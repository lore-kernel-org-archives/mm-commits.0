From: akpm@linux-foundation.org
Subject: + lguest-the-host-code-lgko-cleanup-allocate-separate-pages-for-switcher-code.patch added to -mm tree
Date: Sun, 11 Mar 2007 01:11:28 -0800
Message-ID: <200703110911.l2B9BTNx008448@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40759 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887AbXCKJLh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 05:11:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, ak@suse.de


The patch titled
     lguest: cleanup: allocate separate pages for switcher code
has been added to the -mm tree.  Its filename is
     lguest-the-host-code-lgko-cleanup-allocate-separate-pages-for-switcher-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lguest: cleanup: allocate separate pages for switcher code
From: Rusty Russell <rusty@rustcorp.com.au>

We don't need physically-contiguous pages for the hypervisor, since we use
map_vm_area anyway.

Two other related cleanups: pass the number of pages to init_pagetables() so
we can remove the constant from the header, and call
populate_hypervisor_pte_page() on each page as we allocate it, rather than as
a separate loop.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/lguest/core.c        |   43 +++++++++++++++++++------------
 arch/i386/lguest/lg.h          |    6 ----
 arch/i386/lguest/page_tables.c |   39 ++++++++++------------------
 3 files changed, 42 insertions(+), 46 deletions(-)

diff -puN arch/i386/lguest/core.c~lguest-the-host-code-lgko-cleanup-allocate-separate-pages-for-switcher-code arch/i386/lguest/core.c
--- a/arch/i386/lguest/core.c~lguest-the-host-code-lgko-cleanup-allocate-separate-pages-for-switcher-code
+++ a/arch/i386/lguest/core.c
@@ -24,17 +24,21 @@ static char __initdata hypervisor_blob[]
 #include "hypervisor-blob.c"
 };
 
