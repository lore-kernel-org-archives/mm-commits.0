From: akpm@linux-foundation.org
Subject: + cciss-consolidate-duplicate-bits-in-cciss_cmdh-cciss_ioctlh.patch added to -mm tree
Date: Mon, 22 Feb 2010 14:08:12 -0800
Message-ID: <201002222208.o1MM8CaE026278@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51125 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754729Ab0BVWIX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Feb 2010 17:08:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dannf@hp.com, jens.axboe@oracle.com, scameron@beardog.cce.hp.com


The patch titled
     cciss: consolidate duplicate bits in cciss_cmd.h & cciss_ioctl.h
has been added to the -mm tree.  Its filename is
     cciss-consolidate-duplicate-bits-in-cciss_cmdh-cciss_ioctlh.patch

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
Subject: cciss: consolidate duplicate bits in cciss_cmd.h & cciss_ioctl.h
From: dann frazier <dannf@hp.com>

There are several duplicate definitions in cciss_cmd.h and cciss_ioctl.h. 
Consolidate these into the new cciss_defs.h file.  This patch doesn't
change the definitions exposed under include/linux, so userspace apps
shouldn't be affected.

Signed-off-by: dann frazier <dannf@hp.com>
Acked-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss_cmd.h   |  113 -----------------------------
 include/linux/cciss_defs.h  |  130 ++++++++++++++++++++++++++++++++++
 include/linux/cciss_ioctl.h |  129 ---------------------------------
 3 files changed, 134 insertions(+), 238 deletions(-)

diff -puN drivers/block/cciss_cmd.h~cciss-consolidate-duplicate-bits-in-cciss_cmdh-cciss_ioctlh drivers/block/cciss_cmd.h
--- a/drivers/block/cciss_cmd.h~cciss-consolidate-duplicate-bits-in-cciss_cmdh-cciss_ioctlh
+++ a/drivers/block/cciss_cmd.h
@@ -1,30 +1,16 @@
 #ifndef CCISS_CMD_H
 #define CCISS_CMD_H
+
+#include <linux/cciss_defs.h>
+
 /* DEFINES */
 #define CISS_VERSION "1.00"
 
 /* general boundary definitions */
-#define SENSEINFOBYTES          32 /* note that this value may vary
-				      between host implementations */
 #define MAXSGENTRIES            32
 #define CCISS_SG_CHAIN          0x80000000
 #define MAXREPLYQS              256
 
-/* Command Status value */
-#define CMD_SUCCESS             0x0000
-#define CMD_TARGET_STATUS       0x0001
-#define CMD_DATA_UNDERRUN       0x0002
-#define CMD_DATA_OVERRUN        0x0003
-#define CMD_INVALID             0x0004
-#define CMD_PROTOCOL_ERR        0x0005
-#define CMD_HARDWARE_ERR        0x0006
-#define CMD_CONNECTION_LOST     0x0007
-#define CMD_ABORTED             0x0008
-#define CMD_ABORT_FAILED        0x0009
-#define CMD_UNSOLICITED_ABORT   0x000A
-#define CMD_TIMEOUT             0x000B
-#define CMD_UNABORTABLE		0x000C
-
 /* Unit Attentions ASC's as defined for the MSA2012sa */
 #define POWER_OR_RESET			0x29
 #define STATE_CHANGED			0x2a
@@ -48,23 +34,6 @@
 #define ASYM_ACCESS_CHANGED		0x06
 #define LUN_CAPACITY_CHANGED		0x09
 
-/* transfer direction */
-#define XFER_NONE               0x00
-#define XFER_WRITE              0x01
-#define XFER_READ               0x02
-#define XFER_RSVD               0x03
-
-/* task attribute */
-#define ATTR_UNTAGGED           0x00
-#define ATTR_SIMPLE             0x04
-#define ATTR_HEADOFQUEUE        0x05
-#define ATTR_ORDERED            0x06
-#define ATTR_ACA                0x07
-
-/* cdb type */
-#define TYPE_CMD				0x00
-#define TYPE_MSG				0x01
-
 /* config space register offsets */
 #define CFG_VENDORID            0x00
 #define CFG_DEVICEID            0x02
@@ -103,14 +72,9 @@ typedef union _u64bit
 } u64bit;
 
 /* Type defs used in the following structs */
-#define BYTE __u8
-#define WORD __u16
-#define HWORD __u16
-#define DWORD __u32
 #define QWORD vals32 
 
 /* STRUCTURES */
