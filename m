From: akpm@linux-foundation.org
Subject: - linuxpps-core-support-drivers-pps-sysfsc-make-dev_attr_name-static.patch removed from -mm tree
Date: Tue, 02 Dec 2008 23:50:44 -0800
Message-ID: <200812030750.mB37oipu026921@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43618 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752459AbYLCHux (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2008 02:50:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, giometti@linux.it, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     drivers/pps/sysfs.c: make dev_attr_name static
has been removed from the -mm tree.  Its filename was
     linuxpps-core-support-drivers-pps-sysfsc-make-dev_attr_name-static.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/pps/sysfs.c: make dev_attr_name static
From: Andrew Morton <akpm@linux-foundation.org>

Fix things like this:

drivers/hwmon/built-in.o:(.data+0x8e60): multiple definition of `dev_attr_name'
drivers/pps/built-in.o:(.data+0x160): first defined here

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Rodolfo Giometti <giometti@linux.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/sysfs.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/pps/sysfs.c~linuxpps-core-support-drivers-pps-sysfsc-make-dev_attr_name-static drivers/pps/sysfs.c
--- a/drivers/pps/sysfs.c~linuxpps-core-support-drivers-pps-sysfsc-make-dev_attr_name-static
+++ a/drivers/pps/sysfs.c
@@ -41,7 +41,7 @@ static ssize_t pps_show_assert(struct de
 			(long long) pps->assert_tu.sec, pps->assert_tu.nsec,
 			pps->assert_sequence);
 }
-DEVICE_ATTR(assert, S_IRUGO, pps_show_assert, NULL);
+static DEVICE_ATTR(assert, S_IRUGO, pps_show_assert, NULL);
 
 static ssize_t pps_show_clear(struct device *dev,
 				struct device_attribute *attr, char *buf)
@@ -55,7 +55,7 @@ static ssize_t pps_show_clear(struct dev
 			(long long) pps->clear_tu.sec, pps->clear_tu.nsec,
 			pps->clear_sequence);
 }
-DEVICE_ATTR(clear, S_IRUGO, pps_show_clear, NULL);
+static DEVICE_ATTR(clear, S_IRUGO, pps_show_clear, NULL);
 
 static ssize_t pps_show_mode(struct device *dev,
 				struct device_attribute *attr, char *buf)
@@ -64,7 +64,7 @@ static ssize_t pps_show_mode(struct devi
 
 	return sprintf(buf, "%4x\n", pps->info.mode);
 }
-DEVICE_ATTR(mode, S_IRUGO, pps_show_mode, NULL);
+static DEVICE_ATTR(mode, S_IRUGO, pps_show_mode, NULL);
 
 static ssize_t pps_show_echo(struct device *dev,
 				struct device_attribute *attr, char *buf)
@@ -73,7 +73,7 @@ static ssize_t pps_show_echo(struct devi
 
 	return sprintf(buf, "%d\n", !!pps->info.echo);
 }
-DEVICE_ATTR(echo, S_IRUGO, pps_show_echo, NULL);
+static DEVICE_ATTR(echo, S_IRUGO, pps_show_echo, NULL);
 
 static ssize_t pps_show_name(struct device *dev,
 				struct device_attribute *attr, char *buf)
@@ -82,7 +82,7 @@ static ssize_t pps_show_name(struct devi
 
 	return sprintf(buf, "%s\n", pps->info.name);
 }
-DEVICE_ATTR(name, S_IRUGO, pps_show_name, NULL);
+static DEVICE_ATTR(name, S_IRUGO, pps_show_name, NULL);
 
 static ssize_t pps_show_path(struct device *dev,
 				struct device_attribute *attr, char *buf)
@@ -91,7 +91,7 @@ static ssize_t pps_show_path(struct devi
 
 	return sprintf(buf, "%s\n", pps->info.path);
 }
-DEVICE_ATTR(path, S_IRUGO, pps_show_path, NULL);
+static DEVICE_ATTR(path, S_IRUGO, pps_show_path, NULL);
 
 struct device_attribute pps_attrs[] = {
 	__ATTR(assert, S_IRUGO, pps_show_assert, NULL),
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

bdi-register-sysfs-bdi-device-only-once-per-queue.patch
ksym_symbol_len-fixes.patch
mm-remove-the-might_sleep-from-lock_page.patch
make-linx-next-apply.patch
linux-next.patch
next-remove-localversion.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
linux-timexh-cleanup-for-userspace.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
netdev-smc911x-fix-for-driver-resume-cleanup.patch
backlight-catch-invalid-input.patch
pci-uninline-pci_ioremap_bar.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-more-terminate-quickly.patch
swapfile-change-discard-pgoff_t-to-sector_t-fix.patch
fs-truncate-blocks-outside-i_size-after-o_direct-write-error-fix.patch
init-properly-placing-noinline-keyword.patch
add-pr_prefix-to-pr_xyz-macros-checkpatch-fixes.patch
poll-allow-f_op-poll-to-sleep-take6.patch
binfmtsh-include-listh-fix.patch
max3100-spi-uart-driver-select-serial_core-fix.patch
spi_gpio-driver-cleanups.patch
kprobes-support-probing-module-__exit-function-fix.patch
kprobes-support-probing-module-__exit-function-fix-2.patch
rtc-au1000-on-chip-counter0-as-rtc-driver-fix.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memcg-avoid-unnecessary-system-wide-oom-killer-fix.patch
edac-struct-device-replace-bus_id-with-dev_name-dev_set_name-checkpatch-fixes.patch
edac-x38-use-the-architectures-readq-function-fix.patch
parport-ieee1284-use-del_timer_sync-in-parport_wait_event-checkpatch-fixes.patch
romfs-romfs_iget-unsigned-ino-=-0-is-always-true-checkpatch-fixes.patch
filesystem-freeze-implement-generic-freeze-feature-fix.patch
linuxpps-core-support-drivers-pps-sysfsc-make-dev_attr_name-static.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

