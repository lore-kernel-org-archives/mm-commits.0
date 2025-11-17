Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914E121A447
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343132; cv=none; b=H8fiG8nh+xPDS7DvINas//CTtaE2DrCoblMf/VzMRvjYxxQkUOHeFDY8WdAd4LgfFBBtarCX9aiIdlaqy3vt38d5G6gJN78DRsUVubGm+3qwwSdDgjmSwMRYzdlUyyYmcYE4WkAerPjp1yU7G0yLMKXyrh2hgfdTBab46pYYHxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343132; c=relaxed/simple;
	bh=IthbYaYU/bx9emZj6e9ujMypW1j5qLskWYlx8FPthf4=;
	h=Date:To:From:Subject:Message-Id; b=g73OjjAm2ynCsY+DJeprAIVNjCOLbPBe3I83OlWCTvJc17uvHqUxzLNvfbtshNk9fDWoFlJ5B45STgme0OWj8dMhtn8E7RMU10AAyH96mT0lYY3A7TPz+eeaJb8UgzU9q99OtNHlXB1S5LQ/bOKhKhWjV+wqPjWKUkGelBC1L+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XfzSJZDG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XfzSJZDG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D3EC19423;
	Mon, 17 Nov 2025 01:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343132;
	bh=IthbYaYU/bx9emZj6e9ujMypW1j5qLskWYlx8FPthf4=;
	h=Date:To:From:Subject:From;
	b=XfzSJZDGhJ9n37e/Jab99s0Lv7IIdgSPc7uj4PkIKxDKW/Yc/tCPkmYkz4uqhhn8C
	 J8ZeuvlNMACbJCuv/jDInz5nHTYP2VEO4VPRGubx6WkvA9sWlt8g3sGxF1PU7kAmTX
	 lQkZb4S0vKG/nc3OlvNRsV4VvpFsKcWLA+0IWPoQ=
Date: Sun, 16 Nov 2025 17:32:11 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,rppt@kernel.org,ritesh.list@gmail.com,peterz@infradead.org,osalvador@suse.de,mingo@redhat.com,maddy@linux.ibm.com,gregkh@linuxfoundation.org,david@redhat.com,dave.jiang@intel.com,dakr@kernel.org,christophe.leroy@csgroup.eu,aboorvad@linux.ibm.com,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] drivers-base-node-fold-unregister_node-into-unregister_one_node.patch removed from -mm tree
Message-Id: <20251117013212.68D3EC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drivers/base/node: fold unregister_node() into unregister_one_node()
has been removed from the -mm tree.  Its filename was
     drivers-base-node-fold-unregister_node-into-unregister_one_node.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Donet Tom <donettom@linux.ibm.com>
Subject: drivers/base/node: fold unregister_node() into unregister_one_node()
Date: Tue, 14 Oct 2025 21:09:17 +0530

unregister_node() is only called from unregister_one_node().  This patch
folds unregister_node() into its only caller and renames
unregister_one_node() to unregister_node().

This reduces unnecessary indirection and simplifies the code structure. 
No functional changes are introduced.

[donettom@linux.ibm.com: remove extra spaces before @nid and "All"]
  Link: https://lkml.kernel.org/r/cff01514-9074-4c97-bcf1-d4e3594e48b0@linux.ibm.com
Link: https://lkml.kernel.org/r/32b7d5d8f0f30d313c3e1d8798f591459c8746f9.1760097208.git.donettom@linux.ibm.com
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: SeongJae Park <sj@kernel.org>
Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c  |   38 +++++++++++++++++---------------------
 include/linux/node.h |    6 ++----
 mm/memory_hotplug.c  |    4 ++--
 3 files changed, 21 insertions(+), 27 deletions(-)

--- a/drivers/base/node.c~drivers-base-node-fold-unregister_node-into-unregister_one_node
+++ a/drivers/base/node.c
@@ -676,23 +676,6 @@ static void node_device_release(struct d
 	kfree(to_node(dev));
 }
 
-/**
- * unregister_node - unregister a node device
- * @node: node going away
- *
- * Unregisters a node device @node.  All the devices on the node must be
- * unregistered before calling this function.
- */
-void unregister_node(struct node *node)
-{
-	hugetlb_unregister_node(node);
-	compaction_unregister_node(node);
-	reclaim_unregister_node(node);
-	node_remove_accesses(node);
-	node_remove_caches(node);
-	device_unregister(&node->dev);
-}
-
 struct node *node_devices[MAX_NUMNODES];
 
 /*
@@ -924,13 +907,26 @@ int register_node(int nid)
 
 	return error;
 }
-
-void unregister_one_node(int nid)
+/**
+ * unregister_node - unregister a node device
+ * @nid: nid of the node going away
+ *
+ * Unregisters the node device at node id @nid. All the devices on the
+ * node must be unregistered before calling this function.
+ */
+void unregister_node(int nid)
 {
-	if (!node_devices[nid])
+	struct node *node = node_devices[nid];
+
+	if (!node)
 		return;
 
-	unregister_node(node_devices[nid]);
+	hugetlb_unregister_node(node);
+	compaction_unregister_node(node);
+	reclaim_unregister_node(node);
+	node_remove_accesses(node);
+	node_remove_caches(node);
+	device_unregister(&node->dev);
 	node_devices[nid] = NULL;
 }
 
--- a/include/linux/node.h~drivers-base-node-fold-unregister_node-into-unregister_one_node
+++ a/include/linux/node.h
@@ -132,8 +132,6 @@ static inline void register_memory_block
 }
 #endif
 
-extern void unregister_node(struct node *node);
-
 struct node_notify {
 	int nid;
 };
@@ -177,7 +175,7 @@ static inline int hotplug_node_notifier(
 extern void node_dev_init(void);
 /* Core of the node registration - only memory hotplug should use this */
 int register_node(int nid);
-extern void unregister_one_node(int nid);
+void unregister_node(int nid);
 extern int register_cpu_under_node(unsigned int cpu, unsigned int nid);
 extern int unregister_cpu_under_node(unsigned int cpu, unsigned int nid);
 extern void unregister_memory_block_under_nodes(struct memory_block *mem_blk);
@@ -193,7 +191,7 @@ static inline int register_node(int nid)
 {
 	return 0;
 }
-static inline int unregister_one_node(int nid)
+static inline int unregister_node(int nid)
 {
 	return 0;
 }
--- a/mm/memory_hotplug.c~drivers-base-node-fold-unregister_node-into-unregister_one_node
+++ a/mm/memory_hotplug.c
@@ -1596,7 +1596,7 @@ int add_memory_resource(int nid, struct
 error:
 	if (new_node) {
 		node_set_offline(nid);
-		unregister_one_node(nid);
+		unregister_node(nid);
 	}
 error_memblock_remove:
 	if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK))
@@ -2201,7 +2201,7 @@ void try_offline_node(int nid)
 	 * node now.
 	 */
 	node_set_offline(nid);
-	unregister_one_node(nid);
+	unregister_node(nid);
 }
 EXPORT_SYMBOL(try_offline_node);
 
_

Patches currently in -mm which might be from donettom@linux.ibm.com are


