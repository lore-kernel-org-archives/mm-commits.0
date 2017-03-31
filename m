From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Fri, 31 Mar 2017 13:06:14 -0700
Message-ID: <58deb6b6.K4tiq4F2zIIGJe9B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49238 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754594AbdCaUGP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 31 Mar 2017 16:06:15 -0400
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

 drivers/thermal/devfreq_cooling.c |   20 --------------------
 1 file changed, 20 deletions(-)

diff -puN drivers/thermal/devfreq_cooling.c~linux-next-git-rejects drivers/thermal/devfreq_cooling.c
--- a/drivers/thermal/devfreq_cooling.c~linux-next-git-rejects
+++ a/drivers/thermal/devfreq_cooling.c
@@ -214,29 +214,9 @@ get_static_power(struct devfreq_cooling_
 	if (!dfc->power_ops->get_static_power)
 		return 0;
 
-<<<<<<< HEAD
-	opp = dev_pm_opp_find_freq_exact(dev, freq, true);
-	if (PTR_ERR(opp) == -ERANGE)
-		opp = dev_pm_opp_find_freq_exact(dev, freq, false);
-
-	if (IS_ERR(opp)) {
-		dev_err_ratelimited(dev, "Failed to find OPP for frequency %lu: %ld\n",
-				    freq, PTR_ERR(opp));
-		return 0;
-	}
-
-	voltage = dev_pm_opp_get_voltage(opp) / 1000; /* mV */
-	dev_pm_opp_put(opp);
-
-	if (voltage == 0) {
-		dev_err_ratelimited(dev,
-				    "Failed to get voltage for frequency %lu\n",
-				    freq);
-=======
 	voltage = get_voltage(df, freq);
 
 	if (voltage == 0)
->>>>>>> linux-next/akpm-base
 		return 0;
 
 	return dfc->power_ops->get_static_power(df, voltage);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
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
drivers-net-ethernet-mellanox-mlx5-core-en_mainc-fix-build-with-gcc-444.patch
drm-use-set_memoryh-header-fix.patch
drivers-staging-media-atomisp-pci-atomisp2-use-set_memoryh.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
drivers-net-ethernet-mellanox-mlx5-core-en_ethtoolc-fix-build-with-gcc-444.patch

