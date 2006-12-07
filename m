From: akpm@osdl.org
Subject: - lockdep-annotate-nfs-nfsd-in-kernel-sockets.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:01:00 -0800
Message-ID: <200612072301.kB7N109X029691@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51546 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163761AbWLGXBk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:01:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, SteveD@redhat.com, davem@davemloft.net, mingo@elte.hu, neilb@suse.de, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     lockdep: annotate nfs/nfsd in-kernel sockets
has been removed from the -mm tree.  Its filename was
     lockdep-annotate-nfs-nfsd-in-kernel-sockets.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lockdep: annotate nfs/nfsd in-kernel sockets
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Stick NFS sockets in their own class to avoid some lockdep warnings.  NFS
sockets are never exposed to user-space, and will hence not trigger certain
code paths that would otherwise pose deadlock scenarios.

[akpm@osdl.org: cleanups]
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Steven Dickson <SteveD@redhat.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Acked-by: Neil Brown <neilb@suse.de>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/net/sock.h    |   19 +++++++++++++++++++
 kernel/lockdep.c      |    1 +
 net/core/sock.c       |   23 +++++------------------
 net/sunrpc/svcsock.c  |   31 +++++++++++++++++++++++++++++++
 net/sunrpc/xprtsock.c |   31 +++++++++++++++++++++++++++++++
 5 files changed, 87 insertions(+), 18 deletions(-)

diff -puN include/net/sock.h~lockdep-annotate-nfs-nfsd-in-kernel-sockets include/net/sock.h
--- a/include/net/sock.h~lockdep-annotate-nfs-nfsd-in-kernel-sockets
+++ a/include/net/sock.h
@@ -746,6 +746,25 @@ static inline int sk_stream_wmem_schedul
  */
 #define sock_owned_by_user(sk)	((sk)->sk_lock.owner)
 
+/*
+ * Macro so as to not evaluate some arguments when
+ * lockdep is not enabled.
+ *
+ * Mark both the sk_lock and the sk_lock.slock as a
+ * per-address-family lock class.
+ */
+#define sock_lock_init_class_and_name(sk, sname, skey, name, key) 	\
+do {									\
+	sk->sk_lock.owner = NULL;					\
+	init_waitqueue_head(&sk->sk_lock.wq);				\
+	spin_lock_init(&(sk)->sk_lock.slock);				\
+	debug_check_no_locks_freed((void *)&(sk)->sk_lock,		\
+			sizeof((sk)->sk_lock));				\
+	lockdep_set_class_and_name(&(sk)->sk_lock.slock,		\
+		       	(skey), (sname));				\
+	lockdep_init_map(&(sk)->sk_lock.dep_map, (name), (key), 0);	\
+} while (0)
+
 extern void FASTCALL(lock_sock_nested(struct sock *sk, int subclass));
 
 static inline void lock_sock(struct sock *sk)
diff -puN kernel/lockdep.c~lockdep-annotate-nfs-nfsd-in-kernel-sockets kernel/lockdep.c
--- a/kernel/lockdep.c~lockdep-annotate-nfs-nfsd-in-kernel-sockets
+++ a/kernel/lockdep.c
@@ -2645,6 +2645,7 @@ void debug_check_no_locks_freed(const vo
 	}
 	local_irq_restore(flags);
 }