-#define CISS_MAX_LUN	1024
 #define CISS_MAX_PHYS_LUN	1024
 /* SCSI-3 Cmmands */
 
@@ -176,45 +140,6 @@ typedef struct _ReadCapdata_struct_16
 #define CCISS_CACHE_FLUSH 0x01	/* C2 was already being used by CCISS */
 
 /* Command List Structure */
-typedef union _SCSI3Addr_struct {
-   struct {
-    BYTE Dev;
-    BYTE Bus:6;
-    BYTE Mode:2;        /* b00 */
-  } PeripDev;
-   struct {
-    BYTE DevLSB;
-    BYTE DevMSB:6;
-    BYTE Mode:2;        /* b01 */
-  } LogDev;
-   struct {
-    BYTE Dev:5;
-    BYTE Bus:3;
-    BYTE Targ:6;
-    BYTE Mode:2;        /* b10 */
-  } LogUnit;
-} SCSI3Addr_struct;
-
-typedef struct _PhysDevAddr_struct {
-  DWORD             TargetId:24;
-  DWORD             Bus:6;
-  DWORD             Mode:2;
-  SCSI3Addr_struct  Target[2]; /* 2 level target device addr */
-} PhysDevAddr_struct;
-  
-typedef struct _LogDevAddr_struct {
-  DWORD            VolId:30;
-  DWORD            Mode:2;
-  BYTE             reserved[4];
-} LogDevAddr_struct;
-
-typedef union _LUNAddr_struct {
-  BYTE               LunAddrBytes[8];
-  SCSI3Addr_struct   SCSI3Lun[4];
-  PhysDevAddr_struct PhysDev;
-  LogDevAddr_struct  LogDev;
-} LUNAddr_struct;
-
 #define CTLR_LUNID "\0\0\0\0\0\0\0\0"
 
 typedef struct _CommandListHeader_struct {
@@ -224,16 +149,6 @@ typedef struct _CommandListHeader_struct
   QWORD             Tag;
   LUNAddr_struct    LUN;
 } CommandListHeader_struct;
