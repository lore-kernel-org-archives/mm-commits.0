From: akpm@linux-foundation.org
Subject: - page_mkwrite-race-fix.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:46:12 -0800
Message-ID: <200702112246.l1BMkCqp015473@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59472 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932609AbXBKWqQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:46:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     page_mkwrite caller race fix
has been removed from the -mm tree.  Its filename was
     page_mkwrite-race-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: page_mkwrite caller race fix
From: Hugh Dickins <hugh@veritas.com>

After do_wp_page has tested page_mkwrite, it must release old_page after
acquiring page table lock, not before: at some stage that ordering got
reversed, leaving a (very unlikely) window in which old_page might be
truncated, freed, and reused in the same position.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Acked-by: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/memory.c~page_mkwrite-race-fix mm/memory.c
--- a/mm/memory.c~page_mkwrite-race-fix
+++ a/mm/memory.c
@@ -1531,8 +1531,6 @@ static int do_wp_page(struct mm_struct *
 			if (vma->vm_ops->page_mkwrite(vma, old_page) < 0)
 				goto unwritable_page;
 
-			page_cache_release(old_page);
-
 			/*
 			 * Since we dropped the lock we need to revalidate
 			 * the PTE as someone else may have changed it.  If
@@ -1541,6 +1539,7 @@ static int do_wp_page(struct mm_struct *
 			 */
 			page_table = pte_offset_map_lock(mm, pmd, address,
 							 &ptl);
+			page_cache_release(old_page);
 			if (!pte_same(*page_table, orig_pte))
 				goto unlock;
 		}
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
add-vm_insert_pfn.patch
mm-vm_insert_pfn-tidy.patch
add-nopfn_refault-result-from-vm_ops-nopfn.patch
mm-mincore-anon.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
ext2-reservations.patch
ext2-balloc-fix-_with_rsv-freeze.patch
ext2-balloc-reset-windowsz-when-full.patch
ext2-balloc-fix-off-by-one-against-rsv_end.patch
ext2-balloc-fix-off-by-one-against-grp_goal.patch
ext2-balloc-say-rb_entry-not-list_entry.patch
ext2-balloc-use-io_error-label.patch
