From: akpm@linux-foundation.org
Subject: + i386-make-arch-i386-mm-pgtablecpgd_cdtor-static.patch added to -mm tree
Date: Mon, 04 Jun 2007 14:25:26 -0700
Message-ID: <200706042125.l54LPQBe019540@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46772 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761830AbXFDVZ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jun 2007 17:25:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de


The patch titled
     i386: make arch/i386/mm/pgtable.c:pgd_{c,d}tor() static
has been added to the -mm tree.  Its filename is
     i386-make-arch-i386-mm-pgtablecpgd_cdtor-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
git-acpi.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
drivers-mtd-maps-nettelc-possible-cleanups.patch
git-battery.patch
unexport-pci_proc_attach_device.patch
git-scsi-misc.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-wd33c93c-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
scsi-lpfc-lpfc_initc-remove-unused-variable.patch
git-unionfs.patch
git-wireless.patch
git-ipwireless_cs.patch
fix-x86_64-mm-xen-add-xen-virtual-block-device-driver.patch
make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
arch-i386-kernel-i8253c-should-include-asm-timerh.patch
make-arch-i386-kernel-io_apicctimer_irq_works-static-again.patch
i386-remove-support-for-the-rise-cpu.patch
i386-make-arch-i386-mm-pgtablecpgd_cdtor-static.patch
maps2-add-proc-kpagemap-interface.patch
lumpy-reclaim-v4.patch
more-scheduled-oss-driver-removal.patch
ext2-reservations.patch
revoke-core-code.patch
oss-trident-fix-locking-around-write_voice_regs.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
