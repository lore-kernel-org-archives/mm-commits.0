From: akpm@linux-foundation.org
Subject: + scsi-upstream-arcmsr-1200015.patch added to -mm tree
Date: Fri, 14 Sep 2007 17:26:03 -0700
Message-ID: <200709150026.l8F0Q3QZ031599@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38579 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752903AbXIOA0T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Sep 2007 20:26:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nick.cheng@areca.com.tw


The patch titled
     scsi: upstream arcmsr-1.20.00.15
has been added to the -mm tree.  Its filename is
     scsi-upstream-arcmsr-1200015.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: scsi: upstream arcmsr-1.20.00.15
From: Nick Cheng <nick.cheng@areca.com.tw>

Description:
** support ARC1200/1201/1202 SATA RAID adapter, which is named
ACB_ADAPTER_TYPE_B
** modify the arcmsr_pci_slot_reset function
** modify the arcmsr_pci_ers_disconnect_forepart function
** modify the arcmsr_pci_ers_need_reset_forepart function=A0

Signed-off-by: Nick Cheng <nick.cheng@areca.com.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/scsi/ChangeLog.arcmsr |   17 
 drivers/scsi/Kconfig                |   23 
 drivers/scsi/arcmsr/arcmsr.h        |  194 +-
 drivers/scsi/arcmsr/arcmsr_attr.c   |   64 
 drivers/scsi/arcmsr/arcmsr_hba.c    | 2311 +++++++++++++++-----------
 include/linux/pci_ids.h             |    3 
 6 files changed, 1596 insertions(+), 1016 deletions(-)

diff -puN Documentation/scsi/ChangeLog.arcmsr~scsi-upstream-arcmsr-1200015 Documentation/scsi/ChangeLog.arcmsr
--- a/Documentation/scsi/ChangeLog.arcmsr~scsi-upstream-arcmsr-1200015
+++ a/Documentation/scsi/ChangeLog.arcmsr
@@ -53,4 +53,19 @@
 **						for linux standard list
 **						enable usage of pci message signal interrupt
 **						follow Randy.Danlup kindness suggestion cleanup this code
-**************************************************************************
\ No newline at end of file
+** 1.20.00.14   05/02/2007	 Erich Chen & Nick Cheng
+**						1.implement PCI-Express error recovery function and AER capability
+**						2.implement the selection of ARCMSR_MAX_XFER_SECTORS_B=4096
+**				 		if firmware version is newer than 1.42
+**						3.modify arcmsr_iop_reset to improve the ability
+**						4.modify the ISR, arcmsr_interrupt routine,to prevent the
+**						inconsistency with sg_mod driver if application	directly calls
+**						the arcmsr driver w/o passing through scsi mid layer
+**						specially thanks to Yanmin Zhang's openhanded help about AER
+** 1.20.00.15   08/30/2007	 Erich Chen & Nick Cheng
+**						1. support ARC1200/1201/1202 SATA RAID adapter, which is named
+**						ACB_ADAPTER_TYPE_B
+**						2. modify the arcmsr_pci_slot_reset function
+**						3. modify the arcmsr_pci_ers_disconnect_forepart function
+**						4. modify the arcmsr_pci_ers_need_reset_forepart function
+**************************************************************************
diff -puN drivers/scsi/Kconfig~scsi-upstream-arcmsr-1200015 drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig~scsi-upstream-arcmsr-1200015
+++ a/drivers/scsi/Kconfig
@@ -538,19 +538,32 @@ config SCSI_IN2000
 	  module will be called in2000.
 
 config SCSI_ARCMSR
-	tristate "ARECA ARC11X0[PCI-X]/ARC12X0[PCI-EXPRESS] SATA-RAID support"
+	tristate "ARECA (ARC11xx/12xx/13xx/16xx) SATA/SAS RAID Host Adapter"
 	depends on PCI && SCSI
 	help
-	  This driver supports all of ARECA's SATA RAID controller cards.
+	  This driver supports all of ARECA's SATA/SAS RAID controller cards.
 	  This is an ARECA-maintained driver by Erich Chen.
-	  If you have any problems, please mail to: < erich@areca.com.tw >
+	  If you have any problems, please mail to: <erich@areca.com.tw>.
 	  Areca supports Linux RAID config tools.
-
-	  < http://www.areca.com.tw >
+	  Please link <http://www.areca.com.tw>
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called arcmsr (modprobe arcmsr).
 
+config SCSI_ARCMSR_AER
+	bool "Enable PCI Error Recovery Capability in Areca Driver(ARCMSR)"
+	depends on SCSI_ARCMSR && PCIEAER
+	default n
+	help
+	  The advanced error reporting(AER) capability is "NOT" provided by
+	  ARC1200/1201/1202 SATA RAID controllers cards.
+	  If your card is one of ARC1200/1201/1202, please use the default setting, n.
+	  If your card is other models, you could pick it
+	  on condition that the kernel version is greater than 2.6.19.
+	  This function is maintained driver by Nick Cheng. If you have any
+	  problems or suggestion, you are welcome to contact with <nick.cheng@areca.com.tw>.
+	  To enable this function, choose Y here.
+
 source "drivers/scsi/megaraid/Kconfig.megaraid"
 
 config SCSI_HPTIOP
diff -puN drivers/scsi/arcmsr/arcmsr.h~scsi-upstream-arcmsr-1200015 drivers/scsi/arcmsr/arcmsr.h
--- a/drivers/scsi/arcmsr/arcmsr.h~scsi-upstream-arcmsr-1200015
+++ a/drivers/scsi/arcmsr/arcmsr.h
@@ -9,7 +9,7 @@
 ** Copyright (C) 2002 - 2005, Areca Technology Corporation All rights reserved.
 **
 **     Web site: www.areca.com.tw
-**       E-mail: erich@areca.com.tw
+**       E-mail: support@areca.com.tw
 **
 ** This program is free software; you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License version 2 as
@@ -45,19 +45,26 @@
 #include <linux/interrupt.h>
 
 struct class_device_attribute;
-
-#define ARCMSR_MAX_OUTSTANDING_CMD 						256
-#define ARCMSR_MAX_FREECCB_NUM							288
-#define ARCMSR_DRIVER_VERSION				"Driver Version 1.20.00.14"
+/*The limit of outstanding scsi command that firmware can handle*/
+#define ARCMSR_MAX_OUTSTANDING_CMD						256
+#define ARCMSR_MAX_FREECCB_NUM							320
+#define ARCMSR_DRIVER_VERSION		     "Driver Version 1.20.00.15 2007/08/30"
 #define ARCMSR_SCSI_INITIATOR_ID						255
 #define ARCMSR_MAX_XFER_SECTORS							512
-#define ARCMSR_MAX_XFER_SECTORS_B                                              4096
-#define ARCMSR_MAX_TARGETID							 17
-#define ARCMSR_MAX_TARGETLUN							  8
-#define ARCMSR_MAX_CMD_PERLUN				 ARCMSR_MAX_OUTSTANDING_CMD
-#define ARCMSR_MAX_QBUFFER						       4096
-#define ARCMSR_MAX_SG_ENTRIES							 38
-
+#define ARCMSR_MAX_XFER_SECTORS_B						4096
+#define ARCMSR_MAX_TARGETID							17
+#define ARCMSR_MAX_TARGETLUN							8
+#define ARCMSR_MAX_CMD_PERLUN		                 ARCMSR_MAX_OUTSTANDING_CMD
+#define ARCMSR_MAX_QBUFFER							4096
+#define ARCMSR_MAX_SG_ENTRIES							38
+#define ARCMSR_MAX_HBB_POSTQUEUE						264
+/*
+**********************************************************************************
+**
+**********************************************************************************
+*/
+#define ARC_SUCCESS                                                       0
+#define ARC_FAILURE                                                       1
 /*
 *******************************************************************************
 **        split 64bits dma addressing
@@ -90,7 +97,7 @@ struct CMD_MESSAGE_FIELD
     uint8_t				messagedatabuffer[1032];
 };
 /* IOP message transfer */
-#define ARCMSR_MESSAGE_FAIL             0x0001
+#define ARCMSR_MESSAGE_FAIL			0x0001
 /* DeviceType */
 #define ARECA_SATA_RAID				0x90000000
 /* FunctionCode */
@@ -163,27 +170,27 @@ struct QBUFFER
 };
 /*
 *******************************************************************************
-**      FIRMWARE INFO
+**      FIRMWARE INFO for Intel IOP R 80331 processor (Type A)
 *******************************************************************************
 */
 struct FIRMWARE_INFO
 {
-	uint32_t      signature;                /*0, 00-03*/
-	uint32_t      request_len;              /*1, 04-07*/
-	uint32_t      numbers_queue;            /*2, 08-11*/
+	uint32_t      signature;		/*0, 00-03*/
+	uint32_t      request_len;		/*1, 04-07*/
+	uint32_t      numbers_queue;		/*2, 08-11*/
 	uint32_t      sdram_size;               /*3, 12-15*/
-	uint32_t      ide_channels;             /*4, 16-19*/
-	char          vendor[40];               /*5, 20-59*/
-	char          model[8];                 /*15, 60-67*/
-	char          firmware_ver[16];         /*17, 68-83*/
-	char          device_map[16];           /*21, 84-99*/
+	uint32_t      ide_channels;		/*4, 16-19*/
+	char          vendor[40];		/*5, 20-59*/
+	char          model[8];			/*15, 60-67*/
+	char          firmware_ver[16];     	/*17, 68-83*/
+	char          device_map[16];		/*21, 84-99*/
 };
 /* signature of set and get firmware config */
-#define ARCMSR_SIGNATURE_GET_CONFIG                   0x87974060
-#define ARCMSR_SIGNATURE_SET_CONFIG                   0x87974063
+#define ARCMSR_SIGNATURE_GET_CONFIG		      0x87974060
+#define ARCMSR_SIGNATURE_SET_CONFIG		      0x87974063
 /* message code of inbound message register */
-#define ARCMSR_INBOUND_MESG0_NOP                      0x00000000
-#define ARCMSR_INBOUND_MESG0_GET_CONFIG               0x00000001
+#define ARCMSR_INBOUND_MESG0_NOP		      0x00000000
+#define ARCMSR_INBOUND_MESG0_GET_CONFIG		      0x00000001
 #define ARCMSR_INBOUND_MESG0_SET_CONFIG               0x00000002
 #define ARCMSR_INBOUND_MESG0_ABORT_CMD                0x00000003
 #define ARCMSR_INBOUND_MESG0_STOP_BGRB                0x00000004
@@ -203,6 +210,60 @@ struct FIRMWARE_INFO
 #define ARCMSR_CCBREPLY_FLAG_ERROR                    0x10000000
 /* outbound firmware ok */
 #define ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK             0x80000000
+
+/*
+************************************************************************
+**                SPEC. for Areca Type B adapter
+************************************************************************
+*/
+/* ARECA HBB COMMAND for its FIRMWARE */
+/* window of "instruction flags" from driver to iop */
+#define ARCMSR_DRV2IOP_DOORBELL                       0x00020400
+#define ARCMSR_DRV2IOP_DOORBELL_MASK                  0x00020404
+/* window of "instruction flags" from iop to driver */
+#define ARCMSR_IOP2DRV_DOORBELL                       0x00020408
+#define ARCMSR_IOP2DRV_DOORBELL_MASK                  0x0002040C
+/* ARECA FLAG LANGUAGE */
+/* ioctl transfer */
+#define ARCMSR_IOP2DRV_DATA_WRITE_OK                  0x00000001
+/* ioctl transfer */
+#define ARCMSR_IOP2DRV_DATA_READ_OK                   0x00000002
+#define ARCMSR_IOP2DRV_CDB_DONE                       0x00000004
+#define ARCMSR_IOP2DRV_MESSAGE_CMD_DONE               0x00000008
+
+#define ARCMSR_DOORBELL_HANDLE_INT		      0x0000000F
+#define ARCMSR_DOORBELL_INT_CLEAR_PATTERN   	      0xFF00FFF0
+#define ARCMSR_MESSAGE_INT_CLEAR_PATTERN	      0xFF00FFF7
+/* (ARCMSR_INBOUND_MESG0_GET_CONFIG<<16)|ARCMSR_DRV2IOP_MESSAGE_CMD_POSTED) */
+#define ARCMSR_MESSAGE_GET_CONFIG		      0x00010008
+/* (ARCMSR_INBOUND_MESG0_SET_CONFIG<<16)|ARCMSR_DRV2IOP_MESSAGE_CMD_POSTED) */
+#define ARCMSR_MESSAGE_SET_CONFIG		      0x00020008
+/* (ARCMSR_INBOUND_MESG0_ABORT_CMD<<16)|ARCMSR_DRV2IOP_MESSAGE_CMD_POSTED) */
+#define ARCMSR_MESSAGE_ABORT_CMD		      0x00030008
+/* (ARCMSR_INBOUND_MESG0_STOP_BGRB<<16)|ARCMSR_DRV2IOP_MESSAGE_CMD_POSTED) */
+#define ARCMSR_MESSAGE_STOP_BGRB		      0x00040008
+/* (ARCMSR_INBOUND_MESG0_FLUSH_CACHE<<16)|ARCMSR_DRV2IOP_MESSAGE_CMD_POSTED) */
+#define ARCMSR_MESSAGE_FLUSH_CACHE                    0x00050008
+/* (ARCMSR_INBOUND_MESG0_START_BGRB<<16)|ARCMSR_DRV2IOP_MESSAGE_CMD_POSTED) */
+#define ARCMSR_MESSAGE_START_BGRB		      0x00060008
+#define ARCMSR_MESSAGE_START_DRIVER_MODE	      0x000E0008
+#define ARCMSR_MESSAGE_SET_POST_WINDOW		      0x000F0008
+/* ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK */
+#define ARCMSR_MESSAGE_FIRMWARE_OK		      0x80000000
+/* ioctl transfer */
+#define ARCMSR_DRV2IOP_DATA_WRITE_OK                  0x00000001
+/* ioctl transfer */
+#define ARCMSR_DRV2IOP_DATA_READ_OK                   0x00000002
+#define ARCMSR_DRV2IOP_CDB_POSTED                     0x00000004
+#define ARCMSR_DRV2IOP_MESSAGE_CMD_POSTED             0x00000008
+
+/* data tunnel buffer between user space program and its firmware */
+/* user space data to iop 128bytes */
+#define ARCMSR_IOCTL_WBUFFER			      0x0000fe00
+/* iop data to user space 128bytes */
+#define ARCMSR_IOCTL_RBUFFER			      0x0000ff00
+/* iop message_rwbuffer for message command */
+#define ARCMSR_MSGCODE_RWBUFFER			      0x0000fa00
 /*
 *******************************************************************************
 **    ARECA SCSI COMMAND DESCRIPTOR BLOCK size 0x1F8 (504)
@@ -214,7 +275,6 @@ struct ARCMSR_CDB
 	uint8_t							TargetID;
 	uint8_t							LUN;
 	uint8_t							Function;
-
 	uint8_t							CdbLength;
 	uint8_t							sgcount;
 	uint8_t							Flags;
@@ -224,20 +284,18 @@ struct ARCMSR_CDB
 #define ARCMSR_CDB_FLAG_SIMPLEQ            0x00
 #define ARCMSR_CDB_FLAG_HEADQ              0x08
 #define ARCMSR_CDB_FLAG_ORDEREDQ           0x10
-	uint8_t							Reserved1;
 
+	uint8_t							Reserved1;
 	uint32_t						Context;
 	uint32_t						DataLength;
-
 	uint8_t							Cdb[16];
-
 	uint8_t							DeviceStatus;
-#define ARCMSR_DEV_CHECK_CONDITION          0x02
-#define ARCMSR_DEV_SELECT_TIMEOUT			0xF0
-#define ARCMSR_DEV_ABORTED				0xF1
-#define ARCMSR_DEV_INIT_FAIL				0xF2
-	uint8_t							SenseData[15];
+#define ARCMSR_DEV_CHECK_CONDITION	    0x02
+#define ARCMSR_DEV_SELECT_TIMEOUT	    0xF0
+#define ARCMSR_DEV_ABORTED		    0xF1
+#define ARCMSR_DEV_INIT_FAIL		    0xF2
 
+	uint8_t							SenseData[15];
 	union
 	{
 		struct SG32ENTRY                sg32entry[ARCMSR_MAX_SG_ENTRIES];
@@ -246,10 +304,10 @@ struct ARCMSR_CDB
 };
 /*
 *******************************************************************************
-**     Messaging Unit (MU) of the Intel R 80331 I/O processor (80331)
+**     Messaging Unit (MU) of the Intel R 80331 I/O processor(Type A) and Type B processor
 *******************************************************************************
 */
-struct MessageUnit
+struct MessageUnit_A
 {
 	uint32_t	resrved0[4];			/*0000 000F*/
 	uint32_t	inbound_msgaddr0;		/*0010 0013*/
@@ -274,6 +332,30 @@ struct MessageUnit
 	uint32_t	message_rbuffer[32];		/*0F00 0F7F  32*/
 	uint32_t	reserved6[32];			/*0F80 0FFF  32*/
 };
