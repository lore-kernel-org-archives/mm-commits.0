From: akpm@linux-foundation.org
Subject: +
 mm-memory_hotplugc-check-start_pfn-in-test_pages_in_a_zone.patch added to
 -mm tree
Date: Tue, 31 Jan 2017 14:22:11 -0800
Message-ID: <58910e13.HyjTKFfp8ZWg6Gnm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42952 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750837AbdAaWan (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2017 17:30:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: toshi.kani@hpe.com, abanman@sgi.com, arbab@linux.vnet.ibm.com, greg@kroah.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug.c: check start_pfn in test_pages_in_a_zone()
has been added to the -mm tree.  Its filename is
     mm-memory_hotplugc-check-start_pfn-in-test_pages_in_a_zone.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplugc-check-start_pfn-in-test_pages_in_a_zone.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplugc-check-start_pfn-in-test_pages_in_a_zone.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Toshi Kani <toshi.kani@hpe.com>
Subject: mm/memory_hotplug.c: check start_pfn in test_pages_in_a_zone()

test_pages_in_a_zone() does not check 'start_pfn' when it is aligned by
section since 'sec_end_pfn' is set equal to 'pfn'.  Since this function is
called for testing the range of a sysfs memory file, 'start_pfn' is always
aligned by section.

Fix it by properly setting 'sec_end_pfn' to the next section pfn.

Also make sure that this function returns 1 only when the range belongs to
a zone.

Link: http://lkml.kernel.org/r/20170127222149.30893-2-toshi.kani@hpe.com
Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Andrew Banman <abanman@sgi.com>
Cc: Reza Arbab <arbab@linux.vnet.ibm.com>
Cc: Greg KH <greg@kroah.com>
Cc: <stable@vger.kernel.org>	[4.4+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN mm/memory_hotplug.c~mm-memory_hotplugc-check-start_pfn-in-test_pages_in_a_zone mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplugc-check-start_pfn-in-test_pages_in_a_zone
+++ a/mm/memory_hotplug.c
@@ -1483,7 +1483,7 @@ bool is_mem_section_removable(unsigned l
 }
 
 /*
- * Confirm all pages in a range [start, end) is belongs to the same zone.
+ * Confirm all pages in a range [start, end) belong to the same zone.
  */
 int test_pages_in_a_zone(unsigned long start_pfn, unsigned long end_pfn)
 {
@@ -1491,9 +1491,9 @@ int test_pages_in_a_zone(unsigned long s
 	struct zone *zone = NULL;
 	struct page *page;
 	int i;
-	for (pfn = start_pfn, sec_end_pfn = SECTION_ALIGN_UP(start_pfn);
+	for (pfn = start_pfn, sec_end_pfn = SECTION_ALIGN_UP(start_pfn + 1);
 	     pfn < end_pfn;
-	     pfn = sec_end_pfn + 1, sec_end_pfn += PAGES_PER_SECTION) {
+	     pfn = sec_end_pfn, sec_end_pfn += PAGES_PER_SECTION) {
 		/* Make sure the memory section is present first */
 		if (!present_section_nr(pfn_to_section_nr(pfn)))
 			continue;
@@ -1512,7 +1512,11 @@ int test_pages_in_a_zone(unsigned long s
 			zone = page_zone(page);
 		}
 	}
-	return 1;
+
+	if (zone)
+		return 1;
+	else
+		return 0;
 }
 
 /*
_

Patches currently in -mm which might be from toshi.kani@hpe.com are

mm-memory_hotplugc-check-start_pfn-in-test_pages_in_a_zone.patch
base-memory-hotplug-fix-a-kernel-oops-in-show_valid_zones.patch

