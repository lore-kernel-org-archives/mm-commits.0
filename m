From: akpm@linux-foundation.org
Subject: - kexec-i386-setup-kexec-page-table-in-c.patch removed from -mm tree
Date: Wed, 05 Nov 2008 11:26:38 -0800
Message-ID: <200811051926.mA5JQcn5010196@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47348 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752523AbYKET1n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Nov 2008 14:27:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, Ian.Campbell@citrix.com, ebiederm@xmission.com, horms@verge.net.au, magnus.damm@gmail.com, mingo@elte.hu, tglx@linutronix.de, vgoyal@redhat.com, mm-commits@vger.


The patch titled
     kexec/i386: setup kexec page table in C
has been removed from the -mm tree.  Its filename was
     kexec-i386-setup-kexec-page-table-in-c.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kexec/i386: setup kexec page table in C
From: Huang Ying <ying.huang@intel.com>

Transform the kexec page tables setup code from assembler code to C code
in machine_kexec_prepare.  This improves readability and reduces code line
number.

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

 arch/x86/include/asm/kexec.h         |   17 ---
 arch/x86/kernel/machine_kexec_32.c   |   59 ++++++++++--
 arch/x86/kernel/relocate_kernel_32.S |  114 -------------------------
 3 files changed, 49 insertions(+), 141 deletions(-)

diff -puN arch/x86/include/asm/kexec.h~kexec-i386-setup-kexec-page-table-in-c arch/x86/include/asm/kexec.h
--- a/arch/x86/include/asm/kexec.h~kexec-i386-setup-kexec-page-table-in-c
+++ a/arch/x86/include/asm/kexec.h
@@ -5,21 +5,8 @@
 # define PA_CONTROL_PAGE	0
 # define VA_CONTROL_PAGE	1
 # define PA_PGD			2
-# define VA_PGD			3
-# define PA_PTE_0		4
-# define VA_PTE_0		5
-# define PA_PTE_1		6
-# define VA_PTE_1		7
-# define PA_SWAP_PAGE		8
-# ifdef CONFIG_X86_PAE
-#  define PA_PMD_0		9
-#  define VA_PMD_0		10
-#  define PA_PMD_1		11
-#  define VA_PMD_1		12
-#  define PAGES_NR		13
-# else
-#  define PAGES_NR		9
-# endif
+# define PA_SWAP_PAGE		3
+# define PAGES_NR		4
 #else
 # define PA_CONTROL_PAGE	0
 # define VA_CONTROL_PAGE	1
diff -puN arch/x86/kernel/machine_kexec_32.c~kexec-i386-setup-kexec-page-table-in-c arch/x86/kernel/machine_kexec_32.c
--- a/arch/x86/kernel/machine_kexec_32.c~kexec-i386-setup-kexec-page-table-in-c
+++ a/arch/x86/kernel/machine_kexec_32.c
@@ -99,6 +99,45 @@ static int machine_kexec_alloc_page_tabl
 	return 0;
 }
 