+
+struct MessageUnit_B
+{
+  	uint32_t	post_qbuffer[ARCMSR_MAX_HBB_POSTQUEUE];
+  	uint32_t	done_qbuffer[ARCMSR_MAX_HBB_POSTQUEUE];
+	uint32_t	postq_index;
+	uint32_t	doneq_index;
+	uint32_t	*drv2iop_doorbell_reg;
+	uint32_t	*drv2iop_doorbell_mask_reg;
+	uint32_t	*iop2drv_doorbell_reg;
+	uint32_t	*iop2drv_doorbell_mask_reg;
+	uint32_t	*msgcode_rwbuffer_reg;
+	uint32_t	*ioctl_wbuffer_reg;
+	uint32_t	*ioctl_rbuffer_reg;
+};
+
+struct MessageUnit
+{
+	union
+	{
+		struct MessageUnit_A	pmu_A;
+  		struct MessageUnit_B	pmu_B;
+	} u;
+};
 /*
 *******************************************************************************
 **                 Adapter Control Block
@@ -281,37 +363,45 @@ struct MessageUnit
 */
 struct AdapterControlBlock
 {
-	struct pci_dev *		pdev;
+	uint32_t  adapter_type;                /* adapter A,B..... */
+	#define ACB_ADAPTER_TYPE_A            0x00000001	/* hba I IOP */
+	#define ACB_ADAPTER_TYPE_B            0x00000002	/* hbb M IOP */
+	#define ACB_ADAPTER_TYPE_C            0x00000004	/* hbc P IOP */
+	#define ACB_ADAPTER_TYPE_D            0x00000008	/* hbd A IOP */
+	struct pci_dev *	 	pdev;
 	struct Scsi_Host *		host;
 	unsigned long			vir2phy_offset;
 	/* Offset is used in making arc cdb physical to virtual calculations */
 	uint32_t			outbound_int_enable;
 
-	struct MessageUnit __iomem *		pmu;
+	struct MessageUnit *			pmu;
 	/* message unit ATU inbound base address0 */
 
 	uint32_t			acb_flags;
-#define ACB_F_SCSISTOPADAPTER         0x0001
-#define ACB_F_MSG_STOP_BGRB           0x0002
+	#define ACB_F_SCSISTOPADAPTER         	0x0001
+	#define ACB_F_MSG_STOP_BGRB     	0x0002
 	/* stop RAID background rebuild */
-#define ACB_F_MSG_START_BGRB          0x0004
+	#define ACB_F_MSG_START_BGRB          	0x0004
 	/* stop RAID background rebuild */
-#define ACB_F_IOPDATA_OVERFLOW        0x0008
+	#define ACB_F_IOPDATA_OVERFLOW        	0x0008
 	/* iop message data rqbuffer overflow */
-#define ACB_F_MESSAGE_WQBUFFER_CLEARED  0x0010
+	#define ACB_F_MESSAGE_WQBUFFER_CLEARED	0x0010
 	/* message clear wqbuffer */
-#define ACB_F_MESSAGE_RQBUFFER_CLEARED  0x0020
+	#define ACB_F_MESSAGE_RQBUFFER_CLEARED  0x0020
 	/* message clear rqbuffer */
-#define ACB_F_MESSAGE_WQBUFFER_READED   0x0040
-#define ACB_F_BUS_RESET               0x0080
-#define ACB_F_IOP_INITED              0x0100
+	#define ACB_F_MESSAGE_WQBUFFER_READED   0x0040
+	#define ACB_F_BUS_RESET               	0x0080
+	#define ACB_F_IOP_INITED              	0x0100
 	/* iop init */
 
 	struct CommandControlBlock *			pccb_pool[ARCMSR_MAX_FREECCB_NUM];
 	/* used for memory free */
 	struct list_head		ccb_free_list;
 	/* head of free ccb list */
+
 	atomic_t			ccboutstandingcount;
+	/*The present outstanding command number that in the IOP that
+					waiting for being handled by FW*/
 
 	void *				dma_coherent;
 	/* dma_coherent used for memory free */
@@ -353,7 +443,7 @@ struct CommandControlBlock
 {
 	struct ARCMSR_CDB		arcmsr_cdb;
 	/*
-	** 0-503 (size of CDB=504):
+	** 0-503 (size of CDB = 504):
 	** arcmsr messenger scsi command descriptor size 504 bytes
 	*/
 	uint32_t			cdb_shifted_phyaddr;
@@ -466,7 +556,9 @@ struct SENSE_DATA
 #define     ARCMSR_MU_OUTBOUND_MESSAGE0_INTMASKENABLE               0x01
 #define     ARCMSR_MU_OUTBOUND_ALL_INTMASKENABLE                    0x1F
 
-extern void arcmsr_post_Qbuffer(struct AdapterControlBlock *acb);
+extern void arcmsr_post_ioctldata2iop(struct AdapterControlBlock *);
+extern void arcmsr_iop_message_read(struct AdapterControlBlock *);
+extern struct QBUFFER *arcmsr_get_iop_rqbuffer(struct AdapterControlBlock *);
 extern struct class_device_attribute *arcmsr_host_attrs[];
-extern int arcmsr_alloc_sysfs_attr(struct AdapterControlBlock *acb);
+extern int arcmsr_alloc_sysfs_attr(struct AdapterControlBlock *);
 void arcmsr_free_sysfs_attr(struct AdapterControlBlock *acb);
diff -puN drivers/scsi/arcmsr/arcmsr_attr.c~scsi-upstream-arcmsr-1200015 drivers/scsi/arcmsr/arcmsr_attr.c
--- a/drivers/scsi/arcmsr/arcmsr_attr.c~scsi-upstream-arcmsr-1200015
+++ a/drivers/scsi/arcmsr/arcmsr_attr.c
@@ -8,7 +8,7 @@
 ** Copyright (C) 2002 - 2005, Areca Technology Corporation All rights reserved
 **
 **     Web site: www.areca.com.tw
-**       E-mail: erich@areca.com.tw
+**       E-mail: support@areca.com.tw
 **
 ** This program is free software; you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License version 2 as
@@ -49,6 +49,7 @@
 #include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/delay.h>
+#include <linux/pci.h>
 
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
@@ -58,15 +59,11 @@
 
 struct class_device_attribute *arcmsr_host_attrs[];
 
-static ssize_t
-arcmsr_sysfs_iop_message_read(struct kobject *kobj,
-			      struct bin_attribute *bin_attr,
-			      char *buf, loff_t off, size_t count)
+static ssize_t arcmsr_sysfs_iop_message_read(struct kobject *kobj, char *buf, loff_t off, size_t count)
 {
 	struct class_device *cdev = container_of(kobj,struct class_device,kobj);
 	struct Scsi_Host *host = class_to_shost(cdev);
 	struct AdapterControlBlock *acb = (struct AdapterControlBlock *) host->hostdata;
-	struct MessageUnit __iomem *reg = acb->pmu;
 	uint8_t *pQbuffer,*ptmpQbuffer;
 	int32_t allxfer_len = 0;
 
@@ -85,12 +82,13 @@ arcmsr_sysfs_iop_message_read(struct kob
 		allxfer_len++;
 	}
 	if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
-		struct QBUFFER __iomem * prbuffer = (struct QBUFFER __iomem *)
-					&reg->message_rbuffer;
-		uint8_t __iomem * iop_data = (uint8_t __iomem *)prbuffer->data;
+		struct QBUFFER *prbuffer;
+		uint8_t *iop_data;
 		int32_t iop_len;
 
 		acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;
+		prbuffer = arcmsr_get_iop_rqbuffer(acb);
+		iop_data = (uint8_t *)prbuffer->data;
 		iop_len = readl(&prbuffer->data_len);
 		while (iop_len > 0) {
 			acb->rqbuffer[acb->rqbuf_lastindex] = readb(iop_data);
@@ -99,16 +97,12 @@ arcmsr_sysfs_iop_message_read(struct kob
 			iop_data++;
 			iop_len--;
 		}
-		writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK,
-				&reg->inbound_doorbell);
+		arcmsr_iop_message_read(acb);
 	}
 	return (allxfer_len);
 }
 
-static ssize_t
-arcmsr_sysfs_iop_message_write(struct kobject *kobj,
-			       struct bin_attribute *bin_attr,
-			       char *buf, loff_t off, size_t count)
+static ssize_t arcmsr_sysfs_iop_message_write(struct kobject *kobj, char *buf, loff_t off, size_t count)
 {
 	struct class_device *cdev = container_of(kobj,struct class_device,kobj);
 	struct Scsi_Host *host = class_to_shost(cdev);
@@ -126,7 +120,7 @@ arcmsr_sysfs_iop_message_write(struct ko
 	wqbuf_lastindex = acb->wqbuf_lastindex;
 	wqbuf_firstindex = acb->wqbuf_firstindex;
 	if (wqbuf_lastindex != wqbuf_firstindex) {
-		arcmsr_post_Qbuffer(acb);
+		arcmsr_post_ioctldata2iop(acb);
 		return 0;	/*need retry*/
 	} else {
 		my_empty_len = (wqbuf_firstindex-wqbuf_lastindex - 1)
@@ -144,7 +138,7 @@ arcmsr_sysfs_iop_message_write(struct ko
 			if (acb->acb_flags & ACB_F_MESSAGE_WQBUFFER_CLEARED) {
 				acb->acb_flags &=
 					~ACB_F_MESSAGE_WQBUFFER_CLEARED;
-				arcmsr_post_Qbuffer(acb);
+				arcmsr_post_ioctldata2iop(acb);
 			}
 			return count;
 		} else {
@@ -153,15 +147,11 @@ arcmsr_sysfs_iop_message_write(struct ko
 	}
 }
 
-static ssize_t
-arcmsr_sysfs_iop_message_clear(struct kobject *kobj,
-			       struct bin_attribute *bin_attr,
-			       char *buf, loff_t off, size_t count)
+static ssize_t arcmsr_sysfs_iop_message_clear(struct kobject *kobj, char *buf, loff_t off, size_t count)
 {
 	struct class_device *cdev = container_of(kobj,struct class_device,kobj);
 	struct Scsi_Host *host = class_to_shost(cdev);
 	struct AdapterControlBlock *acb = (struct AdapterControlBlock *) host->hostdata;
-	struct MessageUnit __iomem *reg = acb->pmu;
 	uint8_t *pQbuffer;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -169,8 +159,7 @@ arcmsr_sysfs_iop_message_clear(struct ko
 
 	if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
 		acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;
-		writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK
-				, &reg->inbound_doorbell);
+		arcmsr_iop_message_read(acb);
 	}
 	acb->acb_flags |=
 		(ACB_F_MESSAGE_WQBUFFER_CLEARED
@@ -191,6 +180,7 @@ static struct bin_attribute arcmsr_sysfs
 	.attr = {
 		.name = "mu_read",
 		.mode = S_IRUSR ,
+		.owner = THIS_MODULE,
 	},
 	.size = 1032,
 	.read = arcmsr_sysfs_iop_message_read,
@@ -200,6 +190,7 @@ static struct bin_attribute arcmsr_sysfs
 	.attr = {
 		.name = "mu_write",
 		.mode = S_IWUSR,
+		.owner = THIS_MODULE,
 	},
 	.size = 1032,
 	.write = arcmsr_sysfs_iop_message_write,
@@ -209,6 +200,7 @@ static struct bin_attribute arcmsr_sysfs
 	.attr = {
 		.name = "mu_clear",
 		.mode = S_IWUSR,
+		.owner = THIS_MODULE,
 	},
 	.size = 1,
 	.write = arcmsr_sysfs_iop_message_clear,
@@ -219,31 +211,26 @@ int arcmsr_alloc_sysfs_attr(struct Adapt
 	struct Scsi_Host *host = acb->host;
 	int error;
 
-	error = sysfs_create_bin_file(&host->shost_classdev.kobj,
-				&arcmsr_sysfs_message_read_attr);
+	error = sysfs_create_bin_file(&host->shost_classdev.kobj, &arcmsr_sysfs_message_read_attr);
 	if (error) {
 		printk(KERN_ERR "arcmsr: alloc sysfs mu_read failed\n");
 		goto error_bin_file_message_read;
 	}
-	error = sysfs_create_bin_file(&host->shost_classdev.kobj,
-				&arcmsr_sysfs_message_write_attr);
+	error = sysfs_create_bin_file(&host->shost_classdev.kobj, &arcmsr_sysfs_message_write_attr);
 	if (error) {
 		printk(KERN_ERR "arcmsr: alloc sysfs mu_write failed\n");
 		goto error_bin_file_message_write;
 	}
-	error = sysfs_create_bin_file(&host->shost_classdev.kobj,
-				&arcmsr_sysfs_message_clear_attr);
+	error = sysfs_create_bin_file(&host->shost_classdev.kobj, &arcmsr_sysfs_message_clear_attr);
 	if (error) {
 		printk(KERN_ERR "arcmsr: alloc sysfs mu_clear failed\n");
 		goto error_bin_file_message_clear;
 	}
 	return 0;
 error_bin_file_message_clear:
-	sysfs_remove_bin_file(&host->shost_classdev.kobj,
-				&arcmsr_sysfs_message_write_attr);
+	sysfs_remove_bin_file(&host->shost_classdev.kobj, &arcmsr_sysfs_message_write_attr);
 error_bin_file_message_write:
-	sysfs_remove_bin_file(&host->shost_classdev.kobj,
-				&arcmsr_sysfs_message_read_attr);
+	sysfs_remove_bin_file(&host->shost_classdev.kobj, &arcmsr_sysfs_message_read_attr);
 error_bin_file_message_read:
 	return error;
 }
@@ -252,12 +239,9 @@ void
 arcmsr_free_sysfs_attr(struct AdapterControlBlock *acb) {
 	struct Scsi_Host *host = acb->host;
 
-	sysfs_remove_bin_file(&host->shost_classdev.kobj,
-				&arcmsr_sysfs_message_clear_attr);
-	sysfs_remove_bin_file(&host->shost_classdev.kobj,
-				&arcmsr_sysfs_message_write_attr);
-	sysfs_remove_bin_file(&host->shost_classdev.kobj,
-				&arcmsr_sysfs_message_read_attr);
+	sysfs_remove_bin_file(&host->shost_classdev.kobj, &arcmsr_sysfs_message_clear_attr);
+	sysfs_remove_bin_file(&host->shost_classdev.kobj, &arcmsr_sysfs_message_write_attr);
+	sysfs_remove_bin_file(&host->shost_classdev.kobj, &arcmsr_sysfs_message_read_attr);
 }
 
 
diff -puN drivers/scsi/arcmsr/arcmsr_hba.c~scsi-upstream-arcmsr-1200015 drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c~scsi-upstream-arcmsr-1200015
+++ a/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -9,7 +9,7 @@
 ** Copyright (C) 2002 - 2005, Areca Technology Corporation All rights reserved
 **
 **     Web site: www.areca.com.tw
-**       E-mail: erich@areca.com.tw
+**       E-mail: support@areca.com.tw
 **
 ** This program is free software; you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License version 2 as
@@ -71,33 +71,37 @@
 #include <scsi/scsicam.h>
 #include "arcmsr.h"
 
-MODULE_AUTHOR("Erich Chen <erich@areca.com.tw>");
+MODULE_AUTHOR("Erich Chen <support@areca.com.tw>");
 MODULE_DESCRIPTION("ARECA (ARC11xx/12xx/13xx/16xx) SATA/SAS RAID HOST Adapter");
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_VERSION(ARCMSR_DRIVER_VERSION);
 
-static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb, struct scsi_cmnd *cmd);
+static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb,
+					struct scsi_cmnd *cmd);
+static int arcmsr_iop_confirm(struct AdapterControlBlock *acb);
 static int arcmsr_abort(struct scsi_cmnd *);
 static int arcmsr_bus_reset(struct scsi_cmnd *);
 static int arcmsr_bios_param(struct scsi_device *sdev,
-				struct block_device *bdev, sector_t capacity, int *info);
-static int arcmsr_queue_command(struct scsi_cmnd * cmd,
-				void (*done) (struct scsi_cmnd *));
+		struct block_device *bdev, sector_t capacity, int *info);
+static int arcmsr_queue_command(struct scsi_cmnd *cmd,
+					void (*done) (struct scsi_cmnd *));
 static int arcmsr_probe(struct pci_dev *pdev,
 				const struct pci_device_id *id);
 static void arcmsr_remove(struct pci_dev *pdev);
 static void arcmsr_shutdown(struct pci_dev *pdev);
 static void arcmsr_iop_init(struct AdapterControlBlock *acb);
 static void arcmsr_free_ccb_pool(struct AdapterControlBlock *acb);
+static u32 arcmsr_disable_outbound_ints(struct AdapterControlBlock *acb);
 static void arcmsr_stop_adapter_bgrb(struct AdapterControlBlock *acb);
-static void arcmsr_flush_adapter_cache(struct AdapterControlBlock *acb);
-static uint8_t arcmsr_wait_msgint_ready(struct AdapterControlBlock *acb);
+static void arcmsr_flush_hba_cache(struct AdapterControlBlock *acb);
+static void arcmsr_flush_hbb_cache(struct AdapterControlBlock *acb);
 static const char *arcmsr_info(struct Scsi_Host *);
 static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb);
 static pci_ers_result_t arcmsr_pci_error_detected(struct pci_dev *pdev,
 						pci_channel_state_t state);
 static pci_ers_result_t arcmsr_pci_slot_reset(struct pci_dev *pdev);
-static int arcmsr_adjust_disk_queue_depth(struct scsi_device *sdev, int queue_depth)
+static int arcmsr_adjust_disk_queue_depth(struct scsi_device *sdev,
+								int queue_depth)
 {
 	if (queue_depth > ARCMSR_MAX_CMD_PERLUN)
 		queue_depth = ARCMSR_MAX_CMD_PERLUN;
@@ -123,17 +127,21 @@ static struct scsi_host_template arcmsr_
 	.use_clustering		= ENABLE_CLUSTERING,
 	.shost_attrs		= arcmsr_host_attrs,
 };
+#ifdef CONFIG_SCSI_ARCMSR_AER
 static struct pci_error_handlers arcmsr_pci_error_handlers = {
 	.error_detected		= arcmsr_pci_error_detected,
 	.slot_reset		= arcmsr_pci_slot_reset,
 };
-
+#endif
 static struct pci_device_id arcmsr_device_id_table[] = {
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1110)},
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1120)},
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1130)},
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1160)},
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1170)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1200)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1201)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1202)},
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1210)},
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1220)},
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1230)},
@@ -153,20 +161,20 @@ static struct pci_driver arcmsr_pci_driv
 	.probe			= arcmsr_probe,
 	.remove			= arcmsr_remove,
 	.shutdown		= arcmsr_shutdown,
+	#ifdef CONFIG_SCSI_ARCMSR_AER
 	.err_handler		= &arcmsr_pci_error_handlers,
+	#endif
 };
 
 static irqreturn_t arcmsr_do_interrupt(int irq, void *dev_id)
 {
 	irqreturn_t handle_state;
-	struct AdapterControlBlock *acb;
-	unsigned long flags;
-
-	acb = (struct AdapterControlBlock *)dev_id;
+	struct AdapterControlBlock *acb = dev_id;
 
-	spin_lock_irqsave(acb->host->host_lock, flags);
+	spin_lock(acb->host->host_lock);
 	handle_state = arcmsr_interrupt(acb);
-	spin_unlock_irqrestore(acb->host->host_lock, flags);
+	spin_unlock(acb->host->host_lock);
+
 	return handle_state;
 }
 
@@ -198,68 +206,159 @@ static int arcmsr_bios_param(struct scsi
 	return 0;
 }
 
