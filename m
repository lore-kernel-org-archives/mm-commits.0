From: akpm@linux-foundation.org
Subject: + x86-extable-use-generic-search-and-sort-routines.patch added to -mm tree
Date: Wed, 27 Jan 2016 11:32:14 -0800
Message-ID: <56a91b3e.dCaHuzW7JO62bWlc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57698 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934074AbcA0TcP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jan 2016 14:32:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ard.biesheuvel@linaro.org, hpa@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: x86/extable: use generic search and sort routines
has been added to the -mm tree.  Its filename is
     x86-extable-use-generic-search-and-sort-routines.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-extable-use-generic-search-and-sort-routines.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-extable-use-generic-search-and-sort-routines.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
 arch/x86/mm/extable.c          |  106 -------------------------------
 2 files changed, 4 insertions(+), 107 deletions(-)

diff -puN arch/x86/include/asm/uaccess.h~x86-extable-use-generic-search-and-sort-routines arch/x86/include/asm/uaccess.h
--- a/arch/x86/include/asm/uaccess.h~x86-extable-use-generic-search-and-sort-routines
+++ a/arch/x86/include/asm/uaccess.h
@@ -106,9 +106,8 @@ static inline bool __chk_range_not_ok(un
 struct exception_table_entry {
 	int insn, fixup;
 };
-/* This is not the generic standard exception_table_entry format */
-#define ARCH_HAS_SORT_EXTABLE
-#define ARCH_HAS_SEARCH_EXTABLE
+
+#define ARCH_HAS_RELATIVE_EXTABLE
 
 extern int fixup_exception(struct pt_regs *regs);
 extern int early_fixup_exception(unsigned long *ip);
diff -puN arch/x86/mm/extable.c~x86-extable-use-generic-search-and-sort-routines arch/x86/mm/extable.c
--- a/arch/x86/mm/extable.c~x86-extable-use-generic-search-and-sort-routines
+++ a/arch/x86/mm/extable.c
@@ -1,14 +1,9 @@
+
 #include <linux/module.h>
-#include <linux/spinlock.h>
-#include <linux/sort.h>
+
 #include <asm/uaccess.h>
 
 static inline unsigned long
-ex_insn_addr(const struct exception_table_entry *x)
-{
-	return (unsigned long)&x->insn + x->insn;
-}
-static inline unsigned long
 ex_fixup_addr(const struct exception_table_entry *x)
 {
 	return (unsigned long)&x->fixup + x->fixup;
@@ -70,100 +65,3 @@ int __init early_fixup_exception(unsigne
 
 	return 0;
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
-	}
-}
-
-#ifdef CONFIG_MODULES
-/*
- * If the exception table is sorted, any referring to the module init
- * will be at the beginning or the end.
- */
-void trim_init_extable(struct module *m)
-{
-	/*trim the beginning*/
-	while (m->num_exentries &&
-	       within_module_init(ex_insn_addr(&m->extable[0]), m)) {
-		m->extable++;
-		m->num_exentries--;
-	}
-	/*trim the end*/
-	while (m->num_exentries &&
-	       within_module_init(ex_insn_addr(&m->extable[m->num_exentries-1]), m))
-		m->num_exentries--;
-}
-#endif /* CONFIG_MODULES */
_

Patches currently in -mm which might be from ard.biesheuvel@linaro.org are

extable-add-support-for-relative-extables-to-search-and-sort-routines.patch
alpha-extable-use-generic-search-and-sort-routines.patch
s390-extable-use-generic-search-and-sort-routines.patch
x86-extable-use-generic-search-and-sort-routines.patch
ia64-extable-use-generic-search-and-sort-routines.patch
arm64-switch-to-relative-exception-tables.patch
x86-kallsyms-disable-absolute-percpu-symbols-on-smp.patch
kallsyms-dont-overload-absolute-symbol-type-for-percpu-symbols.patch
kallsyms-add-support-for-relative-offsets-in-kallsyms-address-table.patch

