From: akpm@linux-foundation.org
Subject: + flex-onenand-support-v2.patch added to -mm tree
Date: Mon, 09 Mar 2009 11:56:05 -0700
Message-ID: <200903091856.n29Iu5ca027467@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37027 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751020AbZCIS43 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Mar 2009 14:56:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: h.rohit@samsung.com, dwmw2@infradead.org, kyungmin.park@samsung.com, vishak.g@samsung.com


The patch titled
     mtd: Flex-OneNAND support
has been added to the -mm tree.  Its filename is
     flex-onenand-support-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd: Flex-OneNAND support
From: Rohit Hagargundgi <h.rohit@samsung.com>

Add support for Samsung Flex-OneNAND devices.

Flex-OneNAND combines SLC and MLC technologies into a single device. 
SLC area provides increased reliability and speed, suitable for storing
code such as bootloader, kernel and root file system.  MLC area
provides high density and is suitable for storing user data.

SLC and MLC regions can be configured through kernel parameter.

Signed-off-by: Vishak G <vishak.g@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Rohit Hagargundgi <h.rohit@samsung.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |   10 +
 drivers/mtd/onenand/Kconfig         |   62 -------
 drivers/mtd/onenand/onenand_base.c  |  206 +++++++++++++++-----------
 drivers/mtd/onenand/onenand_bbt.c   |   13 -
 drivers/mtd/onenand/onenand_sim.c   |   21 +-
 include/linux/mtd/onenand.h         |   31 ---
 6 files changed, 153 insertions(+), 190 deletions(-)

diff -puN Documentation/kernel-parameters.txt~flex-onenand-support-v2 Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~flex-onenand-support-v2
+++ a/Documentation/kernel-parameters.txt
@@ -1346,6 +1346,16 @@ and is between 256 and 4096 characters. 
 	mtdparts=	[MTD]
 			See drivers/mtd/cmdlinepart.c.
 
+	onenand.bdry=	[HW,MTD] Flex-OneNAND Boundary Configuration
+
+			Format: [die0_boundary][,die0_lock][,die1_boundary][,die1_lock]
+
+			boundary - index of last SLC block on Flex-OneNAND.
+				   The remaining blocks are configured as MLC blocks.
+			lock	 - Configure if Flex-OneNAND boundary should be locked.
+				   Once locked, the boundary cannot be changed.
+				   1 indicates lock status, 0 indicates unlock status.
+
 	mtdset=		[ARM]
 			ARM/S3C2412 JIVE boot control
 
diff -puN drivers/mtd/onenand/Kconfig~flex-onenand-support-v2 drivers/mtd/onenand/Kconfig
--- a/drivers/mtd/onenand/Kconfig~flex-onenand-support-v2
+++ a/drivers/mtd/onenand/Kconfig
@@ -71,66 +71,4 @@ config MTD_ONENAND_SIM
 	  The simulator may simulate various OneNAND flash chips for the
 	  OneNAND MTD layer.
 
