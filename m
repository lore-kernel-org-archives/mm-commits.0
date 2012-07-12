From: akpm@linux-foundation.org
Subject: + netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb.patch added to -mm tree
Date: Thu, 12 Jul 2012 14:27:59 -0700
Message-ID: <20120712212800.0D04E20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:50163 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161112Ab2GLV2D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 17:28:03 -0400
Received: by fat25 with SMTP id 25so147134fat.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 14:28:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, a.p.zijlstra@chello.nl, cl@linux.com, davem@davemloft.net, emunson@mgebm.net, eric.dumazet@gmail.com, michaelc@cs.wisc.edu, neilb@suse.de, sebastian@breakpoint.cc


The patch titled
     Subject: netvm: propagate page->pfmemalloc from skb_alloc_page to skb
has been added to the -mm tree.  Its filename is
     netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: netvm: propagate page->pfmemalloc from skb_alloc_page to skb

The skb->pfmemalloc flag gets set to true iff during the slab allocation
of data in __alloc_skb that the the PFMEMALLOC reserves were used.  If
page splitting is used, it is possible that pages will be allocated from
the PFMEMALLOC reserve without propagating this information to the skb. 
This patch propagates page->pfmemalloc from pages allocated for fragments
to the skb.

It works by reintroducing and expanding the skb_alloc_page() API to take
an skb.  If the page was allocated from pfmemalloc reserves, it is
automatically copied.  If the driver allocates the page before the skb, it
should call skb_propagate_pfmemalloc() after the skb is allocated to
ensure the flag is copied properly.

Failure to do so is not critical.  The resulting driver may perform slower
if it is used for swap-over-NBD or swap-over-NFS but it should not result
in failure.

[davem@davemloft.net: API rename and consistency]
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

 drivers/net/ethernet/chelsio/cxgb4/sge.c          |    2 
 drivers/net/ethernet/chelsio/cxgb4vf/sge.c        |    2 
 drivers/net/ethernet/intel/igb/igb_main.c         |    2 
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c     |    4 
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c |    3 
 drivers/net/usb/cdc-phonet.c                      |    2 
 drivers/usb/gadget/f_phonet.c                     |    2 
 include/linux/skbuff.h                            |   55 ++++++++++++
 8 files changed, 64 insertions(+), 8 deletions(-)

