Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F94F2798FA
	for <mm-commits@vger.kernel.org>; Fri,  3 Oct 2025 23:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759534995; cv=none; b=XHV937fiETSC10upEIHXw9rX1DA3NnksnAnVxHkLOkkFqnItvgHDhV5oZ42fAaVlOv3HbnJosSGoTXOPkweE+Ooe800S7YwjKYZphmkAHxI4+PuOydxpOsMKvxoQMv5q58JJ/l+++6v8907nDKZEdsOKmYGGlkejzxEjiWPvpbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759534995; c=relaxed/simple;
	bh=2smMjCDapKu3WSzvG6lSFwrIfPKlHXMlPROi6pGp2sc=;
	h=Date:To:From:Subject:Message-Id; b=oFgWBtjsq7BHPqNY9j2pdN+S9utMGrYvsLcNBV23zBVk612HKm0HEnYKyQVv9O9RU6cxlhIa5nl1RgQatMvQPIIVNS+o1DUrBVKyiYJboNtxE0e4QW9Iw73TV60F7DxVeJdsFT+xAqVBL3WiBJ4vWbJK01fmcBkrQJmJBKD9X3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sPMlnB4d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sPMlnB4d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA988C4CEF5;
	Fri,  3 Oct 2025 23:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759534994;
	bh=2smMjCDapKu3WSzvG6lSFwrIfPKlHXMlPROi6pGp2sc=;
	h=Date:To:From:Subject:From;
	b=sPMlnB4dLYgJ01zeB+HORcoJNq+cAczeasGFqOiUl1U1nki5C5++S4ZAIIWTfVUQU
	 RsaQ/vmsgmmxvuSuRwccyf3meOhXQEyUpbZ6pmW7t84Lf8xkktSafk2crRt4CnEZ59
	 2YslpabgPvLHZJFgJFtCrYnm3tdk6FaH8fRbftAM=
Date: Fri, 03 Oct 2025 16:43:14 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,donettom@linux.ibm.com,david@redhat.com,hare@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] drivers-base-move-memory_block_add_nid-into-the-caller.patch removed from -mm tree
Message-Id: <20251003234314.CA988C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drivers/base: move memory_block_add_nid() into the caller
has been removed from the -mm tree.  Its filename was
     drivers-base-move-memory_block_add_nid-into-the-caller.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hannes Reinecke <hare@kernel.org>
Subject: drivers/base: move memory_block_add_nid() into the caller
Date: Tue, 29 Jul 2025 08:46:36 +0200

Now the node id only needs to be set for early memory, so move
memory_block_add_nid() into the caller and rename it into
memory_block_add_nid_early().  This allows us to further simplify the code
by dropping the 'context' argument to
do_register_memory_block_under_node().

Link: https://lkml.kernel.org/r/20250729064637.51662-4-hare@kernel.org
Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Hannes Reinecke <hare@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c  |   36 ++++++++++++++++++------------------
 drivers/base/node.c    |   10 ++++------
 include/linux/memory.h |    3 +--
 3 files changed, 23 insertions(+), 26 deletions(-)

--- a/drivers/base/memory.c~drivers-base-move-memory_block_add_nid-into-the-caller
+++ a/drivers/base/memory.c
@@ -769,21 +769,22 @@ static struct zone *early_node_zone_for_
 
 #ifdef CONFIG_NUMA
 /**
- * memory_block_add_nid() - Indicate that system RAM falling into this memory
- *			    block device (partially) belongs to the given node.
+ * memory_block_add_nid_early() - Indicate that early system RAM falling into
+ *				  this memory block device (partially) belongs
+ *				  to the given node.
  * @mem: The memory block device.
  * @nid: The node id.
- * @context: The memory initialization context.
  *
- * Indicate that system RAM falling into this memory block (partially) belongs
- * to the given node. If the context indicates ("early") that we are adding the
- * node during node device subsystem initialization, this will also properly
- * set/adjust mem->zone based on the zone ranges of the given node.
+ * Indicate that early system RAM falling into this memory block (partially)
+ * belongs to the given node. This will also properly set/adjust mem->zone based
+ * on the zone ranges of the given node.
+ *
+ * Memory hotplug handles this on memory block creation, where we can only have
+ * a single nid span a memory block.
  */
-void memory_block_add_nid(struct memory_block *mem, int nid,
-			  enum meminit_context context)
+void memory_block_add_nid_early(struct memory_block *mem, int nid)
 {
-	if (context == MEMINIT_EARLY && mem->nid != nid) {
+	if (mem->nid != nid) {
 		/*
 		 * For early memory we have to determine the zone when setting
 		 * the node id and handle multiple nodes spanning a single
@@ -797,15 +798,14 @@ void memory_block_add_nid(struct memory_
 			mem->zone = early_node_zone_for_memory_block(mem, nid);
 		else
 			mem->zone = NULL;
+		/*
+		 * If this memory block spans multiple nodes, we only indicate
+		 * the last processed node. If we span multiple nodes (not applicable
+		 * to hotplugged memory), zone == NULL will prohibit memory offlining
+		 * and consequently unplug.
+		 */
+		mem->nid = nid;
 	}
-
-	/*
-	 * If this memory block spans multiple nodes, we only indicate
-	 * the last processed node. If we span multiple nodes (not applicable
-	 * to hotplugged memory), zone == NULL will prohibit memory offlining
-	 * and consequently unplug.
-	 */
-	mem->nid = nid;
 }
 #endif
 
--- a/drivers/base/node.c~drivers-base-move-memory_block_add_nid-into-the-caller
+++ a/drivers/base/node.c
@@ -781,13 +781,10 @@ int unregister_cpu_under_node(unsigned i
 
 #ifdef CONFIG_MEMORY_HOTPLUG
 static void do_register_memory_block_under_node(int nid,
-						struct memory_block *mem_blk,
-						enum meminit_context context)
+						struct memory_block *mem_blk)
 {
 	int ret;
 
-	memory_block_add_nid(mem_blk, nid, context);
-
 	ret = sysfs_create_link_nowarn(&node_devices[nid]->dev.kobj,
 				       &mem_blk->dev.kobj,
 				       kobject_name(&mem_blk->dev.kobj));
@@ -815,7 +812,7 @@ static int register_mem_block_under_node
 {
 	int nid = *(int *)arg;
 
-	do_register_memory_block_under_node(nid, mem_blk, MEMINIT_HOTPLUG);
+	do_register_memory_block_under_node(nid, mem_blk);
 	return 0;
 }
 
@@ -855,7 +852,8 @@ static void register_memory_blocks_under
 			if (!mem)
 				continue;
 
-			do_register_memory_block_under_node(nid, mem, MEMINIT_EARLY);
+			memory_block_add_nid_early(mem, nid);
+			do_register_memory_block_under_node(nid, mem);
 			put_device(&mem->dev);
 		}
 
--- a/include/linux/memory.h~drivers-base-move-memory_block_add_nid-into-the-caller
+++ a/include/linux/memory.h
@@ -202,8 +202,7 @@ static inline unsigned long phys_to_bloc
 }
 
 #ifdef CONFIG_NUMA
-void memory_block_add_nid(struct memory_block *mem, int nid,
-			  enum meminit_context context);
+void memory_block_add_nid_early(struct memory_block *mem, int nid);
 #endif /* CONFIG_NUMA */
 int memory_block_advise_max_size(unsigned long size);
 unsigned long memory_block_advised_max_size(void);
_

Patches currently in -mm which might be from hare@kernel.org are


