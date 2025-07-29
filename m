Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CCF2272E4A
	for <mm-commits@vger.kernel.org>; Tue, 29 Jul 2025 20:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753821459; cv=none; b=T5HOnpXPcv0UtW0pKxu91bMVirnHsPDJWaGdBDAdzwQG04EES1QkjuOVnTdw0g5MexosuuvezSOJu3i0b/d3ykMKXP2C8VyRfF5qpgWGQBZXbSGA3P34fY9SgV5ArSFsva0K/ZoanHObrTF83Ko9p8t8pMsVmeNLp3VtdQl4CZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753821459; c=relaxed/simple;
	bh=5URCocP3CoZXrYIms0zpy5AW1gkKFvI4OEDaZVKXqgY=;
	h=Date:To:From:Subject:Message-Id; b=ROqwO0HezRjbn/gmVI2g9yk5ZnwfDLb98gYlImQjllUQzlrYoreTtYrvLlPWg3cxIRv5ZO+4HecCXfqb1cdIc9BQP9rHxtfzojfl/ZtevUrFbLhe8dJBQMMwPF7RuhBILjgrt0f9Tf9bJtPlq9XsfNYsmFds4yuf5+x3lFoYnBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H64ioqEi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H64ioqEi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B571AC4CEEF;
	Tue, 29 Jul 2025 20:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753821458;
	bh=5URCocP3CoZXrYIms0zpy5AW1gkKFvI4OEDaZVKXqgY=;
	h=Date:To:From:Subject:From;
	b=H64ioqEiY0XJPzWMUgDmgS9HnxbxuhZ0xUYCKlDAy49ll9jTAbipi8qP0IIveahQ2
	 cAh3wG4QTGep82GIeIPFNkP/eggPsQWXv5j/ryKPK0Ksa9/Edm67g4Xei5IfoVg59e
	 I6joaifbR6gVjJaquQzwrkIetqIK79XiS2k2120Q=
Date: Tue, 29 Jul 2025 13:37:38 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,donettom@linux.ibm.com,david@redhat.com,hare@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drivers-base-move-memory_block_add_nid-into-the-caller.patch added to mm-new branch
Message-Id: <20250729203738.B571AC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drivers/base: move memory_block_add_nid() into the caller
has been added to the -mm mm-new branch.  Its filename is
     drivers-base-move-memory_block_add_nid-into-the-caller.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drivers-base-move-memory_block_add_nid-into-the-caller.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

drivers-base-memory-add-node-id-parameter-to-add_memory_block.patch
mm-memory_hotplug-activate-node-before-adding-new-memory-blocks.patch
drivers-base-move-memory_block_add_nid-into-the-caller.patch

