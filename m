From: akpm@linux-foundation.org
Subject: [merged] mm-__tlb_remove_page-checks-correct-batch.patch removed from -mm tree
Date: Mon, 11 Jul 2011 11:42:56 -0700
Message-ID: <201107111842.p6BIgRcQ025483@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42371 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755766Ab1GKTmL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jul 2011 15:42:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shaohua.li@intel.com, a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     mm: __tlb_remove_page() check the correct batch
has been removed from the -mm tree.  Its filename was
     mm-__tlb_remove_page-checks-correct-batch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: __tlb_remove_page() check the correct batch
From: Shaohua Li <shaohua.li@intel.com>

__tlb_remove_page() switches to a new batch page, but still checks space
in the old batch.  This check always fails, and causes a forced tlb flush.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/memory.c~mm-__tlb_remove_page-checks-correct-batch mm/memory.c
--- a/mm/memory.c~mm-__tlb_remove_page-checks-correct-batch
+++ a/mm/memory.c
@@ -305,6 +305,7 @@ int __tlb_remove_page(struct mmu_gather 
 	if (batch->nr == batch->max) {
 		if (!tlb_next_batch(tlb))
 			return 0;
+		batch = tlb->active;
 	}
 	VM_BUG_ON(batch->nr > batch->max);
 
_

Patches currently in -mm which might be from shaohua.li@intel.com are

origin.patch
linux-next.patch
acpi-add-missing-_osi-strings-resend.patch
tmpfs-simplify-prealloc_page.patch
intel_idle-fix-api-misuse.patch
intel_idle-disable-auto_demotion-for-hotplugged-cpus.patch
memcg-export-memory-cgroups-swappiness-with-mem_cgroup_swappiness.patch

