Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137D426738D
	for <mm-commits@vger.kernel.org>; Fri,  3 Oct 2025 23:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759534994; cv=none; b=tDYPBhiN2Svagk2S4xdn/XA4fHM8j3h/MCP2pcuLoegWLAG7ALuh+jGuBBxwViYzJm0IsFto22sY6yb5gm7Oge1usz+D2XrqZ0ZKwy5FnnbChXMff7w8Pk+5FfdEZH2c6bJi9lyIX5ZNM+K1HYz1gAAH7QsajuDdTANE9K8TNtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759534994; c=relaxed/simple;
	bh=+WwbspkSqRBD5GAoAclaBKap69yaApi4d5Ppph7LB/8=;
	h=Date:To:From:Subject:Message-Id; b=XPkh8QbZL2oFHWmpSMIOeGQa7jVCzqHL+UFLdZRaiHyvFYyyW2GKKEwFuzmCDK/Y5duX9Bm90rS4OQD38l7JH59yBeTaPP99DprKt8917P7xkYrM9Ju1V01AXV8kyNNvnR37dHj7OWD29uq/dj9XhualF9Sn4A9xiZaLLRtGUQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tzVA5BCg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tzVA5BCg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92790C4CEF5;
	Fri,  3 Oct 2025 23:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759534993;
	bh=+WwbspkSqRBD5GAoAclaBKap69yaApi4d5Ppph7LB/8=;
	h=Date:To:From:Subject:From;
	b=tzVA5BCgk9T/ej7O+DSFkKHVWppUbmk2ifNLmleikJzcOntnC4hk1C/v5n5b3Rqwx
	 /mwrpM6hkD1nhmwd6HuZHcWskY19eedEpK/iV5zzt4s1VHU/y9c+ulEa9E4ffQo4f6
	 zTaP8ynvC11c0aog4t6XZRNQnQiTvdrV2QyMqwuk=
Date: Fri, 03 Oct 2025 16:43:12 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,donettom@linux.ibm.com,david@redhat.com,hare@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory_hotplug-activate-node-before-adding-new-memory-blocks.patch removed from -mm tree
Message-Id: <20251003234313.92790C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory_hotplug: activate node before adding new memory blocks
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-activate-node-before-adding-new-memory-blocks.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hannes Reinecke <hare@kernel.org>
Subject: mm/memory_hotplug: activate node before adding new memory blocks
Date: Tue, 29 Jul 2025 08:46:35 +0200

The sysfs attributes for memory blocks require the node ID to be set and
initialized, so move the node activation before adding new memory blocks. 
This also has the nice side effect that the BUG_ON() can be converted into
a WARN_ON() as we now can handle registration errors.

Link: https://lkml.kernel.org/r/20250729064637.51662-3-hare@kernel.org
Fixes: b9ff036082cd ("mm/memory_hotplug.c: make add_memory_resource use __try_online_node")
Signed-off-by: Hannes Reinecke <hare@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c  |    4 ++--
 include/linux/memory.h |    2 +-
 mm/memory_hotplug.c    |   32 +++++++++++++++++---------------
 3 files changed, 20 insertions(+), 18 deletions(-)

--- a/drivers/base/memory.c~mm-memory_hotplug-activate-node-before-adding-new-memory-blocks
+++ a/drivers/base/memory.c
@@ -879,7 +879,7 @@ static void remove_memory_block(struct m
  * Called under device_hotplug_lock.
  */
 int create_memory_block_devices(unsigned long start, unsigned long size,
-				struct vmem_altmap *altmap,
+				int nid, struct vmem_altmap *altmap,
 				struct memory_group *group)
 {
 	const unsigned long start_block_id = pfn_to_block_id(PFN_DOWN(start));
@@ -893,7 +893,7 @@ int create_memory_block_devices(unsigned
 		return -EINVAL;
 
 	for (block_id = start_block_id; block_id != end_block_id; block_id++) {
-		ret = add_memory_block(block_id, NUMA_NO_NODE, MEM_OFFLINE, altmap, group);
+		ret = add_memory_block(block_id, nid, MEM_OFFLINE, altmap, group);
 		if (ret)
 			break;
 	}
--- a/include/linux/memory.h~mm-memory_hotplug-activate-node-before-adding-new-memory-blocks
+++ a/include/linux/memory.h
@@ -159,7 +159,7 @@ static inline unsigned long memory_block
 extern int register_memory_notifier(struct notifier_block *nb);
 extern void unregister_memory_notifier(struct notifier_block *nb);
 int create_memory_block_devices(unsigned long start, unsigned long size,
-				struct vmem_altmap *altmap,
+				int nid, struct vmem_altmap *altmap,
 				struct memory_group *group);
 void remove_memory_block_devices(unsigned long start, unsigned long size);
 extern void memory_dev_init(void);
--- a/mm/memory_hotplug.c~mm-memory_hotplug-activate-node-before-adding-new-memory-blocks
+++ a/mm/memory_hotplug.c
@@ -1477,7 +1477,7 @@ static int create_altmaps_and_memory_blo
 		}
 
 		/* create memory block devices after memory was added */
-		ret = create_memory_block_devices(cur_start, memblock_size,
+		ret = create_memory_block_devices(cur_start, memblock_size, nid,
 						  params.altmap, group);
 		if (ret) {
 			arch_remove_memory(cur_start, memblock_size, NULL);
@@ -1539,8 +1539,16 @@ int add_memory_resource(int nid, struct
 
 	ret = __try_online_node(nid, false);
 	if (ret < 0)
-		goto error;
-	new_node = ret;
+		goto error_memblock_remove;
+	if (ret) {
+		node_set_online(nid);
+		ret = register_one_node(nid);
+		if (WARN_ON(ret)) {
+			node_set_offline(nid);
+			goto error_memblock_remove;
+		}
+		new_node = true;
+	}
 
 	/*
 	 * Self hosted memmap array
@@ -1556,24 +1564,13 @@ int add_memory_resource(int nid, struct
 			goto error;
 
 		/* create memory block devices after memory was added */
-		ret = create_memory_block_devices(start, size, NULL, group);
+		ret = create_memory_block_devices(start, size, nid, NULL, group);
 		if (ret) {
 			arch_remove_memory(start, size, params.altmap);
 			goto error;
 		}
 	}
 
-	if (new_node) {
-		/* If sysfs file of new node can't be created, cpu on the node
-		 * can't be hot-added. There is no rollback way now.
-		 * So, check by BUG_ON() to catch it reluctantly..
-		 * We online node here. We can't roll back from here.
-		 */
-		node_set_online(nid);
-		ret = register_one_node(nid);
-		BUG_ON(ret);
-	}
-
 	register_memory_blocks_under_node_hotplug(nid, PFN_DOWN(start),
 					  PFN_UP(start + size - 1));
 
@@ -1597,6 +1594,11 @@ int add_memory_resource(int nid, struct
 
 	return ret;
 error:
+	if (new_node) {
+		node_set_offline(nid);
+		unregister_one_node(nid);
+	}
+error_memblock_remove:
 	if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK))
 		memblock_remove(start, size);
 error_mem_hotplug_end:
_

Patches currently in -mm which might be from hare@kernel.org are


