From: akpm@linux-foundation.org
Subject: [merged]
 memory_hotplug-use-pgdat_resize_lock-in-online_pages.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:25:10 -0700
Message-ID: <51db1216.G6/y74mA8yY1yF5W%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50366 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab3GHTZL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:25:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, cody@linux.vnet.ibm.com

Subject: [merged] memory_hotplug-use-pgdat_resize_lock-in-online_pages.patch removed from -mm tree
To: cody@linux.vnet.ibm.com,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:25:10 -0700


The patch titled
     Subject: memory_hotplug: use pgdat_resize_lock() in online_pages()
has been removed from the -mm tree.  Its filename was
     memory_hotplug-use-pgdat_resize_lock-in-online_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: memory_hotplug: use pgdat_resize_lock() in online_pages()

mmzone.h documents node_size_lock (which pgdat_resize_lock() locks) as
follows:

        * Must be held any time you expect node_start_pfn, node_present_pages
        * or node_spanned_pages stay constant.  [...]

So actually hold it when we update node_present_pages in online_pages().

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN mm/memory_hotplug.c~memory_hotplug-use-pgdat_resize_lock-in-online_pages mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory_hotplug-use-pgdat_resize_lock-in-online_pages
+++ a/mm/memory_hotplug.c
@@ -918,6 +918,7 @@ static void node_states_set_node(int nod
 
 int __ref online_pages(unsigned long pfn, unsigned long nr_pages, int online_type)
 {
+	unsigned long flags;
 	unsigned long onlined_pages = 0;
 	struct zone *zone;
 	int need_zonelists_rebuild = 0;
@@ -996,7 +997,11 @@ int __ref online_pages(unsigned long pfn
 
 	zone->managed_pages += onlined_pages;
 	zone->present_pages += onlined_pages;
+
+	pgdat_resize_lock(zone->zone_pgdat, &flags);
 	zone->zone_pgdat->node_present_pages += onlined_pages;
+	pgdat_resize_unlock(zone->zone_pgdat, &flags);
+
 	if (onlined_pages) {
 		node_states_set_node(zone_to_nid(zone), &arg);
 		if (need_zonelists_rebuild)
_

Patches currently in -mm which might be from cody@linux.vnet.ibm.com are

origin.patch
zbud-add-to-mm.patch
zswap-add-to-mm.patch
zswap-add-documentation.patch

