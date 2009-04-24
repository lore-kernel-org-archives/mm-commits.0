From: akpm@linux-foundation.org
Subject: + alpha-exception-table-sorting.patch added to -mm tree
Date: Fri, 24 Apr 2009 13:12:45 -0700
Message-ID: <200904242012.n3OKCj7X006330@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60153 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753062AbZDXUPL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Apr 2009 16:15:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ink@jurassic.park.msu.ru, rth@twiddle.net, viro@ZenIV.linux.org.uk


The patch titled
     alpha: exception table sorting
has been added to the -mm tree.  Its filename is
     alpha-exception-table-sorting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha: exception table sorting
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

Exception fixups for sections other than .text (like one in futex_init())
break the natural ordering of fixup entries, so sorting is required.

Without that the result of the exception table search depends on phase of
the moon.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Richard Henderson <rth@twiddle.net
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/uaccess.h |    2 +
 arch/alpha/mm/extable.c          |   40 ++++++++++++++++++++++++++++-
 2 files changed, 41 insertions(+), 1 deletion(-)

diff -puN arch/alpha/include/asm/uaccess.h~alpha-exception-table-sorting arch/alpha/include/asm/uaccess.h
--- a/arch/alpha/include/asm/uaccess.h~alpha-exception-table-sorting
+++ a/arch/alpha/include/asm/uaccess.h
@@ -507,5 +507,7 @@ struct exception_table_entry
 	(pc) + (_fixup)->fixup.bits.nextinsn;			\
 })
 
+#define ARCH_HAS_SORT_EXTABLE
+#define ARCH_HAS_SEARCH_EXTABLE
 
 #endif /* __ALPHA_UACCESS_H */
diff -puN arch/alpha/mm/extable.c~alpha-exception-table-sorting arch/alpha/mm/extable.c
--- a/arch/alpha/mm/extable.c~alpha-exception-table-sorting
+++ a/arch/alpha/mm/extable.c
@@ -3,11 +3,49 @@
  */
 
 #include <linux/module.h>
+#include <linux/sort.h>
 #include <asm/uaccess.h>
 
+static inline unsigned long ex_to_addr(const struct exception_table_entry *x)
+{
+	return (unsigned long)&x->insn + x->insn;
+}
+
+static void swap_ex(void *a, void *b, int size)
+{
+	struct exception_table_entry *ex_a = a, *ex_b = b;
+	unsigned long addr_a = ex_to_addr(ex_a), addr_b = ex_to_addr(ex_b);
+	unsigned int t = ex_a->fixup.unit;
+
+	ex_a->fixup.unit = ex_b->fixup.unit;
+	ex_b->fixup.unit = t;
+	ex_a->insn = (int)(addr_b - (unsigned long)&ex_a->insn);
+	ex_b->insn = (int)(addr_a - (unsigned long)&ex_b->insn);
+}
+
+/*
+ * The exception table needs to be sorted so that the binary
+ * search that we use to find entries in it works properly.
+ * This is used both for the kernel exception table and for
+ * the exception tables of modules that get loaded.
+ */
+static int cmp_ex(const void *a, const void *b)
+{
+	const struct exception_table_entry *x = a, *y = b;
+
+	/* avoid overflow */
+	if (ex_to_addr(x) > ex_to_addr(y))
+		return 1;
+	if (ex_to_addr(x) < ex_to_addr(y))
+		return -1;
+	return 0;
+}
+
 void sort_extable(struct exception_table_entry *start,
 		  struct exception_table_entry *finish)
 {
+	sort(start, finish - start, sizeof(struct exception_table_entry),
+	     cmp_ex, swap_ex);
 }
 
 const struct exception_table_entry *
@@ -20,7 +58,7 @@ search_extable(const struct exception_ta
 		unsigned long mid_value;
 
 		mid = (last - first) / 2 + first;
-		mid_value = (unsigned long)&mid->insn + mid->insn;
+		mid_value = ex_to_addr(mid);
                 if (mid_value == value)
                         return mid;
                 else if (mid_value < value)
_

Patches currently in -mm which might be from ink@jurassic.park.msu.ru are

linux-next.patch
time-create-arch_gettimeoffset-infrastructure-for-use-in-the-generic-timekeeping-core.patch
alpha-titan-and-marvel-build-fixes.patch
alpha-exception-table-sorting.patch
alpha-futex-implementation.patch
alpha-binfmt_aout-fix.patch
kmap_types-make-most-arches-use-generic-header-file.patch
make-sure-nobodys-leaking-resources.patch

