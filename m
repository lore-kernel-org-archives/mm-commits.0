From: akpm@linux-foundation.org
Subject: [merged]
 hugetlb-fix-copy_hugetlb_page_range-to-handle-migration-hwpoisoned-entry.patch removed from -mm tree
Date: Tue, 24 Jun 2014 12:02:17 -0700
Message-ID: <53a9cb39.xYTKoSNcXrLsZy6r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35568 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbaFXTCS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jun 2014 15:02:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, cl@linux.com, hughd@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: fix copy_hugetlb_page_range() to handle migration/hwpoisoned entry
has been removed from the -mm tree.  Its filename was
     hugetlb-fix-copy_hugetlb_page_range-to-handle-migration-hwpoisoned-entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: hugetlb: fix copy_hugetlb_page_range() to handle migration/hwpoisoned entry

There's a race between fork() and hugepage migration, as a result we try
to "dereference" a swap entry as a normal pte, causing kernel panic.  The
cause of the problem is that copy_hugetlb_page_range() can't handle "swap
entry" family (migration entry and hwpoisoned entry,) so let's fix it.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: <stable@vger.kernel.org>	[2.6.37+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   71 +++++++++++++++++++++++++++++--------------------
 1 file changed, 43 insertions(+), 28 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-fix-copy_hugetlb_page_range-to-handle-migration-hwpoisoned-entry mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-fix-copy_hugetlb_page_range-to-handle-migration-hwpoisoned-entry
+++ a/mm/hugetlb.c
@@ -2520,6 +2520,31 @@ static void set_huge_ptep_writable(struc
 		update_mmu_cache(vma, address, ptep);
 }
 
+static int is_hugetlb_entry_migration(pte_t pte)
+{
+	swp_entry_t swp;
+
+	if (huge_pte_none(pte) || pte_present(pte))
+		return 0;
+	swp = pte_to_swp_entry(pte);
+	if (non_swap_entry(swp) && is_migration_entry(swp))
+		return 1;
+	else
+		return 0;
+}
+
+static int is_hugetlb_entry_hwpoisoned(pte_t pte)
+{
+	swp_entry_t swp;
+
+	if (huge_pte_none(pte) || pte_present(pte))
+		return 0;
+	swp = pte_to_swp_entry(pte);
+	if (non_swap_entry(swp) && is_hwpoison_entry(swp))
+		return 1;
+	else
+		return 0;
+}
 
 int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 			    struct vm_area_struct *vma)
@@ -2559,10 +2584,26 @@ int copy_hugetlb_page_range(struct mm_st
 		dst_ptl = huge_pte_lock(h, dst, dst_pte);
 		src_ptl = huge_pte_lockptr(h, src, src_pte);
 		spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
-		if (!huge_pte_none(huge_ptep_get(src_pte))) {
+		entry = huge_ptep_get(src_pte);
+		if (huge_pte_none(entry)) { /* skip none entry */
+			;
+		} else if (unlikely(is_hugetlb_entry_migration(entry) ||
+				    is_hugetlb_entry_hwpoisoned(entry))) {
+			swp_entry_t swp_entry = pte_to_swp_entry(entry);
+
+			if (is_write_migration_entry(swp_entry) && cow) {
+				/*
+				 * COW mappings require pages in both
+				 * parent and child to be set to read.
+				 */
+				make_migration_entry_read(&swp_entry);
+				entry = swp_entry_to_pte(swp_entry);
+				set_huge_pte_at(src, addr, src_pte, entry);
+			}
+			set_huge_pte_at(dst, addr, dst_pte, entry);
+		} else {
 			if (cow)
 				huge_ptep_set_wrprotect(src, addr, src_pte);
-			entry = huge_ptep_get(src_pte);
 			ptepage = pte_page(entry);
 			get_page(ptepage);
 			page_dup_rmap(ptepage);
@@ -2578,32 +2619,6 @@ int copy_hugetlb_page_range(struct mm_st
 	return ret;
 }
 
-static int is_hugetlb_entry_migration(pte_t pte)
-{
-	swp_entry_t swp;
-
-	if (huge_pte_none(pte) || pte_present(pte))
-		return 0;
-	swp = pte_to_swp_entry(pte);
-	if (non_swap_entry(swp) && is_migration_entry(swp))
-		return 1;
-	else
-		return 0;
-}
-
-static int is_hugetlb_entry_hwpoisoned(pte_t pte)
-{
-	swp_entry_t swp;
-
-	if (huge_pte_none(pte) || pte_present(pte))
-		return 0;
-	swp = pte_to_swp_entry(pte);
-	if (non_swap_entry(swp) && is_hwpoison_entry(swp))
-		return 1;
-	else
-		return 0;
-}
