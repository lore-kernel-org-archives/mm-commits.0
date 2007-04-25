From: akpm@linux-foundation.org
Subject: - i386-pgd-clone-under-lock-fix.patch removed from -mm tree
Date: Wed, 25 Apr 2007 13:39:52 -0700
Message-ID: <200704252039.l3PKdqsJ012348@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46037 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993143AbXDYUkQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 16:40:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zach@vmware.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     i386 pgd clone under lock fix
has been removed from the -mm tree.  Its filename was
     i386-pgd-clone-under-lock-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386 pgd clone under lock fix
From: Zachary Amsden <zach@vmware.com>

Copying of the pgd range must happen under the pgd_lock.  This got broken by
the paravirt changes in the -mm tree.  Badness can result if you copy the pgd
before being added to the list when splitting or rejoining large pages.

Signed-off-by: Zachary Amsden <zach@vmware.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/mm/pgtable.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN arch/i386/mm/pgtable.c~i386-pgd-clone-under-lock-fix arch/i386/mm/pgtable.c
--- a/arch/i386/mm/pgtable.c~i386-pgd-clone-under-lock-fix
+++ a/arch/i386/mm/pgtable.c
@@ -241,18 +241,16 @@ void pgd_ctor(void *pgd, struct kmem_cac
 	/* !PAE, no pagetable sharing */
 	memset(pgd, 0, USER_PTRS_PER_PGD*sizeof(pgd_t));
 
-	clone_pgd_range((pgd_t *)pgd + USER_PTRS_PER_PGD,
-			swapper_pg_dir + USER_PTRS_PER_PGD,
-			KERNEL_PGD_PTRS);
-
 	spin_lock_irqsave(&pgd_lock, flags);
 
 	/* must happen under lock */
+	clone_pgd_range((pgd_t *)pgd + USER_PTRS_PER_PGD,
+			swapper_pg_dir + USER_PTRS_PER_PGD,
+			KERNEL_PGD_PTRS);
 	paravirt_alloc_pd_clone(__pa(pgd) >> PAGE_SHIFT,
 				__pa(swapper_pg_dir) >> PAGE_SHIFT,
 				USER_PTRS_PER_PGD,
 				KERNEL_PGD_PTRS);
-
 	pgd_list_add(pgd);
 	spin_unlock_irqrestore(&pgd_lock, flags);
 }
_

Patches currently in -mm which might be from zach@vmware.com are

fix-buslogic-to-stop-using-check_region.patch
i386-pte-clear-optimization.patch
i386-pte-xchg-optimization.patch
i386-pte-simplify-ops.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
ignore-stolen-time-in-the-softlockup-watchdog-fix.patch