+EXPORT_SYMBOL_GPL(debug_check_no_locks_freed);
 
 static void print_held_locks_bug(struct task_struct *curr)
 {
diff -puN net/core/sock.c~lockdep-annotate-nfs-nfsd-in-kernel-sockets net/core/sock.c
--- a/net/core/sock.c~lockdep-annotate-nfs-nfsd-in-kernel-sockets
+++ a/net/core/sock.c
@@ -810,24 +810,11 @@ lenout:
  */
 static void inline sock_lock_init(struct sock *sk)
 {
-	spin_lock_init(&sk->sk_lock.slock);
-	sk->sk_lock.owner = NULL;
-	init_waitqueue_head(&sk->sk_lock.wq);
-	/*
-	 * Make sure we are not reinitializing a held lock:
-	 */
-	debug_check_no_locks_freed((void *)&sk->sk_lock, sizeof(sk->sk_lock));
-
-	/*
-	 * Mark both the sk_lock and the sk_lock.slock as a
-	 * per-address-family lock class:
-	 */
-	lockdep_set_class_and_name(&sk->sk_lock.slock,
-				   af_family_slock_keys + sk->sk_family,
-				   af_family_slock_key_strings[sk->sk_family]);
-	lockdep_init_map(&sk->sk_lock.dep_map,
-			 af_family_key_strings[sk->sk_family],
-			 af_family_keys + sk->sk_family, 0);
+	sock_lock_init_class_and_name(sk,
+			af_family_slock_key_strings[sk->sk_family],
+			af_family_slock_keys + sk->sk_family,
+			af_family_key_strings[sk->sk_family],
+			af_family_keys + sk->sk_family);
 }
 
 /**
diff -puN net/sunrpc/svcsock.c~lockdep-annotate-nfs-nfsd-in-kernel-sockets net/sunrpc/svcsock.c
--- a/net/sunrpc/svcsock.c~lockdep-annotate-nfs-nfsd-in-kernel-sockets
+++ a/net/sunrpc/svcsock.c
@@ -85,6 +85,35 @@ static struct cache_deferred_req *svc_de
  */
 static int svc_conn_age_period = 6*60;
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+static struct lock_class_key svc_key[2];
+static struct lock_class_key svc_slock_key[2];
+
+static inline void svc_reclassify_socket(struct socket *sock)
+{
+	struct sock *sk = sock->sk;
+	BUG_ON(sk->sk_lock.owner != NULL);
+	switch (sk->sk_family) {
+	case AF_INET:
+		sock_lock_init_class_and_name(sk, "slock-AF_INET-NFSD",
+		    &svc_slock_key[0], "sk_lock-AF_INET-NFSD", &svc_key[0]);
+		break;
+
+	case AF_INET6:
+		sock_lock_init_class_and_name(sk, "slock-AF_INET6-NFSD",
+		    &svc_slock_key[1], "sk_lock-AF_INET6-NFSD", &svc_key[1]);
+		break;
+
+	default:
+		BUG();
+	}
+}
+#else
+static inline void svc_reclassify_socket(struct socket *sock)
+{
+}
+#endif
+
 /*
  * Queue up an idle server thread.  Must have pool->sp_lock held.
  * Note: this is really a stack rather than a queue, so that we only
@@ -1557,6 +1586,8 @@ svc_create_socket(struct svc_serv *serv,
 	if ((error = sock_create_kern(PF_INET, type, protocol, &sock)) < 0)
 		return error;
 
+	svc_reclassify_socket(sock);
+
 	if (type == SOCK_STREAM)
 		sock->sk->sk_reuse = 1; /* allow address reuse */
 	error = kernel_bind(sock, (struct sockaddr *) sin,
diff -puN net/sunrpc/xprtsock.c~lockdep-annotate-nfs-nfsd-in-kernel-sockets net/sunrpc/xprtsock.c
--- a/net/sunrpc/xprtsock.c~lockdep-annotate-nfs-nfsd-in-kernel-sockets
+++ a/net/sunrpc/xprtsock.c
@@ -1058,6 +1058,35 @@ static int xs_bindresvport(struct rpc_xp
 	return err;
 }
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+static struct lock_class_key xs_key[2];
+static struct lock_class_key xs_slock_key[2];
+
+static inline void xs_reclassify_socket(struct socket *sock)
+{
+	struct sock *sk = sock->sk;
+	BUG_ON(sk->sk_lock.owner != NULL);
+	switch (sk->sk_family) {
+	case AF_INET:
+		sock_lock_init_class_and_name(sk, "slock-AF_INET-NFS",
+			&xs_slock_key[0], "sk_lock-AF_INET-NFS", &xs_key[0]);
+		break;
+
+	case AF_INET6:
+		sock_lock_init_class_and_name(sk, "slock-AF_INET6-NFS",
+			&xs_slock_key[1], "sk_lock-AF_INET6-NFS", &xs_key[1]);
+		break;
+
+	default:
+		BUG();
+	}
+}
+#else
+static inline void xs_reclassify_socket(struct socket *sock)
+{
+}
+#endif
+
 /**
  * xs_udp_connect_worker - set up a UDP socket
  * @work: RPC transport to connect
@@ -1205,6 +1234,8 @@ static void xs_tcp_connect_worker(struct
 
 		write_unlock_bh(&sk->sk_callback_lock);
 	}
+	xs_reclassify_socket(sock);
+		xs_reclassify_socket(sock);
 
 	/* Tell the socket layer to start connecting... */
 	xprt->stat.connect_count++;
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
tty-signal-tty-locking.patch
tty-signal-tty-locking-post-viro-trainwreck.patch
tty-signal-tty-locking-post-viro-trainwreck-fix.patch
tty-signal-tty-locking-post-viro-trainwreck-fix-fix.patch
tty-signal-tty-locking-3270-fix.patch
do_task_stat-dont-take-tty_mutex.patch
do_acct_process-dont-take-tty_mutex.patch
sys_unshare-remove-a-broken-clone_sighand-code.patch
remove-the-old-bd_mutex-lockdep-annotation.patch
new-bd_mutex-lockdep-annotation.patch
remove-lock_key-approach-to-managing-nested-bd_mutex-locks.patch
simplify-some-aspects-of-bd_mutex-nesting.patch
use-mutex_lock_nested-for-bd_mutex-to-avoid-lockdep-warning.patch
avoid-lockdep-warning-in-md.patch
bdev-fix-bd_part_count-leak.patch
lockdep-annotate-nfsd4-recover-code.patch

