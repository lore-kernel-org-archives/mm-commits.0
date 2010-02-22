From: akpm@linux-foundation.org
Subject: + cciss-remove-c99-style-comments.patch added to -mm tree
Date: Mon, 22 Feb 2010 14:08:09 -0800
Message-ID: <201002222208.o1MM8903026275@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44178 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754729Ab0BVWI1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Feb 2010 17:08:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dannf@hp.com, jens.axboe@oracle.com, scameron@beardog.cce.hp.com


The patch titled
     cciss: remove C99-style comments
has been added to the -mm tree.  Its filename is
     cciss-remove-c99-style-comments.patch

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
Subject: cciss: remove C99-style comments
From: dann frazier <dannf@hp.com>

Some cleanup before the header file split-out so we don't propagate this style
into new files.

Signed-off-by: dann frazier <dannf@hp.com>
Acked-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c       |   37 ++++++++++----------
 drivers/block/cciss.h       |    9 ++---
 drivers/block/cciss_cmd.h   |   61 ++++++++++++++++------------------
 drivers/block/cciss_scsi.h  |   18 +++++-----
 include/linux/cciss_ioctl.h |   33 +++++++++---------
 5 files changed, 78 insertions(+), 80 deletions(-)

diff -puN drivers/block/cciss.c~cciss-remove-c99-style-comments drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-remove-c99-style-comments
+++ a/drivers/block/cciss.c
@@ -1344,26 +1344,27 @@ static int cciss_ioctl(struct block_devi
 				kfree(buff);
 				return -ENOMEM;
 			}
-			// Fill in the command type
+			/* Fill in the command type */
 			c->cmd_type = CMD_IOCTL_PEND;
-			// Fill in Command Header
-			c->Header.ReplyQueue = 0;	// unused in simple mode
-			if (iocommand.buf_size > 0)	// buffer to fill
+			/* Fill in Command Header */
+			c->Header.ReplyQueue = 0;   /* unused in simple mode */
+			if (iocommand.buf_size > 0) /* buffer to fill */
 			{
 				c->Header.SGList = 1;
 				c->Header.SGTotal = 1;
-			} else	// no buffers to fill
+			} else /* no buffers to fill */
 			{
 				c->Header.SGList = 0;
 				c->Header.SGTotal = 0;
 			}
 			c->Header.LUN = iocommand.LUN_info;
-			c->Header.Tag.lower = c->busaddr;	// use the kernel address the cmd block for tag
+			/* use the kernel address the cmd block for tag */
+			c->Header.Tag.lower = c->busaddr;
 
-			// Fill in Request block
+			/* Fill in Request block */
 			c->Request = iocommand.Request;
 
