From: akpm@linux-foundation.org
Subject: - revert-9p-convert-from-semaphore-to-spinlock.patch removed from -mm tree
Date: Fri, 16 May 2008 15:53:41 -0700
Message-ID: <200805162253.m4GMrfio003158@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37733 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757024AbYEPWxv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 May 2008 18:53:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, matthew@wil.cx, sfr@canb.auug.org.au, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     revert 9p: Convert from semaphore to spinlock
has been removed from the -mm tree.  Its filename was
     revert-9p-convert-from-semaphore-to-spinlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: revert 9p: Convert from semaphore to spinlock
From: Andrew Morton <akpm@linux-foundation.org>

revert

commit 2c77d192c68a95a188dd326db1315b3492487c41
Author: Matthew Wilcox <matthew@wil.cx>
Date:   Wed Apr 23 08:41:35 2008 -0400

    9p: Convert from semaphore to spinlock
    
    The virtio_9p_lock is only held for very short periods of time and
    never does a blocking operation while it's held, so it really should be
    a spinlock.
    
    Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

because it craps all over the maintainer's tree.

Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/9p/trans_virtio.c |   44 +++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 23 deletions(-)

diff -puN net/9p/trans_virtio.c~revert-9p-convert-from-semaphore-to-spinlock net/9p/trans_virtio.c
--- a/net/9p/trans_virtio.c~revert-9p-convert-from-semaphore-to-spinlock
+++ a/net/9p/trans_virtio.c
@@ -28,30 +28,28 @@
  *
  */
 
-#include <linux/errno.h>
-#include <linux/file.h>
-#include <linux/idr.h>
-#include <linux/inet.h>
 #include <linux/in.h>
-#include <linux/ipv6.h>
-#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/net.h>
-#include <linux/parser.h>
-#include <linux/scatterlist.h>
-#include <linux/spinlock.h>
-#include <linux/uaccess.h>
+#include <linux/ipv6.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
 #include <linux/un.h>
-#include <linux/virtio_9p.h>
-#include <linux/virtio.h>
-
+#include <linux/uaccess.h>
+#include <linux/inet.h>
+#include <linux/idr.h>
+#include <linux/file.h>
 #include <net/9p/9p.h>
+#include <linux/parser.h>
 #include <net/9p/transport.h>
+#include <linux/scatterlist.h>
+#include <linux/virtio.h>
+#include <linux/virtio_9p.h>
 
 #define VIRTQUEUE_NUM	128
 
-/* a single lock to manage channel initialization and attachment */
-static DEFINE_SPINLOCK(virtio_9p_lock);
+/* a single mutex to manage channel initialization and attachment */
+static DECLARE_MUTEX(virtio_9p_lock);
 /* global which tracks highest initialized channel */
 static int chan_index;
 
@@ -146,9 +144,9 @@ static void p9_virtio_close(struct p9_tr
 	chan->max_tag = 0;
 	spin_unlock_irqrestore(&chan->lock, flags);
 
-	spin_lock(&virtio_9p_lock);
+	down(&virtio_9p_lock);
 	chan->inuse = false;
-	spin_unlock(&virtio_9p_lock);
+	up(&virtio_9p_lock);
 
 	kfree(trans);
 }
