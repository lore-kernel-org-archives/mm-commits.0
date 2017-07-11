From: akpm@linux-foundation.org
Subject: [merged]
 lib-extablec-use-bsearch-library-function-in-search_extable.patch removed
 from -mm tree
Date: Tue, 11 Jul 2017 12:26:45 -0700
Message-ID: <20170711192645.RCqN5JlEd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48550 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932973AbdGKT0q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:26:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org, thomas@m3y3r.de


The patch titled
     Subject: lib/extable.c: use bsearch() library function in search_extable()
has been removed from the -mm tree.  Its filename was
     lib-extablec-use-bsearch-library-function-in-search_extable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Thomas Meyer <thomas@m3y3r.de>
Subject: lib/extable.c: use bsearch() library function in search_extable()

[thomas@m3y3r.de: v3: fix arch specific implementations]
  Link: http://lkml.kernel.org/r/1497890858.12931.7.camel@m3y3r.de
Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/module.c |    3 +-
 arch/mips/kernel/traps.c  |    3 +-
 arch/sh/mm/extable_64.c   |   34 +++++++++++++++--------------
 arch/sparc/mm/extable.c   |   28 ++++++++++++------------
 include/linux/extable.h   |    5 ++--
 kernel/extable.c          |    3 +-
 kernel/module.c           |    2 -
 lib/extable.c             |   41 ++++++++++++++++++------------------
 8 files changed, 63 insertions(+), 56 deletions(-)

diff -puN arch/mips/kernel/module.c~lib-extablec-use-bsearch-library-function-in-search_extable arch/mips/kernel/module.c
--- a/arch/mips/kernel/module.c~lib-extablec-use-bsearch-library-function-in-search_extable
+++ a/arch/mips/kernel/module.c
@@ -317,7 +317,8 @@ const struct exception_table_entry *sear
 
 	spin_lock_irqsave(&dbe_lock, flags);
 	list_for_each_entry(dbe, &dbe_list, dbe_list) {
-		e = search_extable(dbe->dbe_start, dbe->dbe_end - 1, addr);
+		e = search_extable(dbe->dbe_start,
+				   dbe->dbe_end - dbe->dbe_start, addr);
 		if (e)
 			break;
 	}
diff -puN arch/mips/kernel/traps.c~lib-extablec-use-bsearch-library-function-in-search_extable arch/mips/kernel/traps.c
--- a/arch/mips/kernel/traps.c~lib-extablec-use-bsearch-library-function-in-search_extable
+++ a/arch/mips/kernel/traps.c
@@ -429,7 +429,8 @@ static const struct exception_table_entr
 {
 	const struct exception_table_entry *e;
 
-	e = search_extable(__start___dbe_table, __stop___dbe_table - 1, addr);
+	e = search_extable(__start___dbe_table,
+			   __stop___dbe_table - __start___dbe_table, addr);
 	if (!e)
 		e = search_module_dbetables(addr);
 	return e;
diff -puN arch/sh/mm/extable_64.c~lib-extablec-use-bsearch-library-function-in-search_extable arch/sh/mm/extable_64.c
--- a/arch/sh/mm/extable_64.c~lib-extablec-use-bsearch-library-function-in-search_extable
+++ a/arch/sh/mm/extable_64.c
@@ -10,6 +10,7 @@
  * License.  See the file "COPYING" in the main directory of this archive
  * for more details.
  */
+#include <linux/bsearch.h>
 #include <linux/rwsem.h>
 #include <linux/extable.h>
 #include <linux/uaccess.h>
@@ -40,10 +41,23 @@ static const struct exception_table_entr
 	return NULL;
 }
 
+static int cmp_ex_search(const void *key, const void *elt)
+{
+	const struct exception_table_entry *_elt = elt;
+	unsigned long _key = *(unsigned long *)key;
+
+	/* avoid overflow */
+	if (_key > _elt->insn)
+		return 1;
+	if (_key < _elt->insn)
+		return -1;
+	return 0;
+}
+
 /* Simple binary search */
 const struct exception_table_entry *
