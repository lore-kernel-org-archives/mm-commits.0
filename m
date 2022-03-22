Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99ACEC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:47:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236645AbiCVVtT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236677AbiCVVtF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:49:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DDD15FF32
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:47:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2226EB81DB0
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:47:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A7BC340EC;
        Tue, 22 Mar 2022 21:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985654;
        bh=hZmnlFBROMKtttPam+a64W/geo9wV78nPOc3rq/yyfQ=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=E6XXtJCZESguDOPaRnXuMGIHtD+ba/+H7VYtPoiL4FoC1zlzlCUA25KlQm/K0GWKX
         M3vJIU10jgbXapsuqtkCcfkChFEu9+sEYLdllhrfCWV6V/ZHcv7rZ+OiQd+EwZw1v2
         gM+rr0vCsDUNJnLec/XxT3j3d3crNSAgoq6Y8PHs=
Date:   Tue, 22 Mar 2022 14:47:34 -0700
To:     rafael@kernel.org, osalvador@suse.de, mhocko@suse.com,
        gregkh@linuxfoundation.org, david@redhat.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 178/227] drivers/base/memory: clarify adding and removing of memory blocks
Message-Id: <20220322214734.D1A7BC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
