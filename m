From: akpm@linux-foundation.org
Subject: - memstick-fix-msprohg-8-bit-interface-mode-support.patch removed from -mm tree
Date: Thu, 18 Sep 2008 13:56:25 -0700
Message-ID: <200809182056.m8IKuPwj019189@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44686 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754751AbYIRU42 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Sep 2008 16:56:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oakad@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     memstick: fix MSProHG 8-bit interface mode support
has been removed from the -mm tree.  Its filename was
     memstick-fix-msprohg-8-bit-interface-mode-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memstick: fix MSProHG 8-bit interface mode support
From: Alex Dubov <oakad@yahoo.com>

- 8-bit interface mode never worked properly.  The only adapter I have
  which supports the 8b mode (the Jmicron) had some problems with its
  clock wiring and they discovered it only now.  We also discovered that
  ProHG media is more sensitive to the ordering of initialization
  commands.

- Make the driver fall back to highest supported mode instead of always
  falling back to serial.  The driver will attempt the switch to 8b mode
  for any new MSPro card, but not all of them support it.  Previously,
  these new cards ended up in serial mode, which is not the best idea
  (they work fine with 4b, after all).

- Edit some macros for better conformance to Sony documentation

Signed-off-by: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/memstick.c    |   10 +-
 drivers/memstick/core/mspro_block.c |   33 ++++++--
 drivers/memstick/host/jmb38x_ms.c   |   39 +++++++---
 include/linux/memstick.h            |   97 +++++++++++++-------------
 4 files changed, 106 insertions(+), 73 deletions(-)

diff -puN drivers/memstick/core/memstick.c~memstick-fix-msprohg-8-bit-interface-mode-support drivers/memstick/core/memstick.c
--- a/drivers/memstick/core/memstick.c~memstick-fix-msprohg-8-bit-interface-mode-support
+++ a/drivers/memstick/core/memstick.c
@@ -185,7 +185,7 @@ static void memstick_free(struct device 
 }
 
 static struct class memstick_host_class = {
-	.name       = "memstick_host",
+	.name        = "memstick_host",
 	.dev_release = memstick_free
 };
 
@@ -264,7 +264,7 @@ EXPORT_SYMBOL(memstick_new_req);
  * @sg - TPC argument
  */
 void memstick_init_req_sg(struct memstick_request *mrq, unsigned char tpc,
-			  struct scatterlist *sg)
+			  const struct scatterlist *sg)
 {
 	mrq->tpc = tpc;
 	if (tpc & 8)
@@ -294,7 +294,7 @@ EXPORT_SYMBOL(memstick_init_req_sg);
  * user supplied buffer.
  */
 void memstick_init_req(struct memstick_request *mrq, unsigned char tpc,
-		       void *buf, size_t length)
+		       const void *buf, size_t length)
 {
 	mrq->tpc = tpc;
 	if (tpc & 8)
@@ -439,7 +439,7 @@ static void memstick_check(struct work_s
 	if (!host->card) {
 		if (memstick_power_on(host))
 			goto out_power_off;
-	} else
+	} else if (host->card->stop)
 		host->card->stop(host->card);
 
 	card = memstick_alloc_card(host);
@@ -458,7 +458,7 @@ static void memstick_check(struct work_s
 			    || !(host->card->check(host->card))) {
 				device_unregister(&host->card->dev);
 				host->card = NULL;
-			} else
+			} else if (host->card->start)
 				host->card->start(host->card);
 		}
 
diff -puN drivers/memstick/core/mspro_block.c~memstick-fix-msprohg-8-bit-interface-mode-support drivers/memstick/core/mspro_block.c
--- a/drivers/memstick/core/mspro_block.c~memstick-fix-msprohg-8-bit-interface-mode-support
+++ a/drivers/memstick/core/mspro_block.c
@@ -30,6 +30,8 @@ module_param(major, int, 0644);
 #define MSPRO_BLOCK_SIGNATURE        0xa5c3
 #define MSPRO_BLOCK_MAX_ATTRIBUTES   41
 