+static void machine_kexec_page_table_set_one(
+	pgd_t *pgd, pmd_t *pmd, pte_t *pte,
+	unsigned long vaddr, unsigned long paddr)
+{
+	pud_t *pud;
+
+	pgd += pgd_index(vaddr);
+#ifdef CONFIG_X86_PAE
+	if (!(pgd_val(*pgd) & _PAGE_PRESENT))
+		set_pgd(pgd, __pgd(__pa(pmd) | _PAGE_PRESENT));
+#endif
+	pud = pud_offset(pgd, vaddr);
+	pmd = pmd_offset(pud, vaddr);
+	if (!(pmd_val(*pmd) & _PAGE_PRESENT))
+		set_pmd(pmd, __pmd(__pa(pte) | _PAGE_TABLE));
+	pte = pte_offset_kernel(pmd, vaddr);
+	set_pte(pte, pfn_pte(paddr >> PAGE_SHIFT, PAGE_KERNEL_EXEC));
+}
+
+static void machine_kexec_prepare_page_tables(struct kimage *image)
+{
+	void *control_page;
+	pmd_t *pmd = 0;
+
+	control_page = page_address(image->control_code_page);
+#ifdef CONFIG_X86_PAE
+	pmd = image->arch.pmd0;
+#endif
+	machine_kexec_page_table_set_one(
+		image->arch.pgd, pmd, image->arch.pte0,
+		(unsigned long)control_page, __pa(control_page));
+#ifdef CONFIG_X86_PAE
+	pmd = image->arch.pmd1;
+#endif
+	machine_kexec_page_table_set_one(
+		image->arch.pgd, pmd, image->arch.pte1,
+		__pa(control_page), __pa(control_page));
+}
+
 /*
  * A architecture hook called to validate the
  * proposed image and prepare the control pages
@@ -112,12 +151,19 @@ static int machine_kexec_alloc_page_tabl
  *
  * - Make control page executable.
  * - Allocate page tables
+ * - Setup page tables
  */
 int machine_kexec_prepare(struct kimage *image)
 {
+	int error;
+
 	if (nx_enabled)
 		set_pages_x(image->control_code_page, 1);
-	return machine_kexec_alloc_page_tables(image);
+	error = machine_kexec_alloc_page_tables(image);
+	if (error)
+		return error;
+	machine_kexec_prepare_page_tables(image);
+	return 0;
 }
 
 /*
@@ -176,17 +222,6 @@ void machine_kexec(struct kimage *image)
 	page_list[PA_CONTROL_PAGE] = __pa(control_page);
 	page_list[VA_CONTROL_PAGE] = (unsigned long)control_page;
 	page_list[PA_PGD] = __pa(image->arch.pgd);
-	page_list[VA_PGD] = (unsigned long)image->arch.pgd;
-#ifdef CONFIG_X86_PAE
-	page_list[PA_PMD_0] = __pa(image->arch.pmd0);
-	page_list[VA_PMD_0] = (unsigned long)image->arch.pmd0;
-	page_list[PA_PMD_1] = __pa(image->arch.pmd1);
-	page_list[VA_PMD_1] = (unsigned long)image->arch.pmd1;
-#endif
-	page_list[PA_PTE_0] = __pa(image->arch.pte0);
-	page_list[VA_PTE_0] = (unsigned long)image->arch.pte0;
-	page_list[PA_PTE_1] = __pa(image->arch.pte1);
-	page_list[VA_PTE_1] = (unsigned long)image->arch.pte1;
 
 	if (image->type == KEXEC_TYPE_DEFAULT)
 		page_list[PA_SWAP_PAGE] = (page_to_pfn(image->swap_page)
diff -puN arch/x86/kernel/relocate_kernel_32.S~kexec-i386-setup-kexec-page-table-in-c arch/x86/kernel/relocate_kernel_32.S
--- a/arch/x86/kernel/relocate_kernel_32.S~kexec-i386-setup-kexec-page-table-in-c
+++ a/arch/x86/kernel/relocate_kernel_32.S
@@ -10,15 +10,12 @@
 #include <asm/page.h>
 #include <asm/kexec.h>
 #include <asm/processor-flags.h>
-#include <asm/pgtable.h>
 
 /*
  * Must be relocatable PIC code callable as a C function
  */
 
 #define PTR(x) (x << 2)
