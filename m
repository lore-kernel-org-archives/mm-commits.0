From: akpm@linux-foundation.org
Subject: +
 extable-add-support-for-relative-extables-to-search-and-sort-routines.patch added to -mm tree
Date: Wed, 27 Jan 2016 11:32:08 -0800
Message-ID: <56a91b38.CN0BUGUF45cwPend%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57685 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934074AbcA0TcK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jan 2016 14:32:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ard.biesheuvel@linaro.org, deller@gmx.de, heiko.carstens@de.ibm.com, hpa@linux.intel.com, rth@twiddle.net, tony.luck@intel.com, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: extable: add support for relative extables to search and sort routines
has been added to the -mm tree.  Its filename is
     extable-add-support-for-relative-extables-to-search-and-sort-routines.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/extable-add-support-for-relative-extables-to-search-and-sort-routines.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/extable-add-support-for-relative-extables-to-search-and-sort-routines.patch

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
Subject: extable: add support for relative extables to search and sort routines

There are currently four architectures (x86, ia64, alpha and s390) whose
user-access exception tables are relative to the table entry address
rather than absolute.  Each of these architectures has its own
search_extable() and sort_extable() implementation, which are not only
mostly identical to each other, but also deviate very little from the
generic absolute implementations in lib/extable.c that they override.

So before making arm64 the fifth architecture that reimplements this,
let's refactor the existing code so that all of these architectures use
common code for searching and sorting the relative extables.  Archs may
set ARCH_HAS_RELATIVE_EXTABLE to indicate that the table consists of a
pair of relative ints, and may define swap_ex_entry_fixup() if the fixup
member needs special treatment in the swapping step of the sorting routine
(such as alpha).



This patch (of 6):

Add support to the generic search_extable() and sort_extable()
implementations for dealing with exception table entries whose fields
contain relative offsets rather than absolute addresses.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Acked-by: Helge Deller <deller@gmx.de>
Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: H. Peter Anvin <hpa@linux.intel.com>
Acked-by: Tony Luck <tony.luck@intel.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Acked-by: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/extable.c |   50 +++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 41 insertions(+), 9 deletions(-)

diff -puN lib/extable.c~extable-add-support-for-relative-extables-to-search-and-sort-routines lib/extable.c
--- a/lib/extable.c~extable-add-support-for-relative-extables-to-search-and-sort-routines
+++ a/lib/extable.c
@@ -14,7 +14,37 @@
 #include <linux/sort.h>
 #include <asm/uaccess.h>
 
+#ifndef ARCH_HAS_RELATIVE_EXTABLE
+#define ex_to_insn(x)	((x)->insn)
+#else
+static inline unsigned long ex_to_insn(const struct exception_table_entry *x)
+{
+	return (unsigned long)&x->insn + x->insn;
+}
+#endif
+
 #ifndef ARCH_HAS_SORT_EXTABLE
+#ifndef ARCH_HAS_RELATIVE_EXTABLE
+#define swap_ex		NULL
+#else
+static void swap_ex(void *a, void *b, int size)
+{
+	struct exception_table_entry *x = a, *y = b, tmp;
+	int delta = b - a;
+
+	tmp = *x;
+	x->insn = y->insn + delta;
+	y->insn = tmp.insn - delta;
+
+#ifdef swap_ex_entry_fixup
+	swap_ex_entry_fixup(x, y, tmp, delta);
+#else
+	x->fixup = y->fixup + delta;
+	y->fixup = tmp.fixup - delta;
+#endif
+}
+#endif /* ARCH_HAS_RELATIVE_EXTABLE */
+
 /*
  * The exception table needs to be sorted so that the binary
  * search that we use to find entries in it works properly.
@@ -26,9 +56,9 @@ static int cmp_ex(const void *a, const v
 	const struct exception_table_entry *x = a, *y = b;
 
 	/* avoid overflow */
-	if (x->insn > y->insn)
+	if (ex_to_insn(x) > ex_to_insn(y))
 		return 1;
-	if (x->insn < y->insn)
+	if (ex_to_insn(x) < ex_to_insn(y))
 		return -1;
 	return 0;
 }
@@ -37,7 +67,7 @@ void sort_extable(struct exception_table
 		  struct exception_table_entry *finish)
 {
 	sort(start, finish - start, sizeof(struct exception_table_entry),
-	     cmp_ex, NULL);
+	     cmp_ex, swap_ex);
 }
 
 #ifdef CONFIG_MODULES
@@ -48,13 +78,15 @@ void sort_extable(struct exception_table
 void trim_init_extable(struct module *m)
 {
 	/*trim the beginning*/
-	while (m->num_exentries && within_module_init(m->extable[0].insn, m)) {
+	while (m->num_exentries &&
+	       within_module_init(ex_to_insn(&m->extable[0]), m)) {
 		m->extable++;
 		m->num_exentries--;
 	}
 	/*trim the end*/
 	while (m->num_exentries &&
-		within_module_init(m->extable[m->num_exentries-1].insn, m))
+	       within_module_init(ex_to_insn(&m->extable[m->num_exentries - 1]),
+				  m))
 		m->num_exentries--;
 }
 #endif /* CONFIG_MODULES */
@@ -81,13 +113,13 @@ search_extable(const struct exception_ta
 		 * careful, the distance between value and insn
 		 * can be larger than MAX_LONG:
 		 */
-		if (mid->insn < value)
+		if (ex_to_insn(mid) < value)
 			first = mid + 1;
-		else if (mid->insn > value)
+		else if (ex_to_insn(mid) > value)
 			last = mid - 1;
 		else
 			return mid;
-        }
-        return NULL;
+	}
+	return NULL;
 }
 #endif
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

