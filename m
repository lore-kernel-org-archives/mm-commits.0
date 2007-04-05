From: akpm@linux-foundation.org
Subject: - mtd-support-for-auto-locking-flash-on-power-up.patch removed from -mm tree
Date: Wed, 04 Apr 2007 19:00:25 -0700
Message-ID: <200704050200.l3520Pj4004819@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38040 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932451AbXDECAi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 4 Apr 2007 22:00:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: giometti@enneenne.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     MTD: support for auto locking flash on power up
has been removed from the -mm tree.  Its filename was
     mtd-support-for-auto-locking-flash-on-power-up.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: MTD: support for auto locking flash on power up
From: Rodolfo Giometti <giometti@enneenne.com>

Auto unlock sectors on resume for auto locking flash on power up.

Signed-off-by: Rodolfo Giometti <giometti@enneenne.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/chips/cfi_cmdset_0001.c |   93 +++++++++++++++++++++++++-
 include/linux/mtd/mtd.h             |    1 
 2 files changed, 91 insertions(+), 3 deletions(-)

diff -puN drivers/mtd/chips/cfi_cmdset_0001.c~mtd-support-for-auto-locking-flash-on-power-up drivers/mtd/chips/cfi_cmdset_0001.c
--- a/drivers/mtd/chips/cfi_cmdset_0001.c~mtd-support-for-auto-locking-flash-on-power-up
+++ a/drivers/mtd/chips/cfi_cmdset_0001.c
@@ -15,6 +15,8 @@
  *	- optimized write buffer method
  * 02/05/2002	Christopher Hoover <ch@hpl.hp.com>/<ch@murgatroid.com>
  *	- reworked lock/unlock/erase support for var size flash
+ * 21/03/2007   Rodolfo Giometti <giometti@linux.it>
+ * 	- auto unlock sectors on resume for auto locking flash on power up
  */
 
 #include <linux/module.h>
@@ -30,6 +32,7 @@
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/reboot.h>
+#include <linux/bitmap.h>
 #include <linux/mtd/xip.h>
 #include <linux/mtd/map.h>
 #include <linux/mtd/mtd.h>
@@ -220,6 +223,15 @@ static void fixup_use_write_buffers(stru
 	}
 }
 
+/*
+ * Some chips power-up with all sectors locked by default.
+ */
+static void fixup_use_powerup_lock(struct mtd_info *mtd, void *param)
+{
+	printk(KERN_INFO "Using auto-unlock on power-up/resume\n" );
+	mtd->flags |= MTD_STUPID_LOCK;
+}
+
 static struct cfi_fixup cfi_fixup_table[] = {
 #ifdef CMDSET0001_DISABLE_ERASE_SUSPEND_ON_WRITE
 	{ CFI_MFR_ANY, CFI_ID_ANY, fixup_intel_strataflash, NULL },
@@ -232,6 +244,7 @@ static struct cfi_fixup cfi_fixup_table[
 #endif
 	{ CFI_MFR_ST, 0x00ba, /* M28W320CT */ fixup_st_m28w320ct, NULL },
 	{ CFI_MFR_ST, 0x00bb, /* M28W320CB */ fixup_st_m28w320cb, NULL },
+	{ MANUFACTURER_INTEL, 0x891c,	      fixup_use_powerup_lock, NULL, },
 	{ 0, 0, NULL, NULL }
 };
 
@@ -460,6 +473,7 @@ static struct mtd_info *cfi_intelext_set
 			mtd->eraseregions[(j*cfi->cfiq->NumEraseRegions)+i].offset = (j*devsize)+offset;
 			mtd->eraseregions[(j*cfi->cfiq->NumEraseRegions)+i].erasesize = ersize;
 			mtd->eraseregions[(j*cfi->cfiq->NumEraseRegions)+i].numblocks = ernum;
+			mtd->eraseregions[(j*cfi->cfiq->NumEraseRegions)+i].lockmap = kmalloc(ernum / 8 + 1, GFP_KERNEL);
 		}
 		offset += (ersize * ernum);
 	}
@@ -1825,8 +1839,7 @@ static void cfi_intelext_sync (struct mt
 	}
 }
 
-#ifdef DEBUG_LOCK_BITS
-static int __xipram do_printlockstatus_oneblock(struct map_info *map,
+static int __xipram do_getlockstatus_oneblock(struct map_info *map,
 						struct flchip *chip,
 						unsigned long adr,
 						int len, void *thunk)
@@ -1840,8 +1853,17 @@ static int __xipram do_printlockstatus_o
 	chip->state = FL_JEDEC_QUERY;
 	status = cfi_read_query(map, adr+(2*ofs_factor));
 	xip_enable(map, chip, 0);
+	return status;
+}
+
+#ifdef DEBUG_LOCK_BITS
+static int __xipram do_printlockstatus_oneblock(struct map_info *map,
+						struct flchip *chip,
+						unsigned long adr,
+						int len, void *thunk)
+{
 	printk(KERN_DEBUG "block status register for 0x%08lx is %x\n",
-	       adr, status);
+	       adr, do_getlockstatus_oneblock(map, chip, adr, len, thunk));
 	return 0;
 }
 #endif
