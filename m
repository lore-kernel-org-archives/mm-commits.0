Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98FA82749C1
	for <mm-commits@vger.kernel.org>; Mon, 26 Jan 2026 20:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769460855; cv=none; b=tT8B6vBdO3v1tBLxZvqYExnEme3UZGiVHSG5wDLQPEHuZ71yD22uQWoa8QiO95/Q4jPZLBohieOn79u0rRwuYviUPynWkdFyCQ8DtYyjYJ7L9+ysJucxngOt5Sc9il9RO/sXW3ZSGL6Zv06JRE5WvqL/kCr/+NPB8gJZgr/51kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769460855; c=relaxed/simple;
	bh=3QB36v+GKScEVPX9P2ZXcOZ0tX3LA+wBq6CvlxnRESg=;
	h=Date:To:From:Subject:Message-Id; b=V9OAtBnDEvVSda2FMn23Y9iDkdEzHs7u8YHIraVNWN8a/f+KfYxBPvEsJNNA3WCv9CsOfr3eiwrUfao9Z50HsUkYEinUcvrQj801k3KQRkiiYbVi5W24nszjMbWYnxNGvu47OhqLig/BGpmCU8GqX92XaVjQuKOM+bs66tMudmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NjLjJ4xM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NjLjJ4xM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C7CDC116C6;
	Mon, 26 Jan 2026 20:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769460855;
	bh=3QB36v+GKScEVPX9P2ZXcOZ0tX3LA+wBq6CvlxnRESg=;
	h=Date:To:From:Subject:From;
	b=NjLjJ4xMJ4Lc0qYQ3FFpbWHAMmoqke2WgX0jFRb/Gl/SYlMEWvjQBeKBhEA5xOwE1
	 cc8mMsELcLspQ+4SvLDxw5lkQAxC+pJX0Enavkx+n1KnOE2SitiWbi+ndnmqY+rLC/
	 cmegYPCilLZattC1SHoiCCu8OLxMcN/a/z7Wznh0=
Date: Mon, 26 Jan 2026 12:54:14 -0800
To: mm-commits@vger.kernel.org,steven.price@arm.com,pabeni@redhat.com,leon@kernel.org,kuba@kernel.org,horms@kernel.org,felix.kuehling@amd.com,edumazet@google.com,davem@davemloft.net,christian.koenig@amd.com,boris.brezillon@collabora.com,aliceryhl@google.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + android-binder-use-same_thread_groupproc-tsk-current-in-binder_mmap.patch added to mm-nonmm-unstable branch
Message-Id: <20260126205415.5C7CDC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: android/binder: use same_thread_group(proc->tsk, current) in binder_mmap()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     android-binder-use-same_thread_groupproc-tsk-current-in-binder_mmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/android-binder-use-same_thread_groupproc-tsk-current-in-binder_mmap.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: android/binder: use same_thread_group(proc->tsk, current) in binder_mmap()
Date: Sun, 25 Jan 2026 17:07:20 +0100

With or without this change the checked condition can be falsely true if
proc->tsk execs, but this is fine: binder_alloc_mmap_handler() checks
vma->vm_mm == alloc->mm.

Link: https://lkml.kernel.org/r/aXY_uPYyUg4rwNOg@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Cc: Boris Brezillon <boris.brezillon@collabora.com>
Cc: Christan König <christian.koenig@amd.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Felix Kuehling <felix.kuehling@amd.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>
Cc: Steven Price <steven.price@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/android/binder.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/android/binder.c~android-binder-use-same_thread_groupproc-tsk-current-in-binder_mmap
+++ a/drivers/android/binder.c
@@ -6015,7 +6015,7 @@ static int binder_mmap(struct file *filp
 {
 	struct binder_proc *proc = filp->private_data;
 
-	if (proc->tsk != current->group_leader)
+	if (!same_thread_group(proc->tsk, current))
 		return -EINVAL;
 
 	binder_debug(BINDER_DEBUG_OPEN_CLOSE,
_

Patches currently in -mm which might be from oleg@redhat.com are

android-binder-dont-abuse-current-group_leader.patch
android-binder-use-same_thread_groupproc-tsk-current-in-binder_mmap.patch
drm-amdgpu-dont-abuse-current-group_leader.patch
drm-amd-kill-the-outdated-only-the-pthreads-threading-model-is-supported-checks.patch
drm-pan-dont-abuse-current-group_leader.patch
rdma-umem-dont-abuse-current-group_leader.patch
netclassid-use-thread_group_leaderp-in-update_classid_task.patch

