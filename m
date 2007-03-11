From: akpm@linux-foundation.org
Subject: + remove-unused-header-file-drivers-message-fusion-lsi-mpi_inbh-and-drivers-message-fusion-lsi-mpi_log_fch.patch added to -mm tree
Date: Sat, 10 Mar 2007 23:22:36 -0800
Message-ID: <200703110722.l2B7MadC006898@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38594 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbXCKHWo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 03:22:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, Eric.Moore@lsil.com


The patch titled
     remove unused header file: drivers/message/fusion/lsi/mpi_inb.h and drivers/message/fusion/lsi/mpi_log_fc.h
has been added to the -mm tree.  Its filename is
     remove-unused-header-file-drivers-message-fusion-lsi-mpi_inbh-and-drivers-message-fusion-lsi-mpi_log_fch.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: remove unused header file: drivers/message/fusion/lsi/mpi_inb.h and drivers/message/fusion/lsi/mpi_log_fc.h
From: "Robert P. J. Day" <rpjday@mindspring.com>

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/lsi/mpi_inb.h    |  221 ----------------------
 drivers/message/fusion/lsi/mpi_log_fc.h |   89 --------
 2 files changed, 310 deletions(-)

diff -puN drivers/message/fusion/lsi/mpi_inb.h~remove-unused-header-file-drivers-message-fusion-lsi-mpi_inbh-and-drivers-message-fusion-lsi-mpi_log_fch /dev/null
--- a/drivers/message/fusion/lsi/mpi_inb.h
+++ /dev/null
@@ -1,221 +0,0 @@
-/*
- *  Copyright (c) 2003-2004 LSI Logic Corporation.
- *
- *
- *           Name:  mpi_inb.h
- *          Title:  MPI Inband structures and definitions
- *  Creation Date:  September 30, 2003
- *
- *    mpi_inb.h Version:  01.05.01
- *
- *  Version History
- *  ---------------
- *
- *  Date      Version   Description
- *  --------  --------  ------------------------------------------------------
- *  05-11-04  01.03.01  Original release.
- *  08-19-04  01.05.01  Original release for MPI v1.5.
- *  --------------------------------------------------------------------------
- */
-
-#ifndef MPI_INB_H
-#define MPI_INB_H
-
-/******************************************************************************
-*
-*        I n b a n d    M e s s a g e s
-*
-*******************************************************************************/
-
-
-/****************************************************************************/
-/* Inband Buffer Post Request                                               */
-/****************************************************************************/
-
-typedef struct _MSG_INBAND_BUFFER_POST_REQUEST
-{
-    U8                      Reserved1;          /* 00h */
-    U8                      BufferCount;        /* 01h */
-    U8                      ChainOffset;        /* 02h */
-    U8                      Function;           /* 03h */
-    U16                     Reserved2;          /* 04h */
-    U8                      Reserved3;          /* 06h */
-    U8                      MsgFlags;           /* 07h */
-    U32                     MsgContext;         /* 08h */
-    U32                     Reserved4;          /* 0Ch */
-    SGE_TRANS_SIMPLE_UNION  SGL;                /* 10h */
-} MSG_INBAND_BUFFER_POST_REQUEST, MPI_POINTER PTR_MSG_INBAND_BUFFER_POST_REQUEST,
-  MpiInbandBufferPostRequest_t , MPI_POINTER pMpiInbandBufferPostRequest_t;
-
-
-typedef struct _WWN_FC_FORMAT
-{
-    U64                     NodeName;           /* 00h */
-    U64                     PortName;           /* 08h */
-} WWN_FC_FORMAT, MPI_POINTER PTR_WWN_FC_FORMAT,
-  WwnFcFormat_t, MPI_POINTER pWwnFcFormat_t;
-
-typedef struct _WWN_SAS_FORMAT
-{
-    U64                     WorldWideID;        /* 00h */
-    U32                     Reserved1;          /* 08h */
-    U32                     Reserved2;          /* 0Ch */
-} WWN_SAS_FORMAT, MPI_POINTER PTR_WWN_SAS_FORMAT,
-  WwnSasFormat_t, MPI_POINTER pWwnSasFormat_t;
-
-typedef union _WWN_INBAND_FORMAT
-{
-    WWN_FC_FORMAT           Fc;
-    WWN_SAS_FORMAT          Sas;
-} WWN_INBAND_FORMAT, MPI_POINTER PTR_WWN_INBAND_FORMAT,
-  WwnInbandFormat, MPI_POINTER pWwnInbandFormat;
-
-
-/* Inband Buffer Post reply message */
-
-typedef struct _MSG_INBAND_BUFFER_POST_REPLY
-{
-    U16                     Reserved1;          /* 00h */
-    U8                      MsgLength;          /* 02h */
-    U8                      Function;           /* 03h */
-    U16                     Reserved2;          /* 04h */
-    U8                      Reserved3;          /* 06h */
-    U8                      MsgFlags;           /* 07h */
-    U32                     MsgContext;         /* 08h */
-    U16                     Reserved4;          /* 0Ch */
-    U16                     IOCStatus;          /* 0Eh */
-    U32                     IOCLogInfo;         /* 10h */
-    U32                     TransferLength;     /* 14h */
-    U32                     TransactionContext; /* 18h */
-    WWN_INBAND_FORMAT       Wwn;                /* 1Ch */
-    U32                     IOCIdentifier[4];   /* 2Ch */
-} MSG_INBAND_BUFFER_POST_REPLY, MPI_POINTER PTR_MSG_INBAND_BUFFER_POST_REPLY,
-  MpiInbandBufferPostReply_t, MPI_POINTER pMpiInbandBufferPostReply_t;
-
-
-/****************************************************************************/
-/* Inband Send Request                                                      */
-/****************************************************************************/
-
-typedef struct _MSG_INBAND_SEND_REQUEST
-{
-    U16                     Reserved1;          /* 00h */
-    U8                      ChainOffset;        /* 02h */
-    U8                      Function;           /* 03h */
-    U16                     Reserved2;          /* 04h */
-    U8                      Reserved3;          /* 06h */
-    U8                      MsgFlags;           /* 07h */
-    U32                     MsgContext;         /* 08h */
-    U32                     Reserved4;          /* 0Ch */
-    WWN_INBAND_FORMAT       Wwn;                /* 10h */
-    U32                     Reserved5;          /* 20h */
-    SGE_IO_UNION            SGL;                /* 24h */
-} MSG_INBAND_SEND_REQUEST, MPI_POINTER PTR_MSG_INBAND_SEND_REQUEST,
-  MpiInbandSendRequest_t , MPI_POINTER pMpiInbandSendRequest_t;
-
-
-/* Inband Send reply message */
-
-typedef struct _MSG_INBAND_SEND_REPLY
-{
-    U16                     Reserved1;          /* 00h */
-    U8                      MsgLength;          /* 02h */
-    U8                      Function;           /* 03h */
-    U16                     Reserved2;          /* 04h */
-    U8                      Reserved3;          /* 06h */
-    U8                      MsgFlags;           /* 07h */
-    U32                     MsgContext;         /* 08h */
-    U16                     Reserved4;          /* 0Ch */
-    U16                     IOCStatus;          /* 0Eh */
-    U32                     IOCLogInfo;         /* 10h */
-    U32                     ResponseLength;     /* 14h */
-} MSG_INBAND_SEND_REPLY, MPI_POINTER PTR_MSG_INBAND_SEND_REPLY,
-  MpiInbandSendReply_t, MPI_POINTER pMpiInbandSendReply_t;
-
-
-/****************************************************************************/
-/* Inband Response Request                                                  */
-/****************************************************************************/
-
-typedef struct _MSG_INBAND_RSP_REQUEST
-{
-    U16                     Reserved1;          /* 00h */
-    U8                      ChainOffset;        /* 02h */
-    U8                      Function;           /* 03h */
-    U16                     Reserved2;          /* 04h */
-    U8                      Reserved3;          /* 06h */
-    U8                      MsgFlags;           /* 07h */
-    U32                     MsgContext;         /* 08h */
-    U32                     Reserved4;          /* 0Ch */
-    WWN_INBAND_FORMAT       Wwn;                /* 10h */
-    U32                     IOCIdentifier[4];   /* 20h */
-    U32                     ResponseLength;     /* 30h */
-    SGE_IO_UNION            SGL;                /* 34h */
-} MSG_INBAND_RSP_REQUEST, MPI_POINTER PTR_MSG_INBAND_RSP_REQUEST,
-  MpiInbandRspRequest_t , MPI_POINTER pMpiInbandRspRequest_t;
-
-
-/* Inband Response reply message */
-
-typedef struct _MSG_INBAND_RSP_REPLY
-{
-    U16                     Reserved1;          /* 00h */
-    U8                      MsgLength;          /* 02h */
-    U8                      Function;           /* 03h */
-    U16                     Reserved2;          /* 04h */
-    U8                      Reserved3;          /* 06h */
-    U8                      MsgFlags;           /* 07h */
-    U32                     MsgContext;         /* 08h */
-    U16                     Reserved4;          /* 0Ch */
-    U16                     IOCStatus;          /* 0Eh */
-    U32                     IOCLogInfo;         /* 10h */
-} MSG_INBAND_RSP_REPLY, MPI_POINTER PTR_MSG_INBAND_RSP_REPLY,
-  MpiInbandRspReply_t, MPI_POINTER pMpiInbandRspReply_t;
-
-
-/****************************************************************************/
-/* Inband Abort Request                                                     */
-/****************************************************************************/
-
-typedef struct _MSG_INBAND_ABORT_REQUEST
-{
-    U8                      Reserved1;          /* 00h */
-    U8                      AbortType;          /* 01h */
-    U8                      ChainOffset;        /* 02h */
-    U8                      Function;           /* 03h */
-    U16                     Reserved2;          /* 04h */
-    U8                      Reserved3;          /* 06h */
-    U8                      MsgFlags;           /* 07h */
-    U32                     MsgContext;         /* 08h */
-    U32                     Reserved4;          /* 0Ch */
-    U32                     ContextToAbort;     /* 10h */
-} MSG_INBAND_ABORT_REQUEST, MPI_POINTER PTR_MSG_INBAND_ABORT_REQUEST,
-  MpiInbandAbortRequest_t , MPI_POINTER pMpiInbandAbortRequest_t;
-
-#define MPI_INBAND_ABORT_TYPE_ALL_BUFFERS       (0x00)
-#define MPI_INBAND_ABORT_TYPE_EXACT_BUFFER      (0x01)
-#define MPI_INBAND_ABORT_TYPE_SEND_REQUEST      (0x02)
-#define MPI_INBAND_ABORT_TYPE_RESPONSE_REQUEST  (0x03)
-
-
-/* Inband Abort reply message */
-
-typedef struct _MSG_INBAND_ABORT_REPLY
-{
-    U8                      Reserved1;          /* 00h */
-    U8                      AbortType;          /* 01h */
-    U8                      MsgLength;          /* 02h */
-    U8                      Function;           /* 03h */
-    U16                     Reserved2;          /* 04h */
-    U8                      Reserved3;          /* 06h */
-    U8                      MsgFlags;           /* 07h */
-    U32                     MsgContext;         /* 08h */
-    U16                     Reserved4;          /* 0Ch */
-    U16                     IOCStatus;          /* 0Eh */
-    U32                     IOCLogInfo;         /* 10h */
-} MSG_INBAND_ABORT_REPLY, MPI_POINTER PTR_MSG_INBAND_ABORT_REPLY,
-  MpiInbandAbortReply_t, MPI_POINTER pMpiInbandAbortReply_t;
-
-
-#endif
-
diff -puN drivers/message/fusion/lsi/mpi_log_fc.h~remove-unused-header-file-drivers-message-fusion-lsi-mpi_inbh-and-drivers-message-fusion-lsi-mpi_log_fch /dev/null
--- a/drivers/message/fusion/lsi/mpi_log_fc.h
+++ /dev/null
@@ -1,89 +0,0 @@
-/*
- *  Copyright (c) 2000-2001 LSI Logic Corporation. All rights reserved.
- *
- *  NAME:           fc_log.h
- *  SUMMARY:        MPI IocLogInfo definitions for the SYMFC9xx chips
- *  DESCRIPTION:    Contains the enumerated list of values that may be returned
- *                  in the IOCLogInfo field of a MPI Default Reply Message.
- *
- *  CREATION DATE:  6/02/2000
- *  ID:             $Id: fc_log.h,v 4.6 2001/07/26 14:41:33 sschremm Exp $
- */
-
-
-/*
- * MpiIocLogInfo_t enum
- *
- * These 32 bit values are used in the IOCLogInfo field of the MPI reply
- * messages.
- * The value is 0xabcccccc where
- *          a = The type of log info as per the MPI spec. Since these codes are
- *              all for Fibre Channel this value will always be 2.
- *          b = Specifies a subclass of the firmware where
- *                  0 = FCP Initiator
- *                  1 = FCP Target
- *                  2 = LAN
- *                  3 = MPI Message Layer
- *                  4 = FC Link
- *                  5 = Context Manager
- *                  6 = Invalid Field Offset
- *                  7 = State Change Info
- *                  all others are reserved for future use
- *          c = A specific value within the subclass.
- *
- * NOTE: Any new values should be added to the end of each subclass so that the
- *       codes remain consistent across firmware releases.
- */
-typedef enum _MpiIocLogInfoFc
-{
-    MPI_IOCLOGINFO_FC_INIT_BASE                     = 0x20000000,
-    MPI_IOCLOGINFO_FC_INIT_ERROR_OUT_OF_ORDER_FRAME = 0x20000001, /* received an out of order frame - unsupported */
-    MPI_IOCLOGINFO_FC_INIT_ERROR_BAD_START_OF_FRAME = 0x20000002, /* Bad Rx Frame, bad start of frame primative */
-    MPI_IOCLOGINFO_FC_INIT_ERROR_BAD_END_OF_FRAME   = 0x20000003, /* Bad Rx Frame, bad end of frame primative */
-    MPI_IOCLOGINFO_FC_INIT_ERROR_OVER_RUN           = 0x20000004, /* Bad Rx Frame, overrun */
-    MPI_IOCLOGINFO_FC_INIT_ERROR_RX_OTHER           = 0x20000005, /* Other errors caught by IOC which require retries */
-    MPI_IOCLOGINFO_FC_INIT_ERROR_SUBPROC_DEAD       = 0x20000006, /* Main processor could not initialize sub-processor */
-    MPI_IOCLOGINFO_FC_INIT_ERROR_RX_OVERRUN         = 0x20000007, /* Scatter Gather overrun  */
-    MPI_IOCLOGINFO_FC_INIT_ERROR_RX_BAD_STATUS      = 0x20000008, /* Receiver detected context mismatch via invalid header */
-    MPI_IOCLOGINFO_FC_INIT_ERROR_RX_UNEXPECTED_FRAME= 0x20000009, /* CtxMgr detected unsupported frame type  */
-    MPI_IOCLOGINFO_FC_INIT_ERROR_LINK_FAILURE       = 0x2000000A, /* Link failure occurred  */
-    MPI_IOCLOGINFO_FC_INIT_ERROR_TX_TIMEOUT         = 0x2000000B, /* Transmitter timeout error */
-
-    MPI_IOCLOGINFO_FC_TARGET_BASE                   = 0x21000000,
-    MPI_IOCLOGINFO_FC_TARGET_NO_PDISC               = 0x21000001, /* not sent because we are waiting for a PDISC from the initiator */
-    MPI_IOCLOGINFO_FC_TARGET_NO_LOGIN               = 0x21000002, /* not sent because we are not logged in to the remote node */
-    MPI_IOCLOGINFO_FC_TARGET_DOAR_KILLED_BY_LIP     = 0x21000003, /* Data Out, Auto Response, not sent due to a LIP */
-    MPI_IOCLOGINFO_FC_TARGET_DIAR_KILLED_BY_LIP     = 0x21000004, /* Data In, Auto Response, not sent due to a LIP */
-    MPI_IOCLOGINFO_FC_TARGET_DIAR_MISSING_DATA      = 0x21000005, /* Data In, Auto Response, missing data frames */
-    MPI_IOCLOGINFO_FC_TARGET_DONR_KILLED_BY_LIP     = 0x21000006, /* Data Out, No Response, not sent due to a LIP */
-    MPI_IOCLOGINFO_FC_TARGET_WRSP_KILLED_BY_LIP     = 0x21000007, /* Auto-response after a write not sent due to a LIP */
-    MPI_IOCLOGINFO_FC_TARGET_DINR_KILLED_BY_LIP     = 0x21000008, /* Data In, No Response, not completed due to a LIP */
-    MPI_IOCLOGINFO_FC_TARGET_DINR_MISSING_DATA      = 0x21000009, /* Data In, No Response, missing data frames */
-    MPI_IOCLOGINFO_FC_TARGET_MRSP_KILLED_BY_LIP     = 0x2100000a, /* Manual Response not sent due to a LIP */
-    MPI_IOCLOGINFO_FC_TARGET_NO_CLASS_3             = 0x2100000b, /* not sent because remote node does not support Class 3 */
-    MPI_IOCLOGINFO_FC_TARGET_LOGIN_NOT_VALID        = 0x2100000c, /* not sent because login to remote node not validated */
-    MPI_IOCLOGINFO_FC_TARGET_FROM_OUTBOUND          = 0x2100000e, /* cleared from the outbound queue after a logout */
-    MPI_IOCLOGINFO_FC_TARGET_WAITING_FOR_DATA_IN    = 0x2100000f, /* cleared waiting for data after a logout */
-
-    MPI_IOCLOGINFO_FC_LAN_BASE                      = 0x22000000,
-    MPI_IOCLOGINFO_FC_LAN_TRANS_SGL_MISSING         = 0x22000001, /* Transaction Context Sgl Missing */
-    MPI_IOCLOGINFO_FC_LAN_TRANS_WRONG_PLACE         = 0x22000002, /* Transaction Context found before an EOB */
-    MPI_IOCLOGINFO_FC_LAN_TRANS_RES_BITS_SET        = 0x22000003, /* Transaction Context value has reserved bits set */
-    MPI_IOCLOGINFO_FC_LAN_WRONG_SGL_FLAG            = 0x22000004, /* Invalid SGL Flags */
-
-    MPI_IOCLOGINFO_FC_MSG_BASE                      = 0x23000000,
-
-    MPI_IOCLOGINFO_FC_LINK_BASE                     = 0x24000000,
-    MPI_IOCLOGINFO_FC_LINK_LOOP_INIT_TIMEOUT        = 0x24000001, /* Loop initialization timed out */
-    MPI_IOCLOGINFO_FC_LINK_ALREADY_INITIALIZED      = 0x24000002, /* Another system controller already initialized the loop */
-    MPI_IOCLOGINFO_FC_LINK_LINK_NOT_ESTABLISHED     = 0x24000003, /* Not synchronized to signal or still negotiating (possible cable problem) */
-    MPI_IOCLOGINFO_FC_LINK_CRC_ERROR                = 0x24000004, /* CRC check detected error on received frame */
-
-    MPI_IOCLOGINFO_FC_CTX_BASE                      = 0x25000000,
-
-    MPI_IOCLOGINFO_FC_INVALID_FIELD_BYTE_OFFSET     = 0x26000000, /* The lower 24 bits give the byte offset of the field in the request message that is invalid */
-    MPI_IOCLOGINFO_FC_INVALID_FIELD_MAX_OFFSET      = 0x26ffffff,
-
-    MPI_IOCLOGINFO_FC_STATE_CHANGE                  = 0x27000000  /* The lower 24 bits give additional information concerning state change */
-
-} MpiIocLogInfoFc_t;
_

