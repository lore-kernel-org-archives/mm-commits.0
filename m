Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FD9BC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:35:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357554AbiCYBgx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357471AbiCYBew (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:34:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B339CC12E5
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:32:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67B09B81DEA
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:32:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D790C340EC;
        Fri, 25 Mar 2022 01:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171969;
        bh=c2iiP7oqCMTLOriqmgLF+CnJFFRpNvBem+wk6Qug5Q8=;
        h=Date:To:From:Subject:From;
        b=jBGHDnyfjp1v/hpp6J1ho/71IOK9u9K73zgoGfQsUyhSLMSU3opeABQ/r997IDj9n
         knDN5zneRev+2d2P96DL4EJ5jnA2brfUSCpOTKPsGcavFoErZkQNJeZGTaagT/Gxye
         s7WN0HxXTekazn2quqoyUbFMLSS11wXqnQMjX298=
Date:   Thu, 24 Mar 2022 18:32:48 -0700
To:     mm-commits@vger.kernel.org, rafael@kernel.org, osalvador@suse.de,
        mhocko@suse.com, gregkh@linuxfoundation.org, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] drivers-base-memory-clarify-adding-and-removing-of-memory-blocks.patch removed from -mm tree
Message-Id: <20220325013249.1D790C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/base/memory: clarify adding and removing of memory blocks
has been removed from the -mm tree.  Its filename was
     drivers-base-memory-clarify-adding-and-removing-of-memory-blocks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |   38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

--- a/drivers/base/memory.c~drivers-base-memory-clarify-adding-and-removing-of-memory-blocks
+++ a/drivers/base/memory.c
@@ -619,11 +619,7 @@ static const struct attribute_group *mem
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
 
@@ -723,9 +719,9 @@ void memory_block_add_nid(struct memory_
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
@@ -756,7 +752,7 @@ static int init_memory_block(unsigned lo
 		mem->zone = early_node_zone_for_memory_block(mem, NUMA_NO_NODE);
 #endif /* CONFIG_NUMA */
 
-	ret = register_memory(mem);
+	ret = __add_memory_block(mem);
 	if (ret)
 		return ret;
 
@@ -768,7 +764,7 @@ static int init_memory_block(unsigned lo
 	return 0;
 }
 
-static int add_memory_block(unsigned long base_section_nr)
+static int __init add_boot_memory_block(unsigned long base_section_nr)
 {
 	int section_count = 0;
 	unsigned long nr;
@@ -780,11 +776,18 @@ static int add_memory_block(unsigned lon
 
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
@@ -823,8 +826,7 @@ int create_memory_block_devices(unsigned
 		return -EINVAL;
 
 	for (block_id = start_block_id; block_id != end_block_id; block_id++) {
-		ret = init_memory_block(block_id, MEM_OFFLINE, vmemmap_pages,
-					group);
+		ret = add_hotplug_memory_block(block_id, vmemmap_pages, group);
 		if (ret)
 			break;
 	}
@@ -835,7 +837,7 @@ int create_memory_block_devices(unsigned
 			mem = find_memory_block_by_id(block_id);
 			if (WARN_ON_ONCE(!mem))
 				continue;
-			unregister_memory(mem);
+			remove_memory_block(mem);
 		}
 	}
 	return ret;
@@ -864,7 +866,7 @@ void remove_memory_block_devices(unsigne
 		if (WARN_ON_ONCE(!mem))
 			continue;
 		unregister_memory_block_under_nodes(mem);
-		unregister_memory(mem);
+		remove_memory_block(mem);
 	}
 }
 
@@ -924,7 +926,7 @@ void __init memory_dev_init(void)
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

