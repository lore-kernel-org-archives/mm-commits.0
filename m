Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7411D289367
	for <mm-commits@vger.kernel.org>; Fri, 28 Nov 2025 18:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764355301; cv=none; b=S+/bEWl6lyJ1aOHtvBkBmaiHC6+P+SFZ+Dpe9zyENHEjvZUfrgqjeuWT25/hXYShodhWQdozwBPiNoplv8YvPeSepZTVPQ7Zp+4JCwiDqkvF8gjZjWTgeQ+FMsJby5hBU91+V6tvjwdgdTUJkyFp8++7vumlvEPcO6HAos0GgWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764355301; c=relaxed/simple;
	bh=2FeEVaUxOsibaBsYHcrRvbP+q2xUnsqcI9wZYvLoO6Q=;
	h=Date:To:From:Subject:Message-Id; b=Cw3M7tNYRjRDmf4TkWxyQ8IvT98rbytob1+KY/Y8p2WXLmCH7OeZmV3Tbn8ed00BcL6HGQ6dHA3uprDv/tJeMER+1/iIfbF95FnCzPylqJyTS1dlzO9KaZHQgeGeS+qq2wNc8pUJW2ue+DcYOXGWX4GRrGhUKP6rtCo5BrM3RI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HOlwxach; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HOlwxach"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E217CC4CEF1;
	Fri, 28 Nov 2025 18:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764355301;
	bh=2FeEVaUxOsibaBsYHcrRvbP+q2xUnsqcI9wZYvLoO6Q=;
	h=Date:To:From:Subject:From;
	b=HOlwxachpWGLdv2xom3QPULpowBxLSaP6pGtgYkAdZuDvgcJErzc7ugKOxGzbMVhY
	 2M0Am2hj4PY4Ez6XdL/TjDeVrZ7kFXD18+Pddf630GO5CZ/hxCSOdhrR6/2d33fw6O
	 Dl6CrAV1rgXsl8w0/s3YtRHVo0Zs0bpy3nHPyyE0=
Date: Fri, 28 Nov 2025 10:41:40 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-vma_start_write_killable-signal-handling.patch added to mm-unstable branch
Message-Id: <20251128184140.E217CC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix vma_start_write_killable() signal handling
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-vma_start_write_killable-signal-handling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-vma_start_write_killable-signal-handling.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-fix-vma_start_write_killable-signal-handling.patch