-config MTD_FLEXONENAND_BOUNDARY
-	bool "Flex-OneNAND Boundary Configuration"
-	depends on MTD_ONENAND
-	default n
-	help
-	  Set SLC and MLC regions of Flex-OneNAND
-
-config MTD_FLEXONENAND_DIE0_BOUNDARY
-	int "Last SLC Block of Flex-OneNAND (min = 0, max = 1023)"
-	depends on MTD_ONENAND && MTD_FLEXONENAND_BOUNDARY
-	default "-1"
-	help
-	  Configure Partition Information (PI) of Flex-OneNAND
-
-	  Entered value indicates index of last SLC block on Flex-OneNAND.
-	  The remaining blocks are configured as MLC blocks.
-
-	  A value of -1 means that PI remains unchanged.
-
-	  This setting applies to :
-		- SDP Flex-OneNAND
-		- Die 1 of DDP Flex-OneNAND.
-
-config MTD_FLEXONENAND_DIE0_ISLOCKED
-	bool "Lock Boundary of Flex-OneNAND"
-	depends on MTD_ONENAND && MTD_FLEXONENAND_BOUNDARY
-	default n
-	help
-	  Configure if Flex-OneNAND boundary should be locked.
-	  Once locked, the boundary cannot be changed.
-
-	  This setting applies to :
-		- SDP Flex-OneNAND
-		- Die 1 of DDP Flex-OneNAND
-
-config MTD_FLEXONENAND_DDP_BOUNDARY
-	bool "Flex-OneNAND DDP Boundary Configuration"
-	depends on MTD_ONENAND && MTD_FLEXONENAND_BOUNDARY
-	default n
-	help
-	  Set SLC and MLC regions of Die 2 of Flex-OneNAND DDP
-
-config MTD_FLEXONENAND_DIE1_BOUNDARY
-	int "Last SLC Block of Flex-OneNAND Die 2 (min = 0, max = 1023)"
-	depends on MTD_ONENAND && MTD_FLEXONENAND_BOUNDARY && MTD_FLEXONENAND_DDP_BOUNDARY
-	default "-1"
-	help
-	  Configure Partition Information (PI) for Die 2 of DDP Flex-OneNAND.
-
-	  Entered value indicates index of last SLC block on Flex-OneNAND.
-	  The remaining blocks are configured as MLC blocks.
-
-	  A value of -1 means that PI remains unchanged.
-
-config MTD_FLEXONENAND_DIE1_ISLOCKED
-	bool "Lock Boundary of Flex-OneNAND Die 2"
-	depends on MTD_ONENAND && MTD_FLEXONENAND_BOUNDARY && MTD_FLEXONENAND_DDP_BOUNDARY
-	default n
-	help
-	  Configure if boundary for Die 2 of DDP Flex-OneNAND should be locked.
-	  Once locked, the boundary cannot be changed.
-
 endif # MTD_ONENAND
diff -puN drivers/mtd/onenand/onenand_base.c~flex-onenand-support-v2 drivers/mtd/onenand/onenand_base.c
--- a/drivers/mtd/onenand/onenand_base.c~flex-onenand-support-v2
+++ a/drivers/mtd/onenand/onenand_base.c
@@ -9,7 +9,7 @@
  *	auto-placement support, read-while load support, various fixes
  *	Copyright (C) Nokia Corporation, 2007
  *
- *	Vishak G <vishak.g@samsung.com>, Rohit Hagargundgi <h.rohit@samsung.com>
+ *	Vishak G <vishak.g at samsung.com>, Rohit Hagargundgi <h.rohit at samsung.com>
  *	Flex-OneNAND support
  *	Copyright (C) Samsung Electronics, 2008
  *
@@ -31,6 +31,9 @@
 
 #include <asm/io.h>
 
+/* Default Flex-OneNAND boundary and lock respectively */
+static int flex_bdry[MAX_DIES * 2] = { -1, 0, -1, 0 };
+
 /**
  *  onenand_oob_128 - oob info for Flex-Onenand with 4KB page
  *  For now, we expose only 64 out of 80 ecc bytes
@@ -204,17 +207,15 @@ static int onenand_buffer_address(int da
 }
 
 /**
- * flexonenand_get_block- For given address return block number and if slc
+ * flexonenand_block- For given address return block number
  * @param this         - OneNAND device structure
  * @param addr		- Address for which block number is needed
- * @return isblkslc	- Block is an SLC block or not
  */
