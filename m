From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Thu, 14 May 2015 11:08:31 -0700
Message-ID: <5554e49f.996VveZa//cQVzgA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44270 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbbENSIc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 May 2015 14:08:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/qualcomm/qca_spi.c |    6 ------
 include/net/codel.h                     |    6 ------
 include/uapi/linux/tcp.h                |    3 ---
 net/core/net_namespace.c                |    4 ----
 net/core/sock.c                         |   22 ----------------------
 net/ipv4/tcp_input.c                    |    4 ----
 net/mac80211/sta_info.c                 |    7 -------
 7 files changed, 52 deletions(-)

diff -puN drivers/net/ethernet/qualcomm/qca_spi.c~linux-next-git-rejects drivers/net/ethernet/qualcomm/qca_spi.c
--- a/drivers/net/ethernet/qualcomm/qca_spi.c~linux-next-git-rejects
+++ a/drivers/net/ethernet/qualcomm/qca_spi.c
@@ -912,15 +912,9 @@ qca_spi_probe(struct spi_device *spi)
 	qca->spi_dev = spi;
 	qca->legacy_mode = legacy_mode;
 
-<<<<<<< HEAD
-	spi_set_drvdata(spi_device, qcaspi_devs);
-
-	mac = of_get_mac_address(spi_device->dev.of_node);
-=======
 	spi_set_drvdata(spi, qcaspi_devs);
 
 	mac = of_get_mac_address(spi->dev.of_node);
->>>>>>> linux-next/akpm-base
 
 	if (mac)
 		ether_addr_copy(qca->net_dev->dev_addr, mac);
diff -puN include/net/codel.h~linux-next-git-rejects include/net/codel.h
--- a/include/net/codel.h~linux-next-git-rejects
+++ a/include/net/codel.h
@@ -172,20 +172,14 @@ struct codel_stats {
 	u32		ce_mark;
 };
 
-<<<<<<< HEAD
-=======
 #define CODEL_DISABLED_THRESHOLD INT_MAX
 
->>>>>>> linux-next/akpm-base
 static void codel_params_init(struct codel_params *params,
 			      const struct Qdisc *sch)
 {
 	params->interval = MS2TIME(100);
 	params->target = MS2TIME(5);
-<<<<<<< HEAD
-=======
 	params->ce_threshold = CODEL_DISABLED_THRESHOLD;
->>>>>>> linux-next/akpm-base
 	params->mtu = psched_mtu(qdisc_dev(sch));
 	params->ecn = false;
 }
