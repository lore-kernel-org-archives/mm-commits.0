From: akpm@linux-foundation.org
Subject: [patch 17/18] mm: page_vma_mapped: ensure pmd is loaded with
 READ_ONCE outside of lock
Date: Fri, 13 Oct 2017 15:58:25 -0700
Message-ID: <59e14511.eLRptBeL+6bECu9A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40284 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753089AbdJMW61 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Oct 2017 18:58:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, will.deacon@arm.com, kirill.shutemov@linux.intel.com, paulmck@linux.vnet.ibm.com, peterz@infradead.org, rruigrok@codeaurora.org, stable@vger.kernel.org, ynorov@caviumnetworks.com

From: Will Deacon <will.deacon@arm.com>
Subject: mm: page_vma_mapped: ensure pmd is loaded with READ_ONCE outside of lock

Loading the pmd without holding the pmd_lock exposes us to races with
concurrent updaters of the page tables but, worse still, it also allows
the compiler to cache the pmd value in a register and reuse it later on,
even if we've performed a READ_ONCE in between and seen a more recent
value.

In the case of page_vma_mapped_walk, this leads to the following crash
when the pmd loaded for the initial pmd_trans_huge check is all zeroes and
a subsequent valid table entry is loaded by check_pmd.  We then proceed
into map_pte, but the compiler re-uses the zero entry inside
pte_offset_map, resulting in a junk pointer being installed in pvmw->pte:

[  254.032812] PC is at check_pte+0x20/0x170
[  254.032948] LR is at page_vma_mapped_walk+0x2e0/0x540
[...]
[  254.036114] Process doio (pid: 2463, stack limit = 0xffff00000f2e8000)
[  254.036361] Call trace:
[  254.038977] [<ffff000008233328>] check_pte+0x20/0x170
[  254.039137] [<ffff000008233758>] page_vma_mapped_walk+0x2e0/0x540
[  254.039332] [<ffff000008234adc>] page_mkclean_one+0xac/0x278
[  254.039489] [<ffff000008234d98>] rmap_walk_file+0xf0/0x238
[  254.039642] [<ffff000008236e74>] rmap_walk+0x64/0xa0
[  254.039784] [<ffff0000082370c8>] page_mkclean+0x90/0xa8
[  254.040029] [<ffff0000081f3c64>] clear_page_dirty_for_io+0x84/0x2a8
[  254.040311] [<ffff00000832f984>] mpage_submit_page+0x34/0x98
[  254.040518] [<ffff00000832fb4c>] mpage_process_page_bufs+0x164/0x170
[  254.040743] [<ffff00000832fc8c>] mpage_prepare_extent_to_map+0x134/0x2b8
[  254.040969] [<ffff00000833530c>] ext4_writepages+0x484/0xe30
[  254.041175] [<ffff0000081f6ab4>] do_writepages+0x44/0xe8
[  254.041372] [<ffff0000081e5bd4>] __filemap_fdatawrite_range+0xbc/0x110
[  254.041568] [<ffff0000081e5e68>] file_write_and_wait_range+0x48/0xd8
[  254.041739] [<ffff000008324310>] ext4_sync_file+0x80/0x4b8
[  254.041907] [<ffff0000082bd434>] vfs_fsync_range+0x64/0xc0
[  254.042106] [<ffff0000082332b4>] SyS_msync+0x194/0x1e8

This patch fixes the problem by ensuring that READ_ONCE is used before the
initial checks on the pmd, and this value is subsequently used when
checking whether or not the pmd is present.  pmd_check is removed and the
pmd_present check is inlined directly.

Link: http://lkml.kernel.org/r/1507222630-5839-1-git-send-email-will.deacon@arm.com
Fixes: f27176cfc363 ("mm: convert page_mkclean_one() to use page_vma_mapped_walk()")
Signed-off-by: Will Deacon <will.deacon@arm.com>
Tested-by: Yury Norov <ynorov@caviumnetworks.com>
Tested-by: Richard Ruigrok <rruigrok@codeaurora.org>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_vma_mapped.c |   25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff -puN mm/page_vma_mapped.c~mm-page_vma_mapped-ensure-pmd-is-loaded-with-read_once-outside-of-lock mm/page_vma_mapped.c
--- a/mm/page_vma_mapped.c~mm-page_vma_mapped-ensure-pmd-is-loaded-with-read_once-outside-of-lock
+++ a/mm/page_vma_mapped.c
@@ -6,17 +6,6 @@
 
 #include "internal.h"
 
-static inline bool check_pmd(struct page_vma_mapped_walk *pvmw)
-{
-	pmd_t pmde;
-	/*
-	 * Make sure we don't re-load pmd between present and !trans_huge check.
-	 * We need a consistent view.
-	 */
-	pmde = READ_ONCE(*pvmw->pmd);
-	return pmd_present(pmde) && !pmd_trans_huge(pmde);
-}
-
 static inline bool not_found(struct page_vma_mapped_walk *pvmw)
 {
 	page_vma_mapped_walk_done(pvmw);
@@ -116,6 +105,7 @@ bool page_vma_mapped_walk(struct page_vm
 	pgd_t *pgd;
 	p4d_t *p4d;
 	pud_t *pud;
+	pmd_t pmde;
 
 	/* The only possible pmd mapping has been handled on last iteration */
 	if (pvmw->pmd && !pvmw->pte)
@@ -148,7 +138,13 @@ restart:
 	if (!pud_present(*pud))
 		return false;
 	pvmw->pmd = pmd_offset(pud, pvmw->address);
-	if (pmd_trans_huge(*pvmw->pmd) || is_pmd_migration_entry(*pvmw->pmd)) {
+	/*
+	 * Make sure the pmd value isn't cached in a register by the
+	 * compiler and used as a stale value after we've observed a
+	 * subsequent update.
+	 */
+	pmde = READ_ONCE(*pvmw->pmd);
+	if (pmd_trans_huge(pmde) || is_pmd_migration_entry(pmde)) {
 		pvmw->ptl = pmd_lock(mm, pvmw->pmd);
 		if (likely(pmd_trans_huge(*pvmw->pmd))) {
 			if (pvmw->flags & PVMW_MIGRATION)
@@ -174,9 +170,8 @@ restart:
 			spin_unlock(pvmw->ptl);
 			pvmw->ptl = NULL;
 		}
-	} else {
-		if (!check_pmd(pvmw))
-			return false;
+	} else if (!pmd_present(pmde)) {
+		return false;
 	}
 	if (!map_pte(pvmw))
 		goto next_pte;
_
