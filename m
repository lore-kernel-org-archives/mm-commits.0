Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33A058208
	for <mm-commits@vger.kernel.org>; Thu, 11 Jan 2024 21:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x1VkIGyp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52135C433F1;
	Thu, 11 Jan 2024 21:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705010061;
	bh=hPqEB5QR2aObx0pGh69scBS8ii64TLH+r4qLgrODhdw=;
	h=Date:To:From:Subject:From;
	b=x1VkIGypfkp3TTmaj7fgcs/2oquJf5ATQW8dsZjmRcBKpim5UYykAjC9MCRNLEUqk
	 QCTcNAC8Ay1b2GRzeU24GuE+cHpfppj8qzNo0EH0dBdEeVkP9z07LyfB4fX1s3HgN8
	 jFhzLVD5LL2f0ibxAFJWSnjTJqyqpeInVSRcJTms=
Date: Thu, 11 Jan 2024 13:54:20 -0800
To: mm-commits@vger.kernel.org,schwidefsky@de.ibm.com,peterz@infradead.org,mhocko@suse.com,jianfeng.w.wang@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-oom-add-lru_add_drain-in-__oom_reap_task_mm.patch removed from -mm tree
Message-Id: <20240111215421.52135C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, oom: add lru_add_drain() in __oom_reap_task_mm()
has been removed from the -mm tree.  Its filename was
     mm-oom-add-lru_add_drain-in-__oom_reap_task_mm.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Jianfeng Wang <jianfeng.w.wang@oracle.com>
Subject: mm, oom: add lru_add_drain() in __oom_reap_task_mm()
Date: Tue, 9 Jan 2024 01:15:11 -0800

The oom_reaper tries to reclaim additional memory owned by the oom
victim. In __oom_reap_task_mm(), it uses mmu_gather for batched page
free.

After oom_reaper was added, the mmu_gather CONFIG_MMU_GATHER_NO_GATHER
feature was introduced in commit 952a31c9e6fa ("asm-generic/tlb: Introduce
CONFIG_HAVE_MMU_GATHER_NO_GATHER=y").  This is an option to skip batched
page freeing.  If set, tlb_batch_pages_flush(), which is responsible for
calling lru_add_drain(), is skipped during tlb_finish_mmu().  Without
this, pages could still be held by per-cpu fbatches rather than being
freed.

This fix adds lru_add_drain() prior to mmu_gather. This makes the code
consistent with other cases where mmu_gather is used for freeing pages.

Link: https://lkml.kernel.org/r/20240109091511.8299-1-jianfeng.w.wang@oracle.com
Signed-off-by: Jianfeng Wang <jianfeng.w.wang@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/oom_kill.c~mm-oom-add-lru_add_drain-in-__oom_reap_task_mm
+++ a/mm/oom_kill.c
@@ -538,6 +538,7 @@ static bool __oom_reap_task_mm(struct mm
 			struct mmu_notifier_range range;
 			struct mmu_gather tlb;
 
+			lru_add_drain();
 			mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0,
 						mm, vma->vm_start,
 						vma->vm_end);
_

Patches currently in -mm which might be from jianfeng.w.wang@oracle.com are


