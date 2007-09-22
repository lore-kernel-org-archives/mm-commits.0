From: akpm@linux-foundation.org
Subject: + spider_net_ethtool-keep-up-with-recent-netdev-stats-changes.patch added to -mm tree
Date: Sat, 22 Sep 2007 00:37:01 -0700
Message-ID: <200709220737.l8M7b1TM013110@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58422 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755347AbXIVHhK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 22 Sep 2007 03:37:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: satyam@infradead.org


The patch titled
     spider_net_ethtool: Keep up with recent netdev stats changes
has been added to the -mm tree.  Its filename is
     spider_net_ethtool-keep-up-with-recent-netdev-stats-changes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spider_net_ethtool: Keep up with recent netdev stats changes
From: Satyam Sharma <satyam@infradead.org>

drivers/net/spider_net_ethtool.c: In function 'spider_net_get_ethtool_stats':
drivers/net/spider_net_ethtool.c:160: error: structure has no member named 'netdev_stats'
drivers/net/spider_net_ethtool.c:161: error: structure has no member named 'netdev_stats'
drivers/net/spider_net_ethtool.c:162: error: structure has no member named 'netdev_stats'
drivers/net/spider_net_ethtool.c:163: error: structure has no member named 'netdev_stats'
drivers/net/spider_net_ethtool.c:164: error: structure has no member named 'netdev_stats'
drivers/net/spider_net_ethtool.c:165: error: structure has no member named 'netdev_stats'
drivers/net/spider_net_ethtool.c:166: error: structure has no member named 'netdev_stats'
make[2]: *** [drivers/net/spider_net_ethtool.o] Error 1

Also do another ARRAY_SIZE() cleanup while at it.

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/spider_net_ethtool.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff -puN drivers/net/spider_net_ethtool.c~spider_net_ethtool-keep-up-with-recent-netdev-stats-changes drivers/net/spider_net_ethtool.c
--- a/drivers/net/spider_net_ethtool.c~spider_net_ethtool-keep-up-with-recent-netdev-stats-changes
+++ a/drivers/net/spider_net_ethtool.c
@@ -28,8 +28,6 @@
 #include "spider_net.h"
 
 
-#define SPIDER_NET_NUM_STATS 13
-
 static struct {
 	const char str[ETH_GSTRING_LEN];
 } ethtool_stats_keys[] = {
@@ -151,7 +149,7 @@ static int spider_net_get_sset_count(str
 {
 	switch (sset) {
 	case ETH_SS_STATS:
-		return SPIDER_NET_NUM_STATS;
+		return ARRAY_SIZE(ethtool_stats_keys);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -162,13 +160,13 @@ static void spider_net_get_ethtool_stats
 {
 	struct spider_net_card *card = netdev->priv;
 
-	data[0] = card->netdev_stats.tx_packets;
-	data[1] = card->netdev_stats.tx_bytes;
-	data[2] = card->netdev_stats.rx_packets;
-	data[3] = card->netdev_stats.rx_bytes;
-	data[4] = card->netdev_stats.tx_errors;
-	data[5] = card->netdev_stats.tx_dropped;
-	data[6] = card->netdev_stats.rx_dropped;
+	data[0] = netdev->stats.tx_packets;
+	data[1] = netdev->stats.tx_bytes;
+	data[2] = netdev->stats.rx_packets;
+	data[3] = netdev->stats.rx_bytes;
+	data[4] = netdev->stats.tx_errors;
+	data[5] = netdev->stats.tx_dropped;
+	data[6] = netdev->stats.rx_dropped;
 	data[7] = card->spider_stats.rx_desc_error;
 	data[8] = card->spider_stats.tx_timeouts;
 	data[9] = card->spider_stats.alloc_rx_skb_error;
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
spider_net_ethtool-keep-up-with-recent-netdev-stats-changes.patch
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
