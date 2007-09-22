From: akpm@linux-foundation.org
Subject: + git-net-fix-spidernet-build.patch added to -mm tree
Date: Sat, 22 Sep 2007 00:18:33 -0700
Message-ID: <200709220718.l8M7IXQl012525@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43614 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753689AbXIVHSp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 22 Sep 2007 03:18:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: satyam@infradead.org, davem@davemloft.net


The patch titled
     git-net: fix spidernet build
has been added to the -mm tree.  Its filename is
     git-net-fix-spidernet-build.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-net: fix spidernet build
From: Satyam Sharma <satyam@infradead.org>

Unbreak the following:

drivers/net/spider_net.c: In function 'spider_net_release_tx_chain':
drivers/net/spider_net.c:818: error: 'dev' undeclared (first use in this function)
drivers/net/spider_net.c:818: error: (Each undeclared identifier is reported only once
drivers/net/spider_net.c:818: error: for each function it appears in.)
drivers/net/spider_net.c: In function 'spider_net_xmit':
drivers/net/spider_net.c:922: error: 'dev' undeclared (first use in this function)
drivers/net/spider_net.c: In function 'spider_net_pass_skb_up':
drivers/net/spider_net.c:1018: error: 'dev' undeclared (first use in this function)
drivers/net/spider_net.c: In function 'spider_net_decode_one_descr':
drivers/net/spider_net.c:1215: error: 'dev' undeclared (first use in this function)
make[2]: *** [drivers/net/spider_net.o] Error 1

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/spider_net.c |   24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff -puN drivers/net/spider_net.c~git-net-fix-spidernet-build drivers/net/spider_net.c
--- a/drivers/net/spider_net.c~git-net-fix-spidernet-build
+++ a/drivers/net/spider_net.c
@@ -795,6 +795,7 @@ spider_net_set_low_watermark(struct spid
 static int
 spider_net_release_tx_chain(struct spider_net_card *card, int brutal)
 {
+	struct net_device *dev = card->netdev;
 	struct spider_net_descr_chain *chain = &card->tx_chain;
 	struct spider_net_descr *descr;
 	struct spider_net_hw_descr *hwdescr;
@@ -919,7 +920,7 @@ spider_net_xmit(struct sk_buff *skb, str
 	spider_net_release_tx_chain(card, 0);
 
 	if (spider_net_prepare_tx_descr(card, skb) != 0) {
-		dev->stats.tx_dropped++;
+		netdev->stats.tx_dropped++;
 		netif_stop_queue(netdev);
 		return NETDEV_TX_BUSY;
 	}
@@ -979,16 +980,12 @@ static void
 spider_net_pass_skb_up(struct spider_net_descr *descr,
 		       struct spider_net_card *card)
 {
-	struct spider_net_hw_descr *hwdescr= descr->hwdescr;
-	struct sk_buff *skb;
-	struct net_device *netdev;
-	u32 data_status, data_error;
-
-	data_status = hwdescr->data_status;
-	data_error = hwdescr->data_error;
-	netdev = card->netdev;
+	struct spider_net_hw_descr *hwdescr = descr->hwdescr;
+	struct sk_buff *skb = descr->skb;
+	struct net_device *netdev = card->netdev;
+	u32 data_status = hwdescr->data_status;
+	u32 data_error = hwdescr->data_error;
 
-	skb = descr->skb;
 	skb_put(skb, hwdescr->valid_size);
 
 	/* the card seems to add 2 bytes of junk in front
@@ -1015,8 +1012,8 @@ spider_net_pass_skb_up(struct spider_net
 	}
 
 	/* update netdevice statistics */
-	dev->stats.rx_packets++;
-	dev->stats.rx_bytes += skb->len;
+	netdev->stats.rx_packets++;
+	netdev->stats.rx_bytes += skb->len;
 
 	/* pass skb up to stack */
 	netif_receive_skb(skb);
@@ -1184,6 +1181,7 @@ static int spider_net_resync_tail_ptr(st
 static int
 spider_net_decode_one_descr(struct spider_net_card *card)
 {
+	struct net_device *dev = card->netdev;
 	struct spider_net_descr_chain *chain = &card->rx_chain;
 	struct spider_net_descr *descr = chain->tail;
 	struct spider_net_hw_descr *hwdescr = descr->hwdescr;
@@ -1210,7 +1208,7 @@ spider_net_decode_one_descr(struct spide
 	     (status == SPIDER_NET_DESCR_PROTECTION_ERROR) ||
 	     (status == SPIDER_NET_DESCR_FORCE_END) ) {
 		if (netif_msg_rx_err(card))
-			dev_err(&card->netdev->dev,
+			dev_err(&dev->dev,
 			       "dropping RX descriptor with state %d\n", status);
 		dev->stats.rx_dropped++;
 		goto bad_desc;
_

Patches currently in -mm which might be from satyam@infradead.org are

cpufreq-mark-hotplug-notifier-callback-as-__cpuinit.patch
cpufreq-implement-config_cpu_freq-stub-for.patch
cpufreq_stats-misc-cpuinit-section-annotations.patch
git-hwmon.patch
ia64-tree-wide-misc-__cpuinitdata-init-exit.patch
ia64-perfmon-remove-exit_pfm_fs.patch
git-ieee1394.patch
ehca_irq-misc-cpuinit-section-annotations-and-ifdef-cleanups.patch
git-net.patch
git-net-fix-spidernet-build.patch
git-s390.patch
sched-use-show_regs-to-improve-__schedule_bug-output.patch
use-mutex-instead-of-semaphore-in-the-onstream-scsi-tape-driver.patch
mpt-fusion-shut-up-uninitialized-variable.patch
git-block.patch
git-watchdog.patch
intel_cacheinfo-misc-section-annotation-fixes.patch
intel_cacheinfo-call-cache_add_dev-from-cache_sysfs_init.patch
slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check.patch
softlockup-improve-debug-output-fix.patch
argv_split-allow-argv_split-to-handle-null-pointer-in-argcp-parameter-gracefully.patch
ufs-fix-sun-state-fix-mount-check-in-ufs_fill_super.patch
i2o-fix-defined-but-not-used-build-warnings.patch
i2o-fix-defined-but-not-used-build-warnings-fix.patch
make-the-pr_-family-of-macros-in-kernelh-complete.patch
unify-dma_bit_mask-definitions-v31.patch
redefine-unregister_hotcpu_notifier-hotplug_cpu-stubs.patch
x86-msr-driver-misc-cpuinit-annotations.patch
i386-cpuid-misc-cpuinit-annotations.patch