diff -puN drivers/net/ethernet/chelsio/cxgb4/sge.c~netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb drivers/net/ethernet/chelsio/cxgb4/sge.c
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c~netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb
+++ a/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -528,7 +528,7 @@ static unsigned int refill_fl(struct ada
 #endif
 
 	while (n--) {
-		pg = alloc_page(gfp);
+		pg = __skb_alloc_page(gfp, NULL);
 		if (unlikely(!pg)) {
 			q->alloc_failed++;
 			break;
diff -puN drivers/net/ethernet/chelsio/cxgb4vf/sge.c~netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb drivers/net/ethernet/chelsio/cxgb4vf/sge.c
--- a/drivers/net/ethernet/chelsio/cxgb4vf/sge.c~netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb
+++ a/drivers/net/ethernet/chelsio/cxgb4vf/sge.c
@@ -653,7 +653,7 @@ static unsigned int refill_fl(struct ada
 
 alloc_small_pages:
 	while (n--) {
-		page = alloc_page(gfp | __GFP_NOWARN | __GFP_COLD);
+		page = __skb_alloc_page(gfp | __GFP_NOWARN, NULL);
 		if (unlikely(!page)) {
 			fl->alloc_failed++;
 			break;
diff -puN drivers/net/ethernet/intel/igb/igb_main.c~netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb drivers/net/ethernet/intel/igb/igb_main.c
--- a/drivers/net/ethernet/intel/igb/igb_main.c~netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb
+++ a/drivers/net/ethernet/intel/igb/igb_main.c
@@ -6234,7 +6234,7 @@ static bool igb_alloc_mapped_page(struct
 		return true;
 
 	if (!page) {
-		page = alloc_page(GFP_ATOMIC | __GFP_COLD);
+		page = __skb_alloc_page(GFP_ATOMIC, bi->skb);
 		bi->page = page;
 		if (unlikely(!page)) {
 			rx_ring->rx_stats.alloc_failed++;
diff -puN drivers/net/ethernet/intel/ixgbe/ixgbe_main.c~netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c~netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb
+++ a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -1146,8 +1146,8 @@ static bool ixgbe_alloc_mapped_page(stru
 
 	/* alloc new page for storage */
 	if (likely(!page)) {
-		page = alloc_pages(GFP_ATOMIC | __GFP_COLD | __GFP_COMP,
-				   ixgbe_rx_pg_order(rx_ring));
+		page = __skb_alloc_pages(GFP_ATOMIC | __GFP_COLD | __GFP_COMP,
+				 	 bi->skb, ixgbe_rx_pg_order(rx_ring));
 		if (unlikely(!page)) {
 			rx_ring->rx_stats.alloc_rx_page_failed++;
 			return false;
diff -puN drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c~netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c~netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb
+++ a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -369,7 +369,7 @@ static void ixgbevf_alloc_rx_buffers(str
 		if (!bi->page_dma &&
 		    (adapter->flags & IXGBE_FLAG_RX_PS_ENABLED)) {
 			if (!bi->page) {
-				bi->page = alloc_page(GFP_ATOMIC | __GFP_COLD);
+				bi->page = __skb_alloc_page(GFP_ATOMIC, NULL);
 				if (!bi->page) {
 					adapter->alloc_rx_page_failed++;
 					goto no_buffers;
@@ -403,6 +403,7 @@ static void ixgbevf_alloc_rx_buffers(str
 			 */
 			skb_reserve(skb, NET_IP_ALIGN);
 
+			skb_propagate_pfmemalloc(bi->page, skb);
 			bi->skb = skb;
 		}
 		if (!bi->dma) {
diff -puN drivers/net/usb/cdc-phonet.c~netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb drivers/net/usb/cdc-phonet.c
--- a/drivers/net/usb/cdc-phonet.c~netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb
+++ a/drivers/net/usb/cdc-phonet.c
@@ -130,7 +130,7 @@ static int rx_submit(struct usbpn_dev *p
 	struct page *page;
 	int err;
 
-	page = alloc_page(gfp_flags);
+	page = __skb_alloc_page(gfp_flags | __GFP_NOMEMALLOC, NULL);
 	if (!page)
 		return -ENOMEM;
 
diff -puN drivers/usb/gadget/f_phonet.c~netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb drivers/usb/gadget/f_phonet.c
--- a/drivers/usb/gadget/f_phonet.c~netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb
+++ a/drivers/usb/gadget/f_phonet.c
@@ -301,7 +301,7 @@ pn_rx_submit(struct f_phonet *fp, struct
 	struct page *page;
 	int err;
 
-	page = alloc_page(gfp_flags);
+	page = __skb_alloc_page(gfp_flags | __GFP_NOMEMALLOC, NULL);
 	if (!page)
 		return -ENOMEM;
 
diff -puN include/linux/skbuff.h~netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb include/linux/skbuff.h
--- a/include/linux/skbuff.h~netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb
+++ a/include/linux/skbuff.h
@@ -1774,6 +1774,61 @@ static inline struct sk_buff *netdev_all
 	return __netdev_alloc_skb_ip_align(dev, length, GFP_ATOMIC);
 }
 
+/*
+ *	__skb_alloc_page - allocate pages for ps-rx on a skb and preserve pfmemalloc data
+ *	@gfp_mask: alloc_pages_node mask. Set __GFP_NOMEMALLOC if not for network packet RX
+ *	@skb: skb to set pfmemalloc on if __GFP_MEMALLOC is used
+ *	@order: size of the allocation
+ *
+ * 	Allocate a new page.
+ *
+ * 	%NULL is returned if there is no free memory.
+*/
+static inline struct page *__skb_alloc_pages(gfp_t gfp_mask,
+					      struct sk_buff *skb,
+					      unsigned int order)
+{
+	struct page *page;
+
+	gfp_mask |= __GFP_COLD;
+
+	if (!(gfp_mask & __GFP_NOMEMALLOC))
+		gfp_mask |= __GFP_MEMALLOC;
+
+	page = alloc_pages_node(NUMA_NO_NODE, gfp_mask, order);
+	if (skb && page && page->pfmemalloc)
+		skb->pfmemalloc = true;
+
+	return page;
+}
+
+/**
+ *	__skb_alloc_page - allocate a page for ps-rx for a given skb and preserve pfmemalloc data
+ *	@gfp_mask: alloc_pages_node mask. Set __GFP_NOMEMALLOC if not for network packet RX
+ *	@skb: skb to set pfmemalloc on if __GFP_MEMALLOC is used
+ *
+ * 	Allocate a new page.
+ *
+ * 	%NULL is returned if there is no free memory.
+ */
+static inline struct page *__skb_alloc_page(gfp_t gfp_mask,
+					     struct sk_buff *skb)
+{
+	return __skb_alloc_pages(gfp_mask, skb, 0);
+}
+
+/**
+ *	skb_propagate_pfmemalloc - Propagate pfmemalloc if skb is allocated after RX page
+ *	@page: The page that was allocated from skb_alloc_page
+ *	@skb: The skb that may need pfmemalloc set
+ */
+static inline void skb_propagate_pfmemalloc(struct page *page,
+					     struct sk_buff *skb)
+{
+	if (page && page->pfmemalloc)
+		skb->pfmemalloc = true;
+}
+
 /**
  * skb_frag_page - retrieve the page refered to by a paged fragment
  * @frag: the paged fragment
_
Subject: Subject: netvm: propagate page->pfmemalloc from skb_alloc_page to skb

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
memcg-prevent-oom-with-too-many-dirty-pages-fix.patch
mm-do-not-use-page_count-without-a-page-pin.patch
mm-clean-up-__count_immobile_pages.patch
mm-hotplug-correctly-setup-fallback-zonelists-when-creating-new-pgdat.patch
mm-hotplug-correctly-add-new-zone-to-all-other-nodes-zone-lists.patch
mm-hotplug-free-zone-pageset-when-a-zone-becomes-empty.patch
mm-hotplug-mark-memory-hotplug-code-in-page_allocc-as-__meminit.patch
mm-factor-out-memory-isolate-functions.patch
mm-bug-fix-free-page-check-in-zone_watermark_ok.patch
memory-hotplug-fix-kswapd-looping-forever-problem.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix.patch
mm-slb-add-knowledge-of-pfmemalloc-reserve-pages.patch
mm-slub-optimise-the-slub-fast-path-to-avoid-pfmemalloc-checks.patch
mm-introduce-__gfp_memalloc-to-allow-access-to-emergency-reserves.patch
mm-allow-pf_memalloc-from-softirq-context.patch
mm-only-set-page-pfmemalloc-when-alloc_no_watermarks-was-used.patch
mm-ignore-mempolicies-when-using-alloc_no_watermark.patch
net-introduce-sk_gfp_atomic-to-allow-addition-of-gfp-flags-depending-on-the-individual-socket.patch
netvm-allow-the-use-of-__gfp_memalloc-by-specific-sockets.patch
netvm-allow-skb-allocation-to-use-pfmemalloc-reserves.patch
netvm-propagate-page-pfmemalloc-to-skb.patch
netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb.patch
netvm-set-pf_memalloc-as-appropriate-during-skb-processing.patch
mm-micro-optimise-slab-to-avoid-a-function-call.patch
nbd-set-sock_memalloc-for-access-to-pfmemalloc-reserves.patch
mm-throttle-direct-reclaimers-if-pf_memalloc-reserves-are-low-and-swap-is-backed-by-network-storage.patch
mm-account-for-the-number-of-times-direct-reclaimers-get-throttled.patch

