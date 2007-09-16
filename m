From: akpm@linux-foundation.org
Subject: - 3c59x-fix-uninitialized-variable-bug.patch removed from -mm tree
Date: Sun, 16 Sep 2007 01:23:19 -0700
Message-ID: <200709160823.l8G8NJxi007187@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50125 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751597AbXIPIYe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 04:24:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: satyam@infradead.org, jeff@garzik.org, klassert@mathematik.tu-chemnitz.de, mark@hindley.org.uk, mm-commits@vger.kernel.org


The patch titled
     3c59x: fix uninitialized variable bug
has been removed from the -mm tree.  Its filename was
     3c59x-fix-uninitialized-variable-bug.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: 3c59x: fix uninitialized variable bug
From: Satyam Sharma <satyam@infradead.org>

drivers/net/3c59x.c: In function 'vortex_up':
drivers/net/3c59x.c:1495: warning: 'err' may be used uninitialized in this function

is a genuine bug. The function returns an uninitialized value of 'err'
back to the caller, which expects it to be 0 for success cases. Let's
fix this by explicitly initializing 'err' to zero.

(Fixes 2edcccd88469ebb559ee629a9fbeb7eb2cd56d4d in git-netdev-all)

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Acked-by: Steffen Klassert <klassert@mathematik.tu-chemnitz.de>
Cc: Jeff Garzik <jeff@garzik.org>
Acked-by: Mark Hindley <mark@hindley.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/3c59x.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/net/3c59x.c~3c59x-fix-uninitialized-variable-bug drivers/net/3c59x.c
--- a/drivers/net/3c59x.c~3c59x-fix-uninitialized-variable-bug
+++ a/drivers/net/3c59x.c
@@ -1493,7 +1493,8 @@ vortex_up(struct net_device *dev)
 	struct vortex_private *vp = netdev_priv(dev);
 	void __iomem *ioaddr = vp->ioaddr;
 	unsigned int config;
-	int i, mii_reg1, mii_reg5, err;
+	int i, mii_reg1, mii_reg5;
+	int err = 0;
 
 	if (VORTEX_PCI(vp)) {
 		pci_set_power_state(VORTEX_PCI(vp), PCI_D0);	/* Go active */
_

Patches currently in -mm which might be from satyam@infradead.org are

origin.patch
cpufreq-mark-hotplug-notifier-callback-as-__cpuinit.patch
cpufreq-implement-config_cpu_freq-stub-for.patch
cpufreq_stats-misc-cpuinit-section-annotations.patch
drivers-char-nozomic-__devexit_p-usage-build-fix.patch
git-hwmon.patch
ia64-tree-wide-misc-__cpuinitdata-init-exit.patch
ia64-perfmon-remove-exit_pfm_fs.patch
git-ieee1394.patch
ehca_irq-misc-cpuinit-section-annotations-and-ifdef-cleanups.patch
3c59x-fix-uninitialized-variable-bug.patch
git-net.patch
net-sched-sch_cbqc-shut-up-uninitialized-variable.patch
git-s390.patch
sched-use-show_regs-to-improve-__schedule_bug-output.patch
use-mutex-instead-of-semaphore-in-the-onstream-scsi-tape-driver.patch
ll_rw_blk-blk_cpu_notifier-should-be-__cpuinitdata.patch
git-watchdog.patch
intel_cacheinfo-misc-section-annotation-fixes.patch
intel_cacheinfo-call-cache_add_dev-from-cache_sysfs_init.patch
therm_throtc-fix-section-mismatch.patch
i386-cpuid_count-fix-argument-signedness-warnings.patch
slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check.patch
softlockup-improve-debug-output-fix.patch
argv_split-allow-argv_split-to-handle-null-pointer-in-argcp-parameter-gracefully.patch
ufs-fix-sun-state-fix-mount-check-in-ufs_fill_super.patch
remove-superfluous-definition-of-__setup_null_param-macro-and-broken-for-module-__setup_param.patch
i2o-fix-defined-but-not-used-build-warnings.patch
i2o-fix-defined-but-not-used-build-warnings-fix.patch
make-the-pr_-family-of-macros-in-kernelh-complete.patch
redefine-unregister_hotcpu_notifier-hotplug_cpu-stubs.patch
x86-msr-driver-misc-cpuinit-annotations.patch
i386-cpuid-misc-cpuinit-annotations.patch