-#define MAX_LGUEST_GUESTS						  \
-	(((PAGE_SIZE << HYPERVISOR_PAGE_ORDER) - sizeof(hypervisor_blob)) \
+/* 64k ought to be enough for anybody! */
+#define HYPERVISOR_PAGES (65536 / PAGE_SIZE)
+
+#define MAX_LGUEST_GUESTS						\
+	(((HYPERVISOR_PAGES * PAGE_SIZE) - sizeof(hypervisor_blob))	\
 	 / sizeof(struct lguest_state))
 
 static struct vm_struct *hypervisor_vma;
+/* Pages for hypervisor itself */
+static struct page *hype_page[HYPERVISOR_PAGES];
 static int cpu_had_pge;
 static struct {
 	unsigned long offset;
 	unsigned short segment;
 } lguest_entry __attribute_used__;
-struct page *hype_pages; /* Contiguous pages. */
 struct lguest lguests[MAX_LGUEST_GUESTS];
 DEFINE_MUTEX(lguest_lock);
 
@@ -58,15 +62,19 @@ struct lguest_state *__lguest_states(voi
 
 static __init int map_hypervisor(void)
 {
-	unsigned int i;
-	int err;
-	struct page *pages[HYPERVISOR_PAGES], **pagep = pages;
+	int i, err;
+	struct page **pagep = hype_page;
 
-	hype_pages = alloc_pages(GFP_KERNEL|__GFP_ZERO, HYPERVISOR_PAGE_ORDER);
-	if (!hype_pages)
-		return -ENOMEM;
+	for (i = 0; i < ARRAY_SIZE(hype_page); i++) {
+		unsigned long addr = get_zeroed_page(GFP_KERNEL);
+		if (!addr) {
+			err = -ENOMEM;
+			goto free_some_pages;
+		}
+		hype_page[i] = virt_to_page(addr);
+	}
 
-	hypervisor_vma = __get_vm_area(PAGE_SIZE << HYPERVISOR_PAGE_ORDER,
+	hypervisor_vma = __get_vm_area(ARRAY_SIZE(hype_page) * PAGE_SIZE,
 				       VM_ALLOC, HYPE_ADDR, VMALLOC_END);
 	if (!hypervisor_vma) {
 		err = -ENOMEM;
@@ -74,9 +82,6 @@ static __init int map_hypervisor(void)
 		goto free_pages;
 	}
 
-	for (i = 0; i < HYPERVISOR_PAGES; i++)
-		pages[i] = hype_pages + i;
-
 	err = map_vm_area(hypervisor_vma, PAGE_KERNEL, &pagep);
 	if (err) {
 		printk("lguest: map_vm_area failed: %i\n", err);
@@ -100,14 +105,20 @@ static __init int map_hypervisor(void)
 free_vma:
 	vunmap(hypervisor_vma->addr);
 free_pages:
-	__free_pages(hype_pages, HYPERVISOR_PAGE_ORDER);
+	i = ARRAY_SIZE(hype_page);
+free_some_pages:
+	for (--i; i >= 0; i--)
+		__free_pages(hype_page[i], 0);
 	return err;
 }
 
 static __exit void unmap_hypervisor(void)
 {
+	unsigned int i;
+
 	vunmap(hypervisor_vma->addr);
-	__free_pages(hype_pages, HYPERVISOR_PAGE_ORDER);
+	for (i = 0; i < ARRAY_SIZE(hype_page); i++)
+		__free_pages(hype_page[i], 0);
 }
 
 /* IN/OUT insns: enough to get us past boot-time probing. */
@@ -390,7 +401,7 @@ static int __init init(void)
 	if (err)
 		return err;
 
-	err = init_pagetables(hype_pages);
+	err = init_pagetables(hype_page, HYPERVISOR_PAGES);
 	if (err) {
 		unmap_hypervisor();
 		return err;
diff -puN arch/i386/lguest/lg.h~lguest-the-host-code-lgko-cleanup-allocate-separate-pages-for-switcher-code arch/i386/lguest/lg.h
--- a/arch/i386/lguest/lg.h~lguest-the-host-code-lgko-cleanup-allocate-separate-pages-for-switcher-code
+++ a/arch/i386/lguest/lg.h
@@ -2,9 +2,6 @@
 #define _LGUEST_H
 
 #include <asm/desc.h>
-/* 64k ought to be enough for anybody! */
-#define HYPERVISOR_PAGE_ORDER (16 - PAGE_SHIFT)
-#define HYPERVISOR_PAGES (1 << HYPERVISOR_PAGE_ORDER)
 
 #define GDT_ENTRY_LGUEST_CS	10
 #define GDT_ENTRY_LGUEST_DS	11
@@ -43,7 +40,7 @@ struct lguest_regs
 };
 
 __exit void free_pagetables(void);
-__init int init_pagetables(struct page *hype_pages);
+__init int init_pagetables(struct page **hype_page, int pages);
 
 /* Full 4G segment descriptors, suitable for CS and DS. */
 #define FULL_EXEC_SEGMENT ((struct desc_struct){0x0000ffff, 0x00cf9b00})
@@ -122,7 +119,6 @@ struct lguest
 	struct host_trap interrupt[LGUEST_IRQS];
 };
 
-extern struct page *hype_pages; /* Contiguous pages. */
 extern struct lguest lguests[];
 extern struct mutex lguest_lock;
 
diff -puN arch/i386/lguest/page_tables.c~lguest-the-host-code-lgko-cleanup-allocate-separate-pages-for-switcher-code arch/i386/lguest/page_tables.c
--- a/arch/i386/lguest/page_tables.c~lguest-the-host-code-lgko-cleanup-allocate-separate-pages-for-switcher-code
+++ a/arch/i386/lguest/page_tables.c
@@ -328,43 +328,32 @@ static void free_hypervisor_pte_pages(vo
 		free_page((long)hypervisor_pte_page(i));
 }
 
-static __init int alloc_hypervisor_pte_pages(void)
-{
-	int i;
-
-	for_each_possible_cpu(i) {
-		hypervisor_pte_page(i) = (u32 *)get_zeroed_page(GFP_KERNEL);
-		if (!hypervisor_pte_page(i)) {
-			free_hypervisor_pte_pages();
-			return -ENOMEM;
-		}
-	}
-	return 0;
-}
-
-static __init void populate_hypervisor_pte_page(int cpu)
+static __init void populate_hypervisor_pte_page(int cpu,
+						struct page *hype_page[],
+						int pages)
 {
 	int i;
 	u32 *pte = hypervisor_pte_page(cpu);
 
-	for (i = 0; i < HYPERVISOR_PAGES; i++) {
+	for (i = 0; i < pages; i++) {
 		/* First entry set dynamically in map_trap_page */
-		pte[i+1] = ((page_to_pfn(&hype_pages[i]) << PAGE_SHIFT)
+		pte[i+1] = ((page_to_pfn(hype_page[i]) << PAGE_SHIFT)
 			    | _PAGE_KERNEL_EXEC);
 	}
 }
 
-__init int init_pagetables(struct page hype_pages[])
+__init int init_pagetables(struct page **hype_page, int pages)
 {
-	int ret;
 	unsigned int i;
 
-	ret = alloc_hypervisor_pte_pages();
-	if (ret)
-		return ret;
-
-	for_each_possible_cpu(i)
-		populate_hypervisor_pte_page(i);
+	for_each_possible_cpu(i) {
+		hypervisor_pte_page(i) = (u32 *)get_zeroed_page(GFP_KERNEL);
+		if (!hypervisor_pte_page(i)) {
+			free_hypervisor_pte_pages();
+			return -ENOMEM;
+		}
+		populate_hypervisor_pte_page(i, hype_page, pages);
+	}
 	return 0;
 }
 
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

futex-restartable-futex_wait.patch
i386-vdso_prelink-warning-fix.patch
cleanup-initialize-esp0-properly-all-the-time.patch
lguest-preparation-export_symbol_gpl-5-functions.patch
lguest-preparation-expose-futex-infrastructure.patch
lguest-kconfig-and-headers.patch
lguest-the-host-code-lgko.patch
lguest-the-host-code-lgko-cleanup-allocate-separate-pages-for-switcher-code.patch
lguest-guest-code.patch
lguest-makefile.patch
lguest-trivial-guest-network-driver.patch
lguest-trivial-guest-console-driver.patch
lguest-trivial-guest-block-driver.patch
lguest-trivial-guest-block-driver-lguest-block-device-speedup.patch
lguest-documentatation-and-example-launcher.patch
lguest-documentatation-and-example-launcher-bridging-support-in-example-code.patch
lguest-cleanup-clean-up-regs-save-restore.patch
lguest-documentation-fixes.patch
lguest-pin-stack-page-optimization.patch
lguest-use-read-only-pages-rather-than-segments-to-protect-high-mapped-switcher.patch
lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages.patch
lguest-dont-crash-host-on-nmi.patch
module-use-krealloc.patch
extend-print_symbol-capability.patch
array_size-check-for-type.patch
____call_usermodehelper-dont-flush_signals.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
add-ability-to-keep-track-of-callers-of-symbol_getput-tidy.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
