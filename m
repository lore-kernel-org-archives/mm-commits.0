From: akpm@linux-foundation.org
Subject: +
 lib-extablec-use-bsearch-library-function-in-search_extable.patch added to
 -mm tree
Date: Thu, 15 Jun 2017 14:35:34 -0700
Message-ID: <5942fda6.2QWHUhYGO28i6k9v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43318 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751590AbdFOVff (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jun 2017 17:35:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: thomas@m3y3r.de, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/extable.c: use bsearch() library function in search_extable()
has been added to the -mm tree.  Its filename is
     lib-extablec-use-bsearch-library-function-in-search_extable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-extablec-use-bsearch-library-function-in-search_extable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-extablec-use-bsearch-library-function-in-search_extable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Thomas Meyer <thomas@m3y3r.de>
Subject: lib/extable.c: use bsearch() library function in search_extable()

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/extable.h |    3 ++-
 kernel/extable.c        |    2 +-
 kernel/module.c         |    2 +-
 lib/extable.c           |   38 +++++++++++++++++++-------------------
 4 files changed, 23 insertions(+), 22 deletions(-)

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
 search_extable(const struct exception_table_entry *first,
-	       const struct exception_table_entry *last,
+	       const size_t num,
 	       unsigned long value);
 void sort_extable(struct exception_table_entry *start,
 		  struct exception_table_entry *finish);
diff -puN kernel/extable.c~lib-extablec-use-bsearch-library-function-in-search_extable kernel/extable.c
--- a/kernel/extable.c~lib-extablec-use-bsearch-library-function-in-search_extable
+++ a/kernel/extable.c
@@ -55,7 +55,7 @@ const struct exception_table_entry *sear
 {
 	const struct exception_table_entry *e;
 
-	e = search_extable(__start___ex_table, __stop___ex_table-1, addr);
+	e = search_extable(__start___ex_table, __stop___ex_table - __start___ex_table, addr);
 	if (!e)
 		e = search_module_extables(addr);
 	return e;
diff -puN kernel/module.c~lib-extablec-use-bsearch-library-function-in-search_extable kernel/module.c
--- a/kernel/module.c~lib-extablec-use-bsearch-library-function-in-search_extable
+++ a/kernel/module.c
@@ -4201,7 +4201,7 @@ const struct exception_table_entry *sear
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
+	const struct exception_table_entry * _elt = elt;
+	unsigned long k = *(unsigned long*) key;
+
+	/* avoid overflow */
+	if (k > ex_to_insn(_elt))
+		return 1;
+	if (k < ex_to_insn(_elt))
+		return -1;
+	return 0;
+}
+
 /*
  * Search one exception table for an entry corresponding to the
  * given instruction address, and return the address of the entry,
@@ -102,24 +117,9 @@ void trim_init_extable(struct module *m)
  */
 const struct exception_table_entry *
 search_extable(const struct exception_table_entry *first,
-	       const struct exception_table_entry *last,
+	       const size_t num,
 	       unsigned long value)
 {
-	while (first <= last) {
-		const struct exception_table_entry *mid;
