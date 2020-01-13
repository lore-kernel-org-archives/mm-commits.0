From: akpm@linux-foundation.org
Subject: + mm-memory_hotplug-pass-in-nid-to-online_pages.patch added
 to -mm tree
Date: Mon, 13 Jan 2020 14:28:35 -0800
Message-ID: <20200113222835.fauUU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726530AbgAMW2i (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Jan 2020 17:28:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rafael@kernel.org, pasha.tatashin@soleen.com, osalvador@suse.de, mhocko@suse.com, gregkh@linuxfoundation.org, dan.j.williams@intel.com, anshuman.khandual@arm.com, david@redhat.com


The patch titled
     Subject: mm/memory_hotplug: pass in nid to online_pages()
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-pass-in-nid-to-online_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-pass-in-nid-to-online_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-pass-in-nid-to-online_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -233,7 +233,7 @@ static bool pages_correctly_probed(unsig
  */
 static int
 memory_block_action(unsigned long start_section_nr, unsigned long action,
-		    int online_type)
+		    int online_type, int nid)
 {
 	unsigned long start_pfn;
 	unsigned long nr_pages = PAGES_PER_SECTION * sections_per_block;
@@ -246,7 +246,7 @@ memory_block_action(unsigned long start_
 		if (!pages_correctly_probed(start_pfn))
 			return -EBUSY;
 
-		ret = online_pages(start_pfn, nr_pages, online_type);
+		ret = online_pages(start_pfn, nr_pages, online_type, nid);
 		break;
 	case MEM_OFFLINE:
 		ret = offline_pages(start_pfn, nr_pages);
@@ -272,7 +272,7 @@ static int memory_block_change_state(str
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
 extern struct zone *test_pages_in_a_zone(unsigned long start_pfn,
 					 unsigned long end_pfn);
 extern unsigned long __offline_isolated_pages(unsigned long start_pfn,
--- a/mm/memory_hotplug.c~mm-memory_hotplug-pass-in-nid-to-online_pages
+++ a/mm/memory_hotplug.c
@@ -758,27 +758,18 @@ struct zone * zone_for_pfn_range(int onl
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
