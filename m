Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E16DDC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 01:57:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbiBVB5x (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Feb 2022 20:57:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbiBVB5v (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Feb 2022 20:57:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE34B10A1
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 17:57:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A08D61463
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 01:57:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96E4C340E9;
        Tue, 22 Feb 2022 01:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645495044;
        bh=EGV4G4ctxvGrY77ROA3ds7EZ8UvdtIDz+tObPgjrifU=;
        h=Date:To:From:Subject:From;
        b=opViICL5eEOJsTbRO9tI3t9pbduH/zRPuQK0Ko5Kh8NnqPn5xBxbDXyFHkiP/0tKr
         3d4TdH53MN/xrtAT5jwojqIdFD/4JXs7XGbD3SWYaBvCC7OnTTkMeHn8kwjaJVU3qF
         qQ4PmXSWFcjl7jbSAaOWMHw190xhqkOHhLIS5D4c=
Date:   Mon, 21 Feb 2022 17:57:24 -0800
To:     mm-commits@vger.kernel.org, rafael@kernel.org, osalvador@suse.de,
        mhocko@suse.com, gregkh@linuxfoundation.org, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + drivers-base-memory-clarify-adding-and-removing-of-memory-blocks.patch added to -mm tree
Message-Id: <20220222015724.A96E4C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/base/memory: clarify adding and removing of memory blocks
has been added to the -mm tree.  Its filename is
     drivers-base-memory-clarify-adding-and-removing-of-memory-blocks.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/drivers-base-memory-clarify-adding-and-removing-of-memory-blocks.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/drivers-base-memory-clarify-adding-and-removing-of-memory-blocks.patch

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
Subject: drivers/base/memory: clarify adding and removing of memory blocks

Let's make it clearer at which places we actually add and remove memory
blocks -- streamlining the terminology -- and highlight which memory block
start out online and which start out as offline.

* rename add_memory_block -> add_boot_memory_block
* rename init_memory_block -> add_memory_block
* rename unregister_memory -> remove_memory_block
* rename register_memory -> __add_memory_block
* add add_hotplug_memory_block
* mark add_boot_memory_block with __init (suggested by Oscar)

__add_memory_block() is  a pure helper for add_memory_block(), remove
the somewhat obvious comment.

Link: https://lkml.kernel.org/r/20220221154531.11382-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |   38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

--- a/drivers/base/memory.c~drivers-base-memory-clarify-adding-and-removing-of-memory-blocks
+++ a/drivers/base/memory.c
@@ -617,11 +617,7 @@ static const struct attribute_group *mem
 	NULL,
 };
 
-/*
- * register_memory - Setup a sysfs device for a memory block
- */
-static
-int register_memory(struct memory_block *memory)
+static int __add_memory_block(struct memory_block *memory)
 {
 	int ret;
 
@@ -721,9 +717,9 @@ void memory_block_add_nid(struct memory_
 }
 #endif
 
-static int init_memory_block(unsigned long block_id, unsigned long state,
-			     unsigned long nr_vmemmap_pages,
-			     struct memory_group *group)
+static int add_memory_block(unsigned long block_id, unsigned long state,
+			    unsigned long nr_vmemmap_pages,
+			    struct memory_group *group)
 {
 	struct memory_block *mem;
 	int ret = 0;
@@ -754,7 +750,7 @@ static int init_memory_block(unsigned lo
 		mem->zone = early_node_zone_for_memory_block(mem, NUMA_NO_NODE);
 #endif /* CONFIG_NUMA */
 
-	ret = register_memory(mem);
+	ret = __add_memory_block(mem);
 	if (ret)
 		return ret;
 
@@ -766,7 +762,7 @@ static int init_memory_block(unsigned lo
 	return 0;
 }
 
-static int add_memory_block(unsigned long base_section_nr)
+static int __init add_boot_memory_block(unsigned long base_section_nr)
 {
 	int section_count = 0;
 	unsigned long nr;
@@ -778,11 +774,18 @@ static int add_memory_block(unsigned lon
 
 	if (section_count == 0)
 		return 0;
-	return init_memory_block(memory_block_id(base_section_nr),
-				 MEM_ONLINE, 0,  NULL);
+	return add_memory_block(memory_block_id(base_section_nr),
+				MEM_ONLINE, 0,  NULL);
+}
+
+static int add_hotplug_memory_block(unsigned long block_id,
+				    unsigned long nr_vmemmap_pages,
+				    struct memory_group *group)
+{
+	return add_memory_block(block_id, MEM_OFFLINE, nr_vmemmap_pages, group);
 }
 
-static void unregister_memory(struct memory_block *memory)
+static void remove_memory_block(struct memory_block *memory)
 {
 	if (WARN_ON_ONCE(memory->dev.bus != &memory_subsys))
 		return;
@@ -821,8 +824,7 @@ int create_memory_block_devices(unsigned
 		return -EINVAL;
 
 	for (block_id = start_block_id; block_id != end_block_id; block_id++) {
-		ret = init_memory_block(block_id, MEM_OFFLINE, vmemmap_pages,
-					group);
+		ret = add_hotplug_memory_block(block_id, vmemmap_pages, group);
 		if (ret)
 			break;
 	}
@@ -833,7 +835,7 @@ int create_memory_block_devices(unsigned
 			mem = find_memory_block_by_id(block_id);
 			if (WARN_ON_ONCE(!mem))
 				continue;
-			unregister_memory(mem);
+			remove_memory_block(mem);
 		}
 	}
 	return ret;
@@ -862,7 +864,7 @@ void remove_memory_block_devices(unsigne
 		if (WARN_ON_ONCE(!mem))
 			continue;
 		unregister_memory_block_under_nodes(mem);
-		unregister_memory(mem);
+		remove_memory_block(mem);
 	}
 }
 
@@ -922,7 +924,7 @@ void __init memory_dev_init(void)
 	 */
 	for (nr = 0; nr <= __highest_present_section_nr;
 	     nr += sections_per_block) {
-		ret = add_memory_block(nr);
+		ret = add_boot_memory_block(nr);
 		if (ret)
 			panic("%s() failed to add memory block: %d\n", __func__,
 			      ret);
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
cma-factor-out-minimum-alignment-requirement.patch
mm-enforce-pageblock_order-max_order.patch
drivers-base-memory-add-memory-block-to-memory-group-after-registration-succeeded.patch
drivers-base-node-consolidate-node-device-subsystem-initialization-in-node_dev_init.patch
drivers-base-node-rename-link_mem_sections-to-register_memory_block_under_node.patch
drivers-base-memory-determine-and-store-zone-for-single-zone-memory-blocks.patch
drivers-base-memory-clarify-adding-and-removing-of-memory-blocks.patch
proc-vmcore-fix-possible-deadlock-on-concurrent-mmap-and-read.patch

