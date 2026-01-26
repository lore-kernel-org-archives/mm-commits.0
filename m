Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F9D82D8797
	for <mm-commits@vger.kernel.org>; Mon, 26 Jan 2026 20:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769460860; cv=none; b=jC+H5SGGruaqDcDA07zOexuS5vVFc713GMxud/QSyWMV550aMc5dVKiMKvrQ3vUAS/dlofISdTKFxrbqb97FTsxcnH66PDtFD3FZ/KS5lZX9IeH0ENDhybYdNAtBOtbWUxQ+dOyRZo0TE8RcTqEu2PfjXhyQwfP+C3gG3pw6GVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769460860; c=relaxed/simple;
	bh=CzbEOZb8VwkxKNLRMMjosDFcmvQK0lsf+4LVJeckToA=;
	h=Date:To:From:Subject:Message-Id; b=c00h+FVf7zzBunjDR80F6+rnIZyoFGC5iCxeZKBrmYa9st/KKcv5kiBJio3dNN0la6UgcYU1PkGdAJjTwFRmBxCGRPlutY8WDINFuh/NiTKHLXp7tySZcEmxiW5JUdKXhe+qjj03SpVDN5kdRj80/jDK8qZRVIQM+gaWYM93NHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Gc5UZw5w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Gc5UZw5w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19011C19422;
	Mon, 26 Jan 2026 20:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769460860;
	bh=CzbEOZb8VwkxKNLRMMjosDFcmvQK0lsf+4LVJeckToA=;
	h=Date:To:From:Subject:From;
	b=Gc5UZw5wiZp3CgBXa6HR8qL3md0DycXiaC8InLWLFpo90Bfhh887EGsgaRUnPWg8W
	 OQLYvEyHAJ5A97LZBiBxxxaceZjpua1shH+AK1KoJqfRRBbkIYAwY7q9Z0m6ohJnoP
	 m4+vDY4GjFoLcyg54MO7cL2DjX1+cD5Ow76fZdLo=
Date: Mon, 26 Jan 2026 12:54:19 -0800
To: mm-commits@vger.kernel.org,steven.price@arm.com,pabeni@redhat.com,leon@kernel.org,kuba@kernel.org,horms@kernel.org,felix.kuehling@amd.com,edumazet@google.com,davem@davemloft.net,christian.koenig@amd.com,boris.brezillon@collabora.com,aliceryhl@google.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drm-amd-kill-the-outdated-only-the-pthreads-threading-model-is-supported-checks.patch added to mm-nonmm-unstable branch
Message-Id: <20260126205420.19011C19422@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drm/amd: kill the outdated "Only the pthreads threading model is supported" checks
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     drm-amd-kill-the-outdated-only-the-pthreads-threading-model-is-supported-checks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drm-amd-kill-the-outdated-only-the-pthreads-threading-model-is-supported-checks.patch

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
Subject: drm/amd: kill the outdated "Only the pthreads threading model is supported" checks
Date: Sun, 25 Jan 2026 17:07:36 +0100

Nowadays task->group_leader->mm != task->mm is only possible if a) task is
not a group leader and b) task->group_leader->mm == NULL because
task->group_leader has already exited using sys_exit().

I don't think that drm/amd tries to detect/nack this case.

Link: https://lkml.kernel.org/r/aXY_yLVHd63UlWtm@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Acked-by: Felix Kuehling <felix.kuehling@amd.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Boris Brezillon <boris.brezillon@collabora.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>
Cc: Steven Price <steven.price@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c   |    3 ---
 drivers/gpu/drm/amd/amdkfd/kfd_process.c |   10 ----------
 2 files changed, 13 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c~drm-amd-kill-the-outdated-only-the-pthreads-threading-model-is-supported-checks
+++ a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -2551,9 +2551,6 @@ void amdgpu_vm_set_task_info(struct amdg
 	vm->task_info->task.pid = current->pid;
 	get_task_comm(vm->task_info->task.comm, current);
 
-	if (current->group_leader->mm != current->mm)
-		return;
-
 	vm->task_info->tgid = current->tgid;
 	get_task_comm(vm->task_info->process_name, current->group_leader);
 }
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c~drm-amd-kill-the-outdated-only-the-pthreads-threading-model-is-supported-checks
+++ a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -833,12 +833,6 @@ struct kfd_process *kfd_create_process(s
 	if (!(thread->mm && mmget_not_zero(thread->mm)))
 		return ERR_PTR(-EINVAL);
 
-	/* Only the pthreads threading model is supported. */
-	if (thread->group_leader->mm != thread->mm) {
-		mmput(thread->mm);
-		return ERR_PTR(-EINVAL);
-	}
-
 	/* If the process just called exec(3), it is possible that the
 	 * cleanup of the kfd_process (following the release of the mm
 	 * of the old process image) is still in the cleanup work queue.
@@ -918,10 +912,6 @@ struct kfd_process *kfd_get_process(cons
 	if (!thread->mm)
 		return ERR_PTR(-EINVAL);
 
-	/* Only the pthreads threading model is supported. */
-	if (thread->group_leader->mm != thread->mm)
-		return ERR_PTR(-EINVAL);
-
 	process = find_process(thread, false);
 	if (!process)
 		return ERR_PTR(-EINVAL);
_

Patches currently in -mm which might be from oleg@redhat.com are

android-binder-dont-abuse-current-group_leader.patch
android-binder-use-same_thread_groupproc-tsk-current-in-binder_mmap.patch
drm-amdgpu-dont-abuse-current-group_leader.patch
drm-amd-kill-the-outdated-only-the-pthreads-threading-model-is-supported-checks.patch
drm-pan-dont-abuse-current-group_leader.patch
rdma-umem-dont-abuse-current-group_leader.patch
netclassid-use-thread_group_leaderp-in-update_classid_task.patch

