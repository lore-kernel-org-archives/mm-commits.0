From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Thu, 06 Apr 2017 14:02:53 -0700
Message-ID: <58e6acfd.KqazVt1tMIknEx1g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38456 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752974AbdDFVCz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Apr 2017 17:02:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/netronome/nfp/nfp_net_common.c |    9 --
 drivers/net/usb/r8152.c                             |   14 ----
 kernel/bpf/verifier.c                               |   17 -----
 net/core/flow_dissector.c                           |   31 ----------
 net/core/secure_seq.c                               |   12 ---
 tools/testing/selftests/bpf/Makefile                |    6 -
 tools/testing/selftests/bpf/test_verifier.c         |    8 --
 7 files changed, 97 deletions(-)

diff -puN drivers/net/ethernet/netronome/nfp/nfp_net_common.c~linux-next-git-rejects drivers/net/ethernet/netronome/nfp/nfp_net_common.c
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c~linux-next-git-rejects
+++ a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -3295,18 +3295,9 @@ void nfp_net_netdev_clean(struct net_dev
 {
 	struct nfp_net *nn = netdev_priv(netdev);
 
-<<<<<<< HEAD
-	unregister_netdev(nn->netdev);
-
-	if (nn->xdp_prog)
-		bpf_prog_put(nn->xdp_prog);
-	if (nn->bpf_offload_xdp)
-		nfp_net_xdp_offload(nn, NULL);
-=======
 	if (nn->dp.xdp_prog)
 		bpf_prog_put(nn->dp.xdp_prog);
 	if (nn->dp.bpf_offload_xdp)
 		nfp_net_xdp_offload(nn, NULL);
 	unregister_netdev(nn->dp.netdev);
->>>>>>> linux-next/akpm-base
 }
diff -puN drivers/net/usb/r8152.c~linux-next-git-rejects drivers/net/usb/r8152.c
--- a/drivers/net/usb/r8152.c~linux-next-git-rejects
+++ a/drivers/net/usb/r8152.c
@@ -3717,15 +3717,6 @@ static int rtl8152_resume(struct usb_int
 			napi_disable(napi);
 			set_bit(WORK_ENABLE, &tp->flags);
 
-<<<<<<< HEAD
-			if (netif_carrier_ok(tp->netdev)) {
-				if (rtl8152_get_speed(tp) & LINK_STATUS) {
-					rtl_start_rx(tp);
-				} else {
-					netif_carrier_off(tp->netdev);
-					tp->rtl_ops.disable(tp);
-					netif_info(tp, link, tp->netdev,
-=======
 			if (netif_carrier_ok(netdev)) {
 				if (rtl8152_get_speed(tp) & LINK_STATUS) {
 					rtl_start_rx(tp);
@@ -3733,16 +3724,11 @@ static int rtl8152_resume(struct usb_int
 					netif_carrier_off(netdev);
 					tp->rtl_ops.disable(tp);
 					netif_info(tp, link, netdev,
->>>>>>> linux-next/akpm-base
 						   "linking down\n");
 				}
 			}
 
-<<<<<<< HEAD
-			napi_enable(&tp->napi);
-=======
 			napi_enable(napi);
->>>>>>> linux-next/akpm-base
 			clear_bit(SELECTIVE_SUSPEND, &tp->flags);
 			smp_mb__after_atomic();
 			if (!list_empty(&tp->rx_done))
diff -puN kernel/bpf/verifier.c~linux-next-git-rejects kernel/bpf/verifier.c
--- a/kernel/bpf/verifier.c~linux-next-git-rejects
+++ a/kernel/bpf/verifier.c
@@ -782,7 +782,6 @@ static int check_pkt_ptr_alignment(const
 		return -EACCES;
 	}
 
-<<<<<<< HEAD
 	return 0;
 }
 
@@ -797,22 +796,6 @@ static int check_val_ptr_alignment(const
 	return 0;
 }
 
-=======
-	return 0;
-}
-
-static int check_val_ptr_alignment(const struct bpf_reg_state *reg,
-				   int size)
-{
-	if (size != 1) {
-		verbose("Unknown alignment. Only byte-sized access allowed in value access.\n");
-		return -EACCES;
-	}
-
-	return 0;
-}
-
->>>>>>> linux-next/akpm-base
 static int check_ptr_alignment(const struct bpf_reg_state *reg,
 			       int off, int size)
 {
diff -puN net/core/flow_dissector.c~linux-next-git-rejects net/core/flow_dissector.c
--- a/net/core/flow_dissector.c~linux-next-git-rejects
+++ a/net/core/flow_dissector.c
@@ -576,36 +576,6 @@ mpls:
 		goto out_good;
 
 	case htons(ETH_P_ARP):
-<<<<<<< HEAD
-	case htons(ETH_P_RARP): {
-		struct {
-			unsigned char ar_sha[ETH_ALEN];
-			unsigned char ar_sip[4];
-			unsigned char ar_tha[ETH_ALEN];
-			unsigned char ar_tip[4];
-		} *arp_eth, _arp_eth;
-		const struct arphdr *arp;
-		struct arphdr _arp;
-
-		arp = __skb_header_pointer(skb, nhoff, sizeof(_arp), data,
-					   hlen, &_arp);
-		if (!arp)
-			goto out_bad;
-
-		if (arp->ar_hrd != htons(ARPHRD_ETHER) ||
-		    arp->ar_pro != htons(ETH_P_IP) ||
-		    arp->ar_hln != ETH_ALEN ||
-		    arp->ar_pln != 4 ||
-		    (arp->ar_op != htons(ARPOP_REPLY) &&
-		     arp->ar_op != htons(ARPOP_REQUEST)))
-			goto out_bad;
-
-		arp_eth = __skb_header_pointer(skb, nhoff + sizeof(_arp),
-					       sizeof(_arp_eth), data,
-					       hlen,
-					       &_arp_eth);
-		if (!arp_eth)
-=======
 	case htons(ETH_P_RARP):
 		switch (__skb_flow_dissect_arp(skb, flow_dissector,
 					       target_container, data,
@@ -614,7 +584,6 @@ mpls:
 			goto out_good;
 		case FLOW_DISSECT_RET_OUT_BAD:
 		default:
->>>>>>> linux-next/akpm-base
 			goto out_bad;
 		}
 	default:
diff -puN net/core/secure_seq.c~linux-next-git-rejects net/core/secure_seq.c
--- a/net/core/secure_seq.c~linux-next-git-rejects
+++ a/net/core/secure_seq.c
@@ -64,13 +64,8 @@ static u32 secure_tcpv6_ts_off(const __b
 		       &ts_secret);
 }
 
-<<<<<<< HEAD
-u32 secure_tcpv6_sequence_number(const __be32 *saddr, const __be32 *daddr,
-				 __be16 sport, __be16 dport, u32 *tsoff)
-=======
 u32 secure_tcpv6_seq_and_tsoff(const __be32 *saddr, const __be32 *daddr,
 			       __be16 sport, __be16 dport, u32 *tsoff)
->>>>>>> linux-next/akpm-base
 {
 	const struct {
 		struct in6_addr saddr;
@@ -116,13 +111,6 @@ static u32 secure_tcp_ts_off(__be32 sadd
 {
 	if (sysctl_tcp_timestamps != 1)
 		return 0;
-<<<<<<< HEAD
-
-	return siphash_2u32((__force u32)saddr, (__force u32)daddr,
-			    &ts_secret);
-}
-=======
->>>>>>> linux-next/akpm-base
 
 	return siphash_2u32((__force u32)saddr, (__force u32)daddr,
 			    &ts_secret);
diff -puN tools/testing/selftests/bpf/Makefile~linux-next-git-rejects tools/testing/selftests/bpf/Makefile
--- a/tools/testing/selftests/bpf/Makefile~linux-next-git-rejects
+++ a/tools/testing/selftests/bpf/Makefile
@@ -7,12 +7,6 @@ GENHDR := $(GENDIR)/autoconf.h
 ifneq ($(wildcard $(GENHDR)),)
   GENFLAGS := -DHAVE_GENHDR
 endif
-<<<<<<< HEAD
-
-CFLAGS += -Wall -O2 -I$(APIDIR) -I$(LIBDIR) -I$(GENDIR) $(GENFLAGS)
-LDLIBS += -lcap
-=======
->>>>>>> linux-next/akpm-base
 
 CFLAGS += -Wall -O2 -I$(APIDIR) -I$(LIBDIR) -I$(GENDIR) -I../../../include $(GENFLAGS)
 LDLIBS += -lcap -lelf
diff -puN tools/testing/selftests/bpf/test_verifier.c~linux-next-git-rejects tools/testing/selftests/bpf/test_verifier.c
--- a/tools/testing/selftests/bpf/test_verifier.c~linux-next-git-rejects
+++ a/tools/testing/selftests/bpf/test_verifier.c
@@ -4724,9 +4724,6 @@ static struct bpf_test tests[] = {
 		.result = REJECT,
 		.result_unpriv = REJECT,
 		.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
-<<<<<<< HEAD
-	}
-=======
 	},
 	{
 		"map in map access",
@@ -4797,7 +4794,6 @@ static struct bpf_test tests[] = {
 		.errstr = "R1 type=map_value_or_null expected=map_ptr",
 		.result = REJECT,
 	},
->>>>>>> linux-next/akpm-base
 };
 
 static int probe_filter_length(const struct bpf_insn *fp)
@@ -4910,11 +4906,7 @@ static void do_test_single(struct bpf_te
 	struct bpf_insn *prog = test->insns;
 	int prog_len = probe_filter_length(prog);
 	int prog_type = test->prog_type;
-<<<<<<< HEAD
-	int fd_f1 = -1, fd_f2 = -1, fd_f3 = -1;
-=======
 	int map_fds[MAX_NR_MAPS];
->>>>>>> linux-next/akpm-base
 	const char *expected_err;
 	int i;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
ptrace-fix-ptrace_listen-race-corrupting-task-state-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-move-madv_free-pages-into-lru_inactive_file-list-checkpatch-fixes.patch
mm-use-is_migrate_highatomic-to-simplify-the-code-fix.patch
mm-introduce-memalloc_nofs_saverestore-api-fix.patch
jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context-fix.patch
jbd2-make-the-whole-kjournald2-kthread-nofs-safe-checkpatch-fixes.patch
mm-page_alloc-count-movable-pages-when-stealing-from-pageblock-fix.patch
swap-add-warning-if-swap-slots-cache-failed-to-initialize-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix-fix.patch
taskstats-add-e-u-stime-for-tgid-command-fix.patch
taskstats-add-e-u-stime-for-tgid-command-fix-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
linux-next-rejects.patch
drm-use-set_memoryh-header-fix.patch
drivers-staging-media-atomisp-pci-atomisp2-use-set_memoryh.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
linux-next-git-rejects.patch

