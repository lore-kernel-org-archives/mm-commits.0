From: akpm@linux-foundation.org
Subject: - alloc_uid-cleanup.patch removed from -mm tree
Date: Thu, 01 May 2008 02:32:43 -0700
Message-ID: <200805010932.m419Whrw031007@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45679 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758131AbYEAJda (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:33:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     alloc_uid: cleanup
has been removed from the -mm tree.  Its filename was
     alloc_uid-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alloc_uid: cleanup
From: Andrew Morton <akpm@linux-foundation.org>

Use kmem_cache_zalloc(), remove large amounts of initialisation code and
ifdeffery.

Note: this assumes that memset(*atomic_t, 0) correctly initialises the
atomic_t.  This is true for all present archtiectures and if it becomes false
for a future architecture then we'll need to make large changes all over the
place anyway.

Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/user.c |   18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff -puN kernel/user.c~alloc_uid-cleanup kernel/user.c
--- a/kernel/user.c~alloc_uid-cleanup
+++ a/kernel/user.c
@@ -384,7 +384,7 @@ void free_uid(struct user_struct *up)
 		local_irq_restore(flags);
 }
 
-struct user_struct * alloc_uid(struct user_namespace *ns, uid_t uid)
+struct user_struct *alloc_uid(struct user_namespace *ns, uid_t uid)
 {
 	struct hlist_head *hashent = uidhashentry(ns, uid);
 	struct user_struct *up, *new;
@@ -399,26 +399,12 @@ struct user_struct * alloc_uid(struct us
 	spin_unlock_irq(&uidhash_lock);
 
 	if (!up) {
-		new = kmem_cache_alloc(uid_cachep, GFP_KERNEL);
+		new = kmem_cache_zalloc(uid_cachep, GFP_KERNEL);
 		if (!new)
 			goto out_unlock;
 
 		new->uid = uid;
 		atomic_set(&new->__count, 1);
-		atomic_set(&new->processes, 0);
-		atomic_set(&new->files, 0);
-		atomic_set(&new->sigpending, 0);
-#ifdef CONFIG_INOTIFY_USER
-		atomic_set(&new->inotify_watches, 0);
-		atomic_set(&new->inotify_devs, 0);
-#endif
-#ifdef CONFIG_POSIX_MQUEUE
-		new->mq_bytes = 0;
-#endif
-		new->locked_shm = 0;
-#ifdef CONFIG_KEYS
-		new->uid_keyring = new->session_keyring = NULL;
-#endif
 
 		if (sched_create_user(new) < 0)
 			goto out_free_user;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static.patch
revert-memory-hotplug-register-section-node-id-to-free.patch
pci-export-resource_wc-in-pci-sysfs-fix.patch
disable-the-memory-controller-by-default-v3.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
pnp-fix-printk-format-warnings-fix-checkpatch-fixes.patch
git-x86-fixup.patch
rtc-remove-unneeded-declarations-of-hpet_rtc_interrupt.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline-cleanup.patch
cifs-suppress-warning.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
git-dvb.patch
i2c-renesas-highlander-fpga-smbus-support.patch
git-hwmon.patch
touch-screen-driver-for-the-superh-migor-board.patch
git-kvm.patch
pata_atiixp-simplex-clear.patch
git-m32r.patch
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
scsi-fix-section-mismatch-in-aic94xx.patch
drivers-scsi-mvsasc-fix-build-warnings.patch
aic79xx_core-remove-ascii-art.patch
sparc32-export-empty_zero_page.patch
git-unionfs.patch
git-v9fs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
xfs-suppress-uninitialized-var-warnings.patch
git-xtensa.patch
make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes.patch
ext4-is-busted-on-m68k.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
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
x86-ioremap-add-checks-for-virtual-addresses-fix.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

