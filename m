From: akpm@linux-foundation.org
Subject: + mm-save-soft-dirty-bits-on-swapped-pages.patch added to -mm
 tree
Date: Tue, 30 Jul 2013 13:03:52 -0700
Message-ID: <51f81c28.Pw+KIUMPMxT6S2oF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46924 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab3G3UDx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Jul 2013 16:03:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xiaoguangrong@linux.vnet.ibm.com, xemul@parallels.com, sfr@canb.auug.org.au, mtosatti@redhat.com, mpm@selenic.com, luto@amacapital.net, kosaki.motohiro@gmail.com, hush.bensen@gmail.com, gorcunov@openvz.org, James.Bottomley@hansenpartnership.com, gorcunov@gmail.com

Subject: + mm-save-soft-dirty-bits-on-swapped-pages.patch added to -mm tree
To: gorcunov@gmail.com,James.Bottomley@hansenpartnership.com,gorcunov@openvz.org,hush.bensen@gmail.com,kosaki.motohiro@gmail.com,luto@amacapital.net,mpm@selenic.com,mtosatti@redhat.com,sfr@canb.auug.org.au,xemul@parallels.com,xiaoguangrong@linux.vnet.ibm.com
From: akpm@linux-foundation.org
Date: Tue, 30 Jul 2013 13:03:52 -0700


The patch titled
     Subject: mm: save soft-dirty bits on swapped pages
has been added to the -mm tree.  Its filename is
     mm-save-soft-dirty-bits-on-swapped-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-save-soft-dirty-bits-on-swapped-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-save-soft-dirty-bits-on-swapped-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: mm: save soft-dirty bits on swapped pages

Andy Lutomirski reported that in case if a page with _PAGE_SOFT_DIRTY bit
set get swapped out, the bit is getting lost and no longer available when
pte read back.

To resolve this we introduce _PTE_SWP_SOFT_DIRTY bit which is saved in pte
entry for the page being swapped out.  When such page is to be read back
from a swap cache we check for bit presence and if it's there we clear it
and restore the former _PAGE_SOFT_DIRTY bit back.

One of the problem was to find a place in pte entry where we can save the
_PTE_SWP_SOFT_DIRTY bit while page is in swap.  The _PAGE_PSE was chosen
for that, it doesn't intersect with swap entry format stored in pte.

Reported-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Hush Bensen <hush.bensen@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h       |   15 +++++++++++++++
 arch/x86/include/asm/pgtable_types.h |   13 +++++++++++++
 fs/proc/task_mmu.c                   |   23 +++++++++++++++++------
 include/linux/swapops.h              |    4 ++++
 mm/memory.c                          |    4 ++++
 mm/rmap.c                            |    6 +++++-
 6 files changed, 58 insertions(+), 7 deletions(-)

diff -puN arch/x86/include/asm/pgtable.h~mm-save-soft-dirty-bits-on-swapped-pages arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~mm-save-soft-dirty-bits-on-swapped-pages
+++ a/arch/x86/include/asm/pgtable.h
@@ -314,6 +314,21 @@ static inline pmd_t pmd_mksoft_dirty(pmd
 	return pmd_set_flags(pmd, _PAGE_SOFT_DIRTY);
 }
 
+static inline pte_t pte_swp_mksoft_dirty(pte_t pte)
+{
+	return pte_set_flags(pte, _PAGE_SWP_SOFT_DIRTY);
+}
+
+static inline int pte_swp_soft_dirty(pte_t pte)
+{
+	return pte_flags(pte) & _PAGE_SWP_SOFT_DIRTY;
+}
+
+static inline pte_t pte_swp_clear_soft_dirty(pte_t pte)
+{
+	return pte_clear_flags(pte, _PAGE_SWP_SOFT_DIRTY);
+}
+
 /*
  * Mask out unsupported bits in a present pgprot.  Non-present pgprots
  * can use those bits for other purposes, so leave them be.
diff -puN arch/x86/include/asm/pgtable_types.h~mm-save-soft-dirty-bits-on-swapped-pages arch/x86/include/asm/pgtable_types.h
--- a/arch/x86/include/asm/pgtable_types.h~mm-save-soft-dirty-bits-on-swapped-pages
+++ a/arch/x86/include/asm/pgtable_types.h
@@ -67,6 +67,19 @@
 #define _PAGE_SOFT_DIRTY	(_AT(pteval_t, 0))
 #endif
 
+/*
+ * Tracking soft dirty bit when a page goes to a swap is tricky.
+ * We need a bit which can be stored in pte _and_ not conflict
+ * with swap entry format. On x86 bits 6 and 7 are *not* involved
+ * into swap entry computation, but bit 6 is used for nonlinear
+ * file mapping, so we borrow bit 7 for soft dirty tracking.
+ */
+#ifdef CONFIG_MEM_SOFT_DIRTY
+#define _PAGE_SWP_SOFT_DIRTY	_PAGE_PSE
+#else
+#define _PAGE_SWP_SOFT_DIRTY	(_AT(pteval_t, 0))
+#endif
+
 #if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
 #define _PAGE_NX	(_AT(pteval_t, 1) << _PAGE_BIT_NX)
 #else