@@ -2216,14 +2238,45 @@ static int cfi_intelext_get_user_prot_in
 
 #endif
 
+static void cfi_intelext_save_locks(struct mtd_info *mtd)
+{
+	struct mtd_erase_region_info *region;
+	int block, status, i;
+	unsigned long adr;
+	size_t len;
+
+	for (i = 0; i < mtd->numeraseregions; i++) {
+		region = &mtd->eraseregions[i];
+		if (!region->lockmap)
+			continue;
+
+		for (block = 0; block < region->numblocks; block++){
+			len = region->erasesize;
+			adr = region->offset + block * len;
+
+			status = cfi_varsize_frob(mtd,
+					do_getlockstatus_oneblock, adr, len, 0);
+			if (status)
+				set_bit(block, region->lockmap);
+			else
+				clear_bit(block, region->lockmap);
+		}
+	}
+}
+
 static int cfi_intelext_suspend(struct mtd_info *mtd)
 {
 	struct map_info *map = mtd->priv;
 	struct cfi_private *cfi = map->fldrv_priv;
+	struct cfi_pri_intelext *extp = cfi->cmdset_priv;
 	int i;
 	struct flchip *chip;
 	int ret = 0;
 
+	if ((mtd->flags & MTD_STUPID_LOCK)
+	    && extp && (extp->FeatureSupport & (1 << 5)))
+		cfi_intelext_save_locks(mtd);
+
 	for (i=0; !ret && i<cfi->numchips; i++) {
 		chip = &cfi->chips[i];
 
@@ -2285,10 +2338,33 @@ static int cfi_intelext_suspend(struct m
 	return ret;
 }
 
+static void cfi_intelext_restore_locks(struct mtd_info *mtd)
+{
+	struct mtd_erase_region_info *region;
+	int block, i;
+	unsigned long adr;
+	size_t len;
+
+	for (i = 0; i < mtd->numeraseregions; i++) {
+		region = &mtd->eraseregions[i];
+		if (!region->lockmap)
+			continue;
+
+		for (block = 0; block < region->numblocks; block++) {
+			len = region->erasesize;
+			adr = region->offset + block * len;
+
+			if (!test_bit(block, region->lockmap))
+				cfi_intelext_unlock(mtd, adr, len);
+		}
+	}
+}
+
 static void cfi_intelext_resume(struct mtd_info *mtd)
 {
 	struct map_info *map = mtd->priv;
 	struct cfi_private *cfi = map->fldrv_priv;
+	struct cfi_pri_intelext *extp = cfi->cmdset_priv;
 	int i;
 	struct flchip *chip;
 
@@ -2307,6 +2383,10 @@ static void cfi_intelext_resume(struct m
 
 		spin_unlock(chip->mutex);
 	}
+
+	if ((mtd->flags & MTD_STUPID_LOCK)
+	    && extp && (extp->FeatureSupport & (1 << 5)))
+		cfi_intelext_restore_locks(mtd);
 }
 
 static int cfi_intelext_reset(struct mtd_info *mtd)
@@ -2347,12 +2427,19 @@ static void cfi_intelext_destroy(struct 
 {
 	struct map_info *map = mtd->priv;
 	struct cfi_private *cfi = map->fldrv_priv;
+	struct mtd_erase_region_info *region;
+	int i;
 	cfi_intelext_reset(mtd);
 	unregister_reboot_notifier(&mtd->reboot_notifier);
 	kfree(cfi->cmdset_priv);
 	kfree(cfi->cfiq);
 	kfree(cfi->chips[0].priv);
 	kfree(cfi);
+	for (i = 0; i < mtd->numeraseregions; i++) {
+		region = &mtd->eraseregions[i];
+		if (region->lockmap)
+			kfree(region->lockmap);
+	}
 	kfree(mtd->eraseregions);
 }
 
diff -puN include/linux/mtd/mtd.h~mtd-support-for-auto-locking-flash-on-power-up include/linux/mtd/mtd.h
--- a/include/linux/mtd/mtd.h~mtd-support-for-auto-locking-flash-on-power-up
+++ a/include/linux/mtd/mtd.h
@@ -53,6 +53,7 @@ struct mtd_erase_region_info {
 	u_int32_t offset;			/* At which this region starts, from the beginning of the MTD */
 	u_int32_t erasesize;		/* For this region */
 	u_int32_t numblocks;		/* Number of blocks of erasesize in this region */
+	unsigned long *lockmap;		/* If keeping bitmap of locks */
 };
 
 /*
_

Patches currently in -mm which might be from giometti@enneenne.com are

i2c-tsl2550-support.patch
git-input.patch
git-mtd.patch
