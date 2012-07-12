From: akpm@linux-foundation.org
Subject: + net-introduce-sk_gfp_atomic-to-allow-addition-of-gfp-flags-depending-on-the-individual-socket.patch added to -mm tree
Date: Thu, 12 Jul 2012 14:27:43 -0700
Message-ID: <20120712212743.D9CF820004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:41948 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932971Ab2GLV1r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 17:27:47 -0400
Received: by bkcjc3 with SMTP id jc3so148697bkc.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 14:27:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, a.p.zijlstra@chello.nl, cl@linux.com, davem@davemloft.net, emunson@mgebm.net, eric.dumazet@gmail.com, michaelc@cs.wisc.edu, neilb@suse.de, sebastian@breakpoint.cc


The patch titled
     Subject: net: introduce sk_gfp_atomic() to allow addition of GFP flags depending on the individual socket
has been added to the -mm tree.  Its filename is
     net-introduce-sk_gfp_atomic-to-allow-addition-of-gfp-flags-depending-on-the-individual-socket.patch

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
Subject: net: introduce sk_gfp_atomic() to allow addition of GFP flags depending on the individual socket

Introduce sk_gfp_atomic(), this function allows to inject sock specific
flags to each sock related allocation.  It is only used on allocation
paths that may be required for writing pages back to network storage.

[davem@davemloft.net: Use sk_gfp_atomic only when necessary]
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Neil Brown <neilb@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Eric B Munson <emunson@mgebm.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/net/sock.h    |    5 +++++
 net/ipv4/tcp_output.c |   12 +++++++-----
 net/ipv6/tcp_ipv6.c   |    8 +++++---
 3 files changed, 17 insertions(+), 8 deletions(-)

diff -puN include/net/sock.h~net-introduce-sk_gfp_atomic-to-allow-addition-of-gfp-flags-depending-on-the-individual-socket include/net/sock.h
--- a/include/net/sock.h~net-introduce-sk_gfp_atomic-to-allow-addition-of-gfp-flags-depending-on-the-individual-socket
+++ a/include/net/sock.h
@@ -658,6 +658,11 @@ static inline bool sock_flag(const struc
 	return test_bit(flag, &sk->sk_flags);
 }
 
