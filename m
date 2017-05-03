From: akpm@linux-foundation.org
Subject: [patch 055/102] mm: make rmap_walk() return void
Date: Wed, 03 May 2017 14:54:23 -0700
Message-ID: <20170503215423.fa1Vu3m1z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50712 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751216AbdECVzw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:55:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, torvalds@linux-foundation.org, vbabka@suse.cz

From: Minchan Kim <minchan@kernel.org>
Subject: mm: make rmap_walk() return void

There is no user of the return value from rmap_walk() and friends so this
patch makes them void-returning functions.

Link: http://lkml.kernel.org/r/1489555493-14659-9-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ksm.h  |    5 ++---
 include/linux/rmap.h |    4 ++--
 mm/ksm.c             |   16 ++++++----------
 mm/rmap.c            |   32 +++++++++++++-------------------
 4 files changed, 23 insertions(+), 34 deletions(-)

diff -puN include/linux/ksm.h~mm-make-rmap_walk-void-function include/linux/ksm.h
--- a/include/linux/ksm.h~mm-make-rmap_walk-void-function
+++ a/include/linux/ksm.h
@@ -61,7 +61,7 @@ static inline void set_page_stable_node(
 struct page *ksm_might_need_to_copy(struct page *page,
 			struct vm_area_struct *vma, unsigned long address);
 
-int rmap_walk_ksm(struct page *page, struct rmap_walk_control *rwc);
+void rmap_walk_ksm(struct page *page, struct rmap_walk_control *rwc);
 void ksm_migrate_page(struct page *newpage, struct page *oldpage);
 
 #else  /* !CONFIG_KSM */
@@ -94,10 +94,9 @@ static inline int page_referenced_ksm(st
 	return 0;
 }
 
-static inline int rmap_walk_ksm(struct page *page,
+static inline void rmap_walk_ksm(struct page *page,
 			struct rmap_walk_control *rwc)
 {
-	return 0;
 }
 
 static inline void ksm_migrate_page(struct page *newpage, struct page *oldpage)
diff -puN include/linux/rmap.h~mm-make-rmap_walk-void-function include/linux/rmap.h
--- a/include/linux/rmap.h~mm-make-rmap_walk-void-function
+++ a/include/linux/rmap.h
@@ -264,8 +264,8 @@ struct rmap_walk_control {
 	bool (*invalid_vma)(struct vm_area_struct *vma, void *arg);
 };
 
-int rmap_walk(struct page *page, struct rmap_walk_control *rwc);
-int rmap_walk_locked(struct page *page, struct rmap_walk_control *rwc);
+void rmap_walk(struct page *page, struct rmap_walk_control *rwc);
+void rmap_walk_locked(struct page *page, struct rmap_walk_control *rwc);
 
 #else	/* !CONFIG_MMU */
 
diff -puN mm/ksm.c~mm-make-rmap_walk-void-function mm/ksm.c
--- a/mm/ksm.c~mm-make-rmap_walk-void-function
+++ a/mm/ksm.c
@@ -1933,11 +1933,10 @@ struct page *ksm_might_need_to_copy(stru
 	return new_page;
 }
 
-int rmap_walk_ksm(struct page *page, struct rmap_walk_control *rwc)
+void rmap_walk_ksm(struct page *page, struct rmap_walk_control *rwc)
 {
 	struct stable_node *stable_node;
 	struct rmap_item *rmap_item;
-	int ret = SWAP_AGAIN;
 	int search_new_forks = 0;
 
 	VM_BUG_ON_PAGE(!PageKsm(page), page);
@@ -1950,7 +1949,7 @@ int rmap_walk_ksm(struct page *page, str
 
 	stable_node = page_stable_node(page);
 	if (!stable_node)
-		return ret;
+		return;
 again:
 	hlist_for_each_entry(rmap_item, &stable_node->hlist, hlist) {
 		struct anon_vma *anon_vma = rmap_item->anon_vma;
@@ -1978,23 +1977,20 @@ again:
 			if (rwc->invalid_vma && rwc->invalid_vma(vma, rwc->arg))
 				continue;
 
-			ret = rwc->rmap_one(page, vma,
-					rmap_item->address, rwc->arg);
-			if (ret != SWAP_AGAIN) {
+			if (SWAP_AGAIN != rwc->rmap_one(page, vma,
+					rmap_item->address, rwc->arg)) {
 				anon_vma_unlock_read(anon_vma);
-				goto out;
+				return;
 			}
 			if (rwc->done && rwc->done(page)) {
 				anon_vma_unlock_read(anon_vma);
-				goto out;
+				return;
 			}
 		}
 		anon_vma_unlock_read(anon_vma);
 	}
 	if (!search_new_forks++)
 		goto again;
-out:
-	return ret;
 }
 
 #ifdef CONFIG_MIGRATION
diff -puN mm/rmap.c~mm-make-rmap_walk-void-function mm/rmap.c
--- a/mm/rmap.c~mm-make-rmap_walk-void-function
+++ a/mm/rmap.c
@@ -1607,13 +1607,12 @@ static struct anon_vma *rmap_walk_anon_l
  * vm_flags for that VMA.  That should be OK, because that vma shouldn't be
  * LOCKED.
  */
-static int rmap_walk_anon(struct page *page, struct rmap_walk_control *rwc,
+static void rmap_walk_anon(struct page *page, struct rmap_walk_control *rwc,
 		bool locked)
 {
 	struct anon_vma *anon_vma;
 	pgoff_t pgoff_start, pgoff_end;
 	struct anon_vma_chain *avc;
-	int ret = SWAP_AGAIN;
 
 	if (locked) {
 		anon_vma = page_anon_vma(page);
@@ -1623,7 +1622,7 @@ static int rmap_walk_anon(struct page *p
 		anon_vma = rmap_walk_anon_lock(page, rwc);
 	}
 	if (!anon_vma)
-		return ret;
+		return;
 
 	pgoff_start = page_to_pgoff(page);
 	pgoff_end = pgoff_start + hpage_nr_pages(page) - 1;
@@ -1637,8 +1636,7 @@ static int rmap_walk_anon(struct page *p
 		if (rwc->invalid_vma && rwc->invalid_vma(vma, rwc->arg))
 			continue;
 
-		ret = rwc->rmap_one(page, vma, address, rwc->arg);
-		if (ret != SWAP_AGAIN)
+		if (SWAP_AGAIN != rwc->rmap_one(page, vma, address, rwc->arg))
 			break;
 		if (rwc->done && rwc->done(page))
 			break;
@@ -1646,7 +1644,6 @@ static int rmap_walk_anon(struct page *p
 
 	if (!locked)
 		anon_vma_unlock_read(anon_vma);
-	return ret;
 }
 
 /*
@@ -1662,13 +1659,12 @@ static int rmap_walk_anon(struct page *p
  * vm_flags for that VMA.  That should be OK, because that vma shouldn't be
  * LOCKED.
  */
-static int rmap_walk_file(struct page *page, struct rmap_walk_control *rwc,
+static void rmap_walk_file(struct page *page, struct rmap_walk_control *rwc,
 		bool locked)
 {
 	struct address_space *mapping = page_mapping(page);
 	pgoff_t pgoff_start, pgoff_end;
 	struct vm_area_struct *vma;
-	int ret = SWAP_AGAIN;
 
 	/*
 	 * The page lock not only makes sure that page->mapping cannot
@@ -1679,7 +1675,7 @@ static int rmap_walk_file(struct page *p
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 
 	if (!mapping)
-		return ret;
+		return;
 
 	pgoff_start = page_to_pgoff(page);
 	pgoff_end = pgoff_start + hpage_nr_pages(page) - 1;
@@ -1694,8 +1690,7 @@ static int rmap_walk_file(struct page *p
 		if (rwc->invalid_vma && rwc->invalid_vma(vma, rwc->arg))
 			continue;
 
-		ret = rwc->rmap_one(page, vma, address, rwc->arg);
-		if (ret != SWAP_AGAIN)
+		if (SWAP_AGAIN != rwc->rmap_one(page, vma, address, rwc->arg))
 			goto done;
 		if (rwc->done && rwc->done(page))
 			goto done;
@@ -1704,28 +1699,27 @@ static int rmap_walk_file(struct page *p
 done:
 	if (!locked)
 		i_mmap_unlock_read(mapping);
-	return ret;
 }
 
-int rmap_walk(struct page *page, struct rmap_walk_control *rwc)
+void rmap_walk(struct page *page, struct rmap_walk_control *rwc)
 {
 	if (unlikely(PageKsm(page)))
-		return rmap_walk_ksm(page, rwc);
+		rmap_walk_ksm(page, rwc);
 	else if (PageAnon(page))
-		return rmap_walk_anon(page, rwc, false);
+		rmap_walk_anon(page, rwc, false);
 	else
-		return rmap_walk_file(page, rwc, false);
+		rmap_walk_file(page, rwc, false);
 }
 
 /* Like rmap_walk, but caller holds relevant rmap lock */
-int rmap_walk_locked(struct page *page, struct rmap_walk_control *rwc)
+void rmap_walk_locked(struct page *page, struct rmap_walk_control *rwc)
 {
 	/* no ksm support for now */
 	VM_BUG_ON_PAGE(PageKsm(page), page);
 	if (PageAnon(page))
-		return rmap_walk_anon(page, rwc, true);
+		rmap_walk_anon(page, rwc, true);
 	else
-		return rmap_walk_file(page, rwc, true);
+		rmap_walk_file(page, rwc, true);
 }
 
 #ifdef CONFIG_HUGETLB_PAGE
_
