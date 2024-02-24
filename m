Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC61B63AC
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739382; cv=none; b=iQrIInvKsfcdgHV7+daFwIIQ7jZShqfZ3GuLUGTrpipcyrtzUeCdfcRsMk7cxaedouIgJyRv/cY42mKEWDzEM+797qtZaNRAVXOaY/fS58hOr8y3mhC5i2lZ8/K1H41CMvEHS/0knkZi1cXgM5Shkt/qJYrVfKPyrZEJSzcgHuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739382; c=relaxed/simple;
	bh=LMCwyAAgrCJDWc9Vuk3JpTcaBoJBsShfsdCMcnDkHqc=;
	h=Date:To:From:Subject:Message-Id; b=k5ueRV++22AgpEpYK36DRhJwOn4ebliMrswDjDDRZsGb3lqNpr25xqXcIW25zSxN9ZfJU2sGE39BB7G06sb2oET9zR7WMdoohynKX10xF3lMrv9aZuVI5vdX9L1rEfGfHQVDXG6FSg0OlJyKx4jfHvKpgvYfiYzD/xEWMxRd6Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T6YDLAb4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T6YDLAb4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98CF8C43394;
	Sat, 24 Feb 2024 01:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739382;
	bh=LMCwyAAgrCJDWc9Vuk3JpTcaBoJBsShfsdCMcnDkHqc=;
	h=Date:To:From:Subject:From;
	b=T6YDLAb4zO1/SuXM8EVlKfbAvrfOuutK4NTVq1/iJuGhb2wqsVSUbBt7am9AgWp0P
	 INnqSAQxCmzh9d6g4x0u3uGqAJ0W3VzB0S3pW8NLToKl2eC9v+6RXr3N7TnCL/SddV
	 tsptVnC9zSfbC3LhNpIjLrO7YxLbtfTh8YkltDgU=
Date: Fri, 23 Feb 2024 17:49:42 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,oleksiy.avramchenko@sony.com,lstoakes@gmail.com,hch@infradead.org,david@fromorbit.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-improve-description-of-vmap-node-layer.patch removed from -mm tree
Message-Id: <20240224014942.98CF8C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmalloc: improve description of vmap node layer
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-improve-description-of-vmap-node-layer.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm: vmalloc: improve description of vmap node layer
Date: Wed, 24 Jan 2024 19:09:19 +0100

This patch adds extra explanation of recently added vmap node layer based
on community feedback.  No functional change.

Link: https://lkml.kernel.org/r/20240124180920.50725-1-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
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


