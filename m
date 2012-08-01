From: akpm@linux-foundation.org
Subject: [merged] netvm-set-pf_memalloc-as-appropriate-during-skb-processing.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:16:22 -0700
Message-ID: <20120801201622.EA6A31E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:52099 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab2HAUQY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:16:24 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so5412588obb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:16:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, a.p.zijlstra@chello.nl, cl@linux.com, davem@davemloft.net, emunson@mgebm.net, eric.dumazet@gmail.com, michaelc@cs.wisc.edu, neilb@suse.de, sebastian@breakpoint.cc, mm-commits@vger.kernel.org


The patch titled
     Subject: netvm: set PF_MEMALLOC as appropriate during SKB processing
has been removed from the -mm tree.  Its filename was
     netvm-set-pf_memalloc-as-appropriate-during-skb-processing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: netvm: set PF_MEMALLOC as appropriate during SKB processing

In order to make sure pfmemalloc packets receive all memory needed to
proceed, ensure processing of pfmemalloc SKBs happens under PF_MEMALLOC. 
This is limited to a subset of protocols that are expected to be used for
writing to swap.  Taps are not allowed to use PF_MEMALLOC as these are
expected to communicate with userspace processes which could be paged out.

[a.p.zijlstra@chello.nl: Ideas taken from various patches]
[jslaby@suse.cz: Lock imbalance fix]
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

 include/net/sock.h |    5 ++++
 net/core/dev.c     |   53 ++++++++++++++++++++++++++++++++++++++-----
 net/core/sock.c    |   16 ++++++++++++
 3 files changed, 68 insertions(+), 6 deletions(-)

diff -puN include/net/sock.h~netvm-set-pf_memalloc-as-appropriate-during-skb-processing include/net/sock.h
--- a/include/net/sock.h~netvm-set-pf_memalloc-as-appropriate-during-skb-processing
+++ a/include/net/sock.h
@@ -754,8 +754,13 @@ static inline __must_check int sk_add_ba
 	return 0;
 }
 
+extern int __sk_backlog_rcv(struct sock *sk, struct sk_buff *skb);
+
 static inline int sk_backlog_rcv(struct sock *sk, struct sk_buff *skb)
 {
+	if (sk_memalloc_socks() && skb_pfmemalloc(skb))
+		return __sk_backlog_rcv(sk, skb);
+
 	return sk->sk_backlog_rcv(sk, skb);
 }
 
diff -puN net/core/dev.c~netvm-set-pf_memalloc-as-appropriate-during-skb-processing net/core/dev.c
--- a/net/core/dev.c~netvm-set-pf_memalloc-as-appropriate-during-skb-processing
+++ a/net/core/dev.c
@@ -3155,6 +3155,23 @@ void netdev_rx_handler_unregister(struct
 }
 EXPORT_SYMBOL_GPL(netdev_rx_handler_unregister);
 
