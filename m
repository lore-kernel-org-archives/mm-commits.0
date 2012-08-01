From: akpm@linux-foundation.org
Subject: [merged] netvm-allow-skb-allocation-to-use-pfmemalloc-reserves.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:16:07 -0700
Message-ID: <20120801201608.470205C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:48104 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936Ab2HAUQL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:16:11 -0400
Received: by wibhr14 with SMTP id hr14so199031wib.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:16:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, a.p.zijlstra@chello.nl, cl@linux.com, davem@davemloft.net, emunson@mgebm.net, eric.dumazet@gmail.com, michaelc@cs.wisc.edu, neilb@suse.de, sebastian@breakpoint.cc, mm-commits@vger.kernel.org


The patch titled
     Subject: netvm: allow skb allocation to use PFMEMALLOC reserves
has been removed from the -mm tree.  Its filename was
     netvm-allow-skb-allocation-to-use-pfmemalloc-reserves.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: netvm: allow skb allocation to use PFMEMALLOC reserves

Change the skb allocation API to indicate RX usage and use this to fall
back to the PFMEMALLOC reserve when needed.  SKBs allocated from the
reserve are tagged in skb->pfmemalloc.  If an SKB is allocated from the
reserve and the socket is later found to be unrelated to page reclaim, the
packet is dropped so that the memory remains available for page reclaim. 
Network protocols are expected to recover from this packet loss.

[a.p.zijlstra@chello.nl: Ideas taken from various patches]
[davem@davemloft.net: Use static branches, coding style corrections]
[sebastian@breakpoint.cc: Avoid unnecessary cast, fix !CONFIG_NET build]
Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Neil Brown <neilb@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Eric B Munson <emunson@mgebm.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h    |    3 
 include/linux/skbuff.h |   14 +++-
 include/net/sock.h     |   15 ++++
 mm/internal.h          |    3 
 net/core/filter.c      |    8 ++
 net/core/skbuff.c      |  124 +++++++++++++++++++++++++++++++--------
 net/core/sock.c        |    5 +
 7 files changed, 142 insertions(+), 30 deletions(-)

diff -puN include/linux/gfp.h~netvm-allow-skb-allocation-to-use-pfmemalloc-reserves include/linux/gfp.h
--- a/include/linux/gfp.h~netvm-allow-skb-allocation-to-use-pfmemalloc-reserves
+++ a/include/linux/gfp.h
@@ -385,6 +385,9 @@ void drain_local_pages(void *dummy);
  */
 extern gfp_t gfp_allowed_mask;
 
+/* Returns true if the gfp_mask allows use of ALLOC_NO_WATERMARK */
+bool gfp_pfmemalloc_allowed(gfp_t gfp_mask);
+
 extern void pm_restrict_gfp_mask(void);
 extern void pm_restore_gfp_mask(void);
 
