From: akpm@linux-foundation.org
Subject: [folded] flex-onenand-support-v2-fix.patch removed from -mm tree
Date: Mon, 06 Apr 2009 21:16:13 -0700
Message-ID: <200904070416.n374GDMN030328@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44908 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751316AbZDGETp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 00:19:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dwmw2@infradead.org, h.rohit@samsung.com, kyungmin.park@samsung.com, vishak.g@samsung.com, mm-commits@vger.kernel.org


The patch titled
     flex-onenand-support-v2-fix
has been removed from the -mm tree.  Its filename was
     flex-onenand-support-v2-fix.patch

This patch was dropped because it was folded into mtd-flex-onenand-support.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: flex-onenand-support-v2-fix
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: "flexonenand_region" [drivers/mtd/onenand/onenand_sim.ko] undefined!
ERROR: "onenand_addr" [drivers/mtd/onenand/onenand_sim.ko] undefined!

(How many times do I need to fix this??)

Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Rohit Hagargundgi <h.rohit@samsung.com>
Cc: Vishak G <vishak.g@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/onenand/onenand_base.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/mtd/onenand/onenand_base.c~flex-onenand-support-v2-fix drivers/mtd/onenand/onenand_base.c
--- a/drivers/mtd/onenand/onenand_base.c~flex-onenand-support-v2-fix
+++ a/drivers/mtd/onenand/onenand_base.c
@@ -262,12 +262,13 @@ static loff_t flexonenand_addr(struct on
 	return ofs;
 }
 
-inline loff_t onenand_addr(struct onenand_chip *this, int block)
+loff_t onenand_addr(struct onenand_chip *this, int block)
 {
 	if (!FLEXONENAND(this))
 		return (loff_t)block << this->erase_shift;
 	return flexonenand_addr(this, block);
 }
+EXPORT_SYMBOL(onenand_addr);
 
 /**
  * onenand_get_density - [DEFAULT] Get OneNAND density
@@ -286,7 +287,7 @@ static inline int onenand_get_density(in
  * @param mtd		MTD device structure
  * @param addr		address whose erase region needs to be identified
  */
-inline int flexonenand_region(struct mtd_info *mtd, loff_t addr)
+int flexonenand_region(struct mtd_info *mtd, loff_t addr)
 {
 	int i;
 
@@ -295,6 +296,7 @@ inline int flexonenand_region(struct mtd
 			break;
 	return i - 1;
 }
+EXPORT_SYMBOL(flexonenand_region);
 
 /**
  * onenand_command - [DEFAULT] Send command to OneNAND device
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-add-proc-controls-for-pdflush-threads.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas.patch
namespaces-mqueue-namespace-adapt-sysctl.patch
nilfs2-integrated-block-mapping.patch
nilfs2-segment-buffer.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
toshiba_acpi-add-full-hotkey-support-fix.patch
early-platform-driver-v3.patch
clocksource-pass-clocksource-to-read-callback.patch
input-bcm5974-declare-alignment-usage.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
mtd-flex-onenand-support.patch
flex-onenand-support-v2-fix.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
xtensa-add-flat-support-checkpatch-fixes.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work.patch
mm-add-proc-controls-for-pdflush-threads-fix-99.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
flat-fix-data-sections-alignment.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
page-owner-tracking.patch
page-owner-tracking-checkpatch-fixes.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch

