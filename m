From: akpm@linux-foundation.org
Subject: [merged] mm-add-comment-for-__mod_zone_page_stat.patch removed
 from -mm tree
Date: Thu, 05 Jun 2014 12:51:57 -0700
Message-ID: <5390ca5d.3KnDA7vCWAUClYoE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56233 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbaFETv6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:51:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hughd@google.com, cl@linux.com, akpm@linux-foundation.org, nasa4836@gmail.com

Subject: [merged] mm-add-comment-for-__mod_zone_page_stat.patch removed from -mm tree
To: nasa4836@gmail.com,akpm@linux-foundation.org,cl@linux.com,hughd@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:51:57 -0700


The patch titled
     Subject: mm: use the light version __mod_zone_page_state in mlocked_vma_newpage()
has been removed from the -mm tree.  Its filename was
     mm-add-comment-for-__mod_zone_page_stat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: coding-style fixes]
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    7 ++++++-
 mm/rmap.c     |   11 +++++++++++
 mm/vmstat.c   |    4 +++-
 3 files changed, 20 insertions(+), 2 deletions(-)

diff -puN mm/internal.h~mm-add-comment-for-__mod_zone_page_stat mm/internal.h
--- a/mm/internal.h~mm-add-comment-for-__mod_zone_page_stat
+++ a/mm/internal.h
@@ -201,7 +201,12 @@ static inline int mlocked_vma_newpage(st
 		return 0;
 
 	if (!TestSetPageMlocked(page)) {
-		mod_zone_page_state(page_zone(page), NR_MLOCK,
+		/*
+		 * We use the irq-unsafe __mod_zone_page_stat because this
+		 * counter is not modified from interrupt context, and the pte
+		 * lock is held(spinlock), which implies preemption disabled.
+		 */
+		__mod_zone_page_state(page_zone(page), NR_MLOCK,
 				    hpage_nr_pages(page));
 		count_vm_event(UNEVICTABLE_PGMLOCKED);
 	}
diff -puN mm/rmap.c~mm-add-comment-for-__mod_zone_page_stat mm/rmap.c
--- a/mm/rmap.c~mm-add-comment-for-__mod_zone_page_stat
+++ a/mm/rmap.c
@@ -988,6 +988,12 @@ void do_page_add_anon_rmap(struct page *
 {
 	int first = atomic_inc_and_test(&page->_mapcount);
 	if (first) {
+		/*
+		 * We use the irq-unsafe __{inc|mod}_zone_page_stat because
+		 * these counters are not modified in interrupt context, and
+		 * pte lock(a spinlock) is held, which implies preemption
+		 * disabled.
+		 */
 		if (PageTransHuge(page))
 			__inc_zone_page_state(page,
 					      NR_ANON_TRANSPARENT_HUGEPAGES);
@@ -1079,6 +1085,11 @@ void page_remove_rmap(struct page *page)
 	/*
 	 * Hugepages are not counted in NR_ANON_PAGES nor NR_FILE_MAPPED
 	 * and not charged by memcg for now.
+	 *
+	 * We use the irq-unsafe __{inc|mod}_zone_page_stat because
+	 * these counters are not modified in interrupt context, and
+	 * these counters are not modified in interrupt context, and
+	 * pte lock(a spinlock) is held, which implies preemption disabled.
 	 */
 	if (unlikely(PageHuge(page)))
 		goto out;
diff -puN mm/vmstat.c~mm-add-comment-for-__mod_zone_page_stat mm/vmstat.c
--- a/mm/vmstat.c~mm-add-comment-for-__mod_zone_page_stat
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
linux-next.patch
mm-memcontrol-clean-up-memcg-zoneinfo-lookup.patch
mm-memcontrol-remove-unnecessary-memcg-argument-from-soft-limit-functions.patch

