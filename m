From: akpm@osdl.org
Subject: - node-aware-skb-allocation.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:57:17 -0800
Message-ID: <200612072257.kB7MvHGe029268@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50652 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163616AbWLGW5r (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:57:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, clameter@engr.sgi.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     node-aware skb allocation
has been removed from the -mm tree.  Its filename was
     node-aware-skb-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: node-aware skb allocation
From: Christoph Hellwig <hch@lst.de>

Node-aware allocation of skbs for the receive path.

Details:

  - __alloc_skb gets a new node argument and cals the node-aware
    slab functions with it.
  - netdev_alloc_skb passed the node number it gets from dev_to_node
    to it, everyone else passes -1 (any node)

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/skbuff.h |    6 +++---
 net/core/skbuff.c      |   12 +++++++-----
 2 files changed, 10 insertions(+), 8 deletions(-)

diff -puN include/linux/skbuff.h~node-aware-skb-allocation include/linux/skbuff.h
--- a/include/linux/skbuff.h~node-aware-skb-allocation
+++ a/include/linux/skbuff.h
@@ -332,17 +332,17 @@ struct sk_buff {
 extern void kfree_skb(struct sk_buff *skb);
 extern void	       __kfree_skb(struct sk_buff *skb);
 extern struct sk_buff *__alloc_skb(unsigned int size,
-				   gfp_t priority, int fclone);
+				   gfp_t priority, int fclone, int node);
 static inline struct sk_buff *alloc_skb(unsigned int size,
 					gfp_t priority)
 {
-	return __alloc_skb(size, priority, 0);
+	return __alloc_skb(size, priority, 0, -1);
 }
 
 static inline struct sk_buff *alloc_skb_fclone(unsigned int size,
 					       gfp_t priority)
 {
-	return __alloc_skb(size, priority, 1);
+	return __alloc_skb(size, priority, 1, -1);
 }
 
 extern struct sk_buff *alloc_skb_from_cache(kmem_cache_t *cp,
diff -puN net/core/skbuff.c~node-aware-skb-allocation net/core/skbuff.c
--- a/net/core/skbuff.c~node-aware-skb-allocation
+++ a/net/core/skbuff.c
@@ -132,6 +132,7 @@ EXPORT_SYMBOL(skb_truesize_bug);
  *	@gfp_mask: allocation mask
  *	@fclone: allocate from fclone cache instead of head cache
  *		and allocate a cloned (child) skb
+ *	@node: numa node to allocate memory on
  *
  *	Allocate a new &sk_buff. The returned buffer has no headroom and a
  *	tail room of size bytes. The object has a reference count of one.
@@ -141,7 +142,7 @@ EXPORT_SYMBOL(skb_truesize_bug);
  *	%GFP_ATOMIC.
  */
 struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
-			    int fclone)
+			    int fclone, int node)
 {
 	kmem_cache_t *cache;
 	struct skb_shared_info *shinfo;
@@ -151,14 +152,14 @@ struct sk_buff *__alloc_skb(unsigned int
 	cache = fclone ? skbuff_fclone_cache : skbuff_head_cache;
 
 	/* Get the HEAD */
-	skb = kmem_cache_alloc(cache, gfp_mask & ~__GFP_DMA);
+	skb = kmem_cache_alloc_node(cache, gfp_mask & ~__GFP_DMA, node);
 	if (!skb)
 		goto out;
 
 	/* Get the DATA. Size must match skb_add_mtu(). */
 	size = SKB_DATA_ALIGN(size);
-	data = kmalloc_track_caller(size + sizeof(struct skb_shared_info),
-			gfp_mask);
+	data = kmalloc_node_track_caller(size + sizeof(struct skb_shared_info),
+			gfp_mask, node);
 	if (!data)
 		goto nodata;
 
@@ -267,9 +268,10 @@ nodata:
 struct sk_buff *__netdev_alloc_skb(struct net_device *dev,
 		unsigned int length, gfp_t gfp_mask)
 {
+	int node = dev->class_dev.dev ? dev_to_node(dev->class_dev.dev) : -1;
 	struct sk_buff *skb;
 
-	skb = alloc_skb(length + NET_SKB_PAD, gfp_mask);
+ 	skb = __alloc_skb(length + NET_SKB_PAD, gfp_mask, 0, node);
 	if (likely(skb)) {
 		skb_reserve(skb, NET_SKB_PAD);
 		skb->dev = dev;
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
node-aware-skb-allocation-fix-for-device-tree-changes.patch
touch_atime-cleanup.patch
relative-atime.patch
ocfs2-relative-atime-support.patch
ocfs2-relative-atime-support-tweaks.patch
optimize-o_direct-on-block-device-v3.patch
optimize-o_direct-on-block-device-v3-tweak.patch
fdtable-delete-pointless-code-in-dup_fd.patch
fdtable-make-fdarray-and-fdsets-equal-in-size.patch
fdtable-remove-the-free_files-field.patch
fdtable-implement-new-pagesize-based-fdtable-allocator.patch

