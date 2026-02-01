Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCF43EBF1D
	for <mm-commits@vger.kernel.org>; Sun,  1 Feb 2026 00:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769905034; cv=none; b=aF/riZ0TzWO7PBqSiXhFWEvq2AeCs5ympHrAzLZVdxcxf5ehTq1/dHbfCP7L+Wx5qRKLlb72nWOL0G5LtjtMXFr1TJEe7OHmYIVUYInIHteOJWTQ4ex6N+EYkE/k5x0zLWB9SRXo3JgGlp5xp3a1t4eEMTDITY2NEThJ1CJZmhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769905034; c=relaxed/simple;
	bh=mKAM0pxV/us/7R401N34CPOBV2Idv0pKyOPsXUvuHNI=;
	h=Date:To:From:Subject:Message-Id; b=UlfMSebjDQSHvKYTsvqoS8xtu07/4VJHPkc4MI7ZblqO6m7hlL4Go/RZ332F7TsFsB2ETVxCm7Npv/55I+xiLXdcn6a6U6G1iD+96bmq8vxKamDz4DO0q1NWuuaLVcKlkG/eM293rZPHeh8xb4nfOogDWVdcipJMpy/4W9SJVtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zbGG9l2K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zbGG9l2K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 543D9C4CEF1;
	Sun,  1 Feb 2026 00:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769905034;
	bh=mKAM0pxV/us/7R401N34CPOBV2Idv0pKyOPsXUvuHNI=;
	h=Date:To:From:Subject:From;
	b=zbGG9l2Kb0w3x+H3LXrnH7JfbvCh1Klph/P/9zmKXgsrNsg6uK+SJQPDFfi7onF0o
	 ghQ4U28TlJPI8LtwjWBciLMenKLUo/oCy8Q9tZmhmgTJYLy5hjWgAeHE5TotVDyAE7
	 y6KW0PYetwmCqzwJA5rgRXYp5GE9wZheKFuk43qg=
Date: Sat, 31 Jan 2026 16:17:13 -0800
To: mm-commits@vger.kernel.org,steven.price@arm.com,pabeni@redhat.com,leon@kernel.org,kuba@kernel.org,horms@kernel.org,felix.kuehling@amd.com,edumazet@google.com,davem@davemloft.net,christian.koenig@amd.com,boris.brezillon@collabora.com,aliceryhl@google.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] drm-amdgpu-dont-abuse-current-group_leader.patch removed from -mm tree
Message-Id: <20260201001714.543D9C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drm/amdgpu: don't abuse current->group_leader
has been removed from the -mm tree.  Its filename was
     drm-amdgpu-dont-abuse-current-group_leader.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


