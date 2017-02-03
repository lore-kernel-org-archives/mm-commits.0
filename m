From: akpm@linux-foundation.org
Subject: [patch 5/8] mm/memory_hotplug.c: check start_pfn in
 test_pages_in_a_zone()
Date: Fri, 03 Feb 2017 13:13:20 -0800
Message-ID: <5894f270.k6CVgm268xdc45zu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50288 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752508AbdBCVNV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2017 16:13:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, toshi.kani@hpe.com, abanman@sgi.com, arbab@linux.vnet.ibm.com, greg@kroah.com, stable@vger.kernel.org

From: Toshi Kani <toshi.kani@hpe.com>
Subject: mm/memory_hotplug.c: check start_pfn in test_pages_in_a_zone()

Patch series "fix a kernel oops when reading sysfs valid_zones", v2.

A sysfs memory file is created for each 2GiB memory block on x86-64 when
the system has 64GiB or more memory.  [1] When the start address of a
memory block is not backed by struct page, i.e.  a memory range is not
aligned by 2GiB, reading its 'valid_zones' attribute file leads to a
kernel oops.  This issue was observed on multiple x86-64 systems with more
than 64GiB of memory.  This patch-set fixes this issue.

Patch 1 first fixes an issue in test_pages_in_a_zone(), which does
not test the start section.

Patch 2 then fixes the kernel oops by extending test_pages_in_a_zone()
to return valid [start, end).

Note for stable kernels: The memory block size change was made by commit
bdee237c034, which was accepted to 3.9.  However, this patch-set depends
on (and fixes) the change to test_pages_in_a_zone() made by commit
5f0f2887f4, which was accepted to 4.4.  So, I recommend that we backport
it up to 4.4.

[1] 'Commit bdee237c0343 ("x86: mm: Use 2GB memory block size on
    large-memory x86-64 systems")'


This patch (of 2):

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
