From: akpm@linux-foundation.org
Subject: + drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static.patch added to -mm tree
Date: Thu, 06 Mar 2008 23:44:30 -0800
Message-ID: <200803070744.m277iUwU011491@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53198 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758907AbYCGHpc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Mar 2008 02:45:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, rmk@arm.linux.org.uk


The patch titled
     drivers/pcmcia/soc_common.c: convert soc_pcmcia_sockets_lock into a mutex and make it static
has been added to the -mm tree.  Its filename is
     drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static.patch

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
rename-declare_pci_device_table-to-define_pci_device_table.patch
git-x86.patch
arch-x86-kernel-ptracec-fix-defined-but-unused-warnings.patch
git-acpi-fixup.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-alsa.patch
git-alsa-fix-git-conflicts.patch
git-arm-master.patch
git-powerpc-fix-git-rejects.patch
revert-gregkh-driver-video-add-the-go7007-driver.patch
fix-gregkh-driver-net-convert-the-phy_device-file-to-use-bus_find_device_by_name.patch
driver-core-debug-for-bad-dev_attr_show-return-value.patch
git-drm.patch
git-dvb.patch
oz99x-i2c-button-and-led-support-driver.patch
git-hwmon.patch
git-hrt.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
maple-add-driver-for-sega-dreamcast-controller-update-checkpatch-fixes.patch
git-kvm.patch
git-md-accel.patch
git-md-accel-fix-git-rejects.patch
git-net.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd.patch
git-ocfs2.patch
git-selinux.patch
git-sh.patch
scsi-aic94xx-cleanups.patch
scsi-chc-fix-shadowed-variable-warnings-checkpatch-fixes.patch
git-block-git-rejects.patch
git-unionfs.patch
git-v9fs.patch
git-watchdog.patch
git-watchdog-prevent-kconfig-explosion.patch
git-semaphore-git-rejects.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
capabilities-implement-per-process-securebits-warning-fix.patch
lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks-checkpatch-fixes.patch
lsm-audit-introduce-generic-audit-lsm-hooks-checkpatch-fixes.patch
selinux-use-new-audit-hooks-remove-redundant-exports-checkpatch-fixes.patch
audit-final-renamings-and-cleanup-checkpatch-fixes.patch
make-dev-kmem-a-config-option-fix.patch
misc-phantom-add-compat-ioctl-checkpatch-fixes.patch
kernel-add-clamp-and-clamp_t-macros-checkpatch-fixes.patch
kernel-add-clamp-and-clamp_t-macros-fix.patch
r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir-fix.patch
r-o-bind-mounts-elevate-write-count-for-xattr_permission-callers-fix.patch
r-o-bind-mounts-get-write-access-for-vfs_rename-callers-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix-2.patch
r-o-bind-mounts-get-callers-of-vfs_mknod-create-fix.patch
fs-inodec-use-hlist_for_each_entry-checkpatch-fixes.patch
add-rcu_assign_index-if-ever-needed-fix.patch
uart_get_baud_rate-stop-mangling-termios-fix.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
vt-notifier-extension-for-accessibility-checkpatch-fixes.patch
kprobes-prevent-probing-of-preempt_schedule-fix.patch
kprobes-prevent-probing-of-preempt_schedule-checkpatch-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
fat_valid_media-remove-pointless-test.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
ext4-is-broken.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
keys-add-keyctl-function-to-get-a-security-label-fix.patch
procfs-task-exe-symlink-fix.patch
edd-add-default-mode-config_edd_off=n-override-with-edd=onoff-fix.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
basic-braille-screen-reader-support-ppc-fix.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
w1-build-fix.patch
drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static.patch

