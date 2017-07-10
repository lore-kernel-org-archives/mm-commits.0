From: akpm@linux-foundation.org
Subject: [folded-merged]
 lib-extablec-use-bsearch-library-function-in-search_extable-v3.patch
 removed from -mm tree
Date: Mon, 10 Jul 2017 15:35:51 -0700
Message-ID: <59640147.vYxAgNcZrT9BHciX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41320 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754041AbdGJWfw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:35:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: thomas@m3y3r.de, dalias@libc.org, davem@davemloft.net, linux@rasmusvillemoes.dk, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-extablec-use-bsearch-library-function-in-search_extable-v3
has been removed from the -mm tree.  Its filename was
     lib-extablec-use-bsearch-library-function-in-search_extable-v3.patch

This patch was dropped because it was folded into lib-extablec-use-bsearch-library-function-in-search_extable.patch

------------------------------------------------------
From: Thomas Meyer <thomas@m3y3r.de>
Subject: lib-extablec-use-bsearch-library-function-in-search_extable-v3

v3: Fix arch specific implementations

Link: http://lkml.kernel.org/r/1497890858.12931.7.camel@m3y3r.de
Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Rich Felker <dalias@libc.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/module.c |    3 ++-
 arch/mips/kernel/traps.c  |    3 ++-
 arch/sh/mm/extable_64.c   |   34 ++++++++++++++++++----------------
 arch/sparc/mm/extable.c   |   28 ++++++++++++++--------------
 include/linux/extable.h   |    2 +-
 kernel/extable.c          |    3 ++-
 lib/extable.c             |   13 +++++++------
 7 files changed, 46 insertions(+), 40 deletions(-)

diff -puN arch/mips/kernel/module.c~lib-extablec-use-bsearch-library-function-in-search_extable-v3 arch/mips/kernel/module.c
--- a/arch/mips/kernel/module.c~lib-extablec-use-bsearch-library-function-in-search_extable-v3
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
diff -puN arch/mips/kernel/traps.c~lib-extablec-use-bsearch-library-function-in-search_extable-v3 arch/mips/kernel/traps.c
--- a/arch/mips/kernel/traps.c~lib-extablec-use-bsearch-library-function-in-search_extable-v3
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
diff -puN arch/sh/mm/extable_64.c~lib-extablec-use-bsearch-library-function-in-search_extable-v3 arch/sh/mm/extable_64.c
--- a/arch/sh/mm/extable_64.c~lib-extablec-use-bsearch-library-function-in-search_extable-v3
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
diff -puN arch/sparc/mm/extable.c~lib-extablec-use-bsearch-library-function-in-search_extable-v3 arch/sparc/mm/extable.c
--- a/arch/sparc/mm/extable.c~lib-extablec-use-bsearch-library-function-in-search_extable-v3
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
diff -puN include/linux/extable.h~lib-extablec-use-bsearch-library-function-in-search_extable-v3 include/linux/extable.h
--- a/include/linux/extable.h~lib-extablec-use-bsearch-library-function-in-search_extable-v3
+++ a/include/linux/extable.h
@@ -8,7 +8,7 @@ struct module;
 struct exception_table_entry;
 
 const struct exception_table_entry *
-search_extable(const struct exception_table_entry *first,
+search_extable(const struct exception_table_entry *base,
 	       const size_t num,
 	       unsigned long value);
 void sort_extable(struct exception_table_entry *start,
diff -puN kernel/extable.c~lib-extablec-use-bsearch-library-function-in-search_extable-v3 kernel/extable.c
--- a/kernel/extable.c~lib-extablec-use-bsearch-library-function-in-search_extable-v3
+++ a/kernel/extable.c
@@ -55,7 +55,8 @@ const struct exception_table_entry *sear
 {
 	const struct exception_table_entry *e;
 
-	e = search_extable(__start___ex_table, __stop___ex_table - __start___ex_table, addr);
+	e = search_extable(__start___ex_table,
+			   __stop___ex_table - __start___ex_table, addr);
 	if (!e)
 		e = search_module_extables(addr);
 	return e;
diff -puN lib/extable.c~lib-extablec-use-bsearch-library-function-in-search_extable-v3 lib/extable.c
--- a/lib/extable.c~lib-extablec-use-bsearch-library-function-in-search_extable-v3
+++ a/lib/extable.c
@@ -97,13 +97,13 @@ void trim_init_extable(struct module *m)
 
 static int cmp_ex_search(const void *key, const void *elt)
 {
-	const struct exception_table_entry * _elt = elt;
-	unsigned long k = *(unsigned long*) key;
+	const struct exception_table_entry *_elt = elt;
+	unsigned long _key = *(unsigned long *)key;
 
 	/* avoid overflow */
-	if (k > ex_to_insn(_elt))
+	if (_key > ex_to_insn(_elt))
 		return 1;
-	if (k < ex_to_insn(_elt))
+	if (_key < ex_to_insn(_elt))
 		return -1;
 	return 0;
 }
@@ -116,10 +116,11 @@ static int cmp_ex_search(const void *key
  * already sorted.
  */
 const struct exception_table_entry *
-search_extable(const struct exception_table_entry *first,
+search_extable(const struct exception_table_entry *base,
 	       const size_t num,
 	       unsigned long value)
 {
-	return bsearch(&value, first, num, sizeof(struct exception_table_entry), cmp_ex_search);
+	return bsearch(&value, base, num,
+		       sizeof(struct exception_table_entry), cmp_ex_search);
 }
 #endif
_

Patches currently in -mm which might be from thomas@m3y3r.de are

lib-extablec-use-bsearch-library-function-in-search_extable.patch

