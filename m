From: akpm@linux-foundation.org
Subject: [merged] x86-extable-use-generic-search-and-sort-routines.patch
 removed from -mm tree
Date: Wed, 23 Mar 2016 10:43:04 -0700
Message-ID: <56f2d5a8.1QdyDSN6iSH5p/6+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59430 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755928AbcCWRnF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:43:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ard.biesheuvel@linaro.org, hpa@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: x86/extable: use generic search and sort routines
has been removed from the -mm tree.  Its filename was
     x86-extable-use-generic-search-and-sort-routines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: x86/extable: use generic search and sort routines

Replace the arch specific versions of search_extable() and sort_extable()
with calls to the generic ones, which now support relative exception
tables as well.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Acked-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/uaccess.h |    5 -
 arch/x86/mm/extable.c          |  108 -------------------------------
 2 files changed, 2 insertions(+), 111 deletions(-)

diff -puN arch/x86/include/asm/uaccess.h~x86-extable-use-generic-search-and-sort-routines arch/x86/include/asm/uaccess.h
--- a/arch/x86/include/asm/uaccess.h~x86-extable-use-generic-search-and-sort-routines
+++ a/arch/x86/include/asm/uaccess.h
@@ -105,9 +105,8 @@ static inline bool __chk_range_not_ok(un
 struct exception_table_entry {
 	int insn, fixup, handler;
 };
-/* This is not the generic standard exception_table_entry format */
-#define ARCH_HAS_SORT_EXTABLE
-#define ARCH_HAS_SEARCH_EXTABLE
+
+#define ARCH_HAS_RELATIVE_EXTABLE
 
 extern int fixup_exception(struct pt_regs *regs, int trapnr);
 extern bool ex_has_fault_handler(unsigned long ip);
diff -puN arch/x86/mm/extable.c~x86-extable-use-generic-search-and-sort-routines arch/x86/mm/extable.c
--- a/arch/x86/mm/extable.c~x86-extable-use-generic-search-and-sort-routines
+++ a/arch/x86/mm/extable.c
@@ -1,17 +1,10 @@
 #include <linux/module.h>
-#include <linux/spinlock.h>
-#include <linux/sort.h>
 #include <asm/uaccess.h>
 
 typedef bool (*ex_handler_t)(const struct exception_table_entry *,
 			    struct pt_regs *, int);
 
 static inline unsigned long
-ex_insn_addr(const struct exception_table_entry *x)
-{
-	return (unsigned long)&x->insn + x->insn;
-}
-static inline unsigned long
 ex_fixup_addr(const struct exception_table_entry *x)
 {
 	return (unsigned long)&x->fixup + x->fixup;
@@ -110,104 +103,3 @@ int __init early_fixup_exception(unsigne
 	*ip = new_ip;
 	return 1;
 }
-
-/*
- * Search one exception table for an entry corresponding to the
- * given instruction address, and return the address of the entry,
- * or NULL if none is found.
- * We use a binary search, and thus we assume that the table is
- * already sorted.
- */
-const struct exception_table_entry *
-search_extable(const struct exception_table_entry *first,
-	       const struct exception_table_entry *last,
-	       unsigned long value)
-{
-	while (first <= last) {
-		const struct exception_table_entry *mid;
-		unsigned long addr;
-
-		mid = ((last - first) >> 1) + first;
-		addr = ex_insn_addr(mid);
-		if (addr < value)
-			first = mid + 1;
-		else if (addr > value)
-			last = mid - 1;
-		else
-			return mid;
-        }
-        return NULL;
-}
-
-/*
- * The exception table needs to be sorted so that the binary
- * search that we use to find entries in it works properly.
- * This is used both for the kernel exception table and for
- * the exception tables of modules that get loaded.
- *
- */
-static int cmp_ex(const void *a, const void *b)
-{
-	const struct exception_table_entry *x = a, *y = b;
-
-	/*
-	 * This value will always end up fittin in an int, because on
-	 * both i386 and x86-64 the kernel symbol-reachable address
-	 * space is < 2 GiB.
-	 *
-	 * This compare is only valid after normalization.
-	 */
-	return x->insn - y->insn;
-}
-
-void sort_extable(struct exception_table_entry *start,
-		  struct exception_table_entry *finish)
-{
-	struct exception_table_entry *p;
-	int i;
-
-	/* Convert all entries to being relative to the start of the section */
-	i = 0;
-	for (p = start; p < finish; p++) {
-		p->insn += i;
-		i += 4;
-		p->fixup += i;
-		i += 4;
-		p->handler += i;
-		i += 4;
-	}
-
-	sort(start, finish - start, sizeof(struct exception_table_entry),
-	     cmp_ex, NULL);
-
-	/* Denormalize all entries */
-	i = 0;
-	for (p = start; p < finish; p++) {
-		p->insn -= i;
-		i += 4;
-		p->fixup -= i;
-		i += 4;
-		p->handler -= i;
-		i += 4;
-	}
-}
