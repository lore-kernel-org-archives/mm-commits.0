Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9227A7484
	for <mm-commits@vger.kernel.org>; Wed, 10 Jan 2024 05:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mECougsp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E626AC433F1;
	Wed, 10 Jan 2024 05:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704862905;
	bh=JDB1UtMfy0co9mI3XATmvaC9yDMBom6RJ+FBiYA3Xlo=;
	h=Date:To:From:Subject:From;
	b=mECougspecBf2lxclzGs1hIcbLP1WDP2fkDlQJH0YJU9CoU6CJ4pXgP1N0Cc8SjJ2
	 BWMG/DDQpciibIF8O5LbU5jfX5cypLdWO2aSdUA1L9opSu3+OYaWtZ3DRbPLaCS5Kr
	 juR2vg/x0JHW9RQnXhbZvdwOxvlESHCKlmrcRa0s=
Date: Tue, 09 Jan 2024 21:01:44 -0800
To: mm-commits@vger.kernel.org,schwidefsky@de.ibm.com,peterz@infradead.org,mhocko@suse.com,jianfeng.w.wang@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-oom-add-lru_add_drain-in-__oom_reap_task_mm.patch added to mm-unstable branch
Message-Id: <20240110050144.E626AC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, oom: add lru_add_drain() in __oom_reap_task_mm()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-oom-add-lru_add_drain-in-__oom_reap_task_mm.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-oom-add-lru_add_drain-in-__oom_reap_task_mm.patch

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

mm-oom-add-lru_add_drain-in-__oom_reap_task_mm.patch