diff -puN fs/proc/task_mmu.c~mm-save-soft-dirty-bits-on-swapped-pages fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-save-soft-dirty-bits-on-swapped-pages
+++ a/fs/proc/task_mmu.c
@@ -730,8 +730,14 @@ static inline void clear_soft_dirty(stru
 	 * of how soft-dirty works.
 	 */
 	pte_t ptent = *pte;
-	ptent = pte_wrprotect(ptent);
-	ptent = pte_clear_flags(ptent, _PAGE_SOFT_DIRTY);
+
+	if (pte_present(ptent)) {
+		ptent = pte_wrprotect(ptent);
+		ptent = pte_clear_flags(ptent, _PAGE_SOFT_DIRTY);
+	} else if (pte_swp_soft_dirty(ptent)) {
+		ptent = pte_swp_clear_soft_dirty(ptent);
+	}
+
 	set_pte_at(vma->vm_mm, addr, pte, ptent);
 #endif
 }
@@ -752,14 +758,15 @@ static int clear_refs_pte_range(pmd_t *p
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	for (; addr != end; pte++, addr += PAGE_SIZE) {
 		ptent = *pte;
-		if (!pte_present(ptent))
-			continue;
 
 		if (cp->type == CLEAR_REFS_SOFT_DIRTY) {
 			clear_soft_dirty(vma, addr, pte);
 			continue;
 		}
 
+		if (!pte_present(ptent))
+			continue;
+
 		page = vm_normal_page(vma, addr, ptent);
 		if (!page)
 			continue;
@@ -930,8 +937,12 @@ static void pte_to_pagemap_entry(pagemap
 		flags = PM_PRESENT;
 		page = vm_normal_page(vma, addr, pte);
 	} else if (is_swap_pte(pte)) {
-		swp_entry_t entry = pte_to_swp_entry(pte);
-
+		swp_entry_t entry;
+#ifdef CONFIG_MEM_SOFT_DIRTY
+		if (pte_swp_soft_dirty(pte))
+			flags2 |= __PM_SOFT_DIRTY;
+#endif
+		entry = pte_to_swp_entry(pte);
 		frame = swp_type(entry) |
 			(swp_offset(entry) << MAX_SWAPFILES_SHIFT);
 		flags = PM_SWAP;
diff -puN include/linux/swapops.h~mm-save-soft-dirty-bits-on-swapped-pages include/linux/swapops.h
--- a/include/linux/swapops.h~mm-save-soft-dirty-bits-on-swapped-pages
+++ a/include/linux/swapops.h
@@ -67,6 +67,10 @@ static inline swp_entry_t pte_to_swp_ent
 	swp_entry_t arch_entry;
 
 	BUG_ON(pte_file(pte));
+#ifdef CONFIG_MEM_SOFT_DIRTY
+	if (pte_swp_soft_dirty(pte))
+		pte = pte_swp_clear_soft_dirty(pte);
+#endif
 	arch_entry = __pte_to_swp_entry(pte);
 	return swp_entry(__swp_type(arch_entry), __swp_offset(arch_entry));
 }
diff -puN mm/memory.c~mm-save-soft-dirty-bits-on-swapped-pages mm/memory.c
--- a/mm/memory.c~mm-save-soft-dirty-bits-on-swapped-pages
+++ a/mm/memory.c
@@ -3115,6 +3115,10 @@ static int do_swap_page(struct mm_struct
 		exclusive = 1;
 	}
 	flush_icache_page(vma, page);
+#ifdef CONFIG_MEM_SOFT_DIRTY
+	if (pte_swp_soft_dirty(orig_pte))
+		pte = pte_mksoft_dirty(pte);
+#endif
 	set_pte_at(mm, address, page_table, pte);
 	if (page == swapcache)
 		do_page_add_anon_rmap(page, vma, address, exclusive);
diff -puN mm/rmap.c~mm-save-soft-dirty-bits-on-swapped-pages mm/rmap.c
--- a/mm/rmap.c~mm-save-soft-dirty-bits-on-swapped-pages
+++ a/mm/rmap.c
@@ -1236,6 +1236,7 @@ int try_to_unmap_one(struct page *page,
 			   swp_entry_to_pte(make_hwpoison_entry(page)));
 	} else if (PageAnon(page)) {
 		swp_entry_t entry = { .val = page_private(page) };
+		pte_t swp_pte;
 
 		if (PageSwapCache(page)) {
 			/*
@@ -1264,7 +1265,10 @@ int try_to_unmap_one(struct page *page,
 			BUG_ON(TTU_ACTION(flags) != TTU_MIGRATION);
 			entry = make_migration_entry(page, pte_write(pteval));
 		}
-		set_pte_at(mm, address, pte, swp_entry_to_pte(entry));
+		swp_pte = swp_entry_to_pte(entry);
+		if (pte_soft_dirty(pteval))
+			swp_pte = pte_swp_mksoft_dirty(swp_pte);
+		set_pte_at(mm, address, pte, swp_pte);
 		BUG_ON(pte_file(*pte));
 	} else if (IS_ENABLED(CONFIG_MIGRATION) &&
 		   (TTU_ACTION(flags) == TTU_MIGRATION)) {
_

Patches currently in -mm which might be from gorcunov@gmail.com are

mm-save-soft-dirty-bits-on-swapped-pages.patch

