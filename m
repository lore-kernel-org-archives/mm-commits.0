From: akpm@linux-foundation.org
Subject: - linux-next-fixup.patch removed from -mm tree
Date: Thu, 08 May 2008 11:59:46 -0700
Message-ID: <200805081859.m48IxkdE000559@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49123 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758880AbYEHTGe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 May 2008 15:06:34 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m48J646J010336
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Thu, 8 May 2008 12:06:05 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     linux-next-fixup
has been removed from the -mm tree.  Its filename was
     linux-next-fixup.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-fixup
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list.h |   25 -------------------------
 kernel/fork.c        |    2 ++
 mm/hugetlb.c         |    1 +
 mm/memory.c          |    3 +++
 4 files changed, 6 insertions(+), 25 deletions(-)

diff -puN include/linux/list.h~linux-next-fixup include/linux/list.h
--- a/include/linux/list.h~linux-next-fixup
+++ a/include/linux/list.h
@@ -515,31 +515,6 @@ static inline void hlist_del(struct hlis
 	n->pprev = LIST_POISON2;
 }
 
-/**
- * hlist_del_rcu - deletes entry from hash list without re-initialization
- * @n: the element to delete from the hash list.
- *
- * Note: list_unhashed() on entry does not return true after this,
- * the entry is in an undefined state. It is useful for RCU based
- * lockfree traversal.
- *
- * In particular, it means that we can not poison the forward
- * pointers that may still be used for walking the hash list.
- *
- * The caller must take whatever precautions are necessary
- * (such as holding appropriate locks) to avoid racing
- * with another list-mutation primitive, such as hlist_add_head_rcu()
- * or hlist_del_rcu(), running on this same list.
- * However, it is perfectly legal to run concurrently with
- * the _rcu list-traversal primitives, such as
- * hlist_for_each_entry_rcu().
- */
-static inline void hlist_del_rcu(struct hlist_node *n)
-{
-	__hlist_del(n);
-	n->pprev = LIST_POISON2;
-}
-
 static inline void hlist_del_init(struct hlist_node *n)
 {
 	if (!hlist_unhashed(n)) {
diff -puN kernel/fork.c~linux-next-fixup kernel/fork.c
--- a/kernel/fork.c~linux-next-fixup
+++ a/kernel/fork.c
@@ -55,6 +55,8 @@
 #include <linux/proc_fs.h>
 #include <linux/blkdev.h>
 #include <linux/mmu_notifier.h>
+#include <linux/magic.h>
+#include <linux/marker.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
diff -puN mm/hugetlb.c~linux-next-fixup mm/hugetlb.c
--- a/mm/hugetlb.c~linux-next-fixup
+++ a/mm/hugetlb.c
@@ -14,6 +14,7 @@
 #include <linux/mempolicy.h>
 #include <linux/cpuset.h>
 #include <linux/mutex.h>
+#include <linux/marker.h>
 #include <linux/mmu_notifier.h>
 
 #include <asm/page.h>
diff -puN mm/memory.c~linux-next-fixup mm/memory.c
--- a/mm/memory.c~linux-next-fixup
+++ a/mm/memory.c
@@ -45,6 +45,7 @@
 #include <linux/swap.h>
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
+#include <linux/marker.h>
 #include <linux/rmap.h>
 #include <linux/module.h>
 #include <linux/delayacct.h>
@@ -52,6 +53,8 @@
 #include <linux/writeback.h>
 #include <linux/memcontrol.h>
 #include <linux/mmu_notifier.h>
+#include <linux/kprobes.h>
+#include <linux/mutex.h>
 
 #include <asm/pgalloc.h>
 #include <asm/uaccess.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
sxc-fix-printk-warnings-on-sparc32.patch
drivers-scsi-dpt_i2oc-fix-build-on-alpha.patch
quota-dont-call-sync_fs-from-vfs_quota_off-when-theres-no-quota-turn-off-fix.patch
rtc-rtc_time_to_tm-use-unsigned-arithmetic-fix.patch
atmel_lcdfb-fix-pixclok-divider-calculation-checkpatch-fixes.patch
linux-next.patch
linux-next-fixup.patch
revert-9p-convert-from-semaphore-to-spinlock.patch
revert-vt-fix-background-color-on-line-feed.patch
revert-lxfb-extend-pll-table-to-support-dotclocks-below-25-mhz.patch
revert-acpica-fixes-for-unload-and-ddbhandles.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-video-balcklist-fujitsu-lifebook-s6410.patch
git-x86.patch
git-x86-fixup.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline.patch
git-arm-master.patch
arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex-fix.patch
cifs-suppress-warning.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
git-dvb.patch
i2c-renesas-highlander-fpga-smbus-support.patch
dlm-convert-connections_lock-in-a-mutex-fix.patch
git-input.patch
touch-screen-driver-for-the-superh-migor-board.patch
git-jg-misc-git-rejects.patch
git-kvm.patch
revert-libata-improve-post-reset-device-ready-test.patch
git-mips-git-rejects.patch
git-mmc.patch
sundance-set-carrier-status-on-link-change-events.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch
git-unionfs.patch
git-unionfs-fixup.patch
git-v9fs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
watchdog-fix-booke_wdtc-on-mpc85xx-smp-system.patch
xfs-suppress-uninitialized-var-warnings.patch
git-xtensa.patch
ext4-is-busted-on-m68k.patch
colibri-fix-support-for-dm9000-ethernet-device-fix.patch
pci-export-resource_wc-in-pci-sysfs-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-checkpatch-fixes.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch
hysdn-no-longer-broken-on-smp.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
reiserfs-convert-j_commit_lock-to-mutex-checkpatch-fixes.patch
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

