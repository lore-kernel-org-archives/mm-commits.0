From: akpm@linux-foundation.org
Subject: [merged]
 mm-page-migration-use-migration-entry-for-swapcache-too.patch removed from
 -mm tree
Date: Fri, 06 Nov 2015 12:16:52 -0800
Message-ID: <563d0ab4.ZPPOnmk93ePShcss%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49025 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032012AbbKFUQx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:16:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, cl@linux.com, dave@stgolabs.net, dvyukov@google.com, gorcunov@openvz.org, kirill.shutemov@linux.intel.com, kosaki.motohiro@jp.fujitsu.com, oleg@redhat.com, riel@redhat.com, sasha.levin@oracle.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page migration use migration entry for swapcache too
has been removed from the -mm tree.  Its filename was
     mm-page-migration-use-migration-entry-for-swapcache-too.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: page migration use migration entry for swapcache too

Hitherto page migration has avoided using a migration entry for a
swapcache page mapped into userspace, apparently for historical reasons. 
So any page blessed with swapcache would entail a minor fault when it's
next touched, which page migration otherwise tries to avoid.  Swapcache in
an mlocked area is rare, so won't often matter, but still better fixed.

Just rearrange the block in try_to_unmap_one(), to handle TTU_MIGRATION
before checking PageAnon, that's all (apart from some reindenting).

Well, no, that's not quite all: doesn't this by the way fix a soft_dirty
bug, that page migration of a file page was forgetting to transfer the
soft_dirty bit?  Probably not a serious bug: if I understand correctly,
soft_dirty afficionados usually have to handle file pages separately
anyway; but we publish the bit in /proc/<pid>/pagemap on file mappings as
well as anonymous, so page migration ought not to perturb it.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   63 ++++++++++++++++++++++++----------------------------
 1 file changed, 30 insertions(+), 33 deletions(-)

diff -puN mm/rmap.c~mm-page-migration-use-migration-entry-for-swapcache-too mm/rmap.c
--- a/mm/rmap.c~mm-page-migration-use-migration-entry-for-swapcache-too
+++ a/mm/rmap.c
@@ -1379,47 +1379,44 @@ static int try_to_unmap_one(struct page
 			dec_mm_counter(mm, MM_ANONPAGES);
 		else
 			dec_mm_counter(mm, MM_FILEPAGES);
+	} else if (IS_ENABLED(CONFIG_MIGRATION) && (flags & TTU_MIGRATION)) {
+		swp_entry_t entry;
+		pte_t swp_pte;
+		/*
+		 * Store the pfn of the page in a special migration
+		 * pte. do_swap_page() will wait until the migration
+		 * pte is removed and then restart fault handling.
+		 */
+		entry = make_migration_entry(page, pte_write(pteval));
+		swp_pte = swp_entry_to_pte(entry);
+		if (pte_soft_dirty(pteval))
+			swp_pte = pte_swp_mksoft_dirty(swp_pte);
+		set_pte_at(mm, address, pte, swp_pte);
 	} else if (PageAnon(page)) {
 		swp_entry_t entry = { .val = page_private(page) };
 		pte_t swp_pte;
-
-		if (PageSwapCache(page)) {
-			/*
-			 * Store the swap location in the pte.
-			 * See handle_pte_fault() ...
-			 */
-			if (swap_duplicate(entry) < 0) {
-				set_pte_at(mm, address, pte, pteval);
-				ret = SWAP_FAIL;
-				goto out_unmap;
-			}
-			if (list_empty(&mm->mmlist)) {
-				spin_lock(&mmlist_lock);
-				if (list_empty(&mm->mmlist))
-					list_add(&mm->mmlist, &init_mm.mmlist);
-				spin_unlock(&mmlist_lock);
-			}
-			dec_mm_counter(mm, MM_ANONPAGES);
-			inc_mm_counter(mm, MM_SWAPENTS);
-		} else if (IS_ENABLED(CONFIG_MIGRATION)) {
-			/*
-			 * Store the pfn of the page in a special migration
-			 * pte. do_swap_page() will wait until the migration
-			 * pte is removed and then restart fault handling.
-			 */
-			BUG_ON(!(flags & TTU_MIGRATION));
-			entry = make_migration_entry(page, pte_write(pteval));
+		/*
+		 * Store the swap location in the pte.
+		 * See handle_pte_fault() ...
+		 */
+		VM_BUG_ON_PAGE(!PageSwapCache(page), page);
+		if (swap_duplicate(entry) < 0) {
+			set_pte_at(mm, address, pte, pteval);
+			ret = SWAP_FAIL;
+			goto out_unmap;
 		}
+		if (list_empty(&mm->mmlist)) {
+			spin_lock(&mmlist_lock);
+			if (list_empty(&mm->mmlist))
+				list_add(&mm->mmlist, &init_mm.mmlist);
+			spin_unlock(&mmlist_lock);
+		}
+		dec_mm_counter(mm, MM_ANONPAGES);
+		inc_mm_counter(mm, MM_SWAPENTS);
 		swp_pte = swp_entry_to_pte(entry);
 		if (pte_soft_dirty(pteval))
 			swp_pte = pte_swp_mksoft_dirty(swp_pte);
 		set_pte_at(mm, address, pte, swp_pte);
-	} else if (IS_ENABLED(CONFIG_MIGRATION) &&
-		   (flags & TTU_MIGRATION)) {
-		/* Establish migration entry for a file page */
-		swp_entry_t entry;
-		entry = make_migration_entry(page, pte_write(pteval));
-		set_pte_at(mm, address, pte, swp_entry_to_pte(entry));
 	} else
 		dec_mm_counter(mm, MM_FILEPAGES);
 
_

Patches currently in -mm which might be from hughd@google.com are

osd-fs-__r4w_get_page-rely-on-pageuptodate-for-uptodate.patch
mm-use-unsigned-int-for-page-order-fix-2.patch

