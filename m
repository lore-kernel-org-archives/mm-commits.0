Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1C87FBA2
	for <mm-commits@vger.kernel.org>; Sat, 29 Nov 2025 18:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764441722; cv=none; b=gxHJ9ttcB8Crwyn4IeKFmrW1FBlrQuWFugAcJG5ZM+iRxPulQFZ08EunsaKOJ3b8ZHDkV0x+/wR6W8sFd9fXYtZj4DoynhK+xArdHEu4fIJ+zDoYSDDIvqmAIBdKPVIq3MhWr1sawtppKus3Y6todjyiLLg6LS3dA3FmmQxFvLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764441722; c=relaxed/simple;
	bh=C0yTX8hDkxXNLEgmvgfE6WOcsBU+ibXXdPgHp7Zh17k=;
	h=Date:To:From:Subject:Message-Id; b=AOeCjf/OWDRZekL0URWN85gcoxu4jAush/NG7NScva4qlHgkny+KBaD9Fn4IrKnJnWbWSd0Eiob8hR488eGJi5V9jAZfPpozh8mOuaBCE9ddly5Z7Bs5oO/MD6vQCVnt6ddNpcPYCwER24wVsTCkRTiaoEAwO/VXjH/j57ZfZaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PO3DcSbD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PO3DcSbD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71F1C4CEF7;
	Sat, 29 Nov 2025 18:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764441721;
	bh=C0yTX8hDkxXNLEgmvgfE6WOcsBU+ibXXdPgHp7Zh17k=;
	h=Date:To:From:Subject:From;
	b=PO3DcSbD392iuVFCdEpGptafwr6OdKsCz3ezE+lafj8rK1jH5Za1dDzzSEtu1uHJQ
	 wwhBvvnQn4giv7ftK98dOPIQJNxRUClD48a5C9dJw5xdIAgYCw/aa169uIVr5EYMaL
	 esUQymZEimOYyb+WwEMQ6YxEaftpA0jUp+ribPts=
Date: Sat, 29 Nov 2025 10:42:01 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fix-vma_start_write_killable-signal-handling.patch removed from -mm tree
Message-Id: <20251129184201.B71F1C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix vma_start_write_killable() signal handling
has been removed from the -mm tree.  Its filename was
     mm-fix-vma_start_write_killable-signal-handling.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: fix vma_start_write_killable() signal handling
Date: Fri, 28 Nov 2025 04:00:58 +0000

If we get a signal, we need to restore the vm_refcnt.  We don't think that
the refcount can actually be decremented to zero here as it requires the
VMA to be detached, and the vma_mark_detached() uses TASK_UNINTERRUPTIBLE.
However, that's a bit subtle, so handle it as if the refcount was zero at
the start of this function.

Link: https://lkml.kernel.org/r/20251128040100.3022561-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Reported-by: syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com
Fixes: 2197bb60f890 ("mm: add vma_start_write_killable()")
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap_lock.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/mmap_lock.c~mm-fix-vma_start_write_killable-signal-handling
+++ a/mm/mmap_lock.c
@@ -74,6 +74,14 @@ static inline int __vma_enter_locked(str
 		   refcount_read(&vma->vm_refcnt) == tgt_refcnt,
 		   state);
 	if (err) {
+		if (refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm_refcnt)) {
+			/*
+			 * The wait failed, but the last reader went away
+			 * as well.  Tell the caller the VMA is detached.
+			 */
+			WARN_ON_ONCE(!detaching);
+			err = 0;
+		}
 		rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
 		return err;
 	}
_

Patches currently in -mm which might be from willy@infradead.org are

idr-fix-idr_alloc-returning-an-id-out-of-range.patch