-			// Fill in the scatter gather information
+			/* Fill in the scatter gather information */
 			if (iocommand.buf_size > 0) {
 				temp64.val = pci_map_single(host->pdev, buff,
 					iocommand.buf_size,
@@ -1371,7 +1372,7 @@ static int cciss_ioctl(struct block_devi
 				c->SG[0].Addr.lower = temp64.val32.lower;
 				c->SG[0].Addr.upper = temp64.val32.upper;
 				c->SG[0].Len = iocommand.buf_size;
-				c->SG[0].Ext = 0;	// we are not chaining
+				c->SG[0].Ext = 0;  /* we are not chaining */
 			}
 			c->waiting = &wait;
 
@@ -2425,7 +2426,7 @@ static int fill_cmd(CommandList_struct *
 			c->Request.Type.Direction = XFER_READ;
 			c->Request.Timeout = 0;
 			c->Request.CDB[0] = cmd;
-			c->Request.CDB[6] = (size >> 24) & 0xFF;	//MSB
+			c->Request.CDB[6] = (size >> 24) & 0xFF; /* MSB */
 			c->Request.CDB[7] = (size >> 16) & 0xFF;
 			c->Request.CDB[8] = (size >> 8) & 0xFF;
 			c->Request.CDB[9] = size & 0xFF;
@@ -2694,7 +2695,7 @@ static void cciss_geometry_inquiry(int c
 			       "cciss: reading geometry failed, volume "
 			       "does not support reading geometry\n");
 			drv->heads = 255;
-			drv->sectors = 32;	// Sectors per track
+			drv->sectors = 32;	/* Sectors per track */
 			drv->cylinders = total_size + 1;
 			drv->raid_level = RAID_UNKNOWN;
 		} else {
@@ -3112,19 +3113,19 @@ static void do_cciss_request(struct requ
 
 	/* fill in the request */
 	drv = creq->rq_disk->private_data;
-	c->Header.ReplyQueue = 0;	// unused in simple mode
+	c->Header.ReplyQueue = 0;	/* unused in simple mode */
 	/* got command from pool, so use the command block index instead */
 	/* for direct lookups. */
 	/* The first 2 bits are reserved for controller error reporting. */
 	c->Header.Tag.lower = (c->cmdindex << 3);
 	c->Header.Tag.lower |= 0x04;	/* flag for direct lookup. */
 	memcpy(&c->Header.LUN, drv->LunID, sizeof(drv->LunID));
-	c->Request.CDBLen = 10;	// 12 byte commands not in FW yet;
-	c->Request.Type.Type = TYPE_CMD;	// It is a command.
+	c->Request.CDBLen = 10;	/* 12 byte commands not in FW yet; */
+	c->Request.Type.Type = TYPE_CMD;	/* It is a command. */
 	c->Request.Type.Attribute = ATTR_SIMPLE;
 	c->Request.Type.Direction =
 	    (rq_data_dir(creq) == READ) ? XFER_READ : XFER_WRITE;
-	c->Request.Timeout = 0;	// Don't time out
+	c->Request.Timeout = 0;	/* Don't time out */
 	c->Request.CDB[0] =
 	    (rq_data_dir(creq) == READ) ? h->cciss_read : h->cciss_write;
 	start_blk = blk_rq_pos(creq);
@@ -3209,11 +3210,11 @@ static void do_cciss_request(struct requ
 	if (likely(blk_fs_request(creq))) {
 		if(h->cciss_read == CCISS_READ_10) {
 			c->Request.CDB[1] = 0;
-			c->Request.CDB[2] = (start_blk >> 24) & 0xff;	//MSB
+			c->Request.CDB[2] = (start_blk >> 24) & 0xff; /* MSB */
 			c->Request.CDB[3] = (start_blk >> 16) & 0xff;
 			c->Request.CDB[4] = (start_blk >> 8) & 0xff;
 			c->Request.CDB[5] = start_blk & 0xff;
-			c->Request.CDB[6] = 0;	// (sect >> 24) & 0xff; MSB
+			c->Request.CDB[6] = 0; /* (sect >> 24) & 0xff; MSB */
 			c->Request.CDB[7] = (blk_rq_sectors(creq) >> 8) & 0xff;
 			c->Request.CDB[8] = blk_rq_sectors(creq) & 0xff;
 			c->Request.CDB[9] = c->Request.CDB[11] = c->Request.CDB[12] = 0;
@@ -3222,7 +3223,7 @@ static void do_cciss_request(struct requ
 
 			c->Request.CDBLen = 16;
 			c->Request.CDB[1]= 0;
-			c->Request.CDB[2]= (upper32 >> 24) & 0xff;	//MSB
+			c->Request.CDB[2]= (upper32 >> 24) & 0xff; /* MSB */
 			c->Request.CDB[3]= (upper32 >> 16) & 0xff;
 			c->Request.CDB[4]= (upper32 >>  8) & 0xff;
 			c->Request.CDB[5]= upper32 & 0xff;
diff -puN drivers/block/cciss.h~cciss-remove-c99-style-comments drivers/block/cciss.h
--- a/drivers/block/cciss.h~cciss-remove-c99-style-comments
+++ a/drivers/block/cciss.h
@@ -66,7 +66,7 @@ struct ctlr_info
 	int	ctlr;
 	char	devname[8];
 	char    *product_name;
-	char	firm_ver[4]; // Firmware version 
+	char	firm_ver[4]; /* Firmware version */
 	struct pci_dev *pdev;
 	__u32	board_id;
 	void __iomem *vaddr;
@@ -103,7 +103,7 @@ struct ctlr_info
 	BYTE	cciss_write;
 	BYTE	cciss_read_capacity;
 
-	// information about each logical volume
+	/* information about each logical volume */
 	drive_info_struct *drv[CISS_MAX_LUN];
 
 	struct access_method access;
@@ -116,7 +116,7 @@ struct ctlr_info
 	unsigned int maxSG;
 	spinlock_t lock;
 
-	//* pointers to command and error info pool */ 
+	/* pointers to command and error info pool */
 	CommandList_struct 	*cmd_pool;
 	dma_addr_t		cmd_pool_dhandle; 
 	ErrorInfo_struct 	*errinfo_pool;
@@ -134,7 +134,7 @@ struct ctlr_info
 	*/
 	int			next_to_run;
 
-	// Disk structures we need to pass back
+	/* Disk structures we need to pass back */
 	struct gendisk   *gendisk[CISS_MAX_LUN];
 #ifdef CONFIG_CISS_SCSI_TAPE
 	void *scsi_ctlr; /* ptr to structure containing scsi related stuff */
@@ -315,4 +315,3 @@ struct board_type {
 #define CCISS_LOCK(i)	(&hba[i]->lock)
 
 #endif /* CCISS_H */
-
diff -puN drivers/block/cciss_cmd.h~cciss-remove-c99-style-comments drivers/block/cciss_cmd.h
--- a/drivers/block/cciss_cmd.h~cciss-remove-c99-style-comments
+++ a/drivers/block/cciss_cmd.h
@@ -1,17 +1,16 @@
 #ifndef CCISS_CMD_H
 #define CCISS_CMD_H
-//###########################################################################
-//DEFINES
-//###########################################################################
+/* DEFINES */
 #define CISS_VERSION "1.00"
 
-//general boundary definitions
-#define SENSEINFOBYTES          32//note that this value may vary between host implementations
+/* general boundary definitions */
+#define SENSEINFOBYTES          32 /* note that this value may vary
+				      between host implementations */
 #define MAXSGENTRIES            32
 #define CCISS_SG_CHAIN          0x80000000
 #define MAXREPLYQS              256
 
-//Command Status value
+/* Command Status value */
 #define CMD_SUCCESS             0x0000
 #define CMD_TARGET_STATUS       0x0001
 #define CMD_DATA_UNDERRUN       0x0002
@@ -49,30 +48,30 @@
 #define ASYM_ACCESS_CHANGED		0x06
 #define LUN_CAPACITY_CHANGED		0x09
 
-//transfer direction
+/* transfer direction */
 #define XFER_NONE               0x00
 #define XFER_WRITE              0x01
 #define XFER_READ               0x02
 #define XFER_RSVD               0x03
 
-//task attribute
+/* task attribute */
 #define ATTR_UNTAGGED           0x00
 #define ATTR_SIMPLE             0x04
 #define ATTR_HEADOFQUEUE        0x05
 #define ATTR_ORDERED            0x06
 #define ATTR_ACA                0x07
 
-//cdb type
+/* cdb type */
 #define TYPE_CMD				0x00
 #define TYPE_MSG				0x01
 
-//config space register offsets
+/* config space register offsets */
 #define CFG_VENDORID            0x00
 #define CFG_DEVICEID            0x02
 #define CFG_I2OBAR              0x10
 #define CFG_MEM1BAR             0x14
 
-//i2o space register offsets
+/* i2o space register offsets */
 #define I2O_IBDB_SET            0x20
 #define I2O_IBDB_CLEAR          0x70
 #define I2O_INT_STATUS          0x30
@@ -81,7 +80,7 @@
 #define I2O_OBPOST_Q            0x44
 #define I2O_DMA1_CFG		0x214
 
-//Configuration Table
+/* Configuration Table */
 #define CFGTBL_ChangeReq        0x00000001l
 #define CFGTBL_AccCmds          0x00000001l
 
@@ -103,24 +102,22 @@ typedef union _u64bit
    __u64	val;
 } u64bit;
 
-// Type defs used in the following structs
+/* Type defs used in the following structs */
 #define BYTE __u8
 #define WORD __u16
 #define HWORD __u16
 #define DWORD __u32
 #define QWORD vals32 
 
-//###########################################################################
-//STRUCTURES
-//###########################################################################
+/* STRUCTURES */
 #define CISS_MAX_LUN	1024
 #define CISS_MAX_PHYS_LUN	1024
-// SCSI-3 Cmmands 
+/* SCSI-3 Cmmands */
 
 #pragma pack(1)	
 
 #define CISS_INQUIRY 0x12
-//Date returned
+/* Date returned */
 typedef struct _InquiryData_struct
 {
   BYTE data_byte[36];
@@ -128,7 +125,7 @@ typedef struct _InquiryData_struct
 
 #define CISS_REPORT_LOG 0xc2    /* Report Logical LUNs */
 #define CISS_REPORT_PHYS 0xc3   /* Report Physical LUNs */
-// Data returned
+/* Data returned */
 typedef struct _ReportLUNdata_struct
 {
   BYTE LUNListLength[4];
@@ -139,8 +136,8 @@ typedef struct _ReportLUNdata_struct
 #define CCISS_READ_CAPACITY 0x25 /* Read Capacity */ 
 typedef struct _ReadCapdata_struct
 {
-  BYTE total_size[4];	// Total size in blocks
-  BYTE block_size[4];	// Size of blocks in bytes
+  BYTE total_size[4];	/* Total size in blocks */
+  BYTE block_size[4];	/* Size of blocks in bytes */
 } ReadCapdata_struct;
 
 #define CCISS_READ_CAPACITY_16 0x9e /* Read Capacity 16 */
@@ -172,29 +169,29 @@ typedef struct _ReadCapdata_struct_16
 #define CDB_LEN10	10
 #define CDB_LEN16	16
 
-// BMIC commands 
+/* BMIC commands */
 #define BMIC_READ 0x26
 #define BMIC_WRITE 0x27
 #define BMIC_CACHE_FLUSH 0xc2
-#define CCISS_CACHE_FLUSH 0x01	//C2 was already being used by CCISS
+#define CCISS_CACHE_FLUSH 0x01	/* C2 was already being used by CCISS */
 
-//Command List Structure
+/* Command List Structure */
 typedef union _SCSI3Addr_struct {
    struct {
     BYTE Dev;
     BYTE Bus:6;
-    BYTE Mode:2;        // b00
+    BYTE Mode:2;        /* b00 */
   } PeripDev;
    struct {
     BYTE DevLSB;
     BYTE DevMSB:6;
-    BYTE Mode:2;        // b01
+    BYTE Mode:2;        /* b01 */
   } LogDev;
    struct {
     BYTE Dev:5;
     BYTE Bus:3;
     BYTE Targ:6;
-    BYTE Mode:2;        // b10
+    BYTE Mode:2;        /* b10 */
   } LogUnit;
 } SCSI3Addr_struct;
 
@@ -202,7 +199,7 @@ typedef struct _PhysDevAddr_struct {
   DWORD             TargetId:24;
   DWORD             Bus:6;
   DWORD             Mode:2;
-  SCSI3Addr_struct  Target[2]; //2 level target device addr
+  SCSI3Addr_struct  Target[2]; /* 2 level target device addr */
 } PhysDevAddr_struct;
   
 typedef struct _LogDevAddr_struct {
@@ -255,8 +252,8 @@ typedef union _MoreErrInfo_struct{
   }Common_Info;
   struct{
     BYTE  Reserved[2];
-    BYTE  offense_size;//size of offending entry
-    BYTE  offense_num; //byte # of offense 0-base
+    BYTE  offense_size; /* size of offending entry */
+    BYTE  offense_num;  /* byte # of offense 0-base */
     DWORD offense_value;
   }Invalid_Cmd;
 }MoreErrInfo_struct;
@@ -300,7 +297,7 @@ typedef struct _CommandList_struct {
   char   pad[PADSIZE];
 } CommandList_struct;
 
-//Configuration Table Structure
+/* Configuration Table Structure */
 typedef struct _HostWrite_struct {
   DWORD TransportRequest;
   DWORD Reserved;
@@ -326,4 +323,4 @@ typedef struct _CfgTable_struct {
   DWORD            MaxPhysicalDrivesPerLogicalUnit;
 } CfgTable_struct;
 #pragma pack()	 
-#endif // CCISS_CMD_H
+#endif /* CCISS_CMD_H */
diff -puN drivers/block/cciss_scsi.h~cciss-remove-c99-style-comments drivers/block/cciss_scsi.h
--- a/drivers/block/cciss_scsi.h~cciss-remove-c99-style-comments
+++ a/drivers/block/cciss_scsi.h
@@ -25,16 +25,16 @@
 
 #include <scsi/scsicam.h> /* possibly irrelevant, since we don't show disks */
 
-		// the scsi id of the adapter...
+		/* the scsi id of the adapter... */
 #define SELF_SCSI_ID 15
-		// 15 is somewhat arbitrary, since the scsi-2 bus
-		// that's presented by the driver to the OS is
-		// fabricated.  The "real" scsi-3 bus the 
-		// hardware presents is fabricated too.
-		// The actual, honest-to-goodness physical
-		// bus that the devices are attached to is not 
-		// addressible natively, and may in fact turn
-		// out to be not scsi at all.
+		/* 15 is somewhat arbitrary, since the scsi-2 bus
+		   that's presented by the driver to the OS is
+		   fabricated.  The "real" scsi-3 bus the
+		   hardware presents is fabricated too.
+		   The actual, honest-to-goodness physical
+		   bus that the devices are attached to is not
+		   addressible natively, and may in fact turn
+		   out to be not scsi at all. */
 
 #define SCSI_CCISS_CAN_QUEUE 2
 
diff -puN include/linux/cciss_ioctl.h~cciss-remove-c99-style-comments include/linux/cciss_ioctl.h
--- a/include/linux/cciss_ioctl.h~cciss-remove-c99-style-comments
+++ a/include/linux/cciss_ioctl.h
@@ -37,12 +37,13 @@ typedef __u32 DriverVer_type;
 #define MAX_KMALLOC_SIZE 128000
 
 #ifndef CCISS_CMD_H
-// This defines are duplicated in cciss_cmd.h in the driver directory 
+/* This defines are duplicated in cciss_cmd.h in the driver directory */
 
-//general boundary definitions
-#define SENSEINFOBYTES          32//note that this value may vary between host implementations
+/* general boundary definitions */
+#define SENSEINFOBYTES          32 /* note that this value may vary
+				      between host implementations */
 
-//Command Status value
+/* Command Status value */
 #define CMD_SUCCESS             0x0000
 #define CMD_TARGET_STATUS       0x0001
 #define CMD_DATA_UNDERRUN       0x0002
@@ -57,24 +58,24 @@ typedef __u32 DriverVer_type;
 #define CMD_TIMEOUT             0x000B
 #define CMD_UNABORTABLE		0x000C
 
-//transfer direction
+/* transfer direction */
 #define XFER_NONE               0x00
 #define XFER_WRITE              0x01
 #define XFER_READ               0x02
 #define XFER_RSVD               0x03
 
-//task attribute
+/* task attribute */
 #define ATTR_UNTAGGED           0x00
 #define ATTR_SIMPLE             0x04
 #define ATTR_HEADOFQUEUE        0x05
 #define ATTR_ORDERED            0x06
 #define ATTR_ACA                0x07
 
-//cdb type
+/* cdb type */
 #define TYPE_CMD				0x00
 #define TYPE_MSG				0x01
 
-// Type defs used in the following structs
+/* Type defs used in the following structs */
 #define BYTE __u8
 #define WORD __u16
 #define HWORD __u16
@@ -82,28 +83,28 @@ typedef __u32 DriverVer_type;
 
 #define CISS_MAX_LUN	1024
 
-#define LEVEL2LUN   1   // index into Target(x) structure, due to byte swapping
+#define LEVEL2LUN   1 /* index into Target(x) structure, due to byte swapping */
 #define LEVEL3LUN   0
 
 #pragma pack(1)
 
-//Command List Structure
+/* Command List Structure */
 typedef union _SCSI3Addr_struct {
    struct {
     BYTE Dev;
     BYTE Bus:6;
-    BYTE Mode:2;        // b00
+    BYTE Mode:2;        /* b00 */
   } PeripDev;
    struct {
     BYTE DevLSB;
     BYTE DevMSB:6;
-    BYTE Mode:2;        // b01
+    BYTE Mode:2;        /* b01 */
   } LogDev;
    struct {
     BYTE Dev:5;
     BYTE Bus:3;
     BYTE Targ:6;
-    BYTE Mode:2;        // b10
+    BYTE Mode:2;        /* b10 */
   } LogUnit;
 } SCSI3Addr_struct;
 
@@ -111,7 +112,7 @@ typedef struct _PhysDevAddr_struct {
   DWORD             TargetId:24;
   DWORD             Bus:6;
   DWORD             Mode:2;
-  SCSI3Addr_struct  Target[2]; //2 level target device addr
+  SCSI3Addr_struct  Target[2]; /* 2 level target device addr */
 } PhysDevAddr_struct;
   
 typedef struct _LogDevAddr_struct {
@@ -146,8 +147,8 @@ typedef union _MoreErrInfo_struct{
   }Common_Info;
   struct{
     BYTE  Reserved[2];
-    BYTE  offense_size;//size of offending entry
-    BYTE  offense_num; //byte # of offense 0-base
+    BYTE  offense_size; /* size of offending entry */
+    BYTE  offense_num;  /* byte # of offense 0-base */
     DWORD offense_value;
   }Invalid_Cmd;
 }MoreErrInfo_struct;
_

Patches currently in -mm which might be from dannf@hp.com are

cciss-remove-c99-style-comments.patch
cciss-consolidate-duplicate-bits-in-cciss_cmdh-cciss_ioctlh.patch

