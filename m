From: akpm@linux-foundation.org
Subject: - mtd-nand-fix-possible-ooops-in-rfc_from4.patch removed from -mm tree
Date: Sat, 26 Apr 2008 09:41:23 -0700
Message-ID: <200804261641.m3QGfNF6031121@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38481 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758400AbYDZQth (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Apr 2008 12:49:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bigeasy@tglx.de, bigeasy@linutronix.de, dwmw2@infradead.org, joern@wohnheim.fh-wedel.de, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     mtd: nand: fix possible Ooops in rfc_from4
has been removed from the -mm tree.  Its filename was
     mtd-nand-fix-possible-ooops-in-rfc_from4.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd: nand: fix possible Ooops in rfc_from4
From: Sebastian Siewior <bigeasy@tglx.de>

I found this while I was looking how the rs_lib is working.  The rs_decoder is
initialized _after_ the nand core code read the BBT table and _after_ the
partition table has been added.  The driver has a private BBT description
which is in located in flash data so we Ooops if there is a bit flip _or_ if a
bit flips while reading the partition table.

This patch moves the initialization of the rs_lib before the first possible
access by nand core.

Signed-off-by: Sebastian Siewior <bigeasy@linutronix.de>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Joern Engel <joern@wh.fh-wedel.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/rtc_from4.c |   50 +++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 21 deletions(-)

diff -puN drivers/mtd/nand/rtc_from4.c~mtd-nand-fix-possible-ooops-in-rfc_from4 drivers/mtd/nand/rtc_from4.c
--- a/drivers/mtd/nand/rtc_from4.c~mtd-nand-fix-possible-ooops-in-rfc_from4
+++ a/drivers/mtd/nand/rtc_from4.c
@@ -478,6 +478,7 @@ static int __init rtc_from4_init(void)
 	struct nand_chip *this;
 	unsigned short bcr1, bcr2, wcr2;
 	int i;
+	int ret;
 
 	/* Allocate memory for MTD device structure and private data */
 	rtc_from4_mtd = kmalloc(sizeof(struct mtd_info) + sizeof(struct nand_chip), GFP_KERNEL);
@@ -537,6 +538,22 @@ static int __init rtc_from4_init(void)
 	this->ecc.hwctl = rtc_from4_enable_hwecc;
 	this->ecc.calculate = rtc_from4_calculate_ecc;
 	this->ecc.correct = rtc_from4_correct_data;
+
+	/* We could create the decoder on demand, if memory is a concern.
+	 * This way we have it handy, if an error happens
+	 *
+	 * Symbolsize is 10 (bits)
+	 * Primitve polynomial is x^10+x^3+1
+	 * first consecutive root is 0
+	 * primitve element to generate roots = 1
+	 * generator polinomial degree = 6
+	 */
+	rs_decoder = init_rs(10, 0x409, 0, 1, 6);
+	if (!rs_decoder) {
+		printk(KERN_ERR "Could not create a RS decoder\n");
+		ret = -ENOMEM;
+		goto err_1;
+	}
 #else
 	printk(KERN_INFO "rtc_from4_init: using software ECC detection.\n");
 
@@ -549,8 +566,8 @@ static int __init rtc_from4_init(void)
 
 	/* Scan to find existence of the device */
 	if (nand_scan(rtc_from4_mtd, RTC_FROM4_MAX_CHIPS)) {
-		kfree(rtc_from4_mtd);
-		return -ENXIO;
+		ret = -ENXIO;
+		goto err_2;
 	}
 
 	/* Perform 'device recovery' for each chip in case there was a power loss. */
@@ -566,28 +583,19 @@ static int __init rtc_from4_init(void)
 #endif
 
 	/* Register the partitions */
-	add_mtd_partitions(rtc_from4_mtd, partition_info, NUM_PARTITIONS);
+	ret = add_mtd_partitions(rtc_from4_mtd, partition_info, NUM_PARTITIONS);
+	if (ret)
+		goto err_3;
 
-#ifdef RTC_FROM4_HWECC
-	/* We could create the decoder on demand, if memory is a concern.
-	 * This way we have it handy, if an error happens
-	 *
-	 * Symbolsize is 10 (bits)
-	 * Primitve polynomial is x^10+x^3+1
-	 * first consecutive root is 0
-	 * primitve element to generate roots = 1
-	 * generator polinomial degree = 6
-	 */
-	rs_decoder = init_rs(10, 0x409, 0, 1, 6);
-	if (!rs_decoder) {
-		printk(KERN_ERR "Could not create a RS decoder\n");
-		nand_release(rtc_from4_mtd);
-		kfree(rtc_from4_mtd);
-		return -ENOMEM;
-	}
-#endif
 	/* Return happy */
 	return 0;
+err_3:
+	nand_release(rtc_from4_mtd);
+err_2:
+	free_rs(rs_decoder);
+err_1:
+	kfree(rtc_from4_mtd);
+	return ret;
 }
 
 module_init(rtc_from4_init);
_

Patches currently in -mm which might be from bigeasy@tglx.de are

origin.patch

