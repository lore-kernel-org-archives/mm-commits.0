From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-fix-invalid-use-of-pfn_valid_within-in-test_pages_in_a_zone.patch
 removed from -mm tree
Date: Mon, 14 Sep 2015 10:46:48 -0700
Message-ID: <55f70808.9tBRVxeqOKUAIdDw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50224 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbbINRqt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Sep 2015 13:46:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jcuster@sgi.com, isimatu.yasuaki@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, rja@sgi.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix invalid use of pfn_valid_within in test_pages_in_a_zone
has been removed from the -mm tree.  Its filename was
     mm-fix-invalid-use-of-pfn_valid_within-in-test_pages_in_a_zone.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: James Custer <jcuster@sgi.com>
Subject: mm: fix invalid use of pfn_valid_within in test_pages_in_a_zone

Offlining memory by 'echo 0 > /sys/devices/system/memory/memory#/online'
or reading valid_zones 'cat
/sys/devices/system/memory/memory#/valid_zones' causes BUG: unable to
handle kernel paging request due to invalid use of pfn_valid_within.  This
is due to a bug in test_pages_in_a_zone.

In order to use pfn_valid_within within a MAX_ORDER_NR_PAGES block of
pages, a valid pfn within the block must first be found.  There only needs
to be one valid pfn found in test_pages_in_a_zone in the first place.  So
the fix is to replace pfn_valid_within with pfn_valid such that the first
valid pfn within the pageblock is found (if it exists).  This works
independently of CONFIG_HOLES_IN_ZONE.

Signed-off-by: James Custer <jcuster@sgi.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Russ Anderson <rja@sgi.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN mm/memory_hotplug.c~mm-fix-invalid-use-of-pfn_valid_within-in-test_pages_in_a_zone mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-fix-invalid-use-of-pfn_valid_within-in-test_pages_in_a_zone
+++ a/mm/memory_hotplug.c
@@ -1358,7 +1358,7 @@ int is_mem_section_removable(unsigned lo
 }
 
 /*
- * Confirm all pages in a range [start, end) is belongs to the same zone.
+ * Confirm all pages in a range [start, end) belong to the same zone.
  */
 int test_pages_in_a_zone(unsigned long start_pfn, unsigned long end_pfn)
 {
@@ -1369,10 +1369,11 @@ int test_pages_in_a_zone(unsigned long s
 	for (pfn = start_pfn;
 	     pfn < end_pfn;
 	     pfn += MAX_ORDER_NR_PAGES) {
-		i = 0;
-		/* This is just a CONFIG_HOLES_IN_ZONE check.*/
-		while ((i < MAX_ORDER_NR_PAGES) && !pfn_valid_within(pfn + i))
-			i++;
+		/* Find the first valid pfn in this pageblock */
+		for (i = 0; i < MAX_ORDER_NR_PAGES; i++) {
+			if (pfn_valid(pfn + i))
+				break;
+		}
 		if (i == MAX_ORDER_NR_PAGES)
 			continue;
 		page = pfn_to_page(pfn + i);
_

Patches currently in -mm which might be from jcuster@sgi.com are