+/*
+ * Limit the use of PFMEMALLOC reserves to those protocols that implement
+ * the special handling of PFMEMALLOC skbs.
+ */
+static bool skb_pfmemalloc_protocol(struct sk_buff *skb)
+{
+	switch (skb->protocol) {
+	case __constant_htons(ETH_P_ARP):
+	case __constant_htons(ETH_P_IP):
+	case __constant_htons(ETH_P_IPV6):
+	case __constant_htons(ETH_P_8021Q):
+		return true;
+	default:
+		return false;
+	}
+}
+
 static int __netif_receive_skb(struct sk_buff *skb)
 {
 	struct packet_type *ptype, *pt_prev;
@@ -3164,14 +3181,27 @@ static int __netif_receive_skb(struct sk
 	bool deliver_exact = false;
 	int ret = NET_RX_DROP;
 	__be16 type;
+	unsigned long pflags = current->flags;
 
 	net_timestamp_check(!netdev_tstamp_prequeue, skb);
 
 	trace_netif_receive_skb(skb);
 
+	/*
+	 * PFMEMALLOC skbs are special, they should
+	 * - be delivered to SOCK_MEMALLOC sockets only
+	 * - stay away from userspace
+	 * - have bounded memory usage
+	 *
+	 * Use PF_MEMALLOC as this saves us from propagating the allocation
+	 * context down to all allocation sites.
+	 */
+	if (sk_memalloc_socks() && skb_pfmemalloc(skb))
+		current->flags |= PF_MEMALLOC;
+
 	/* if we've gotten here through NAPI, check netpoll */
 	if (netpoll_receive_skb(skb))
-		return NET_RX_DROP;
+		goto out;
 
 	orig_dev = skb->dev;
 
@@ -3191,7 +3221,7 @@ another_round:
 	if (skb->protocol == cpu_to_be16(ETH_P_8021Q)) {
 		skb = vlan_untag(skb);
 		if (unlikely(!skb))
-			goto out;
+			goto unlock;
 	}
 
 #ifdef CONFIG_NET_CLS_ACT
@@ -3201,6 +3231,9 @@ another_round:
 	}
 #endif
 
+	if (sk_memalloc_socks() && skb_pfmemalloc(skb))
+		goto skip_taps;
+
 	list_for_each_entry_rcu(ptype, &ptype_all, list) {
 		if (!ptype->dev || ptype->dev == skb->dev) {
 			if (pt_prev)
@@ -3209,13 +3242,18 @@ another_round:
 		}
 	}
 
+skip_taps:
 #ifdef CONFIG_NET_CLS_ACT
 	skb = handle_ing(skb, &pt_prev, &ret, orig_dev);
 	if (!skb)
-		goto out;
+		goto unlock;
 ncls:
 #endif
 
+	if (sk_memalloc_socks() && skb_pfmemalloc(skb)
+				&& !skb_pfmemalloc_protocol(skb))
+		goto drop;
+
 	rx_handler = rcu_dereference(skb->dev->rx_handler);
 	if (vlan_tx_tag_present(skb)) {
 		if (pt_prev) {
@@ -3225,7 +3263,7 @@ ncls:
 		if (vlan_do_receive(&skb, !rx_handler))
 			goto another_round;
 		else if (unlikely(!skb))
-			goto out;
+			goto unlock;
 	}
 
 	if (rx_handler) {
@@ -3235,7 +3273,7 @@ ncls:
 		}
 		switch (rx_handler(&skb)) {
 		case RX_HANDLER_CONSUMED:
-			goto out;
+			goto unlock;
 		case RX_HANDLER_ANOTHER:
 			goto another_round;
 		case RX_HANDLER_EXACT:
@@ -3268,6 +3306,7 @@ ncls:
 		else
 			ret = pt_prev->func(skb, skb->dev, pt_prev, orig_dev);
 	} else {
+drop:
 		atomic_long_inc(&skb->dev->rx_dropped);
 		kfree_skb(skb);
 		/* Jamal, now you will not able to escape explaining
@@ -3276,8 +3315,10 @@ ncls:
 		ret = NET_RX_DROP;
 	}
 
-out:
+unlock:
 	rcu_read_unlock();
+out:
+	tsk_restore_flags(current, pflags, PF_MEMALLOC);
 	return ret;
 }
 
diff -puN net/core/sock.c~netvm-set-pf_memalloc-as-appropriate-during-skb-processing net/core/sock.c
--- a/net/core/sock.c~netvm-set-pf_memalloc-as-appropriate-during-skb-processing
+++ a/net/core/sock.c
@@ -298,6 +298,22 @@ void sk_clear_memalloc(struct sock *sk)
 }
 EXPORT_SYMBOL_GPL(sk_clear_memalloc);
 
+int __sk_backlog_rcv(struct sock *sk, struct sk_buff *skb)
+{
+	int ret;
+	unsigned long pflags = current->flags;
+
+	/* these should have been dropped before queueing */
+	BUG_ON(!sock_flag(sk, SOCK_MEMALLOC));
+
+	current->flags |= PF_MEMALLOC;
+	ret = sk->sk_backlog_rcv(sk, skb);
+	tsk_restore_flags(current, pflags, PF_MEMALLOC);
+
+	return ret;
+}
+EXPORT_SYMBOL(__sk_backlog_rcv);
+
 #if defined(CONFIG_CGROUPS)
 #if !defined(CONFIG_NET_CLS_CGROUP)
 int net_cls_subsys_id = -1;
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch

