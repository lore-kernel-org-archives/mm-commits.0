From: akpm@linux-foundation.org
Subject: [to-be-updated]
 alpha-extable-use-generic-search-and-sort-routines.patch removed from -mm
 tree
Date: Fri, 19 Feb 2016 10:58:23 -0800
Message-ID: <56c765cf.MV2BA3+nUxsuAlEj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34631 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422838AbcBSS6X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Feb 2016 13:58:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ard.biesheuvel@linaro.org, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     Subject: alpha/extable: use generic search and sort routines
has been removed from the -mm tree.  Its filename was
     alpha-extable-use-generic-search-and-sort-routines.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: alpha/extable: use generic search and sort routines

Replace the arch specific versions of search_extable() and sort_extable()
with calls to the generic ones, which now support relative exception
tables as well.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Acked-by: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/uaccess.h |   10 ++-
 arch/alpha/mm/Makefile           |    2 
 arch/alpha/mm/extable.c          |   92 -----------------------------
 3 files changed, 9 insertions(+), 95 deletions(-)

diff -puN arch/alpha/include/asm/uaccess.h~alpha-extable-use-generic-search-and-sort-routines arch/alpha/include/asm/uaccess.h
--- a/arch/alpha/include/asm/uaccess.h~alpha-extable-use-generic-search-and-sort-routines
+++ a/arch/alpha/include/asm/uaccess.h
@@ -483,7 +483,13 @@ struct exception_table_entry
 	(pc) + (_fixup)->fixup.bits.nextinsn;			\
 })
 
-#define ARCH_HAS_SORT_EXTABLE
-#define ARCH_HAS_SEARCH_EXTABLE
+#define ARCH_HAS_RELATIVE_EXTABLE
+
+#define swap_ex_entry_fixup(a, b, tmp, delta)			\
+	do {							\
+		(a)->fixup.unit = (b)->fixup.unit;		\
+		(b)->fixup.unit = (tmp).fixup.unit;		\
+	} while (0)
+
 
 #endif /* __ALPHA_UACCESS_H */
diff -puN arch/alpha/mm/Makefile~alpha-extable-use-generic-search-and-sort-routines arch/alpha/mm/Makefile
--- a/arch/alpha/mm/Makefile~alpha-extable-use-generic-search-and-sort-routines
+++ a/arch/alpha/mm/Makefile
@@ -4,6 +4,6 @@
 
 ccflags-y := -Werror
 
-obj-y	:= init.o fault.o extable.o
+obj-y	:= init.o fault.o
 
 obj-$(CONFIG_DISCONTIGMEM) += numa.o
diff -puN arch/alpha/mm/extable.c~alpha-extable-use-generic-search-and-sort-routines /dev/null
--- a/arch/alpha/mm/extable.c
+++ /dev/null
@@ -1,92 +0,0 @@
-/*
- * linux/arch/alpha/mm/extable.c
- */
-
-#include <linux/module.h>
-#include <linux/sort.h>
-#include <asm/uaccess.h>
-
-static inline unsigned long ex_to_addr(const struct exception_table_entry *x)
-{
-	return (unsigned long)&x->insn + x->insn;
-}
-
-static void swap_ex(void *a, void *b, int size)
-{
-	struct exception_table_entry *ex_a = a, *ex_b = b;
-	unsigned long addr_a = ex_to_addr(ex_a), addr_b = ex_to_addr(ex_b);
-	unsigned int t = ex_a->fixup.unit;
-
-	ex_a->fixup.unit = ex_b->fixup.unit;
-	ex_b->fixup.unit = t;
-	ex_a->insn = (int)(addr_b - (unsigned long)&ex_a->insn);
-	ex_b->insn = (int)(addr_a - (unsigned long)&ex_b->insn);
-}
-
-/*
- * The exception table needs to be sorted so that the binary
- * search that we use to find entries in it works properly.
- * This is used both for the kernel exception table and for
- * the exception tables of modules that get loaded.
- */
-static int cmp_ex(const void *a, const void *b)
-{
-	const struct exception_table_entry *x = a, *y = b;
-
-	/* avoid overflow */
-	if (ex_to_addr(x) > ex_to_addr(y))
-		return 1;
-	if (ex_to_addr(x) < ex_to_addr(y))
-		return -1;
-	return 0;
-}
-
-void sort_extable(struct exception_table_entry *start,
-		  struct exception_table_entry *finish)
-{
-	sort(start, finish - start, sizeof(struct exception_table_entry),
-	     cmp_ex, swap_ex);
-}
-
-#ifdef CONFIG_MODULES
-/*
- * Any entry referring to the module init will be at the beginning or
- * the end.
- */
-void trim_init_extable(struct module *m)
-{
-	/*trim the beginning*/
-	while (m->num_exentries &&
-	       within_module_init(ex_to_addr(&m->extable[0]), m)) {
-		m->extable++;
-		m->num_exentries--;
-	}
-	/*trim the end*/
-	while (m->num_exentries &&
-	       within_module_init(ex_to_addr(&m->extable[m->num_exentries-1]),
-				  m))
-		m->num_exentries--;
-}
-#endif /* CONFIG_MODULES */
-
-const struct exception_table_entry *
-search_extable(const struct exception_table_entry *first,
-	       const struct exception_table_entry *last,
-	       unsigned long value)
-{
-        while (first <= last) {
-		const struct exception_table_entry *mid;
-		unsigned long mid_value;
-
-		mid = (last - first) / 2 + first;
-		mid_value = ex_to_addr(mid);
-                if (mid_value == value)
-                        return mid;
-                else if (mid_value < value)
-                        first = mid+1;
-                else
-                        last = mid-1;
-        }
