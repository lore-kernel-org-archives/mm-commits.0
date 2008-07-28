From: akpm@linux-foundation.org
Subject: - powerpc-implement-pte_special-update.patch removed from -mm tree
Date: Sun, 27 Jul 2008 20:27:26 -0700
Message-ID: <200807280327.m6S3RQM1017942@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41441 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752160AbYG1D1w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jul 2008 23:27:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, a.p.zijlstra@chello.nl, benh@kernel.crashing.org, hugh@veritas.com, paulmck@us.ibm.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     powerpc: implement pte_special for 64K pages
has been removed from the -mm tree.  Its filename was
     powerpc-implement-pte_special-update.patch

This patch was dropped because it was folded into powerpc-implement-pte_special.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc: implement pte_special for 64K pages
From: Nick Piggin <npiggin@suse.de>

Ben has now freed up a pte bit on 64k pages. Use it for special pte bit.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
CcPeter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-powerpc/pgtable-64k.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/asm-powerpc/pgtable-64k.h~powerpc-implement-pte_special-update include/asm-powerpc/pgtable-64k.h
--- a/include/asm-powerpc/pgtable-64k.h~powerpc-implement-pte_special-update
+++ a/include/asm-powerpc/pgtable-64k.h
@@ -70,11 +70,12 @@ static inline struct subpage_prot_table 
 #define PGDIR_MASK	(~(PGDIR_SIZE-1))
 
 /* Additional PTE bits (don't change without checking asm in hash_low.S) */
+#define __HAVE_ARCH_PTE_SPECIAL
+#define _PAGE_SPECIAL	0x00000400 /* software: special page */
 #define _PAGE_HPTE_SUB	0x0ffff000 /* combo only: sub pages HPTE bits */
 #define _PAGE_HPTE_SUB0	0x08000000 /* combo only: first sub page */
 #define _PAGE_COMBO	0x10000000 /* this is a combo 4k page */
 #define _PAGE_4K_PFN	0x20000000 /* PFN is for a single 4k page */
-#define _PAGE_SPECIAL	0x0	   /* don't have enough room for this yet */
 
 /* For 64K page, we don't have a separate _PAGE_HASHPTE bit. Instead,
  * we set that to be the whole sub-bits mask. The C code will only
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifier-core.patch
linux-next.patch
mmu-notifiers-add-mm_take_all_locks-operation-fix.patch
powerpc-implement-pte_special.patch
powerpc-implement-pte_special-update.patch
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

