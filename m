From: akpm@linux-foundation.org
Subject: +
 mm-munlock-batch-non-thp-page-isolation-and-munlockputback-using-pagevec.patch added to -mm tree
Date: Mon, 19 Aug 2013 15:49:06 -0700
Message-ID: <5212a0e2.9BRMZq9z5VjR+tkZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55138 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab3HSWtH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Aug 2013 18:49:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, riel@redhat.com, mhocko@suse.cz, mgorman@suse.de, joern@logfs.org, hughd@google.com, hannes@cmpxchg.org, vbabka@suse.cz

Subject: + mm-munlock-batch-non-thp-page-isolation-and-munlockputback-using-pagevec.patch added to -mm tree
To: vbabka@suse.cz,hannes@cmpxchg.org,hughd@google.com,joern@logfs.org,mgorman@suse.de,mhocko@suse.cz,riel@redhat.com,walken@google.com
From: akpm@linux-foundation.org
Date: Mon, 19 Aug 2013 15:49:06 -0700


The patch titled
     Subject: mm: munlock: batch non-THP page isolation and munlock+putback using pagevec
has been added to the -mm tree.  Its filename is
     mm-munlock-batch-non-thp-page-isolation-and-munlockputback-using-pagevec.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-munlock-batch-non-thp-page-isolation-and-munlockputback-using-pagevec.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-munlock-batch-non-thp-page-isolation-and-munlockputback-using-pagevec.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm: munlock: batch non-THP page isolation and munlock+putback using pagevec

Currently, munlock_vma_range() calls munlock_vma_page on each page in a
loop, which results in repeated taking and releasing of the lru_lock
spinlock for isolating pages one by one.  This patch batches the munlock
operations using an on-stack pagevec, so that isolation is done under
single lru_lock.  For THP pages, the old behavior is preserved as they
might be split while putting them into the pagevec.  After this patch, a
9% speedup was measured for munlocking a 56GB large memory area with THP
disabled.

A new function __munlock_pagevec() is introduced that takes a pagevec and:
1) It clears PageMlocked and isolates all pages under lru_lock.  Zone page
stats can be also updated using the variant which assumes disabled
interrupts.  2) It finishes the munlock and lru putback on all pages under
their lock_page.  Note that previously, lock_page covered also the
PageMlocked clearing and page isolation, but it is not needed for those
operations.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Jörn Engel <joern@logfs.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Michel Lespinasse <walken@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |  193 ++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 153 insertions(+), 40 deletions(-)

diff -puN mm/mlock.c~mm-munlock-batch-non-thp-page-isolation-and-munlockputback-using-pagevec mm/mlock.c
--- a/mm/mlock.c~mm-munlock-batch-non-thp-page-isolation-and-munlockputback-using-pagevec
+++ a/mm/mlock.c
@@ -11,6 +11,7 @@
 #include <linux/swap.h>
 #include <linux/swapops.h>
 #include <linux/pagemap.h>
+#include <linux/pagevec.h>
 #include <linux/mempolicy.h>
 #include <linux/syscalls.h>
 #include <linux/sched.h>
@@ -18,6 +19,8 @@
 #include <linux/rmap.h>
 #include <linux/mmzone.h>
 #include <linux/hugetlb.h>
+#include <linux/memcontrol.h>
+#include <linux/mm_inline.h>
 
 #include "internal.h"
 
@@ -87,6 +90,47 @@ void mlock_vma_page(struct page *page)
 	}
 }
 
