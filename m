From: akpm@linux-foundation.org
Subject: + lguest-the-net-driver-lguest-2621-mm1-update-lguest-net-stats-inlinepatch.patch added to -mm tree
Date: Mon, 07 May 2007 16:12:37 -0700
Message-ID: <200705072312.l47NCbDW007902@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38012 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755179AbXEGXMr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 19:12:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, ak@suse.de, jeff@garzik.org


The patch titled
     lguest: 2.6.21-mm1 update: lguest-net-stats-inline.patch
has been added to the -mm tree.  Its filename is
     lguest-the-net-driver-lguest-2621-mm1-update-lguest-net-stats-inlinepatch.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lguest: 2.6.21-mm1 update: lguest-net-stats-inline.patch
From: Rusty Russell <rusty@rustcorp.com.au>

Now inline net_device_stats is upstream, we can use it in the lguest net
driver.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/lguest_net.c |   20 +++++---------------
 1 files changed, 5 insertions(+), 15 deletions(-)

diff -puN drivers/net/lguest_net.c~lguest-the-net-driver-lguest-2621-mm1-update-lguest-net-stats-inlinepatch drivers/net/lguest_net.c
--- a/drivers/net/lguest_net.c~lguest-the-net-driver-lguest-2621-mm1-update-lguest-net-stats-inlinepatch
+++ a/drivers/net/lguest_net.c
@@ -38,8 +38,6 @@ struct lguestnet_info
 	/* My peerid. */
 	unsigned int me;
 
-	struct net_device_stats stats;
-
 	/* Receive queue. */
 	struct sk_buff *skb[NUM_SKBS];
 	struct lguest_dma dma[NUM_SKBS];
@@ -120,13 +118,13 @@ static void transfer_packet(struct net_d
 
 	hcall(LHCALL_SEND_DMA, peer_key(info,peernum), __pa(&dma), 0);
 	if (dma.used_len != skb->len) {
-		info->stats.tx_carrier_errors++;
+		dev->stats.tx_carrier_errors++;
 		pr_debug("Bad xfer to peer %i: %i of %i (dma %p/%i)\n",
 			 peernum, dma.used_len, skb->len,
 			 (void *)dma.addr[0], dma.len[0]);
 	} else {
-		info->stats.tx_bytes += skb->len;
-		info->stats.tx_packets++;
+		dev->stats.tx_bytes += skb->len;
+		dev->stats.tx_packets++;
 	}
 }
 
@@ -212,8 +210,8 @@ static irqreturn_t lguestnet_rcv(int irq
 		pr_debug("Receiving skb proto 0x%04x len %i type %i\n",
 			 ntohs(skb->protocol), skb->len, skb->pkt_type);
 
-		info->stats.rx_bytes += skb->len;
-		info->stats.rx_packets++;
+		dev->stats.rx_bytes += skb->len;
+		dev->stats.rx_packets++;
 		netif_rx(skb);
 	}
 	return done ? IRQ_HANDLED : IRQ_NONE;
@@ -260,13 +258,6 @@ static int lguestnet_close(struct net_de
 	return 0;
 }
 
-static struct net_device_stats *lguestnet_get_stats(struct net_device *dev)
-{
-	struct lguestnet_info *info = dev->priv;
-
-	return &info->stats;
-}
-
 static int lguestnet_probe(struct lguest_device *lgdev)
 {
 	int err, irqf = IRQF_SHARED;
@@ -295,7 +286,6 @@ static int lguestnet_probe(struct lguest
 	dev->open = lguestnet_open;
 	dev->stop = lguestnet_close;
 	dev->hard_start_xmit = lguestnet_start_xmit;
-	dev->get_stats = lguestnet_get_stats;
 
 	/* Turning on/off promisc will call dev->set_multicast_list.
 	 * We don't actually support multicast yet */
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
array_size-check-for-type.patch
xfs-clean-up-shrinker-games.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
module-use-krealloc.patch
get_futex_key-get_key_refs-and-drop_key_refs.patch
futex-restartable-futex_wait.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
simplify-module_get_kallsym-by-dropping-length-arg.patch
fix-race-between-rmmod-and-cat-proc-kallsyms.patch
simplify-kallsyms_lookup.patch
fix-race-between-cat-proc-wchan-and-rmmod-et-al.patch
fix-race-between-cat-proc-slab_allocators-and-rmmod.patch
____call_usermodehelper-dont-flush_signals.patch
wait_for_helper-remove-unneeded-do_sigaction.patch
futex-new-private-futexes.patch
lguest-export-symbols-for-lguest-as-a-module.patch
lguest-the-guest-code.patch
lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda.patch
lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda-lguest-2621-mm1-update.patch
lguest-the-guest-code-update-lguests-patch-code-for-new-paravirt-patch.patch
lguest-the-guest-code-handle-new-paravirt-lazy-mode-fix-userspace.patch
lguest-the-guest-code-dont-use-paravirt_probe-its-dying.patch
lguest-the-host-code.patch
lguest-the-host-code-vs-x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions.patch
lguest-the-host-code-fix-lguest-oops-when-guest-dies-while-receiving-i-o.patch
lguest-the-host-code-simplification-dont-pin-guest-trap-handlers.patch
lguest-the-host-code-properly-kill-guest-userspace-programs-accessing-kernel-mem.patch
lguest-the-host-code-remove-put_user-etc-warnings-add-bloat.patch
lguest-the-host-code-fix-obscure-but-nasty-cow-bug.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-console-driver.patch
lguest-the-net-driver.patch
lguest-the-net-driver-lguest-2621-mm1-update-lguest-net-stats-inlinepatch.patch
lguest-the-block-driver.patch
lguest-the-documentation-example-launcher.patch
lguest-the-documentation-example-launcher-fix-lguest-documentation-error.patch
lguest-documentation-and-example-updates.patch
lguest-the-documentation-example-launcher-dont-use-paravirt_probe-its-dying-doc.patch
lguest-the-host-code-vs-futex-new-private-futexes.patch
compiler-introduce-__used-and-__maybe_unused.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
