Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5427EC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236575AbiCVVtS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236629AbiCVVs7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:48:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B856A5FF05
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:47:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53E106104C
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:47:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7226C340EC;
        Tue, 22 Mar 2022 21:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985648;
        bh=XHZSHrl0g4YG5ETrkh5ZV4nruaRl+iQ/z4t6kK3KvUo=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=niNyw6zG+Rp9an6sQjB8z+0YSscKJvr9ynkfBbxWTJS3npEwKoOF4t9Vkg1kljB5p
         +dMx7EKiYHBQcQ9W1GAFf9WYQCTc4q5VmySltOpZ+LTOOXSdWgeIKsBU64gTgeTevg
         mf2xAZ8kWv+r/93Hx10ybHYt6DOS2Bi8tZ8M/UzA=
Date:   Tue, 22 Mar 2022 14:47:28 -0700
To:     rparrazo@redhat.com, rafael@kernel.org, osalvador@suse.de,
        mhocko@suse.com, gregkh@linuxfoundation.org, david@redhat.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 176/227] drivers/base/node: rename link_mem_sections() to register_memory_block_under_node()
Message-Id: <20220322214728.A7226C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
