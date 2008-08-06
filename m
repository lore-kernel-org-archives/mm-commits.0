From: akpm@linux-foundation.org
Subject: - mm-make-generic-weak-get_user_pages_fast-and-export_gpl-it.patch removed from -mm tree
Date: Wed, 06 Aug 2008 13:57:32 -0700
Message-ID: <200808062057.m76KvW23014778@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56401 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753068AbYHFVRQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2008 17:17:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, benh@kernel.crashing.org, mingo@elte.hu, npiggin@suse.de, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     mm: Make generic weak get_user_pages_fast and EXPORT_GPL it
has been removed from the -mm tree.  Its filename was
     mm-make-generic-weak-get_user_pages_fast-and-export_gpl-it.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: Make generic weak get_user_pages_fast and EXPORT_GPL it
From: Rusty Russell <rusty@rustcorp.com.au>

Out of line get_user_pages_fast fallback implementation, make it a weak
symbol, get rid of CONFIG_HAVE_GET_USER_PAGES_FAST.

Export the symbol to modules so lguest can use it.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig |    3 ---
 arch/x86/Kconfig     |    1 -
 arch/x86/mm/Makefile |    3 +--
 include/linux/mm.h   |   20 --------------------
 mm/Kconfig           |    3 ---
 mm/util.c            |   15 +++++++++++++++
 6 files changed, 16 insertions(+), 29 deletions(-)

diff -puN arch/powerpc/Kconfig~mm-make-generic-weak-get_user_pages_fast-and-export_gpl-it arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~mm-make-generic-weak-get_user_pages_fast-and-export_gpl-it
+++ a/arch/powerpc/Kconfig
@@ -42,9 +42,6 @@ config GENERIC_HARDIRQS
 	bool
 	default y
 
-config HAVE_GET_USER_PAGES_FAST
-	def_bool PPC64
-
 config HAVE_SETUP_PER_CPU_AREA
 	def_bool PPC64
 
diff -puN arch/x86/Kconfig~mm-make-generic-weak-get_user_pages_fast-and-export_gpl-it arch/x86/Kconfig
--- a/arch/x86/Kconfig~mm-make-generic-weak-get_user_pages_fast-and-export_gpl-it
+++ a/arch/x86/Kconfig
@@ -23,7 +23,6 @@ config X86
 	select HAVE_OPROFILE
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_IOREMAP_PROT
-	select HAVE_GET_USER_PAGES_FAST
 	select HAVE_KPROBES
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select HAVE_KRETPROBES
diff -puN arch/x86/mm/Makefile~mm-make-generic-weak-get_user_pages_fast-and-export_gpl-it arch/x86/mm/Makefile
--- a/arch/x86/mm/Makefile~mm-make-generic-weak-get_user_pages_fast-and-export_gpl-it
+++ a/arch/x86/mm/Makefile
@@ -1,7 +1,6 @@
 obj-y	:=  init_$(BITS).o fault.o ioremap.o extable.o pageattr.o mmap.o \
-	    pat.o pgtable.o
+	    pat.o pgtable.o gup.o
 
-obj-$(CONFIG_HAVE_GET_USER_PAGES_FAST) += gup.o
 obj-$(CONFIG_X86_32)		+= pgtable_32.o
 
 obj-$(CONFIG_HUGETLB_PAGE)	+= hugetlbpage.o
diff -puN include/linux/mm.h~mm-make-generic-weak-get_user_pages_fast-and-export_gpl-it include/linux/mm.h
--- a/include/linux/mm.h~mm-make-generic-weak-get_user_pages_fast-and-export_gpl-it
+++ a/include/linux/mm.h
@@ -834,7 +834,6 @@ extern int mprotect_fixup(struct vm_area
 			  struct vm_area_struct **pprev, unsigned long start,
 			  unsigned long end, unsigned long newflags);
 
-#ifdef CONFIG_HAVE_GET_USER_PAGES_FAST
 /*
  * get_user_pages_fast provides equivalent functionality to get_user_pages,
  * operating on current and current->mm (force=0 and doesn't return any vmas).
@@ -848,25 +847,6 @@ extern int mprotect_fixup(struct vm_area
 int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			struct page **pages);
 
-#else
-/*
- * Should probably be moved to asm-generic, and architectures can include it if
- * they don't implement their own get_user_pages_fast.
- */
-#define get_user_pages_fast(start, nr_pages, write, pages)	\
-({								\
-	struct mm_struct *mm = current->mm;			\
-	int ret;						\
-								\
-	down_read(&mm->mmap_sem);				\
-	ret = get_user_pages(current, mm, start, nr_pages,	\
-					write, 0, pages, NULL);	\
-	up_read(&mm->mmap_sem);					\
-								\
-	ret;							\
-})
-#endif
-
 /*
  * A callback you can register to apply pressure to ageable caches.
  *
diff -puN mm/Kconfig~mm-make-generic-weak-get_user_pages_fast-and-export_gpl-it mm/Kconfig
--- a/mm/Kconfig~mm-make-generic-weak-get_user_pages_fast-and-export_gpl-it
+++ a/mm/Kconfig
@@ -77,9 +77,6 @@ config FLAT_NODE_MEM_MAP
 	def_bool y
 	depends on !SPARSEMEM
 
-config HAVE_GET_USER_PAGES_FAST
-	bool
-
 #
 # Both the NUMA code and DISCONTIGMEM use arrays of pg_data_t's
 # to represent different areas of memory.  This variable allows
diff -puN mm/util.c~mm-make-generic-weak-get_user_pages_fast-and-export_gpl-it mm/util.c
--- a/mm/util.c~mm-make-generic-weak-get_user_pages_fast-and-export_gpl-it
+++ a/mm/util.c
@@ -171,3 +171,18 @@ void arch_pick_mmap_layout(struct mm_str
 	mm->unmap_area = arch_unmap_area;
 }
 #endif
+
+int __attribute__((weak)) get_user_pages_fast(unsigned long start,
+				int nr_pages, int write, struct page **pages)
+{
+	struct mm_struct *mm = current->mm;
+	int ret;
+
+	down_read(&mm->mmap_sem);
+	ret = get_user_pages(current, mm, start, nr_pages,
+					write, 0, pages, NULL);
+	up_read(&mm->mmap_sem);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(get_user_pages_fast);
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

linux-next.patch
kernel-call-constructors.patch
kernel-introduce-gcc_version_lower-macro.patch
seq_file-add-function-to-write-binary-data.patch
gcov-add-gcov-profiling-infrastructure.patch
gcov-add-gcov-profiling-infrastructure-revert-link-changes.patch
gcov-architecture-specific-compile-flag-adjustments.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
reiser4.patch

