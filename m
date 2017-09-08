From: akpm@linux-foundation.org
Subject: [patch 008/126] mm: mempolicy: mbind and migrate_pages
 support thp migration
Date: Fri, 08 Sep 2017 16:11:08 -0700
Message-ID: <20170908231108.NssPzrZgC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51078 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757223AbdIHXLK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:11:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, dave.hansen@intel.com, dnellans@nvidia.com, hpa@zytor.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, mhocko@kernel.org, minchan@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, tglx@linutronix.de, torvalds@linux-foundation.org, vbabka@suse.cz, zi.yan@cs.rutgers.edu

From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: mempolicy: mbind and migrate_pages support thp migration

This patch enables thp migration for mbind(2) and migrate_pages(2).

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Zi Yan <zi.yan@cs.rutgers.edu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Nellans <dnellans@nvidia.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |  108 ++++++++++++++++++++++++++++++++++-------------
 1 file changed, 79 insertions(+), 29 deletions(-)

diff -puN mm/mempolicy.c~mm-mempolicy-mbind-and-migrate_pages-support-thp-migration mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicy-mbind-and-migrate_pages-support-thp-migration
+++ a/mm/mempolicy.c
@@ -97,6 +97,7 @@
 #include <linux/mm_inline.h>
 #include <linux/mmu_notifier.h>
 #include <linux/printk.h>
+#include <linux/swapops.h>
 
 #include <asm/tlbflush.h>
 #include <linux/uaccess.h>
@@ -426,6 +427,49 @@ static inline bool queue_pages_required(
 	return node_isset(nid, *qp->nmask) == !(flags & MPOL_MF_INVERT);
 }
 
+static int queue_pages_pmd(pmd_t *pmd, spinlock_t *ptl, unsigned long addr,
+				unsigned long end, struct mm_walk *walk)
+{
+	int ret = 0;
+	struct page *page;
+	struct queue_pages *qp = walk->private;
+	unsigned long flags;
+
+	if (unlikely(is_pmd_migration_entry(*pmd))) {
+		ret = 1;
+		goto unlock;
+	}
+	page = pmd_page(*pmd);
+	if (is_huge_zero_page(page)) {
+		spin_unlock(ptl);
+		__split_huge_pmd(walk->vma, pmd, addr, false, NULL);
+		goto out;
+	}
+	if (!thp_migration_supported()) {
+		get_page(page);
+		spin_unlock(ptl);
+		lock_page(page);
+		ret = split_huge_page(page);
+		unlock_page(page);
+		put_page(page);
+		goto out;
+	}
+	if (!queue_pages_required(page, qp)) {
+		ret = 1;
+		goto unlock;
+	}
+
+	ret = 1;
+	flags = qp->flags;
+	/* go to thp migration */
+	if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL))
+		migrate_page_add(page, qp->pagelist, flags);
+unlock:
+	spin_unlock(ptl);
+out:
+	return ret;
+}
+
 /*
  * Scan through pages checking if pages follow certain conditions,
  * and move them to the pagelist if they do.
@@ -437,30 +481,15 @@ static int queue_pages_pte_range(pmd_t *
 	struct page *page;
 	struct queue_pages *qp = walk->private;
 	unsigned long flags = qp->flags;
-	int nid, ret;
+	int ret;
 	pte_t *pte;
 	spinlock_t *ptl;
 
-	if (pmd_trans_huge(*pmd)) {
-		ptl = pmd_lock(walk->mm, pmd);
-		if (pmd_trans_huge(*pmd)) {
-			page = pmd_page(*pmd);
-			if (is_huge_zero_page(page)) {
-				spin_unlock(ptl);
-				__split_huge_pmd(vma, pmd, addr, false, NULL);
-			} else {
-				get_page(page);
-				spin_unlock(ptl);
-				lock_page(page);
-				ret = split_huge_page(page);
-				unlock_page(page);
-				put_page(page);
-				if (ret)
-					return 0;
-			}
-		} else {
-			spin_unlock(ptl);
-		}
+	ptl = pmd_trans_huge_lock(pmd, vma);
+	if (ptl) {
+		ret = queue_pages_pmd(pmd, ptl, addr, end, walk);
+		if (ret)
+			return 0;
 	}
 
 	if (pmd_trans_unstable(pmd))
@@ -481,7 +510,7 @@ retry:
 			continue;
 		if (!queue_pages_required(page, qp))
 			continue;
-		if (PageTransCompound(page)) {
+		if (PageTransCompound(page) && !thp_migration_supported()) {
 			get_page(page);
 			pte_unmap_unlock(pte, ptl);
 			lock_page(page);
@@ -893,19 +922,21 @@ static long do_get_mempolicy(int *policy
 
 #ifdef CONFIG_MIGRATION
 /*
- * page migration
+ * page migration, thp tail pages can be passed.
  */
 static void migrate_page_add(struct page *page, struct list_head *pagelist,
 				unsigned long flags)
 {
+	struct page *head = compound_head(page);
 	/*
 	 * Avoid migrating a page that is shared with others.
 	 */
-	if ((flags & MPOL_MF_MOVE_ALL) || page_mapcount(page) == 1) {
-		if (!isolate_lru_page(page)) {
-			list_add_tail(&page->lru, pagelist);
-			inc_node_page_state(page, NR_ISOLATED_ANON +
-					    page_is_file_cache(page));
+	if ((flags & MPOL_MF_MOVE_ALL) || page_mapcount(head) == 1) {
+		if (!isolate_lru_page(head)) {
+			list_add_tail(&head->lru, pagelist);
+			mod_node_page_state(page_pgdat(head),
+				NR_ISOLATED_ANON + page_is_file_cache(head),
+				hpage_nr_pages(head));
 		}
 	}
 }
@@ -915,7 +946,17 @@ static struct page *new_node_page(struct
 	if (PageHuge(page))
 		return alloc_huge_page_node(page_hstate(compound_head(page)),
 					node);
-	else
+	else if (thp_migration_supported() && PageTransHuge(page)) {
+		struct page *thp;
+
+		thp = alloc_pages_node(node,
+			(GFP_TRANSHUGE | __GFP_THISNODE),
+			HPAGE_PMD_ORDER);
+		if (!thp)
+			return NULL;
+		prep_transhuge_page(thp);
+		return thp;
+	} else
 		return __alloc_pages_node(node, GFP_HIGHUSER_MOVABLE |
 						    __GFP_THISNODE, 0);
 }
@@ -1081,6 +1122,15 @@ static struct page *new_page(struct page
 	if (PageHuge(page)) {
 		BUG_ON(!vma);
 		return alloc_huge_page_noerr(vma, address, 1);
+	} else if (thp_migration_supported() && PageTransHuge(page)) {
+		struct page *thp;
+
+		thp = alloc_hugepage_vma(GFP_TRANSHUGE, vma, address,
+					 HPAGE_PMD_ORDER);
+		if (!thp)
+			return NULL;
+		prep_transhuge_page(thp);
+		return thp;
 	}
 	/*
 	 * if !vma, alloc_page_vma() will use task or system default policy
_