-search_extable(const struct exception_table_entry *first,
-		 const struct exception_table_entry *last,
+search_extable(const struct exception_table_entry *base,
+		 const size_t num,
 		 unsigned long value)
 {
 	const struct exception_table_entry *mid;
@@ -52,20 +66,8 @@ search_extable(const struct exception_ta
 	if (mid)
 		return mid;
 
-        while (first <= last) {
-		long diff;
-
-		mid = (last - first) / 2 + first;
-		diff = mid->insn - value;
-                if (diff == 0)
-                        return mid;
-                else if (diff < 0)
-                        first = mid+1;
-                else
-                        last = mid-1;
-        }
-
-        return NULL;
+	return bsearch(&value, base, num,
+		       sizeof(struct exception_table_entry), cmp_ex_search);
 }
 
 int fixup_exception(struct pt_regs *regs)
diff -puN arch/sparc/mm/extable.c~lib-extablec-use-bsearch-library-function-in-search_extable arch/sparc/mm/extable.c
--- a/arch/sparc/mm/extable.c~lib-extablec-use-bsearch-library-function-in-search_extable
+++ a/arch/sparc/mm/extable.c
@@ -13,11 +13,11 @@ void sort_extable(struct exception_table
 
 /* Caller knows they are in a range if ret->fixup == 0 */
 const struct exception_table_entry *
-search_extable(const struct exception_table_entry *start,
-	       const struct exception_table_entry *last,
+search_extable(const struct exception_table_entry *base,
+	       const size_t num,
 	       unsigned long value)
 {
-	const struct exception_table_entry *walk;
+	int i;
 
 	/* Single insn entries are encoded as:
 	 *	word 1:	insn address
@@ -37,30 +37,30 @@ search_extable(const struct exception_ta
 	 */
 
 	/* 1. Try to find an exact match. */
-	for (walk = start; walk <= last; walk++) {
-		if (walk->fixup == 0) {
+	for (i = 0; i < num; i++) {
+		if (base[i].fixup == 0) {
 			/* A range entry, skip both parts. */
-			walk++;
+			i++;
 			continue;
 		}
 
 		/* A deleted entry; see trim_init_extable */
-		if (walk->fixup == -1)
+		if (base[i].fixup == -1)
 			continue;
 
-		if (walk->insn == value)
-			return walk;
+		if (base[i].insn == value)
+			return &base[i];
 	}
 
 	/* 2. Try to find a range match. */
-	for (walk = start; walk <= (last - 1); walk++) {
-		if (walk->fixup)
+	for (i = 0; i < (num - 1); i++) {
+		if (base[i].fixup)
 			continue;
 
-		if (walk[0].insn <= value && walk[1].insn > value)
-			return walk;
+		if (base[i].insn <= value && base[i + 1].insn > value)
+			return &base[i];
 
-		walk++;
+		i++;
 	}
 
         return NULL;
diff -puN include/linux/extable.h~lib-extablec-use-bsearch-library-function-in-search_extable include/linux/extable.h
--- a/include/linux/extable.h~lib-extablec-use-bsearch-library-function-in-search_extable
+++ a/include/linux/extable.h
@@ -2,13 +2,14 @@
 #define _LINUX_EXTABLE_H
 
 #include <linux/stddef.h>	/* for NULL */
+#include <linux/types.h>
 
 struct module;
 struct exception_table_entry;
 
 const struct exception_table_entry *
-search_extable(const struct exception_table_entry *first,
-	       const struct exception_table_entry *last,
+search_extable(const struct exception_table_entry *base,
+	       const size_t num,
 	       unsigned long value);
 void sort_extable(struct exception_table_entry *start,
 		  struct exception_table_entry *finish);
diff -puN kernel/extable.c~lib-extablec-use-bsearch-library-function-in-search_extable kernel/extable.c
--- a/kernel/extable.c~lib-extablec-use-bsearch-library-function-in-search_extable
+++ a/kernel/extable.c
@@ -55,7 +55,8 @@ const struct exception_table_entry *sear
 {
 	const struct exception_table_entry *e;
 
-	e = search_extable(__start___ex_table, __stop___ex_table-1, addr);
+	e = search_extable(__start___ex_table,
+			   __stop___ex_table - __start___ex_table, addr);
 	if (!e)
 		e = search_module_extables(addr);
 	return e;
diff -puN kernel/module.c~lib-extablec-use-bsearch-library-function-in-search_extable kernel/module.c
--- a/kernel/module.c~lib-extablec-use-bsearch-library-function-in-search_extable
+++ a/kernel/module.c
@@ -4196,7 +4196,7 @@ const struct exception_table_entry *sear
 		goto out;
 
 	e = search_extable(mod->extable,
-			   mod->extable + mod->num_exentries - 1,
+			   mod->num_exentries,
 			   addr);
 out:
 	preempt_enable();
diff -puN lib/extable.c~lib-extablec-use-bsearch-library-function-in-search_extable lib/extable.c
--- a/lib/extable.c~lib-extablec-use-bsearch-library-function-in-search_extable
+++ a/lib/extable.c
@@ -9,6 +9,7 @@
  * 2 of the License, or (at your option) any later version.
  */
 
+#include <linux/bsearch.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/sort.h>
@@ -51,7 +52,7 @@ static void swap_ex(void *a, void *b, in
  * This is used both for the kernel exception table and for
  * the exception tables of modules that get loaded.
  */
-static int cmp_ex(const void *a, const void *b)
+static int cmp_ex_sort(const void *a, const void *b)
 {
 	const struct exception_table_entry *x = a, *y = b;
 
@@ -67,7 +68,7 @@ void sort_extable(struct exception_table
 		  struct exception_table_entry *finish)
 {
 	sort(start, finish - start, sizeof(struct exception_table_entry),
-	     cmp_ex, swap_ex);
+	     cmp_ex_sort, swap_ex);
 }
 
 #ifdef CONFIG_MODULES
@@ -93,6 +94,20 @@ void trim_init_extable(struct module *m)
 #endif /* !ARCH_HAS_SORT_EXTABLE */
 
 #ifndef ARCH_HAS_SEARCH_EXTABLE
+
+static int cmp_ex_search(const void *key, const void *elt)
+{
+	const struct exception_table_entry *_elt = elt;
+	unsigned long _key = *(unsigned long *)key;
+
+	/* avoid overflow */
+	if (_key > ex_to_insn(_elt))
+		return 1;
+	if (_key < ex_to_insn(_elt))
+		return -1;
+	return 0;
+}
+
 /*
  * Search one exception table for an entry corresponding to the
  * given instruction address, and return the address of the entry,
@@ -101,25 +116,11 @@ void trim_init_extable(struct module *m)
  * already sorted.
  */
 const struct exception_table_entry *
-search_extable(const struct exception_table_entry *first,
-	       const struct exception_table_entry *last,
+search_extable(const struct exception_table_entry *base,
+	       const size_t num,
 	       unsigned long value)
 {
-	while (first <= last) {
-		const struct exception_table_entry *mid;
