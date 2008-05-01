From: akpm@linux-foundation.org
Subject: - hfs-fix-warning-with-64k-page_size.patch removed from -mm tree
Date: Thu, 01 May 2008 02:32:39 -0700
Message-ID: <200805010932.m419Wdam031001@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35532 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758065AbYEAJct (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:32:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     hfs: fix warning with 64k PAGE_SIZE
has been removed from the -mm tree.  Its filename was
     hfs-fix-warning-with-64k-page_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hfs: fix warning with 64k PAGE_SIZE
From: Andrew Morton <akpm@linux-foundation.org>

fs/hfs/btree.c: In function 'hfs_bmap_alloc':
fs/hfs/btree.c:263: warning: comparison is always false due to limited range of data type

The patch makes the warning go away, but the code might actually be buggy?

Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/btree.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN fs/hfs/btree.c~hfs-fix-warning-with-64k-page_size fs/hfs/btree.c
--- a/fs/hfs/btree.c~hfs-fix-warning-with-64k-page_size
+++ a/fs/hfs/btree.c
@@ -208,7 +208,9 @@ struct hfs_bnode *hfs_bmap_alloc(struct 
 	struct hfs_bnode *node, *next_node;
 	struct page **pagep;
 	u32 nidx, idx;
-	u16 off, len;
+	unsigned off;
+	u16 off16;
+	u16 len;
 	u8 *data, byte, m;
 	int i;
 
@@ -235,7 +237,8 @@ struct hfs_bnode *hfs_bmap_alloc(struct 
 	node = hfs_bnode_find(tree, nidx);
 	if (IS_ERR(node))
 		return node;
-	len = hfs_brec_lenoff(node, 2, &off);
+	len = hfs_brec_lenoff(node, 2, &off16);
+	off = off16;
 
 	off += node->page_offset;
 	pagep = node->page + (off >> PAGE_CACHE_SHIFT);
@@ -280,7 +283,8 @@ struct hfs_bnode *hfs_bmap_alloc(struct 
 			return next_node;
 		node = next_node;
 
-		len = hfs_brec_lenoff(node, 0, &off);
+		len = hfs_brec_lenoff(node, 0, &off16);
+		off = off16;
 		off += node->page_offset;
 		pagep = node->page + (off >> PAGE_CACHE_SHIFT);
 		data = kmap(*pagep);
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

