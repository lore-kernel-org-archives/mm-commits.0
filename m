From: akpm@linux-foundation.org
Subject: + per-cpuset-hugetlb-accounting-and-administration.patch added to -mm tree
Date: Thu, 03 May 2007 18:04:34 -0700
Message-ID: <200705040104.l4414YFR026322@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54055 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767569AbXEDBEu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 21:04:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kenchen@google.com, agl@us.ibm.com, hermes@gibson.dropbear.id.au, pj@sgi.com, wli@holomorphy.com


The patch titled
     per-cpuset hugetlb accounting and administration
has been added to the -mm tree.  Its filename is
     per-cpuset-hugetlb-accounting-and-administration.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: per-cpuset hugetlb accounting and administration
From: "Ken Chen" <kenchen@google.com>

Existing application heavily depends on accurate free hugetlb page pool
presented in /proc/meminfo.  Enterprise applications typically query
HugePages_Free field to know how much hugetlb pages are available for it to
use and intelligently segment its memory demand into several memory
segments, one to use the full extent of hugetlb page and have the rest to
fall back to normal page segment.

The reporting data with cpuset configured breaks that information, as it
presents global stats.  This will cause hiccup in application when run
inside cpuset that application will be mislead by the kernel and
mis-configure its hugetlb segment.

The following patch attempts to fix this deficiency when hugetlb is used
with cpuset to preserve the user space visible interface.  This is required
for compatibility and to allow existing application in the field to operate
normally regardless whether it is run with or without cpuset configured.

Signed-off-by: Ken Chen <kenchen@google.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: David Gibson <hermes@gibson.dropbear.id.au>
Cc: William Lee Irwin III <wli@holomorphy.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   28 +++++++++++++++++-----------
 1 files changed, 17 insertions(+), 11 deletions(-)

diff -puN mm/hugetlb.c~per-cpuset-hugetlb-accounting-and-administration mm/hugetlb.c
--- a/mm/hugetlb.c~per-cpuset-hugetlb-accounting-and-administration
+++ a/mm/hugetlb.c
@@ -219,7 +219,7 @@ static void try_to_free_low(unsigned lon
 			update_and_free_page(page);
 			free_huge_pages--;
 			free_huge_pages_node[page_to_nid(page)]--;
-			if (count >= nr_huge_pages)
+			if (count >= cpuset_mems_nr(nr_huge_pages_node))
 				return;
 		}
 	}
@@ -232,24 +232,30 @@ static inline void try_to_free_low(unsig
 
 static unsigned long set_max_huge_pages(unsigned long count)
 {
-	while (count > nr_huge_pages) {
+	unsigned int cpuset_nr_huge_pages = cpuset_mems_nr(nr_huge_pages_node);
+
+	while (count > cpuset_nr_huge_pages) {
 		if (!alloc_fresh_huge_page())
-			return nr_huge_pages;
+			return cpuset_nr_huge_pages;
+		cpuset_nr_huge_pages++;
 	}
-	if (count >= nr_huge_pages)
-		return nr_huge_pages;
+	if (count >= cpuset_nr_huge_pages)
+		return cpuset_nr_huge_pages;
 
 	spin_lock(&hugetlb_lock);
 	count = max(count, resv_huge_pages);
 	try_to_free_low(count);
-	while (count < nr_huge_pages) {
+
+	cpuset_nr_huge_pages = cpuset_mems_nr(nr_huge_pages_node);
+	while (count < cpuset_nr_huge_pages) {
 		struct page *page = dequeue_huge_page(NULL, 0);
 		if (!page)
 			break;
 		update_and_free_page(page);
+		cpuset_nr_huge_pages--;
 	}
 	spin_unlock(&hugetlb_lock);
-	return nr_huge_pages;
+	return cpuset_nr_huge_pages;
 }
 
 int hugetlb_sysctl_handler(struct ctl_table *table, int write,
@@ -278,12 +284,12 @@ int hugetlb_treat_movable_handler(struct
 int hugetlb_report_meminfo(char *buf)
 {
 	return sprintf(buf,
-			"HugePages_Total: %5lu\n"
-			"HugePages_Free:  %5lu\n"
+			"HugePages_Total: %5u\n"
+			"HugePages_Free:  %5u\n"
 			"HugePages_Rsvd:  %5lu\n"
 			"Hugepagesize:    %5lu kB\n",
-			nr_huge_pages,
-			free_huge_pages,
+			cpuset_mems_nr(nr_huge_pages_node),
+			cpuset_mems_nr(free_huge_pages_node),
 			resv_huge_pages,
 			HPAGE_SIZE/1024);
 }
_

Patches currently in -mm which might be from kenchen@google.com are

fix-leaky-resv_huge_pages-when-cpuset-is-in-use.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
remove-artificial-software-max_loop-limit.patch
pretend-cpuset-has-some-form-of-hugetlb-page-reservation.patch
per-cpuset-hugetlb-accounting-and-administration.patch
