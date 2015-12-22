From: akpm@linux-foundation.org
Subject: +
 drivers-memory-check-for-missing-sections-in-test_pages_in_a_zone.patch
 added to -mm tree
Date: Tue, 22 Dec 2015 15:27:43 -0800
Message-ID: <5679dc6f.fnaegq/j6BSnSLoz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34069 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbbLVX1o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Dec 2015 18:27:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: abanman@sgi.com, athorlton@sgi.com, greg@kroah.com, rja@sgi.com, sjennings@variantweb.net, stable@vger.kernel.org, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug.c: check for missing sections in test_pages_in_a_zone()
has been added to the -mm tree.  Its filename is
     drivers-memory-check-for-missing-sections-in-test_pages_in_a_zone.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-memory-check-for-missing-sections-in-test_pages_in_a_zone.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-memory-check-for-missing-sections-in-test_pages_in_a_zone.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Banman <abanman@sgi.com>
Subject: mm/memory_hotplug.c: check for missing sections in test_pages_in_a_zone()

test_pages_in_a_zone() does not account for the possibility of missing
sections in the given pfn range.  pfn_valid_within always returns 1 when
CONFIG_HOLES_IN_ZONE is not set, allowing invalid pfns from missing
sections to pass the test, leading to a kernel oops.

Wrap an additional pfn loop with PAGES_PER_SECTION granularity to check
for missing sections before proceeding into the zone-check code.

This also prevents a crash from offlining memory devices with missing
sections.  Despite this, it may be a good idea to keep the related patch
'[PATCH 3/3] drivers: memory: prohibit offlining of memory blocks with
missing sections' because missing sections in a memory block may lead to
other problems not covered by the scope of this fix.

Signed-off-by: Andrew Banman <abanman@sgi.com>
Acked-by: Alex Thorlton <athorlton@sgi.com>
Cc: Russ Anderson <rja@sgi.com>
Cc: Alex Thorlton <athorlton@sgi.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Greg KH <greg@kroah.com>
Cc: Seth Jennings <sjennings@variantweb.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff -puN mm/memory_hotplug.c~drivers-memory-check-for-missing-sections-in-test_pages_in_a_zone mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~drivers-memory-check-for-missing-sections-in-test_pages_in_a_zone
+++ a/mm/memory_hotplug.c
@@ -1375,23 +1375,30 @@ int is_mem_section_removable(unsigned lo
  */
 int test_pages_in_a_zone(unsigned long start_pfn, unsigned long end_pfn)
 {
-	unsigned long pfn;
+	unsigned long pfn, sec_end_pfn;
 	struct zone *zone = NULL;
 	struct page *page;
 	int i;
-	for (pfn = start_pfn;
+	for (pfn = start_pfn, sec_end_pfn = SECTION_ALIGN_UP(start_pfn);
 	     pfn < end_pfn;
-	     pfn += MAX_ORDER_NR_PAGES) {
-		i = 0;
-		/* This is just a CONFIG_HOLES_IN_ZONE check.*/
-		while ((i < MAX_ORDER_NR_PAGES) && !pfn_valid_within(pfn + i))
-			i++;
-		if (i == MAX_ORDER_NR_PAGES)
+	     pfn = sec_end_pfn + 1, sec_end_pfn += PAGES_PER_SECTION) {
+		/* Make sure the memory section is present first */
+		if (!present_section_nr(pfn_to_section_nr(pfn)))
 			continue;
-		page = pfn_to_page(pfn + i);
-		if (zone && page_zone(page) != zone)
-			return 0;
-		zone = page_zone(page);
+		for (; pfn < sec_end_pfn && pfn < end_pfn;
+		     pfn += MAX_ORDER_NR_PAGES) {
+			i = 0;
+			/* This is just a CONFIG_HOLES_IN_ZONE check.*/
+			while ((i < MAX_ORDER_NR_PAGES) &&
+				!pfn_valid_within(pfn + i))
+				i++;
+			if (i == MAX_ORDER_NR_PAGES)
+				continue;
+			page = pfn_to_page(pfn + i);
+			if (zone && page_zone(page) != zone)
+				return 0;
+			zone = page_zone(page);
+		}
 	}
 	return 1;
 }
_

Patches currently in -mm which might be from abanman@sgi.com are

drivers-memory-check-for-missing-sections-in-test_pages_in_a_zone.patch
drivers-memory-check-for-missing-sections-when-testing-zones.patch

