From: akpm@osdl.org
Subject: - ide-optimize-hpt37x-timing-tables.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:18:38 -0800
Message-ID: <200612140618.kBE6Ib56002350@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52982 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982AbWLNGWO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:22:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sshtylyov@ru.mvista.com, B.Zolnierkiewicz@elka.pw.edu.pl, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     ide: optimize HPT37x timing tables
has been removed from the -mm tree.  Its filename was
     ide-optimize-hpt37x-timing-tables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ide: optimize HPT37x timing tables
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

Save some space on the timing tables by introducing the separate transfer mode
table in which the mode lookup is done to get the index into the timing table
itself.  Get rid of the rest of the obsolete/duplicate tables and use one set
of tables for the whole HPT37x chip family like the HighPoint open-source
drivers do.  Documnent the different timing register layout for the HPT36x
chip family (this is my guesswork based on the timing values).

Have been tested and works fine on HPT370/302/371N.

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Bartlomiej Zolnierkiewicz <B.Zolnierkiewicz@elka.pw.edu.pl>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ide/pci/hpt366.c |  404 +++++++++++++++----------------------
 1 file changed, 174 insertions(+), 230 deletions(-)

diff -puN drivers/ide/pci/hpt366.c~ide-optimize-hpt37x-timing-tables drivers/ide/pci/hpt366.c
--- a/drivers/ide/pci/hpt366.c~ide-optimize-hpt37x-timing-tables
+++ a/drivers/ide/pci/hpt366.c
@@ -67,10 +67,9 @@
  * - add support for HPT302N and HPT371N clocking (the same as for HPT372N)
  * - HPT371/N are single channel chips, so avoid touching the primary channel
  *   which exists only virtually (there's no pins for it)
- * - fix/remove bad/unused timing tables: HPT370/A  66 MHz tables weren't really
- *   needed and had many modes over- and  underclocked,  HPT372 33 MHz table was
- *   for 66 MHz and 50 MHz table missed UltraDMA mode 6, HPT374 33 MHz table was
- *   really for 50 MHz; switch to using HPT372 tables for HPT374...
+ * - fix/remove bad/unused timing tables and use one set of tables for the whole
+ *   HPT37x chip family; save space by introducing the separate transfer mode
+ *   table in which the mode lookup is done
  *		<source@mvista.com>
  *
  */
@@ -162,214 +161,168 @@ static const char *bad_ata33[] = {
 	NULL
 };
 
-struct chipset_bus_clock_list_entry {
-	u8		xfer_speed;
-	unsigned int	chipset_settings;
+static u8 xfer_speeds[] = {
+	XFER_UDMA_6,
+	XFER_UDMA_5,
+	XFER_UDMA_4,
+	XFER_UDMA_3,
+	XFER_UDMA_2,
+	XFER_UDMA_1,
+	XFER_UDMA_0,
+
+	XFER_MW_DMA_2,
+	XFER_MW_DMA_1,
+	XFER_MW_DMA_0,
+
+	XFER_PIO_4,
+	XFER_PIO_3,
+	XFER_PIO_2,
+	XFER_PIO_1,
+	XFER_PIO_0
 };
 
-/* key for bus clock timings
- * bit
- * 0:3    data_high_time. inactive time of DIOW_/DIOR_ for PIO and MW
- *        DMA. cycles = value + 1
- * 4:8    data_low_time. active time of DIOW_/DIOR_ for PIO and MW
- *        DMA. cycles = value + 1
- * 9:12   cmd_high_time. inactive time of DIOW_/DIOR_ during task file
- *        register access.
- * 13:17  cmd_low_time. active time of DIOW_/DIOR_ during task file
- *        register access.
- * 18:21  udma_cycle_time. clock freq and clock cycles for UDMA xfer.
- *        during task file register access.
- * 22:24  pre_high_time. time to initialize 1st cycle for PIO and MW DMA
- *        xfer.
- * 25:27  cmd_pre_high_time. time to initialize 1st PIO cycle for task
- *        register access.
- * 28     UDMA enable
- * 29     DMA enable
- * 30     PIO_MST enable. if set, the chip is in bus master mode during
- *        PIO.
- * 31     FIFO enable.
+/* Key for bus clock timings
+ * 36x   37x
+ * bits  bits
+ * 0:3	 0:3	data_high_time. Inactive time of DIOW_/DIOR_ for PIO and MW DMA.
+ *		cycles = value + 1
+ * 4:7	 4:8	data_low_time. Active time of DIOW_/DIOR_ for PIO and MW DMA.
+ *		cycles = value + 1
+ * 8:11  9:12	cmd_high_time. Inactive time of DIOW_/DIOR_ during task file
+ *		register access.
+ * 12:15 13:17	cmd_low_time. Active time of DIOW_/DIOR_ during task file
+ *		register access.
+ * 16:18 18:20	udma_cycle_time. Clock cycles for UDMA xfer.
+ * -	 21	CLK frequency: 0=ATA clock, 1=dual ATA clock.
+ * 19:21 22:24	pre_high_time. Time to initialize the 1st cycle for PIO and
+ *		MW DMA xfer.
+ * 22:24 25:27	cmd_pre_high_time. Time to initialize the 1st PIO cycle for
+ *		task file register access.
+ * 28	 28	UDMA enable.
+ * 29	 29	DMA  enable.
+ * 30	 30	PIO MST enable. If set, the chip is in bus master mode during
+ *		PIO xfer.
+ * 31	 31	FIFO enable.
  */
-static struct chipset_bus_clock_list_entry forty_base_hpt366[] = {
-	{	XFER_UDMA_4,	0x900fd943	},
-	{	XFER_UDMA_3,	0x900ad943	},
-	{	XFER_UDMA_2,	0x900bd943	},
-	{	XFER_UDMA_1,	0x9008d943	},
-	{	XFER_UDMA_0,	0x9008d943	},
-
-	{	XFER_MW_DMA_2,	0xa008d943	},
-	{	XFER_MW_DMA_1,	0xa010d955	},
-	{	XFER_MW_DMA_0,	0xa010d9fc	},
-
-	{	XFER_PIO_4,	0xc008d963	},
-	{	XFER_PIO_3,	0xc010d974	},
-	{	XFER_PIO_2,	0xc010d997	},
-	{	XFER_PIO_1,	0xc010d9c7	},
-	{	XFER_PIO_0,	0xc018d9d9	},
-	{	0,		0x0120d9d9	}
-};
-
-static struct chipset_bus_clock_list_entry thirty_three_base_hpt366[] = {
-	{	XFER_UDMA_4,	0x90c9a731	},
-	{	XFER_UDMA_3,	0x90cfa731	},
-	{	XFER_UDMA_2,	0x90caa731	},
-	{	XFER_UDMA_1,	0x90cba731	},
-	{	XFER_UDMA_0,	0x90c8a731	},
-
-	{	XFER_MW_DMA_2,	0xa0c8a731	},
-	{	XFER_MW_DMA_1,	0xa0c8a732	},	/* 0xa0c8a733 */
-	{	XFER_MW_DMA_0,	0xa0c8a797	},
-
-	{	XFER_PIO_4,	0xc0c8a731	},
-	{	XFER_PIO_3,	0xc0c8a742	},
-	{	XFER_PIO_2,	0xc0d0a753	},
-	{	XFER_PIO_1,	0xc0d0a7a3	},	/* 0xc0d0a793 */
-	{	XFER_PIO_0,	0xc0d0a7aa	},	/* 0xc0d0a7a7 */
-	{	0,		0x0120a7a7	}
-};
 
-static struct chipset_bus_clock_list_entry twenty_five_base_hpt366[] = {
-	{	XFER_UDMA_4,	0x90c98521	},
-	{	XFER_UDMA_3,	0x90cf8521	},
-	{	XFER_UDMA_2,	0x90cf8521	},
-	{	XFER_UDMA_1,	0x90cb8521	},
-	{	XFER_UDMA_0,	0x90cb8521	},
-
-	{	XFER_MW_DMA_2,	0xa0ca8521	},
-	{	XFER_MW_DMA_1,	0xa0ca8532	},
-	{	XFER_MW_DMA_0,	0xa0ca8575	},
-
-	{	XFER_PIO_4,	0xc0ca8521	},
-	{	XFER_PIO_3,	0xc0ca8532	},
-	{	XFER_PIO_2,	0xc0ca8542	},
-	{	XFER_PIO_1,	0xc0d08572	},
-	{	XFER_PIO_0,	0xc0d08585	},
-	{	0,		0x01208585	}
+static u32 forty_base_hpt36x[] = {
+	/* XFER_UDMA_6 */	0x900fd943,
+	/* XFER_UDMA_5 */	0x900fd943,
+	/* XFER_UDMA_4 */	0x900fd943,
+	/* XFER_UDMA_3 */	0x900ad943,
+	/* XFER_UDMA_2 */	0x900bd943,
+	/* XFER_UDMA_1 */	0x9008d943,
+	/* XFER_UDMA_0 */	0x9008d943,
+
+	/* XFER_MW_DMA_2 */	0xa008d943,
+	/* XFER_MW_DMA_1 */	0xa010d955,
+	/* XFER_MW_DMA_0 */	0xa010d9fc,
+
+	/* XFER_PIO_4 */	0xc008d963,
+	/* XFER_PIO_3 */	0xc010d974,
+	/* XFER_PIO_2 */	0xc010d997,
+	/* XFER_PIO_1 */	0xc010d9c7,
+	/* XFER_PIO_0 */	0xc018d9d9
 };
 
-/* from highpoint documentation. these are old values */
-static struct chipset_bus_clock_list_entry thirty_three_base_hpt370[] = {
-/*	{	XFER_UDMA_5,	0x1A85F442,	0x16454e31	}, */
-	{	XFER_UDMA_5,	0x16454e31	},
-	{	XFER_UDMA_4,	0x16454e31	},
-	{	XFER_UDMA_3,	0x166d4e31	},
-	{	XFER_UDMA_2,	0x16494e31	},
-	{	XFER_UDMA_1,	0x164d4e31	},
-	{	XFER_UDMA_0,	0x16514e31	},
-
-	{	XFER_MW_DMA_2,	0x26514e21	},
-	{	XFER_MW_DMA_1,	0x26514e33	},
-	{	XFER_MW_DMA_0,	0x26514e97	},
-
-	{	XFER_PIO_4,	0x06514e21	},
-	{	XFER_PIO_3,	0x06514e22	},
-	{	XFER_PIO_2,	0x06514e33	},
-	{	XFER_PIO_1,	0x06914e43	},
-	{	XFER_PIO_0,	0x06914e57	},
-	{	0,		0x06514e57	}
+static u32 thirty_three_base_hpt36x[] = {
+	/* XFER_UDMA_6 */	0x90c9a731,
+	/* XFER_UDMA_5 */	0x90c9a731,
+	/* XFER_UDMA_4 */	0x90c9a731,
+	/* XFER_UDMA_3 */	0x90cfa731,
+	/* XFER_UDMA_2 */	0x90caa731,
+	/* XFER_UDMA_1 */	0x90cba731,
+	/* XFER_UDMA_0 */	0x90c8a731,
+
+	/* XFER_MW_DMA_2 */	0xa0c8a731,
+	/* XFER_MW_DMA_1 */	0xa0c8a732,	/* 0xa0c8a733 */
+	/* XFER_MW_DMA_0 */	0xa0c8a797,
+
+	/* XFER_PIO_4 */	0xc0c8a731,
+	/* XFER_PIO_3 */	0xc0c8a742,
+	/* XFER_PIO_2 */	0xc0d0a753,
+	/* XFER_PIO_1 */	0xc0d0a7a3,	/* 0xc0d0a793 */
+	/* XFER_PIO_0 */	0xc0d0a7aa	/* 0xc0d0a7a7 */
 };
 
-/* these are the current (4 sep 2001) timings from highpoint */
-static struct chipset_bus_clock_list_entry thirty_three_base_hpt370a[] = {
-	{	XFER_UDMA_5,	0x12446231	},
-	{	XFER_UDMA_4,	0x12446231	},
-	{	XFER_UDMA_3,	0x126c6231	},
-	{	XFER_UDMA_2,	0x12486231	},
-	{	XFER_UDMA_1,	0x124c6233	},
-	{	XFER_UDMA_0,	0x12506297	},
-
-	{	XFER_MW_DMA_2,	0x22406c31	},
-	{	XFER_MW_DMA_1,	0x22406c33	},
-	{	XFER_MW_DMA_0,	0x22406c97	},
-
-	{	XFER_PIO_4,	0x06414e31	},
-	{	XFER_PIO_3,	0x06414e42	},
-	{	XFER_PIO_2,	0x06414e53	},
-	{	XFER_PIO_1,	0x06814e93	},
-	{	XFER_PIO_0,	0x06814ea7	},
-	{	0,		0x06814ea7	}
+static u32 twenty_five_base_hpt36x[] = {
+	/* XFER_UDMA_6 */	0x90c98521,
+	/* XFER_UDMA_5 */	0x90c98521,
+	/* XFER_UDMA_4 */	0x90c98521,
+	/* XFER_UDMA_3 */	0x90cf8521,
+	/* XFER_UDMA_2 */	0x90cf8521,
+	/* XFER_UDMA_1 */	0x90cb8521,
+	/* XFER_UDMA_0 */	0x90cb8521,
+
+	/* XFER_MW_DMA_2 */	0xa0ca8521,
+	/* XFER_MW_DMA_1 */	0xa0ca8532,
+	/* XFER_MW_DMA_0 */	0xa0ca8575,
+
+	/* XFER_PIO_4 */	0xc0ca8521,
+	/* XFER_PIO_3 */	0xc0ca8532,
+	/* XFER_PIO_2 */	0xc0ca8542,
+	/* XFER_PIO_1 */	0xc0d08572,
+	/* XFER_PIO_0 */	0xc0d08585
 };
 
-static struct chipset_bus_clock_list_entry fifty_base_hpt370a[] = {
-	{	XFER_UDMA_5,	0x12848242	},
-	{	XFER_UDMA_4,	0x12ac8242	},
-	{	XFER_UDMA_3,	0x128c8242	},
-	{	XFER_UDMA_2,	0x120c8242	},
-	{	XFER_UDMA_1,	0x12148254	},
-	{	XFER_UDMA_0,	0x121882ea	},
-
-	{	XFER_MW_DMA_2,	0x22808242	},
-	{	XFER_MW_DMA_1,	0x22808254	},
-	{	XFER_MW_DMA_0,	0x228082ea	},
-
-	{	XFER_PIO_4,	0x0a81f442	},
-	{	XFER_PIO_3,	0x0a81f443	},
-	{	XFER_PIO_2,	0x0a81f454	},
-	{	XFER_PIO_1,	0x0ac1f465	},
-	{	XFER_PIO_0,	0x0ac1f48a	},
-	{	0,		0x0ac1f48a	}
+static u32 thirty_three_base_hpt37x[] = {
+	/* XFER_UDMA_6 */	0x12446231,	/* 0x12646231 ?? */
+	/* XFER_UDMA_5 */	0x12446231,
+	/* XFER_UDMA_4 */	0x12446231,
+	/* XFER_UDMA_3 */	0x126c6231,
+	/* XFER_UDMA_2 */	0x12486231,
+	/* XFER_UDMA_1 */	0x124c6233,
+	/* XFER_UDMA_0 */	0x12506297,
+
+	/* XFER_MW_DMA_2 */	0x22406c31,
+	/* XFER_MW_DMA_1 */	0x22406c33,
+	/* XFER_MW_DMA_0 */	0x22406c97,
+
+	/* XFER_PIO_4 */	0x06414e31,
+	/* XFER_PIO_3 */	0x06414e42,
+	/* XFER_PIO_2 */	0x06414e53,
+	/* XFER_PIO_1 */	0x06814e93,
+	/* XFER_PIO_0 */	0x06814ea7
 };
 
-static struct chipset_bus_clock_list_entry thirty_three_base_hpt372[] = {
-	{	XFER_UDMA_6,	0x12446231	},	/* 0x12646231 ?? */
-	{	XFER_UDMA_5,	0x12446231	},
-	{	XFER_UDMA_4,	0x12446231	},
-	{	XFER_UDMA_3,	0x126c6231	},
-	{	XFER_UDMA_2,	0x12486231	},
-	{	XFER_UDMA_1,	0x124c6233	},
-	{	XFER_UDMA_0,	0x12506297	},
-
-	{	XFER_MW_DMA_2,	0x22406c31	},
-	{	XFER_MW_DMA_1,	0x22406c33	},
-	{	XFER_MW_DMA_0,	0x22406c97	},
-
-	{	XFER_PIO_4,	0x06414e31	},
-	{	XFER_PIO_3,	0x06414e42	},
-	{	XFER_PIO_2,	0x06414e53	},
-	{	XFER_PIO_1,	0x06814e93	},
-	{	XFER_PIO_0,	0x06814ea7	},
-	{	0,		0x06814ea7	}
+static u32 fifty_base_hpt37x[] = {
+	/* XFER_UDMA_6 */	0x12848242,
+	/* XFER_UDMA_5 */	0x12848242,
+	/* XFER_UDMA_4 */	0x12ac8242,
+	/* XFER_UDMA_3 */	0x128c8242,
+	/* XFER_UDMA_2 */	0x120c8242,
+	/* XFER_UDMA_1 */	0x12148254,
+	/* XFER_UDMA_0 */	0x121882ea,
+
+	/* XFER_MW_DMA_2 */	0x22808242,
+	/* XFER_MW_DMA_1 */	0x22808254,
+	/* XFER_MW_DMA_0 */	0x228082ea,
+
+	/* XFER_PIO_4 */	0x0a81f442,
+	/* XFER_PIO_3 */	0x0a81f443,
+	/* XFER_PIO_2 */	0x0a81f454,
+	/* XFER_PIO_1 */	0x0ac1f465,
+	/* XFER_PIO_0 */	0x0ac1f48a
 };
 
-static struct chipset_bus_clock_list_entry fifty_base_hpt372[] = {
-	{	XFER_UDMA_6,	0x12848242	},
-	{	XFER_UDMA_5,	0x12848242	},
-	{	XFER_UDMA_4,	0x12ac8242	},
-	{	XFER_UDMA_3,	0x128c8242	},
-	{	XFER_UDMA_2,	0x120c8242	},
-	{	XFER_UDMA_1,	0x12148254	},
-	{	XFER_UDMA_0,	0x121882ea	},
-
-	{	XFER_MW_DMA_2,	0x22808242	},
-	{	XFER_MW_DMA_1,	0x22808254	},
-	{	XFER_MW_DMA_0,	0x228082ea	},
-
-	{	XFER_PIO_4,	0x0a81f442	},
-	{	XFER_PIO_3,	0x0a81f443	},
-	{	XFER_PIO_2,	0x0a81f454	},
-	{	XFER_PIO_1,	0x0ac1f465	},
-	{	XFER_PIO_0,	0x0ac1f48a	},
-	{	0,		0x0a81f443	}
-};
-
-static struct chipset_bus_clock_list_entry sixty_six_base_hpt372[] = {
-	{	XFER_UDMA_6,	0x1c869c62	},
-	{	XFER_UDMA_5,	0x1cae9c62	},	/* 0x1c8a9c62 */
-	{	XFER_UDMA_4,	0x1c8a9c62	},
-	{	XFER_UDMA_3,	0x1c8e9c62	},
-	{	XFER_UDMA_2,	0x1c929c62	},
-	{	XFER_UDMA_1,	0x1c9a9c62	},
-	{	XFER_UDMA_0,	0x1c829c62	},
-
-	{	XFER_MW_DMA_2,	0x2c829c62	},
-	{	XFER_MW_DMA_1,	0x2c829c66	},
-	{	XFER_MW_DMA_0,	0x2c829d2e	},
-
-	{	XFER_PIO_4,	0x0c829c62	},
-	{	XFER_PIO_3,	0x0c829c84	},
-	{	XFER_PIO_2,	0x0c829ca6	},
-	{	XFER_PIO_1,	0x0d029d26	},
-	{	XFER_PIO_0,	0x0d029d5e	},
-	{	0,		0x0d029d26	}
+static u32 sixty_six_base_hpt37x[] = {
+	/* XFER_UDMA_6 */	0x1c869c62,
+	/* XFER_UDMA_5 */	0x1cae9c62,	/* 0x1c8a9c62 */
+	/* XFER_UDMA_4 */	0x1c8a9c62,
+	/* XFER_UDMA_3 */	0x1c8e9c62,
+	/* XFER_UDMA_2 */	0x1c929c62,
+	/* XFER_UDMA_1 */	0x1c9a9c62,
+	/* XFER_UDMA_0 */	0x1c829c62,
+
+	/* XFER_MW_DMA_2 */	0x2c829c62,
+	/* XFER_MW_DMA_1 */	0x2c829c66,
+	/* XFER_MW_DMA_0 */	0x2c829d2e,
+
+	/* XFER_PIO_4 */	0x0c829c62,
+	/* XFER_PIO_3 */	0x0c829c84,
+	/* XFER_PIO_2 */	0x0c829ca6,
+	/* XFER_PIO_1 */	0x0d029d26,
+	/* XFER_PIO_0 */	0x0d029d5e
 };
 
 #define HPT366_DEBUG_DRIVE_INFO		0
@@ -401,7 +354,7 @@ struct hpt_info
 #define IS_3xxN 	2
 #define PCI_66MHZ	4
 				/* Speed table */
-	struct chipset_bus_clock_list_entry *speed;
+	u32 *speed;
 };
 
 /*
@@ -538,12 +491,20 @@ static int check_in_drive_lists (ide_dri
 	return 0;
 }
 
-static unsigned int pci_bus_clock_list (u8 speed, struct chipset_bus_clock_list_entry * chipset_table)
+static u32 pci_bus_clock_list(u8 speed, u32 *chipset_table)
 {
-	for ( ; chipset_table->xfer_speed ; chipset_table++)
-		if (chipset_table->xfer_speed == speed)
-			return chipset_table->chipset_settings;
-	return chipset_table->chipset_settings;
+	int i;
+
+	/*
+	 * Lookup the transfer mode table to get the index into
+	 * the timing table.
+	 *
+	 * NOTE: For XFER_PIO_SLOW, PIO mode 0 timings will be used.
+	 */
+	for (i = 0; i < ARRAY_SIZE(xfer_speeds) - 1; i++)
+		if (xfer_speeds[i] == speed)
+			break;
+	return chipset_table[i];
 }
 
 static int hpt36x_tune_chipset(ide_drive_t *drive, u8 xferspeed)
@@ -1061,14 +1022,14 @@ static void __devinit hpt366_clocking(id
 	/* detect bus speed by looking at control reg timing: */
 	switch((reg1 >> 8) & 7) {
 		case 5:
-			info->speed = forty_base_hpt366;
+			info->speed = forty_base_hpt36x;
 			break;
 		case 9:
-			info->speed = twenty_five_base_hpt366;
+			info->speed = twenty_five_base_hpt36x;
 			break;
 		case 7:
 		default:
-			info->speed = thirty_three_base_hpt366;
+			info->speed = thirty_three_base_hpt36x;
 			break;
 	}
 }
@@ -1131,27 +1092,16 @@ static void __devinit hpt37x_clocking(id
 			pll = F_LOW_PCI_66;
 	
 		if (pll == F_LOW_PCI_33) {
-			if (info->revision >= 5)
-				info->speed = thirty_three_base_hpt372;
-			else if (info->revision >= 4)
-				info->speed = thirty_three_base_hpt370a;
-			else
-				info->speed = thirty_three_base_hpt370;
+			info->speed = thirty_three_base_hpt37x;
 			printk(KERN_DEBUG "HPT37X: using 33MHz PCI clock\n");
 		} else if (pll == F_LOW_PCI_40) {
 			/* Unsupported */
 		} else if (pll == F_LOW_PCI_50) {
-			if (info->revision >= 5)
-				info->speed = fifty_base_hpt372;
-			else
-				info->speed = fifty_base_hpt370a;
+			info->speed = fifty_base_hpt37x;
 			printk(KERN_DEBUG "HPT37X: using 50MHz PCI clock\n");
 		} else {
-			if (info->revision >= 5) {
-				info->speed = sixty_six_base_hpt372;
-				printk(KERN_DEBUG "HPT37X: using 66MHz PCI clock\n");
-			} else
-				printk(KERN_ERR "HPT37x: 66MHz timings not supported.\n");
+			info->speed = sixty_six_base_hpt37x;
+			printk(KERN_DEBUG "HPT37X: using 66MHz PCI clock\n");
 		}
 	}
 
@@ -1201,14 +1151,8 @@ static void __devinit hpt37x_clocking(id
 				pci_write_config_dword(dev, 0x5c, 
 						       pll & ~0x100);
 				pci_write_config_byte(dev, 0x5b, 0x21);
-				if (info->revision >= 8)
-					info->speed = fifty_base_hpt370a;
-				else if (info->revision >= 5)
-					info->speed = fifty_base_hpt372;
-				else if (info->revision >= 4)
-					info->speed = fifty_base_hpt370a;
-				else
-					info->speed = fifty_base_hpt370a;
+
+				info->speed = fifty_base_hpt37x;
 				printk("HPT37X: using 50MHz internal PLL\n");
 				goto init_hpt37X_done;
 			}
_

Patches currently in -mm which might be from sshtylyov@ru.mvista.com are

git-mtd.patch
3x59x-fix-pci-resource-management.patch
toshiba-tc86c001-ide-driver-take-2.patch
hpt3xx-rework-rate-filtering.patch
hpt3xx-rework-rate-filtering-tidy.patch
hpt3xx-print-the-real-chip-name-at-startup.patch
hpt3xx-switch-to-using-pci_get_slot.patch
hpt3xx-cache-channels-mcr-address.patch
hpt3x7-merge-speedproc-handlers.patch
hpt370-clean-up-dma-timeout-handling.patch
hpt3xx-init-code-rewrite.patch
piix-fix-82371mx-enablebits.patch
piix-remove-check-for-broken-mw-dma-mode-0.patch
piix-slc90e66-pio-mode-fallback-fix.patch
pdc202xx_new-remove-useless-code.patch
pdc202xx_-remove-check_in_drive_lists-abomination.patch

