From: akpm@linux-foundation.org
Subject: [merged] mm-filter-unevictable-page-out-in-deactivate_page.patch removed from -mm tree
Date: Wed, 25 May 2011 13:29:50 -0700
Message-ID: <201105252028.p4PKSDls014724@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34915 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755053Ab1EYU2r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:28:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan.kim@gmail.com, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: filter unevictable page out in deactivate_page()
has been removed from the -mm tree.  Its filename was
     mm-filter-unevictable-page-out-in-deactivate_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: filter unevictable page out in deactivate_page()
From: Minchan Kim <minchan.kim@gmail.com>

It's pointless that deactive_page's operates on unevictable pages.  This
patch removes unnecessary overhead which might be a bit problem in case
that there are many unevictable page in system(ex, mprotect workload)

[akpm@linux-foundation.org: tidy up comment]
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: Rik van Riel<riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN mm/swap.c~mm-filter-unevictable-page-out-in-deactivate_page mm/swap.c
--- a/mm/swap.c~mm-filter-unevictable-page-out-in-deactivate_page
+++ a/mm/swap.c
@@ -476,6 +476,13 @@ static void drain_cpu_pagevecs(int cpu)
  */
 void deactivate_page(struct page *page)
 {
+	/*
+	 * In a workload with many unevictable page such as mprotect, unevictable
+	 * page deactivation for accelerating reclaim is pointless.
+	 */
+	if (PageUnevictable(page))
+		return;
+
 	if (likely(get_page_unless_zero(page))) {
 		struct pagevec *pvec = &get_cpu_var(lru_deactivate_pvecs);
 
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

origin.patch
linux-next.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix-fix.patch
writeback-elevate-queue_io-into-wb_writeback.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-count-the-soft_limit-reclaim-in-global-background-reclaim.patch
memcg-add-the-soft_limit-reclaim-in-global-direct-reclaim.patch
memcg-rename-mem_cgroup_zone_nr_pages-to-mem_cgroup_zone_nr_lru_pages.patch
memcg-add-memorynumastat-api-for-numa-statistics.patch
memcg-add-memorynumastat-api-for-numa-statistics-v5.patch
add-the-pagefault-count-into-memcg-stats.patch

