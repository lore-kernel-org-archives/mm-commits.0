Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6617979DC
	for <mm-commits@vger.kernel.org>; Fri, 26 Jan 2024 02:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706235413; cv=none; b=ZFhHYVloK2IwvFdzQNHUBDf+o9KmZRDzEQjKnYZ0dhbJ91+7R5zqKqaTXMS4qMwKQYy7ujFakU552jTujc/J4oCOxvO44dXfn3LEcIU+MeZlo7DUIVX33EFtXOR3d828NdlZdIuehWEhZrhBX+odK/TR+fdJl0VByeU1yoGpBxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706235413; c=relaxed/simple;
	bh=MiQ79AUubyR09xu2hLnE2rJ1MpNz5KgjTTyKcKvZUAU=;
	h=Date:To:From:Subject:Message-Id; b=UkgOccew53fdr7FZ55AqmTUz+39X0NXi8EAQ+2K9VaO3ULPOAif2EdXl5gzNz+fd5pOG3YuKj4keuDM2/ATADXKaxID0M9sYF4cswxlqwExvVgIU2mwc2r/ItTyVG9wNFAloztvI5HvsmT/BNjvOOqwuH6ZD4Uq9URuwpaauIUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LlmSx/Qn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LlmSx/Qn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9669C433C7;
	Fri, 26 Jan 2024 02:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706235413;
	bh=MiQ79AUubyR09xu2hLnE2rJ1MpNz5KgjTTyKcKvZUAU=;
	h=Date:To:From:Subject:From;
	b=LlmSx/QnGGBTTFYUHGvFnLzgoINAmoKPWWla25cgESxRKor4QoS+NV0HufDiT71cM
	 Xtrm9PZsizW1zo+QcOWsITpWafLgAXflsAJeg7pnPV75rTcIw9y2LchVDdfczGcCgs
	 qeJaPjUGjwj10f1IVZqlDZOuvUYgnAzz1qjxIBhQ=
Date: Thu, 25 Jan 2024 18:16:50 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,oleksiy.avramchenko@sony.com,lstoakes@gmail.com,hch@infradead.org,david@fromorbit.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-improve-description-of-vmap-node-layer.patch added to mm-unstable branch
Message-Id: <20240126021652.A9669C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmalloc: improve description of vmap node layer
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-improve-description-of-vmap-node-layer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-improve-description-of-vmap-node-layer.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm: vmalloc: improve description of vmap node layer
Date: Wed, 24 Jan 2024 19:09:19 +0100

This patch adds extra explanation of recently added vmap node layer based
on community feedback.  No functional change.

Link: https://lkml.kernel.org/r/20240124180920.50725-1-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   60 +++++++++++++++++++++++++++++++++++++------------
 1 file changed, 46 insertions(+), 14 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-improve-description-of-vmap-node-layer
+++ a/mm/vmalloc.c
@@ -765,9 +765,10 @@ static struct rb_root free_vmap_area_roo
 static DEFINE_PER_CPU(struct vmap_area *, ne_fit_preload_node);
 
 /*
- * An effective vmap-node logic. Users make use of nodes instead
- * of a global heap. It allows to balance an access and mitigate
- * contention.
+ * This structure defines a single, solid model where a list and
+ * rb-tree are part of one entity protected by the lock. Nodes are
+ * sorted in ascending order, thus for O(1) access to left/right
+ * neighbors a list is used as well as for sequential traversal.
  */
 struct rb_list {
 	struct rb_root root;
@@ -775,16 +776,23 @@ struct rb_list {
 	spinlock_t lock;
 };
 
+/*
+ * A fast size storage contains VAs up to 1M size. A pool consists
+ * of linked between each other ready to go VAs of certain sizes.
+ * An index in the pool-array corresponds to number of pages + 1.
+ */
+#define MAX_VA_SIZE_PAGES 256
+
 struct vmap_pool {
 	struct list_head head;
 	unsigned long len;
 };
 
 /*
- * A fast size storage contains VAs up to 1M size.
+ * An effective vmap-node logic. Users make use of nodes instead
+ * of a global heap. It allows to balance an access and mitigate
+ * contention.
  */
-#define MAX_VA_SIZE_PAGES 256
-
 static struct vmap_node {
 	/* Simple size segregated storage. */
 	struct vmap_pool pool[MAX_VA_SIZE_PAGES];
@@ -803,6 +811,11 @@ static struct vmap_node {
 	unsigned long nr_purged;
 } single;
 
+/*
+ * Initial setup consists of one single node, i.e. a balancing
+ * is fully disabled. Later on, after vmap is initialized these
+ * parameters are updated based on a system capacity.
+ */
 static struct vmap_node *vmap_nodes = &single;
 static __read_mostly unsigned int nr_vmap_nodes = 1;
 static __read_mostly unsigned int vmap_zone_size = 1;
@@ -2048,7 +2061,12 @@ decay_va_pool_node(struct vmap_node *vn,
 			}
 		}
 
-		/* Attach the pool back if it has been partly decayed. */
+		/*
+		 * Attach the pool back if it has been partly decayed.
+		 * Please note, it is supposed that nobody(other contexts)
+		 * can populate the pool therefore a simple list replace
+		 * operation takes place here.
+		 */
 		if (!full_decay && !list_empty(&tmp_list)) {
 			spin_lock(&vn->pool_lock);
 			list_replace_init(&tmp_list, &vn->pool[i].head);
@@ -2257,16 +2275,14 @@ struct vmap_area *find_vmap_area(unsigne
 	 * An addr_to_node_id(addr) converts an address to a node index
 	 * where a VA is located. If VA spans several zones and passed
 	 * addr is not the same as va->va_start, what is not common, we
-	 * may need to scan an extra nodes. See an example:
+	 * may need to scan extra nodes. See an example:
 	 *
-	 *      <--va-->
+	 *      <----va---->
 	 * -|-----|-----|-----|-----|-
 	 *     1     2     0     1
 	 *
-	 * VA resides in node 1 whereas it spans 1 and 2. If passed
-	 * addr is within a second node we should do extra work. We
-	 * should mention that it is rare and is a corner case from
-	 * the other hand it has to be covered.
+	 * VA resides in node 1 whereas it spans 1, 2 an 0. If passed
+	 * addr is within 2 or 0 nodes we should do extra work.
 	 */
 	i = j = addr_to_node_id(addr);
 	do {
@@ -2289,6 +2305,9 @@ static struct vmap_area *find_unlink_vma
 	struct vmap_area *va;
 	int i, j;
 
+	/*
+	 * Check the comment in the find_vmap_area() about the loop.
+	 */
 	i = j = addr_to_node_id(addr);
 	do {
 		vn = &vmap_nodes[i];
@@ -4882,7 +4901,20 @@ static void vmap_init_nodes(void)
 	int i, n;
 
 #if BITS_PER_LONG == 64
-	/* A high threshold of max nodes is fixed and bound to 128. */
+	/*
+	 * A high threshold of max nodes is fixed and bound to 128,
+	 * thus a scale factor is 1 for systems where number of cores
+	 * are less or equal to specified threshold.
+	 *
+	 * As for NUMA-aware notes. For bigger systems, for example
+	 * NUMA with multi-sockets, where we can end-up with thousands
+	 * of cores in total, a "sub-numa-clustering" should be added.
+	 *
+	 * In this case a NUMA domain is considered as a single entity
+	 * with dedicated sub-nodes in it which describe one group or
+	 * set of cores. Therefore a per-domain purging is supposed to
+	 * be added as well as a per-domain balancing.
+	 */
 	n = clamp_t(unsigned int, num_possible_cpus(), 1, 128);
 
 	if (n > 1) {
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmalloc-add-va_alloc-helper.patch
mm-vmalloc-rename-adjust_va_to_fit_type-function.patch
mm-vmalloc-move-vmap_init_free_space-down-in-vmallocc.patch
mm-vmalloc-remove-global-vmap_area_root-rb-tree.patch
mm-vmalloc-remove-global-vmap_area_root-rb-tree-fix.patch
mm-vmalloc-remove-global-vmap_area_root-rb-tree-fix-2.patch
mm-vmalloc-remove-vmap_area_list-fix.patch
mm-vmalloc-remove-global-purge_vmap_area_root-rb-tree.patch
mm-vmalloc-offload-free_vmap_area_lock-lock.patch
mm-vmalloc-support-multiple-nodes-in-vread_iter.patch
mm-vmalloc-support-multiple-nodes-in-vmallocinfo.patch
mm-vmalloc-set-nr_nodes-based-on-cpus-in-a-system.patch
mm-vmalloc-add-a-shrinker-to-drain-vmap-pools.patch
mm-vmalloc-improve-description-of-vmap-node-layer.patch
mm-vmalloc-refactor-vmalloc_dump_obj-function.patch