diff -puN include/linux/skbuff.h~netvm-allow-skb-allocation-to-use-pfmemalloc-reserves include/linux/skbuff.h
--- a/include/linux/skbuff.h~netvm-allow-skb-allocation-to-use-pfmemalloc-reserves
+++ a/include/linux/skbuff.h
@@ -462,6 +462,7 @@ struct sk_buff {
 #ifdef CONFIG_IPV6_NDISC_NODETYPE
 	__u8			ndisc_nodetype:2;
 #endif
+	__u8			pfmemalloc:1;
 	__u8			ooo_okay:1;
 	__u8			l4_rxhash:1;
 	__u8			wifi_acked_valid:1;
@@ -502,6 +503,15 @@ struct sk_buff {
 #include <linux/slab.h>
 
 
+#define SKB_ALLOC_FCLONE	0x01
+#define SKB_ALLOC_RX		0x02
+
+/* Returns true if the skb was allocated from PFMEMALLOC reserves */
+static inline bool skb_pfmemalloc(const struct sk_buff *skb)
+{
+	return unlikely(skb->pfmemalloc);
+}
+
 /*
  * skb might have a dst pointer attached, refcounted or not.
  * _skb_refdst low order bit is set if refcount was _not_ taken
@@ -565,7 +575,7 @@ extern bool skb_try_coalesce(struct sk_b
 			     bool *fragstolen, int *delta_truesize);
 
 extern struct sk_buff *__alloc_skb(unsigned int size,
-				   gfp_t priority, int fclone, int node);
+				   gfp_t priority, int flags, int node);
 extern struct sk_buff *build_skb(void *data, unsigned int frag_size);
 static inline struct sk_buff *alloc_skb(unsigned int size,
 					gfp_t priority)
@@ -576,7 +586,7 @@ static inline struct sk_buff *alloc_skb(
 static inline struct sk_buff *alloc_skb_fclone(unsigned int size,
 					       gfp_t priority)
 {
-	return __alloc_skb(size, priority, 1, NUMA_NO_NODE);
+	return __alloc_skb(size, priority, SKB_ALLOC_FCLONE, NUMA_NO_NODE);
 }
 
 extern void skb_recycle(struct sk_buff *skb);
diff -puN include/net/sock.h~netvm-allow-skb-allocation-to-use-pfmemalloc-reserves include/net/sock.h
--- a/include/net/sock.h~netvm-allow-skb-allocation-to-use-pfmemalloc-reserves
+++ a/include/net/sock.h
@@ -659,6 +659,21 @@ static inline bool sock_flag(const struc
 	return test_bit(flag, &sk->sk_flags);
 }
 
+#ifdef CONFIG_NET
+extern struct static_key memalloc_socks;
+static inline int sk_memalloc_socks(void)
+{
+	return static_key_false(&memalloc_socks);
+}
+#else
+
+static inline int sk_memalloc_socks(void)
+{
+	return 0;
+}
+
+#endif
+
 static inline gfp_t sk_gfp_atomic(struct sock *sk, gfp_t gfp_mask)
 {
 	return GFP_ATOMIC | (sk->sk_allocation & __GFP_MEMALLOC);
diff -puN mm/internal.h~netvm-allow-skb-allocation-to-use-pfmemalloc-reserves mm/internal.h
--- a/mm/internal.h~netvm-allow-skb-allocation-to-use-pfmemalloc-reserves
+++ a/mm/internal.h
@@ -279,9 +279,6 @@ static inline struct page *mem_map_next(
 #define __paginginit __init
 #endif
 
-/* Returns true if the gfp_mask allows use of ALLOC_NO_WATERMARK */
-bool gfp_pfmemalloc_allowed(gfp_t gfp_mask);
-
 /* Memory initialisation debug and verification */
 enum mminit_level {
 	MMINIT_WARNING,
diff -puN net/core/filter.c~netvm-allow-skb-allocation-to-use-pfmemalloc-reserves net/core/filter.c
--- a/net/core/filter.c~netvm-allow-skb-allocation-to-use-pfmemalloc-reserves
+++ a/net/core/filter.c
@@ -83,6 +83,14 @@ int sk_filter(struct sock *sk, struct sk
 	int err;
 	struct sk_filter *filter;
 
+	/*
+	 * If the skb was allocated from pfmemalloc reserves, only
+	 * allow SOCK_MEMALLOC sockets to use it as this socket is
+	 * helping free memory
+	 */
+	if (skb_pfmemalloc(skb) && !sock_flag(sk, SOCK_MEMALLOC))
+		return -ENOMEM;
+
 	err = security_sock_rcv_skb(sk, skb);
 	if (err)
 		return err;
diff -puN net/core/skbuff.c~netvm-allow-skb-allocation-to-use-pfmemalloc-reserves net/core/skbuff.c
--- a/net/core/skbuff.c~netvm-allow-skb-allocation-to-use-pfmemalloc-reserves
+++ a/net/core/skbuff.c
@@ -145,6 +145,43 @@ static void skb_under_panic(struct sk_bu
 	BUG();
 }
 
+
+/*
+ * kmalloc_reserve is a wrapper around kmalloc_node_track_caller that tells
+ * the caller if emergency pfmemalloc reserves are being used. If it is and
+ * the socket is later found to be SOCK_MEMALLOC then PFMEMALLOC reserves
+ * may be used. Otherwise, the packet data may be discarded until enough
+ * memory is free
+ */
+#define kmalloc_reserve(size, gfp, node, pfmemalloc) \
+	 __kmalloc_reserve(size, gfp, node, _RET_IP_, pfmemalloc)
+void *__kmalloc_reserve(size_t size, gfp_t flags, int node, unsigned long ip,
+			 bool *pfmemalloc)
+{
+	void *obj;
+	bool ret_pfmemalloc = false;
+
+	/*
+	 * Try a regular allocation, when that fails and we're not entitled
+	 * to the reserves, fail.
+	 */
+	obj = kmalloc_node_track_caller(size,
+					flags | __GFP_NOMEMALLOC | __GFP_NOWARN,
+					node);
+	if (obj || !(gfp_pfmemalloc_allowed(flags)))
+		goto out;
+
+	/* Try again but now we are using pfmemalloc reserves */
+	ret_pfmemalloc = true;
+	obj = kmalloc_node_track_caller(size, flags, node);
+
+out:
+	if (pfmemalloc)
+		*pfmemalloc = ret_pfmemalloc;
+
+	return obj;
+}
+
 /* 	Allocate a new skbuff. We do this ourselves so we can fill in a few
  *	'private' fields and also do memory statistics to find all the
  *	[BEEP] leaks.
@@ -155,8 +192,10 @@ static void skb_under_panic(struct sk_bu
  *	__alloc_skb	-	allocate a network buffer
  *	@size: size to allocate
  *	@gfp_mask: allocation mask
- *	@fclone: allocate from fclone cache instead of head cache
- *		and allocate a cloned (child) skb
+ *	@flags: If SKB_ALLOC_FCLONE is set, allocate from fclone cache
+ *		instead of head cache and allocate a cloned (child) skb.
+ *		If SKB_ALLOC_RX is set, __GFP_MEMALLOC will be used for
+ *		allocations in case the data is required for writeback
  *	@node: numa node to allocate memory on
  *
  *	Allocate a new &sk_buff. The returned buffer has no headroom and a
@@ -167,14 +206,19 @@ static void skb_under_panic(struct sk_bu
  *	%GFP_ATOMIC.
  */
 struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
-			    int fclone, int node)
+			    int flags, int node)
 {
 	struct kmem_cache *cache;
 	struct skb_shared_info *shinfo;
 	struct sk_buff *skb;
 	u8 *data;
+	bool pfmemalloc;
 
-	cache = fclone ? skbuff_fclone_cache : skbuff_head_cache;
+	cache = (flags & SKB_ALLOC_FCLONE)
+		? skbuff_fclone_cache : skbuff_head_cache;
+
+	if (sk_memalloc_socks() && (flags & SKB_ALLOC_RX))
+		gfp_mask |= __GFP_MEMALLOC;
 
 	/* Get the HEAD */
 	skb = kmem_cache_alloc_node(cache, gfp_mask & ~__GFP_DMA, node);
@@ -189,7 +233,7 @@ struct sk_buff *__alloc_skb(unsigned int
 	 */
 	size = SKB_DATA_ALIGN(size);
 	size += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
-	data = kmalloc_node_track_caller(size, gfp_mask, node);
+	data = kmalloc_reserve(size, gfp_mask, node, &pfmemalloc);
 	if (!data)
 		goto nodata;
 	/* kmalloc(size) might give us more room than requested.
@@ -207,6 +251,7 @@ struct sk_buff *__alloc_skb(unsigned int
 	memset(skb, 0, offsetof(struct sk_buff, tail));
 	/* Account for allocated memory : skb + skb->head */
 	skb->truesize = SKB_TRUESIZE(size);
+	skb->pfmemalloc = pfmemalloc;
 	atomic_set(&skb->users, 1);
 	skb->head = data;
 	skb->data = data;
@@ -222,7 +267,7 @@ struct sk_buff *__alloc_skb(unsigned int
 	atomic_set(&shinfo->dataref, 1);
 	kmemcheck_annotate_variable(shinfo->destructor_arg);
 
-	if (fclone) {
+	if (flags & SKB_ALLOC_FCLONE) {
 		struct sk_buff *child = skb + 1;
 		atomic_t *fclone_ref = (atomic_t *) (child + 1);
 
@@ -232,6 +277,7 @@ struct sk_buff *__alloc_skb(unsigned int
 		atomic_set(fclone_ref, 1);
 
 		child->fclone = SKB_FCLONE_UNAVAILABLE;
+		child->pfmemalloc = pfmemalloc;
 	}
 out:
 	return skb;
@@ -302,14 +348,7 @@ static DEFINE_PER_CPU(struct netdev_allo
 
 #define NETDEV_PAGECNT_BIAS (PAGE_SIZE / SMP_CACHE_BYTES)
 
-/**
- * netdev_alloc_frag - allocate a page fragment
- * @fragsz: fragment size
- *
- * Allocates a frag from a page for receive buffer.
- * Uses GFP_ATOMIC allocations.
- */
-void *netdev_alloc_frag(unsigned int fragsz)
+static void *__netdev_alloc_frag(unsigned int fragsz, gfp_t gfp_mask)
 {
 	struct netdev_alloc_cache *nc;
 	void *data = NULL;
@@ -319,7 +358,7 @@ void *netdev_alloc_frag(unsigned int fra
 	nc = &__get_cpu_var(netdev_alloc_cache);
 	if (unlikely(!nc->page)) {
 refill:
-		nc->page = alloc_page(GFP_ATOMIC | __GFP_COLD);
+		nc->page = alloc_page(gfp_mask);
 		if (unlikely(!nc->page))
 			goto end;
 recycle:
@@ -343,6 +382,18 @@ end:
 	local_irq_restore(flags);
 	return data;
 }
+
+/**
+ * netdev_alloc_frag - allocate a page fragment
+ * @fragsz: fragment size
+ *
+ * Allocates a frag from a page for receive buffer.
+ * Uses GFP_ATOMIC allocations.
+ */
+void *netdev_alloc_frag(unsigned int fragsz)
+{
+	return __netdev_alloc_frag(fragsz, GFP_ATOMIC | __GFP_COLD);
+}
 EXPORT_SYMBOL(netdev_alloc_frag);
 
 /**
@@ -366,7 +417,12 @@ struct sk_buff *__netdev_alloc_skb(struc
 			      SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 
 	if (fragsz <= PAGE_SIZE && !(gfp_mask & (__GFP_WAIT | GFP_DMA))) {
-		void *data = netdev_alloc_frag(fragsz);
+		void *data;
+
+		if (sk_memalloc_socks())
+			gfp_mask |= __GFP_MEMALLOC;
+
+		data = __netdev_alloc_frag(fragsz, gfp_mask);
 
 		if (likely(data)) {
 			skb = build_skb(data, fragsz);
@@ -374,7 +430,8 @@ struct sk_buff *__netdev_alloc_skb(struc
 				put_page(virt_to_head_page(data));
 		}
 	} else {
-		skb = __alloc_skb(length + NET_SKB_PAD, gfp_mask, 0, NUMA_NO_NODE);
+		skb = __alloc_skb(length + NET_SKB_PAD, gfp_mask,
+				  SKB_ALLOC_RX, NUMA_NO_NODE);
 	}
 	if (likely(skb)) {
 		skb_reserve(skb, NET_SKB_PAD);
@@ -656,6 +713,7 @@ static void __copy_skb_header(struct sk_
 #if IS_ENABLED(CONFIG_IP_VS)
 	new->ipvs_property	= old->ipvs_property;
 #endif
+	new->pfmemalloc		= old->pfmemalloc;
 	new->protocol		= old->protocol;
 	new->mark		= old->mark;
 	new->skb_iif		= old->skb_iif;
@@ -814,6 +872,9 @@ struct sk_buff *skb_clone(struct sk_buff
 		n->fclone = SKB_FCLONE_CLONE;
 		atomic_inc(fclone_ref);
 	} else {
+		if (skb_pfmemalloc(skb))
+			gfp_mask |= __GFP_MEMALLOC;
+
 		n = kmem_cache_alloc(skbuff_head_cache, gfp_mask);
 		if (!n)
 			return NULL;
@@ -850,6 +911,13 @@ static void copy_skb_header(struct sk_bu
 	skb_shinfo(new)->gso_type = skb_shinfo(old)->gso_type;
 }
 
+static inline int skb_alloc_rx_flag(const struct sk_buff *skb)
+{
+	if (skb_pfmemalloc(skb))
+		return SKB_ALLOC_RX;
+	return 0;
+}
+
 /**
  *	skb_copy	-	create private copy of an sk_buff
  *	@skb: buffer to copy
@@ -871,7 +939,8 @@ struct sk_buff *skb_copy(const struct sk
 {
 	int headerlen = skb_headroom(skb);
 	unsigned int size = skb_end_offset(skb) + skb->data_len;
-	struct sk_buff *n = alloc_skb(size, gfp_mask);
+	struct sk_buff *n = __alloc_skb(size, gfp_mask,
+					skb_alloc_rx_flag(skb), NUMA_NO_NODE);
 
 	if (!n)
 		return NULL;
@@ -906,7 +975,8 @@ EXPORT_SYMBOL(skb_copy);
 struct sk_buff *__pskb_copy(struct sk_buff *skb, int headroom, gfp_t gfp_mask)
 {
 	unsigned int size = skb_headlen(skb) + headroom;
-	struct sk_buff *n = alloc_skb(size, gfp_mask);
+	struct sk_buff *n = __alloc_skb(size, gfp_mask,
+					skb_alloc_rx_flag(skb), NUMA_NO_NODE);
 
 	if (!n)
 		goto out;
@@ -979,8 +1049,10 @@ int pskb_expand_head(struct sk_buff *skb
 
 	size = SKB_DATA_ALIGN(size);
 
-	data = kmalloc(size + SKB_DATA_ALIGN(sizeof(struct skb_shared_info)),
-		       gfp_mask);
+	if (skb_pfmemalloc(skb))
+		gfp_mask |= __GFP_MEMALLOC;
+	data = kmalloc_reserve(size + SKB_DATA_ALIGN(sizeof(struct skb_shared_info)),
+			       gfp_mask, NUMA_NO_NODE, NULL);
 	if (!data)
 		goto nodata;
 	size = SKB_WITH_OVERHEAD(ksize(data));
@@ -1092,8 +1164,9 @@ struct sk_buff *skb_copy_expand(const st
 	/*
 	 *	Allocate the copy buffer
 	 */
-	struct sk_buff *n = alloc_skb(newheadroom + skb->len + newtailroom,
-				      gfp_mask);
+	struct sk_buff *n = __alloc_skb(newheadroom + skb->len + newtailroom,
+					gfp_mask, skb_alloc_rx_flag(skb),
+					NUMA_NO_NODE);
 	int oldheadroom = skb_headroom(skb);
 	int head_copy_len, head_copy_off;
 	int off;
@@ -2775,8 +2848,9 @@ struct sk_buff *skb_segment(struct sk_bu
 			skb_release_head_state(nskb);
 			__skb_push(nskb, doffset);
 		} else {
-			nskb = alloc_skb(hsize + doffset + headroom,
-					 GFP_ATOMIC);
+			nskb = __alloc_skb(hsize + doffset + headroom,
+					   GFP_ATOMIC, skb_alloc_rx_flag(skb),
+					   NUMA_NO_NODE);
 
 			if (unlikely(!nskb))
 				goto err;
diff -puN net/core/sock.c~netvm-allow-skb-allocation-to-use-pfmemalloc-reserves net/core/sock.c
--- a/net/core/sock.c~netvm-allow-skb-allocation-to-use-pfmemalloc-reserves
+++ a/net/core/sock.c
@@ -271,6 +271,9 @@ __u32 sysctl_rmem_default __read_mostly 
 int sysctl_optmem_max __read_mostly = sizeof(unsigned long)*(2*UIO_MAXIOV+512);
 EXPORT_SYMBOL(sysctl_optmem_max);
 
+struct static_key memalloc_socks = STATIC_KEY_INIT_FALSE;
+EXPORT_SYMBOL_GPL(memalloc_socks);
+
 /**
  * sk_set_memalloc - sets %SOCK_MEMALLOC
  * @sk: socket to set it on
@@ -283,6 +286,7 @@ void sk_set_memalloc(struct sock *sk)
 {
 	sock_set_flag(sk, SOCK_MEMALLOC);
 	sk->sk_allocation |= __GFP_MEMALLOC;
+	static_key_slow_inc(&memalloc_socks);
 }
 EXPORT_SYMBOL_GPL(sk_set_memalloc);
 
@@ -290,6 +294,7 @@ void sk_clear_memalloc(struct sock *sk)
 {
 	sock_reset_flag(sk, SOCK_MEMALLOC);
 	sk->sk_allocation &= ~__GFP_MEMALLOC;
+	static_key_slow_dec(&memalloc_socks);
 }
 EXPORT_SYMBOL_GPL(sk_clear_memalloc);
 
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch

