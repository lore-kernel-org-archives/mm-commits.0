From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-use-the-light-version-__mod_zone_page_state-in-mlocked_vma_newpage.patch removed from -mm tree
Date: Wed, 14 May 2014 13:28:00 -0700
Message-ID: <5373d1d0.opvcAjG8GvQV4Adk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46733 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbaENU2B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 May 2014 16:28:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hughd@google.com, cl@linux.com, akpm@linux-foundation.org, nasa4836@gmail.com

Subject: [to-be-updated] mm-use-the-light-version-__mod_zone_page_state-in-mlocked_vma_newpage.patch removed from -mm tree
To: nasa4836@gmail.com,akpm@linux-foundation.org,cl@linux.com,hughd@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 14 May 2014 13:28:00 -0700


The patch titled
     Subject: mm: use the light version __mod_zone_page_state in mlocked_vma_newpage()
has been removed from the -mm tree.  Its filename was
     mm-use-the-light-version-__mod_zone_page_state-in-mlocked_vma_newpage.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Jianyu Zhan <nasa4836@gmail.com>
Subject: mm: use the light version __mod_zone_page_state in mlocked_vma_newpage()

mlocked_vma_newpage() is called with pte lock held(a spinlock), which
implies preemtion disabled, and the vm stat counter is not modified from
interrupt context, so we need not use an irq-safe mod_zone_page_state()
here, using a light-weight version __mod_zone_page_state() would be OK.

This patch also documents __mod_zone_page_state() and some of its
callsites.  The comment above __mod_zone_page_state() is from Hugh
Dickins, and acked by Christoph.

Most credits to Hugh and Christoph for the clarification on the usage of
the __mod_zone_page_state().

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    7 ++++++-
 mm/rmap.c     |    9 +++++++++
 mm/vmstat.c   |    4 +++-
 3 files changed, 18 insertions(+), 2 deletions(-)

diff -puN mm/internal.h~mm-use-the-light-version-__mod_zone_page_state-in-mlocked_vma_newpage mm/internal.h
--- a/mm/internal.h~mm-use-the-light-version-__mod_zone_page_state-in-mlocked_vma_newpage
+++ a/mm/internal.h
@@ -201,7 +201,12 @@ static inline int mlocked_vma_newpage(st
 		return 0;
 
 	if (!TestSetPageMlocked(page)) {
-		mod_zone_page_state(page_zone(page), NR_MLOCK,
+		/*
+		 * We use the irq-unsafe __mod_zone_page_stat because
+		 * this counter is not modified from interrupt context, and the
+		 * pte lock is held(spinlock), which implies preemption disabled.
+		 */
+		__mod_zone_page_state(page_zone(page), NR_MLOCK,
 				    hpage_nr_pages(page));
 		count_vm_event(UNEVICTABLE_PGMLOCKED);
 	}
diff -puN mm/rmap.c~mm-use-the-light-version-__mod_zone_page_state-in-mlocked_vma_newpage mm/rmap.c
--- a/mm/rmap.c~mm-use-the-light-version-__mod_zone_page_state-in-mlocked_vma_newpage
+++ a/mm/rmap.c
@@ -982,6 +982,11 @@ void do_page_add_anon_rmap(struct page *
 {
 	int first = atomic_inc_and_test(&page->_mapcount);
 	if (first) {
+		/*
+		 * We use the irq-unsafe __{inc|mod}_zone_page_stat because
+		 * these counters are not modified from interrupt context, and
+		 * pte lock(a spinlock) is held, which implies preemption disabled.
+		 */
 		if (PageTransHuge(page))
 			__inc_zone_page_state(page,
 					      NR_ANON_TRANSPARENT_HUGEPAGES);
@@ -1073,6 +1078,10 @@ void page_remove_rmap(struct page *page)
 	/*
 	 * Hugepages are not counted in NR_ANON_PAGES nor NR_FILE_MAPPED
 	 * and not charged by memcg for now.
+	 *
+	 * We use the irq-unsafe __{inc|mod}_zone_page_stat because
+	 * these counters are not modified from interrupt context, and
+	 * pte lock(a spinlock) is held, which implies preemption disabled.
 	 */
 	if (unlikely(PageHuge(page)))
 		goto out;
diff -puN mm/vmstat.c~mm-use-the-light-version-__mod_zone_page_state-in-mlocked_vma_newpage mm/vmstat.c
--- a/mm/vmstat.c~mm-use-the-light-version-__mod_zone_page_state-in-mlocked_vma_newpage
+++ a/mm/vmstat.c
@@ -207,7 +207,9 @@ void set_pgdat_percpu_threshold(pg_data_
 }
 
 /*
- * For use when we know that interrupts are disabled.
+ * For use when we know that interrupts are disabled,
+ * or when we know that preemption is disabled and that
+ * particular counter cannot be updated from interrupt context.
  */
 void __mod_zone_page_state(struct zone *zone, enum zone_stat_item item,
 				int delta)
_

Patches currently in -mm which might be from nasa4836@gmail.com are

origin.patch
mm-swapc-clean-up-lru_cache_add-functions.patch
mm-swapc-introduce-put_refcounted_compound_page-helpers-for-spliting-put_compound_page.patch
mm-swapc-split-put_compound_page-function.patch
mm-introdule-compound_head_by_tail.patch
mm-memcontrol-clean-up-memcg-zoneinfo-lookup.patch
mm-memcontrol-remove-unnecessary-memcg-argument-from-soft-limit-functions.patch
mm-use-the-light-version-__mod_zone_page_state-in-mlocked_vma_newpage-checkpatch-fixes.patch
mm-fold-mlocked_vma_newpage-into-its-only-call-site.patch
mm-fold-mlocked_vma_newpage-into-its-only-call-site-checkpatch-fixes.patch
linux-next.patch