diff -puN include/uapi/linux/tcp.h~linux-next-git-rejects include/uapi/linux/tcp.h
--- a/include/uapi/linux/tcp.h~linux-next-git-rejects
+++ a/include/uapi/linux/tcp.h
@@ -113,11 +113,8 @@ enum {
 #define TCP_TIMESTAMP		24
 #define TCP_NOTSENT_LOWAT	25	/* limit number of unsent bytes in write queue */
 #define TCP_CC_INFO		26	/* Get Congestion Control (optional) info */
-<<<<<<< HEAD
-=======
 #define TCP_SAVE_SYN		27	/* Record SYN headers for new connections */
 #define TCP_SAVED_SYN		28	/* Get SYN headers recorded for connection */
->>>>>>> linux-next/akpm-base
 
 struct tcp_repair_opt {
 	__u32	opt_code;
diff -puN net/core/net_namespace.c~linux-next-git-rejects net/core/net_namespace.c
--- a/net/core/net_namespace.c~linux-next-git-rejects
+++ a/net/core/net_namespace.c
@@ -641,11 +641,7 @@ static int rtnl_net_getid(struct sk_buff
 
 	id = peernet2id(net, peer);
 	err = rtnl_net_fill(msg, NETLINK_CB(skb).portid, nlh->nlmsg_seq, 0,
-<<<<<<< HEAD
-			    RTM_NEWNSID, net, peer, -1);
-=======
 			    RTM_NEWNSID, net, id);
->>>>>>> linux-next/akpm-base
 	if (err < 0)
 		goto err_out;
 
diff -puN net/core/sock.c~linux-next-git-rejects net/core/sock.c
--- a/net/core/sock.c~linux-next-git-rejects
+++ a/net/core/sock.c
@@ -1466,28 +1466,6 @@ void sk_free(struct sock *sk)
 }
 EXPORT_SYMBOL(sk_free);
 
-<<<<<<< HEAD
-/*
- * Last sock_put should drop reference to sk->sk_net. It has already
- * been dropped in sk_change_net. Taking reference to stopping namespace
- * is not an option.
- * Take reference to a socket to remove it from hash _alive_ and after that
- * destroy it in the context of init_net.
- */
-void sk_release_kernel(struct sock *sk)
-{
-	if (sk == NULL || sk->sk_socket == NULL)
-		return;
-
-	sock_hold(sk);
-	sock_release(sk->sk_socket);
-	sock_net_set(sk, get_net(&init_net));
-	sock_put(sk);
-}
-EXPORT_SYMBOL(sk_release_kernel);
-
-=======
->>>>>>> linux-next/akpm-base
 static void sk_update_clone(const struct sock *sk, struct sock *newsk)
 {
 	if (mem_cgroup_sockets_enabled && sk->sk_cgrp)
diff -puN net/ipv4/tcp_input.c~linux-next-git-rejects net/ipv4/tcp_input.c
--- a/net/ipv4/tcp_input.c~linux-next-git-rejects
+++ a/net/ipv4/tcp_input.c
@@ -1818,11 +1818,7 @@ advance_sp:
 	for (j = 0; j < used_sacks; j++)
 		tp->recv_sack_cache[i++] = sp[j];
 
-<<<<<<< HEAD
-	if ((state.reord < tp->fackets_out) &&
-=======
 	if ((state->reord < tp->fackets_out) &&
->>>>>>> linux-next/akpm-base
 	    ((inet_csk(sk)->icsk_ca_state != TCP_CA_Loss) || tp->undo_marker))
 		tcp_update_reordering(sk, tp->fackets_out - state->reord, 0);
 
diff -puN net/mac80211/sta_info.c~linux-next-git-rejects net/mac80211/sta_info.c
--- a/net/mac80211/sta_info.c~linux-next-git-rejects
+++ a/net/mac80211/sta_info.c
@@ -162,17 +162,10 @@ struct sta_info *sta_info_get(struct iee
 	struct sta_info *sta;
 	struct rhash_head *tmp;
 	const struct bucket_table *tbl;
-<<<<<<< HEAD
 
 	rcu_read_lock();
 	tbl = rht_dereference_rcu(local->sta_hash.tbl, &local->sta_hash);
 
-=======
-
-	rcu_read_lock();
-	tbl = rht_dereference_rcu(local->sta_hash.tbl, &local->sta_hash);
-
->>>>>>> linux-next/akpm-base
 	for_each_sta_info(local, tbl, addr, sta, tmp) {
 		if (sta->sdata == sdata) {
 			rcu_read_unlock();
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-rtc-rtc-armada38xc-remove-unused-local-flags.patch
gfp-add-__gfp_noaccount-v2-fix.patch
cma-page_isolation-check-buddy-before-access-it-fix.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
mm.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch
mm-new-mm-hook-framework.patch
mm-meminit-inline-some-helper-functions-fix.patch
mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup-fix.patch
mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix-fix.patch
mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions-fix.patch
mm-clarify-that-the-function-operateds-on-hugepage-pte-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
proc-fix-page_size-limit-of-proc-pid-cmdline-fix.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch
radix-tree-replace-preallocated-node-array-with-linked-list-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix.patch
linux-next.patch
linux-next-rejects.patch
net-bridge-br_stpc-work-around-gcc-444-initializer-bug.patch
net-switchdev-switchdevc-work-around-gcc-444-initializer-bug.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

