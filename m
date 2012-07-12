From: akpm@linux-foundation.org
Subject: + netvm-allow-the-use-of-__gfp_memalloc-by-specific-sockets.patch added to -mm tree
Date: Thu, 12 Jul 2012 14:27:48 -0700
Message-ID: <20120712212748.785D81E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:51016 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932971Ab2GLV1t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 17:27:49 -0400
Received: by mail-vb0-f74.google.com with SMTP id l22so279362vbn.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 14:27:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, a.p.zijlstra@chello.nl, cl@linux.com, davem@davemloft.net, emunson@mgebm.net, eric.dumazet@gmail.com, michaelc@cs.wisc.edu, neilb@suse.de, sebastian@breakpoint.cc


The patch titled
     Subject: netvm: allow the use of __GFP_MEMALLOC by specific sockets
has been added to the -mm tree.  Its filename is
     netvm-allow-the-use-of-__gfp_memalloc-by-specific-sockets.patch

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
Subject: netvm: allow the use of __GFP_MEMALLOC by specific sockets

Allow specific sockets to be tagged SOCK_MEMALLOC and use __GFP_MEMALLOC
for their allocations.  These sockets will be able to go below watermarks
and allocate from the emergency reserve.  Such sockets are to be used to
service the VM (iow.  to swap over).  They must be handled kernel side,
exposing such a socket to user-space is a bug.

There is a risk that the reserves be depleted so for now, the
administrator is responsible for increasing min_free_kbytes as necessary
to prevent deadlock for their workloads.

[a.p.zijlstra@chello.nl: Original patches]
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

 include/net/sock.h |    5 ++++-
 net/core/sock.c    |   22 ++++++++++++++++++++++
 2 files changed, 26 insertions(+), 1 deletion(-)

diff -puN include/net/sock.h~netvm-allow-the-use-of-__gfp_memalloc-by-specific-sockets include/net/sock.h
--- a/include/net/sock.h~netvm-allow-the-use-of-__gfp_memalloc-by-specific-sockets
+++ a/include/net/sock.h
@@ -621,6 +621,7 @@ enum sock_flags {
 	SOCK_RCVTSTAMPNS, /* %SO_TIMESTAMPNS setting */
 	SOCK_LOCALROUTE, /* route locally only, %SO_DONTROUTE setting */
 	SOCK_QUEUE_SHRUNK, /* write queue has been shrunk recently */
+	SOCK_MEMALLOC, /* VM depends on this socket for swapping */
 	SOCK_TIMESTAMPING_TX_HARDWARE,  /* %SOF_TIMESTAMPING_TX_HARDWARE */
 	SOCK_TIMESTAMPING_TX_SOFTWARE,  /* %SOF_TIMESTAMPING_TX_SOFTWARE */
 	SOCK_TIMESTAMPING_RX_HARDWARE,  /* %SOF_TIMESTAMPING_RX_HARDWARE */
@@ -660,7 +661,7 @@ static inline bool sock_flag(const struc
 
 static inline gfp_t sk_gfp_atomic(struct sock *sk, gfp_t gfp_mask)
 {
-	return GFP_ATOMIC;
+	return GFP_ATOMIC | (sk->sk_allocation & __GFP_MEMALLOC);
 }
 
 static inline void sk_acceptq_removed(struct sock *sk)
@@ -803,6 +804,8 @@ extern int sk_stream_wait_memory(struct 
 extern void sk_stream_wait_close(struct sock *sk, long timeo_p);
 extern int sk_stream_error(struct sock *sk, int flags, int err);
 extern void sk_stream_kill_queues(struct sock *sk);
+extern void sk_set_memalloc(struct sock *sk);
+extern void sk_clear_memalloc(struct sock *sk);
 
 extern int sk_wait_data(struct sock *sk, long *timeo);
 
diff -puN net/core/sock.c~netvm-allow-the-use-of-__gfp_memalloc-by-specific-sockets net/core/sock.c
--- a/net/core/sock.c~netvm-allow-the-use-of-__gfp_memalloc-by-specific-sockets
+++ a/net/core/sock.c
@@ -271,6 +271,28 @@ __u32 sysctl_rmem_default __read_mostly 
 int sysctl_optmem_max __read_mostly = sizeof(unsigned long)*(2*UIO_MAXIOV+512);
 EXPORT_SYMBOL(sysctl_optmem_max);
 
+/**
+ * sk_set_memalloc - sets %SOCK_MEMALLOC
+ * @sk: socket to set it on
+ *
+ * Set %SOCK_MEMALLOC on a socket for access to emergency reserves.
+ * It's the responsibility of the admin to adjust min_free_kbytes
+ * to meet the requirements
+ */
+void sk_set_memalloc(struct sock *sk)
+{
+	sock_set_flag(sk, SOCK_MEMALLOC);
+	sk->sk_allocation |= __GFP_MEMALLOC;
+}
+EXPORT_SYMBOL_GPL(sk_set_memalloc);
+
+void sk_clear_memalloc(struct sock *sk)
+{
+	sock_reset_flag(sk, SOCK_MEMALLOC);
+	sk->sk_allocation &= ~__GFP_MEMALLOC;
+}
+EXPORT_SYMBOL_GPL(sk_clear_memalloc);
+
 #if defined(CONFIG_CGROUPS)
 #if !defined(CONFIG_NET_CLS_CGROUP)
 int net_cls_subsys_id = -1;
_
Subject: Subject: netvm: allow the use of __GFP_MEMALLOC by specific sockets

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