+static inline gfp_t sk_gfp_atomic(struct sock *sk, gfp_t gfp_mask)
+{
+	return GFP_ATOMIC;
+}
+
 static inline void sk_acceptq_removed(struct sock *sk)
 {
 	sk->sk_ack_backlog--;
diff -puN net/ipv4/tcp_output.c~net-introduce-sk_gfp_atomic-to-allow-addition-of-gfp-flags-depending-on-the-individual-socket net/ipv4/tcp_output.c
--- a/net/ipv4/tcp_output.c~net-introduce-sk_gfp_atomic-to-allow-addition-of-gfp-flags-depending-on-the-individual-socket
+++ a/net/ipv4/tcp_output.c
@@ -1849,7 +1849,8 @@ void __tcp_push_pending_frames(struct so
 	if (unlikely(sk->sk_state == TCP_CLOSE))
 		return;
 
-	if (tcp_write_xmit(sk, cur_mss, nonagle, 0, GFP_ATOMIC))
+	if (tcp_write_xmit(sk, cur_mss, nonagle, 0,
+			   sk_gfp_atomic(sk, GFP_ATOMIC)))
 		tcp_check_probe_timer(sk);
 }
 
@@ -2470,7 +2471,8 @@ struct sk_buff *tcp_make_synack(struct s
 
 	if (cvp != NULL && cvp->s_data_constant && cvp->s_data_desired)
 		s_data_desired = cvp->s_data_desired;
-	skb = alloc_skb(MAX_TCP_HEADER + 15 + s_data_desired, GFP_ATOMIC);
+	skb = alloc_skb(MAX_TCP_HEADER + 15 + s_data_desired,
+			sk_gfp_atomic(sk, GFP_ATOMIC));
 	if (unlikely(!skb)) {
 		dst_release(dst);
 		return NULL;
@@ -2769,7 +2771,7 @@ void tcp_send_ack(struct sock *sk)
 	 * tcp_transmit_skb() will set the ownership to this
 	 * sock.
 	 */
-	buff = alloc_skb(MAX_TCP_HEADER, GFP_ATOMIC);
+	buff = alloc_skb(MAX_TCP_HEADER, sk_gfp_atomic(sk, GFP_ATOMIC));
 	if (buff == NULL) {
 		inet_csk_schedule_ack(sk);
 		inet_csk(sk)->icsk_ack.ato = TCP_ATO_MIN;
@@ -2784,7 +2786,7 @@ void tcp_send_ack(struct sock *sk)
 
 	/* Send it off, this clears delayed acks for us. */
 	TCP_SKB_CB(buff)->when = tcp_time_stamp;
-	tcp_transmit_skb(sk, buff, 0, GFP_ATOMIC);
+	tcp_transmit_skb(sk, buff, 0, sk_gfp_atomic(sk, GFP_ATOMIC));
 }
 
 /* This routine sends a packet with an out of date sequence
@@ -2804,7 +2806,7 @@ static int tcp_xmit_probe_skb(struct soc
 	struct sk_buff *skb;
 
 	/* We don't queue it, tcp_transmit_skb() sets ownership. */
-	skb = alloc_skb(MAX_TCP_HEADER, GFP_ATOMIC);
+	skb = alloc_skb(MAX_TCP_HEADER, sk_gfp_atomic(sk, GFP_ATOMIC));
 	if (skb == NULL)
 		return -1;
 
diff -puN net/ipv6/tcp_ipv6.c~net-introduce-sk_gfp_atomic-to-allow-addition-of-gfp-flags-depending-on-the-individual-socket net/ipv6/tcp_ipv6.c
--- a/net/ipv6/tcp_ipv6.c~net-introduce-sk_gfp_atomic-to-allow-addition-of-gfp-flags-depending-on-the-individual-socket
+++ a/net/ipv6/tcp_ipv6.c
@@ -1314,7 +1314,8 @@ static struct sock * tcp_v6_syn_recv_soc
 	/* Clone pktoptions received with SYN */
 	newnp->pktoptions = NULL;
 	if (treq->pktopts != NULL) {
-		newnp->pktoptions = skb_clone(treq->pktopts, GFP_ATOMIC);
+		newnp->pktoptions = skb_clone(treq->pktopts,
+					      sk_gfp_atomic(sk, GFP_ATOMIC));
 		consume_skb(treq->pktopts);
 		treq->pktopts = NULL;
 		if (newnp->pktoptions)
@@ -1364,7 +1365,8 @@ static struct sock * tcp_v6_syn_recv_soc
 		 * across. Shucks.
 		 */
 		tcp_md5_do_add(newsk, (union tcp_md5_addr *)&newnp->daddr,
-			       AF_INET6, key->key, key->keylen, GFP_ATOMIC);
+			       AF_INET6, key->key, key->keylen,
+			       sk_gfp_atomic(sk, GFP_ATOMIC));
 	}
 #endif
 
@@ -1457,7 +1459,7 @@ static int tcp_v6_do_rcv(struct sock *sk
 					       --ANK (980728)
 	 */
 	if (np->rxopt.all)
-		opt_skb = skb_clone(skb, GFP_ATOMIC);
+		opt_skb = skb_clone(skb, sk_gfp_atomic(sk, GFP_ATOMIC));
 
 	if (sk->sk_state == TCP_ESTABLISHED) { /* Fast path */
 		sock_rps_save_rxhash(sk, skb);
_
Subject: Subject: net: introduce sk_gfp_atomic() to allow addition of GFP flags depending on the individual socket

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

