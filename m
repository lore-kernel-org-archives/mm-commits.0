From: akpm@linux-foundation.org
Subject: [patch 056/102] mm: make rmap_one boolean function
Date: Wed, 03 May 2017 14:54:27 -0700
Message-ID: <20170503215427.85ZZExrFy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51366 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752181AbdECV4Y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:56:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, torvalds@linux-foundation.org, vbabka@suse.cz

From: Minchan Kim <minchan@kernel.org>
Subject: mm: make rmap_one boolean function

rmap_one's return value controls whether rmap_work should contine to scan
other ptes or not so it's target for changing to boolean.  Return true if
the scan should be continued.  Otherwise, return false to stop the
scanning.

This patch makes rmap_one's return value to boolean.

Link: http://lkml.kernel.org/r/1489555493-14659-10-git-send-email-minchan@kernel.org
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

 include/linux/rmap.h |    6 +++++-
 mm/ksm.c             |    2 +-
 mm/migrate.c         |    4 ++--
 mm/page_idle.c       |    4 ++--
 mm/rmap.c            |   30 +++++++++++++++---------------
 5 files changed, 25 insertions(+), 21 deletions(-)

diff -puN include/linux/rmap.h~mm-make-rmap_one-boolean-function include/linux/rmap.h
--- a/include/linux/rmap.h~mm-make-rmap_one-boolean-function
+++ a/include/linux/rmap.h
@@ -257,7 +257,11 @@ int page_mapped_in_vma(struct page *page
  */
 struct rmap_walk_control {
 	void *arg;
-	int (*rmap_one)(struct page *page, struct vm_area_struct *vma,
+	/*
+	 * Return false if page table scanning in rmap_walk should be stopped.
+	 * Otherwise, return true.
+	 */
+	bool (*rmap_one)(struct page *page, struct vm_area_struct *vma,
 					unsigned long addr, void *arg);
 	int (*done)(struct page *page);
 	struct anon_vma *(*anon_lock)(struct page *page);
diff -puN mm/ksm.c~mm-make-rmap_one-boolean-function mm/ksm.c
--- a/mm/ksm.c~mm-make-rmap_one-boolean-function
+++ a/mm/ksm.c
@@ -1977,7 +1977,7 @@ again:
 			if (rwc->invalid_vma && rwc->invalid_vma(vma, rwc->arg))
 				continue;
 
-			if (SWAP_AGAIN != rwc->rmap_one(page, vma,
+			if (!rwc->rmap_one(page, vma,
 					rmap_item->address, rwc->arg)) {
 				anon_vma_unlock_read(anon_vma);
 				return;
diff -puN mm/migrate.c~mm-make-rmap_one-boolean-function mm/migrate.c
--- a/mm/migrate.c~mm-make-rmap_one-boolean-function
+++ a/mm/migrate.c
@@ -194,7 +194,7 @@ void putback_movable_pages(struct list_h
 /*
  * Restore a potential migration pte to a working pte entry
  */
-static int remove_migration_pte(struct page *page, struct vm_area_struct *vma,
+static bool remove_migration_pte(struct page *page, struct vm_area_struct *vma,
 				 unsigned long addr, void *old)
 {
 	struct page_vma_mapped_walk pvmw = {
@@ -253,7 +253,7 @@ static int remove_migration_pte(struct p
 		update_mmu_cache(vma, pvmw.address, pvmw.pte);
 	}
 
-	return SWAP_AGAIN;
+	return true;
 }
 
 /*
diff -puN mm/page_idle.c~mm-make-rmap_one-boolean-function mm/page_idle.c
--- a/mm/page_idle.c~mm-make-rmap_one-boolean-function
+++ a/mm/page_idle.c
@@ -50,7 +50,7 @@ static struct page *page_idle_get_page(u
 	return page;
 }
 
-static int page_idle_clear_pte_refs_one(struct page *page,
+static bool page_idle_clear_pte_refs_one(struct page *page,
 					struct vm_area_struct *vma,
 					unsigned long addr, void *arg)
 {
@@ -84,7 +84,7 @@ static int page_idle_clear_pte_refs_one(
 		 */
 		set_page_young(page);
 	}
-	return SWAP_AGAIN;
+	return true;
 }
 
 static void page_idle_clear_pte_refs(struct page *page)
diff -puN mm/rmap.c~mm-make-rmap_one-boolean-function mm/rmap.c
--- a/mm/rmap.c~mm-make-rmap_one-boolean-function
+++ a/mm/rmap.c
@@ -724,7 +724,7 @@ struct page_referenced_arg {
 /*
  * arg: page_referenced_arg will be passed
  */
-static int page_referenced_one(struct page *page, struct vm_area_struct *vma,
+static bool page_referenced_one(struct page *page, struct vm_area_struct *vma,
 			unsigned long address, void *arg)
 {
 	struct page_referenced_arg *pra = arg;
@@ -741,7 +741,7 @@ static int page_referenced_one(struct pa
 		if (vma->vm_flags & VM_LOCKED) {
 			page_vma_mapped_walk_done(&pvmw);
 			pra->vm_flags |= VM_LOCKED;
-			return SWAP_FAIL; /* To break the loop */
+			return false; /* To break the loop */
 		}
 
 		if (pvmw.pte) {
@@ -781,9 +781,9 @@ static int page_referenced_one(struct pa
 	}
 
 	if (!pra->mapcount)
-		return SWAP_SUCCESS; /* To break the loop */
+		return false; /* To break the loop */
 
-	return SWAP_AGAIN;
+	return true;
 }
 
 static bool invalid_page_referenced_vma(struct vm_area_struct *vma, void *arg)
@@ -854,7 +854,7 @@ int page_referenced(struct page *page,
 	return pra.referenced;
 }
 
-static int page_mkclean_one(struct page *page, struct vm_area_struct *vma,
+static bool page_mkclean_one(struct page *page, struct vm_area_struct *vma,
 			    unsigned long address, void *arg)
 {
 	struct page_vma_mapped_walk pvmw = {
@@ -907,7 +907,7 @@ static int page_mkclean_one(struct page
 		}
 	}
 
-	return SWAP_AGAIN;
+	return true;
 }
 
 static bool invalid_mkclean_vma(struct vm_area_struct *vma, void *arg)
@@ -1290,7 +1290,7 @@ void page_remove_rmap(struct page *page,
 /*
  * @arg: enum ttu_flags will be passed to this argument
  */
-static int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
+static bool try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 		     unsigned long address, void *arg)
 {
 	struct mm_struct *mm = vma->vm_mm;
@@ -1301,12 +1301,12 @@ static int try_to_unmap_one(struct page
 	};
 	pte_t pteval;
 	struct page *subpage;
-	int ret = SWAP_AGAIN;
+	bool ret = true;
 	enum ttu_flags flags = (enum ttu_flags)arg;
 
 	/* munlock has nothing to gain from examining un-locked vmas */
 	if ((flags & TTU_MUNLOCK) && !(vma->vm_flags & VM_LOCKED))
-		return SWAP_AGAIN;
+		return true;
 
 	if (flags & TTU_SPLIT_HUGE_PMD) {
 		split_huge_pmd_address(vma, address,
@@ -1329,7 +1329,7 @@ static int try_to_unmap_one(struct page
 					 */
 					mlock_vma_page(page);
 				}
-				ret = SWAP_FAIL;
+				ret = false;
 				page_vma_mapped_walk_done(&pvmw);
 				break;
 			}
@@ -1347,7 +1347,7 @@ static int try_to_unmap_one(struct page
 		if (!(flags & TTU_IGNORE_ACCESS)) {
 			if (ptep_clear_flush_young_notify(vma, address,
 						pvmw.pte)) {
-				ret = SWAP_FAIL;
+				ret = false;
 				page_vma_mapped_walk_done(&pvmw);
 				break;
 			}
@@ -1437,14 +1437,14 @@ static int try_to_unmap_one(struct page
 				 */
 				set_pte_at(mm, address, pvmw.pte, pteval);
 				SetPageSwapBacked(page);
-				ret = SWAP_FAIL;
+				ret = false;
 				page_vma_mapped_walk_done(&pvmw);
 				break;
 			}
 
 			if (swap_duplicate(entry) < 0) {
 				set_pte_at(mm, address, pvmw.pte, pteval);
-				ret = SWAP_FAIL;
+				ret = false;
 				page_vma_mapped_walk_done(&pvmw);
 				break;
 			}
@@ -1636,7 +1636,7 @@ static void rmap_walk_anon(struct page *
 		if (rwc->invalid_vma && rwc->invalid_vma(vma, rwc->arg))
 			continue;
 
-		if (SWAP_AGAIN != rwc->rmap_one(page, vma, address, rwc->arg))
+		if (!rwc->rmap_one(page, vma, address, rwc->arg))
 			break;
 		if (rwc->done && rwc->done(page))
 			break;
@@ -1690,7 +1690,7 @@ static void rmap_walk_file(struct page *
 		if (rwc->invalid_vma && rwc->invalid_vma(vma, rwc->arg))
 			continue;
 
-		if (SWAP_AGAIN != rwc->rmap_one(page, vma, address, rwc->arg))
+		if (!rwc->rmap_one(page, vma, address, rwc->arg))
 			goto done;
 		if (rwc->done && rwc->done(page))
 			goto done;
_
