From: akpm@linux-foundation.org
Subject: [merged] x86-mm-get-aslr-work-for-hugetlb-mappings.patch removed
 from -mm tree
Date: Wed, 27 Nov 2013 12:26:27 -0800
Message-ID: <52965573.FLAiZi9jekVfyOOD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51429 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758199Ab3K0U02 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Nov 2013 15:26:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, willy@linux.intel.com, tglx@linutronix.de, n-horiguchi@ah.jp.nec.com, mingo@redhat.com, hpa@zytor.com, dave.hansen@intel.com, kirill.shutemov@linux.intel.com

Subject: [merged] x86-mm-get-aslr-work-for-hugetlb-mappings.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,dave.hansen@intel.com,hpa@zytor.com,mingo@redhat.com,n-horiguchi@ah.jp.nec.com,tglx@linutronix.de,willy@linux.intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 27 Nov 2013 12:26:27 -0800


The patch titled
     Subject: x86, mm: get ASLR work for hugetlb mappings
has been removed from the -mm tree.  Its filename was
     x86-mm-get-aslr-work-for-hugetlb-mappings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: x86, mm: get ASLR work for hugetlb mappings

Matthew noticed that hugetlb doesn't participate in ASLR on x86-64.  The
reason is genereic hugetlb_get_unmapped_area() which is used on x86-64. 
It doesn't support randomization and use bottom-up unmapped area lookup,
instead of usual top-down on x86-64.

x86 has arch-specific hugetlb_get_unmapped_area(), but it's used only on
x86-32.

Let's use arch-specific hugetlb_get_unmapped_area() on x86-64 too.  It
fixes the issue and make hugetlb use top-down unmapped area lookup.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/page.h    |    1 +
 arch/x86/include/asm/page_32.h |    4 ----
 arch/x86/mm/hugetlbpage.c      |    9 +++------
 3 files changed, 4 insertions(+), 10 deletions(-)

diff -puN arch/x86/include/asm/page.h~x86-mm-get-aslr-work-for-hugetlb-mappings arch/x86/include/asm/page.h
--- a/arch/x86/include/asm/page.h~x86-mm-get-aslr-work-for-hugetlb-mappings
+++ a/arch/x86/include/asm/page.h
@@ -71,6 +71,7 @@ extern bool __virt_addr_valid(unsigned l
 #include <asm-generic/getorder.h>
 
 #define __HAVE_ARCH_GATE_AREA 1
+#define HAVE_ARCH_HUGETLB_UNMAPPED_AREA
 
 #endif	/* __KERNEL__ */
 #endif /* _ASM_X86_PAGE_H */
diff -puN arch/x86/include/asm/page_32.h~x86-mm-get-aslr-work-for-hugetlb-mappings arch/x86/include/asm/page_32.h
--- a/arch/x86/include/asm/page_32.h~x86-mm-get-aslr-work-for-hugetlb-mappings
+++ a/arch/x86/include/asm/page_32.h
@@ -5,10 +5,6 @@
 
 #ifndef __ASSEMBLY__
 
-#ifdef CONFIG_HUGETLB_PAGE
-#define HAVE_ARCH_HUGETLB_UNMAPPED_AREA
-#endif
-
 #define __phys_addr_nodebug(x)	((x) - PAGE_OFFSET)
 #ifdef CONFIG_DEBUG_VIRTUAL
 extern unsigned long __phys_addr(unsigned long);
diff -puN arch/x86/mm/hugetlbpage.c~x86-mm-get-aslr-work-for-hugetlb-mappings arch/x86/mm/hugetlbpage.c
--- a/arch/x86/mm/hugetlbpage.c~x86-mm-get-aslr-work-for-hugetlb-mappings
+++ a/arch/x86/mm/hugetlbpage.c
@@ -87,9 +87,7 @@ int pmd_huge_support(void)
 }
 #endif
 
-/* x86_64 also uses this file */
-
-#ifdef HAVE_ARCH_HUGETLB_UNMAPPED_AREA
+#ifdef CONFIG_HUGETLB_PAGE
 static unsigned long hugetlb_get_unmapped_area_bottomup(struct file *file,
 		unsigned long addr, unsigned long len,
 		unsigned long pgoff, unsigned long flags)
@@ -99,7 +97,7 @@ static unsigned long hugetlb_get_unmappe
 
 	info.flags = 0;
 	info.length = len;
-	info.low_limit = TASK_UNMAPPED_BASE;
+	info.low_limit = current->mm->mmap_legacy_base;
 	info.high_limit = TASK_SIZE;
 	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
 	info.align_offset = 0;
@@ -172,8 +170,7 @@ hugetlb_get_unmapped_area(struct file *f
 		return hugetlb_get_unmapped_area_topdown(file, addr, len,
 				pgoff, flags);
 }
