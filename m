From: akpm@linux-foundation.org
Subject: + hugetlb-vmstat-events-for-huge-page-allocations.patch added to -mm tree
Date: Tue, 01 Apr 2008 13:49:31 -0700
Message-ID: <200804012049.m31KnV4R012560@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49096 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752667AbYDAUuL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Apr 2008 16:50:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: agl@us.ibm.com, apw@shadowen.org, ebmunson@us.ibm.com, mel@csn.ul.ie


The patch titled
     Subject: [PATCH] hugetlb: vmstat events for huge page allocations
has been added to the -mm tree.  Its filename is
     hugetlb-vmstat-events-for-huge-page-allocations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: Adam Litke <agl@us.ibm.com>
Signed-off-by: Eric Munson <ebmunson@us.ibm.com>
Tested-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    8 +++++++-
 mm/hugetlb.c           |    7 +++++++
 mm/vmstat.c            |    4 ++++
 3 files changed, 18 insertions(+), 1 deletion(-)

diff -puN include/linux/vmstat.h~hugetlb-vmstat-events-for-huge-page-allocations include/linux/vmstat.h
--- a/include/linux/vmstat.h~hugetlb-vmstat-events-for-huge-page-allocations
+++ a/include/linux/vmstat.h
@@ -25,6 +25,12 @@
 #define HIGHMEM_ZONE(xx)
 #endif
 
+#ifdef CONFIG_HUGETLB_PAGE
+#define HTLB_STATS	HTLB_BUDDY_PGALLOC, HTLB_BUDDY_PGALLOC_FAIL,
+#else
+#define HTLB_STATS
+#endif
+
 #define FOR_ALL_ZONES(xx) DMA_ZONE(xx) DMA32_ZONE(xx) xx##_NORMAL HIGHMEM_ZONE(xx) , xx##_MOVABLE
 
 enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
@@ -36,7 +42,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		FOR_ALL_ZONES(PGSCAN_KSWAPD),
 		FOR_ALL_ZONES(PGSCAN_DIRECT),
 		PGINODESTEAL, SLABS_SCANNED, KSWAPD_STEAL, KSWAPD_INODESTEAL,
-		PAGEOUTRUN, ALLOCSTALL, PGROTATED,
+		PAGEOUTRUN, ALLOCSTALL, PGROTATED, HTLB_STATS
 		NR_VM_EVENT_ITEMS
 };
 
diff -puN mm/hugetlb.c~hugetlb-vmstat-events-for-huge-page-allocations mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-vmstat-events-for-huge-page-allocations
+++ a/mm/hugetlb.c
@@ -247,6 +247,11 @@ static int alloc_fresh_huge_page(void)
 		hugetlb_next_nid = next_nid;
 	} while (!page && hugetlb_next_nid != start_nid);
 
+	if (ret)
+		count_vm_event(HTLB_BUDDY_PGALLOC);
+	else
+		count_vm_event(HTLB_BUDDY_PGALLOC_FAIL);
+
 	return ret;
 }
 
@@ -307,9 +312,11 @@ static struct page *alloc_buddy_huge_pag
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
@@ -644,6 +644,10 @@ static const char * const vmstat_text[] 
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

hugetlb-decrease-hugetlb_lock-cycling-in-gather_surplus_huge_pages.patch
hugetlb-vmstat-events-for-huge-page-allocations.patch

