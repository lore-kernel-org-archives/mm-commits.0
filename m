From: akpm@linux-foundation.org
Subject: [merged]
 base-memory-hotplug-fix-a-kernel-oops-in-show_valid_zones.patch removed
 from -mm tree
Date: Mon, 06 Feb 2017 13:24:46 -0800
Message-ID: <5898e99e.tjVrfSHFWNUlo1Ep%akpm__32179.4712720022$1486416293$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57800 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751640AbdBFVYr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2017 16:24:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: toshi.kani@hpe.com, arbab@linux.vnet.ibm.com, dan.j.williams@intel.com, gregkh@linuxfoundation.org, rientjes@google.com, stable@vger.kernel.org, zhenzhang.zhang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: base/memory, hotplug: fix a kernel oops in show_valid_zones()
has been removed from the -mm tree.  Its filename was
     base-memory-hotplug-fix-a-kernel-oops-in-show_valid_zones.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Toshi Kani <toshi.kani@hpe.com>
Subject: base/memory, hotplug: fix a kernel oops in show_valid_zones()

Reading a sysfs "memoryN/valid_zones" file leads to the following oops
when the first page of a range is not backed by struct page. 
show_valid_zones() assumes that 'start_pfn' is always valid for
page_zone().

 BUG: unable to handle kernel paging request at ffffea017a000000
 IP: show_valid_zones+0x6f/0x160

This issue may happen on x86-64 systems with 64GiB or more memory since
their memory block size is bumped up to 2GiB.  [1] An example of such
systems is desribed below.  0x3240000000 is only aligned by 1GiB and this
memory block starts from 0x3200000000, which is not backed by struct page.

 BIOS-e820: [mem 0x0000003240000000-0x000000603fffffff] usable

Since test_pages_in_a_zone() already checks holes, fix this issue by
extending this function to return 'valid_start' and 'valid_end' for a
given range.  show_valid_zones() then proceeds with the valid range.

[1] 'Commit bdee237c0343 ("x86: mm: Use 2GB memory block size on
    large-memory x86-64 systems")'

Link: http://lkml.kernel.org/r/20170127222149.30893-3-toshi.kani@hpe.com
Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Zhang Zhen <zhenzhang.zhang@huawei.com>
Cc: Reza Arbab <arbab@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: <stable@vger.kernel.org>	[4.4+]

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c          |   12 ++++++------
 include/linux/memory_hotplug.h |    3 ++-
 mm/memory_hotplug.c            |   20 +++++++++++++++-----
 3 files changed, 23 insertions(+), 12 deletions(-)

