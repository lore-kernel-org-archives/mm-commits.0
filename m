From: akpm@linux-foundation.org
Subject: - revert-send-a-single-notification-on-device-state-changes.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:21:14 -0800
Message-ID: <200802232021.m1NKLEm4013313@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:50262 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758974AbYBWUVg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:21:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davem@davemloft.net, panther@balabit.hu, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     revert "[RTNETLINK]: Send a single notification on device state changes."
has been removed from the -mm tree.  Its filename was
     revert-send-a-single-notification-on-device-state-changes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: revert "[RTNETLINK]: Send a single notification on device state changes."
From: Andrew Morton <akpm@linux-foundation.org>

Revert

commit 45b503548210fe6f23e92b856421c2a3f05fd034
Author: Laszlo Attila Toth <panther@balabit.hu>
Date:   Tue Feb 12 22:42:09 2008 -0800

    [RTNETLINK]: Send a single notification on device state changes.
    
    In do_setlink() a single notification is sent at the end of the
    function if any modification occured. If the address has been changed,
    another notification is sent.
    
    Both of them is required because originally only the NETDEV_CHANGEADDR
    notification was sent and although device state change implies address
    change, some programs may expect the original notification. It remains
    for compatibity.
    
    If set_operstate() is called from do_setlink(), it doesn't send a
    notification, only if it is called from rtnl_create_link() as earlier.
    
    Signed-off-by: Laszlo Attila Toth <panther@balabit.hu>
    Signed-off-by: David S. Miller <davem@davemloft.net>

due to obvious deadlock, and NetworkManager breakage when that's fixed.

Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/rtnetlink.c |   36 ++++++++++--------------------------
 1 file changed, 10 insertions(+), 26 deletions(-)

diff -puN net/core/rtnetlink.c~revert-send-a-single-notification-on-device-state-changes net/core/rtnetlink.c
--- a/net/core/rtnetlink.c~revert-send-a-single-notification-on-device-state-changes
+++ a/net/core/rtnetlink.c
@@ -504,7 +504,7 @@ int rtnl_put_cacheinfo(struct sk_buff *s
 
 EXPORT_SYMBOL_GPL(rtnl_put_cacheinfo);
 
-static int set_operstate(struct net_device *dev, unsigned char transition, bool send_notification)
+static void set_operstate(struct net_device *dev, unsigned char transition)
 {
 	unsigned char operstate = dev->operstate;
 
@@ -527,12 +527,8 @@ static int set_operstate(struct net_devi
 		write_lock_bh(&dev_base_lock);
 		dev->operstate = operstate;
 		write_unlock_bh(&dev_base_lock);
-
-		if (send_notification)
-			netdev_state_change(dev);
-		return 1;
-	} else
-		return 0;
+		netdev_state_change(dev);
+	}
 }
 
 static void copy_rtnl_link_stats(struct rtnl_link_stats *a,
@@ -826,7 +822,6 @@ static int do_setlink(struct net_device 
 	if (tb[IFLA_BROADCAST]) {
 		nla_memcpy(dev->broadcast, tb[IFLA_BROADCAST], dev->addr_len);
 		send_addr_notify = 1;
-		modified = 1;
 	}
 
 	if (ifm->ifi_flags || ifm->ifi_change) {
@@ -839,23 +834,16 @@ static int do_setlink(struct net_device 
 		dev_change_flags(dev, flags);
 	}
 
-	if (tb[IFLA_TXQLEN]) {
-		if (dev->tx_queue_len != nla_get_u32(tb[IFLA_TXQLEN])) {
-			dev->tx_queue_len = nla_get_u32(tb[IFLA_TXQLEN]);
-			modified = 1;
-		}
-	}
+	if (tb[IFLA_TXQLEN])
+		dev->tx_queue_len = nla_get_u32(tb[IFLA_TXQLEN]);
 
 	if (tb[IFLA_OPERSTATE])
-		modified |= set_operstate(dev, nla_get_u8(tb[IFLA_OPERSTATE]), false);
+		set_operstate(dev, nla_get_u8(tb[IFLA_OPERSTATE]));
 
 	if (tb[IFLA_LINKMODE]) {
-		if (dev->link_mode != nla_get_u8(tb[IFLA_LINKMODE])) {
-			write_lock_bh(&dev_base_lock);
-			dev->link_mode = nla_get_u8(tb[IFLA_LINKMODE]);
-			write_lock_bh(&dev_base_lock);
-			modified = 1;
-		}
+		write_lock_bh(&dev_base_lock);
+		dev->link_mode = nla_get_u8(tb[IFLA_LINKMODE]);
+		write_unlock_bh(&dev_base_lock);
 	}
 
 	err = 0;
@@ -869,10 +857,6 @@ errout:
 
 	if (send_addr_notify)
 		call_netdevice_notifiers(NETDEV_CHANGEADDR, dev);
-
-	if (modified)
-		netdev_state_change(dev);
-
 	return err;
 }
 
@@ -990,7 +974,7 @@ struct net_device *rtnl_create_link(stru
 	if (tb[IFLA_TXQLEN])
 		dev->tx_queue_len = nla_get_u32(tb[IFLA_TXQLEN]);
 	if (tb[IFLA_OPERSTATE])
-		set_operstate(dev, nla_get_u8(tb[IFLA_OPERSTATE]), true);
+		set_operstate(dev, nla_get_u8(tb[IFLA_OPERSTATE]));
 	if (tb[IFLA_LINKMODE])
 		dev->link_mode = nla_get_u8(tb[IFLA_LINKMODE]);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-alsa-fix-git-conflicts.patch
git-audit-printk-warning-fix.patch
git-cifs.patch
git-drm.patch
git-dvb.patch
git-dvb-someone-broke-the-gpio-includes.patch
git-hwmon.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
git-kvm.patch
git-md-accel.patch
git-ubi.patch
3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd.patch
git-sched.patch
tracing-is-borked-on-powerpc.patch
scsi-aic94xx-cleanups.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
git-block-git-rejects.patch
git-unionfs.patch
drivers-usb-storage-sddr55c-fix-uninitialized-var-warnings.patch
git-x86.patch
git-x86-fixup.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
make-dev-kmem-a-config-option-fix.patch
r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir-fix.patch
r-o-bind-mounts-elevate-write-count-for-xattr_permission-callers-fix.patch
r-o-bind-mounts-get-write-access-for-vfs_rename-callers-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix-2.patch
r-o-bind-mounts-get-callers-of-vfs_mknod-create-fix.patch
add-rcu_assign_index-if-ever-needed-fix.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
vt-notifier-extension-for-accessibility-checkpatch-fixes.patch
rtc-add-support-for-the-s-35390a-rtc-chip-checkpatch-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch
procfs-task-exe-symlink-fix.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
w1-build-fix.patch