+#define MSPRO_BLOCK_PART_SHIFT 3
+
 enum {
 	MSPRO_BLOCK_ID_SYSINFO         = 0x10,
 	MSPRO_BLOCK_ID_MODELNAME       = 0x15,
@@ -195,7 +197,7 @@ static int mspro_block_bd_open(struct in
 static int mspro_block_disk_release(struct gendisk *disk)
 {
 	struct mspro_block_data *msb = disk->private_data;
-	int disk_id = disk->first_minor >> MEMSTICK_PART_SHIFT;
+	int disk_id = disk->first_minor >> MSPRO_BLOCK_PART_SHIFT;
 
 	mutex_lock(&mspro_block_disk_lock);
 
@@ -877,6 +879,7 @@ static int mspro_block_switch_interface(
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
 	int rc = 0;
 
+try_again:
 	if (msb->caps & MEMSTICK_CAP_PAR4)
 		rc = mspro_block_set_interface(card, MEMSTICK_SYS_PAR4);
 	else
@@ -930,6 +933,18 @@ static int mspro_block_switch_interface(
 		rc = memstick_set_rw_addr(card);
 		if (!rc)
 			rc = mspro_block_set_interface(card, msb->system);
+
+		if (!rc) {
+			msleep(150);
+			rc = mspro_block_wait_for_ced(card);
+			if (rc)
+				return rc;
+
+			if (msb->caps & MEMSTICK_CAP_PAR8) {
+				msb->caps &= ~MEMSTICK_CAP_PAR8;
+				goto try_again;
+			}
+		}
 	}
 	return rc;
 }
@@ -1117,14 +1132,16 @@ static int mspro_block_init_card(struct 
 		return -EIO;
 
 	msb->caps = host->caps;
-	rc = mspro_block_switch_interface(card);
+
+	msleep(150);
+	rc = mspro_block_wait_for_ced(card);
 	if (rc)
 		return rc;
 
-	msleep(200);
-	rc = mspro_block_wait_for_ced(card);
+	rc = mspro_block_switch_interface(card);
 	if (rc)
 		return rc;
+
 	dev_dbg(&card->dev, "card activated\n");
 	if (msb->system != MEMSTICK_SYS_SERIAL)
 		msb->caps |= MEMSTICK_CAP_AUTO_GET_INT;
@@ -1192,12 +1209,12 @@ static int mspro_block_init_disk(struct 
 	if (rc)
 		return rc;
 
-	if ((disk_id << MEMSTICK_PART_SHIFT) > 255) {
+	if ((disk_id << MSPRO_BLOCK_PART_SHIFT) > 255) {
 		rc = -ENOSPC;
 		goto out_release_id;
 	}
 
-	msb->disk = alloc_disk(1 << MEMSTICK_PART_SHIFT);
+	msb->disk = alloc_disk(1 << MSPRO_BLOCK_PART_SHIFT);
 	if (!msb->disk) {
 		rc = -ENOMEM;
 		goto out_release_id;
@@ -1220,7 +1237,7 @@ static int mspro_block_init_disk(struct 
 				   MSPRO_BLOCK_MAX_PAGES * msb->page_size);
 
 	msb->disk->major = major;
-	msb->disk->first_minor = disk_id << MEMSTICK_PART_SHIFT;
+	msb->disk->first_minor = disk_id << MSPRO_BLOCK_PART_SHIFT;
 	msb->disk->fops = &ms_block_bdops;
 	msb->usage_count = 1;
 	msb->disk->private_data = msb;
@@ -1416,7 +1433,7 @@ out_unlock:
 
 static struct memstick_device_id mspro_block_id_tbl[] = {
 	{MEMSTICK_MATCH_ALL, MEMSTICK_TYPE_PRO, MEMSTICK_CATEGORY_STORAGE_DUO,
-	 MEMSTICK_CLASS_GENERIC_DUO},
+	 MEMSTICK_CLASS_DUO},
 	{}
 };
 
diff -puN drivers/memstick/host/jmb38x_ms.c~memstick-fix-msprohg-8-bit-interface-mode-support drivers/memstick/host/jmb38x_ms.c
--- a/drivers/memstick/host/jmb38x_ms.c~memstick-fix-msprohg-8-bit-interface-mode-support
+++ a/drivers/memstick/host/jmb38x_ms.c
@@ -81,6 +81,8 @@ struct jmb38x_ms {
 #define TPC_CODE_SZ_MASK       0x00000700
 #define TPC_DATA_SZ_MASK       0x00000007
 
+#define HOST_CONTROL_TDELAY_EN 0x00040000
+#define HOST_CONTROL_HW_OC_P   0x00010000
 #define HOST_CONTROL_RESET_REQ 0x00008000
 #define HOST_CONTROL_REI       0x00004000
 #define HOST_CONTROL_LED       0x00000400
@@ -88,6 +90,7 @@ struct jmb38x_ms {
 #define HOST_CONTROL_RESET     0x00000100
 #define HOST_CONTROL_POWER_EN  0x00000080
 #define HOST_CONTROL_CLOCK_EN  0x00000040
+#define HOST_CONTROL_REO       0x00000008
 #define HOST_CONTROL_IF_SHIFT  4
 
 #define HOST_CONTROL_IF_SERIAL 0x0
@@ -133,11 +136,15 @@ struct jmb38x_ms {
 #define PAD_PU_PD_ON_MS_SOCK1 0x0f0f0000
 
 #define CLOCK_CONTROL_40MHZ   0x00000001
-#define CLOCK_CONTROL_50MHZ   0x00000002
+#define CLOCK_CONTROL_50MHZ   0x0000000a
 #define CLOCK_CONTROL_60MHZ   0x00000008
 #define CLOCK_CONTROL_62_5MHZ 0x0000000c
 #define CLOCK_CONTROL_OFF     0x00000000
 
+#define PCI_CTL_CLOCK_DLY_ADDR   0x000000b0
+#define PCI_CTL_CLOCK_DLY_MASK_A 0x00000f00
+#define PCI_CTL_CLOCK_DLY_MASK_B 0x0000f000
+
 enum {
 	CMD_READY    = 0x01,
 	FIFO_READY   = 0x02,
@@ -367,8 +374,7 @@ static int jmb38x_ms_issue_cmd(struct me
 		return host->req->error;
 	}
 
-	dev_dbg(&msh->dev, "control %08x\n",
-		readl(host->addr + HOST_CONTROL));
+	dev_dbg(&msh->dev, "control %08x\n", readl(host->addr + HOST_CONTROL));
 	dev_dbg(&msh->dev, "status %08x\n", readl(host->addr + INT_STATUS));
 	dev_dbg(&msh->dev, "hstatus %08x\n", readl(host->addr + STATUS));
 
@@ -637,7 +643,7 @@ static int jmb38x_ms_reset(struct jmb38x
 		ndelay(20);
 	}
 	dev_dbg(&host->chip->pdev->dev, "reset_req timeout\n");
-	return -EIO;
+	/* return -EIO; */
 
 reset_next:
 	writel(HOST_CONTROL_RESET | HOST_CONTROL_CLOCK_EN
@@ -680,7 +686,9 @@ static int jmb38x_ms_set_param(struct me
 
 			host_ctl = 7;
 			host_ctl |= HOST_CONTROL_POWER_EN
-				 | HOST_CONTROL_CLOCK_EN;
+				    | HOST_CONTROL_CLOCK_EN
+				    | HOST_CONTROL_HW_OC_P
+				    | HOST_CONTROL_TDELAY_EN;
 			writel(host_ctl, host->addr + HOST_CONTROL);
 
 			writel(host->id ? PAD_PU_PD_ON_MS_SOCK1
@@ -704,33 +712,40 @@ static int jmb38x_ms_set_param(struct me
 		break;
 	case MEMSTICK_INTERFACE:
 		host_ctl &= ~(3 << HOST_CONTROL_IF_SHIFT);
+		pci_read_config_dword(host->chip->pdev,
+				      PCI_CTL_CLOCK_DLY_ADDR,
+				      &clock_delay);
+		clock_delay &= host->id ? ~PCI_CTL_CLOCK_DLY_MASK_B
+					: ~PCI_CTL_CLOCK_DLY_MASK_A;
 
 		if (value == MEMSTICK_SERIAL) {
 			host_ctl &= ~HOST_CONTROL_FAST_CLK;
+			host_ctl &= ~HOST_CONTROL_REO;
 			host_ctl |= HOST_CONTROL_IF_SERIAL
 				    << HOST_CONTROL_IF_SHIFT;
 			host_ctl |= HOST_CONTROL_REI;
 			clock_ctl = CLOCK_CONTROL_40MHZ;
-			clock_delay = 0;
 		} else if (value == MEMSTICK_PAR4) {
-			host_ctl |= HOST_CONTROL_FAST_CLK;
+			host_ctl |= HOST_CONTROL_FAST_CLK | HOST_CONTROL_REO;
 			host_ctl |= HOST_CONTROL_IF_PAR4
 				    << HOST_CONTROL_IF_SHIFT;
 			host_ctl &= ~HOST_CONTROL_REI;
 			clock_ctl = CLOCK_CONTROL_40MHZ;
-			clock_delay = 4;
+			clock_delay |= host->id ? (4 << 12) : (4 << 8);
 		} else if (value == MEMSTICK_PAR8) {
 			host_ctl |= HOST_CONTROL_FAST_CLK;
 			host_ctl |= HOST_CONTROL_IF_PAR8
 				    << HOST_CONTROL_IF_SHIFT;
-			host_ctl &= ~HOST_CONTROL_REI;
-			clock_ctl = CLOCK_CONTROL_60MHZ;
-			clock_delay = 0;
+			host_ctl &= ~(HOST_CONTROL_REI | HOST_CONTROL_REO);
+			clock_ctl = CLOCK_CONTROL_50MHZ;
 		} else
 			return -EINVAL;
+
 		writel(host_ctl, host->addr + HOST_CONTROL);
 		writel(clock_ctl, host->addr + CLOCK_CONTROL);
-		writel(clock_delay, host->addr + CLOCK_DELAY);
+		pci_write_config_dword(host->chip->pdev,
+				       PCI_CTL_CLOCK_DLY_ADDR,
+				       clock_delay);
 		break;
 	};
 	return 0;
diff -puN include/linux/memstick.h~memstick-fix-msprohg-8-bit-interface-mode-support include/linux/memstick.h
--- a/include/linux/memstick.h~memstick-fix-msprohg-8-bit-interface-mode-support
+++ a/include/linux/memstick.h
@@ -21,30 +21,30 @@
 struct ms_status_register {
 	unsigned char reserved;
 	unsigned char interrupt;
-#define MEMSTICK_INT_CMDNAK             0x0001
-#define MEMSTICK_INT_IOREQ              0x0008
-#define MEMSTICK_INT_IOBREQ             0x0010
-#define MEMSTICK_INT_BREQ               0x0020
-#define MEMSTICK_INT_ERR                0x0040
-#define MEMSTICK_INT_CED                0x0080
+#define MEMSTICK_INT_CMDNAK 0x01
+#define MEMSTICK_INT_IOREQ  0x08
+#define MEMSTICK_INT_IOBREQ 0x10
+#define MEMSTICK_INT_BREQ   0x20
+#define MEMSTICK_INT_ERR    0x40
+#define MEMSTICK_INT_CED    0x80
 
 	unsigned char status0;
-#define MEMSTICK_STATUS0_WP             0x0001
-#define MEMSTICK_STATUS0_SL             0x0002
-#define MEMSTICK_STATUS0_BF             0x0010
-#define MEMSTICK_STATUS0_BE             0x0020
-#define MEMSTICK_STATUS0_FB0            0x0040
-#define MEMSTICK_STATUS0_MB             0x0080
+#define MEMSTICK_STATUS0_WP  0x01
+#define MEMSTICK_STATUS0_SL  0x02
+#define MEMSTICK_STATUS0_BF  0x10
+#define MEMSTICK_STATUS0_BE  0x20
+#define MEMSTICK_STATUS0_FB0 0x40
+#define MEMSTICK_STATUS0_MB  0x80
 
 	unsigned char status1;
-#define MEMSTICK_STATUS1_UCFG           0x0001
-#define MEMSTICK_STATUS1_FGER           0x0002
-#define MEMSTICK_STATUS1_UCEX           0x0004
-#define MEMSTICK_STATUS1_EXER           0x0008
-#define MEMSTICK_STATUS1_UCDT           0x0010
-#define MEMSTICK_STATUS1_DTER           0x0020
-#define MEMSTICK_STATUS1_FBI            0x0040
-#define MEMSTICK_STATUS1_MB             0x0080
+#define MEMSTICK_STATUS1_UCFG 0x01
+#define MEMSTICK_STATUS1_FGER 0x02
+#define MEMSTICK_STATUS1_UCEX 0x04
+#define MEMSTICK_STATUS1_EXER 0x08
+#define MEMSTICK_STATUS1_UCDT 0x10
+#define MEMSTICK_STATUS1_DTER 0x20
+#define MEMSTICK_STATUS1_FB1  0x40
+#define MEMSTICK_STATUS1_MB   0x80
 } __attribute__((packed));
 
 struct ms_id_register {
@@ -56,32 +56,32 @@ struct ms_id_register {
 
 struct ms_param_register {
 	unsigned char system;
-#define MEMSTICK_SYS_ATEN 0xc0
-#define MEMSTICK_SYS_BAMD 0x80
 #define MEMSTICK_SYS_PAM  0x08
+#define MEMSTICK_SYS_BAMD 0x80
 
 	unsigned char block_address_msb;
 	unsigned short block_address;
 	unsigned char cp;
-#define MEMSTICK_CP_BLOCK               0x0000
-#define MEMSTICK_CP_PAGE                0x0020
-#define MEMSTICK_CP_EXTRA               0x0040
-#define MEMSTICK_CP_OVERWRITE           0x0080
+#define MEMSTICK_CP_BLOCK     0x00
+#define MEMSTICK_CP_PAGE      0x20
+#define MEMSTICK_CP_EXTRA     0x40
+#define MEMSTICK_CP_OVERWRITE 0x80
 
 	unsigned char page_address;
 } __attribute__((packed));
 
 struct ms_extra_data_register {
 	unsigned char  overwrite_flag;
-#define MEMSTICK_OVERWRITE_UPDATA       0x0010
-#define MEMSTICK_OVERWRITE_PAGE         0x0060
-#define MEMSTICK_OVERWRITE_BLOCK        0x0080
+#define MEMSTICK_OVERWRITE_UDST  0x10
+#define MEMSTICK_OVERWRITE_PGST1 0x20
+#define MEMSTICK_OVERWRITE_PGST0 0x40
+#define MEMSTICK_OVERWRITE_BKST  0x80
 
 	unsigned char  management_flag;
-#define MEMSTICK_MANAGEMENT_SYSTEM      0x0004
-#define MEMSTICK_MANAGEMENT_TRANS_TABLE 0x0008
-#define MEMSTICK_MANAGEMENT_COPY        0x0010
-#define MEMSTICK_MANAGEMENT_ACCESS      0x0020
+#define MEMSTICK_MANAGEMENT_SYSFLG 0x04
+#define MEMSTICK_MANAGEMENT_ATFLG  0x08
+#define MEMSTICK_MANAGEMENT_SCMS1  0x10
+#define MEMSTICK_MANAGEMENT_SCMS0  0x20
 
 	unsigned short logical_address;
 } __attribute__((packed));
@@ -96,9 +96,9 @@ struct ms_register {
 
 struct mspro_param_register {
 	unsigned char  system;
-#define MEMSTICK_SYS_SERIAL 0x80
 #define MEMSTICK_SYS_PAR4   0x00
 #define MEMSTICK_SYS_PAR8   0x40
+#define MEMSTICK_SYS_SERIAL 0x80
 
 	unsigned short data_count;
 	unsigned int   data_address;
@@ -147,7 +147,7 @@ struct ms_register_addr {
 	unsigned char w_length;
 } __attribute__((packed));
 
-enum {
+enum memstick_tpc {
 	MS_TPC_READ_MG_STATUS   = 0x01,
 	MS_TPC_READ_LONG_DATA   = 0x02,
 	MS_TPC_READ_SHORT_DATA  = 0x03,
@@ -167,7 +167,7 @@ enum {
 	MS_TPC_SET_CMD          = 0x0e
 };
 
-enum {
+enum memstick_command {
 	MS_CMD_BLOCK_END       = 0x33,
 	MS_CMD_RESET           = 0x3c,
 	MS_CMD_BLOCK_WRITE     = 0x55,
@@ -201,8 +201,6 @@ enum {
 
 /*** Driver structures and functions ***/
 
-#define MEMSTICK_PART_SHIFT 3
-
 enum memstick_param { MEMSTICK_POWER = 1, MEMSTICK_INTERFACE };
 
 #define MEMSTICK_POWER_OFF 0
@@ -215,24 +213,27 @@ enum memstick_param { MEMSTICK_POWER = 1
 struct memstick_host;
 struct memstick_driver;
 
+struct memstick_device_id {
+	unsigned char match_flags;
 #define MEMSTICK_MATCH_ALL            0x01
 
+	unsigned char type;
 #define MEMSTICK_TYPE_LEGACY          0xff
 #define MEMSTICK_TYPE_DUO             0x00
 #define MEMSTICK_TYPE_PRO             0x01
 
+	unsigned char category;
 #define MEMSTICK_CATEGORY_STORAGE     0xff
 #define MEMSTICK_CATEGORY_STORAGE_DUO 0x00
+#define MEMSTICK_CATEGORY_IO          0x01
+#define MEMSTICK_CATEGORY_IO_PRO      0x10
 
-#define MEMSTICK_CLASS_GENERIC        0xff
-#define MEMSTICK_CLASS_GENERIC_DUO    0x00
-
-
-struct memstick_device_id {
-	unsigned char match_flags;
-	unsigned char type;
-	unsigned char category;
 	unsigned char class;
+#define MEMSTICK_CLASS_FLASH          0xff
+#define MEMSTICK_CLASS_DUO            0x00
+#define MEMSTICK_CLASS_ROM            0x01
+#define MEMSTICK_CLASS_RO             0x02
+#define MEMSTICK_CLASS_WP             0x03
 };
 
 struct memstick_request {
@@ -319,9 +320,9 @@ void memstick_suspend_host(struct memsti
 void memstick_resume_host(struct memstick_host *host);
 
 void memstick_init_req_sg(struct memstick_request *mrq, unsigned char tpc,
-			  struct scatterlist *sg);
+			  const struct scatterlist *sg);
 void memstick_init_req(struct memstick_request *mrq, unsigned char tpc,
-		       void *buf, size_t length);
+		       const void *buf, size_t length);
 int memstick_next_req(struct memstick_host *host,
 		      struct memstick_request **mrq);
 void memstick_new_req(struct memstick_host *host);
_

Patches currently in -mm which might be from oakad@yahoo.com are

origin.patch

