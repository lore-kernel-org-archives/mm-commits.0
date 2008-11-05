From: akpm@linux-foundation.org
Subject: - kexec-i386-allocate-page-table-pages-dynamically.patch removed from -mm tree
Date: Wed, 05 Nov 2008 11:26:35 -0800
Message-ID: <200811051926.mA5JQZKV010187@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51966 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751999AbYKET1M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Nov 2008 14:27:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, Ian.Campbell@citrix.com, ebiederm@xmission.com, horms@verge.net.au, magnus.damm@gmail.com, mingo@elte.hu, tglx@linutronix.de, vgoyal@redhat.com, mm-commits@vger.


The patch titled
     kexec/i386: allocate page table pages dynamically
has been removed from the -mm tree.  Its filename was
     kexec-i386-allocate-page-table-pages-dynamically.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kexec/i386: allocate page table pages dynamically
From: Huang Ying <ying.huang@intel.com>

Add an architecture specific struct kimage_arch into struct kimage.  The
pointers to page table pages used by kexec are added to struct
kimage_arch.  The page tables pages are dynamically allocated in
machine_kexec_prepare instead of statically from BSS segment.  This will
save up to 20k memory when kexec image is not loaded.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Reviewed-by: Simon Horman <horms@verge.net.au>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@redhat.com> 
Cc: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/kexec.h       |   14 +++++
 arch/x86/kernel/machine_kexec_32.c |   69 ++++++++++++++++++---------
 include/linux/kexec.h              |    4 +
 3 files changed, 65 insertions(+), 22 deletions(-)

diff -puN arch/x86/include/asm/kexec.h~kexec-i386-allocate-page-table-pages-dynamically arch/x86/include/asm/kexec.h
--- a/arch/x86/include/asm/kexec.h~kexec-i386-allocate-page-table-pages-dynamically
+++ a/arch/x86/include/asm/kexec.h
@@ -170,6 +170,20 @@ relocate_kernel(unsigned long indirectio
 		unsigned long start_address) ATTRIB_NORET;
 #endif
 
+#ifdef CONFIG_X86_32
+#define ARCH_HAS_KIMAGE_ARCH
+
+struct kimage_arch {
+	pgd_t *pgd;
+#ifdef CONFIG_X86_PAE
+	pmd_t *pmd0;
+	pmd_t *pmd1;
+#endif
+	pte_t *pte0;
+	pte_t *pte1;
+};
+#endif
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_X86_KEXEC_H */
diff -puN arch/x86/kernel/machine_kexec_32.c~kexec-i386-allocate-page-table-pages-dynamically arch/x86/kernel/machine_kexec_32.c
--- a/arch/x86/kernel/machine_kexec_32.c~kexec-i386-allocate-page-table-pages-dynamically
+++ a/arch/x86/kernel/machine_kexec_32.c
@@ -13,6 +13,7 @@
 #include <linux/numa.h>
 #include <linux/ftrace.h>
 #include <linux/suspend.h>
+#include <linux/gfp.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -25,15 +26,6 @@
 #include <asm/system.h>
 #include <asm/cacheflush.h>
 
-#define PAGE_ALIGNED __attribute__ ((__aligned__(PAGE_SIZE)))
-static u32 kexec_pgd[1024] PAGE_ALIGNED;
-#ifdef CONFIG_X86_PAE
-static u32 kexec_pmd0[1024] PAGE_ALIGNED;
-static u32 kexec_pmd1[1024] PAGE_ALIGNED;
-#endif
-static u32 kexec_pte0[1024] PAGE_ALIGNED;
-static u32 kexec_pte1[1024] PAGE_ALIGNED;
-
 static void set_idt(void *newidt, __u16 limit)
 {
 	struct desc_ptr curidt;
@@ -76,6 +68,37 @@ static void load_segments(void)
 #undef __STR
 }
 
