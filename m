From: akpm@linux-foundation.org
Subject: - drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static.patch removed from -mm tree
Date: Fri, 02 May 2008 12:42:43 -0700
Message-ID: <200805021942.m42JghhO011215@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33145 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932193AbYEBTmt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:42:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     drivers/pcmcia/soc_common.c: convert soc_pcmcia_sockets_lock into a mutex and make it static
has been removed from the -mm tree.  Its filename was
     drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/pcmcia/soc_common.c: convert soc_pcmcia_sockets_lock into a mutex and make it static
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/soc_common.c |   15 ++++++++-------
 drivers/pcmcia/soc_common.h |    1 -
 2 files changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/pcmcia/soc_common.c~drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static drivers/pcmcia/soc_common.c
--- a/drivers/pcmcia/soc_common.c~drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static
+++ a/drivers/pcmcia/soc_common.c
@@ -37,6 +37,7 @@
 #include <linux/kernel.h>
 #include <linux/timer.h>
 #include <linux/mm.h>
+#include <linux/mutex.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/spinlock.h>
@@ -578,7 +579,7 @@ EXPORT_SYMBOL(soc_pcmcia_enable_irqs);
 
 
 LIST_HEAD(soc_pcmcia_sockets);
-DECLARE_MUTEX(soc_pcmcia_sockets_lock);
+static DEFINE_MUTEX(soc_pcmcia_sockets_lock);
 
 static const char *skt_names[] = {
 	"PCMCIA socket 0",
@@ -601,11 +602,11 @@ soc_pcmcia_notifier(struct notifier_bloc
 	struct cpufreq_freqs *freqs = data;
 	int ret = 0;
 
-	down(&soc_pcmcia_sockets_lock);
+	mutex_lock(&soc_pcmcia_sockets_lock);
 	list_for_each_entry(skt, &soc_pcmcia_sockets, node)
 		if ( skt->ops->frequency_change )
 			ret += skt->ops->frequency_change(skt, val, freqs);
-	up(&soc_pcmcia_sockets_lock);
+	mutex_unlock(&soc_pcmcia_sockets_lock);
 
 	return ret;
 }
@@ -642,7 +643,7 @@ int soc_common_drv_pcmcia_probe(struct d
 	struct soc_pcmcia_socket *skt;
 	int ret, i;
 
-	down(&soc_pcmcia_sockets_lock);
+	mutex_lock(&soc_pcmcia_sockets_lock);
 
 	sinfo = kzalloc(SKT_DEV_INFO_SIZE(nr), GFP_KERNEL);
 	if (!sinfo) {
@@ -782,7 +783,7 @@ int soc_common_drv_pcmcia_probe(struct d
 	kfree(sinfo);
 
  out:
-	up(&soc_pcmcia_sockets_lock);
+	mutex_unlock(&soc_pcmcia_sockets_lock);
 	return ret;
 }
 
@@ -793,7 +794,7 @@ int soc_common_drv_pcmcia_remove(struct 
 
 	dev_set_drvdata(dev, NULL);
 
-	down(&soc_pcmcia_sockets_lock);
+	mutex_lock(&soc_pcmcia_sockets_lock);
 	for (i = 0; i < sinfo->nskt; i++) {
 		struct soc_pcmcia_socket *skt = &sinfo->skt[i];
 
@@ -818,7 +819,7 @@ int soc_common_drv_pcmcia_remove(struct 
 	if (list_empty(&soc_pcmcia_sockets))
 		soc_pcmcia_cpufreq_unregister();
 
-	up(&soc_pcmcia_sockets_lock);
+	mutex_unlock(&soc_pcmcia_sockets_lock);
 
 	kfree(sinfo);
 
diff -puN drivers/pcmcia/soc_common.h~drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static drivers/pcmcia/soc_common.h
--- a/drivers/pcmcia/soc_common.h~drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static
+++ a/drivers/pcmcia/soc_common.h
@@ -133,7 +133,6 @@ extern void soc_common_pcmcia_get_timing
 
 
 extern struct list_head soc_pcmcia_sockets;
-extern struct semaphore soc_pcmcia_sockets_lock;
 
 extern int soc_common_drv_pcmcia_probe(struct device *dev, struct pcmcia_low_level *ops, int first, int nr);
 extern int soc_common_drv_pcmcia_remove(struct device *dev);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
revert-memory-hotplug-register-section-node-id-to-free.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-video-balcklist-fujitsu-lifebook-s6410.patch
git-x86-fixup.patch
rtc-remove-unneeded-declarations-of-hpet_rtc_interrupt.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline.patch
cifs-suppress-warning.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
git-dvb.patch
i2c-renesas-highlander-fpga-smbus-support.patch
touch-screen-driver-for-the-superh-migor-board.patch
git-kvm.patch
pata_atiixp-simplex-clear.patch
git-mips.patch
git-mips-git-rejects.patch
git-mmc.patch
sundance-set-carrier-status-on-link-change-events.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
power_supply-bump-ec-version-check-that-we-refuse-to-run-with-in-olpc_battery-checkpatch-fixes.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch
git-sched.patch
drivers-base-topologyc-add-conditionals-around-show_cpumap.patch
add-rcu_assign_index-if-ever-needed.patch
git-scsi-misc.patch
aic79xx_core-remove-ascii-art.patch
sparc32-export-empty_zero_page.patch
git-unionfs.patch
git-v9fs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
watchdog-fix-booke_wdtc-on-mpc85xx-smp-system-fix.patch
watchdog-fix-booke_wdtc-on-mpc85xx-smp-system-fix-checkpatch-fixes.patch
xfs-suppress-uninitialized-var-warnings.patch
git-xtensa.patch
make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes.patch
ext4-is-busted-on-m68k.patch
pci-export-resource_wc-in-pci-sysfs-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-checkpatch-fixes.patch
add-warn_on_secs-macro.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
sxc-fix-printk-warnings-on-sparc32.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

