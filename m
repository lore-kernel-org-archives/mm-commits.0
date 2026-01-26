Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F071F2D879A
	for <mm-commits@vger.kernel.org>; Mon, 26 Jan 2026 20:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769460858; cv=none; b=FwYYswBNbX6D3+Kktb5170bN+hGF0GHWYgCvUJPwCOuXKd3p85pdpnmQ6yBT2j45BMpz1m0i3lNVzL+Q7rhvSMK1khdThi8Lu3iwsVwc0BEHLLydaBBxK6QxXe3NynxQev/o+BhdDUjix9PNIKw2Ef7EeY53yuBCezQ/UUryjhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769460858; c=relaxed/simple;
	bh=XRmtmAlieqzR0SRf0Thf3fFmCMKDxH9POWrzqHp7o9E=;
	h=Date:To:From:Subject:Message-Id; b=CCe5jjscjie2Eni2tv8d6weS1FodOtDEfnuGyFOxLp5vSJ41UO5qQeLBIU4fSTZrhQaLut3/pQWurk+OnGhravGL/6wrT9YaBXGErZhluQJyqeHmu+TFkobwgNv74y0D6Lszp/Amv3FcA/XWqTtZcy+i0hSL6SdX1Op1LEHXIyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P5GAw/oL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P5GAw/oL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77502C19422;
	Mon, 26 Jan 2026 20:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769460857;
	bh=XRmtmAlieqzR0SRf0Thf3fFmCMKDxH9POWrzqHp7o9E=;
	h=Date:To:From:Subject:From;
	b=P5GAw/oLlpCzn/Oshvy9oeDEBLEHBjLYOzJycyOyl8Qj7KJETy//SQEvLgmOBQ9WK
	 REwBKzuzpltOMjd0BYsbcq6EUhKHVll16Nqk4zjskmugNQKNvUqNbzWGMksvN9WWP8
	 afM0UsJtl6M/enRU0g6ycEJ3IjUsFyonp2yICgLU=
Date: Mon, 26 Jan 2026 12:54:16 -0800
To: mm-commits@vger.kernel.org,steven.price@arm.com,pabeni@redhat.com,leon@kernel.org,kuba@kernel.org,horms@kernel.org,felix.kuehling@amd.com,edumazet@google.com,davem@davemloft.net,christian.koenig@amd.com,boris.brezillon@collabora.com,aliceryhl@google.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drm-amdgpu-dont-abuse-current-group_leader.patch added to mm-nonmm-unstable branch
Message-Id: <20260126205417.77502C19422@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drm/amdgpu: don't abuse current->group_leader
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     drm-amdgpu-dont-abuse-current-group_leader.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drm-amdgpu-dont-abuse-current-group_leader.patch

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
Subject: drm/amdgpu: don't abuse current->group_leader
Date: Sun, 25 Jan 2026 17:07:28 +0100

Cleanup and preparation to simplify the next changes.

- Use current->tgid instead of current->group_leader->pid

- Use get_task_pid(current, PIDTYPE_TGID) instead of
  get_task_pid(current->group_leader, PIDTYPE_PID)

Link: https://lkml.kernel.org/r/aXY_wKewzV5lCa5I@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Felix Kuehling <felix.kuehling@amd.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Boris Brezillon <boris.brezillon@collabora.com>
Cc: Christan König <christian.koenig@amd.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>
Cc: Steven Price <steven.price@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c |    2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c           |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c~drm-amdgpu-dont-abuse-current-group_leader
+++ a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1421,7 +1421,7 @@ static int init_kfd_vm(struct amdgpu_vm
 			goto create_evict_fence_fail;
 		}
 
-		info->pid = get_task_pid(current->group_leader, PIDTYPE_PID);
+		info->pid = get_task_pid(current, PIDTYPE_TGID);
 		INIT_DELAYED_WORK(&info->restore_userptr_work,
 				  amdgpu_amdkfd_restore_userptr_worker);
 
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c~drm-amdgpu-dont-abuse-current-group_leader
+++ a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -2554,7 +2554,7 @@ void amdgpu_vm_set_task_info(struct amdg
 	if (current->group_leader->mm != current->mm)
 		return;
 
-	vm->task_info->tgid = current->group_leader->pid;
+	vm->task_info->tgid = current->tgid;
 	get_task_comm(vm->task_info->process_name, current->group_leader);
 }
 
_

Patches currently in -mm which might be from oleg@redhat.com are

android-binder-dont-abuse-current-group_leader.patch
android-binder-use-same_thread_groupproc-tsk-current-in-binder_mmap.patch
drm-amdgpu-dont-abuse-current-group_leader.patch
drm-amd-kill-the-outdated-only-the-pthreads-threading-model-is-supported-checks.patch
drm-pan-dont-abuse-current-group_leader.patch
rdma-umem-dont-abuse-current-group_leader.patch
netclassid-use-thread_group_leaderp-in-update_classid_task.patch

