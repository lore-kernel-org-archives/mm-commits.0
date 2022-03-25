Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBACAC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:35:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357473AbiCYBg6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357468AbiCYBew (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:34:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A298CC12DE
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:32:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 533A2B8261B
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:32:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E263BC340EC;
        Fri, 25 Mar 2022 01:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171967;
        bh=zgrdFSDLGhbhYcrRxQHgtSTNoMV9VUZUUHd8ChHSG7A=;
        h=Date:To:From:Subject:From;
        b=TsO6cpt1chfhUiym0qLh106NVWZLmWGPBwIz02M5NArkHDFES0E5glxjB89XYaBSr
         W5B+Nv6Cg5jCys9JMmoDyW4KLbDj3dNZYFt9JHFkHewEc/wm5cOkjXqGTq9w+TUdwF
         /Jcnf/VdVFjibCYLhP1n/8VjDx4qmw3wt/kJtQXs=
Date:   Thu, 24 Mar 2022 18:32:46 -0700
To:     mm-commits@vger.kernel.org, rparrazo@redhat.com, rafael@kernel.org,
        osalvador@suse.de, mhocko@suse.com, gregkh@linuxfoundation.org,
        david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] drivers-base-node-rename-link_mem_sections-to-register_memory_block_under_node.patch removed from -mm tree
Message-Id: <20220325013246.E263BC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/base/node: rename link_mem_sections() to register_memory_block_under_node()
has been removed from the -mm tree.  Its filename was
     drivers-base-node-rename-link_mem_sections-to-register_memory_block_under_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: drivers/base/node: rename link_mem_sections() to register_memory_block_under_node()

Patch series "drivers/base/memory: determine and store zone for single-zone memory blocks", v2.

I remember talking to Michal in the past about removing
test_pages_in_a_zone(), which we use for:
* verifying that a memory block we intend to offline is really only managed
  by a single zone. We don't support offlining of memory blocks that are
  managed by multiple zones (e.g., multiple nodes, DMA and DMA32)
* exposing that zone to user space via
  /sys/devices/system/memory/memory*/valid_zones

Now that I identified some more cases where test_pages_in_a_zone() might
go wrong, and we received an UBSAN report (see patch #3), let's get rid of
this PFN walker.

So instead of detecting the zone at runtime with test_pages_in_a_zone() by
scanning the memmap, let's determine and remember for each memory block if
it's managed by a single zone.  The stored zone can then be used for the
above two cases, avoiding a manual lookup using test_pages_in_a_zone().

This avoids eventually stumbling over uninitialized memmaps in corner
cases, especially when ZONE_DEVICE ranges partly fall into memory block
(that are responsible for managing System RAM).

Handling memory onlining is easy, because we online to exactly one zone. 
Handling boot memory is more tricky, because we want to avoid scanning all
zones of all nodes to detect possible zones that overlap with the physical
memory region of interest.  Fortunately, we already have code that
determines the applicable nodes for a memory block, to create sysfs links
-- we'll hook into that.

Patch #1 is a simple cleanup I had laying around for a longer time.
Patch #2 contains the main logic to remove test_pages_in_a_zone() and
further details.

[1] https://lkml.kernel.org/r/20220128144540.153902-1-david@redhat.com
[2] https://lkml.kernel.org/r/20220203105212.30385-1-david@redhat.com


This patch (of 2):

Let's adjust the stale terminology, making it match
unregister_memory_block_under_nodes() and
do_register_memory_block_under_node().  We're dealing with memory block
devices, which span 1..X memory sections.

Link: https://lkml.kernel.org/r/20220210184359.235565-1-david@redhat.com
Link: https://lkml.kernel.org/r/20220210184359.235565-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Rafael Parra <rparrazo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c  |    5 +++--
 include/linux/node.h |   16 ++++++++--------
 mm/memory_hotplug.c  |    6 +++---
 3 files changed, 14 insertions(+), 13 deletions(-)

--- a/drivers/base/node.c~drivers-base-node-rename-link_mem_sections-to-register_memory_block_under_node
+++ a/drivers/base/node.c
@@ -892,8 +892,9 @@ void unregister_memory_block_under_nodes
 			  kobject_name(&node_devices[mem_blk->nid]->dev.kobj));
 }
 
-void link_mem_sections(int nid, unsigned long start_pfn, unsigned long end_pfn,
-		       enum meminit_context context)
+void register_memory_blocks_under_node(int nid, unsigned long start_pfn,
+				       unsigned long end_pfn,
+				       enum meminit_context context)
 {
 	walk_memory_blocks_func_t func;
 
--- a/include/linux/node.h~drivers-base-node-rename-link_mem_sections-to-register_memory_block_under_node
+++ a/include/linux/node.h
@@ -99,13 +99,13 @@ extern struct node *node_devices[];
 typedef  void (*node_registration_func_t)(struct node *);
 
 #if defined(CONFIG_MEMORY_HOTPLUG) && defined(CONFIG_NUMA)
-void link_mem_sections(int nid, unsigned long start_pfn,
-		       unsigned long end_pfn,
-		       enum meminit_context context);
+void register_memory_blocks_under_node(int nid, unsigned long start_pfn,
+				       unsigned long end_pfn,
+				       enum meminit_context context);
 #else
-static inline void link_mem_sections(int nid, unsigned long start_pfn,
-				     unsigned long end_pfn,
-				     enum meminit_context context)
+static inline void register_memory_blocks_under_node(int nid, unsigned long start_pfn,
+						     unsigned long end_pfn,
+						     enum meminit_context context)
 {
 }
 #endif
@@ -129,8 +129,8 @@ static inline int register_one_node(int
 		error = __register_one_node(nid);
 		if (error)
 			return error;
-		/* link memory sections under this node */
-		link_mem_sections(nid, start_pfn, end_pfn, MEMINIT_EARLY);
+		register_memory_blocks_under_node(nid, start_pfn, end_pfn,
+						  MEMINIT_EARLY);
 	}
 
 	return error;
--- a/mm/memory_hotplug.c~drivers-base-node-rename-link_mem_sections-to-register_memory_block_under_node
+++ a/mm/memory_hotplug.c
@@ -1383,9 +1383,9 @@ int __ref add_memory_resource(int nid, s
 		BUG_ON(ret);
 	}
 
-	/* link memory sections under this node.*/
-	link_mem_sections(nid, PFN_DOWN(start), PFN_UP(start + size - 1),
-			  MEMINIT_HOTPLUG);
+	register_memory_blocks_under_node(nid, PFN_DOWN(start),
+					  PFN_UP(start + size - 1),
+					  MEMINIT_HOTPLUG);
 
 	/* create new memmap entry */
 	if (!strcmp(res->name, "System RAM"))
_

Patches currently in -mm which might be from david@redhat.com are

mm-optimize-do_wp_page-for-exclusive-pages-in-the-swapcache.patch
mm-optimize-do_wp_page-for-fresh-pages-in-local-lru-pagevecs.patch
mm-slightly-clarify-ksm-logic-in-do_swap_page.patch
mm-streamline-cow-logic-in-do_swap_page.patch
mm-huge_memory-streamline-cow-logic-in-do_huge_pmd_wp_page.patch
mm-khugepaged-remove-reuse_swap_page-usage.patch
mm-swapfile-remove-stale-reuse_swap_page.patch
mm-huge_memory-remove-stale-page_trans_huge_mapcount.patch
mm-huge_memory-remove-stale-locking-logic-from-__split_huge_pmd.patch

