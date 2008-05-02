From: akpm@linux-foundation.org
Subject: + revert-9p-convert-from-semaphore-to-spinlock.patch added to -mm tree
Date: Fri, 02 May 2008 14:50:59 -0700
Message-ID: <200805022150.m42Lox35016709@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33305 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752521AbYEBVvg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 17:51:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, matthew@wil.cx, sfr@canb.auug.org.au, willy@linux.intel.com


The patch titled
     revert 9p: Convert from semaphore to spinlock
has been added to the -mm tree.  Its filename is
     revert-9p-convert-from-semaphore-to-spinlock.patch

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
revert-9p-convert-from-semaphore-to-spinlock.patch
sxc-fix-printk-warnings-on-sparc32.patch
revert-memory-hotplug-register-section-node-id-to-free.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-video-balcklist-fujitsu-lifebook-s6410.patch
git-x86-fixup.patch
rtc-remove-unneeded-declarations-of-hpet_rtc_interrupt.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline.patch
cifs-suppress-warning.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
i2c-renesas-highlander-fpga-smbus-support.patch
touch-screen-driver-for-the-superh-migor-board.patch
pata_atiixp-simplex-clear.patch
git-mips.patch
git-mips-git-rejects.patch
git-mmc.patch
sundance-set-carrier-status-on-link-change-events.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch
drivers-base-topologyc-add-conditionals-around-show_cpumap.patch
add-rcu_assign_index-if-ever-needed.patch
git-unionfs.patch
git-unionfs-fixup.patch
git-v9fs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
watchdog-fix-booke_wdtc-on-mpc85xx-smp-system.patch
xfs-suppress-uninitialized-var-warnings.patch
git-xtensa.patch
ext4-is-busted-on-m68k.patch
pci-export-resource_wc-in-pci-sysfs-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-checkpatch-fixes.patch
add-warn_on_secs-macro.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
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