Patches currently in -mm which might be from rpjday@mindspring.com are

git-avr32.patch
mtd-correct-misspelled-preprocessor-variable.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
reiserfs-correct-misspelled-reiserfs_proc_info-to.patch
kconfig-centralize-the-selection-of-semaphore-debugging.patch
rocket-remove-modversions-include.patch
remove-unused-header-file-sound-pci-cs46xx-imgs-cwcemb80h.patch
remove-unused-header-file-include-linux-elfnoteh.patch
remove-unused-header-file-drivers-video-riva-nv4refh.patch
remove-unused-header-file-drivers-serial-crisv10h.patch
remove-unused-header-file-drivers-net-wan-lmc-lmc_mediah.patch
remove-unused-header-file-drivers-net-skfp-h-lnkstath.patch
remove-unused-header-file-drivers-message-i2o-i2o_lanh.patch
remove-unused-header-file-drivers-message-fusion-lsi-mpi_inbh-and-drivers-message-fusion-lsi-mpi_log_fch.patch
remove-unused-header-file-drivers-char-drm-via_mmh.patch
remove-unused-header-file-drivers-char-digih.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
remove-unused-header-file-arch-ppc-syslib-cpc710h.patch
remove-unused-header-file-arch-powerpc-platforms-83xx-mpc834x_itxh.patch
remove-unused-header-file-arch-m68k-atari-atasoundh.patch
remove-unused-header-file-arch-arm-mach-s3c2410-basth.patch
