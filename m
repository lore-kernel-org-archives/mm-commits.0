From: akpm@linux-foundation.org
Subject: - powerpc-implement-pte_special.patch removed from -mm tree
Date: Mon, 28 Jul 2008 14:11:54 -0700
Message-ID: <200807282111.m6SLBsXp027727@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57203 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756977AbYG1VZx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 17:25:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, a.p.zijlstra@chello.nl, benh@kernel.crashing.org, hugh@veritas.com, paulmck@us.ibm.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     powerpc: implement pte_special
has been removed from the -mm tree.  Its filename was
     powerpc-implement-pte_special.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc: implement pte_special
From: Nick Piggin <npiggin@suse.de>

Implement PTE_SPECIAL for powerpc.  At the moment I only have a spare bit
for the 4k pages config, but Ben has freed up another one for 64k pages
that I can use, so this patch should include that before it goes upstream.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Reviewed-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-powerpc/pgtable-4k.h    |    2 ++
 include/asm-powerpc/pgtable-64k.h   |    2 ++
 include/asm-powerpc/pgtable-ppc64.h |    4 ++--
 3 files changed, 6 insertions(+), 2 deletions(-)

diff -puN include/asm-powerpc/pgtable-4k.h~powerpc-implement-pte_special include/asm-powerpc/pgtable-4k.h
--- a/include/asm-powerpc/pgtable-4k.h~powerpc-implement-pte_special
+++ a/include/asm-powerpc/pgtable-4k.h
@@ -46,6 +46,8 @@
 #define _PAGE_GROUP_IX  0x7000 /* software: HPTE index within group */
 #define _PAGE_F_SECOND  _PAGE_SECONDARY
 #define _PAGE_F_GIX     _PAGE_GROUP_IX
+#define _PAGE_SPECIAL	0x10000 /* software: special page */
+#define __HAVE_ARCH_PTE_SPECIAL
 
 /* PTE flags to conserve for HPTE identification */
 #define _PAGE_HPTEFLAGS (_PAGE_BUSY | _PAGE_HASHPTE | \
diff -puN include/asm-powerpc/pgtable-64k.h~powerpc-implement-pte_special include/asm-powerpc/pgtable-64k.h
--- a/include/asm-powerpc/pgtable-64k.h~powerpc-implement-pte_special
+++ a/include/asm-powerpc/pgtable-64k.h
@@ -70,6 +70,8 @@ static inline struct subpage_prot_table 
 #define PGDIR_MASK	(~(PGDIR_SIZE-1))
 
 /* Additional PTE bits (don't change without checking asm in hash_low.S) */
+#define __HAVE_ARCH_PTE_SPECIAL
+#define _PAGE_SPECIAL	0x00000400 /* software: special page */
 #define _PAGE_HPTE_SUB	0x0ffff000 /* combo only: sub pages HPTE bits */
 #define _PAGE_HPTE_SUB0	0x08000000 /* combo only: first sub page */
 #define _PAGE_COMBO	0x10000000 /* this is a combo 4k page */
diff -puN include/asm-powerpc/pgtable-ppc64.h~powerpc-implement-pte_special include/asm-powerpc/pgtable-ppc64.h
--- a/include/asm-powerpc/pgtable-ppc64.h~powerpc-implement-pte_special
+++ a/include/asm-powerpc/pgtable-ppc64.h
@@ -245,7 +245,7 @@ static inline int pte_write(pte_t pte) {
 static inline int pte_dirty(pte_t pte) { return pte_val(pte) & _PAGE_DIRTY;}
 static inline int pte_young(pte_t pte) { return pte_val(pte) & _PAGE_ACCESSED;}
 static inline int pte_file(pte_t pte) { return pte_val(pte) & _PAGE_FILE;}
-static inline int pte_special(pte_t pte) { return 0; }
+static inline int pte_special(pte_t pte) { return pte_val(pte) & _PAGE_SPECIAL; }
 
 static inline void pte_uncache(pte_t pte) { pte_val(pte) |= _PAGE_NO_CACHE; }
 static inline void pte_cache(pte_t pte)   { pte_val(pte) &= ~_PAGE_NO_CACHE; }
@@ -265,7 +265,7 @@ static inline pte_t pte_mkyoung(pte_t pt
 static inline pte_t pte_mkhuge(pte_t pte) {
 	return pte; }
 static inline pte_t pte_mkspecial(pte_t pte) {
-	return pte; }
+	pte_val(pte) |= _PAGE_SPECIAL; return pte; }
 static inline unsigned long pte_pgprot(pte_t pte)
 {
 	return __pgprot(pte_val(pte)) & PAGE_PROT_BITS;
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifier-core.patch
linux-next.patch
mmu-notifiers-add-mm_take_all_locks-operation-fix.patch
powerpc-lockless-get_user_pages.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
vmscan-move-isolate_lru_page-to-vmscanc-fix.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-bdi_cap_swap_backed.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch
mlock-mlocked-pages-are-unevictable-fix-3.patch
mlock-mlocked-pages-are-unevictable-fix-fix-munlock-page-table-walk-now-requires-mm.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch
vmstat-mlocked-pages-statistics.patch
vmstat-mlocked-pages-statistics-fix-incorrect-mlocked-field-of-proc-meminfo.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch

