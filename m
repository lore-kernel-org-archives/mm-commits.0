From: akpm@linux-foundation.org
Subject: [merged] netvm-prevent-a-stream-specific-deadlock.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:16:42 -0700
Message-ID: <20120801201643.79E1520004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:56693 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab2HAUQq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:16:46 -0400
Received: by wibhr14 with SMTP id hr14so199048wib.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:16:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, Trond.Myklebust@netapp.com, a.p.zijlstra@chello.nl, davem@davemloft.net, emunson@mgebm.net, hch@infradead.org, michaelc@cs.wisc.edu, neilb@suse.de, riel@redhat.com, sebastian@breakpoint.cc, mm-commits@vger.kernel.org


The patch titled
     Subject: netvm: prevent a stream-specific deadlock
has been removed from the -mm tree.  Its filename was
     netvm-prevent-a-stream-specific-deadlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: netvm: prevent a stream-specific deadlock

This patch series is based on top of "Swap-over-NBD without deadlocking
v15" as it depends on the same reservation of PF_MEMALLOC reserves logic.

When a user or administrator requires swap for their application, they
create a swap partition and file, format it with mkswap and activate it
with swapon.  In diskless systems this is not an option so if swap if
required then swapping over the network is considered.  The two likely
scenarios are when blade servers are used as part of a cluster where the
form factor or maintenance costs do not allow the use of disks and thin
clients.

The Linux Terminal Server Project recommends the use of the Network Block
Device (NBD) for swap but this is not always an option.  There is no
guarantee that the network attached storage (NAS) device is running Linux
or supports NBD.  However, it is likely that it supports NFS so there are
users that want support for swapping over NFS despite any performance
concern.  Some distributions currently carry patches that support swapping
over NFS but it would be preferable to support it in the mainline kernel.

Patch 1 avoids a stream-specific deadlock that potentially affects TCP.

Patch 2 is a small modification to SELinux to avoid using PFMEMALLOC
	reserves.

Patch 3 adds three helpers for filesystems to handle swap cache pages.
	For example, page_file_mapping() returns page->mapping for
	file-backed pages and the address_space of the underlying
	swap file for swap cache pages.

Patch 4 adds two address_space_operations to allow a filesystem
	to pin all metadata relevant to a swapfile in memory. Upon
	successful activation, the swapfile is marked SWP_FILE and
	the address space operation ->direct_IO is used for writing
	and ->readpage for reading in swap pages.

Patch 5 notes that patch 3 is bolting
	filesystem-specific-swapfile-support onto the side and that
	the default handlers have different information to what
	is available to the filesystem. This patch refactors the
	code so that there are generic handlers for each of the new
	address_space operations.

Patch 6 adds an API to allow a vector of kernel addresses to be
	translated to struct pages and pinned for IO.

Patch 7 adds support for using highmem pages for swap by kmapping
	the pages before calling the direct_IO handler.

Patch 8 updates NFS to use the helpers from patch 3 where necessary.

Patch 9 avoids setting PF_private on PG_swapcache pages within NFS.

Patch 10 implements the new swapfile-related address_space operations
	for NFS and teaches the direct IO handler how to manage
	kernel addresses.

Patch 11 prevents page allocator recursions in NFS by using GFP_NOIO
	where appropriate.

Patch 12 fixes a NULL pointer dereference that occurs when using
	swap-over-NFS.

With the patches applied, it is possible to mount a swapfile that is on an
NFS filesystem.  Swap performance is not great with a swap stress test
taking roughly twice as long to complete than if the swap device was
backed by NBD.



This patch: netvm: prevent a stream-specific deadlock

It could happen that all !SOCK_MEMALLOC sockets have buffered so much data
that we're over the global rmem limit.  This will prevent SOCK_MEMALLOC
buffers from receiving data, which will prevent userspace from running,
which is needed to reduce the buffered data.

Fix this by exempting the SOCK_MEMALLOC sockets from the rmem limit.  Once
this change it applied, it is important that sockets that set
SOCK_MEMALLOC do not clear the flag until the socket is being torn down. 
If this happens, a warning is generated and the tokens reclaimed to avoid
accounting errors until the bug is fixed.

[davem@davemloft.net: Warning about clearing SOCK_MEMALLOC]
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Eric B Munson <emunson@mgebm.net>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/net/sock.h     |    8 +++++---
 net/caif/caif_socket.c |    2 +-
 net/core/sock.c        |   14 +++++++++++++-
 net/ipv4/tcp_input.c   |   21 +++++++++++----------
 net/sctp/ulpevent.c    |    3 ++-
 5 files changed, 32 insertions(+), 16 deletions(-)

diff -puN include/net/sock.h~netvm-prevent-a-stream-specific-deadlock include/net/sock.h
--- a/include/net/sock.h~netvm-prevent-a-stream-specific-deadlock
+++ a/include/net/sock.h
@@ -1329,12 +1329,14 @@ static inline bool sk_wmem_schedule(stru
 		__sk_mem_schedule(sk, size, SK_MEM_SEND);
 }
 
-static inline bool sk_rmem_schedule(struct sock *sk, int size)
+static inline bool
+sk_rmem_schedule(struct sock *sk, struct sk_buff *skb, unsigned int size)
 {
 	if (!sk_has_account(sk))
 		return true;
-	return size <= sk->sk_forward_alloc ||
-		__sk_mem_schedule(sk, size, SK_MEM_RECV);
+	return size<= sk->sk_forward_alloc ||
+		__sk_mem_schedule(sk, size, SK_MEM_RECV) ||
+		skb_pfmemalloc(skb);
 }
 
 static inline void sk_mem_reclaim(struct sock *sk)