-#define PAGE_ATTR (_PAGE_PRESENT | _PAGE_RW | _PAGE_ACCESSED | _PAGE_DIRTY)
-#define PAE_PGD_ATTR (_PAGE_PRESENT)
 
 /* control_page + KEXEC_CONTROL_CODE_MAX_SIZE
  * ~ control_page + PAGE_SIZE are used as data storage and stack for
@@ -59,117 +56,6 @@ relocate_kernel:
 	movl	%cr4, %eax
 	movl	%eax, CR4(%edi)
 
-#ifdef CONFIG_X86_PAE
-	/* map the control page at its virtual address */
-
-	movl	PTR(VA_PGD)(%ebp), %edi
-	movl	PTR(VA_CONTROL_PAGE)(%ebp), %eax
-	andl	$0xc0000000, %eax
-	shrl	$27, %eax
-	addl	%edi, %eax
-
-	movl	PTR(PA_PMD_0)(%ebp), %edx
-	orl	$PAE_PGD_ATTR, %edx
-	movl	%edx, (%eax)
-
-	movl	PTR(VA_PMD_0)(%ebp), %edi
-	movl	PTR(VA_CONTROL_PAGE)(%ebp), %eax
-	andl	$0x3fe00000, %eax
-	shrl	$18, %eax
-	addl	%edi, %eax
-
-	movl	PTR(PA_PTE_0)(%ebp), %edx
-	orl	$PAGE_ATTR, %edx
-	movl	%edx, (%eax)
-
-	movl	PTR(VA_PTE_0)(%ebp), %edi
-	movl	PTR(VA_CONTROL_PAGE)(%ebp), %eax
-	andl	$0x001ff000, %eax
-	shrl	$9, %eax
-	addl	%edi, %eax
-
-	movl	PTR(PA_CONTROL_PAGE)(%ebp), %edx
-	orl	$PAGE_ATTR, %edx
-	movl	%edx, (%eax)
-
-	/* identity map the control page at its physical address */
-
-	movl	PTR(VA_PGD)(%ebp), %edi
-	movl	PTR(PA_CONTROL_PAGE)(%ebp), %eax
-	andl	$0xc0000000, %eax
-	shrl	$27, %eax
-	addl	%edi, %eax
-
-	movl	PTR(PA_PMD_1)(%ebp), %edx
-	orl	$PAE_PGD_ATTR, %edx
-	movl	%edx, (%eax)
-
-	movl	PTR(VA_PMD_1)(%ebp), %edi
-	movl	PTR(PA_CONTROL_PAGE)(%ebp), %eax
-	andl	$0x3fe00000, %eax
-	shrl	$18, %eax
-	addl	%edi, %eax
-
-	movl	PTR(PA_PTE_1)(%ebp), %edx
-	orl	$PAGE_ATTR, %edx
-	movl	%edx, (%eax)
-
-	movl	PTR(VA_PTE_1)(%ebp), %edi
-	movl	PTR(PA_CONTROL_PAGE)(%ebp), %eax
-	andl	$0x001ff000, %eax
-	shrl	$9, %eax
-	addl	%edi, %eax
-
-	movl	PTR(PA_CONTROL_PAGE)(%ebp), %edx
-	orl	$PAGE_ATTR, %edx
-	movl	%edx, (%eax)
-#else
-	/* map the control page at its virtual address */
-
-	movl	PTR(VA_PGD)(%ebp), %edi
-	movl	PTR(VA_CONTROL_PAGE)(%ebp), %eax
-	andl	$0xffc00000, %eax
-	shrl	$20, %eax
-	addl	%edi, %eax
-
-	movl	PTR(PA_PTE_0)(%ebp), %edx
-	orl	$PAGE_ATTR, %edx
-	movl	%edx, (%eax)
-
-	movl	PTR(VA_PTE_0)(%ebp), %edi
-	movl	PTR(VA_CONTROL_PAGE)(%ebp), %eax
-	andl	$0x003ff000, %eax
-	shrl	$10, %eax
-	addl	%edi, %eax
-
-	movl	PTR(PA_CONTROL_PAGE)(%ebp), %edx
-	orl	$PAGE_ATTR, %edx
-	movl	%edx, (%eax)
-
-	/* identity map the control page at its physical address */
-
-	movl	PTR(VA_PGD)(%ebp), %edi
-	movl	PTR(PA_CONTROL_PAGE)(%ebp), %eax
-	andl	$0xffc00000, %eax
-	shrl	$20, %eax
-	addl	%edi, %eax
-
-	movl	PTR(PA_PTE_1)(%ebp), %edx
-	orl	$PAGE_ATTR, %edx
-	movl	%edx, (%eax)
-
-	movl	PTR(VA_PTE_1)(%ebp), %edi
-	movl	PTR(PA_CONTROL_PAGE)(%ebp), %eax
-	andl	$0x003ff000, %eax
-	shrl	$10, %eax
-	addl	%edi, %eax
-
-	movl	PTR(PA_CONTROL_PAGE)(%ebp), %edx
-	orl	$PAGE_ATTR, %edx
-	movl	%edx, (%eax)
-#endif
