Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60A285634
	for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 18:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711476507; cv=none; b=IVB0Q2ok6QQiMjtdtrrkvQO1ZpMsPAMnbQoaEk5pvItDAyQ3jWQUa3m/iZYQVG3aSlTTBnSnkKIqLPK9paf56mAMFaT4KA7bkcKx5gxNENMZQygmTuNgUbFWVC6C2MJOh940KijBVabIpqLBQS68waztstsQMut+8xvYWdPVNM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711476507; c=relaxed/simple;
	bh=sRO/aRjfObchWJ0g+VL84/fsc1tyiBV+hVa3T8AF5CU=;
	h=Date:To:From:Subject:Message-Id; b=NpQeRRsbjmcXntcFCgDTdVK7aJLhfW387vvKx5yU6ZjF2W7vk7wnet3rYgRS3ybMQL/37bid0ozuDAGn9Br8eMuaT3+mg4BocYHTEvG7yRuNXQCnlU0l0hO4rzR+QSjDjonppQHTGEqCqy6b4ZmShUrW4ixPJb4yX493jTZkwzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=scYLRZxX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="scYLRZxX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E5FC433F1;
	Tue, 26 Mar 2024 18:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711476506;
	bh=sRO/aRjfObchWJ0g+VL84/fsc1tyiBV+hVa3T8AF5CU=;
	h=Date:To:From:Subject:From;
	b=scYLRZxXOcNvKhSCr59nvT9v3sjHSo3/OgTUQQCFLdIvLcVsZJuGJkseU4YH2UaAe
	 uEodj7XG3bt4kFZ6WcfKYzgK/oot0hB1hfRp+YZBjKIfDKtn3/cFVXkQkYgIyijvsM
	 dSPW9vYd/F0JqKahl7lVvZiunGyO68kEHaQGM6BQ=
Date: Tue, 26 Mar 2024 11:08:25 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,rppt@kernel.org,peterx@redhat.com,ngeoffray@google.com,kaleshsingh@google.com,jannh@google.com,hdanton@sina.com,david@redhat.com,bgeffon@google.com,axelrasmussen@google.com,aarcange@redhat.com,lokeshgidra@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] userfaultfd-fix-deadlock-warning-when-locking-src-and-dst-vmas.patch removed from -mm tree
Message-Id: <20240326180826.71E5FC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: userfaultfd: fix deadlock warning when locking src and dst VMAs
has been removed from the -mm tree.  Its filename was
     userfaultfd-fix-deadlock-warning-when-locking-src-and-dst-vmas.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lokesh Gidra <lokeshgidra@google.com>
Subject: userfaultfd: fix deadlock warning when locking src and dst VMAs
Date: Thu, 21 Mar 2024 16:58:18 -0700

Use down_read_nested() to avoid the warning.

Link: https://lkml.kernel.org/r/20240321235818.125118-1-lokeshgidra@google.com
Fixes: 867a43a34ff8 ("userfaultfd: use per-vma locks in userfaultfd operations")
Reported-by: syzbot+49056626fe41e01f2ba7@syzkaller.appspotmail.com
Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Jann Horn <jannh@google.com> [Bug #2]
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Nicolas Geoffray <ngeoffray@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/userfaultfd.c~userfaultfd-fix-deadlock-warning-when-locking-src-and-dst-vmas
+++ a/mm/userfaultfd.c
@@ -1444,7 +1444,8 @@ static int uffd_move_lock(struct mm_stru
 		 */
 		down_read(&(*dst_vmap)->vm_lock->lock);
 		if (*dst_vmap != *src_vmap)
-			down_read(&(*src_vmap)->vm_lock->lock);
+			down_read_nested(&(*src_vmap)->vm_lock->lock,
+					 SINGLE_DEPTH_NESTING);
 	}
 	mmap_read_unlock(mm);
 	return err;
_

Patches currently in -mm which might be from lokeshgidra@google.com are