-typedef struct _RequestBlock_struct {
-  BYTE   CDBLen;
-  struct {
-    BYTE Type:3;
-    BYTE Attribute:3;
-    BYTE Direction:2;
-  } Type;
-  HWORD  Timeout;
-  BYTE   CDB[16];
-} RequestBlock_struct;
 typedef struct _ErrDescriptor_struct {
   QWORD  Addr;
   DWORD  Len;
@@ -244,28 +159,6 @@ typedef struct _SGDescriptor_struct {
   DWORD  Ext;
 } SGDescriptor_struct;
 
-typedef union _MoreErrInfo_struct{
-  struct {
-    BYTE  Reserved[3];
-    BYTE  Type;
-    DWORD ErrorInfo;
-  }Common_Info;
-  struct{
-    BYTE  Reserved[2];
-    BYTE  offense_size; /* size of offending entry */
-    BYTE  offense_num;  /* byte # of offense 0-base */
-    DWORD offense_value;
-  }Invalid_Cmd;
-}MoreErrInfo_struct;
-typedef struct _ErrorInfo_struct {
-  BYTE               ScsiStatus;
-  BYTE               SenseLen;
-  HWORD              CommandStatus;
-  DWORD              ResidualCnt;
-  MoreErrInfo_struct MoreErrInfo;
-  BYTE               SenseInfo[SENSEINFOBYTES];
-} ErrorInfo_struct;
-
 /* Command types */
 #define CMD_RWREQ       0x00
 #define CMD_IOCTL_PEND  0x01
diff -puN /dev/null include/linux/cciss_defs.h
--- /dev/null
+++ a/include/linux/cciss_defs.h
@@ -0,0 +1,130 @@
+#ifndef CCISS_DEFS_H
+#define CCISS_DEFS_H
+
+#include <linux/types.h>
+
+/* general boundary definitions */
+#define SENSEINFOBYTES          32 /* note that this value may vary
+				      between host implementations */
+
+/* Command Status value */
+#define CMD_SUCCESS             0x0000
+#define CMD_TARGET_STATUS       0x0001
+#define CMD_DATA_UNDERRUN       0x0002
+#define CMD_DATA_OVERRUN        0x0003
+#define CMD_INVALID             0x0004
+#define CMD_PROTOCOL_ERR        0x0005
+#define CMD_HARDWARE_ERR        0x0006
+#define CMD_CONNECTION_LOST     0x0007
+#define CMD_ABORTED             0x0008
+#define CMD_ABORT_FAILED        0x0009
+#define CMD_UNSOLICITED_ABORT   0x000A
+#define CMD_TIMEOUT             0x000B
+#define CMD_UNABORTABLE		0x000C
+
+/* transfer direction */
+#define XFER_NONE               0x00
+#define XFER_WRITE              0x01
+#define XFER_READ               0x02
+#define XFER_RSVD               0x03
+
+/* task attribute */
+#define ATTR_UNTAGGED           0x00
+#define ATTR_SIMPLE             0x04
+#define ATTR_HEADOFQUEUE        0x05
+#define ATTR_ORDERED            0x06
+#define ATTR_ACA                0x07
+
+/* cdb type */
+#define TYPE_CMD				0x00
+#define TYPE_MSG				0x01
+
+/* Type defs used in the following structs */
+#define BYTE __u8
+#define WORD __u16
+#define HWORD __u16
+#define DWORD __u32
+
+#define CISS_MAX_LUN	1024
+
+#define LEVEL2LUN   1 /* index into Target(x) structure, due to byte swapping */
+#define LEVEL3LUN   0
+
+#pragma pack(1)
+
+/* Command List Structure */
+typedef union _SCSI3Addr_struct {
+   struct {
+    BYTE Dev;
+    BYTE Bus:6;
+    BYTE Mode:2;        /* b00 */
+  } PeripDev;
+   struct {
+    BYTE DevLSB;
+    BYTE DevMSB:6;
+    BYTE Mode:2;        /* b01 */
+  } LogDev;
+   struct {
+    BYTE Dev:5;
+    BYTE Bus:3;
+    BYTE Targ:6;
+    BYTE Mode:2;        /* b10 */
+  } LogUnit;
+} SCSI3Addr_struct;
+
+typedef struct _PhysDevAddr_struct {
+  DWORD             TargetId:24;
+  DWORD             Bus:6;
+  DWORD             Mode:2;
+  SCSI3Addr_struct  Target[2]; /* 2 level target device addr */
+} PhysDevAddr_struct;
+
+typedef struct _LogDevAddr_struct {
+  DWORD            VolId:30;
+  DWORD            Mode:2;
+  BYTE             reserved[4];
+} LogDevAddr_struct;
+
+typedef union _LUNAddr_struct {
+  BYTE               LunAddrBytes[8];
+  SCSI3Addr_struct   SCSI3Lun[4];
+  PhysDevAddr_struct PhysDev;
+  LogDevAddr_struct  LogDev;
+} LUNAddr_struct;
+
+typedef struct _RequestBlock_struct {
+  BYTE   CDBLen;
+  struct {
+    BYTE Type:3;
+    BYTE Attribute:3;
+    BYTE Direction:2;
+  } Type;
+  HWORD  Timeout;
+  BYTE   CDB[16];
+} RequestBlock_struct;
+
+typedef union _MoreErrInfo_struct{
+  struct {
+    BYTE  Reserved[3];
+    BYTE  Type;
+    DWORD ErrorInfo;
+  } Common_Info;
+  struct{
+    BYTE  Reserved[2];
+    BYTE  offense_size; /* size of offending entry */
+    BYTE  offense_num;  /* byte # of offense 0-base */
+    DWORD offense_value;
+  } Invalid_Cmd;
+} MoreErrInfo_struct;
+typedef struct _ErrorInfo_struct {
+  BYTE               ScsiStatus;
+  BYTE               SenseLen;
+  HWORD              CommandStatus;
+  DWORD              ResidualCnt;
+  MoreErrInfo_struct MoreErrInfo;
+  BYTE               SenseInfo[SENSEINFOBYTES];
+} ErrorInfo_struct;
+
+#pragma pack()
+
+#endif /* CCISS_DEFS_H */
diff -puN include/linux/cciss_ioctl.h~cciss-consolidate-duplicate-bits-in-cciss_cmdh-cciss_ioctlh include/linux/cciss_ioctl.h
--- a/include/linux/cciss_ioctl.h~cciss-consolidate-duplicate-bits-in-cciss_cmdh-cciss_ioctlh
+++ a/include/linux/cciss_ioctl.h
@@ -3,6 +3,7 @@
 
 #include <linux/types.h>
 #include <linux/ioctl.h>
+#include <linux/cciss_defs.h>
 
 #define CCISS_IOC_MAGIC 'B'
 
@@ -36,134 +37,6 @@ typedef __u32 DriverVer_type;
 
 #define MAX_KMALLOC_SIZE 128000
 
-#ifndef CCISS_CMD_H
-/* This defines are duplicated in cciss_cmd.h in the driver directory */
-
-/* general boundary definitions */
-#define SENSEINFOBYTES          32 /* note that this value may vary
-				      between host implementations */
-
-/* Command Status value */
-#define CMD_SUCCESS             0x0000
-#define CMD_TARGET_STATUS       0x0001
-#define CMD_DATA_UNDERRUN       0x0002
-#define CMD_DATA_OVERRUN        0x0003
-#define CMD_INVALID             0x0004
-#define CMD_PROTOCOL_ERR        0x0005
-#define CMD_HARDWARE_ERR        0x0006
-#define CMD_CONNECTION_LOST     0x0007
-#define CMD_ABORTED             0x0008
-#define CMD_ABORT_FAILED        0x0009
-#define CMD_UNSOLICITED_ABORT   0x000A
-#define CMD_TIMEOUT             0x000B
-#define CMD_UNABORTABLE		0x000C
-
-/* transfer direction */
-#define XFER_NONE               0x00
-#define XFER_WRITE              0x01
-#define XFER_READ               0x02
-#define XFER_RSVD               0x03
-
-/* task attribute */
-#define ATTR_UNTAGGED           0x00
-#define ATTR_SIMPLE             0x04
-#define ATTR_HEADOFQUEUE        0x05
-#define ATTR_ORDERED            0x06
-#define ATTR_ACA                0x07
-
-/* cdb type */
-#define TYPE_CMD				0x00
-#define TYPE_MSG				0x01
-
-/* Type defs used in the following structs */
-#define BYTE __u8
-#define WORD __u16
-#define HWORD __u16
-#define DWORD __u32
-
-#define CISS_MAX_LUN	1024
-
-#define LEVEL2LUN   1 /* index into Target(x) structure, due to byte swapping */
-#define LEVEL3LUN   0
-
-#pragma pack(1)
-
-/* Command List Structure */
-typedef union _SCSI3Addr_struct {
-   struct {
-    BYTE Dev;
-    BYTE Bus:6;
-    BYTE Mode:2;        /* b00 */
-  } PeripDev;
-   struct {
-    BYTE DevLSB;
-    BYTE DevMSB:6;
-    BYTE Mode:2;        /* b01 */
-  } LogDev;
-   struct {
-    BYTE Dev:5;
-    BYTE Bus:3;
-    BYTE Targ:6;
-    BYTE Mode:2;        /* b10 */
-  } LogUnit;
-} SCSI3Addr_struct;
-
-typedef struct _PhysDevAddr_struct {
-  DWORD             TargetId:24;
-  DWORD             Bus:6;
-  DWORD             Mode:2;
-  SCSI3Addr_struct  Target[2]; /* 2 level target device addr */
-} PhysDevAddr_struct;
-  
-typedef struct _LogDevAddr_struct {
-  DWORD            VolId:30;
-  DWORD            Mode:2;
-  BYTE             reserved[4];
-} LogDevAddr_struct;
-
-typedef union _LUNAddr_struct {
-  BYTE               LunAddrBytes[8];
-  SCSI3Addr_struct   SCSI3Lun[4];
-  PhysDevAddr_struct PhysDev;
-  LogDevAddr_struct  LogDev;
-} LUNAddr_struct;
-
-typedef struct _RequestBlock_struct {
-  BYTE   CDBLen;
-  struct {
-    BYTE Type:3;
-    BYTE Attribute:3;
-    BYTE Direction:2;
-  } Type;
-  HWORD  Timeout;
-  BYTE   CDB[16];
-} RequestBlock_struct;
-
-typedef union _MoreErrInfo_struct{
-  struct {
-    BYTE  Reserved[3];
-    BYTE  Type;
-    DWORD ErrorInfo;
-  }Common_Info;
-  struct{
-    BYTE  Reserved[2];
-    BYTE  offense_size; /* size of offending entry */
-    BYTE  offense_num;  /* byte # of offense 0-base */
-    DWORD offense_value;
-  }Invalid_Cmd;
-}MoreErrInfo_struct;
-typedef struct _ErrorInfo_struct {
-  BYTE               ScsiStatus;
-  BYTE               SenseLen;
-  HWORD              CommandStatus;
-  DWORD              ResidualCnt;
-  MoreErrInfo_struct MoreErrInfo;
-  BYTE               SenseInfo[SENSEINFOBYTES];
-} ErrorInfo_struct;
-
-#pragma pack()
-#endif /* CCISS_CMD_H */ 
