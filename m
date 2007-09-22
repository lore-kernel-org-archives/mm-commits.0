From: akpm@linux-foundation.org
Subject: + pasemi_mac-build-fix-after-recent-netdev-stats.patch added to -mm tree
Date: Sat, 22 Sep 2007 00:45:19 -0700
Message-ID: <200709220745.l8M7jJrC013320@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40970 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757202AbXIVHpe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 22 Sep 2007 03:45:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: satyam@infradead.org, davem@davemloft.net


The patch titled
     pasemi_mac: build fix after recent netdev stats  changes
has been added to the -mm tree.  Its filename is
     pasemi_mac-build-fix-after-recent-netdev-stats.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pasemi_mac: build fix after recent netdev stats  changes
From: Satyam Sharma <satyam@infradead.org>

Unbreak the following:

drivers/net/pasemi_mac.c: In function 'pasemi_mac_clean_rx':
drivers/net/pasemi_mac.c:533: error: 'dev' undeclared (first use in this function)
drivers/net/pasemi_mac.c:533: error: (Each undeclared identifier is reported only once
drivers/net/pasemi_mac.c:533: error: for each function it appears in.)

And remove an unused static function:

drivers/net/pasemi_mac.c: At top level:
drivers/net/pasemi_mac.c:89: warning: 'read_iob_reg' defined but not used

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/pasemi_mac.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN drivers/net/pasemi_mac.c~pasemi_mac-build-fix-after-recent-netdev-stats drivers/net/pasemi_mac.c
--- a/drivers/net/pasemi_mac.c~pasemi_mac-build-fix-after-recent-netdev-stats
+++ a/drivers/net/pasemi_mac.c
@@ -85,11 +85,6 @@ MODULE_PARM_DESC(debug, "PA Semi MAC bit
 
 static struct pasdma_status *dma_status;
 
-static unsigned int read_iob_reg(struct pasemi_mac *mac, unsigned int reg)
-{
-	return in_le32(mac->iob_regs+reg);
-}
-
 static void write_iob_reg(struct pasemi_mac *mac, unsigned int reg,
 			  unsigned int val)
 {
@@ -530,8 +525,8 @@ static int pasemi_mac_clean_rx(struct pa
 		} else
 			skb->ip_summed = CHECKSUM_NONE;
 
-		dev->stats.rx_bytes += len;
-		dev->stats.rx_packets++;
+		mac->netdev->stats.rx_bytes += len;
+		mac->netdev->stats.rx_packets++;
 
 		skb->protocol = eth_type_trans(skb, mac->netdev);
 		netif_receive_skb(skb);
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
pasemi_mac-build-fix-after-recent-netdev-stats.patch
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
