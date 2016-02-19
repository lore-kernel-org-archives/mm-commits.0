From: akpm@linux-foundation.org
Subject: [to-be-updated]
 ia64-extable-use-generic-search-and-sort-routines.patch removed from -mm
 tree
Date: Fri, 19 Feb 2016 10:58:29 -0800
Message-ID: <56c765d5.FJCOu+BJFmj4zjKA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34639 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422838AbcBSS63 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Feb 2016 13:58:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ard.biesheuvel@linaro.org, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ia64/extable: use generic search and sort routines
has been removed from the -mm tree.  Its filename was
     ia64-extable-use-generic-search-and-sort-routines.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: ia64/extable: use generic search and sort routines

Replace the arch specific versions of search_extable() and sort_extable()
with calls to the generic ones, which now support relative exception
tables as well.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Acked-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/uaccess.h |    8 --
 arch/ia64/mm/extable.c          |   97 ------------------------------
 2 files changed, 4 insertions(+), 101 deletions(-)

diff -puN arch/ia64/include/asm/uaccess.h~ia64-extable-use-generic-search-and-sort-routines arch/ia64/include/asm/uaccess.h
--- a/arch/ia64/include/asm/uaccess.h~ia64-extable-use-generic-search-and-sort-routines
+++ a/arch/ia64/include/asm/uaccess.h
@@ -341,13 +341,11 @@ extern unsigned long __strnlen_user (con
 	__su_ret;						\
 })
 
-/* Generic code can't deal with the location-relative format that we use for compactness.  */
-#define ARCH_HAS_SORT_EXTABLE
-#define ARCH_HAS_SEARCH_EXTABLE
+#define ARCH_HAS_RELATIVE_EXTABLE
 
 struct exception_table_entry {
-	int addr;	/* location-relative address of insn this fixup is for */
-	int cont;	/* location-relative continuation addr.; if bit 2 is set, r9 is set to 0 */
+	int insn;	/* location-relative address of insn this fixup is for */
+	int fixup;	/* location-relative continuation addr.; if bit 2 is set, r9 is set to 0 */
 };
 
 extern void ia64_handle_exception (struct pt_regs *regs, const struct exception_table_entry *e);
diff -puN arch/ia64/mm/extable.c~ia64-extable-use-generic-search-and-sort-routines arch/ia64/mm/extable.c
--- a/arch/ia64/mm/extable.c~ia64-extable-use-generic-search-and-sort-routines
+++ a/arch/ia64/mm/extable.c
@@ -5,107 +5,12 @@
  *	David Mosberger-Tang <davidm@hpl.hp.com>
  */
 
-#include <linux/sort.h>
-
 #include <asm/uaccess.h>
-#include <linux/module.h>
-
-static int cmp_ex(const void *a, const void *b)
-{
-	const struct exception_table_entry *l = a, *r = b;
-	u64 lip = (u64) &l->addr + l->addr;
-	u64 rip = (u64) &r->addr + r->addr;
-
-	/* avoid overflow */
-	if (lip > rip)
-		return 1;
-	if (lip < rip)
-		return -1;
-	return 0;
-}
-
-static void swap_ex(void *a, void *b, int size)
-{
-	struct exception_table_entry *l = a, *r = b, tmp;
-	u64 delta = (u64) r - (u64) l;
-
-	tmp = *l;
-	l->addr = r->addr + delta;
-	l->cont = r->cont + delta;
-	r->addr = tmp.addr - delta;
-	r->cont = tmp.cont - delta;
-}
-
-/*
- * Sort the exception table. It's usually already sorted, but there
- * may be unordered entries due to multiple text sections (such as the
- * .init text section). Note that the exception-table-entries contain
- * location-relative addresses, which requires a bit of care during
- * sorting to avoid overflows in the offset members (e.g., it would
- * not be safe to make a temporary copy of an exception-table entry on
- * the stack, because the stack may be more than 2GB away from the
- * exception-table).
- */
-void sort_extable (struct exception_table_entry *start,
-		   struct exception_table_entry *finish)
-{
-	sort(start, finish - start, sizeof(struct exception_table_entry),
-	     cmp_ex, swap_ex);
-}
-
-static inline unsigned long ex_to_addr(const struct exception_table_entry *x)
-{
-	return (unsigned long)&x->addr + x->addr;
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
-search_extable (const struct exception_table_entry *first,
-		const struct exception_table_entry *last,
-		unsigned long ip)
-{
-	const struct exception_table_entry *mid;
-	unsigned long mid_ip;
-	long diff;
-
-        while (first <= last) {
-		mid = &first[(last - first)/2];
-		mid_ip = (u64) &mid->addr + mid->addr;
-		diff = mid_ip - ip;
-                if (diff == 0)
-                        return mid;
-                else if (diff < 0)
-                        first = mid + 1;
-                else
-                        last = mid - 1;
-        }
-        return NULL;
-}
 
 void
 ia64_handle_exception (struct pt_regs *regs, const struct exception_table_entry *e)
 {
-	long fix = (u64) &e->cont + e->cont;
+	long fix = (u64) &e->fixup + e->fixup;
 
 	regs->r8 = -EFAULT;
 	if (fix & 4)
_

Patches currently in -mm which might be from ard.biesheuvel@linaro.org are

arm64-switch-to-relative-exception-tables.patch
x86-kallsyms-disable-absolute-percpu-symbols-on-smp.patch
x86-kallsyms-disable-absolute-percpu-symbols-on-smp-v5.patch
kallsyms-dont-overload-absolute-symbol-type-for-percpu-symbols.patch
kallsyms-add-support-for-relative-offsets-in-kallsyms-address-table.patch
kallsyms-add-support-for-relative-offsets-in-kallsyms-address-table-v5.patch

