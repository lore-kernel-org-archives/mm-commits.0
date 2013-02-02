From: akpm@linux-foundation.org
Subject: + mm-add-helper-ensure_zone_is_initialized.patch added to -mm tree
Date: Fri, 01 Feb 2013 16:40:02 -0800
Message-ID: <20130202004002.C3E075A42F7@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:48006 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757087Ab3BBAkE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2013 19:40:04 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so504705yen.4
        for <mm-commits@vger.kernel.org>; Fri, 01 Feb 2013 16:40:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jmesmon@gmail.com, catalin.marinas@arm.com, cody@linux.vnet.ibm.com, dave@linux.vnet.ibm.com, hannes@cmpxchg.org, mel@csn.ul.ie


The patch titled
     Subject: mm: add helper ensure_zone_is_initialized()
has been added to the -mm tree.  Its filename is
     mm-add-helper-ensure_zone_is_initialized.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cody P Schafer <jmesmon@gmail.com>
Subject: mm: add helper ensure_zone_is_initialized()

ensure_zone_is_initialized() checks if a zone is in a empty & not
initialized state (typically occuring after it is created in memory
hotplugging), and, if so, calls init_currently_empty_zone() to initialize
the zone.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: David Hansen <dave@linux.vnet.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN mm/memory_hotplug.c~mm-add-helper-ensure_zone_is_initialized mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-add-helper-ensure_zone_is_initialized
+++ a/mm/memory_hotplug.c
@@ -282,6 +282,17 @@ static void fix_zone_id(struct zone *zon
 		set_page_links(pfn_to_page(pfn), zid, nid, pfn);
 }
 
+/* Can fail with -ENOMEM from allocating a wait table with vmalloc() or
+ * alloc_bootmem_node_nopanic() */
+static int __ref ensure_zone_is_initialized(struct zone *zone,
+			unsigned long start_pfn, unsigned long num_pages)
+{
+	if (!zone_is_initialized(zone))
+		return init_currently_empty_zone(zone, start_pfn, num_pages,
+						 MEMMAP_HOTPLUG);
+	return 0;
+}
+
 static int __meminit move_pfn_range_left(struct zone *z1, struct zone *z2,
 		unsigned long start_pfn, unsigned long end_pfn)
 {
_

Patches currently in -mm which might be from jmesmon@gmail.com are

mm-page_alloc-add-a-vm_bug-in-__free_one_page-if-the-zone-is-uninitialized.patch
mmzone-add-pgdat_end_pfnis_empty-helpers-consolidate.patch
mm-add-helper-ensure_zone_is_initialized.patch

