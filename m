From: akpm@linux-foundation.org
Subject: + lockdep-fixup-sk_callback_lock-annotation.patch added to -mm tree
Date: Tue, 12 Jun 2007 13:58:48 -0700
Message-ID: <200706122058.l5CKwmVp021025@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38804 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750747AbXFLU7J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 16:59:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, davem@davemloft.net, mingo@elte.hu


The patch titled
     lockdep: fixup sk_callback_lock annotation
has been added to the -mm tree.  Its filename is
     lockdep-fixup-sk_callback_lock-annotation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lockdep: fixup sk_callback_lock annotation
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

the two init sites resulted in inconsistend names for the lock class.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/sock.c |   23 +++++++++++++++++++----
 1 files changed, 19 insertions(+), 4 deletions(-)

diff -puN net/core/sock.c~lockdep-fixup-sk_callback_lock-annotation net/core/sock.c
--- a/net/core/sock.c~lockdep-fixup-sk_callback_lock-annotation
+++ a/net/core/sock.c
@@ -171,6 +171,19 @@ static const char *af_family_slock_key_s
   "slock-AF_TIPC"  , "slock-AF_BLUETOOTH", "slock-AF_IUCV"     ,
   "slock-AF_RXRPC" , "slock-AF_MAX"
 };
+static const char *af_family_clock_key_strings[AF_MAX+1] = {
+  "clock-AF_UNSPEC", "clock-AF_UNIX"     , "clock-AF_INET"     ,
+  "clock-AF_AX25"  , "clock-AF_IPX"      , "clock-AF_APPLETALK",
+  "clock-AF_NETROM", "clock-AF_BRIDGE"   , "clock-AF_ATMPVC"   ,
+  "clock-AF_X25"   , "clock-AF_INET6"    , "clock-AF_ROSE"     ,
+  "clock-AF_DECnet", "clock-AF_NETBEUI"  , "clock-AF_SECURITY" ,
+  "clock-AF_KEY"   , "clock-AF_NETLINK"  , "clock-AF_PACKET"   ,
+  "clock-AF_ASH"   , "clock-AF_ECONET"   , "clock-AF_ATMSVC"   ,
+  "clock-21"       , "clock-AF_SNA"      , "clock-AF_IRDA"     ,
+  "clock-AF_PPPOX" , "clock-AF_WANPIPE"  , "clock-AF_LLC"      ,
+  "clock-27"       , "clock-28"          , "clock-29"          ,
+  "clock-AF_TIPC"  , "clock-AF_BLUETOOTH", "clock-AF_MAX"
+};
 #endif
 
 /*
@@ -941,8 +954,9 @@ struct sock *sk_clone(const struct sock 
 
 		rwlock_init(&newsk->sk_dst_lock);
 		rwlock_init(&newsk->sk_callback_lock);
-		lockdep_set_class(&newsk->sk_callback_lock,
-				   af_callback_keys + newsk->sk_family);
+		lockdep_set_class_and_name(&newsk->sk_callback_lock,
+				af_callback_keys + newsk->sk_family,
+				af_family_clock_key_strings[newsk->sk_family]);
 
 		newsk->sk_dst_cache	= NULL;
 		newsk->sk_wmem_queued	= 0;
@@ -1530,8 +1544,9 @@ void sock_init_data(struct socket *sock,
 
 	rwlock_init(&sk->sk_dst_lock);
 	rwlock_init(&sk->sk_callback_lock);
-	lockdep_set_class(&sk->sk_callback_lock,
-			   af_callback_keys + sk->sk_family);
+	lockdep_set_class_and_name(&sk->sk_callback_lock,
+			af_callback_keys + sk->sk_family,
+			af_family_clock_key_strings[sk->sk_family]);
 
 	sk->sk_state_change	=	sock_def_wakeup;
 	sk->sk_data_ready	=	sock_def_readable;
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
lumpy-reclaim-v4.patch
split-mmap.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
percpu_counters-use-cpu-notifiers.patch
percpu_counters-use-for_each_online_cpu.patch
fix-raw_spinlock_t-vs-lockdep.patch
lockdep-sanitise-config_prove_locking.patch
lockdep-reduce-the-ifdeffery.patch
lockstat-core-infrastructure.patch
lockstat-core-infrastructure-fix.patch
lockstat-core-infrastructure-fix-fix.patch
lockstat-core-infrastructure-fix-fix-fix.patch
lockstat-human-readability-tweaks.patch
lockstat-human-readability-tweaks-fix.patch
lockstat-hook-into-spinlock_t-rwlock_t-rwsem-and-mutex.patch
lockdep-various-fixes.patch
lockdep-various-fixes-checkpatch.patch
lockdep-fixup-sk_callback_lock-annotation.patch
lockstat-measure-lock-bouncing.patch
lockstat-measure-lock-bouncing-checkpatch.patch
lockstat-better-class-name-representation.patch