+/*
+ * Finish munlock after successful page isolation
+ *
+ * Page must be locked. This is a wrapper for try_to_munlock()
+ * and putback_lru_page() with munlock accounting.
+ */
+static void __munlock_isolated_page(struct page *page)
+{
+	int ret = SWAP_AGAIN;
+
+	/*
+	 * Optimization: if the page was mapped just once, that's our mapping
+	 * and we don't need to check all the other vmas.
+	 */
+	if (page_mapcount(page) > 1)
+		ret = try_to_munlock(page);
+
+	/* Did try_to_unlock() succeed or punt? */
+	if (ret != SWAP_MLOCK)
+		count_vm_event(UNEVICTABLE_PGMUNLOCKED);
+
+	putback_lru_page(page);
+}
+
+/*
+ * Accounting for page isolation fail during munlock
+ *
+ * Performs accounting when page isolation fails in munlock. There is nothing
+ * else to do because it means some other task has already removed the page
+ * from the LRU. putback_lru_page() will take care of removing the page from
+ * the unevictable list, if necessary. vmscan [page_referenced()] will move
+ * the page back to the unevictable list if some other vma has it mlocked.
+ */
+static void __munlock_isolation_failed(struct page *page)
+{
+	if (PageUnevictable(page))
+		count_vm_event(UNEVICTABLE_PGSTRANDED);
+	else
+		count_vm_event(UNEVICTABLE_PGMUNLOCKED);
+}
+
 /**
  * munlock_vma_page - munlock a vma page
  * @page - page to be unlocked
@@ -112,37 +156,10 @@ unsigned int munlock_vma_page(struct pag
 		unsigned int nr_pages = hpage_nr_pages(page);
 		mod_zone_page_state(page_zone(page), NR_MLOCK, -nr_pages);
 		page_mask = nr_pages - 1;
-		if (!isolate_lru_page(page)) {
-			int ret = SWAP_AGAIN;
-
-			/*
-			 * Optimization: if the page was mapped just once,
-			 * that's our mapping and we don't need to check all the
-			 * other vmas.
-			 */
-			if (page_mapcount(page) > 1)
-				ret = try_to_munlock(page);
-			/*
-			 * did try_to_unlock() succeed or punt?
-			 */
-			if (ret != SWAP_MLOCK)
-				count_vm_event(UNEVICTABLE_PGMUNLOCKED);
-
-			putback_lru_page(page);
-		} else {
-			/*
-			 * Some other task has removed the page from the LRU.
-			 * putback_lru_page() will take care of removing the
-			 * page from the unevictable list, if necessary.
-			 * vmscan [page_referenced()] will move the page back
-			 * to the unevictable list if some other vma has it
-			 * mlocked.
-			 */
-			if (PageUnevictable(page))
-				count_vm_event(UNEVICTABLE_PGSTRANDED);
-			else
-				count_vm_event(UNEVICTABLE_PGMUNLOCKED);
-		}
+		if (!isolate_lru_page(page))
+			__munlock_isolated_page(page);
+		else
+			__munlock_isolation_failed(page);
 	}
 
 	return page_mask;
@@ -210,6 +227,70 @@ static int __mlock_posix_error_return(lo
 }
 
 /*
+ * Munlock a batch of pages from the same zone
+ *
+ * The work is split to two main phases. First phase clears the Mlocked flag
+ * and attempts to isolate the pages, all under a single zone lru lock.
+ * The second phase finishes the munlock only for pages where isolation
+ * succeeded.
+ */
+static void __munlock_pagevec(struct pagevec *pvec, struct zone *zone)
+{
+	int i;
+	int nr = pagevec_count(pvec);
+
+	/* Phase 1: page isolation */
+	spin_lock_irq(&zone->lru_lock);
+	for (i = 0; i < nr; i++) {
+		struct page *page = pvec->pages[i];
+
+		if (TestClearPageMlocked(page)) {
+			struct lruvec *lruvec;
+			int lru;
+
+			/* we have disabled interrupts */
+			__mod_zone_page_state(zone, NR_MLOCK, -1);
+
+			if (PageLRU(page)) {
+				lruvec = mem_cgroup_page_lruvec(page, zone);
+				lru = page_lru(page);
+
+				get_page(page);
+				ClearPageLRU(page);
+				del_page_from_lru_list(page, lruvec, lru);
+			} else {
+				__munlock_isolation_failed(page);
+				goto skip_munlock;
+			}
+
+		} else {
+skip_munlock:
+			/*
+			 * We won't be munlocking this page in the next phase
+			 * but we still need to release the follow_page_mask()
+			 * pin.
+			 */
+			pvec->pages[i] = NULL;
+			put_page(page);
+		}
+	}
+	spin_unlock_irq(&zone->lru_lock);
+
+	/* Phase 2: page munlock and putback */
+	for (i = 0; i < nr; i++) {
+		struct page *page = pvec->pages[i];
+
+		if (page) {
+			lock_page(page);
+			__munlock_isolated_page(page);
+			unlock_page(page);
+			put_page(page); /* pin from follow_page_mask() */
+		}
+	}
+	pagevec_reinit(pvec);
+}
+
+/*
  * munlock_vma_pages_range() - munlock all pages in the vma range.'
  * @vma - vma containing range to be munlock()ed.
  * @start - start address in @vma of the range
@@ -230,11 +311,16 @@ static int __mlock_posix_error_return(lo
 void munlock_vma_pages_range(struct vm_area_struct *vma,
 			     unsigned long start, unsigned long end)
 {
+	struct pagevec pvec;
+	struct zone *zone = NULL;
+
+	pagevec_init(&pvec, 0);
 	vma->vm_flags &= ~VM_LOCKED;
 
 	while (start < end) {
 		struct page *page;
 		unsigned int page_mask, page_increm;
+		struct zone *pagezone;
 
 		/*
 		 * Although FOLL_DUMP is intended for get_dump_page(),
@@ -246,20 +332,47 @@ void munlock_vma_pages_range(struct vm_a
 		page = follow_page_mask(vma, start, FOLL_GET | FOLL_DUMP,
 					&page_mask);
 		if (page && !IS_ERR(page)) {
-			lock_page(page);
-			/*
-			 * Any THP page found by follow_page_mask() may have
-			 * gotten split before reaching munlock_vma_page(),
-			 * so we need to recompute the page_mask here.
-			 */
-			page_mask = munlock_vma_page(page);
-			unlock_page(page);
-			put_page(page);
+			pagezone = page_zone(page);
+			/* The whole pagevec must be in the same zone */
+			if (pagezone != zone) {
+				if (pagevec_count(&pvec))
+					__munlock_pagevec(&pvec, zone);
+				zone = pagezone;
+			}
+			if (PageTransHuge(page)) {
+				/*
+				 * THP pages are not handled by pagevec due
+				 * to their possible split (see below).
+				 */
+				if (pagevec_count(&pvec))
+					__munlock_pagevec(&pvec, zone);
+				lock_page(page);
+				/*
+				 * Any THP page found by follow_page_mask() may
+				 * have gotten split before reaching
+				 * munlock_vma_page(), so we need to recompute
+				 * the page_mask here.
+				 */
+				page_mask = munlock_vma_page(page);
+				unlock_page(page);
+				put_page(page); /* follow_page_mask() */
+			} else {
+				/*
+				 * Non-huge pages are handled in batches
+				 * via pagevec. The pin from
+				 * follow_page_mask() prevents them from
+				 * collapsing by THP.
+				 */
+				if (pagevec_add(&pvec, page) == 0)
+					__munlock_pagevec(&pvec, zone);
+			}
 		}
 		page_increm = 1 + (~(start >> PAGE_SHIFT) & page_mask);
 		start += page_increm * PAGE_SIZE;
 		cond_resched();
 	}
+	if (pagevec_count(&pvec))
+		__munlock_pagevec(&pvec, zone);
 }
 
 /*
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-putback_lru_page-remove-unnecessary-call-to-page_lru_base_type.patch
mm-munlock-remove-unnecessary-call-to-lru_add_drain.patch
mm-munlock-batch-non-thp-page-isolation-and-munlockputback-using-pagevec.patch
mm-munlock-batch-nr_mlock-zone-state-updates.patch
mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page.patch
mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page-fix.patch
mm-munlock-remove-redundant-get_page-put_page-pair-on-the-fast-path.patch
mm-munlock-manual-pte-walk-in-fast-path-instead-of-follow_page_mask.patch

