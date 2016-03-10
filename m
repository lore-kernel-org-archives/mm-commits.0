From: akpm@linux-foundation.org
Subject: + s390-extable-use-generic-search-and-sort-routines.patch added
 to -mm tree
Date: Thu, 10 Mar 2016 14:07:55 -0800
Message-ID: <56e1f03b.AhSnDB3ei7aFgTg7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59927 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932379AbcCJWH4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Mar 2016 17:07:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ard.biesheuvel@linaro.org, heiko.carstens@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: s390/extable: use generic search and sort routines
has been added to the -mm tree.  Its filename is
     s390-extable-use-generic-search-and-sort-routines.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/s390-extable-use-generic-search-and-sort-routines.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/s390-extable-use-generic-search-and-sort-routines.patch

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
Subject: s390/extable: use generic search and sort routines

Replace the arch specific versions of search_extable() and sort_extable()
with calls to the generic ones, which now support relative exception
tables as well.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/uaccess.h |    8 --
 arch/s390/mm/Makefile           |    2 
 arch/s390/mm/extable.c          |   85 ------------------------------
 3 files changed, 2 insertions(+), 93 deletions(-)

diff -puN arch/s390/include/asm/uaccess.h~s390-extable-use-generic-search-and-sort-routines arch/s390/include/asm/uaccess.h
--- a/arch/s390/include/asm/uaccess.h~s390-extable-use-generic-search-and-sort-routines
+++ a/arch/s390/include/asm/uaccess.h
@@ -79,18 +79,12 @@ struct exception_table_entry
 	int insn, fixup;
 };
 
-static inline unsigned long extable_insn(const struct exception_table_entry *x)
-{
-	return (unsigned long)&x->insn + x->insn;
-}
-
 static inline unsigned long extable_fixup(const struct exception_table_entry *x)
 {
 	return (unsigned long)&x->fixup + x->fixup;
 }
 
-#define ARCH_HAS_SORT_EXTABLE
-#define ARCH_HAS_SEARCH_EXTABLE
+#define ARCH_HAS_RELATIVE_EXTABLE
 
 /**
  * __copy_from_user: - Copy a block of data from user space, with less checking.
diff -puN arch/s390/mm/Makefile~s390-extable-use-generic-search-and-sort-routines arch/s390/mm/Makefile
--- a/arch/s390/mm/Makefile~s390-extable-use-generic-search-and-sort-routines
+++ a/arch/s390/mm/Makefile
@@ -3,7 +3,7 @@
 #
 
 obj-y		:= init.o fault.o extmem.o mmap.o vmem.o maccess.o
-obj-y		+= page-states.o gup.o extable.o pageattr.o mem_detect.o
+obj-y		+= page-states.o gup.o pageattr.o mem_detect.o
 obj-y		+= pgtable.o pgalloc.o
 
 obj-$(CONFIG_CMM)		+= cmm.o
diff -puN arch/s390/mm/extable.c~s390-extable-use-generic-search-and-sort-routines /dev/null
--- a/arch/s390/mm/extable.c
+++ /dev/null
@@ -1,85 +0,0 @@
-#include <linux/module.h>
-#include <linux/sort.h>
-#include <asm/uaccess.h>
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
-	const struct exception_table_entry *mid;
-	unsigned long addr;
-
-	while (first <= last) {
-		mid = ((last - first) >> 1) + first;
-		addr = extable_insn(mid);
-		if (addr < value)
-			first = mid + 1;
-		else if (addr > value)
-			last = mid - 1;
-		else
-			return mid;
-	}
-	return NULL;
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
-	/* This compare is only valid after normalization. */
-	return x->insn - y->insn;
-}
-
-void sort_extable(struct exception_table_entry *start,
-		  struct exception_table_entry *finish)
-{
-	struct exception_table_entry *p;
-	int i;
-
-	/* Normalize entries to being relative to the start of the section */
-	for (p = start, i = 0; p < finish; p++, i += 8) {
-		p->insn += i;
-		p->fixup += i + 4;
-	}
-	sort(start, finish - start, sizeof(*start), cmp_ex, NULL);
-	/* Denormalize all entries */
-	for (p = start, i = 0; p < finish; p++, i += 8) {
-		p->insn -= i;
-		p->fixup -= i + 4;
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
-	/* Trim the beginning */
-	while (m->num_exentries &&
-	       within_module_init(extable_insn(&m->extable[0]), m)) {
-		m->extable++;
-		m->num_exentries--;
-	}
-	/* Trim the end */
-	while (m->num_exentries &&
-	       within_module_init(extable_insn(&m->extable[m->num_exentries-1]), m))
-		m->num_exentries--;
-}
-#endif /* CONFIG_MODULES */
_

Patches currently in -mm which might be from ard.biesheuvel@linaro.org are

x86-kallsyms-disable-absolute-percpu-symbols-on-smp.patch
x86-kallsyms-disable-absolute-percpu-symbols-on-smp-v5.patch
kallsyms-dont-overload-absolute-symbol-type-for-percpu-symbols.patch
kallsyms-add-support-for-relative-offsets-in-kallsyms-address-table.patch
kallsyms-add-support-for-relative-offsets-in-kallsyms-address-table-v5.patch
alpha-extable-use-generic-search-and-sort-routines.patch
s390-extable-use-generic-search-and-sort-routines.patch
x86-extable-use-generic-search-and-sort-routines.patch
ia64-extable-use-generic-search-and-sort-routines.patch