-static unsigned flexonenand_get_block(struct onenand_chip *this, loff_t addr,
-			   unsigned *isblkslc)
+static unsigned flexonenand_block(struct onenand_chip *this, loff_t addr)
 {
 	unsigned boundary, blk, die = 0;
 
-	if (addr >= this->diesize[0]) {
+	if (ONENAND_IS_DDP(this) && addr >= this->diesize[0]) {
 		die = 1;
 		addr -= this->diesize[0];
 	}
@@ -225,29 +226,25 @@ static unsigned flexonenand_get_block(st
 	if (blk > boundary)
 		blk = (blk + boundary + 1) >> 1;
 
-	if (isblkslc)
-		*isblkslc = (blk <= boundary) ? 1 : 0;
-
 	blk += die ? this->density_mask : 0;
 	return blk;
 }
 
-inline unsigned onenand_get_block(struct onenand_chip *this, loff_t addr,
-					unsigned *isblkslc)
+inline unsigned onenand_block(struct onenand_chip *this, loff_t addr)
 {
 	if (!FLEXONENAND(this))
 		return addr >> this->erase_shift;
-	return flexonenand_get_block(this, addr, isblkslc);
+	return flexonenand_block(this, addr);
 }
 
 /**
- * flexonenand_get_addr - Return address of the block
+ * flexonenand_addr - Return address of the block
  * @this:		OneNAND device structure
  * @block:		Block number on Flex-OneNAND
  *
  * Return address of the block
  */
-static loff_t flexonenand_get_addr(struct onenand_chip *this, int block)
+static loff_t flexonenand_addr(struct onenand_chip *this, int block)
 {
 	loff_t ofs = 0;
 	int die = 0, boundary;
@@ -259,17 +256,17 @@ static loff_t flexonenand_get_addr(struc
 	}
 
 	boundary = this->boundary[die];
-	ofs += block << (this->erase_shift - 1);
+	ofs += (loff_t)block << (this->erase_shift - 1);
 	if (block > (boundary + 1))
-		ofs += (block - boundary - 1) << (this->erase_shift - 1);
+		ofs += (loff_t)(block - boundary - 1) << (this->erase_shift - 1);
 	return ofs;
 }
 
-inline loff_t onenand_get_addr(struct onenand_chip *this, int block)
+inline loff_t onenand_addr(struct onenand_chip *this, int block)
 {
 	if (!FLEXONENAND(this))
-		return block << this->erase_shift;
-	return flexonenand_get_addr(this, block);
+		return (loff_t)block << this->erase_shift;
+	return flexonenand_addr(this, block);
 }
 
 /**
@@ -285,19 +282,18 @@ static inline int onenand_get_density(in
 }
 
 /**
- * eraseregion - [Flex-OneNAND] Return erase region of addr
+ * flexonenand_region - [Flex-OneNAND] Return erase region of addr
  * @param mtd		MTD device structure
  * @param addr		address whose erase region needs to be identified
  */
-static inline int eraseregion(struct mtd_info *mtd, loff_t addr)
+inline int flexonenand_region(struct mtd_info *mtd, loff_t addr)
 {
 	int i;
 
-	for (i = 0; i < mtd->numeraseregions &&
-	     addr >= mtd->eraseregions[i].offset; i++)
-		;
-	i--;
-	return i;
+	for (i = 0; i < mtd->numeraseregions; i++)
+		if (addr < mtd->eraseregions[i].offset)
+			break;
+	return i - 1;
 }
 
 /**
@@ -314,7 +310,6 @@ static int onenand_command(struct mtd_in
 {
 	struct onenand_chip *this = mtd->priv;
 	int value, block, page;
-	unsigned slc = 0;
 
 	/* Address translation */
 	switch (cmd) {
@@ -335,7 +330,7 @@ static int onenand_command(struct mtd_in
 	case ONENAND_CMD_ERASE:
 	case ONENAND_CMD_BUFFERRAM:
 	case ONENAND_CMD_OTP_ACCESS:
-		block = onenand_get_block(this, addr, NULL);
+		block = onenand_block(this, addr);
 		page = -1;
 		break;
 
@@ -346,8 +341,8 @@ static int onenand_command(struct mtd_in
 		break;
 
 	default:
-		block = onenand_get_block(this, addr, &slc);
-		page = (int) (addr - onenand_get_addr(this, block)) >> this->page_shift;
+		block = onenand_block(this, addr);
+		page = (int) (addr - onenand_addr(this, block)) >> this->page_shift;
 
 		if (ONENAND_IS_2PLANE(this)) {
 			/* Make the even block number */
@@ -358,8 +353,6 @@ static int onenand_command(struct mtd_in
 			page >>= 1;
 		}
 		page &= this->page_mask;
-		if (slc)
-			page &= (this->page_mask >> 1);
 		break;
 	}
 
@@ -818,7 +811,7 @@ static int onenand_check_bufferram(struc
 
 	if (found && ONENAND_IS_DDP(this)) {
 		/* Select DataRAM for DDP */
-		int block = onenand_get_block(this, addr, NULL);
+		int block = onenand_block(this, addr);
 		int value = onenand_bufferram_address(this, block);
 		this->write_word(value, this->base + ONENAND_REG_START_ADDRESS2);
 	}
@@ -993,7 +986,7 @@ static int onenand_transfer_auto_oob(str
 static int onenand_recover_lsb(struct mtd_info *mtd, loff_t addr, int status)
 {
 	struct onenand_chip *this = mtd->priv;
-	unsigned slc = 0;
+	int i;
 
 	/* Recovery is only for Flex-OneNAND */
 	if (!FLEXONENAND(this))
@@ -1004,8 +997,8 @@ static int onenand_recover_lsb(struct mt
 		return status;
 
 	/* check if address lies in MLC region */
-	onenand_get_block(this, addr, &slc);
-	if (slc)
+	i = flexonenand_region(mtd, addr);
+	if (mtd->eraseregions[i].erasesize < (1 << this->erase_shift))
 		return status;
 
 	/* We are attempting to reread, so decrement stats.failed
@@ -2101,28 +2094,28 @@ static int onenand_erase(struct mtd_info
 	struct onenand_chip *this = mtd->priv;
 	unsigned int block_size;
 	loff_t addr = instr->addr;
-	unsigned int len = instr->len;
+	loff_t len = instr->len;
 	int ret = 0, i;
 	struct mtd_erase_region_info *region = NULL;
-	unsigned int region_end = 0;
+	loff_t region_end = 0;
 
 	DEBUG(MTD_DEBUG_LEVEL3, "onenand_erase: start = 0x%012llx, len = %llu\n", (unsigned long long) instr->addr, (unsigned long long) instr->len);
 
 	/* Do not allow erase past end of device */
-	if (unlikely((instr->len + instr->addr) > mtd->size)) {
+	if (unlikely((len + addr) > mtd->size)) {
 		printk(KERN_ERR "onenand_erase: Erase past end of device\n");
 		return -EINVAL;
 	}
 
-	if (mtd->numeraseregions > 1) {
+	if (FLEXONENAND(this)) {
 		/* Find the eraseregion of this address */
-		i = eraseregion(mtd, addr);
+		i = flexonenand_region(mtd, addr);
 		region = &mtd->eraseregions[i];
 
 		block_size = region->erasesize;
 		region_end = region->offset + region->erasesize * region->numblocks;
-		/*
-		 * Start address within region must align on block boundary.
+
+		/* Start address within region must align on block boundary.
 		 * Erase region's start offset is always block start address.
 		 */
 		if (unlikely((addr - region->offset) & (block_size - 1))) {
@@ -2130,7 +2123,7 @@ static int onenand_erase(struct mtd_info
 			return -EINVAL;
 		}
 	} else {
-		block_size = (1 << this->erase_shift);
+		block_size = 1 << this->erase_shift;
 
 		/* Start address must align on block boundary */
 		if (unlikely(addr & (block_size - 1))) {
@@ -2145,7 +2138,6 @@ static int onenand_erase(struct mtd_info
 		return -EINVAL;
 	}
 
-
 	instr->fail_addr = MTD_FAIL_ADDR_UNKNOWN;
 
 	/* Grab the lock and see if the device is available */
@@ -2172,7 +2164,7 @@ static int onenand_erase(struct mtd_info
 		/* Check, if it is write protected */
 		if (ret) {
 			printk(KERN_ERR "onenand_erase: Failed erase, block %d\n",
-			 (unsigned)onenand_get_block(this, addr, NULL));
+						 onenand_block(this, addr));
 			instr->state = MTD_ERASE_FAILED;
 			instr->fail_addr = addr;
 			goto erase_exit;
@@ -2274,7 +2266,7 @@ static int onenand_default_block_markbad
 	int block;
 
 	/* Get block number */
-	block = onenand_get_block(this, ofs, NULL);
+	block = onenand_block(this, ofs);
         if (bbm->bbt)
                 bbm->bbt[block >> 2] |= 0x01 << ((block & 0x03) << 1);
 
@@ -2328,8 +2320,8 @@ static int onenand_do_lock_cmd(struct mt
 	int start, end, block, value, status;
 	int wp_status_mask;
 
-	start = onenand_get_block(this, ofs, NULL);
-	end = onenand_get_block(this, ofs + len, NULL) - 1;
+	start = onenand_block(this, ofs);
+	end = onenand_block(this, ofs + len) - 1;
 
 	if (cmd == ONENAND_CMD_LOCK)
 		wp_status_mask = ONENAND_WP_LS;
@@ -2456,6 +2448,7 @@ static int onenand_check_lock_status(str
 			return 0;
 		}
 	}
+
 	return 1;
 }
 
@@ -2469,7 +2462,7 @@ static void onenand_unlock_all(struct mt
 {
 	struct onenand_chip *this = mtd->priv;
 	loff_t ofs = 0;
-	size_t len = mtd->size;
+	loff_t len = mtd->size;
 
 	if (this->options & ONENAND_HAS_UNLOCK_ALL) {
 		/* Set start block address */
@@ -2490,15 +2483,10 @@ static void onenand_unlock_all(struct mt
 			return;
 
 		/* Workaround for all block unlock in DDP */
-		if (ONENAND_IS_DDP(this)) {
-			/* All blocks on another chip
-			 * For Flex-OneNAND with both slc
-			 * mlc regions, we use diesize
-			 */
-			ofs = FLEXONENAND(this) ? this->diesize[0] :
-							this->chipsize >> 1;
-			len = FLEXONENAND(this) ? this->diesize[1] :
-							this->chipsize >> 1;
+		if (ONENAND_IS_DDP(this) && !FLEXONENAND(this)) {
+			/* All blocks on another chip */
+			ofs = this->chipsize >> 1;
+			len = this->chipsize >> 1;
 		}
 	}
 
@@ -2983,8 +2971,10 @@ static int flexonenand_get_boundary(stru
 		ret = this->wait(mtd, FL_READING);
 
 		bdry = this->read_word(this->base + ONENAND_DATARAM);
-		locked = bdry >> FLEXONENAND_PI_UNLOCK_SHIFT;
-		locked = (locked == 0x3) ? 0 : 1;
+		if ((bdry >> FLEXONENAND_PI_UNLOCK_SHIFT) == 3)
+			locked = 0;
+		else
+			locked = 1;
 		this->boundary[die] = bdry & FLEXONENAND_PI_MASK;
 
 		this->command(mtd, ONENAND_CMD_RESET, 0, 0);
@@ -3000,23 +2990,23 @@ static int flexonenand_get_boundary(stru
 }
 
 /**
- * flexonenand_get_size - Fill up fields in onenand_chip
- * 			  boundary[], diesize[], mtd->size
+ * flexonenand_get_size - Fill up fields in onenand_chip and mtd_info
+ * 			  boundary[], diesize[], mtd->size, mtd->erasesize
  * @param mtd		- MTD device structure
  */
 static void flexonenand_get_size(struct mtd_info *mtd)
 {
 	struct onenand_chip *this = mtd->priv;
-	int die, ofs, i, eraseshift, density;
+	int die, i, eraseshift, density;
 	int blksperdie, maxbdry;
+	loff_t ofs;
 
 	density = onenand_get_density(this->device_id);
-	blksperdie = ((16 << density) << 20) >> (this->erase_shift);
+	blksperdie = ((loff_t)(16 << density) << 20) >> (this->erase_shift);
 	blksperdie >>= ONENAND_IS_DDP(this) ? 1 : 0;
 	maxbdry = blksperdie - 1;
 	eraseshift = this->erase_shift - 1;
 
-
 	mtd->numeraseregions = this->dies << 1;
 
 	/* This fills up the device boundary */
@@ -3050,7 +3040,8 @@ static void flexonenand_get_size(struct 
 			mtd->numeraseregions -= 1;
 	}
 
-	mtd->erasesize = 1 << (this->erase_shift);
+	/* Expose MLC erase size except when all blocks are SLC */
+	mtd->erasesize = 1 << this->erase_shift;
 	if (mtd->numeraseregions == 1)
 		mtd->erasesize >>= 1;
 
@@ -3063,8 +3054,8 @@ static void flexonenand_get_size(struct 
 			mtd->eraseregions[i].numblocks);
 
 	for (die = 0, mtd->size = 0; die < this->dies; die++) {
-		this->diesize[die] = (blksperdie << this->erase_shift);
-		this->diesize[die] -= (this->boundary[die] + 1)
+		this->diesize[die] = (loff_t)blksperdie << this->erase_shift;
+		this->diesize[die] -= (loff_t)(this->boundary[die] + 1)
 						 << (this->erase_shift - 1);
 		mtd->size += this->diesize[die];
 	}
@@ -3101,7 +3092,7 @@ static int flexonenand_check_blocks_eras
 	printk(KERN_DEBUG "Check blocks from %d to %d\n", start, end);
 
 	for (block = start; block <= end; block++) {
-		addr = flexonenand_get_addr(this, block);
+		addr = flexonenand_addr(this, block);
 		if (onenand_block_isbad_nolock(mtd, addr, 0))
 			continue;
 
@@ -3128,23 +3119,23 @@ static int flexonenand_check_blocks_eras
 
 /**
  * flexonenand_set_boundary	- Writes the SLC boundary
- * @param onenand_info		- onenand info structure
+ * @param mtd			- mtd info structure
  */
-static int flexonenand_set_boundary(struct mtd_info *mtd, int die,
-						int boundary, int lock)
+int flexonenand_set_boundary(struct mtd_info *mtd, int die,
+				    int boundary, int lock)
 {
 	struct onenand_chip *this = mtd->priv;
-	int ret, density, blksperdie, old, new;
+	int ret, density, blksperdie, old, new, thisboundary;
 	loff_t addr;
 
-	/* boundary value of -1 indicates no required change */
-	if (boundary < 0 || boundary == this->boundary[die])
-		return 0;
-
 	/* Change only once for SDP Flex-OneNAND */
 	if (die && (!ONENAND_IS_DDP(this)))
 		return 0;
 
+	/* boundary value of -1 indicates no required change */
+	if (boundary < 0 || boundary == this->boundary[die])
+		return 0;
+
 	density = onenand_get_density(this->device_id);
 	blksperdie = ((16 << density) << 20) >> this->erase_shift;
 	blksperdie >>= ONENAND_IS_DDP(this) ? 1 : 0;
@@ -3152,7 +3143,7 @@ static int flexonenand_set_boundary(stru
 	if (boundary >= blksperdie) {
 		printk(KERN_ERR "flexonenand_set_boundary: Invalid boundary value. "
 				"Boundary not changed.\n");
-		return -1;
+		return -EINVAL;
 	}
 
 	/* Check if converting blocks are erased */
@@ -3164,6 +3155,20 @@ static int flexonenand_set_boundary(stru
 		return ret;
 	}
 
+	this->command(mtd, FLEXONENAND_CMD_PI_ACCESS, die, 0);
+	this->wait(mtd, FL_SYNCING);
+
+	/* Check is boundary is locked */
+	this->command(mtd, FLEXONENAND_CMD_READ_PI, die, 0);
+	ret = this->wait(mtd, FL_READING);
+
+	thisboundary = this->read_word(this->base + ONENAND_DATARAM);
+	if ((thisboundary >> FLEXONENAND_PI_UNLOCK_SHIFT) != 3) {
+		printk(KERN_ERR "flexonenand_set_boundary: boundary locked\n");
+		ret = 1;
+		goto out;
+	}
+
 	printk(KERN_INFO "flexonenand_set_boundary: Changing die %d boundary: %d%s\n",
 			die, boundary, lock ? "(Locked)" : "(Unlocked)");
 
@@ -3172,9 +3177,6 @@ static int flexonenand_set_boundary(stru
 	boundary &= FLEXONENAND_PI_MASK;
 	boundary |= lock ? 0 : (3 << FLEXONENAND_PI_UNLOCK_SHIFT);
 
-	this->command(mtd, FLEXONENAND_CMD_PI_ACCESS, die, 0);
-	this->wait(mtd, FL_SYNCING);
-
 	this->command(mtd, ONENAND_CMD_ERASE, addr, 0);
 	ret = this->wait(mtd, FL_ERASING);
 	if (ret) {
@@ -3203,6 +3205,25 @@ out:
 }
 
 /**
+ * flexonenand_setup - 	capture Flex-OneNAND boundary and lock
+ * 			values  passed as kernel parameters
+ * @param s	kernel parameter string
+ */
+static int flexonenand_setup(char *s)
+{
+	int ints[5], i;
+
+	s = get_options(s, 5, ints);
+
+	for (i = 0; i < ints[0]; i++)
+		flex_bdry[i] = ints[i + 1];
+
+	return 1;
+}
+
+__setup("onenand.bdry=", flexonenand_setup);
+
+/**
  * onenand_probe - [OneNAND Interface] Probe the OneNAND device
  * @param mtd		MTD device structure
  *
@@ -3265,6 +3286,11 @@ static int onenand_probe(struct mtd_info
 		if (!mtd->eraseregions)
 			return -ENOMEM;
 	}
+
+	/*
+	 * For Flex-OneNAND, chipsize represents maximum possible device size.
+	 * mtd->size represents the actual device size.
+	 */
 	this->chipsize = (16 << density) << 20;
 
 	/* OneNAND page size & block size */
@@ -3277,8 +3303,14 @@ static int onenand_probe(struct mtd_info
 	mtd->oobsize = mtd->writesize >> 5;
 	/* Pages per a block are always 64 in OneNAND */
 	mtd->erasesize = mtd->writesize << 6;
-	/* Flex-OneNAND always has 128 pages per block */
-	mtd->erasesize <<= FLEXONENAND(this) ? 1 : 0;
+	/*
+	 * Flex-OneNAND SLC area has 64 pages per block.
+	 * Flex-OneNAND MLC area has 128 pages per block.
+	 * Expose MLC erase size to find erase_shift and page_mask.
+	 */
+	if (FLEXONENAND(this))
+		mtd->erasesize <<= 1;
+
 	this->erase_shift = ffs(mtd->erasesize) - 1;
 	this->page_shift = ffs(mtd->writesize) - 1;
 	this->page_mask = (1 << (this->erase_shift - this->page_shift)) - 1;
@@ -3484,8 +3516,10 @@ int onenand_scan(struct mtd_info *mtd, i
 		return ret;
 
 	/* Change Flex-OneNAND boundaries if required */
-	flexonenand_set_boundary(mtd, 0, FLEXONENAND_DIE0_BOUNDARY, FLEXONENAND_DIE0_ISLOCKED);
-	flexonenand_set_boundary(mtd, 1, FLEXONENAND_DIE1_BOUNDARY, FLEXONENAND_DIE1_ISLOCKED);
+	for (i = 0; i < MAX_DIES; i++)
+		flexonenand_set_boundary(mtd, i, flex_bdry[2 * i],
+						 flex_bdry[(2 * i) + 1]);
+
 	return 0;
 }
 
diff -puN drivers/mtd/onenand/onenand_bbt.c~flex-onenand-support-v2 drivers/mtd/onenand/onenand_bbt.c
--- a/drivers/mtd/onenand/onenand_bbt.c~flex-onenand-support-v2
+++ a/drivers/mtd/onenand/onenand_bbt.c
@@ -60,10 +60,10 @@ static int create_bbt(struct mtd_info *m
 	struct bbm_info *bbm = this->bbm;
 	int i, j, numblocks, len, scanlen;
 	int startblock;
-	unsigned slc = 0;
 	loff_t from;
 	size_t readlen, ooblen;
 	struct mtd_oob_ops ops;
+	int rgn;
 
 	printk(KERN_INFO "Scanning device for bad blocks\n");
 
@@ -107,10 +107,11 @@ static int create_bbt(struct mtd_info *m
 			}
 		}
 		i += 2;
-		onenand_get_block(this, from, &slc);
-		if (slc)
-			from += (1 << bbm->bbt_erase_shift) >> 1;
-		else
+
+		if (FLEXONENAND(this)) {
+			rgn = flexonenand_region(mtd, from);
+			from += mtd->eraseregions[rgn].erasesize;
+		} else
 			from += (1 << bbm->bbt_erase_shift);
 	}
 
@@ -148,7 +149,7 @@ static int onenand_isbad_bbt(struct mtd_
 	uint8_t res;
 
 	/* Get block number * 2 */
-	block = (int) (onenand_get_block(this, offs, NULL) << 1);
+	block = (int) (onenand_block(this, offs) << 1);
 	res = (bbm->bbt[block >> 3] >> (block & 0x06)) & 0x03;
 
 	DEBUG(MTD_DEBUG_LEVEL2, "onenand_isbad_bbt: bbt info for offs 0x%08x: (block %d) 0x%02x\n",
diff -puN drivers/mtd/onenand/onenand_sim.c~flex-onenand-support-v2 drivers/mtd/onenand/onenand_sim.c
--- a/drivers/mtd/onenand/onenand_sim.c~flex-onenand-support-v2
+++ a/drivers/mtd/onenand/onenand_sim.c
@@ -264,8 +264,9 @@ static void onenand_data_handle(struct o
 	int main_offset, spare_offset, die = 0;
 	void __iomem *src;
 	void __iomem *dest;
-	unsigned int i, slc = 0;
+	unsigned int i;
 	static int pi_operation;
+	int erasesize, rgn;
 
 	if (dataram) {
 		main_offset = mtd->writesize;
@@ -341,14 +342,16 @@ static void onenand_data_handle(struct o
 	case ONENAND_CMD_ERASE:
 		if (pi_operation)
 			break;
-		onenand_get_block(this, offset, &slc);
-		if (slc && (mtd->numeraseregions > 1))
-			mtd->erasesize >>= 1;
-		memset(ONENAND_CORE(flash) + offset, 0xff, mtd->erasesize);
+
+		if (FLEXONENAND(this)) {
+			rgn = flexonenand_region(mtd, offset);
+			erasesize = mtd->eraseregions[rgn].erasesize;
+		} else
+			erasesize = mtd->erasesize;
+
+		memset(ONENAND_CORE(flash) + offset, 0xff, erasesize);
 		memset(ONENAND_CORE_SPARE(flash, this, offset), 0xff,
-		       (mtd->erasesize >> 5));
-		if (slc && (mtd->numeraseregions > 1))
-			mtd->erasesize <<= 1;
+		       (erasesize >> 5));
 		break;
 
 	default:
@@ -401,7 +404,7 @@ static void onenand_command_handle(struc
 	}
 
 	if (block != -1)
-		offset = onenand_get_addr(this, block);
+		offset = onenand_addr(this, block);
 
 	if (page != -1)
 		offset += page << this->page_shift;
diff -puN include/linux/mtd/onenand.h~flex-onenand-support-v2 include/linux/mtd/onenand.h
--- a/include/linux/mtd/onenand.h~flex-onenand-support-v2
+++ a/include/linux/mtd/onenand.h
@@ -20,29 +20,6 @@
 #define MAX_DIES		2
 #define MAX_BUFFERRAM		2
 
-#if defined CONFIG_MTD_FLEXONENAND_DIE0_BOUNDARY
-#define FLEXONENAND_DIE0_BOUNDARY	CONFIG_MTD_FLEXONENAND_DIE0_BOUNDARY
-#else
-#define FLEXONENAND_DIE0_BOUNDARY	-1
-#endif
-
-#if defined CONFIG_MTD_FLEXONENAND_DIE1_BOUNDARY
-#define FLEXONENAND_DIE1_BOUNDARY	CONFIG_MTD_FLEXONENAND_DIE1_BOUNDARY
-#else
-#define FLEXONENAND_DIE1_BOUNDARY	-1
-#endif
-
-#if defined CONFIG_MTD_FLEXONENAND_DIE0_ISLOCKED
-#define FLEXONENAND_DIE0_ISLOCKED	1
-#else
-#define FLEXONENAND_DIE0_ISLOCKED	0
-#endif
-#if defined CONFIG_MTD_FLEXONENAND_DIE1_ISLOCKED
-#define FLEXONENAND_DIE1_ISLOCKED	1
-#else
-#define FLEXONENAND_DIE1_ISLOCKED	0
-#endif
-
 /* Scan and identify a OneNAND device */
 extern int onenand_scan(struct mtd_info *mtd, int max_chips);
 /* Free resources held by the OneNAND device */
@@ -123,7 +100,7 @@ struct onenand_chip {
 	void __iomem		*base;
 	unsigned		dies;
 	unsigned		boundary[MAX_DIES];
-	unsigned int		diesize[MAX_DIES];
+	loff_t			diesize[MAX_DIES];
 	unsigned int		chipsize;
 	unsigned int		device_id;
 	unsigned int		version_id;
@@ -227,8 +204,8 @@ struct onenand_manufacturers {
 
 int onenand_bbt_read_oob(struct mtd_info *mtd, loff_t from,
 			 struct mtd_oob_ops *ops);
-unsigned onenand_get_block(struct onenand_chip *this, loff_t addr,
-			 unsigned *isblkslc);
-loff_t onenand_get_addr(struct onenand_chip *this, int block);
+unsigned onenand_block(struct onenand_chip *this, loff_t addr);
+loff_t onenand_addr(struct onenand_chip *this, int block);
+int flexonenand_region(struct mtd_info *mtd, loff_t addr);
 
 #endif	/* __LINUX_MTD_ONENAND_H */
_

Patches currently in -mm which might be from h.rohit@samsung.com are

mtd-flex-onenand-support.patch
flex-onenand-support-v2.patch
mtd-flex-onenand-support-fix.patch

