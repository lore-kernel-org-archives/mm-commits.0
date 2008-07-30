From: akpm@linux-foundation.org
Subject: + hwmon-adc124s501-generic-driver-cleanup.patch added to -mm tree
Date: Wed, 30 Jul 2008 03:27:42 -0700
Message-ID: <200807301027.m6UARg7t021263@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35062 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755924AbYG3K2C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 06:28:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, david-b@pacbell.net, khali@linux-fr.org, marc.pignat@hevs.ch, mhoffman@lightlink.com, tobias@himmer-online.de


The patch titled
     hwmon-adc124s501-generic-driver-cleanup
has been added to the -mm tree.  Its filename is
     hwmon-adc124s501-generic-driver-cleanup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hwmon-adc124s501-generic-driver-cleanup
From: Andrew Morton <akpm@linux-foundation.org>

Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Marc Pignat <marc.pignat@hevs.ch>
Cc: Tobias Himmer <tobias@himmer-online.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/adcxx.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN drivers/hwmon/adcxx.c~hwmon-adc124s501-generic-driver-cleanup drivers/hwmon/adcxx.c
--- a/drivers/hwmon/adcxx.c~hwmon-adc124s501-generic-driver-cleanup
+++ a/drivers/hwmon/adcxx.c
@@ -61,7 +61,6 @@ static ssize_t adcxx_read(struct device 
 	struct spi_device *spi = to_spi_device(dev);
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct adcxx *adc = dev_get_drvdata(&spi->dev);
-
 	u8 tx_buf[2] = { attr->index << 3 }; /* other bits are don't care */
 	u8 rx_buf[2];
 	int status;
@@ -100,7 +99,6 @@ static ssize_t adcxx_show_max(struct dev
 {
 	struct spi_device *spi = to_spi_device(dev);
 	struct adcxx *adc = dev_get_drvdata(&spi->dev);
-
 	u32 reference;
 
 	if (mutex_lock_interruptible(&adc->lock))
@@ -118,7 +116,6 @@ static ssize_t adcxx_set_max(struct devi
 {
 	struct spi_device *spi = to_spi_device(dev);
 	struct adcxx *adc = dev_get_drvdata(&spi->dev);
-
 	unsigned long value;
 
 	if (strict_strtoul(buf, 10, &value))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

connector-add-a-blackboard-user-to-connector.patch
sched-make-scheduler-sysfs-attributes-sysdev-class-devices.patch
gru-driver-v3-hardware-data-structures.patch
gru-driver-v3-fixes-to-resolve-code-review-comments.patch
seq_file-fix-bug-when-seq_read-reads-nothing.patch
linux-next.patch
linux-next-rejects.patch
next-remove-localversion.patch
drivers-mtd-nand-nandsimc-needs-div64h.patch
pci-make-pci_register_driver-a-macro.patch
arch-x86-pci-irqc-attempt-to-clean-up-code-layout.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
powerpc-replace-__function__-with-__func__-checkpatch-fixes.patch
verify_dynamic_kobject_allocation-dont-use-kmalloc.patch
i2c-renesas-highlander-fpga-smbus-support.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-serio-xilinx_ps2c-fix-warning.patch
git-jg-misc.patch
drivers-mtd-nand-nandsimc-fix-printk-warnings.patch
drivers-mtd-nand-fsl_elbc_nandc-fix-printk-warning.patch
bridge-send-correct-mtu-value-in-pmtu-checkpatch-fixes.patch
sundance-set-carrier-status-on-link-change-events.patch
cassini-use-request_firmware-fix.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
sched-type-fix.patch
scsi-gdthc-use-unaligned-access-helpers-checkpatch-fixes.patch
git-block-git-rejects.patch
git-unionfs.patch
git-logfs-git-rejects.patch
git-logfs-fixup.patch
drivers-usb-class-cdc-acmc-use-correct-type-for-cpu-flags.patch
drivers-usb-class-cdc-wdmc-fix-build-with-config_pm=n.patch
drivers-net-wireless-iwlwifi-iwl-ledc-printk-fix.patch
git-xtensa.patch
drivers-telephony-ixjc-depends-on-pnp.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
hwmon-adc124s501-generic-driver-cleanup.patch
drivers-net-netxen-netxen_nic_hwc-fix-printk-warnings.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works-comment.patch
ftrace-disable-function-tracing-bringing-up-new-cpu-fix.patch
unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmscan-unevictable-lru-scan-sysctl.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix-logfs.patch
eink_apollofb-new-driver-for-apollo-eink-controller.patch
devpts-switch-to-ida-checkpatch-fixes.patch
getdelaysc-add-a-usr1-signal-handler-checkpatch-fixes.patch
w1-feature-enable-hardware-strong-pullup-checkpatch-fixes.patch
w1-ds2490c-add-support-for-strong-pullup-checkpatch-fixes.patch
w1-ds2490c-optimize-ds_set_pullup-checkpatch-fixes.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
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

