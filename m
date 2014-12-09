From: akpm@linux-foundation.org
Subject: +
 mm-fix-invalid-use-of-pfn_valid_within-in-test_pages_in_a_zone.patch added
 to -mm tree
Date: Tue, 09 Dec 2014 14:20:07 -0800
Message-ID: <54877597.FVGg3SpcUnBKK7dG%akpm__11125.5235191949$1418163621$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42868 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbaLIWUI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Dec 2014 17:20:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jcuster@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, rja@sgi.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix invalid use of pfn_valid_within in test_pages_in_a_zone
has been added to the -mm tree.  Its filename is
     mm-fix-invalid-use-of-pfn_valid_within-in-test_pages_in_a_zone.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-invalid-use-of-pfn_valid_within-in-test_pages_in_a_zone.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-invalid-use-of-pfn_valid_within-in-test_pages_in_a_zone.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN mm/memory_hotplug.c~mm-fix-invalid-use-of-pfn_valid_within-in-test_pages_in_a_zone mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-fix-invalid-use-of-pfn_valid_within-in-test_pages_in_a_zone
+++ a/mm/memory_hotplug.c
@@ -1331,7 +1331,7 @@ int is_mem_section_removable(unsigned lo
 }
 
 /*
- * Confirm all pages in a range [start, end) is belongs to the same zone.
+ * Confirm all pages in a range [start, end) belong to the same zone.
  */
 int test_pages_in_a_zone(unsigned long start_pfn, unsigned long end_pfn)
 {
@@ -1342,10 +1342,11 @@ int test_pages_in_a_zone(unsigned long s
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

mm-fix-invalid-use-of-pfn_valid_within-in-test_pages_in_a_zone.patch
linux-next.patch