+static void machine_kexec_free_page_tables(struct kimage *image)
+{
+	free_page((unsigned long)image->arch.pgd);
+#ifdef CONFIG_X86_PAE
+	free_page((unsigned long)image->arch.pmd0);
+	free_page((unsigned long)image->arch.pmd1);
+#endif
+	free_page((unsigned long)image->arch.pte0);
+	free_page((unsigned long)image->arch.pte1);
+}
+
+static int machine_kexec_alloc_page_tables(struct kimage *image)
+{
+	image->arch.pgd = (pgd_t *)get_zeroed_page(GFP_KERNEL);
+#ifdef CONFIG_X86_PAE
+	image->arch.pmd0 = (pmd_t *)get_zeroed_page(GFP_KERNEL);
+	image->arch.pmd1 = (pmd_t *)get_zeroed_page(GFP_KERNEL);
+#endif
+	image->arch.pte0 = (pte_t *)get_zeroed_page(GFP_KERNEL);
+	image->arch.pte1 = (pte_t *)get_zeroed_page(GFP_KERNEL);
+	if (!image->arch.pgd ||
+#ifdef CONFIG_X86_PAE
+	    !image->arch.pmd0 || !image->arch.pmd1 ||
+#endif
+	    !image->arch.pte0 || !image->arch.pte1) {
+		machine_kexec_free_page_tables(image);
+		return -ENOMEM;
+	}
+	return 0;
+}
+
 /*
  * A architecture hook called to validate the
  * proposed image and prepare the control pages
@@ -87,13 +110,14 @@ static void load_segments(void)
  * reboot code buffer to allow us to avoid allocations
  * later.
  *
- * Make control page executable.
+ * - Make control page executable.
+ * - Allocate page tables
  */
 int machine_kexec_prepare(struct kimage *image)
 {
 	if (nx_enabled)
 		set_pages_x(image->control_code_page, 1);
-	return 0;
+	return machine_kexec_alloc_page_tables(image);
 }
 
 /*
@@ -104,6 +128,7 @@ void machine_kexec_cleanup(struct kimage
 {
 	if (nx_enabled)
 		set_pages_nx(image->control_code_page, 1);
+	machine_kexec_free_page_tables(image);
 }
 
 /*
@@ -150,18 +175,18 @@ void machine_kexec(struct kimage *image)
 	relocate_kernel_ptr = control_page;
 	page_list[PA_CONTROL_PAGE] = __pa(control_page);
 	page_list[VA_CONTROL_PAGE] = (unsigned long)control_page;
-	page_list[PA_PGD] = __pa(kexec_pgd);
-	page_list[VA_PGD] = (unsigned long)kexec_pgd;
+	page_list[PA_PGD] = __pa(image->arch.pgd);
+	page_list[VA_PGD] = (unsigned long)image->arch.pgd;
 #ifdef CONFIG_X86_PAE
-	page_list[PA_PMD_0] = __pa(kexec_pmd0);
-	page_list[VA_PMD_0] = (unsigned long)kexec_pmd0;
-	page_list[PA_PMD_1] = __pa(kexec_pmd1);
-	page_list[VA_PMD_1] = (unsigned long)kexec_pmd1;
-#endif
-	page_list[PA_PTE_0] = __pa(kexec_pte0);
-	page_list[VA_PTE_0] = (unsigned long)kexec_pte0;
-	page_list[PA_PTE_1] = __pa(kexec_pte1);
-	page_list[VA_PTE_1] = (unsigned long)kexec_pte1;
+	page_list[PA_PMD_0] = __pa(image->arch.pmd0);
+	page_list[VA_PMD_0] = (unsigned long)image->arch.pmd0;
+	page_list[PA_PMD_1] = __pa(image->arch.pmd1);
+	page_list[VA_PMD_1] = (unsigned long)image->arch.pmd1;
+#endif
+	page_list[PA_PTE_0] = __pa(image->arch.pte0);
+	page_list[VA_PTE_0] = (unsigned long)image->arch.pte0;
+	page_list[PA_PTE_1] = __pa(image->arch.pte1);
+	page_list[VA_PTE_1] = (unsigned long)image->arch.pte1;
 
 	if (image->type == KEXEC_TYPE_DEFAULT)
 		page_list[PA_SWAP_PAGE] = (page_to_pfn(image->swap_page)
diff -puN include/linux/kexec.h~kexec-i386-allocate-page-table-pages-dynamically include/linux/kexec.h
--- a/include/linux/kexec.h~kexec-i386-allocate-page-table-pages-dynamically
+++ a/include/linux/kexec.h
@@ -100,6 +100,10 @@ struct kimage {
 #define KEXEC_TYPE_DEFAULT 0
 #define KEXEC_TYPE_CRASH   1
 	unsigned int preserve_context : 1;
+
+#ifdef ARCH_HAS_KIMAGE_ARCH
+	struct kimage_arch arch;
+#endif
 };
 
 
_

Patches currently in -mm which might be from ying.huang@intel.com are

linux-next.patch
atomic_t-unify-all-arch-definitions.patch