@@ -271,10 +269,10 @@ static int p9_virtio_probe(struct virtio
 	struct virtio_chan *chan;
 	int index;
 
-	spin_lock(&virtio_9p_lock);
+	down(&virtio_9p_lock);
 	index = chan_index++;
 	chan = &channels[index];
-	spin_unlock(&virtio_9p_lock);
+	up(&virtio_9p_lock);
 
 	if (chan_index > MAX_9P_CHAN) {
 		printk(KERN_ERR "9p: virtio: Maximum channels exceeded\n");
@@ -303,9 +301,9 @@ static int p9_virtio_probe(struct virtio
 out_free_vq:
 	vdev->config->del_vq(chan->vq);
 fail:
-	spin_lock(&virtio_9p_lock);
+	down(&virtio_9p_lock);
 	chan_index--;
-	spin_unlock(&virtio_9p_lock);
+	up(&virtio_9p_lock);
 	return err;
 }
 
@@ -322,7 +320,7 @@ p9_virtio_create(const char *devname, ch
 	struct virtio_chan *chan = channels;
 	int index = 0;
 
-	spin_lock(&virtio_9p_lock);
+	down(&virtio_9p_lock);
 	while (index < MAX_9P_CHAN) {
 		if (chan->initialized && !chan->inuse) {
 			chan->inuse = true;
@@ -332,7 +330,7 @@ p9_virtio_create(const char *devname, ch
 			chan = &channels[index];
 		}
 	}
-	spin_unlock(&virtio_9p_lock);
+	up(&virtio_9p_lock);
 
 	if (index >= MAX_9P_CHAN) {
 		printk(KERN_ERR "9p: no channels available\n");
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
fix-kobject-fix-kobject_rename-and-config_sysfs.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-video-balcklist-fujitsu-lifebook-s6410.patch
git-x86-fixup.patch
arch-x86-mm-patc-use-boot_cpu_has.patch
x86-setup_force_cpu_cap-dont-do-clear_bitnon-unsigned-long.patch
lguest-use-cpu-capability-accessors.patch
x86-set_restore_sigmask-avoid-bitop-on-a-u32.patch
x86-bitops-take-an-unsigned-long.patch
arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex.patch
audit_send_reply-fix-error-path-memory-leak.patch
zoran-use-correct-type-for-cpu-flags.patch
i2c-renesas-highlander-fpga-smbus-support.patch
drivers-infiniband-hw-mlx4-qpc-fix-uninitialised-var-warning.patch
git-input.patch
git-jg-misc-git-rejects.patch
drivers-scsi-broadsasc-fix-uninitialised-var-warning.patch
fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch
mmc-sd-host-driver-for-ricoh-bay1controllers.patch
git-ubifs.patch
sundance-set-carrier-status-on-link-change-events.patch
dm9000-use-delayed-work-to-update-mii-phy-state-fix.patch
pcnet32-fix-warning.patch
drivers-net-tokenring-3c359c-squish-a-warning.patch
drivers-net-tokenring-olympicc-fix-warning.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch
drivers-scsi-qla2xxx-qla_osc-suppress-uninitialized-var-warning.patch
s390-uninline-spinlock-functions-which-use-smp_processor_id.patch
git-unionfs.patch
git-unionfs-fixup.patch
git-logfs-fixup.patch
drivers-uwb-nehc-processor-flags-have-type-unsigned-long.patch
drivers-usb-host-isp1760-hcdc-procesxor-flags-have-type-unsigned-long.patch
uwb-fix-scscanf-warning.patch
drivers-uwb-wlp-sysfsc-dead-code.patch
drivers-uwb-i1480-dfu-macc-fix-min-warning.patch
drivers-uwb-whcic-needs-dma-mappingh.patch
git-vfs-cleanups-reject.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
watchdog-fix-booke_wdtc-on-mpc85xx-smp-system.patch
wireless-airo-waitbusy-wont-delay-checkpatch-fixes.patch
git-xtensa.patch
ibmaem-new-driver-for-power-energy-temp-meters-in-ibm-system-x-hardware-ia64-warnings.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
colibri-fix-support-for-dm9000-ethernet-device.patch
mm-verify-the-page-links-and-memory-model.patch
mspec-convert-nopfn-to-fault-fix.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
kill-generic_file_direct_io-checkpatch-fixes.patch
spufs-use-the-new-vm_ops-access-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
split-the-typecheck-macros-out-of-include-linux-kernelh.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-fix.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
rename-warn-to-warning-to-clear-the-namespace-fix.patch
add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch
flag-parameters-paccept-fix.patch
flag-parameters-paccept-sys_ni.patch
flag-parameters-anon_inode_getfd-extension-fix.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
flag-parameters-inotify_init-fix.patch
flag-parameters-check-magic-constants-alpha-hack.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
reiserfs-convert-j_flush_sem-to-mutex-fix.patch
reiserfs-convert-j_commit_lock-to-mutex-checkpatch-fixes.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
reiser4.patch
reiser4-semaphore-fix.patch
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

