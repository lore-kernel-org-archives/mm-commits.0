From: akpm@linux-foundation.org
Subject: [merged]
 mm-memory_hotplug-pass-in-nid-to-online_pages.patch removed from -mm tree
Date: Fri, 31 Jan 2020 15:19:14 -0800
Message-ID: <20200131231914.7C74T19JT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726469AbgAaXTQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:19:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, anshuman.khandual@arm.com, dan.j.williams@intel.com, david@redhat.com, gregkh@linuxfoundation.org, mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de, pasha.tatashin@soleen.com, rafael@kernel.org


The patch titled
     Subject: mm/memory_hotplug: pass in nid to online_pages()
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-pass-in-nid-to-online_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory_hotplug: pass in nid to online_pages()

Patch series "mm/memory_hotplug: pass in nid to online_pages()".

Simplify onlining code and get rid of find_memory_block(). Pass in the
nid from the memory block we are trying to online directly, instead of
manually looking it up.


This patch (of 2):

No need to lookup the memory block, we can directly pass in the nid.

Link: http://lkml.kernel.org/r/20200113113354.6341-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c          |    6 +++---
 include/linux/memory_hotplug.h |    3 ++-
 mm/memory_hotplug.c            |   13 ++-----------
 3 files changed, 7 insertions(+), 15 deletions(-)

--- a/drivers/base/memory.c~mm-memory_hotplug-pass-in-nid-to-online_pages
+++ a/drivers/base/memory.c
@@ -206,7 +206,7 @@ static bool pages_correctly_probed(unsig
  */
 static int
 memory_block_action(unsigned long start_section_nr, unsigned long action,
-		    int online_type)
+		    int online_type, int nid)
 {
 	unsigned long start_pfn;
 	unsigned long nr_pages = PAGES_PER_SECTION * sections_per_block;
@@ -219,7 +219,7 @@ memory_block_action(unsigned long start_
 		if (!pages_correctly_probed(start_pfn))
 			return -EBUSY;
 
-		ret = online_pages(start_pfn, nr_pages, online_type);
+		ret = online_pages(start_pfn, nr_pages, online_type, nid);
 		break;
 	case MEM_OFFLINE:
 		ret = offline_pages(start_pfn, nr_pages);
@@ -245,7 +245,7 @@ static int memory_block_change_state(str
 		mem->state = MEM_GOING_OFFLINE;
 
 	ret = memory_block_action(mem->start_section_nr, to_state,
-				mem->online_type);
+				  mem->online_type, mem->nid);
 
 	mem->state = ret ? from_state_req : to_state;
 
--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-pass-in-nid-to-online_pages
+++ a/include/linux/memory_hotplug.h
@@ -94,7 +94,8 @@ extern int zone_grow_free_lists(struct z
 extern int zone_grow_waitqueues(struct zone *zone, unsigned long nr_pages);
 extern int add_one_highpage(struct page *page, int pfn, int bad_ppro);
 /* VM interface that may be used by firmware interface */
-extern int online_pages(unsigned long, unsigned long, int);
+extern int online_pages(unsigned long pfn, unsigned long nr_pages,
+			int online_type, int nid);
 extern int test_pages_in_a_zone(unsigned long start_pfn, unsigned long end_pfn,
 	unsigned long *valid_start, unsigned long *valid_end);
 extern unsigned long __offline_isolated_pages(unsigned long start_pfn,
--- a/mm/memory_hotplug.c~mm-memory_hotplug-pass-in-nid-to-online_pages
+++ a/mm/memory_hotplug.c
@@ -783,27 +783,18 @@ struct zone * zone_for_pfn_range(int onl
 	return default_zone_for_pfn(nid, start_pfn, nr_pages);
 }
 
-int __ref online_pages(unsigned long pfn, unsigned long nr_pages, int online_type)
+int __ref online_pages(unsigned long pfn, unsigned long nr_pages,
+		       int online_type, int nid)
 {
 	unsigned long flags;
 	unsigned long onlined_pages = 0;
 	struct zone *zone;
 	int need_zonelists_rebuild = 0;
-	int nid;
 	int ret;
 	struct memory_notify arg;
-	struct memory_block *mem;
 
 	mem_hotplug_begin();
 
-	/*
-	 * We can't use pfn_to_nid() because nid might be stored in struct page
-	 * which is not yet initialized. Instead, we find nid from memory block.
-	 */
-	mem = find_memory_block(__pfn_to_section(pfn));
-	nid = mem->nid;
-	put_device(&mem->dev);
