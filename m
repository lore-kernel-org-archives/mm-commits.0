Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67EA2749C1
	for <mm-commits@vger.kernel.org>; Mon, 26 Jan 2026 20:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769460865; cv=none; b=Ess5dUoHrdh30ula+Pxn8+advcYWnOONu3WqZHcpBC/0t5i2r1dYnCG3hrEamRI+H0Ni77fMgYrBiSTZMfRTj2vaUgmqfKs6lK3wPjHjc8iszmQo6LD/XareiATENu3ngJe0ez+ENYOT8h43znE3W8GzujLbTX13dOfG3kFbD7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769460865; c=relaxed/simple;
	bh=DoCraDMwAKuq9FARyAxyZqRRGhCEYw/pZfPJ+RAPR4c=;
	h=Date:To:From:Subject:Message-Id; b=Sgy8ltC/eGBGxt5Y+KEwftC7kCcTt+nwYwAXMJuDppEd5oT2gfrsDAYgqQyxcAHyGtLANoTp8A1IbSgU13i9dGlt2TnYA7kGm4/jWCI0sAyEWpTvuYReojAdqwwxBb6Bd60O3VwhU8+HY0dM518DjS0Vz5z0U+3P/PgOdDNLzog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DpuqVlKe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DpuqVlKe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38B1FC116C6;
	Mon, 26 Jan 2026 20:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769460865;
	bh=DoCraDMwAKuq9FARyAxyZqRRGhCEYw/pZfPJ+RAPR4c=;
	h=Date:To:From:Subject:From;
	b=DpuqVlKete+q15v2eC3E8eJv190U613xX4tXGQ7Nzzi3cqMo1MjCVrpYmtJaDbmvX
	 Ba5qCDgloPCvHoXWLxWUYUzMYRE3qkAN0T3k08G6IeaarTD4aKSHowNdvVvItxusFW
	 y3g6/IBhihyb+czeRiHeYFP/pHJKINJHrddsDDMQ=
Date: Mon, 26 Jan 2026 12:54:24 -0800
To: mm-commits@vger.kernel.org,steven.price@arm.com,pabeni@redhat.com,leon@kernel.org,kuba@kernel.org,horms@kernel.org,felix.kuehling@amd.com,edumazet@google.com,davem@davemloft.net,christian.koenig@amd.com,boris.brezillon@collabora.com,aliceryhl@google.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + rdma-umem-dont-abuse-current-group_leader.patch added to mm-nonmm-unstable branch
Message-Id: <20260126205425.38B1FC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: RDMA/umem: don't abuse current->group_leader
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     rdma-umem-dont-abuse-current-group_leader.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rdma-umem-dont-abuse-current-group_leader.patch

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
Subject: RDMA/umem: don't abuse current->group_leader
Date: Sun, 25 Jan 2026 17:07:52 +0100

Cleanup and preparation to simplify the next changes.

Use current->tgid instead of current->group_leader->pid.

Link: https://lkml.kernel.org/r/aXY_2JIhCeGAYC0r@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Leon Romanovsky <leon@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Boris Brezillon <boris.brezillon@collabora.com>
Cc: Christan König <christian.koenig@amd.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Felix Kuehling <felix.kuehling@amd.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>
Cc: Steven Price <steven.price@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/core/umem_odp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/core/umem_odp.c~rdma-umem-dont-abuse-current-group_leader
+++ a/drivers/infiniband/core/umem_odp.c
@@ -149,7 +149,7 @@ struct ib_umem_odp *ib_umem_odp_alloc_im
 	umem->owning_mm = current->mm;
 	umem_odp->page_shift = PAGE_SHIFT;
 
-	umem_odp->tgid = get_task_pid(current->group_leader, PIDTYPE_PID);
+	umem_odp->tgid = get_task_pid(current, PIDTYPE_TGID);
 	ib_init_umem_implicit_odp(umem_odp);
 	return umem_odp;
 }
@@ -258,7 +258,7 @@ struct ib_umem_odp *ib_umem_odp_get(stru
 		umem_odp->page_shift = HPAGE_SHIFT;
 #endif
 
-	umem_odp->tgid = get_task_pid(current->group_leader, PIDTYPE_PID);
+	umem_odp->tgid = get_task_pid(current, PIDTYPE_TGID);
 	ret = ib_init_umem_odp(umem_odp, ops);
 	if (ret)
 		goto err_put_pid;
_

Patches currently in -mm which might be from oleg@redhat.com are

android-binder-dont-abuse-current-group_leader.patch
android-binder-use-same_thread_groupproc-tsk-current-in-binder_mmap.patch
drm-amdgpu-dont-abuse-current-group_leader.patch
drm-amd-kill-the-outdated-only-the-pthreads-threading-model-is-supported-checks.patch
drm-pan-dont-abuse-current-group_leader.patch
rdma-umem-dont-abuse-current-group_leader.patch
netclassid-use-thread_group_leaderp-in-update_classid_task.patch