diff -puN drivers/base/memory.c~base-memory-hotplug-fix-a-kernel-oops-in-show_valid_zones drivers/base/memory.c
--- a/drivers/base/memory.c~base-memory-hotplug-fix-a-kernel-oops-in-show_valid_zones
+++ a/drivers/base/memory.c
@@ -389,33 +389,33 @@ static ssize_t show_valid_zones(struct d
 {
 	struct memory_block *mem = to_memory_block(dev);
 	unsigned long start_pfn, end_pfn;
+	unsigned long valid_start, valid_end, valid_pages;
 	unsigned long nr_pages = PAGES_PER_SECTION * sections_per_block;
-	struct page *first_page;
 	struct zone *zone;
 	int zone_shift = 0;
 
 	start_pfn = section_nr_to_pfn(mem->start_section_nr);
 	end_pfn = start_pfn + nr_pages;
-	first_page = pfn_to_page(start_pfn);
 
 	/* The block contains more than one zone can not be offlined. */
-	if (!test_pages_in_a_zone(start_pfn, end_pfn))
+	if (!test_pages_in_a_zone(start_pfn, end_pfn, &valid_start, &valid_end))
 		return sprintf(buf, "none\n");
 
-	zone = page_zone(first_page);
+	zone = page_zone(pfn_to_page(valid_start));
+	valid_pages = valid_end - valid_start;
 
 	/* MMOP_ONLINE_KEEP */
 	sprintf(buf, "%s", zone->name);
 
 	/* MMOP_ONLINE_KERNEL */
-	zone_can_shift(start_pfn, nr_pages, ZONE_NORMAL, &zone_shift);
+	zone_can_shift(valid_start, valid_pages, ZONE_NORMAL, &zone_shift);
 	if (zone_shift) {
 		strcat(buf, " ");
 		strcat(buf, (zone + zone_shift)->name);
 	}
 
 	/* MMOP_ONLINE_MOVABLE */
-	zone_can_shift(start_pfn, nr_pages, ZONE_MOVABLE, &zone_shift);
+	zone_can_shift(valid_start, valid_pages, ZONE_MOVABLE, &zone_shift);
 	if (zone_shift) {
 		strcat(buf, " ");
 		strcat(buf, (zone + zone_shift)->name);
diff -puN include/linux/memory_hotplug.h~base-memory-hotplug-fix-a-kernel-oops-in-show_valid_zones include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~base-memory-hotplug-fix-a-kernel-oops-in-show_valid_zones
+++ a/include/linux/memory_hotplug.h
@@ -85,7 +85,8 @@ extern int zone_grow_waitqueues(struct z
 extern int add_one_highpage(struct page *page, int pfn, int bad_ppro);
 /* VM interface that may be used by firmware interface */
 extern int online_pages(unsigned long, unsigned long, int);
-extern int test_pages_in_a_zone(unsigned long, unsigned long);
+extern int test_pages_in_a_zone(unsigned long start_pfn, unsigned long end_pfn,
+	unsigned long *valid_start, unsigned long *valid_end);
 extern void __offline_isolated_pages(unsigned long, unsigned long);
 
 typedef void (*online_page_callback_t)(struct page *page);
diff -puN mm/memory_hotplug.c~base-memory-hotplug-fix-a-kernel-oops-in-show_valid_zones mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~base-memory-hotplug-fix-a-kernel-oops-in-show_valid_zones
+++ a/mm/memory_hotplug.c
@@ -1484,10 +1484,13 @@ bool is_mem_section_removable(unsigned l
 
 /*
  * Confirm all pages in a range [start, end) belong to the same zone.
+ * When true, return its valid [start, end).
  */
-int test_pages_in_a_zone(unsigned long start_pfn, unsigned long end_pfn)
+int test_pages_in_a_zone(unsigned long start_pfn, unsigned long end_pfn,
+			 unsigned long *valid_start, unsigned long *valid_end)
 {
 	unsigned long pfn, sec_end_pfn;
+	unsigned long start, end;
 	struct zone *zone = NULL;
 	struct page *page;
 	int i;
@@ -1509,14 +1512,20 @@ int test_pages_in_a_zone(unsigned long s
 			page = pfn_to_page(pfn + i);
 			if (zone && page_zone(page) != zone)
 				return 0;
+			if (!zone)
+				start = pfn + i;
 			zone = page_zone(page);
+			end = pfn + MAX_ORDER_NR_PAGES;
 		}
 	}
 
-	if (zone)
+	if (zone) {
+		*valid_start = start;
+		*valid_end = end;
 		return 1;
-	else
+	} else {
 		return 0;
+	}
 }
 
 /*
@@ -1843,6 +1852,7 @@ static int __ref __offline_pages(unsigne
 	long offlined_pages;
 	int ret, drain, retry_max, node;
 	unsigned long flags;
+	unsigned long valid_start, valid_end;
 	struct zone *zone;
 	struct memory_notify arg;
 
@@ -1853,10 +1863,10 @@ static int __ref __offline_pages(unsigne
 		return -EINVAL;
 	/* This makes hotplug much easier...and readable.
 	   we assume this for now. .*/
-	if (!test_pages_in_a_zone(start_pfn, end_pfn))
+	if (!test_pages_in_a_zone(start_pfn, end_pfn, &valid_start, &valid_end))
 		return -EINVAL;
 
-	zone = page_zone(pfn_to_page(start_pfn));
+	zone = page_zone(pfn_to_page(valid_start));
 	node = zone_to_nid(zone);
 	nr_pages = end_pfn - start_pfn;
 
_

Patches currently in -mm which might be from toshi.kani@hpe.com are