diff -puN net/caif/caif_socket.c~netvm-prevent-a-stream-specific-deadlock net/caif/caif_socket.c
--- a/net/caif/caif_socket.c~netvm-prevent-a-stream-specific-deadlock
+++ a/net/caif/caif_socket.c
@@ -141,7 +141,7 @@ static int caif_queue_rcv_skb(struct soc
 	err = sk_filter(sk, skb);
 	if (err)
 		return err;
-	if (!sk_rmem_schedule(sk, skb->truesize) && rx_flow_is_on(cf_sk)) {
+	if (!sk_rmem_schedule(sk, skb, skb->truesize) && rx_flow_is_on(cf_sk)) {
 		set_rx_flow_off(cf_sk);
 		net_dbg_ratelimited("sending flow OFF due to rmem_schedule\n");
 		caif_flow_ctrl(sk, CAIF_MODEMCMD_FLOW_OFF_REQ);
diff -puN net/core/sock.c~netvm-prevent-a-stream-specific-deadlock net/core/sock.c
--- a/net/core/sock.c~netvm-prevent-a-stream-specific-deadlock
+++ a/net/core/sock.c
@@ -295,6 +295,18 @@ void sk_clear_memalloc(struct sock *sk)
 	sock_reset_flag(sk, SOCK_MEMALLOC);
 	sk->sk_allocation &= ~__GFP_MEMALLOC;
 	static_key_slow_dec(&memalloc_socks);
+
+	/*
+	 * SOCK_MEMALLOC is allowed to ignore rmem limits to ensure forward
+	 * progress of swapping. However, if SOCK_MEMALLOC is cleared while
+	 * it has rmem allocations there is a risk that the user of the
+	 * socket cannot make forward progress due to exceeding the rmem
+	 * limits. By rights, sk_clear_memalloc() should only be called
+	 * on sockets being torn down but warn and reset the accounting if
+	 * that assumption breaks.
+	 */
+	if (WARN_ON(sk->sk_forward_alloc))
+		sk_mem_reclaim(sk);
 }
 EXPORT_SYMBOL_GPL(sk_clear_memalloc);
 
@@ -396,7 +408,7 @@ int sock_queue_rcv_skb(struct sock *sk, 
 	if (err)
 		return err;
 
-	if (!sk_rmem_schedule(sk, skb->truesize)) {
+	if (!sk_rmem_schedule(sk, skb, skb->truesize)) {
 		atomic_inc(&sk->sk_drops);
 		return -ENOBUFS;
 	}
diff -puN net/ipv4/tcp_input.c~netvm-prevent-a-stream-specific-deadlock net/ipv4/tcp_input.c
--- a/net/ipv4/tcp_input.c~netvm-prevent-a-stream-specific-deadlock
+++ a/net/ipv4/tcp_input.c
@@ -4351,19 +4351,20 @@ static void tcp_ofo_queue(struct sock *s
 static bool tcp_prune_ofo_queue(struct sock *sk);
 static int tcp_prune_queue(struct sock *sk);
 
-static int tcp_try_rmem_schedule(struct sock *sk, unsigned int size)
+static int tcp_try_rmem_schedule(struct sock *sk, struct sk_buff *skb,
+				 unsigned int size)
 {
 	if (atomic_read(&sk->sk_rmem_alloc) > sk->sk_rcvbuf ||
-	    !sk_rmem_schedule(sk, size)) {
+	    !sk_rmem_schedule(sk, skb, size)) {
 
 		if (tcp_prune_queue(sk) < 0)
 			return -1;
 
-		if (!sk_rmem_schedule(sk, size)) {
+		if (!sk_rmem_schedule(sk, skb, size)) {
 			if (!tcp_prune_ofo_queue(sk))
 				return -1;
 
-			if (!sk_rmem_schedule(sk, size))
+			if (!sk_rmem_schedule(sk, skb, size))
 				return -1;
 		}
 	}
@@ -4418,7 +4419,7 @@ static void tcp_data_queue_ofo(struct so
 
 	TCP_ECN_check_ce(tp, skb);
 
-	if (unlikely(tcp_try_rmem_schedule(sk, skb->truesize))) {
+	if (unlikely(tcp_try_rmem_schedule(sk, skb, skb->truesize))) {
 		NET_INC_STATS_BH(sock_net(sk), LINUX_MIB_TCPOFODROP);
 		__kfree_skb(skb);
 		return;
@@ -4552,17 +4553,17 @@ static int __must_check tcp_queue_rcv(st
 
 int tcp_send_rcvq(struct sock *sk, struct msghdr *msg, size_t size)
 {
-	struct sk_buff *skb;
+	struct sk_buff *skb = NULL;
 	struct tcphdr *th;
 	bool fragstolen;
 
-	if (tcp_try_rmem_schedule(sk, size + sizeof(*th)))
-		goto err;
-
 	skb = alloc_skb(size + sizeof(*th), sk->sk_allocation);
 	if (!skb)
 		goto err;
 
+	if (tcp_try_rmem_schedule(sk, skb, size + sizeof(*th)))
+		goto err_free;
+
 	th = (struct tcphdr *)skb_put(skb, sizeof(*th));
 	skb_reset_transport_header(skb);
 	memset(th, 0, sizeof(*th));
@@ -4633,7 +4634,7 @@ static void tcp_data_queue(struct sock *
 		if (eaten <= 0) {
 queue_and_out:
 			if (eaten < 0 &&
-			    tcp_try_rmem_schedule(sk, skb->truesize))
+			    tcp_try_rmem_schedule(sk, skb, skb->truesize))
 				goto drop;
 
 			eaten = tcp_queue_rcv(sk, skb, 0, &fragstolen);
diff -puN net/sctp/ulpevent.c~netvm-prevent-a-stream-specific-deadlock net/sctp/ulpevent.c
--- a/net/sctp/ulpevent.c~netvm-prevent-a-stream-specific-deadlock
+++ a/net/sctp/ulpevent.c
@@ -702,7 +702,8 @@ struct sctp_ulpevent *sctp_ulpevent_make
 	if (rx_count >= asoc->base.sk->sk_rcvbuf) {
 
 		if ((asoc->base.sk->sk_userlocks & SOCK_RCVBUF_LOCK) ||
-		    (!sk_rmem_schedule(asoc->base.sk, chunk->skb->truesize)))
+		    (!sk_rmem_schedule(asoc->base.sk, chunk->skb,
+				       chunk->skb->truesize)))
 			goto fail;
 	}
 
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch

