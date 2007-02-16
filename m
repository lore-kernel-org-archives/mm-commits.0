From: akpm@linux-foundation.org
Subject: + xen-paravirt-allow-paravirt-backend-to-select-pgd-allocation-alignment.patch added to -mm tree
Date: Thu, 15 Feb 2007 23:00:14 -0800
Message-ID: <200702160700.l1G70E5u022625@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55182 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423370AbXBPHBJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 02:01:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, ak@suse.de, chrisw@sous-sol.org, jeremy@xensource.com, rusty@rustcorp.com.au, zach@vmware.com


The patch titled
     Xen-paravirt: allow paravirt backend to select PGD allocation alignment
has been added to the -mm tree.  Its filename is
     xen-paravirt-allow-paravirt-backend-to-select-pgd-allocation-alignment.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Xen-paravirt: allow paravirt backend to select PGD allocation alignment
From: Jeremy Fitzhardinge <jeremy@goop.org>

Xen requires pgds to be page-aligned, so make this a parameter which can be
set in the paravirt_ops structure.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Zachary Amsden <zach@vmware.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/paravirt.c |    1 +
 arch/i386/mm/init.c         |    2 +-
 include/asm-i386/paravirt.h |    5 ++++-
 include/asm-i386/pgtable.h  |    6 ++++++
 4 files changed, 12 insertions(+), 2 deletions(-)

diff -puN arch/i386/kernel/paravirt.c~xen-paravirt-allow-paravirt-backend-to-select-pgd-allocation-alignment arch/i386/kernel/paravirt.c
--- a/arch/i386/kernel/paravirt.c~xen-paravirt-allow-paravirt-backend-to-select-pgd-allocation-alignment
+++ a/arch/i386/kernel/paravirt.c
@@ -605,6 +605,7 @@ struct paravirt_ops paravirt_ops = {
 	.paravirt_enabled = 0,
 	.kernel_rpl = 0,
 	.shared_kernel_pmd = 1,	/* Only used when CONFIG_X86_PAE is set */
+	.pgd_alignment = sizeof(pgd_t) * PTRS_PER_PGD,
 
  	.patch = native_patch,
 	.banner = default_banner,
diff -puN arch/i386/mm/init.c~xen-paravirt-allow-paravirt-backend-to-select-pgd-allocation-alignment arch/i386/mm/init.c
--- a/arch/i386/mm/init.c~xen-paravirt-allow-paravirt-backend-to-select-pgd-allocation-alignment
+++ a/arch/i386/mm/init.c
@@ -729,7 +729,7 @@ void __init pgtable_cache_init(void)
 	}
 	pgd_cache = kmem_cache_create("pgd",
 				      PTRS_PER_PGD*sizeof(pgd_t),
-				      PTRS_PER_PGD*sizeof(pgd_t),
+				      PGD_ALIGNMENT,
 				      0, NULL, NULL);
 	if (!pgd_cache)
 		panic("pgtable_cache_init(): Cannot create pgd cache");
diff -puN include/asm-i386/paravirt.h~xen-paravirt-allow-paravirt-backend-to-select-pgd-allocation-alignment include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h~xen-paravirt-allow-paravirt-backend-to-select-pgd-allocation-alignment
+++ a/include/asm-i386/paravirt.h
@@ -33,9 +33,12 @@ struct tss_struct;
 struct mm_struct;
 struct paravirt_ops
 {
+ 	int paravirt_enabled;
 	unsigned int kernel_rpl;
+
 	int shared_kernel_pmd;
- 	int paravirt_enabled;
+	int pgd_alignment;
+
 	const char *name;
 
 	/*
diff -puN include/asm-i386/pgtable.h~xen-paravirt-allow-paravirt-backend-to-select-pgd-allocation-alignment include/asm-i386/pgtable.h
--- a/include/asm-i386/pgtable.h~xen-paravirt-allow-paravirt-backend-to-select-pgd-allocation-alignment
+++ a/include/asm-i386/pgtable.h
@@ -273,6 +273,12 @@ static inline void vmalloc_sync_all(void
 #define pte_update_defer(mm, addr, ptep)	do { } while (0)
 #endif
 
+#ifdef CONFIG_PARAVIRT
+#define PGD_ALIGNMENT	(paravirt_ops.pgd_alignment)
+#else
+#define PGD_ALIGNMENT	(sizeof(pgd_t) * PTRS_PER_PGD)
+#endif
+
 /*
  * We only update the dirty/accessed state if we set
  * the dirty bit by hand in the kernel, since the hardware
_

Patches currently in -mm which might be from jeremy@goop.org are

i386-probe_roms-cleanup.patch
no-need-to-use-traditional-for-processing-asm-in-i386-kernel.patch
xen-paravirt-fix-typo-in-sync_constant_test_bits-name.patch
xen-paravirt-ignore-vgacon-if-hardware-not-present.patch
xen-paravirt-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries.patch
xen-paravirt-paravirt_ops-hooks-to-set-up-initial-pagetable.patch
xen-paravirt-paravirt_ops-allocate-a-fixmap-slot.patch
xen-paravirt-remove-ctor-for-pgd-cache.patch
xen-paravirt-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
xen-paravirt-allow-paravirt-backend-to-select-pgd-allocation-alignment.patch
xen-paravirt-add-hooks-to-intercept-mm-creation-and-destruction.patch
xen-paravirt-add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
xen-paravirt-allocate-and-free-vmalloc-areas.patch
xen-paravirt-add-nosegneg-capability-to-the-vsyscall-page-notes.patch
xen-paravirt-add-xen-config-options-and-disable-unsupported-config-options.patch
xen-paravirt-add-xen-interface-header-files.patch
xen-paravirt-core-xen-implementation.patch
xen-paravirt-add-the-xen-virtual-console-driver.patch
xen-paravirt-add-xen-grant-table-support.patch
xen-paravirt-add-the-xenbus-sysfs-and-virtual-device-hotplug-driver.patch
xen-paravirt-add-xen-virtual-block-device-driver.patch
xen-paravirt-add-the-xen-virtual-network-device-driver.patch
uninline-jiffiesh-functions.patch
