From: akpm@linux-foundation.org
Subject: - hugetlb-vmstat-events-for-huge-page-allocations.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:52:59 -0700
Message-ID: <200804282152.m3SLqxfj017819@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42194 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934961AbYD1VxZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:53:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agl@us.ibm.com, apw@shadowen.org, ebmunson@us.ibm.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: [PATCH] hugetlb: vmstat events for huge page allocations
has been removed from the -mm tree.  Its filename was
     hugetlb-vmstat-events-for-huge-page-allocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Subject: [PATCH] hugetlb: vmstat events for huge page allocations
From: Adam Litke <agl@us.ibm.com>

Allocating huge pages directly from the buddy allocator is not guaranteed to
succeed.  Success depends on several factors (such as the amount of physical
memory available and the level of fragmentation).  With the addition of
dynamic hugetlb pool resizing, allocations can occur much more frequently. 
For these reasons it is desirable to keep track of huge page allocation
successes and failures.

Add two new vmstat entries to track huge page allocations that succeed and
fail.  The presence of the two entries is contingent upon CONFIG_HUGETLB_PAGE
being enabled.

[akpm@linux-foundation.org: reduced ifdeffery]
Signed-off-by: Adam Litke <agl@us.ibm.com>
Signed-off-by: Eric Munson <ebmunson@us.ibm.com>
Tested-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Andy Whitcroft <apw@shadowen.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    4 ++++
 mm/hugetlb.c           |    7 +++++++
 mm/vmstat.c            |    4 ++++
 3 files changed, 15 insertions(+)

diff -puN include/linux/vmstat.h~hugetlb-vmstat-events-for-huge-page-allocations include/linux/vmstat.h
--- a/include/linux/vmstat.h~hugetlb-vmstat-events-for-huge-page-allocations
+++ a/include/linux/vmstat.h
@@ -25,6 +25,7 @@
 #define HIGHMEM_ZONE(xx)
 #endif
 
+
 #define FOR_ALL_ZONES(xx) DMA_ZONE(xx) DMA32_ZONE(xx) xx##_NORMAL HIGHMEM_ZONE(xx) , xx##_MOVABLE
 
 enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
@@ -37,6 +38,9 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		FOR_ALL_ZONES(PGSCAN_DIRECT),
 		PGINODESTEAL, SLABS_SCANNED, KSWAPD_STEAL, KSWAPD_INODESTEAL,
 		PAGEOUTRUN, ALLOCSTALL, PGROTATED,
+#ifdef CONFIG_HUGETLB_PAGE
+		HTLB_BUDDY_PGALLOC, HTLB_BUDDY_PGALLOC_FAIL,
+#endif
 		NR_VM_EVENT_ITEMS
 };
 
diff -puN mm/hugetlb.c~hugetlb-vmstat-events-for-huge-page-allocations mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-vmstat-events-for-huge-page-allocations
+++ a/mm/hugetlb.c
@@ -242,6 +242,11 @@ static int alloc_fresh_huge_page(void)
 		hugetlb_next_nid = next_nid;
 	} while (!page && hugetlb_next_nid != start_nid);
 
+	if (ret)
+		count_vm_event(HTLB_BUDDY_PGALLOC);
+	else
+		count_vm_event(HTLB_BUDDY_PGALLOC_FAIL);
+
 	return ret;
 }
 
@@ -302,9 +307,11 @@ static struct page *alloc_buddy_huge_pag
 		 */
 		nr_huge_pages_node[nid]++;
 		surplus_huge_pages_node[nid]++;
+		__count_vm_event(HTLB_BUDDY_PGALLOC);
 	} else {
 		nr_huge_pages--;
 		surplus_huge_pages--;
+		__count_vm_event(HTLB_BUDDY_PGALLOC_FAIL);
 	}
 	spin_unlock(&hugetlb_lock);
 
diff -puN mm/vmstat.c~hugetlb-vmstat-events-for-huge-page-allocations mm/vmstat.c
--- a/mm/vmstat.c~hugetlb-vmstat-events-for-huge-page-allocations
+++ a/mm/vmstat.c
@@ -645,6 +645,10 @@ static const char * const vmstat_text[] 
 	"allocstall",
 
 	"pgrotated",
+#ifdef CONFIG_HUGETLB_PAGE
+	"htlb_buddy_alloc_success",
+	"htlb_buddy_alloc_fail",
+#endif
 #endif
 };
 
_

Patches currently in -mm which might be from agl@us.ibm.com are

origin.patch

