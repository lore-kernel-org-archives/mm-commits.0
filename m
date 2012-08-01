From: akpm@linux-foundation.org
Subject: [merged] netvm-allow-the-use-of-__gfp_memalloc-by-specific-sockets.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:16:04 -0700
Message-ID: <20120801201604.E62791E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:52099 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959Ab2HAUQG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:16:06 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so5412588obb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:16:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, a.p.zijlstra@chello.nl, cl@linux.com, davem@davemloft.net, emunson@mgebm.net, eric.dumazet@gmail.com, michaelc@cs.wisc.edu, neilb@suse.de, sebastian@breakpoint.cc, mm-commits@vger.kernel.org


The patch titled
     Subject: netvm: allow the use of __GFP_MEMALLOC by specific sockets
has been removed from the -mm tree.  Its filename was
     netvm-allow-the-use-of-__gfp_memalloc-by-specific-sockets.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch

