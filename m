From: akpm@linux-foundation.org
Subject: [patch 054/114] mm: support __GFP_REPEAT in kvmalloc_node
 for >32kB
Date: Mon, 08 May 2017 15:57:15 -0700
Message-ID: <20170508225715.SvUjI_Yc7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46504 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751959AbdEHW5R (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:57:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davem@davemloft.net, mhocko@suse.com, mm-commits@vger.kernel.org, mst@redhat.com, torvalds@linux-foundation.org, vbabka@suse.cz

From: Michal Hocko <mhocko@suse.com>
Subject: mm: support __GFP_REPEAT in kvmalloc_node for >32kB

vhost code uses __GFP_REPEAT when allocating vhost_virtqueue resp. 
vhost_vsock because it would really like to prefer kmalloc to the vmalloc
fallback - see 23cc5a991c7a ("vhost-net: extend device allocation to
vmalloc") for more context.  Michael Tsirkin has also noted:

"__GFP_REPEAT overhead is during allocation time.  Using vmalloc means all
accesses are slowed down.  Allocation is not on data path, accesses are."

The similar applies to other vhost_kvzalloc users.

Let's teach kvmalloc_node to handle __GFP_REPEAT properly.  There are two
things to be careful about.  First we should prevent from the OOM killer
and so have to involve __GFP_NORETRY by default and secondly override
__GFP_REPEAT for !costly order requests as the __GFP_REPEAT is ignored for
!costly orders.

Supporting __GFP_REPEAT like semantic for !costly request is possible it
would require changes in the page allocator.  This is out of scope of this
patch.

This patch shouldn't introduce any functional change.

Link: http://lkml.kernel.org/r/20170306103032.2540-3-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/vhost/net.c   |    9 +++------
 drivers/vhost/vhost.c |   15 +++------------
 drivers/vhost/vsock.c |    9 +++------
 mm/util.c             |   18 +++++++++++++++---
 4 files changed, 24 insertions(+), 27 deletions(-)

diff -puN drivers/vhost/net.c~mm-support-__gfp_repeat-in-kvmalloc_node-for-32kb drivers/vhost/net.c
--- a/drivers/vhost/net.c~mm-support-__gfp_repeat-in-kvmalloc_node-for-32kb
+++ a/drivers/vhost/net.c
@@ -817,12 +817,9 @@ static int vhost_net_open(struct inode *
 	struct vhost_virtqueue **vqs;
 	int i;
 
-	n = kmalloc(sizeof *n, GFP_KERNEL | __GFP_NOWARN | __GFP_REPEAT);
-	if (!n) {
-		n = vmalloc(sizeof *n);
-		if (!n)
-			return -ENOMEM;
-	}
+	n = kvmalloc(sizeof *n, GFP_KERNEL | __GFP_REPEAT);
+	if (!n)
+		return -ENOMEM;
 	vqs = kmalloc(VHOST_NET_VQ_MAX * sizeof(*vqs), GFP_KERNEL);
 	if (!vqs) {
 		kvfree(n);
diff -puN drivers/vhost/vhost.c~mm-support-__gfp_repeat-in-kvmalloc_node-for-32kb drivers/vhost/vhost.c
--- a/drivers/vhost/vhost.c~mm-support-__gfp_repeat-in-kvmalloc_node-for-32kb
+++ a/drivers/vhost/vhost.c
@@ -534,18 +534,9 @@ err_mm:
 }
 EXPORT_SYMBOL_GPL(vhost_dev_set_owner);
 
-static void *vhost_kvzalloc(unsigned long size)
-{
-	void *n = kzalloc(size, GFP_KERNEL | __GFP_NOWARN | __GFP_REPEAT);
-
-	if (!n)
-		n = vzalloc(size);
-	return n;
-}
-
 struct vhost_umem *vhost_dev_reset_owner_prepare(void)
 {
-	return vhost_kvzalloc(sizeof(struct vhost_umem));
+	return kvzalloc(sizeof(struct vhost_umem), GFP_KERNEL);
 }
 EXPORT_SYMBOL_GPL(vhost_dev_reset_owner_prepare);
 
@@ -1276,7 +1267,7 @@ EXPORT_SYMBOL_GPL(vhost_vq_access_ok);
 
 static struct vhost_umem *vhost_umem_alloc(void)
 {
-	struct vhost_umem *umem = vhost_kvzalloc(sizeof(*umem));
+	struct vhost_umem *umem = kvzalloc(sizeof(*umem), GFP_KERNEL);
 
 	if (!umem)
 		return NULL;
@@ -1302,7 +1293,7 @@ static long vhost_set_memory(struct vhos
 		return -EOPNOTSUPP;
 	if (mem.nregions > max_mem_regions)
 		return -E2BIG;
-	newmem = vhost_kvzalloc(size + mem.nregions * sizeof(*m->regions));
+	newmem = kvzalloc(size + mem.nregions * sizeof(*m->regions), GFP_KERNEL);
 	if (!newmem)
 		return -ENOMEM;
 
diff -puN drivers/vhost/vsock.c~mm-support-__gfp_repeat-in-kvmalloc_node-for-32kb drivers/vhost/vsock.c
--- a/drivers/vhost/vsock.c~mm-support-__gfp_repeat-in-kvmalloc_node-for-32kb
+++ a/drivers/vhost/vsock.c
@@ -508,12 +508,9 @@ static int vhost_vsock_dev_open(struct i
 	/* This struct is large and allocation could fail, fall back to vmalloc
 	 * if there is no other way.
 	 */
-	vsock = kzalloc(sizeof(*vsock), GFP_KERNEL | __GFP_NOWARN | __GFP_REPEAT);
-	if (!vsock) {
-		vsock = vmalloc(sizeof(*vsock));
-		if (!vsock)
-			return -ENOMEM;
-	}
+	vsock = kvmalloc(sizeof(*vsock), GFP_KERNEL | __GFP_REPEAT);
+	if (!vsock)
+		return -ENOMEM;
 
 	vqs = kmalloc_array(ARRAY_SIZE(vsock->vqs), sizeof(*vqs), GFP_KERNEL);
 	if (!vqs) {
diff -puN mm/util.c~mm-support-__gfp_repeat-in-kvmalloc_node-for-32kb mm/util.c
--- a/mm/util.c~mm-support-__gfp_repeat-in-kvmalloc_node-for-32kb
+++ a/mm/util.c
@@ -339,7 +339,9 @@ EXPORT_SYMBOL(vm_mmap);
  * Uses kmalloc to get the memory but if the allocation fails then falls back
  * to the vmalloc allocator. Use kvfree for freeing the memory.
  *
- * Reclaim modifiers - __GFP_NORETRY, __GFP_REPEAT and __GFP_NOFAIL are not supported
+ * Reclaim modifiers - __GFP_NORETRY and __GFP_NOFAIL are not supported. __GFP_REPEAT
+ * is supported only for large (>32kB) allocations, and it should be used only if
+ * kmalloc is preferable to the vmalloc fallback, due to visible performance drawbacks.
  *
  * Any use of gfp flags outside of GFP_KERNEL should be consulted with mm people.
  */
@@ -358,8 +360,18 @@ void *kvmalloc_node(size_t size, gfp_t f
 	 * Make sure that larger requests are not too disruptive - no OOM
 	 * killer and no allocation failure warnings as we have a fallback
 	 */
-	if (size > PAGE_SIZE)
-		kmalloc_flags |= __GFP_NORETRY | __GFP_NOWARN;
+	if (size > PAGE_SIZE) {
+		kmalloc_flags |= __GFP_NOWARN;
+
+		/*
+		 * We have to override __GFP_REPEAT by __GFP_NORETRY for !costly
+		 * requests because there is no other way to tell the allocator
+		 * that we want to fail rather than retry endlessly.
+		 */
+		if (!(kmalloc_flags & __GFP_REPEAT) ||
+				(size <= PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER))
+			kmalloc_flags |= __GFP_NORETRY;
+	}
 
 	ret = kmalloc_node(size, kmalloc_flags, node);
 
_
