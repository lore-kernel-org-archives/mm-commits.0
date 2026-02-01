Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89923EBF1D
	for <mm-commits@vger.kernel.org>; Sun,  1 Feb 2026 00:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769905035; cv=none; b=T8LlljgD3QaZGOZjxQ6SshZiJUy1gwMY0PWGN3Zln+0nkuqQ3FPmDFhzDoZuCQGr+uTH6O7CX6uSOsbD3dBl1E/0xyuk003yYHmOWzyT6AGnmwKXERGVO68oSmBp3Eg06xM7uwS0WA/6RDydNbgq5pZd55z4+L0Pa0jAxRedjTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769905035; c=relaxed/simple;
	bh=CIuvN/HIQWbQgt4Igrdz4KUZeDWUAjC7J3ZD65o7Nes=;
	h=Date:To:From:Subject:Message-Id; b=QVXbXbNSQo1C2zxoWtN4svH9VJsPf2HKi7FlG7es3P0cae3eRaB2wRv06Xv62Fjqad+Fx7DGakb5mx0zCsBpw14931F+YsqlZyM5BBw4t8Byr4+BT5c/VggHdTHW5Tr7s1XiHJItcVy7aF2693uusZKiN7MiyTDOiGYSxEKeiQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cWU0zn4P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cWU0zn4P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C38C4CEF1;
	Sun,  1 Feb 2026 00:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769905035;
	bh=CIuvN/HIQWbQgt4Igrdz4KUZeDWUAjC7J3ZD65o7Nes=;
	h=Date:To:From:Subject:From;
	b=cWU0zn4P5X/Ma2dRdEDZBisemYQHvBeF+gCo/BaRWtKQE4eMXNn1ZUmwgiC0ZrkE6
	 APB+S2hxb0/MSd0lU1j+u0tnpIAmFBjFGhWwdmm5tyJjQ/3z1SzOzBEj92SJM5GLQt
	 nR3hUacBBnp07o8W8FgddkHof3bjywJv+KtsUOI0=
Date: Sat, 31 Jan 2026 16:17:15 -0800
To: mm-commits@vger.kernel.org,steven.price@arm.com,pabeni@redhat.com,leon@kernel.org,kuba@kernel.org,horms@kernel.org,felix.kuehling@amd.com,edumazet@google.com,davem@davemloft.net,christian.koenig@amd.com,boris.brezillon@collabora.com,aliceryhl@google.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] drm-amd-kill-the-outdated-only-the-pthreads-threading-model-is-supported-checks.patch removed from -mm tree
Message-Id: <20260201001715.92C38C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drm/amd: kill the outdated "Only the pthreads threading model is supported" checks
has been removed from the -mm tree.  Its filename was
     drm-amd-kill-the-outdated-only-the-pthreads-threading-model-is-supported-checks.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Christan König <christian.koenig@amd.com>
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