-static int arcmsr_alloc_ccb_pool(struct AdapterControlBlock *acb)
+static void arcmsr_define_adapter_type(struct AdapterControlBlock *acb)
 {
 	struct pci_dev *pdev = acb->pdev;
-	struct MessageUnit __iomem *reg = acb->pmu;
-	u32 ccb_phyaddr_hi32;
-	void *dma_coherent;
-	dma_addr_t dma_coherent_handle, dma_addr;
-	struct CommandControlBlock *ccb_tmp;
-	int i, j;
+	u16 dev_id;
+	pci_read_config_word(pdev, PCI_DEVICE_ID, &dev_id);
+	switch(dev_id) {
+	case 0x1201 : {
+		acb->adapter_type = ACB_ADAPTER_TYPE_B;
+		}
+		break;
+
+	default : acb->adapter_type = ACB_ADAPTER_TYPE_A;
+	}
+}
+
+static int arcmsr_alloc_ccb_pool(struct AdapterControlBlock *acb)
+{
+
+	switch (acb->adapter_type) {
 
-	dma_coherent = dma_alloc_coherent(&pdev->dev,
+	case ACB_ADAPTER_TYPE_A: {
+		struct pci_dev *pdev = acb->pdev;
+		void *dma_coherent;
+		dma_addr_t dma_coherent_handle, dma_addr;
+		struct CommandControlBlock *ccb_tmp;
+		uint32_t intmask_org;
+		int i, j;
+
+		acb->pmu = ioremap(pci_resource_start(pdev,0), pci_resource_len(pdev,0));
+		if (!acb->pmu) {
+			printk(KERN_NOTICE "arcmsr%d: memory mapping region fail \n",
+							acb->host->host_no);
+		}
+
+		dma_coherent = dma_alloc_coherent(&pdev->dev,
 			ARCMSR_MAX_FREECCB_NUM *
 			sizeof (struct CommandControlBlock) + 0x20,
 			&dma_coherent_handle, GFP_KERNEL);
-	if (!dma_coherent)
-		return -ENOMEM;
+		if (!dma_coherent)
+			return -ENOMEM;
 
-	acb->dma_coherent = dma_coherent;
-	acb->dma_coherent_handle = dma_coherent_handle;
+		acb->dma_coherent = dma_coherent;
+		acb->dma_coherent_handle = dma_coherent_handle;
 
-	if (((unsigned long)dma_coherent & 0x1F)) {
-		dma_coherent = dma_coherent +
-			(0x20 - ((unsigned long)dma_coherent & 0x1F));
-		dma_coherent_handle = dma_coherent_handle +
-			(0x20 - ((unsigned long)dma_coherent_handle & 0x1F));
-	}
+		if (((unsigned long)dma_coherent & 0x1F)) {
+			dma_coherent = dma_coherent +
+				(0x20 - ((unsigned long)dma_coherent & 0x1F));
+			dma_coherent_handle = dma_coherent_handle +
+				(0x20 - ((unsigned long)dma_coherent_handle & 0x1F));
+		}
 
-	dma_addr = dma_coherent_handle;
-	ccb_tmp = (struct CommandControlBlock *)dma_coherent;
-	for (i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
-		ccb_tmp->cdb_shifted_phyaddr = dma_addr >> 5;
-		ccb_tmp->acb = acb;
-		acb->pccb_pool[i] = ccb_tmp;
-		list_add_tail(&ccb_tmp->list, &acb->ccb_free_list);
-		dma_addr = dma_addr + sizeof (struct CommandControlBlock);
-		ccb_tmp++;
-	}
+		dma_addr = dma_coherent_handle;
+		ccb_tmp = (struct CommandControlBlock *)dma_coherent;
+		for (i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
+			ccb_tmp->cdb_shifted_phyaddr = dma_addr >> 5;
+			ccb_tmp->acb = acb;
+			acb->pccb_pool[i] = ccb_tmp;
+			list_add_tail(&ccb_tmp->list, &acb->ccb_free_list);
+			dma_addr = dma_addr + sizeof (struct CommandControlBlock);
+			ccb_tmp++;
+		}
 
-	acb->vir2phy_offset = (unsigned long)ccb_tmp -
-			      (unsigned long)dma_addr;
-	for (i = 0; i < ARCMSR_MAX_TARGETID; i++)
-		for (j = 0; j < ARCMSR_MAX_TARGETLUN; j++)
-			acb->devstate[i][j] = ARECA_RAID_GOOD;
+		acb->vir2phy_offset = (unsigned long)ccb_tmp -(unsigned long)dma_addr;
+		for (i = 0; i < ARCMSR_MAX_TARGETID; i++)
+			for (j = 0; j < ARCMSR_MAX_TARGETLUN; j++)
+				acb->devstate[i][j] = ARECA_RAID_GONE;
 
-	/*
-	** here we need to tell iop 331 our ccb_tmp.HighPart
-	** if ccb_tmp.HighPart is not zero
-	*/
-	ccb_phyaddr_hi32 = (uint32_t) ((dma_coherent_handle >> 16) >> 16);
-	if (ccb_phyaddr_hi32 != 0) {
-		writel(ARCMSR_SIGNATURE_SET_CONFIG, &reg->message_rwbuffer[0]);
-		writel(ccb_phyaddr_hi32, &reg->message_rwbuffer[1]);
-		writel(ARCMSR_INBOUND_MESG0_SET_CONFIG, &reg->inbound_msgaddr0);
-		if (arcmsr_wait_msgint_ready(acb))
-			printk(KERN_NOTICE "arcmsr%d: "
-			       "'set ccb high part physical address' timeout\n",
-				acb->host->host_no);
-	}
+		/*
+		** here we need to tell iop 331 our ccb_tmp.HighPart
+		** if ccb_tmp.HighPart is not zero
+		*/
+		intmask_org = arcmsr_disable_outbound_ints(acb);
+		}
+		break;
+
+	case ACB_ADAPTER_TYPE_B: {
+
+		struct pci_dev *pdev = acb->pdev;
+		struct MessageUnit_B *reg;
+		void *mem_base0, *mem_base1;
+		void *dma_coherent;
+		dma_addr_t dma_coherent_handle, dma_addr;
+		uint32_t intmask_org;
+		struct CommandControlBlock *ccb_tmp;
+		int i, j;
+
+		dma_coherent = dma_alloc_coherent(&pdev->dev,
+			((ARCMSR_MAX_FREECCB_NUM *
+			sizeof (struct CommandControlBlock) + 0x20) +
+			sizeof(struct MessageUnit_B)),
+			&dma_coherent_handle, GFP_KERNEL);
+		if (!dma_coherent)
+			return -ENOMEM;
+
+		acb->dma_coherent = dma_coherent;
+		acb->dma_coherent_handle = dma_coherent_handle;
+
+		if (((unsigned long)dma_coherent & 0x1F)) {
+			dma_coherent = dma_coherent +
+				(0x20 - ((unsigned long)dma_coherent & 0x1F));
+			dma_coherent_handle = dma_coherent_handle +
+				(0x20 - ((unsigned long)dma_coherent_handle & 0x1F));
+		}
+
+		reg = (struct MessageUnit_B *)(dma_coherent +
+		ARCMSR_MAX_FREECCB_NUM * sizeof (struct CommandControlBlock));
+
+		dma_addr = dma_coherent_handle;
+		ccb_tmp = (struct CommandControlBlock *)dma_coherent;
+		for (i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
+			ccb_tmp->cdb_shifted_phyaddr = dma_addr >> 5;
+			ccb_tmp->acb = acb;
+			acb->pccb_pool[i] = ccb_tmp;
+			list_add_tail(&ccb_tmp->list, &acb->ccb_free_list);
+			dma_addr = dma_addr + sizeof (struct CommandControlBlock);
+			ccb_tmp++;
+		}
+
+		reg = (struct MessageUnit_B *)(dma_coherent +
+		ARCMSR_MAX_FREECCB_NUM * sizeof (struct CommandControlBlock));
+		acb->pmu = (struct MessageUnit_B *)reg;
+		mem_base0 = ioremap(pci_resource_start(pdev, 0),
+					pci_resource_len(pdev, 0));
+		mem_base1 = ioremap(pci_resource_start(pdev, 2),
+					pci_resource_len(pdev, 2));
+		reg->drv2iop_doorbell_reg = (uint32_t *)((char *)mem_base0 +
+						ARCMSR_DRV2IOP_DOORBELL);
+		reg->drv2iop_doorbell_mask_reg = (uint32_t *)((char *)mem_base0 +
+						ARCMSR_DRV2IOP_DOORBELL_MASK);
+		reg->iop2drv_doorbell_reg = (uint32_t *)((char *)mem_base0 +
+							ARCMSR_IOP2DRV_DOORBELL);
+		reg->iop2drv_doorbell_mask_reg = (uint32_t *)((char *)mem_base0 +
+						ARCMSR_IOP2DRV_DOORBELL_MASK);
+		reg->ioctl_wbuffer_reg = (uint32_t *)((char *)mem_base1 +
+							ARCMSR_IOCTL_WBUFFER);
+		reg->ioctl_rbuffer_reg = (uint32_t *)((char *)mem_base1 +
+							ARCMSR_IOCTL_RBUFFER);
+		reg->msgcode_rwbuffer_reg = (uint32_t *)((char *)mem_base1 +
+							ARCMSR_MSGCODE_RWBUFFER);
+
+		acb->vir2phy_offset = (unsigned long)ccb_tmp -(unsigned long)dma_addr;
+		for (i = 0; i < ARCMSR_MAX_TARGETID; i++)
+			for (j = 0; j < ARCMSR_MAX_TARGETLUN; j++)
+				acb->devstate[i][j] = ARECA_RAID_GOOD;
 
-	writel(readl(&reg->outbound_intmask) |
-			ARCMSR_MU_OUTBOUND_ALL_INTMASKENABLE,
-	       &reg->outbound_intmask);
+		/*
+		** here we need to tell iop 331 our ccb_tmp.HighPart
+		** if ccb_tmp.HighPart is not zero
+		*/
+		intmask_org = arcmsr_disable_outbound_ints(acb);
+		}
+		break;
+	}
 	return 0;
 }
 
@@ -310,16 +409,11 @@ static int arcmsr_probe(struct pci_dev *
 	host->unique_id = (bus << 8) | dev_fun;
 	host->irq = pdev->irq;
 	error = pci_request_regions(pdev, "arcmsr");
-	if (error)
+	if (error) {
 		goto out_host_put;
-
-	acb->pmu = ioremap(pci_resource_start(pdev, 0),
-			   pci_resource_len(pdev, 0));
-	if (!acb->pmu) {
-		printk(KERN_NOTICE "arcmsr%d: memory"
-			" mapping region fail \n", acb->host->host_no);
-		goto out_release_regions;
 	}
+	arcmsr_define_adapter_type(acb);
+
 	acb->acb_flags |= (ACB_F_MESSAGE_WQBUFFER_CLEARED |
 			   ACB_F_MESSAGE_RQBUFFER_CLEARED |
 			   ACB_F_MESSAGE_WQBUFFER_READED);
@@ -328,10 +422,10 @@ static int arcmsr_probe(struct pci_dev *
 
 	error = arcmsr_alloc_ccb_pool(acb);
 	if (error)
-		goto out_iounmap;
+		goto out_release_regions;
 
 	error = request_irq(pdev->irq, arcmsr_do_interrupt,
-			IRQF_DISABLED | IRQF_SHARED, "arcmsr", acb);
+				IRQF_SHARED, "arcmsr", acb);
 	if (error)
 		goto out_free_ccb_pool;
 
@@ -349,14 +443,15 @@ static int arcmsr_probe(struct pci_dev *
 		goto out_free_sysfs;
 
 	scsi_scan_host(host);
+	#ifdef CONFIG_SCSI_ARCMSR_AER
 	pci_enable_pcie_error_reporting(pdev);
+	#endif
 	return 0;
  out_free_sysfs:
  out_free_irq:
 	free_irq(pdev->irq, acb);
  out_free_ccb_pool:
 	arcmsr_free_ccb_pool(acb);
- out_iounmap:
 	iounmap(acb->pmu);
  out_release_regions:
 	pci_release_regions(pdev);
@@ -368,17 +463,84 @@ static int arcmsr_probe(struct pci_dev *
 	return error;
 }
 
-static void arcmsr_abort_allcmd(struct AdapterControlBlock *acb)
+static uint8_t arcmsr_hba_wait_msgint_ready(struct AdapterControlBlock *acb)
+{
+	struct MessageUnit_A __iomem *reg = (struct MessageUnit_A *)acb->pmu;
+	uint32_t Index;
+	uint8_t Retries = 0x00;
+
+	do {
+		for (Index = 0; Index < 100; Index++) {
+			if (readl(&reg->outbound_intstatus) &
+					ARCMSR_MU_OUTBOUND_MESSAGE0_INT) {
+				writel(ARCMSR_MU_OUTBOUND_MESSAGE0_INT,
+					&reg->outbound_intstatus);
+				return 0x00;
+			}
+			msleep(10);
+		}/*max 1 seconds*/
+
+	} while (Retries++ < 20);/*max 20 sec*/
+	return 0xff;
+}
+
+static uint8_t arcmsr_hbb_wait_msgint_ready(struct AdapterControlBlock *acb)
+{
+	struct MessageUnit_B *reg = (struct MessageUnit_B *)acb->pmu;
+	uint32_t Index;
+	uint8_t Retries = 0x00;
+
+	do {
+		for (Index = 0; Index < 100; Index++) {
+			if (readl(reg->iop2drv_doorbell_reg)
+				& ARCMSR_IOP2DRV_MESSAGE_CMD_DONE) {
+				writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN
+					, reg->iop2drv_doorbell_reg);
+				return 0x00;
+			}
+			msleep(10);
+		}/*max 1 seconds*/
+
+	} while (Retries++ < 20);/*max 20 sec*/
+	return 0xff;
+}
+
+static void arcmsr_abort_hba_allcmd(struct AdapterControlBlock *acb)
 {
-	struct MessageUnit __iomem *reg = acb->pmu;
+	struct MessageUnit_A __iomem *reg = (struct MessageUnit_A *)acb->pmu;
 
 	writel(ARCMSR_INBOUND_MESG0_ABORT_CMD, &reg->inbound_msgaddr0);
-	if (arcmsr_wait_msgint_ready(acb))
+	if (arcmsr_hba_wait_msgint_ready(acb))
+		printk(KERN_NOTICE
+			"arcmsr%d: wait 'abort all outstanding command' timeout \n"
+			, acb->host->host_no);
+}
+
+static void arcmsr_abort_hbb_allcmd(struct AdapterControlBlock *acb)
+{
+	struct MessageUnit_B *reg = (struct MessageUnit_B *)acb->pmu;
+
+	writel(ARCMSR_MESSAGE_ABORT_CMD, reg->drv2iop_doorbell_reg);
+	if (arcmsr_hbb_wait_msgint_ready(acb))
 		printk(KERN_NOTICE
 			"arcmsr%d: wait 'abort all outstanding command' timeout \n"
 			, acb->host->host_no);
 }
 
+static void arcmsr_abort_allcmd(struct AdapterControlBlock *acb)
+{
+	switch (acb->adapter_type) {
+	case ACB_ADAPTER_TYPE_A: {
+		arcmsr_abort_hba_allcmd(acb);
+		}
+		break;
+
+	case ACB_ADAPTER_TYPE_B: {
+		arcmsr_abort_hbb_allcmd(acb);
+		}
+	}
+}
+
 static void arcmsr_pci_unmap_dma(struct CommandControlBlock *ccb)
 {
 	struct scsi_cmnd *pcmd = ccb->pcmd;
@@ -400,28 +562,239 @@ static void arcmsr_ccb_complete(struct C
 	pcmd->scsi_done(pcmd);
 }
 
+static void arcmsr_flush_hba_cache(struct AdapterControlBlock *acb)
+{
+	struct MessageUnit_A __iomem *reg = (struct MessageUnit_A *)acb->pmu;
+	int retry_count = 30;
+
+	writel(ARCMSR_INBOUND_MESG0_FLUSH_CACHE, &reg->inbound_msgaddr0);
+	do {
+		if (!arcmsr_hba_wait_msgint_ready(acb))
+			break;
+		else {
+			retry_count--;
+			printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter cache' \
+			timeout, retry count down = %d \n", acb->host->host_no, retry_count);
+		}
+	} while (retry_count != 0);
+}
+
+static void arcmsr_flush_hbb_cache(struct AdapterControlBlock *acb)
+{
+	struct MessageUnit_B *reg = (struct MessageUnit_B *)acb->pmu;
+	int retry_count = 30;
+
+	writel(ARCMSR_MESSAGE_FLUSH_CACHE, reg->drv2iop_doorbell_reg);
+	do {
+		if (!arcmsr_hbb_wait_msgint_ready(acb))
+			break;
+		else {
+			retry_count--;
+			printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter cache' \
+			timeout,retry count down = %d \n", acb->host->host_no, retry_count);
+		}
+	} while (retry_count != 0);
+}
+
+static void arcmsr_flush_adapter_cache(struct AdapterControlBlock *acb)
+{
+	switch (acb->adapter_type) {
+
+	case ACB_ADAPTER_TYPE_A: {
+		arcmsr_flush_hba_cache(acb);
+		}
+		break;
+
+	case ACB_ADAPTER_TYPE_B: {
+		arcmsr_flush_hbb_cache(acb);
+		}
+	}
+}
+
+static void arcmsr_report_sense_info(struct CommandControlBlock *ccb)
+{
+
+	struct scsi_cmnd *pcmd = ccb->pcmd;
+	struct SENSE_DATA *sensebuffer = (struct SENSE_DATA *)pcmd->sense_buffer;
+
+	pcmd->result = DID_OK << 16;
+	if (sensebuffer) {
+		int sense_data_length =
+			sizeof (struct SENSE_DATA) < sizeof (pcmd->sense_buffer)
+			? sizeof (struct SENSE_DATA) : sizeof (pcmd->sense_buffer);
+		memset(sensebuffer, 0, sizeof (pcmd->sense_buffer));
+		memcpy(sensebuffer, ccb->arcmsr_cdb.SenseData, sense_data_length);
+		sensebuffer->ErrorCode = SCSI_SENSE_CURRENT_ERRORS;
+		sensebuffer->Valid = 1;
+	}
+}
+
+static u32 arcmsr_disable_outbound_ints(struct AdapterControlBlock *acb)
+{
+	u32 orig_mask = 0;
+	switch(acb->adapter_type) {
+
+	case ACB_ADAPTER_TYPE_A : {
+		struct MessageUnit_A __iomem *reg = (struct MessageUnit_A *)acb->pmu;
+		orig_mask = readl(&reg->outbound_intmask)|\
+				ARCMSR_MU_OUTBOUND_MESSAGE0_INTMASKENABLE;
+		writel(orig_mask|ARCMSR_MU_OUTBOUND_ALL_INTMASKENABLE, \
+						&reg->outbound_intmask);
+		}
+		break;
+
+	case ACB_ADAPTER_TYPE_B : {
+		struct MessageUnit_B *reg = (struct MessageUnit_B *)acb->pmu;
+		orig_mask = readl(reg->iop2drv_doorbell_mask_reg) & \
+					(~ARCMSR_IOP2DRV_MESSAGE_CMD_DONE);
+		writel(0, reg->iop2drv_doorbell_mask_reg);
+		}
+		break;
+	}
+	return orig_mask;
+}
+
+static void arcmsr_report_ccb_state(struct AdapterControlBlock *acb, \
+			struct CommandControlBlock *ccb, uint32_t flag_ccb)
+{
+
+	uint8_t id, lun;
+	id = ccb->pcmd->device->id;
+	lun = ccb->pcmd->device->lun;
+	if (!(flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR)) {
+		if (acb->devstate[id][lun] == ARECA_RAID_GONE)
+			acb->devstate[id][lun] = ARECA_RAID_GOOD;
+			ccb->pcmd->result = DID_OK << 16;
+			arcmsr_ccb_complete(ccb, 1);
+	} else {
+		switch(ccb->arcmsr_cdb.DeviceStatus) {
+		case ARCMSR_DEV_SELECT_TIMEOUT: {
+			acb->devstate[id][lun] = ARECA_RAID_GONE;
+			ccb->pcmd->result = DID_NO_CONNECT << 16;
+			arcmsr_ccb_complete(ccb, 1);
+			}
+			break;
+
+		case ARCMSR_DEV_ABORTED:
+
+		case ARCMSR_DEV_INIT_FAIL: {
+			acb->devstate[id][lun] = ARECA_RAID_GONE;
+			ccb->pcmd->result = DID_BAD_TARGET << 16;
+			arcmsr_ccb_complete(ccb, 1);
+			}
+			break;
+
+		case ARCMSR_DEV_CHECK_CONDITION: {
+			acb->devstate[id][lun] = ARECA_RAID_GOOD;
+			arcmsr_report_sense_info(ccb);
+			arcmsr_ccb_complete(ccb, 1);
+			}
+			break;
+
+		default:
+				printk(KERN_NOTICE
+					"arcmsr%d: scsi id = %d lun = %d"
+					" isr get command error done, "
+					"but got unknown DeviceStatus = 0x%x \n"
+					, acb->host->host_no
+					, id
+					, lun
+					, ccb->arcmsr_cdb.DeviceStatus);
+					acb->devstate[id][lun] = ARECA_RAID_GONE;
+					ccb->pcmd->result = DID_NO_CONNECT << 16;
+					arcmsr_ccb_complete(ccb, 1);
+			break;
+		}
+	}
+}
+
+static void arcmsr_drain_donequeue(struct AdapterControlBlock *acb, uint32_t flag_ccb)
+
+{
+	struct CommandControlBlock *ccb;
+
+	ccb = (struct CommandControlBlock *)(acb->vir2phy_offset + (flag_ccb << 5));
+	if ((ccb->acb != acb) || (ccb->startdone != ARCMSR_CCB_START)) {
+		if (ccb->startdone == ARCMSR_CCB_ABORTED) {
+			struct scsi_cmnd *abortcmd = ccb->pcmd;
+			if (abortcmd) {
+				abortcmd->result |= DID_ABORT << 16;
+				arcmsr_ccb_complete(ccb, 1);
+				printk(KERN_NOTICE "arcmsr%d: ccb ='0x%p' \
+				isr got aborted command \n", acb->host->host_no, ccb);
+			}
+		}
+		printk(KERN_NOTICE "arcmsr%d: isr get an illegal ccb command \
+				done acb = '0x%p'"
+				"ccb = '0x%p' ccbacb = '0x%p' startdone = 0x%x"
+				" ccboutstandingcount = %d \n"
+				, acb->host->host_no
+				, acb
+				, ccb
+				, ccb->acb
+				, ccb->startdone
+				, atomic_read(&acb->ccboutstandingcount));
+		}
+	arcmsr_report_ccb_state(acb, ccb, flag_ccb);
+}
+
+static void arcmsr_done4abort_postqueue(struct AdapterControlBlock *acb)
+{
+	int i = 0;
+	uint32_t flag_ccb;
+
+	switch (acb->adapter_type) {
+
+	case ACB_ADAPTER_TYPE_A: {
+		struct MessageUnit_A __iomem *reg = \
+			(struct MessageUnit_A *)acb->pmu;
+		uint32_t outbound_intstatus;
+		outbound_intstatus = readl(&reg->outbound_intstatus) & \
+					acb->outbound_int_enable;
+		/*clear and abort all outbound posted Q*/
+		writel(outbound_intstatus, &reg->outbound_intstatus);/*clear interrupt*/
+		while (((flag_ccb = readl(&reg->outbound_queueport)) != 0xFFFFFFFF) \
+				&& (i++ < ARCMSR_MAX_OUTSTANDING_CMD)) {
+			arcmsr_drain_donequeue(acb, flag_ccb);
+		}
+		}
+		break;
+
+	case ACB_ADAPTER_TYPE_B: {
+		struct MessageUnit_B *reg = (struct MessageUnit_B *)acb->pmu;
+		/*clear all outbound posted Q*/
+		for (i = 0; i < ARCMSR_MAX_HBB_POSTQUEUE; i++) {
+			if ((flag_ccb = readl(&reg->done_qbuffer[i]))!= 0) {
+				writel(0, &reg->done_qbuffer[i]);
+				arcmsr_drain_donequeue(acb,flag_ccb);
+			}
+			writel(0, &reg->post_qbuffer[i]);
+		}
+		reg->doneq_index = 0;
+		reg->postq_index = 0;
+		}
+		break;
+	}
+}
 static void arcmsr_remove(struct pci_dev *pdev)
 {
 	struct Scsi_Host *host = pci_get_drvdata(pdev);
 	struct AdapterControlBlock *acb =
 		(struct AdapterControlBlock *) host->hostdata;
-	struct MessageUnit __iomem *reg = acb->pmu;
 	int poll_count = 0;
 
 	arcmsr_free_sysfs_attr(acb);
 	scsi_remove_host(host);
 	arcmsr_stop_adapter_bgrb(acb);
 	arcmsr_flush_adapter_cache(acb);
-	writel(readl(&reg->outbound_intmask) |
-		ARCMSR_MU_OUTBOUND_ALL_INTMASKENABLE,
-		&reg->outbound_intmask);
+	arcmsr_disable_outbound_ints(acb);
 	acb->acb_flags |= ACB_F_SCSISTOPADAPTER;
 	acb->acb_flags &= ~ACB_F_IOP_INITED;
 
-	for (poll_count = 0; poll_count < 256; poll_count++) {
+	for (poll_count = 0; poll_count < ARCMSR_MAX_OUTSTANDING_CMD; poll_count++) {
 		if (!atomic_read(&acb->ccboutstandingcount))
 			break;
-		arcmsr_interrupt(acb);
+		arcmsr_interrupt(acb);/* FIXME: need spinlock */
 		msleep(25);
 	}
 
@@ -429,8 +802,7 @@ static void arcmsr_remove(struct pci_dev
 		int i;
 
 		arcmsr_abort_allcmd(acb);
-		for (i = 0; i < ARCMSR_MAX_OUTSTANDING_CMD; i++)
-			readl(&reg->outbound_queueport);
+		arcmsr_done4abort_postqueue(acb);
 		for (i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
 			struct CommandControlBlock *ccb = acb->pccb_pool[i];
 			if (ccb->startdone == ARCMSR_CCB_START) {
@@ -477,96 +849,53 @@ static void arcmsr_module_exit(void)
 module_init(arcmsr_module_init);
 module_exit(arcmsr_module_exit);
 
-static u32 arcmsr_disable_outbound_ints(struct AdapterControlBlock *acb)
-{
-	struct MessageUnit __iomem *reg = acb->pmu;
-	u32 orig_mask = readl(&reg->outbound_intmask);
-
-	writel(orig_mask | ARCMSR_MU_OUTBOUND_ALL_INTMASKENABLE,
-			&reg->outbound_intmask);
-	return orig_mask;
-}
-
-static void arcmsr_enable_outbound_ints(struct AdapterControlBlock *acb,
-		u32 orig_mask)
+static void arcmsr_enable_outbound_ints(struct AdapterControlBlock *acb, \
+						u32 intmask_org)
 {
-	struct MessageUnit __iomem *reg = acb->pmu;
 	u32 mask;
 
-	mask = orig_mask & ~(ARCMSR_MU_OUTBOUND_POSTQUEUE_INTMASKENABLE |
+	switch (acb->adapter_type) {
+
+	case ACB_ADAPTER_TYPE_A : {
+		struct MessageUnit_A __iomem *reg = (struct MessageUnit_A *)acb->pmu;
+		mask = intmask_org & ~(ARCMSR_MU_OUTBOUND_POSTQUEUE_INTMASKENABLE |
 			     ARCMSR_MU_OUTBOUND_DOORBELL_INTMASKENABLE);
-	writel(mask, &reg->outbound_intmask);
+		writel(mask, &reg->outbound_intmask);
+		acb->outbound_int_enable = ~(intmask_org & mask) & 0x000000ff;
+		}
+		break;
+
+	case ACB_ADAPTER_TYPE_B : {
+		struct MessageUnit_B *reg = (struct MessageUnit_B *)acb->pmu;
+		mask = intmask_org | (ARCMSR_IOP2DRV_DATA_WRITE_OK | \
+			ARCMSR_IOP2DRV_DATA_READ_OK | ARCMSR_IOP2DRV_CDB_DONE);
+		writel(mask, reg->iop2drv_doorbell_mask_reg);
+		acb->outbound_int_enable = (intmask_org | mask) & 0x0000000f;
+		}
+	}
 }
 
-static void arcmsr_flush_adapter_cache(struct AdapterControlBlock *acb)
+static void arcmsr_build_ccb(struct AdapterControlBlock *acb,
+	struct CommandControlBlock *ccb, struct scsi_cmnd *pcmd)
 {
-	struct MessageUnit __iomem *reg = acb->pmu;
+	struct ARCMSR_CDB *arcmsr_cdb = (struct ARCMSR_CDB *)&ccb->arcmsr_cdb;
+	int8_t *psge = (int8_t *)&arcmsr_cdb->u;
+	uint32_t address_lo, address_hi;
+	int arccdbsize = 0x30;
+	int nseg;
 
-	writel(ARCMSR_INBOUND_MESG0_FLUSH_CACHE, &reg->inbound_msgaddr0);
-	if (arcmsr_wait_msgint_ready(acb))
-		printk(KERN_NOTICE
-			"arcmsr%d: wait 'flush adapter cache' timeout \n"
-			, acb->host->host_no);
-}
+	ccb->pcmd = pcmd;
+	memset(arcmsr_cdb, 0, sizeof (struct ARCMSR_CDB));
+	arcmsr_cdb->Bus = 0;
+	arcmsr_cdb->TargetID = pcmd->device->id;
+	arcmsr_cdb->LUN = pcmd->device->lun;
+	arcmsr_cdb->Function = 1;
+	arcmsr_cdb->CdbLength = (uint8_t)pcmd->cmd_len;
+	arcmsr_cdb->Context = (unsigned long)arcmsr_cdb;
+	memcpy(arcmsr_cdb->Cdb, pcmd->cmnd, pcmd->cmd_len);
 
-static void arcmsr_report_sense_info(struct CommandControlBlock *ccb)
-{
-	struct scsi_cmnd *pcmd = ccb->pcmd;
-	struct SENSE_DATA *sensebuffer = (struct SENSE_DATA *)pcmd->sense_buffer;
-
-	pcmd->result = DID_OK << 16;
-	if (sensebuffer) {
-		int sense_data_length =
-			sizeof (struct SENSE_DATA) < sizeof (pcmd->sense_buffer)
-			? sizeof (struct SENSE_DATA) : sizeof (pcmd->sense_buffer);
-		memset(sensebuffer, 0, sizeof (pcmd->sense_buffer));
-		memcpy(sensebuffer, ccb->arcmsr_cdb.SenseData, sense_data_length);
-		sensebuffer->ErrorCode = SCSI_SENSE_CURRENT_ERRORS;
-		sensebuffer->Valid = 1;
-	}
-}
-
-static uint8_t arcmsr_wait_msgint_ready(struct AdapterControlBlock *acb)
-{
-	struct MessageUnit __iomem *reg = acb->pmu;
-	uint32_t Index;
-	uint8_t Retries = 0x00;
-
-	do {
-		for (Index = 0; Index < 100; Index++) {
-			if (readl(&reg->outbound_intstatus)
-				& ARCMSR_MU_OUTBOUND_MESSAGE0_INT) {
-				writel(ARCMSR_MU_OUTBOUND_MESSAGE0_INT
-					, &reg->outbound_intstatus);
-				return 0x00;
-			}
-			msleep_interruptible(10);
-		}/*max 1 seconds*/
-	} while (Retries++ < 20);/*max 20 sec*/
-	return 0xff;
-}
-
-static void arcmsr_build_ccb(struct AdapterControlBlock *acb,
-	struct CommandControlBlock *ccb, struct scsi_cmnd *pcmd)
-{
-	struct ARCMSR_CDB *arcmsr_cdb = (struct ARCMSR_CDB *)&ccb->arcmsr_cdb;
-	int8_t *psge = (int8_t *)&arcmsr_cdb->u;
-	uint32_t address_lo, address_hi;
-	int arccdbsize = 0x30;
-	int nseg;
-
-	ccb->pcmd = pcmd;
-	memset(arcmsr_cdb, 0, sizeof (struct ARCMSR_CDB));
-	arcmsr_cdb->Bus = 0;
-	arcmsr_cdb->TargetID = pcmd->device->id;
-	arcmsr_cdb->LUN = pcmd->device->lun;
-	arcmsr_cdb->Function = 1;
-	arcmsr_cdb->CdbLength = (uint8_t)pcmd->cmd_len;
-	arcmsr_cdb->Context = (unsigned long)arcmsr_cdb;
-	memcpy(arcmsr_cdb->Cdb, pcmd->cmnd, pcmd->cmd_len);
-
-	nseg = scsi_dma_map(pcmd);
-	BUG_ON(nseg < 0);
+	nseg = scsi_dma_map(pcmd);
+	BUG_ON(nseg < 0);
 
 	if (nseg) {
 		int length, i, cdb_sgcount = 0;
@@ -609,52 +938,85 @@ static void arcmsr_build_ccb(struct Adap
 
 static void arcmsr_post_ccb(struct AdapterControlBlock *acb, struct CommandControlBlock *ccb)
 {
-	struct MessageUnit __iomem *reg = acb->pmu;
 	uint32_t cdb_shifted_phyaddr = ccb->cdb_shifted_phyaddr;
 	struct ARCMSR_CDB *arcmsr_cdb = (struct ARCMSR_CDB *)&ccb->arcmsr_cdb;
-
 	atomic_inc(&acb->ccboutstandingcount);
 	ccb->startdone = ARCMSR_CCB_START;
-	if (arcmsr_cdb->Flags & ARCMSR_CDB_FLAG_SGL_BSIZE)
-		writel(cdb_shifted_phyaddr | ARCMSR_CCBPOST_FLAG_SGL_BSIZE,
+
+	switch (acb->adapter_type) {
+	case ACB_ADAPTER_TYPE_A: {
+		struct MessageUnit_A *reg = (struct MessageUnit_A *)acb->pmu;
+
+		if (arcmsr_cdb->Flags & ARCMSR_CDB_FLAG_SGL_BSIZE)
+			writel(cdb_shifted_phyaddr | ARCMSR_CCBPOST_FLAG_SGL_BSIZE,
 			&reg->inbound_queueport);
-	else
-		writel(cdb_shifted_phyaddr, &reg->inbound_queueport);
+		else {
+				writel(cdb_shifted_phyaddr, &reg->inbound_queueport);
+		}
+		}
+		break;
+
+	case ACB_ADAPTER_TYPE_B: {
+		struct MessageUnit_B *reg = (struct MessageUnit_B *)acb->pmu;
+		uint32_t ending_index, index = reg->postq_index;
+
+		ending_index = ((index + 1) % ARCMSR_MAX_HBB_POSTQUEUE);
+		writel(0,&reg->post_qbuffer[ending_index]);
+		if (arcmsr_cdb->Flags & ARCMSR_CDB_FLAG_SGL_BSIZE) {
+			writel(cdb_shifted_phyaddr | ARCMSR_CCBPOST_FLAG_SGL_BSIZE,\
+						 &reg->post_qbuffer[index]);
+		}
+		else {
+			writel(cdb_shifted_phyaddr, &reg->post_qbuffer[index]);
+		}
+		index++;
+		index %= ARCMSR_MAX_HBB_POSTQUEUE;/*if last index number set it to 0 */
+		reg->postq_index = index;
+		writel(ARCMSR_DRV2IOP_CDB_POSTED, reg->drv2iop_doorbell_reg);
+		}
+		break;
+	}
 }
 
-void arcmsr_post_Qbuffer(struct AdapterControlBlock *acb)
+static void arcmsr_stop_hba_bgrb(struct AdapterControlBlock *acb)
 {
-	struct MessageUnit __iomem *reg = acb->pmu;
-	struct QBUFFER __iomem *pwbuffer = (struct QBUFFER __iomem *) &reg->message_wbuffer;
-	uint8_t __iomem *iop_data = (uint8_t __iomem *) pwbuffer->data;
-	int32_t allxfer_len = 0;
+	struct MessageUnit_A __iomem *reg = (struct MessageUnit_A *)acb->pmu;
+	acb->acb_flags &= ~ACB_F_MSG_START_BGRB;
+	writel(ARCMSR_INBOUND_MESG0_STOP_BGRB, &reg->inbound_msgaddr0);
 
-	if (acb->acb_flags & ACB_F_MESSAGE_WQBUFFER_READED) {
-		acb->acb_flags &= (~ACB_F_MESSAGE_WQBUFFER_READED);
-		while ((acb->wqbuf_firstindex != acb->wqbuf_lastindex)
-			&& (allxfer_len < 124)) {
-			writeb(acb->wqbuffer[acb->wqbuf_firstindex], iop_data);
-			acb->wqbuf_firstindex++;
-			acb->wqbuf_firstindex %= ARCMSR_MAX_QBUFFER;
-			iop_data++;
-			allxfer_len++;
-		}
-		writel(allxfer_len, &pwbuffer->data_len);
-		writel(ARCMSR_INBOUND_DRIVER_DATA_WRITE_OK
-			, &reg->inbound_doorbell);
+	if (arcmsr_hba_wait_msgint_ready(acb)) {
+		printk(KERN_NOTICE
+			"arcmsr%d: wait 'stop adapter background rebulid' timeout \n"
+			, acb->host->host_no);
 	}
 }
 
-static void arcmsr_stop_adapter_bgrb(struct AdapterControlBlock *acb)
+static void arcmsr_stop_hbb_bgrb(struct AdapterControlBlock *acb)
 {
-	struct MessageUnit __iomem *reg = acb->pmu;
-
+	struct MessageUnit_B *reg = (struct MessageUnit_B *)acb->pmu;
 	acb->acb_flags &= ~ACB_F_MSG_START_BGRB;
-	writel(ARCMSR_INBOUND_MESG0_STOP_BGRB, &reg->inbound_msgaddr0);
-	if (arcmsr_wait_msgint_ready(acb))
+	writel(ARCMSR_MESSAGE_STOP_BGRB, reg->drv2iop_doorbell_reg);
+
+	if (arcmsr_hbb_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE
 			"arcmsr%d: wait 'stop adapter background rebulid' timeout \n"
 			, acb->host->host_no);
+	}
+}
+
+static void arcmsr_stop_adapter_bgrb(struct AdapterControlBlock *acb)
+{
+	switch (acb->adapter_type) {
+	case ACB_ADAPTER_TYPE_A: {
+		arcmsr_stop_hba_bgrb(acb);
+		}
+		break;
+
+	case ACB_ADAPTER_TYPE_B: {
+		arcmsr_stop_hbb_bgrb(acb);
+		}
+		break;
+	}
 }
 
 static void arcmsr_free_ccb_pool(struct AdapterControlBlock *acb)
@@ -665,151 +1027,260 @@ static void arcmsr_free_ccb_pool(struct 
 		acb->dma_coherent_handle);
 }
 
-static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb)
+void arcmsr_iop_message_read(struct AdapterControlBlock *acb)
 {
-	struct MessageUnit __iomem *reg = acb->pmu;
-	struct CommandControlBlock *ccb;
-	uint32_t flag_ccb, outbound_intstatus, outbound_doorbell;
-
-	outbound_intstatus = readl(&reg->outbound_intstatus)
-		& acb->outbound_int_enable;
-	writel(outbound_intstatus, &reg->outbound_intstatus);
-	if (outbound_intstatus & ARCMSR_MU_OUTBOUND_DOORBELL_INT) {
-		outbound_doorbell = readl(&reg->outbound_doorbell);
-		writel(outbound_doorbell, &reg->outbound_doorbell);
-		if (outbound_doorbell & ARCMSR_OUTBOUND_IOP331_DATA_WRITE_OK) {
-			struct QBUFFER __iomem * prbuffer =
-				(struct QBUFFER __iomem *) &reg->message_rbuffer;
-			uint8_t __iomem * iop_data = (uint8_t __iomem *)prbuffer->data;
-			int32_t my_empty_len, iop_len, rqbuf_firstindex, rqbuf_lastindex;
+	switch (acb->adapter_type) {
+	case ACB_ADAPTER_TYPE_A: {
+		struct MessageUnit_A __iomem *reg = (struct MessageUnit_A *)acb->pmu;
+		writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK, &reg->inbound_doorbell);
+		}
+		break;
 
-			rqbuf_lastindex = acb->rqbuf_lastindex;
-			rqbuf_firstindex = acb->rqbuf_firstindex;
-			iop_len = readl(&prbuffer->data_len);
-			my_empty_len = (rqbuf_firstindex - rqbuf_lastindex - 1)
-					&(ARCMSR_MAX_QBUFFER - 1);
-			if (my_empty_len >= iop_len) {
-				while (iop_len > 0) {
-					acb->rqbuffer[acb->rqbuf_lastindex] = readb(iop_data);
-					acb->rqbuf_lastindex++;
-					acb->rqbuf_lastindex %= ARCMSR_MAX_QBUFFER;
-					iop_data++;
-					iop_len--;
-				}
-				writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK,
-					&reg->inbound_doorbell);
-			} else
-				acb->acb_flags |= ACB_F_IOPDATA_OVERFLOW;
-		}
-		if (outbound_doorbell & ARCMSR_OUTBOUND_IOP331_DATA_READ_OK) {
-			acb->acb_flags |= ACB_F_MESSAGE_WQBUFFER_READED;
-			if (acb->wqbuf_firstindex != acb->wqbuf_lastindex) {
-				struct QBUFFER __iomem * pwbuffer =
-						(struct QBUFFER __iomem *) &reg->message_wbuffer;
-				uint8_t __iomem * iop_data = (uint8_t __iomem *) pwbuffer->data;
-				int32_t allxfer_len = 0;
-
-				acb->acb_flags &= (~ACB_F_MESSAGE_WQBUFFER_READED);
-				while ((acb->wqbuf_firstindex != acb->wqbuf_lastindex)
-					&& (allxfer_len < 124)) {
-					writeb(acb->wqbuffer[acb->wqbuf_firstindex], iop_data);
-					acb->wqbuf_firstindex++;
-					acb->wqbuf_firstindex %= ARCMSR_MAX_QBUFFER;
-					iop_data++;
-					allxfer_len++;
-				}
-				writel(allxfer_len, &pwbuffer->data_len);
-				writel(ARCMSR_INBOUND_DRIVER_DATA_WRITE_OK,
-					&reg->inbound_doorbell);
-			}
-			if (acb->wqbuf_firstindex == acb->wqbuf_lastindex)
-				acb->acb_flags |= ACB_F_MESSAGE_WQBUFFER_CLEARED;
+	case ACB_ADAPTER_TYPE_B: {
+		struct MessageUnit_B *reg = (struct MessageUnit_B *)acb->pmu;
+		writel(ARCMSR_DRV2IOP_DATA_READ_OK, reg->drv2iop_doorbell_reg);
 		}
+		break;
 	}
-	if (outbound_intstatus & ARCMSR_MU_OUTBOUND_POSTQUEUE_INT) {
-		int id, lun;
+}
+
+static void arcmsr_iop_message_wrote(struct AdapterControlBlock *acb)
+{
+	switch (acb->adapter_type) {
+	case ACB_ADAPTER_TYPE_A: {
+		struct MessageUnit_A __iomem *reg = (struct MessageUnit_A *)acb->pmu;
 		/*
-		****************************************************************
-		**	      areca cdb command done
-		****************************************************************
+		** push inbound doorbell tell iop, driver data write ok
+		** and wait reply on next hwinterrupt for next Qbuffer post
 		*/
-		while (1) {
-			if ((flag_ccb = readl(&reg->outbound_queueport)) == 0xFFFFFFFF)
-				break;/*chip FIFO no ccb for completion already*/
-			/* check if command done with no error*/
-			ccb = (struct CommandControlBlock *)(acb->vir2phy_offset +
-				(flag_ccb << 5));
-			if ((ccb->acb != acb) || (ccb->startdone != ARCMSR_CCB_START)) {
-				if (ccb->startdone == ARCMSR_CCB_ABORTED) {
-					struct scsi_cmnd *abortcmd = ccb->pcmd;
-					if (abortcmd) {
-					abortcmd->result |= DID_ABORT >> 16;
-					arcmsr_ccb_complete(ccb, 1);
-					printk(KERN_NOTICE
-						"arcmsr%d: ccb ='0x%p' isr got aborted command \n"
-						, acb->host->host_no, ccb);
-					}
-					continue;
-				}
-				printk(KERN_NOTICE
-					"arcmsr%d: isr get an illegal ccb command done acb = '0x%p'"
-					"ccb = '0x%p' ccbacb = '0x%p' startdone = 0x%x"
-					" ccboutstandingcount = %d \n"
-					, acb->host->host_no
-					, acb
-					, ccb
-					, ccb->acb
-					, ccb->startdone
-					, atomic_read(&acb->ccboutstandingcount));
-				continue;
-			}
-			id = ccb->pcmd->device->id;
-			lun = ccb->pcmd->device->lun;
-			if (!(flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR)) {
-				if (acb->devstate[id][lun] == ARECA_RAID_GONE)
-					acb->devstate[id][lun] = ARECA_RAID_GOOD;
-				ccb->pcmd->result = DID_OK << 16;
-				arcmsr_ccb_complete(ccb, 1);
-			} else {
-				switch(ccb->arcmsr_cdb.DeviceStatus) {
-				case ARCMSR_DEV_SELECT_TIMEOUT: {
-						acb->devstate[id][lun] = ARECA_RAID_GONE;
-						ccb->pcmd->result = DID_NO_CONNECT << 16;
-						arcmsr_ccb_complete(ccb, 1);
-					}
-					break;
-				case ARCMSR_DEV_ABORTED:
-				case ARCMSR_DEV_INIT_FAIL: {
-						acb->devstate[id][lun] = ARECA_RAID_GONE;
-						ccb->pcmd->result = DID_BAD_TARGET << 16;
-						arcmsr_ccb_complete(ccb, 1);
-					}
-					break;
-				case ARCMSR_DEV_CHECK_CONDITION: {
-						acb->devstate[id][lun] = ARECA_RAID_GOOD;
-						arcmsr_report_sense_info(ccb);
-						arcmsr_ccb_complete(ccb, 1);
-					}
-					break;
-				default:
-					printk(KERN_NOTICE
-						"arcmsr%d: scsi id = %d lun = %d"
-						" isr get command error done, "
-						"but got unknown DeviceStatus = 0x%x \n"
-						, acb->host->host_no
-						, id
-						, lun
-						, ccb->arcmsr_cdb.DeviceStatus);
-						acb->devstate[id][lun] = ARECA_RAID_GONE;
-						ccb->pcmd->result = DID_NO_CONNECT << 16;
-						arcmsr_ccb_complete(ccb, 1);
-					break;
-				}
-			}
-		}/*drain reply FIFO*/
+		writel(ARCMSR_INBOUND_DRIVER_DATA_WRITE_OK, &reg->inbound_doorbell);
+		}
+		break;
+
+	case ACB_ADAPTER_TYPE_B: {
+		struct MessageUnit_B *reg = (struct MessageUnit_B *)acb->pmu;
+		/*
+		** push inbound doorbell tell iop, driver data write ok
+		** and wait reply on next hwinterrupt for next Qbuffer post
+		*/
+		writel(ARCMSR_DRV2IOP_DATA_WRITE_OK, reg->drv2iop_doorbell_reg);
+		}
+		break;
+	}
+}
+
+struct QBUFFER *arcmsr_get_iop_rqbuffer(struct AdapterControlBlock *acb)
+{
+	static struct QBUFFER *qbuffer;
+
+	switch (acb->adapter_type) {
+
+	case ACB_ADAPTER_TYPE_A: {
+		struct MessageUnit_A __iomem *reg = (struct MessageUnit_A *)acb->pmu;
+		qbuffer = (struct QBUFFER __iomem *) &reg->message_rbuffer;
+		}
+		break;
+
+	case ACB_ADAPTER_TYPE_B: {
+		struct MessageUnit_B *reg = (struct MessageUnit_B *)acb->pmu;
+		qbuffer = (struct QBUFFER __iomem *) reg->ioctl_rbuffer_reg;
+		}
+		break;
+	}
+	return qbuffer;
+}
+
+static struct QBUFFER *arcmsr_get_iop_wqbuffer(struct AdapterControlBlock *acb)
+{
+	static struct QBUFFER *pqbuffer;
+
+	switch (acb->adapter_type) {
+
+	case ACB_ADAPTER_TYPE_A: {
+		struct MessageUnit_A __iomem *reg = (struct MessageUnit_A *)acb->pmu;
+		pqbuffer = (struct QBUFFER *) &reg->message_wbuffer;
+		}
+		break;
+
+	case ACB_ADAPTER_TYPE_B: {
+		struct MessageUnit_B  *reg = (struct MessageUnit_B *)acb->pmu;
+		pqbuffer = (struct QBUFFER __iomem *)reg->ioctl_wbuffer_reg;
+		}
+		break;
+	}
+	return pqbuffer;
+}
+
+static void arcmsr_iop2drv_data_wrote_handle(struct AdapterControlBlock *acb)
+{
+	struct QBUFFER *prbuffer;
+	struct QBUFFER *pQbuffer;
+	uint8_t *iop_data;
+	int32_t my_empty_len, iop_len, rqbuf_firstindex, rqbuf_lastindex;
+
+   	rqbuf_lastindex = acb->rqbuf_lastindex;
+	rqbuf_firstindex = acb->rqbuf_firstindex;
+	prbuffer = arcmsr_get_iop_rqbuffer(acb);
+	iop_data = (uint8_t *)prbuffer->data;
+	iop_len = prbuffer->data_len;
+    	my_empty_len = (rqbuf_firstindex - rqbuf_lastindex -1)&(ARCMSR_MAX_QBUFFER -1);
+
+	if (my_empty_len >= iop_len)
+	{
+		while (iop_len > 0) {
+			pQbuffer = (struct QBUFFER *)&acb->rqbuffer[rqbuf_lastindex];
+			memcpy(pQbuffer,iop_data,1);
+			rqbuf_lastindex++;
+			rqbuf_lastindex %= ARCMSR_MAX_QBUFFER;
+			iop_data++;
+			iop_len--;
+		}
+        	acb->rqbuf_lastindex = rqbuf_lastindex;
+		arcmsr_iop_message_read(acb);
+	}
+
+	else {
+		acb->acb_flags |= ACB_F_IOPDATA_OVERFLOW;
+	}
+}
+
+static void arcmsr_iop2drv_data_read_handle(struct AdapterControlBlock *acb)
+{
+	acb->acb_flags |= ACB_F_MESSAGE_WQBUFFER_READED;
+	if (acb->wqbuf_firstindex!= acb->wqbuf_lastindex) {
+		uint8_t * pQbuffer;
+		struct QBUFFER *pwbuffer;
+		uint8_t *iop_data;
+		int32_t allxfer_len = 0;
+
+		acb->acb_flags &= (~ACB_F_MESSAGE_WQBUFFER_READED);
+		pwbuffer = arcmsr_get_iop_wqbuffer(acb);
+		iop_data = (uint8_t __iomem *)pwbuffer->data;
+
+		while ((acb->wqbuf_firstindex != acb->wqbuf_lastindex) && \
+							(allxfer_len<124)) {
+			pQbuffer = &acb->wqbuffer[acb->wqbuf_firstindex];
+   			memcpy(iop_data, pQbuffer,1);
+			acb->wqbuf_firstindex++;
+			acb->wqbuf_firstindex %= ARCMSR_MAX_QBUFFER;
+			iop_data++;
+			allxfer_len++;
+		}
+		pwbuffer->data_len = allxfer_len;
+
+		arcmsr_iop_message_wrote(acb);
+ 	}
+
+	if (acb->wqbuf_firstindex == acb->wqbuf_lastindex) {
+		acb->acb_flags |= ACB_F_MESSAGE_WQBUFFER_CLEARED;
+	}
+}
+
+static void arcmsr_hba_doorbell_isr(struct AdapterControlBlock *acb)
+{
+    	uint32_t outbound_doorbell;
+	struct MessageUnit_A __iomem *reg = (struct MessageUnit_A *)acb->pmu;
+
+	outbound_doorbell = readl(&reg->outbound_doorbell);
+	writel(outbound_doorbell, &reg->outbound_doorbell);
+	if (outbound_doorbell & ARCMSR_OUTBOUND_IOP331_DATA_WRITE_OK) {
+		arcmsr_iop2drv_data_wrote_handle(acb);
+	}
+
+	if (outbound_doorbell & ARCMSR_OUTBOUND_IOP331_DATA_READ_OK) 	{
+		arcmsr_iop2drv_data_read_handle(acb);
+	}
+}
+
+static void arcmsr_hba_postqueue_isr(struct AdapterControlBlock *acb)
+{
+    	uint32_t flag_ccb;
+	struct MessageUnit_A __iomem *reg = (struct MessageUnit_A *)acb->pmu;
+
+	while ((flag_ccb = readl(&reg->outbound_queueport)) != 0xFFFFFFFF) {
+		arcmsr_drain_donequeue(acb, flag_ccb);
+	}
+}
+
+static void arcmsr_hbb_postqueue_isr(struct AdapterControlBlock *acb)
+{
+	uint32_t index;
+    	uint32_t flag_ccb;
+	struct MessageUnit_B *reg = (struct MessageUnit_B *)acb->pmu;
+
+	index = reg->doneq_index;
+
+	while ((flag_ccb = readl(&reg->done_qbuffer[index])) != 0) {
+		writel(0, &reg->done_qbuffer[index]);
+		arcmsr_drain_donequeue(acb, flag_ccb);
+		index++;
+		index %= ARCMSR_MAX_HBB_POSTQUEUE;
+		reg->doneq_index = index;
+	}
+}
+
+static int arcmsr_handle_hba_isr(struct AdapterControlBlock *acb)
+{
+	uint32_t outbound_intstatus;
+	struct MessageUnit_A __iomem *reg = (struct MessageUnit_A *)acb->pmu;
+
+	outbound_intstatus = readl(&reg->outbound_intstatus) & \
+							acb->outbound_int_enable;
+	if (!(outbound_intstatus & ARCMSR_MU_OUTBOUND_HANDLE_INT))	{
+        	return 1;
+	}
+	writel(outbound_intstatus, &reg->outbound_intstatus);
+	if (outbound_intstatus & ARCMSR_MU_OUTBOUND_DOORBELL_INT)	{
+		arcmsr_hba_doorbell_isr(acb);
+	}
+	if (outbound_intstatus & ARCMSR_MU_OUTBOUND_POSTQUEUE_INT) {
+		arcmsr_hba_postqueue_isr(acb);
+	}
+	return 0;
+}
+
+static int arcmsr_handle_hbb_isr(struct AdapterControlBlock *acb)
+{
+	uint32_t outbound_doorbell;
+	struct MessageUnit_B *reg = (struct MessageUnit_B *)acb->pmu;
+
+	outbound_doorbell = readl(reg->iop2drv_doorbell_reg) & \
+							acb->outbound_int_enable;
+	if (!outbound_doorbell)
+	        return 1;
+
+	writel(~outbound_doorbell, reg->iop2drv_doorbell_reg);
+
+	if (outbound_doorbell & ARCMSR_IOP2DRV_DATA_WRITE_OK) 	{
+		arcmsr_iop2drv_data_wrote_handle(acb);
+	}
+	if (outbound_doorbell & ARCMSR_IOP2DRV_DATA_READ_OK) {
+		arcmsr_iop2drv_data_read_handle(acb);
+	}
+	if (outbound_doorbell & ARCMSR_IOP2DRV_CDB_DONE) {
+		arcmsr_hbb_postqueue_isr(acb);
+	}
+
+	return 0;
+}
+
+static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb)
+{
+	switch (acb->adapter_type) {
+	case ACB_ADAPTER_TYPE_A: {
+		if (arcmsr_handle_hba_isr(acb)) {
+			return IRQ_NONE;
+		}
+		}
+		break;
+
+	case ACB_ADAPTER_TYPE_B: {
+		if (arcmsr_handle_hbb_isr(acb)) {
+			return IRQ_NONE;
+		}
+		}
+		break;
 	}
-	if (!(outbound_intstatus & ARCMSR_MU_OUTBOUND_HANDLE_INT))
-		return IRQ_NONE;
 	return IRQ_HANDLED;
 }
 
@@ -818,16 +1289,47 @@ static void arcmsr_iop_parking(struct Ad
 	if (acb) {
 		/* stop adapter background rebuild */
 		if (acb->acb_flags & ACB_F_MSG_START_BGRB) {
+			uint32_t intmask_org;
 			acb->acb_flags &= ~ACB_F_MSG_START_BGRB;
+			intmask_org = arcmsr_disable_outbound_ints(acb);
 			arcmsr_stop_adapter_bgrb(acb);
 			arcmsr_flush_adapter_cache(acb);
+			arcmsr_enable_outbound_ints(acb, intmask_org);
+		}
+	}
+}
+
+void arcmsr_post_ioctldata2iop(struct AdapterControlBlock *acb)
+{
+	int32_t wqbuf_firstindex, wqbuf_lastindex;
+	uint8_t *pQbuffer;
+	struct QBUFFER *pwbuffer;
+       	uint8_t *iop_data;
+	int32_t allxfer_len = 0;
+
+	pwbuffer = arcmsr_get_iop_wqbuffer(acb);
+	iop_data = (uint8_t __iomem *)pwbuffer->data;
+    	if (acb->acb_flags & ACB_F_MESSAGE_WQBUFFER_READED) {
+		acb->acb_flags &= (~ACB_F_MESSAGE_WQBUFFER_READED);
+		wqbuf_firstindex = acb->wqbuf_firstindex;
+		wqbuf_lastindex = acb->wqbuf_lastindex;
+		while ((wqbuf_firstindex != wqbuf_lastindex) && (allxfer_len<124)) {
+			pQbuffer = &acb->wqbuffer[wqbuf_firstindex];
+			memcpy(iop_data, pQbuffer, 1);
+			wqbuf_firstindex++;
+			wqbuf_firstindex %= ARCMSR_MAX_QBUFFER;
+			iop_data++;
+			allxfer_len++;
 		}
+		acb->wqbuf_firstindex = wqbuf_firstindex;
+		pwbuffer->data_len = allxfer_len;
+		arcmsr_iop_message_wrote(acb);
 	}
 }
 
-static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb, struct scsi_cmnd *cmd)
+static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb, \
+					struct scsi_cmnd *cmd)
 {
-	struct MessageUnit __iomem *reg = acb->pmu;
 	struct CMD_MESSAGE_FIELD *pcmdmessagefld;
 	int retvalue = 0, transfer_len = 0;
 	char *buffer;
@@ -836,7 +1338,7 @@ static int arcmsr_iop_message_xfer(struc
 						(uint32_t ) cmd->cmnd[6] << 16 |
 						(uint32_t ) cmd->cmnd[7] << 8  |
 						(uint32_t ) cmd->cmnd[8];
-					/* 4 bytes: Areca io control code */
+						/* 4 bytes: Areca io control code */
 
 	sg = scsi_sglist(cmd);
 	buffer = kmap_atomic(sg->page, KM_IRQ0) + sg->offset;
@@ -852,194 +1354,199 @@ static int arcmsr_iop_message_xfer(struc
 	}
 	pcmdmessagefld = (struct CMD_MESSAGE_FIELD *) buffer;
 	switch(controlcode) {
+
 	case ARCMSR_MESSAGE_READ_RQBUFFER: {
-			unsigned long *ver_addr;
-			dma_addr_t buf_handle;
-			uint8_t *pQbuffer, *ptmpQbuffer;
-			int32_t allxfer_len = 0;
+		unsigned long *ver_addr;
+		dma_addr_t buf_handle;
+		uint8_t *pQbuffer, *ptmpQbuffer;
+		int32_t allxfer_len = 0;
+
+		ver_addr = pci_alloc_consistent(acb->pdev, 1032, &buf_handle);
+		if (!ver_addr) {
+			retvalue = ARCMSR_MESSAGE_FAIL;
+			goto message_out;
+		}
+		ptmpQbuffer = (uint8_t *) ver_addr;
+		while ((acb->rqbuf_firstindex != acb->rqbuf_lastindex)
+			&& (allxfer_len < 1031)) {
+			pQbuffer = &acb->rqbuffer[acb->rqbuf_firstindex];
+			memcpy(ptmpQbuffer, pQbuffer, 1);
+			acb->rqbuf_firstindex++;
+			acb->rqbuf_firstindex %= ARCMSR_MAX_QBUFFER;
+			ptmpQbuffer++;
+			allxfer_len++;
+		}
+		if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
 
-			ver_addr = pci_alloc_consistent(acb->pdev, 1032, &buf_handle);
-			if (!ver_addr) {
-				retvalue = ARCMSR_MESSAGE_FAIL;
-				goto message_out;
-			}
-			ptmpQbuffer = (uint8_t *) ver_addr;
-			while ((acb->rqbuf_firstindex != acb->rqbuf_lastindex)
-				&& (allxfer_len < 1031)) {
-				pQbuffer = &acb->rqbuffer[acb->rqbuf_firstindex];
-				memcpy(ptmpQbuffer, pQbuffer, 1);
-				acb->rqbuf_firstindex++;
-				acb->rqbuf_firstindex %= ARCMSR_MAX_QBUFFER;
-				ptmpQbuffer++;
-				allxfer_len++;
-			}
-			if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
-				struct QBUFFER __iomem * prbuffer = (struct QBUFFER __iomem *)
-							&reg->message_rbuffer;
-				uint8_t __iomem * iop_data = (uint8_t __iomem *)prbuffer->data;
-				int32_t iop_len;
-
-				acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;
-				iop_len = readl(&prbuffer->data_len);
-				while (iop_len > 0) {
-					acb->rqbuffer[acb->rqbuf_lastindex] = readb(iop_data);
-					acb->rqbuf_lastindex++;
-					acb->rqbuf_lastindex %= ARCMSR_MAX_QBUFFER;
-					iop_data++;
-					iop_len--;
-				}
-				writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK,
-						&reg->inbound_doorbell);
-			}
-			memcpy(pcmdmessagefld->messagedatabuffer,
-				(uint8_t *)ver_addr, allxfer_len);
-			pcmdmessagefld->cmdmessage.Length = allxfer_len;
-			pcmdmessagefld->cmdmessage.ReturnCode = ARCMSR_MESSAGE_RETURNCODE_OK;
-			pci_free_consistent(acb->pdev, 1032, ver_addr, buf_handle);
+			struct QBUFFER *prbuffer;
+			uint8_t * iop_data;
+                	int32_t iop_len;
+
+                	acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;
+			prbuffer = arcmsr_get_iop_rqbuffer(acb);
+			iop_data = (uint8_t *)prbuffer->data;
+			iop_len = readl(&prbuffer->data_len);
+			while (iop_len > 0) {
+				acb->rqbuffer[acb->rqbuf_lastindex] = readb(iop_data);
+				acb->rqbuf_lastindex++;
+				acb->rqbuf_lastindex %= ARCMSR_MAX_QBUFFER;
+				iop_data++;
+				iop_len--;
+			}
+			arcmsr_iop_message_read(acb);
+		}
+		memcpy(pcmdmessagefld->messagedatabuffer, (uint8_t *)ver_addr, allxfer_len);
+		pcmdmessagefld->cmdmessage.Length = allxfer_len;
+		pcmdmessagefld->cmdmessage.ReturnCode = ARCMSR_MESSAGE_RETURNCODE_OK;
+		pci_free_consistent(acb->pdev, 1032, ver_addr, buf_handle);
 		}
 		break;
-	case ARCMSR_MESSAGE_WRITE_WQBUFFER: {
-			unsigned long *ver_addr;
-			dma_addr_t buf_handle;
-			int32_t my_empty_len, user_len, wqbuf_firstindex, wqbuf_lastindex;
-			uint8_t *pQbuffer, *ptmpuserbuffer;
 
-			ver_addr = pci_alloc_consistent(acb->pdev, 1032, &buf_handle);
-			if (!ver_addr) {
-				retvalue = ARCMSR_MESSAGE_FAIL;
-				goto message_out;
-			}
-			ptmpuserbuffer = (uint8_t *)ver_addr;
-			user_len = pcmdmessagefld->cmdmessage.Length;
-			memcpy(ptmpuserbuffer, pcmdmessagefld->messagedatabuffer, user_len);
-			wqbuf_lastindex = acb->wqbuf_lastindex;
-			wqbuf_firstindex = acb->wqbuf_firstindex;
-			if (wqbuf_lastindex != wqbuf_firstindex) {
+	case ARCMSR_MESSAGE_WRITE_WQBUFFER: {
+		unsigned long *ver_addr;
+		dma_addr_t buf_handle;
+		int32_t my_empty_len, user_len, wqbuf_firstindex, wqbuf_lastindex;
+		uint8_t *pQbuffer, *ptmpuserbuffer;
+
+		ver_addr = pci_alloc_consistent(acb->pdev, 1032, &buf_handle);
+		if (!ver_addr) {
+			retvalue = ARCMSR_MESSAGE_FAIL;
+			goto message_out;
+		}
+		ptmpuserbuffer = (uint8_t *)ver_addr;
+		user_len = pcmdmessagefld->cmdmessage.Length;
+		memcpy(ptmpuserbuffer, pcmdmessagefld->messagedatabuffer, user_len);
+		wqbuf_lastindex = acb->wqbuf_lastindex;
+		wqbuf_firstindex = acb->wqbuf_firstindex;
+		if (wqbuf_lastindex != wqbuf_firstindex) {
+			struct SENSE_DATA *sensebuffer =
+				(struct SENSE_DATA *)cmd->sense_buffer;
+			arcmsr_post_ioctldata2iop(acb);
+			/* has error report sensedata */
+			sensebuffer->ErrorCode = 0x70;
+			sensebuffer->SenseKey = ILLEGAL_REQUEST;
+			sensebuffer->AdditionalSenseLength = 0x0A;
+			sensebuffer->AdditionalSenseCode = 0x20;
+			sensebuffer->Valid = 1;
+			retvalue = ARCMSR_MESSAGE_FAIL;
+		} else {
+			my_empty_len = (wqbuf_firstindex-wqbuf_lastindex - 1)
+				&(ARCMSR_MAX_QBUFFER - 1);
+			if (my_empty_len >= user_len) {
+				while (user_len > 0) {
+					pQbuffer =
+					&acb->wqbuffer[acb->wqbuf_lastindex];
+					memcpy(pQbuffer, ptmpuserbuffer, 1);
+					acb->wqbuf_lastindex++;
+					acb->wqbuf_lastindex %= ARCMSR_MAX_QBUFFER;
+					ptmpuserbuffer++;
+					user_len--;
+				}
+				if (acb->acb_flags & ACB_F_MESSAGE_WQBUFFER_CLEARED) {
+					acb->acb_flags &=
+						~ACB_F_MESSAGE_WQBUFFER_CLEARED;
+					arcmsr_post_ioctldata2iop(acb);
+				}
+			} else {
+				/* has error report sensedata */
 				struct SENSE_DATA *sensebuffer =
 					(struct SENSE_DATA *)cmd->sense_buffer;
-				arcmsr_post_Qbuffer(acb);
-				/* has error report sensedata */
 				sensebuffer->ErrorCode = 0x70;
 				sensebuffer->SenseKey = ILLEGAL_REQUEST;
 				sensebuffer->AdditionalSenseLength = 0x0A;
 				sensebuffer->AdditionalSenseCode = 0x20;
 				sensebuffer->Valid = 1;
 				retvalue = ARCMSR_MESSAGE_FAIL;
-			} else {
-				my_empty_len = (wqbuf_firstindex-wqbuf_lastindex - 1)
-						&(ARCMSR_MAX_QBUFFER - 1);
-				if (my_empty_len >= user_len) {
-					while (user_len > 0) {
-						pQbuffer =
-						&acb->wqbuffer[acb->wqbuf_lastindex];
-						memcpy(pQbuffer, ptmpuserbuffer, 1);
-						acb->wqbuf_lastindex++;
-						acb->wqbuf_lastindex %= ARCMSR_MAX_QBUFFER;
-						ptmpuserbuffer++;
-						user_len--;
-					}
-					if (acb->acb_flags & ACB_F_MESSAGE_WQBUFFER_CLEARED) {
-						acb->acb_flags &=
-							~ACB_F_MESSAGE_WQBUFFER_CLEARED;
-						arcmsr_post_Qbuffer(acb);
-					}
-				} else {
-					/* has error report sensedata */
-					struct SENSE_DATA *sensebuffer =
-						(struct SENSE_DATA *)cmd->sense_buffer;
-					sensebuffer->ErrorCode = 0x70;
-					sensebuffer->SenseKey = ILLEGAL_REQUEST;
-					sensebuffer->AdditionalSenseLength = 0x0A;
-					sensebuffer->AdditionalSenseCode = 0x20;
-					sensebuffer->Valid = 1;
-					retvalue = ARCMSR_MESSAGE_FAIL;
-				}
+			}
 			}
 			pci_free_consistent(acb->pdev, 1032, ver_addr, buf_handle);
 		}
 		break;
+
 	case ARCMSR_MESSAGE_CLEAR_RQBUFFER: {
-			uint8_t *pQbuffer = acb->rqbuffer;
+		uint8_t *pQbuffer = acb->rqbuffer;
 
-			if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
-				acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;
-				writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK,
-					&reg->inbound_doorbell);
-			}
-			acb->acb_flags |= ACB_F_MESSAGE_RQBUFFER_CLEARED;
-			acb->rqbuf_firstindex = 0;
-			acb->rqbuf_lastindex = 0;
-			memset(pQbuffer, 0, ARCMSR_MAX_QBUFFER);
-			pcmdmessagefld->cmdmessage.ReturnCode =
-				ARCMSR_MESSAGE_RETURNCODE_OK;
+		if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
+			acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;
+			arcmsr_iop_message_read(acb);
+		}
+		acb->acb_flags |= ACB_F_MESSAGE_RQBUFFER_CLEARED;
+		acb->rqbuf_firstindex = 0;
+		acb->rqbuf_lastindex = 0;
+		memset(pQbuffer, 0, ARCMSR_MAX_QBUFFER);
+		pcmdmessagefld->cmdmessage.ReturnCode = ARCMSR_MESSAGE_RETURNCODE_OK;
 		}
 		break;
+
 	case ARCMSR_MESSAGE_CLEAR_WQBUFFER: {
-			uint8_t *pQbuffer = acb->wqbuffer;
+		uint8_t *pQbuffer = acb->wqbuffer;
 
-			if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
-				acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;
-				writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK
-						, &reg->inbound_doorbell);
-			}
-			acb->acb_flags |=
-				(ACB_F_MESSAGE_WQBUFFER_CLEARED |
-					ACB_F_MESSAGE_WQBUFFER_READED);
-			acb->wqbuf_firstindex = 0;
-			acb->wqbuf_lastindex = 0;
-			memset(pQbuffer, 0, ARCMSR_MAX_QBUFFER);
-			pcmdmessagefld->cmdmessage.ReturnCode =
-				ARCMSR_MESSAGE_RETURNCODE_OK;
+		if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
+			acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;
+			arcmsr_iop_message_read(acb);
+		}
+		acb->acb_flags |=
+			(ACB_F_MESSAGE_WQBUFFER_CLEARED |
+				ACB_F_MESSAGE_WQBUFFER_READED);
+		acb->wqbuf_firstindex = 0;
+		acb->wqbuf_lastindex = 0;
+		memset(pQbuffer, 0, ARCMSR_MAX_QBUFFER);
+		pcmdmessagefld->cmdmessage.ReturnCode =
+			ARCMSR_MESSAGE_RETURNCODE_OK;
 		}
 		break;
+
 	case ARCMSR_MESSAGE_CLEAR_ALLQBUFFER: {
-			uint8_t *pQbuffer;
+		uint8_t *pQbuffer;
 
-			if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
-				acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;
-				writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK
-						, &reg->inbound_doorbell);
-			}
-			acb->acb_flags |=
-				(ACB_F_MESSAGE_WQBUFFER_CLEARED
-				| ACB_F_MESSAGE_RQBUFFER_CLEARED
-				| ACB_F_MESSAGE_WQBUFFER_READED);
-			acb->rqbuf_firstindex = 0;
-			acb->rqbuf_lastindex = 0;
-			acb->wqbuf_firstindex = 0;
-			acb->wqbuf_lastindex = 0;
-			pQbuffer = acb->rqbuffer;
-			memset(pQbuffer, 0, sizeof (struct QBUFFER));
-			pQbuffer = acb->wqbuffer;
-			memset(pQbuffer, 0, sizeof (struct QBUFFER));
-			pcmdmessagefld->cmdmessage.ReturnCode = ARCMSR_MESSAGE_RETURNCODE_OK;
+		if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
+			acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;
+			arcmsr_iop_message_read(acb);
+		}
+		acb->acb_flags |=
+			(ACB_F_MESSAGE_WQBUFFER_CLEARED
+			| ACB_F_MESSAGE_RQBUFFER_CLEARED
+			| ACB_F_MESSAGE_WQBUFFER_READED);
+		acb->rqbuf_firstindex = 0;
+		acb->rqbuf_lastindex = 0;
+		acb->wqbuf_firstindex = 0;
+		acb->wqbuf_lastindex = 0;
+		pQbuffer = acb->rqbuffer;
+		memset(pQbuffer, 0, sizeof (struct QBUFFER));
+		pQbuffer = acb->wqbuffer;
+		memset(pQbuffer, 0, sizeof (struct QBUFFER));
+		pcmdmessagefld->cmdmessage.ReturnCode = ARCMSR_MESSAGE_RETURNCODE_OK;
 		}
 		break;
+
 	case ARCMSR_MESSAGE_RETURN_CODE_3F: {
-			pcmdmessagefld->cmdmessage.ReturnCode = ARCMSR_MESSAGE_RETURNCODE_3F;
+		pcmdmessagefld->cmdmessage.ReturnCode = ARCMSR_MESSAGE_RETURNCODE_3F;
 		}
 		break;
+
 	case ARCMSR_MESSAGE_SAY_HELLO: {
-			int8_t * hello_string = "Hello! I am ARCMSR";
+		int8_t * hello_string = "Hello! I am ARCMSR";
 
-			memcpy(pcmdmessagefld->messagedatabuffer, hello_string
-				, (int16_t)strlen(hello_string));
-			pcmdmessagefld->cmdmessage.ReturnCode = ARCMSR_MESSAGE_RETURNCODE_OK;
+		memcpy(pcmdmessagefld->messagedatabuffer, hello_string
+			, (int16_t)strlen(hello_string));
+		pcmdmessagefld->cmdmessage.ReturnCode = ARCMSR_MESSAGE_RETURNCODE_OK;
 		}
 		break;
+
 	case ARCMSR_MESSAGE_SAY_GOODBYE:
 		arcmsr_iop_parking(acb);
 		break;
+
 	case ARCMSR_MESSAGE_FLUSH_ADAPTER_CACHE:
 		arcmsr_flush_adapter_cache(acb);
 		break;
+
 	default:
 		retvalue = ARCMSR_MESSAGE_FAIL;
 	}
- message_out:
+	message_out:
 	sg = scsi_sglist(cmd);
 	kunmap_atomic(buffer - sg->offset, KM_IRQ0);
-
 	return retvalue;
 }
 
@@ -1109,8 +1616,7 @@ static int arcmsr_queue_command(struct s
 	void (* done)(struct scsi_cmnd *))
 {
 	struct Scsi_Host *host = cmd->device->host;
-	struct AdapterControlBlock *acb =
-		(struct AdapterControlBlock *) host->hostdata;
+	struct AdapterControlBlock *acb = (struct AdapterControlBlock *) host->hostdata;
 	struct CommandControlBlock *ccb;
 	int target = cmd->device->id;
 	int lun = cmd->device->lun;
@@ -1153,62 +1659,129 @@ static int arcmsr_queue_command(struct s
 	ccb = arcmsr_get_freeccb(acb);
 	if (!ccb)
 		return SCSI_MLQUEUE_HOST_BUSY;
+
 	arcmsr_build_ccb(acb, ccb, cmd);
 	arcmsr_post_ccb(acb, ccb);
 	return 0;
 }
 
-static void arcmsr_get_firmware_spec(struct AdapterControlBlock *acb)
+static void arcmsr_get_hba_config(struct AdapterControlBlock *acb)
 {
-	struct MessageUnit __iomem *reg = acb->pmu;
+	struct MessageUnit_A __iomem *reg = (struct MessageUnit_A *)acb->pmu;
 	char *acb_firm_model = acb->firm_model;
 	char *acb_firm_version = acb->firm_version;
-	char __iomem *iop_firm_model = (char __iomem *) &reg->message_rwbuffer[15];
-	char __iomem *iop_firm_version = (char __iomem *) &reg->message_rwbuffer[17];
+	char *iop_firm_model = (char *) (&reg->message_rwbuffer[15]);
+	char *iop_firm_version = (char *) (&reg->message_rwbuffer[17]);
 	int count;
 
-	writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
-	if (arcmsr_wait_msgint_ready(acb))
-		printk(KERN_NOTICE
-			"arcmsr%d: wait "
-			"'get adapter firmware miscellaneous data' timeout \n"
-			, acb->host->host_no);
+    	writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
+	if (arcmsr_hba_wait_msgint_ready(acb)) {
+		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \
+			miscellaneous data' timeout \n", acb->host->host_no);
+	}
+
 	count = 8;
 	while (count) {
-		*acb_firm_model = readb(iop_firm_model);
-		acb_firm_model++;
+        	*acb_firm_model = readb(iop_firm_model);
+        	acb_firm_model++;
 		iop_firm_model++;
 		count--;
 	}
+
 	count = 16;
 	while (count) {
-		*acb_firm_version = readb(iop_firm_version);
-		acb_firm_version++;
+        	*acb_firm_version = readb(iop_firm_version);
+        	acb_firm_version++;
+		iop_firm_version++;
+		count--;
+	}
+
+	printk(KERN_INFO 	"ARECA RAID ADAPTER%d: FIRMWARE VERSION %s \n"
+		, acb->host->host_no
+		, acb->firm_version);
+
+	acb->firm_request_len = readl(&reg->message_rwbuffer[1]);
+	acb->firm_numbers_queue = readl(&reg->message_rwbuffer[2]);
+	acb->firm_sdram_size = readl(&reg->message_rwbuffer[3]);
+	acb->firm_hd_channels = readl(&reg->message_rwbuffer[4]);
+}
+
+static void arcmsr_get_hbb_config(struct AdapterControlBlock *acb)
+{
+ 	struct MessageUnit_B *reg = (struct MessageUnit_B *)acb->pmu;
+ 	uint32_t * lrwbuffer = reg->msgcode_rwbuffer_reg;
+	char *acb_firm_model = acb->firm_model;
+	char *acb_firm_version = acb->firm_version;
+	char *iop_firm_model = (char *) (&lrwbuffer[15]);
+	/*firm_model,15,60-67*/
+	char *iop_firm_version = (char *) (&lrwbuffer[17]);
+	/*firm_version,17,68-83*/
+ 	int count;
+
+	writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell_reg);
+	if (arcmsr_hbb_wait_msgint_ready(acb)) {
+		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \
+			miscellaneous data' timeout \n", acb->host->host_no);
+ 	}
+
+ 	count = 8;
+ 	while (count)
+ 	{
+		*acb_firm_model = readb(iop_firm_model);
+        	acb_firm_model++;
+  		iop_firm_model++;
+  		count--;
+ 	}
+
+ 	count = 16;
+	while (count)
+	{
+        	*acb_firm_version = readb(iop_firm_version);
+        	acb_firm_version++;
 		iop_firm_version++;
 		count--;
+ 	}
+
+	printk(KERN_INFO "ARECA RAID ADAPTER%d: FIRMWARE VERSION %s \n",
+			acb->host->host_no,
+			acb->firm_version);
+
+	lrwbuffer++;
+	acb->firm_request_len = readl(lrwbuffer++);
+	/*firm_request_len,1,04-07*/
+ 	acb->firm_numbers_queue = readl(lrwbuffer++);
+	/*firm_numbers_queue,2,08-11*/
+ 	acb->firm_sdram_size = readl(lrwbuffer++);
+	/*firm_sdram_size,3,12-15*/
+	acb->firm_hd_channels = readl(lrwbuffer);
+	/*firm_ide_channels,4,16-19*/
+}
+
+static void arcmsr_get_firmware_spec(struct AdapterControlBlock *acb)
+{
+	switch (acb->adapter_type) {
+	case ACB_ADAPTER_TYPE_A: {
+		arcmsr_get_hba_config(acb);
+		}
+		break;
+
+	case ACB_ADAPTER_TYPE_B: {
+		arcmsr_get_hbb_config(acb);
+		}
+		break;
 	}
-	printk(KERN_INFO
-		"ARECA RAID ADAPTER%d: FIRMWARE VERSION %s \n"
-		, acb->host->host_no
-		, acb->firm_version);
-	acb->firm_request_len = readl(&reg->message_rwbuffer[1]);
-	acb->firm_numbers_queue = readl(&reg->message_rwbuffer[2]);
-	acb->firm_sdram_size = readl(&reg->message_rwbuffer[3]);
-	acb->firm_hd_channels = readl(&reg->message_rwbuffer[4]);
 }
 
-static void arcmsr_polling_ccbdone(struct AdapterControlBlock *acb,
+static void arcmsr_polling_hba_ccbdone(struct AdapterControlBlock *acb,
 	struct CommandControlBlock *poll_ccb)
 {
-	struct MessageUnit __iomem *reg = acb->pmu;
+	struct MessageUnit_A __iomem *reg = (struct MessageUnit_A *)acb->pmu;
 	struct CommandControlBlock *ccb;
 	uint32_t flag_ccb, outbound_intstatus, poll_ccb_done = 0, poll_count = 0;
-	int id, lun;
 
- polling_ccb_retry:
+ 	polling_hba_ccb_retry:
 	poll_count++;
-	outbound_intstatus = readl(&reg->outbound_intstatus)
-					& acb->outbound_int_enable;
+	outbound_intstatus = readl(&reg->outbound_intstatus) & acb->outbound_int_enable;
 	writel(outbound_intstatus, &reg->outbound_intstatus);/*clear interrupt*/
 	while (1) {
 		if ((flag_ccb = readl(&reg->outbound_queueport)) == 0xFFFFFFFF) {
@@ -1218,17 +1791,14 @@ static void arcmsr_polling_ccbdone(struc
 				msleep(25);
 				if (poll_count > 100)
 					break;
-				goto polling_ccb_retry;
+				goto polling_hba_ccb_retry;
 			}
 		}
-		ccb = (struct CommandControlBlock *)
-			(acb->vir2phy_offset + (flag_ccb << 5));
-		if ((ccb->acb != acb) ||
-			(ccb->startdone != ARCMSR_CCB_START)) {
-			if ((ccb->startdone == ARCMSR_CCB_ABORTED) ||
-				(ccb == poll_ccb)) {
-				printk(KERN_NOTICE
-					"arcmsr%d: scsi id = %d lun = %d ccb = '0x%p'"
+		ccb = (struct CommandControlBlock *)(acb->vir2phy_offset + (flag_ccb << 5));
+		poll_ccb_done = (ccb == poll_ccb) ? 1:0;
+		if ((ccb->acb != acb) || (ccb->startdone != ARCMSR_CCB_START)) {
+			if ((ccb->startdone == ARCMSR_CCB_ABORTED) || (ccb == poll_ccb)) {
+				printk(KERN_NOTICE "arcmsr%d: scsi id = %d lun = %d ccb = '0x%p'"
 					" poll command abort successfully \n"
 					, acb->host->host_no
 					, ccb->pcmd->device->id
@@ -1239,176 +1809,280 @@ static void arcmsr_polling_ccbdone(struc
 				poll_ccb_done = 1;
 				continue;
 			}
-			printk(KERN_NOTICE
-				"arcmsr%d: polling get an illegal ccb"
-				" command done ccb ='0x%p'"
+			printk(KERN_NOTICE "arcmsr%d: polling get an illegal ccb"
+				" command done ccb = '0x%p'"
 				"ccboutstandingcount = %d \n"
 				, acb->host->host_no
 				, ccb
 				, atomic_read(&acb->ccboutstandingcount));
 			continue;
 		}
-		id = ccb->pcmd->device->id;
-		lun = ccb->pcmd->device->lun;
-		if (!(flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR)) {
-			if (acb->devstate[id][lun] == ARECA_RAID_GONE)
-				acb->devstate[id][lun] = ARECA_RAID_GOOD;
-			ccb->pcmd->result = DID_OK << 16;
-			arcmsr_ccb_complete(ccb, 1);
-		} else {
-			switch(ccb->arcmsr_cdb.DeviceStatus) {
-			case ARCMSR_DEV_SELECT_TIMEOUT: {
-					acb->devstate[id][lun] = ARECA_RAID_GONE;
-					ccb->pcmd->result = DID_NO_CONNECT << 16;
-					arcmsr_ccb_complete(ccb, 1);
-				}
-				break;
-			case ARCMSR_DEV_ABORTED:
-			case ARCMSR_DEV_INIT_FAIL: {
-					acb->devstate[id][lun] = ARECA_RAID_GONE;
-					ccb->pcmd->result = DID_BAD_TARGET << 16;
-					arcmsr_ccb_complete(ccb, 1);
+		arcmsr_report_ccb_state(acb, ccb, flag_ccb);
+	}
+}
+
+static void arcmsr_polling_hbb_ccbdone(struct AdapterControlBlock *acb, \
+					struct CommandControlBlock *poll_ccb)
+{
+		struct MessageUnit_B *reg = (struct MessageUnit_B *)acb->pmu;
+		struct CommandControlBlock *ccb;
+		uint32_t flag_ccb, poll_ccb_done = 0, poll_count = 0;
+		int index;
+
+	polling_hbb_ccb_retry:
+		poll_count++;
+		/* clear doorbell interrupt */
+		writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN, reg->iop2drv_doorbell_reg);
+		while (1){
+			index = reg->doneq_index;
+			if ((flag_ccb = readl(&reg->done_qbuffer[index])) == 0) {
+				if (poll_ccb_done)
+					break;
+				else {
+					msleep(25);
+					if (poll_count > 100)
+						break;
+					goto polling_hbb_ccb_retry;
 				}
-				break;
-			case ARCMSR_DEV_CHECK_CONDITION: {
-					acb->devstate[id][lun] = ARECA_RAID_GOOD;
-					arcmsr_report_sense_info(ccb);
+			}
+			writel(0, &reg->done_qbuffer[index]);
+			index++;
+			/*if last index number set it to 0 */
+			index %= ARCMSR_MAX_HBB_POSTQUEUE;
+			reg->doneq_index = index;
+			/* check ifcommand done with no error*/
+			ccb = (struct CommandControlBlock *)\
+      (acb->vir2phy_offset + (flag_ccb << 5));/*frame must be 32 bytes aligned*/
+			poll_ccb_done = (ccb == poll_ccb) ? 1:0;
+			if ((ccb->acb != acb) || (ccb->startdone != ARCMSR_CCB_START)) {
+				if (ccb->startdone == ARCMSR_CCB_ABORTED) {
+					printk(KERN_NOTICE "arcmsr%d: \
+		scsi id = %d lun = %d ccb = '0x%p' poll command abort successfully \n"
+						,acb->host->host_no
+						,ccb->pcmd->device->id
+						,ccb->pcmd->device->lun
+						,ccb);
+					ccb->pcmd->result = DID_ABORT << 16;
 					arcmsr_ccb_complete(ccb, 1);
+					continue;
 				}
-				break;
-			default:
-				printk(KERN_NOTICE
-					"arcmsr%d: scsi id = %d lun = %d"
-					" polling and getting command error done"
-					"but got unknown DeviceStatus = 0x%x \n"
+				printk(KERN_NOTICE "arcmsr%d: polling get an illegal ccb"
+					" command done ccb = '0x%p'"
+					"ccboutstandingcount = %d \n"
 					, acb->host->host_no
-					, id
-					, lun
-					, ccb->arcmsr_cdb.DeviceStatus);
-				acb->devstate[id][lun] = ARECA_RAID_GONE;
-				ccb->pcmd->result = DID_BAD_TARGET << 16;
-				arcmsr_ccb_complete(ccb, 1);
-				break;
+					, ccb
+					, atomic_read(&acb->ccboutstandingcount));
+				continue;
 			}
+			arcmsr_report_ccb_state(acb, ccb, flag_ccb);
+		}	/*drain reply FIFO*/
+}
+
+static void arcmsr_polling_ccbdone(struct AdapterControlBlock *acb, \
+					struct CommandControlBlock *poll_ccb)
+{
+	switch (acb->adapter_type) {
+
+	case ACB_ADAPTER_TYPE_A: {
+		arcmsr_polling_hba_ccbdone(acb,poll_ccb);
+		}
+		break;
+
+	case ACB_ADAPTER_TYPE_B: {
+		arcmsr_polling_hbb_ccbdone(acb,poll_ccb);
 		}
 	}
 }
-static void arcmsr_done4_abort_postqueue(struct AdapterControlBlock *acb)
+
+static int arcmsr_iop_confirm(struct AdapterControlBlock *acb)
 {
-	int i = 0, found = 0;
-	int id, lun;
-	uint32_t flag_ccb, outbound_intstatus;
-	struct MessageUnit __iomem *reg = acb->pmu;
-	struct CommandControlBlock *ccb;
-	/*clear and abort all outbound posted Q*/
+	uint32_t cdb_phyaddr, ccb_phyaddr_hi32;
+	dma_addr_t dma_coherent_handle;
+	/*
+	********************************************************************
+	** here we need to tell iop 331 our freeccb.HighPart
+	** if freeccb.HighPart is not zero
+	********************************************************************
+	*/
+	dma_coherent_handle = acb->dma_coherent_handle;
+	cdb_phyaddr = (uint32_t)(dma_coherent_handle);
+	ccb_phyaddr_hi32 = (uint32_t)((cdb_phyaddr >> 16) >> 16);
+	/*
+	***********************************************************************
+	**    if adapter type B, set window of "post command Q"
+	***********************************************************************
+	*/
+	switch (acb->adapter_type) {
 
-	while (((flag_ccb = readl(&reg->outbound_queueport)) != 0xFFFFFFFF) &&
-(i++ < 256)){
-		ccb = (struct CommandControlBlock *)(acb->vir2phy_offset +
-(flag_ccb << 5));
-	if (ccb){
-		if ((ccb->acb != acb)||(ccb->startdone != \
-ARCMSR_CCB_START)){
-				printk(KERN_NOTICE "arcmsr%d: polling get \
-an illegal ccb" "command done ccb = '0x%p'""ccboutstandingcount = %d \n",
-					acb->host->host_no, ccb,
-					atomic_read(&acb->ccboutstandingcount));
-				continue;
+	case ACB_ADAPTER_TYPE_A: {
+		if (ccb_phyaddr_hi32 != 0) {
+			struct MessageUnit_A __iomem *reg = \
+					(struct MessageUnit_A *)acb->pmu;
+			uint32_t intmask_org;
+			intmask_org = arcmsr_disable_outbound_ints(acb);
+			writel(ARCMSR_SIGNATURE_SET_CONFIG, \
+						&reg->message_rwbuffer[0]);
+			writel(ccb_phyaddr_hi32, &reg->message_rwbuffer[1]);
+			writel(ARCMSR_INBOUND_MESG0_SET_CONFIG, \
+							&reg->inbound_msgaddr0);
+			if (arcmsr_hba_wait_msgint_ready(acb)) {
+				printk(KERN_NOTICE "arcmsr%d: ""set ccb high \
+				part physical address timeout\n",
+				acb->host->host_no);
+				return 1;
 			}
+			arcmsr_enable_outbound_ints(acb,intmask_org);
+		}
+		}
+		break;
 
-			id = ccb->pcmd->device->id;
-			lun = ccb->pcmd->device->lun;
-			if (!(flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR)){
-				if (acb->devstate[id][lun] == ARECA_RAID_GONE)
-					acb->devstate[id][lun] = ARECA_RAID_GOOD;
-				ccb->pcmd->result = DID_OK << 16;
-				arcmsr_ccb_complete(ccb, 1);
-			}
-			else {
-				switch(ccb->arcmsr_cdb.DeviceStatus) {
-				case ARCMSR_DEV_SELECT_TIMEOUT: {
-						acb->devstate[id][lun] = ARECA_RAID_GONE;
-						ccb->pcmd->result = DID_NO_CONNECT << 16;
-						arcmsr_ccb_complete(ccb, 1);
-				}
-				break;
+	case ACB_ADAPTER_TYPE_B: {
+		unsigned long post_queue_phyaddr;
+		uint32_t *rwbuffer;
 
-				case ARCMSR_DEV_ABORTED:
+		struct MessageUnit_B *reg = (struct MessageUnit_B *)acb->pmu;
+		uint32_t intmask_org;
+		intmask_org = arcmsr_disable_outbound_ints(acb);
+		reg->postq_index = 0;
+		reg->doneq_index = 0;
+		writel(ARCMSR_MESSAGE_SET_POST_WINDOW, reg->drv2iop_doorbell_reg);
+		if (arcmsr_hbb_wait_msgint_ready(acb)) {
+			printk(KERN_NOTICE "arcmsr%d:can not set diver mode\n", \
+				acb->host->host_no);
+			return 1;
+		}
+		post_queue_phyaddr = cdb_phyaddr + ARCMSR_MAX_FREECCB_NUM * \
+		sizeof(struct CommandControlBlock) + offsetof(struct MessageUnit_B, post_qbuffer) ;
+		rwbuffer = reg->msgcode_rwbuffer_reg;
+		/* driver "set config" signature */
+		writel(ARCMSR_SIGNATURE_SET_CONFIG,rwbuffer++);
+		/* normal should be zero */
+		writel(ccb_phyaddr_hi32, rwbuffer++);
+		/* postQ size (256 + 8)*4	 */
+		writel(post_queue_phyaddr, rwbuffer++);
+		/* doneQ size (256 + 8)*4	 */
+		writel(post_queue_phyaddr + 1056, rwbuffer++);
+		/* ccb maxQ size must be --> [(256 + 8)*4]*/
+		writel(1056, rwbuffer);
+
+		writel(ARCMSR_MESSAGE_SET_CONFIG, reg->drv2iop_doorbell_reg);
+		if (arcmsr_hbb_wait_msgint_ready(acb)) {
+			printk(KERN_NOTICE "arcmsr%d: 'set command Q window' \
+			timeout \n",acb->host->host_no);
+			return 1;
+		}
+
+		writel(ARCMSR_MESSAGE_START_DRIVER_MODE, reg->drv2iop_doorbell_reg);
+		if (arcmsr_hbb_wait_msgint_ready(acb)) {
+			printk(KERN_NOTICE "arcmsr%d: 'can not set diver mode \n"\
+			,acb->host->host_no);
+			return 1;
+		}
+		arcmsr_enable_outbound_ints(acb,intmask_org);
+		}
+		break;
+	}
+	return 0;
+}
 
-				case ARCMSR_DEV_INIT_FAIL: {
-						acb->devstate[id][lun] =
-							ARECA_RAID_GONE;
-						ccb->pcmd->result =
-							DID_BAD_TARGET << 16;
-				arcmsr_ccb_complete(ccb, 1);
-				}
-				break;
+static void arcmsr_wait_firmware_ready(struct AdapterControlBlock *acb)
+{
+	uint32_t firmware_state = 0;
 
-				case ARCMSR_DEV_CHECK_CONDITION: {
-						acb->devstate[id][lun] =
-							ARECA_RAID_GOOD;
-						arcmsr_report_sense_info(ccb);
-						arcmsr_ccb_complete(ccb, 1);
-				}
-				break;
+	switch (acb->adapter_type) {
 
-				default:
-						printk(KERN_NOTICE
-						      "arcmsr%d: scsi id = %d \
-							lun = %d""polling and \
-							getting command error \
-							done""but got unknown \
-							DeviceStatus = 0x%x \n",
-							acb->host->host_no, id,
-					   lun, ccb->arcmsr_cdb.DeviceStatus);
-						acb->devstate[id][lun] =
-								ARECA_RAID_GONE;
-						ccb->pcmd->result =
-							DID_BAD_TARGET << 16;
-						arcmsr_ccb_complete(ccb, 1);
-				break;
-			       }
-	}
-		       found = 1;
-	       }
+	case ACB_ADAPTER_TYPE_A: {
+		struct MessageUnit_A __iomem *reg = (struct MessageUnit_A *)acb->pmu;
+		do {
+			firmware_state = readl(&reg->outbound_msgaddr1);
+		}while ((firmware_state & ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK) == 0);
+		}
+		break;
+
+	case ACB_ADAPTER_TYPE_B: {
+		struct MessageUnit_B *reg = (struct MessageUnit_B *)acb->pmu;
+		do {
+			firmware_state = readl(reg->iop2drv_doorbell_reg);
+		}while ((firmware_state & ARCMSR_MESSAGE_FIRMWARE_OK) == 0);
+		}
+		break;
 	}
-	if (found){
-		outbound_intstatus = readl(&reg->outbound_intstatus) & \
-			acb->outbound_int_enable;
-		writel(outbound_intstatus, &reg->outbound_intstatus);
-		/*clear interrupt*/
+}
+
+static void arcmsr_start_hba_bgrb(struct AdapterControlBlock *acb)
+{
+	struct MessageUnit_A __iomem *reg = (struct MessageUnit_A *)acb->pmu;
+	acb->acb_flags |= ACB_F_MSG_START_BGRB;
+	writel(ARCMSR_INBOUND_MESG0_START_BGRB, &reg->inbound_msgaddr0);
+	if (arcmsr_hba_wait_msgint_ready(acb)) {
+		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background \
+				rebulid' timeout \n", acb->host->host_no);
 	}
-	return;
 }
 
+static void arcmsr_start_hbb_bgrb(struct AdapterControlBlock *acb)
+{
+	struct MessageUnit_B *reg = (struct MessageUnit_B *)acb->pmu;
+	acb->acb_flags |= ACB_F_MSG_START_BGRB;
+    	writel(ARCMSR_MESSAGE_START_BGRB, reg->drv2iop_doorbell_reg);
+	if (arcmsr_hbb_wait_msgint_ready(acb)) {
+		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background \
+				rebulid' timeout \n",acb->host->host_no);
+	}
+}
 
-static void arcmsr_iop_init(struct AdapterControlBlock *acb)
+static void arcmsr_start_adapter_bgrb(struct AdapterControlBlock *acb)
 {
-	struct MessageUnit __iomem *reg = acb->pmu;
-	uint32_t intmask_org, mask, outbound_doorbell, firmware_state = 0;
+	switch (acb->adapter_type) {
+	case ACB_ADAPTER_TYPE_A:
+		arcmsr_start_hba_bgrb(acb);
+		break;
+	case ACB_ADAPTER_TYPE_B:
+		arcmsr_start_hbb_bgrb(acb);
+		break;
+	}
+}
 
-	do {
-		firmware_state = readl(&reg->outbound_msgaddr1);
-	} while (!(firmware_state & ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK));
-	intmask_org = readl(&reg->outbound_intmask)
-			| ARCMSR_MU_OUTBOUND_MESSAGE0_INTMASKENABLE;
-	arcmsr_get_firmware_spec(acb);
+static void arcmsr_clear_doorbell_queue_buffer(struct AdapterControlBlock *acb)
+{
+	switch (acb->adapter_type) {
+	case ACB_ADAPTER_TYPE_A: {
+		struct MessageUnit_A *reg = (struct MessageUnit_A *)acb->pmu;
+		uint32_t outbound_doorbell;
+		/* empty doorbell Qbuffer if door bell ringed */
+		outbound_doorbell = readl(&reg->outbound_doorbell);
+		/*clear doorbell interrupt */
+		writel(outbound_doorbell, &reg->outbound_doorbell);
+		writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK, &reg->inbound_doorbell);
+		}
+		break;
 
-	acb->acb_flags |= ACB_F_MSG_START_BGRB;
-	writel(ARCMSR_INBOUND_MESG0_START_BGRB, &reg->inbound_msgaddr0);
-	if (arcmsr_wait_msgint_ready(acb)) {
-		printk(KERN_NOTICE "arcmsr%d: "
-			"wait 'start adapter background rebulid' timeout\n",
-			acb->host->host_no);
+	case ACB_ADAPTER_TYPE_B: {
+		struct MessageUnit_B *reg = (struct MessageUnit_B *)acb->pmu;
+		/*clear interrupt and message state*/
+		writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN, reg->iop2drv_doorbell_reg);
+		writel(ARCMSR_DRV2IOP_DATA_READ_OK, reg->drv2iop_doorbell_reg);
+		/* let IOP know data has been read */
+		}
+		break;
 	}
+}
 
-	outbound_doorbell = readl(&reg->outbound_doorbell);
-	writel(outbound_doorbell, &reg->outbound_doorbell);
-	writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK, &reg->inbound_doorbell);
-	mask = ~(ARCMSR_MU_OUTBOUND_POSTQUEUE_INTMASKENABLE
-			| ARCMSR_MU_OUTBOUND_DOORBELL_INTMASKENABLE);
-	writel(intmask_org & mask, &reg->outbound_intmask);
-	acb->outbound_int_enable = ~(intmask_org & mask) & 0x000000ff;
+static void arcmsr_iop_init(struct AdapterControlBlock *acb)
+{
+    	uint32_t intmask_org;
+
+	arcmsr_wait_firmware_ready(acb);
+	arcmsr_iop_confirm(acb);
+       /* disable all outbound interrupt */
+       intmask_org = arcmsr_disable_outbound_ints(acb);
+	arcmsr_get_firmware_spec(acb);
+	/*start background rebuild*/
+	arcmsr_start_adapter_bgrb(acb);
+	/* empty doorbell Qbuffer if door bell ringed */
+	arcmsr_clear_doorbell_queue_buffer(acb);
+	/* enable outbound Post Queue,outbound doorbell Interrupt */
+	arcmsr_enable_outbound_ints(acb,intmask_org);
 	acb->acb_flags |= ACB_F_IOP_INITED;
 }
 
@@ -1422,21 +2096,21 @@ static void arcmsr_iop_reset(struct Adap
 		/* talk to iop 331 outstanding command aborted */
 		arcmsr_abort_allcmd(acb);
 		/* wait for 3 sec for all command aborted*/
-		msleep_interruptible(3000);
+		ssleep(3);
 		/* disable all outbound interrupt */
 		intmask_org = arcmsr_disable_outbound_ints(acb);
 		/* clear all outbound posted Q */
-		arcmsr_done4_abort_postqueue(acb);
+		arcmsr_done4abort_postqueue(acb);
 		for (i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
 			ccb = acb->pccb_pool[i];
 			if (ccb->startdone == ARCMSR_CCB_START) {
 				ccb->startdone = ARCMSR_CCB_ABORTED;
+				arcmsr_ccb_complete(ccb,1);
 			}
 		}
 		/* enable all outbound interrupt */
 		arcmsr_enable_outbound_ints(acb, intmask_org);
 	}
-
 }
 
 static int arcmsr_bus_reset(struct scsi_cmnd *cmd)
@@ -1450,7 +2124,7 @@ static int arcmsr_bus_reset(struct scsi_
 	for (i = 0; i < 400; i++) {
 		if (!atomic_read(&acb->ccboutstandingcount))
 			break;
-		arcmsr_interrupt(acb);
+		arcmsr_interrupt(acb);/* FIXME: need spinlock */
 		msleep(25);
 	}
 	arcmsr_iop_reset(acb);
@@ -1468,7 +2142,7 @@ static void arcmsr_abort_one_cmd(struct 
 	/*
 	** Wait for 3 sec for all command done.
 	*/
-	msleep_interruptible(3000);
+	ssleep(3);
 
 	intmask = arcmsr_disable_outbound_ints(acb);
 	arcmsr_polling_ccbdone(acb, ccb);
@@ -1515,6 +2189,8 @@ static const char *arcmsr_info(struct Sc
 
 	switch (acb->pdev->device) {
 	case PCI_DEVICE_ID_ARECA_1110:
+	case PCI_DEVICE_ID_ARECA_1200:
+	case PCI_DEVICE_ID_ARECA_1202:
 	case PCI_DEVICE_ID_ARECA_1210:
 		raid6 = 0;
 		/*FALLTHRU*/
@@ -1522,6 +2198,7 @@ static const char *arcmsr_info(struct Sc
 	case PCI_DEVICE_ID_ARECA_1130:
 	case PCI_DEVICE_ID_ARECA_1160:
 	case PCI_DEVICE_ID_ARECA_1170:
+	case PCI_DEVICE_ID_ARECA_1201:
 	case PCI_DEVICE_ID_ARECA_1220:
 	case PCI_DEVICE_ID_ARECA_1230:
 	case PCI_DEVICE_ID_ARECA_1260:
@@ -1544,287 +2221,82 @@ static const char *arcmsr_info(struct Sc
 			ARCMSR_DRIVER_VERSION);
 	return buf;
 }
-
+#ifdef CONFIG_SCSI_ARCMSR_AER
 static pci_ers_result_t arcmsr_pci_slot_reset(struct pci_dev *pdev)
 {
-	struct Scsi_Host *host;
-	struct AdapterControlBlock *acb;
-	uint8_t bus, dev_fun;
-	int error;
-
-	error = pci_enable_device(pdev);
-	if (error)
-		return PCI_ERS_RESULT_DISCONNECT;
-	pci_set_master(pdev);
-
-	host = scsi_host_alloc(&arcmsr_scsi_host_template, sizeof \
-(struct AdapterControlBlock));
-	if (!host)
-		return PCI_ERS_RESULT_DISCONNECT;
-	acb = (struct AdapterControlBlock *)host->hostdata;
-	memset(acb, 0, sizeof (struct AdapterControlBlock));
-
-	error = pci_set_dma_mask(pdev, DMA_64BIT_MASK);
-	if (error) {
-		error = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
-		if (error) {
-			printk(KERN_WARNING
-			       "scsi%d: No suitable DMA mask available\n",
-			       host->host_no);
-			return PCI_ERS_RESULT_DISCONNECT;
-		}
-	}
-	bus = pdev->bus->number;
-	dev_fun = pdev->devfn;
-	acb = (struct AdapterControlBlock *) host->hostdata;
-	memset(acb, 0, sizeof(struct AdapterControlBlock));
-	acb->pdev = pdev;
-	acb->host = host;
-	host->max_sectors = ARCMSR_MAX_XFER_SECTORS;
-	host->max_lun = ARCMSR_MAX_TARGETLUN;
-	host->max_id = ARCMSR_MAX_TARGETID;/*16:8*/
-	host->max_cmd_len = 16;    /*this is issue of 64bit LBA, over 2T byte*/
-	host->sg_tablesize = ARCMSR_MAX_SG_ENTRIES;
-	host->can_queue = ARCMSR_MAX_FREECCB_NUM; /* max simultaneous cmds */
-	host->cmd_per_lun = ARCMSR_MAX_CMD_PERLUN;
-	host->this_id = ARCMSR_SCSI_INITIATOR_ID;
-	host->unique_id = (bus << 8) | dev_fun;
-	host->irq = pdev->irq;
-	error = pci_request_regions(pdev, "arcmsr");
-	if (error)
-		return PCI_ERS_RESULT_DISCONNECT;
+	struct Scsi_Host *host = pci_get_drvdata(pdev);
+	struct AdapterControlBlock *acb =
+		(struct AdapterControlBlock *) host->hostdata;
+	uint32_t intmask_org;
+	int i, j;
 
-	acb->pmu = ioremap(pci_resource_start(pdev, 0),
-			   pci_resource_len(pdev, 0));
-	if (!acb->pmu) {
-		printk(KERN_NOTICE "arcmsr%d: memory"
-			" mapping region fail \n", acb->host->host_no);
+	if (pci_enable_device(pdev)) {
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
+	pci_set_master(pdev);
+	intmask_org = arcmsr_disable_outbound_ints(acb);
 	acb->acb_flags |= (ACB_F_MESSAGE_WQBUFFER_CLEARED |
 			   ACB_F_MESSAGE_RQBUFFER_CLEARED |
 			   ACB_F_MESSAGE_WQBUFFER_READED);
 	acb->acb_flags &= ~ACB_F_SCSISTOPADAPTER;
-	INIT_LIST_HEAD(&acb->ccb_free_list);
-
-	error = arcmsr_alloc_ccb_pool(acb);
-	if (error)
-		return PCI_ERS_RESULT_DISCONNECT;
-
-	error = request_irq(pdev->irq, arcmsr_do_interrupt,
-			IRQF_DISABLED | IRQF_SHARED, "arcmsr", acb);
-	if (error)
-		return PCI_ERS_RESULT_DISCONNECT;
-
-	arcmsr_iop_init(acb);
-	if (strncmp(acb->firm_version, "V1.42", 5) >= 0)
-	      host->max_sectors = ARCMSR_MAX_XFER_SECTORS_B;
-
-	pci_set_drvdata(pdev, host);
-
-	error = scsi_add_host(host, &pdev->dev);
-	if (error)
-		return PCI_ERS_RESULT_DISCONNECT;
+	for (i = 0; i < ARCMSR_MAX_TARGETID; i++)
+		for (j = 0; j < ARCMSR_MAX_TARGETLUN; j++)
+			acb->devstate[i][j] = ARECA_RAID_GONE;
 
-	error = arcmsr_alloc_sysfs_attr(acb);
-	if (error)
-		return PCI_ERS_RESULT_DISCONNECT;
+	arcmsr_wait_firmware_ready(acb);
+	arcmsr_iop_confirm(acb);
+       /* disable all outbound interrupt */
+	arcmsr_get_firmware_spec(acb);
+	/*start background rebuild*/
+	arcmsr_start_adapter_bgrb(acb);
+	/* empty doorbell Qbuffer if door bell ringed */
+	arcmsr_clear_doorbell_queue_buffer(acb);
+	/* enable outbound Post Queue,outbound doorbell Interrupt */
+	arcmsr_enable_outbound_ints(acb,intmask_org);
+	acb->acb_flags |= ACB_F_IOP_INITED;
 
-	scsi_scan_host(host);
+	pci_enable_pcie_error_reporting(pdev);
 	return PCI_ERS_RESULT_RECOVERED;
 }
 
 static void arcmsr_pci_ers_need_reset_forepart(struct pci_dev *pdev)
 {
 	struct Scsi_Host *host = pci_get_drvdata(pdev);
-	struct AdapterControlBlock *acb = (struct AdapterControlBlock *) host->hostdata;
-	struct MessageUnit __iomem *reg = acb->pmu;
+	struct AdapterControlBlock *acb = (struct AdapterControlBlock *)host->hostdata;
 	struct CommandControlBlock *ccb;
-	/*clear and abort all outbound posted Q*/
-	int i = 0, found = 0;
-	int id, lun;
-	uint32_t flag_ccb, outbound_intstatus;
-
-	while (((flag_ccb = readl(&reg->outbound_queueport)) != 0xFFFFFFFF) &&
-								(i++ < 256)){
-			ccb = (struct CommandControlBlock *)(acb->vir2phy_offset
-							 + (flag_ccb << 5));
-			if (ccb){
-				if ((ccb->acb != acb)||(ccb->startdone !=
-							ARCMSR_CCB_START)){
-					printk(KERN_NOTICE "arcmsr%d: polling \
-					get an illegal ccb"" command done ccb = '0x%p'"
-					"ccboutstandingcount = %d \n",
-					acb->host->host_no, ccb,
-					atomic_read(&acb->ccboutstandingcount));
-					continue;
-				}
-
-				id = ccb->pcmd->device->id;
-				lun = ccb->pcmd->device->lun;
-				if (!(flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR)) {
-					if (acb->devstate[id][lun] ==
-								ARECA_RAID_GONE)
-						acb->devstate[id][lun] =
-								ARECA_RAID_GOOD;
-					ccb->pcmd->result = DID_OK << 16;
-					arcmsr_ccb_complete(ccb, 1);
-				}
-				else {
-					switch(ccb->arcmsr_cdb.DeviceStatus) {
-					case ARCMSR_DEV_SELECT_TIMEOUT: {
-							acb->devstate[id][lun] =
-							ARECA_RAID_GONE;
-							ccb->pcmd->result =
-							DID_NO_CONNECT << 16;
-							arcmsr_ccb_complete(ccb, 1);
-					}
-					break;
-
-					case ARCMSR_DEV_ABORTED:
-
-					case ARCMSR_DEV_INIT_FAIL: {
-							acb->devstate[id][lun] =
-							 ARECA_RAID_GONE;
-							ccb->pcmd->result =
-							DID_BAD_TARGET << 16;
-							arcmsr_ccb_complete(ccb, 1);
-					}
-					break;
-
-					case ARCMSR_DEV_CHECK_CONDITION: {
-							acb->devstate[id][lun] =
-							 ARECA_RAID_GOOD;
-							arcmsr_report_sense_info(ccb);
-							arcmsr_ccb_complete(ccb, 1);
-					}
-					break;
+	uint32_t intmask_org;
+	int i = 0;
 
-					default:
-							printk(KERN_NOTICE
-								"arcmsr%d: scsi \
-								id = %d lun = %d"
-								" polling and \
-								getting command \
-								error done"
-								"but got unknown \
-							DeviceStatus = 0x%x \n"
-							, acb->host->host_no,
-								id, lun,
-						ccb->arcmsr_cdb.DeviceStatus);
-							acb->devstate[id][lun] =
-								ARECA_RAID_GONE;
-							ccb->pcmd->result =
-							DID_BAD_TARGET << 16;
-							arcmsr_ccb_complete(ccb, 1);
-					break;
-					}
-				}
-				found = 1;
+	if (atomic_read(&acb->ccboutstandingcount) != 0) {
+		/* talk to iop 331 outstanding command aborted */
+		arcmsr_abort_allcmd(acb);
+		/* wait for 3 sec for all command aborted*/
+		ssleep(3);
+		/* disable all outbound interrupt */
+		intmask_org = arcmsr_disable_outbound_ints(acb);
+		/* clear all outbound posted Q */
+		arcmsr_done4abort_postqueue(acb);
+		for (i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
+			ccb = acb->pccb_pool[i];
+			if (ccb->startdone == ARCMSR_CCB_START) {
+				ccb->startdone = ARCMSR_CCB_ABORTED;
+				arcmsr_ccb_complete(ccb,1);
 			}
 		}
-	if (found){
-		outbound_intstatus = readl(&reg->outbound_intstatus) &
-							acb->outbound_int_enable;
-		writel(outbound_intstatus, &reg->outbound_intstatus);
-		/*clear interrupt*/
-		    }
-	return;
+		/* enable all outbound interrupt */
+		arcmsr_enable_outbound_ints(acb, intmask_org);
+	}
+	pci_disable_device(pdev);
 }
 
-
 static void arcmsr_pci_ers_disconnect_forepart(struct pci_dev *pdev)
 {
-	struct Scsi_Host *host = pci_get_drvdata(pdev);
-	struct AdapterControlBlock *acb = (struct AdapterControlBlock *) host->hostdata;
-	struct MessageUnit __iomem *reg = acb->pmu;
-	struct CommandControlBlock *ccb;
-	/*clear and abort all outbound posted Q*/
-	int i = 0, found = 0;
-	int id, lun;
-	uint32_t flag_ccb, outbound_intstatus;
-
-	while (((flag_ccb = readl(&reg->outbound_queueport)) != 0xFFFFFFFF) &&
-								(i++ < 256)){
-			ccb = (struct CommandControlBlock *)(acb->vir2phy_offset +
-							(flag_ccb << 5));
-			if (ccb){
-				if ((ccb->acb != acb)||(ccb->startdone !=
-							ARCMSR_CCB_START)){
-					printk(KERN_NOTICE
-						"arcmsr%d: polling get an illegal ccb"
-						" command done ccb = '0x%p'"
-						"ccboutstandingcount = %d \n",
-						acb->host->host_no, ccb,
-						atomic_read(&acb->ccboutstandingcount));
-					continue;
-			}
-
-			id = ccb->pcmd->device->id;
-			lun = ccb->pcmd->device->lun;
-			if (!(flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR))	{
-				if (acb->devstate[id][lun] == ARECA_RAID_GONE)
-					acb->devstate[id][lun] = ARECA_RAID_GOOD;
-				ccb->pcmd->result = DID_OK << 16;
-				arcmsr_ccb_complete(ccb, 1);
-			}
-			else {
-				switch(ccb->arcmsr_cdb.DeviceStatus) {
-				case ARCMSR_DEV_SELECT_TIMEOUT: {
-						acb->devstate[id][lun] =
-								ARECA_RAID_GONE;
-						ccb->pcmd->result =
-							DID_NO_CONNECT << 16;
-						arcmsr_ccb_complete(ccb, 1);
-				}
-				break;
+			struct Scsi_Host *host = pci_get_drvdata(pdev);
+			struct AdapterControlBlock *acb	= \
+				(struct AdapterControlBlock *)host->hostdata;
 
-				case ARCMSR_DEV_ABORTED:
-
-				case ARCMSR_DEV_INIT_FAIL: {
-						acb->devstate[id][lun] =
-								ARECA_RAID_GONE;
-						ccb->pcmd->result =
-							DID_BAD_TARGET << 16;
-						arcmsr_ccb_complete(ccb, 1);
-				}
-				break;
-
-				case ARCMSR_DEV_CHECK_CONDITION: {
-						acb->devstate[id][lun] =
-								ARECA_RAID_GOOD;
-						arcmsr_report_sense_info(ccb);
-						arcmsr_ccb_complete(ccb, 1);
-				}
-				break;
-
-				default:
-						printk(KERN_NOTICE "arcmsr%d: \
-							scsi id = %d lun = %d"
-								" polling and \
-						getting command error done"
-								"but got unknown \
-						 DeviceStatus = 0x%x \n"
-								, acb->host->host_no,
-					id, lun, ccb->arcmsr_cdb.DeviceStatus);
-							acb->devstate[id][lun] =
-								ARECA_RAID_GONE;
-							ccb->pcmd->result =
-							DID_BAD_TARGET << 16;
-							arcmsr_ccb_complete(ccb, 1);
-				break;
-				}
-			}
-			found = 1;
-		}
-	}
-	if (found){
-		outbound_intstatus = readl(&reg->outbound_intstatus) &
-						acb->outbound_int_enable;
-		writel(outbound_intstatus, &reg->outbound_intstatus);
-		/*clear interrupt*/
-	}
-	return;
+			arcmsr_stop_adapter_bgrb(acb);
+			arcmsr_flush_adapter_cache(acb);
 }
 
 static pci_ers_result_t arcmsr_pci_error_detected(struct pci_dev *pdev,
@@ -1832,7 +2304,7 @@ static pci_ers_result_t arcmsr_pci_error
 {
 	switch (state) {
 	case pci_channel_io_frozen:
-			arcmsr_pci_ers_need_reset_forepart(pdev);
+	  		arcmsr_pci_ers_need_reset_forepart(pdev);
 			return PCI_ERS_RESULT_NEED_RESET;
 	case pci_channel_io_perm_failure:
 			arcmsr_pci_ers_disconnect_forepart(pdev);
@@ -1840,5 +2312,6 @@ static pci_ers_result_t arcmsr_pci_error
 			break;
 	default:
 			return PCI_ERS_RESULT_NEED_RESET;
-	}
+	  }
 }
+#endif
diff -puN include/linux/pci_ids.h~scsi-upstream-arcmsr-1200015 include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~scsi-upstream-arcmsr-1200015
+++ a/include/linux/pci_ids.h
@@ -2066,6 +2066,9 @@
 #define PCI_DEVICE_ID_ARECA_1130	0x1130
 #define PCI_DEVICE_ID_ARECA_1160	0x1160
 #define PCI_DEVICE_ID_ARECA_1170	0x1170
+#define PCI_DEVICE_ID_ARECA_1200	0x1200
+#define PCI_DEVICE_ID_ARECA_1201	0x1201
+#define PCI_DEVICE_ID_ARECA_1202	0x1202
 #define PCI_DEVICE_ID_ARECA_1210	0x1210
 #define PCI_DEVICE_ID_ARECA_1220	0x1220
 #define PCI_DEVICE_ID_ARECA_1230	0x1230
_

Patches currently in -mm which might be from nick.cheng@areca.com.tw are

scsi-upstream-arcmsr-1200015.patch
