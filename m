From: akpm@linux-foundation.org
Subject: - i386-make-arch-i386-mm-pgtablecpgd_cdtor-static.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:09:44 -0700
Message-ID: <200707192009.l6JK9iS4020605@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57115 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756462AbXGSUPR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     i386: make arch/i386/mm/pgtable.c:pgd_{c,d}tor() static
has been removed from the -mm tree.  Its filename was
     i386-make-arch-i386-mm-pgtablecpgd_cdtor-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: make arch/i386/mm/pgtable.c:pgd_{c,d}tor() static
From: Adrian Bunk <bunk@stusta.de>

pgd_{c,d}tor() can now become static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/mm/pgtable.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/i386/mm/pgtable.c~i386-make-arch-i386-mm-pgtablecpgd_cdtor-static arch/i386/mm/pgtable.c
--- a/arch/i386/mm/pgtable.c~i386-make-arch-i386-mm-pgtablecpgd_cdtor-static
+++ a/arch/i386/mm/pgtable.c
@@ -235,7 +235,7 @@ static inline void pgd_list_del(pgd_t *p
 
 #if (PTRS_PER_PMD == 1)
 /* Non-PAE pgd constructor */
-void pgd_ctor(void *pgd)
+static void pgd_ctor(void *pgd)
 {
 	unsigned long flags;
 
@@ -257,7 +257,7 @@ void pgd_ctor(void *pgd)
 }
 #else  /* PTRS_PER_PMD > 1 */
 /* PAE pgd constructor */
-void pgd_ctor(void *pgd)
+static void pgd_ctor(void *pgd)
 {
 	/* PAE, kernel PMD may be shared */
 
@@ -276,7 +276,7 @@ void pgd_ctor(void *pgd)
 }
 #endif	/* PTRS_PER_PMD */
 
-void pgd_dtor(void *pgd)
+static void pgd_dtor(void *pgd)
 {
 	unsigned long flags; /* can be called from interrupt context */
 
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
fix-x86_64-mm-xen-xen-event-channels.patch
git-acpi.patch
cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default-fix.patch
drivers-acpi-sbsc-remove-dead-code.patch
git-alsa.patch
git-hwmon.patch
git-kbuild.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mtd.patch
git-scsi-misc.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
git-unionfs.patch
git-ipwireless_cs.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
maps2-add-proc-kpagemap-interface.patch
fs-reiserfs-cleanups.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
