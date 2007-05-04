From: akpm@linux-foundation.org
Subject: - revert-fusion-move-spi-api-over-to-mptspic.patch removed from -mm tree
Date: Thu, 03 May 2007 17:21:54 -0700
Message-ID: <200705040021.l440Ls0k025719@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:32935 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423559AbXEDAV5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 20:21:57 -0400
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp1.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l440LtEE010930
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Thu, 3 May 2007 17:21:56 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     revert "[SCSI] fusion - move SPI API over to mptspi.c"
has been removed from the -mm tree.  Its filename was
     revert-fusion-move-spi-api-over-to-mptspic.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: revert "[SCSI] fusion - move SPI API over to mptspi.c"
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptscsih.c |  284 ++++++++++++++++++++++++++++
 drivers/message/fusion/mptspi.c   |  268 --------------------------
 2 files changed, 285 insertions(+), 267 deletions(-)

diff -puN drivers/message/fusion/mptscsih.c~revert-fusion-move-spi-api-over-to-mptspic drivers/message/fusion/mptscsih.c
--- a/drivers/message/fusion/mptscsih.c~revert-fusion-move-spi-api-over-to-mptspic
+++ a/drivers/message/fusion/mptscsih.c
@@ -98,6 +98,9 @@ static int	mptscsih_IssueTaskMgmt(MPT_SC
 int		mptscsih_ioc_reset(MPT_ADAPTER *ioc, int post_reset);
 int		mptscsih_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply);
 
+static void	mptscsih_initTarget(MPT_SCSI_HOST *hd, VirtTarget *vtarget, struct scsi_device *sdev);
+static void	mptscsih_setTargetNegoParms(MPT_SCSI_HOST *hd, VirtTarget *vtarget, struct scsi_device *sdev);
+static int	mptscsih_writeIOCPage4(MPT_SCSI_HOST *hd, int channel, int id);
 int		mptscsih_scandv_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *r);
 static int	mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTERNAL_CMD *iocmd);
 static void	mptscsih_synchronize_cache(MPT_SCSI_HOST *hd, VirtDevice *vdevice);
@@ -2410,6 +2413,7 @@ mptscsih_slave_configure(struct scsi_dev
 	}
 
 	vdevice->configured_lun = 1;
+	mptscsih_initTarget(hd, vtarget, sdev);
 	mptscsih_change_queue_depth(sdev, MPT_SCSI_CMD_PER_DEV_HIGH);
 
 	dsprintk((MYIOC_s_INFO_FMT
@@ -2673,6 +2677,286 @@ mptscsih_event_process(MPT_ADAPTER *ioc,
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*
+ *	mptscsih_initTarget - Target, LUN alloc/free functionality.
+ *	@hd: Pointer to MPT_SCSI_HOST structure
+ *	@vtarget: per target private data
+ *	@sdev: SCSI device
+ *
+ *	NOTE: It's only SAFE to call this routine if data points to
+ *	sane & valid STANDARD INQUIRY data!
+ *
+ *	Allocate and initialize memory for this target.
+ *	Save inquiry data.
+ *
+ */
+static void
+mptscsih_initTarget(MPT_SCSI_HOST *hd, VirtTarget *vtarget,
+		    struct scsi_device *sdev)
+{
+	dinitprintk((MYIOC_s_INFO_FMT "initTarget channel=%d id=%d lun=%d hd=%p\n",
+		hd->ioc->name, vtarget->channel, vtarget->id,
+		sdev->lun, hd));
+
+	/* Is LUN supported? If so, upper 2 bits will be 0
+	* in first byte of inquiry data.
+	*/
+	if (sdev->inq_periph_qual != 0)
+		return;
+
+	if (vtarget == NULL)
+		return;
+
+	vtarget->type = sdev->type;
+
+	if (hd->ioc->bus_type != SPI)
+		return;
+
+	if ((sdev->type == TYPE_PROCESSOR) && (hd->ioc->spi_data.Saf_Te)) {
+		/* Treat all Processors as SAF-TE if
+		 * command line option is set */
+		vtarget->tflags |= MPT_TARGET_FLAGS_SAF_TE_ISSUED;
+		mptscsih_writeIOCPage4(hd, vtarget->channel, vtarget->id);
+	}else if ((sdev->type == TYPE_PROCESSOR) &&
+		!(vtarget->tflags & MPT_TARGET_FLAGS_SAF_TE_ISSUED )) {
+		if (sdev->inquiry_len > 49 ) {
+			if (sdev->inquiry[44] == 'S' &&
+			    sdev->inquiry[45] == 'A' &&
+			    sdev->inquiry[46] == 'F' &&
+			    sdev->inquiry[47] == '-' &&
+			    sdev->inquiry[48] == 'T' &&
+			    sdev->inquiry[49] == 'E' ) {
+				vtarget->tflags |= MPT_TARGET_FLAGS_SAF_TE_ISSUED;
+				mptscsih_writeIOCPage4(hd, vtarget->channel, vtarget->id);
+			}
+		}
+	}
+	mptscsih_setTargetNegoParms(hd, vtarget, sdev);
+}
+
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+/*
+ *  Update the target negotiation parameters based on the
+ *  the Inquiry data, adapter capabilities, and NVRAM settings.
+ *
+ */
+static void
+mptscsih_setTargetNegoParms(MPT_SCSI_HOST *hd, VirtTarget *target,
+			    struct scsi_device *sdev)
+{
+	SpiCfgData *pspi_data = &hd->ioc->spi_data;
+	int  id = (int) target->id;
+	int  nvram;
+	u8 width = MPT_NARROW;
+	u8 factor = MPT_ASYNC;
+	u8 offset = 0;
+	u8 nfactor;
+	u8 noQas = 1;
+
+	target->negoFlags = pspi_data->noQas;
+
+	/* noQas == 0 => device supports QAS. */
+
+	if (sdev->scsi_level < SCSI_2) {
+		width = 0;
+		factor = MPT_ULTRA2;
+		offset = pspi_data->maxSyncOffset;
+		target->tflags &= ~MPT_TARGET_FLAGS_Q_YES;
+	} else {
+		if (scsi_device_wide(sdev)) {
+			width = 1;
+		}
+
+		if (scsi_device_sync(sdev)) {
+			factor = pspi_data->minSyncFactor;
+			if (!scsi_device_dt(sdev))
+					factor = MPT_ULTRA2;
+			else {
+				if (!scsi_device_ius(sdev) &&
+				    !scsi_device_qas(sdev))
+					factor = MPT_ULTRA160;
+				else {
+					factor = MPT_ULTRA320;
+					if (scsi_device_qas(sdev)) {
+						ddvtprintk((KERN_INFO "Enabling QAS due to byte56=%02x on id=%d!\n", scsi_device_qas(sdev), id));
+						noQas = 0;
+					}
+					if (sdev->type == TYPE_TAPE &&
+					    scsi_device_ius(sdev))
+						target->negoFlags |= MPT_TAPE_NEGO_IDP;
+				}
+			}
+			offset = pspi_data->maxSyncOffset;
+
+			/* If RAID, never disable QAS
+			 * else if non RAID, do not disable
+			 *   QAS if bit 1 is set
+			 * bit 1 QAS support, non-raid only
+			 * bit 0 IU support
+			 */
+			if (target->raidVolume == 1) {
+				noQas = 0;
+			}
+		} else {
+			factor = MPT_ASYNC;
+			offset = 0;
+		}
+	}
+
+	if (!sdev->tagged_supported) {
+		target->tflags &= ~MPT_TARGET_FLAGS_Q_YES;
+	}
+
+	/* Update tflags based on NVRAM settings. (SCSI only)
+	 */
+	if (pspi_data->nvram && (pspi_data->nvram[id] != MPT_HOST_NVRAM_INVALID)) {
+		nvram = pspi_data->nvram[id];
+		nfactor = (nvram & MPT_NVRAM_SYNC_MASK) >> 8;
+
+		if (width)
+			width = nvram & MPT_NVRAM_WIDE_DISABLE ? 0 : 1;
+
+		if (offset > 0) {
+			/* Ensure factor is set to the
+			 * maximum of: adapter, nvram, inquiry
+			 */
+			if (nfactor) {
+				if (nfactor < pspi_data->minSyncFactor )
+					nfactor = pspi_data->minSyncFactor;
+
+				factor = max(factor, nfactor);
+				if (factor == MPT_ASYNC)
+					offset = 0;
+			} else {
+				offset = 0;
+				factor = MPT_ASYNC;
+		}
+		} else {
+			factor = MPT_ASYNC;
+		}
+	}
+
+	/* Make sure data is consistent
+	 */
+	if ((!width) && (factor < MPT_ULTRA2)) {
+		factor = MPT_ULTRA2;
+	}
+
+	/* Save the data to the target structure.
+	 */
+	target->minSyncFactor = factor;
+	target->maxOffset = offset;
+	target->maxWidth = width;
+
+	target->tflags |= MPT_TARGET_FLAGS_VALID_NEGO;
+
+	/* Disable unused features.
+	 */
+	if (!width)
+		target->negoFlags |= MPT_TARGET_NO_NEGO_WIDE;
+
+	if (!offset)
+		target->negoFlags |= MPT_TARGET_NO_NEGO_SYNC;
+
+	if ( factor > MPT_ULTRA320 )
+		noQas = 0;
+
+	if (noQas && (pspi_data->noQas == 0)) {
+		pspi_data->noQas |= MPT_TARGET_NO_NEGO_QAS;
+		target->negoFlags |= MPT_TARGET_NO_NEGO_QAS;
+
+		/* Disable QAS in a mixed configuration case
+		 */
+
+		ddvtprintk((KERN_INFO "Disabling QAS due to noQas=%02x on id=%d!\n", noQas, id));
+	}
+}
+
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+/*
+ *  SCSI Config Page functionality ...
+ */
+
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+/*	mptscsih_writeIOCPage4  - write IOC Page 4
+ *	@hd: Pointer to a SCSI Host Structure
+ *	@channel: write IOC Page4 for this Bus
+ *	@id: write IOC Page4 for this ID
+ *
+ *	Return: -EAGAIN if unable to obtain a Message Frame
+ *		or 0 if success.
+ *
+ *	Remark: We do not wait for a return, write pages sequentially.
+ */
+static int
+mptscsih_writeIOCPage4(MPT_SCSI_HOST *hd, int channel, int id)
+{
+	MPT_ADAPTER		*ioc = hd->ioc;
+	Config_t		*pReq;
+	IOCPage4_t		*IOCPage4Ptr;
+	MPT_FRAME_HDR		*mf;
+	dma_addr_t		 dataDma;
+	u16			 req_idx;
+	u32			 frameOffset;
+	u32			 flagsLength;
+	int			 ii;
+
+	/* Get a MF for this command.
+	 */
+	if ((mf = mpt_get_msg_frame(ioc->DoneCtx, ioc)) == NULL) {
+		dfailprintk((MYIOC_s_WARN_FMT "writeIOCPage4 : no msg frames!\n",
+					ioc->name));
+		return -EAGAIN;
+	}
+
+	/* Set the request and the data pointers.
+	 * Place data at end of MF.
+	 */
+	pReq = (Config_t *)mf;
+
+	req_idx = le16_to_cpu(mf->u.frame.hwhdr.msgctxu.fld.req_idx);
+	frameOffset = ioc->req_sz - sizeof(IOCPage4_t);
+
+	/* Complete the request frame (same for all requests).
+	 */
+	pReq->Action = MPI_CONFIG_ACTION_PAGE_WRITE_CURRENT;
+	pReq->Reserved = 0;
+	pReq->ChainOffset = 0;
+	pReq->Function = MPI_FUNCTION_CONFIG;
+	pReq->ExtPageLength = 0;
+	pReq->ExtPageType = 0;
+	pReq->MsgFlags = 0;
+	for (ii=0; ii < 8; ii++) {
+		pReq->Reserved2[ii] = 0;
+	}
+
+	IOCPage4Ptr = ioc->spi_data.pIocPg4;
+	dataDma = ioc->spi_data.IocPg4_dma;
+	ii = IOCPage4Ptr->ActiveSEP++;
+	IOCPage4Ptr->SEP[ii].SEPTargetID = id;
+	IOCPage4Ptr->SEP[ii].SEPBus = channel;
+	pReq->Header = IOCPage4Ptr->Header;
+	pReq->PageAddress = cpu_to_le32(id | (channel << 8 ));
+
+	/* Add a SGE to the config request.
+	 */
+	flagsLength = MPT_SGE_FLAGS_SSIMPLE_WRITE |
+		(IOCPage4Ptr->Header.PageLength + ii) * 4;
+
+	mpt_add_sge((char *)&pReq->PageBufferSGE, flagsLength, dataDma);
+
+	dinitprintk((MYIOC_s_INFO_FMT
+		"writeIOCPage4: MaxSEP=%d ActiveSEP=%d channel=%d id=%d \n",
+			ioc->name, IOCPage4Ptr->MaxSEP, IOCPage4Ptr->ActiveSEP, channel, id));
+
+	mpt_put_msg_frame(ioc->DoneCtx, ioc, mf);
+
+	return 0;
+}
+
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+/*
  *  Bus Scan and Domain Validation functionality ...
  */
 
diff -puN drivers/message/fusion/mptspi.c~revert-fusion-move-spi-api-over-to-mptspic drivers/message/fusion/mptspi.c
--- a/drivers/message/fusion/mptspi.c~revert-fusion-move-spi-api-over-to-mptspic
+++ a/drivers/message/fusion/mptspi.c
@@ -95,269 +95,6 @@ static int	mptspiDoneCtx = -1;
 static int	mptspiTaskCtx = -1;
 static int	mptspiInternalCtx = -1; /* Used only for internal commands */
 
-/**
- * 	mptspi_setTargetNegoParms  - Update the target negotiation
- *	parameters based on the the Inquiry data, adapter capabilities,
- *	and NVRAM settings
- *
- *	@hd: Pointer to a SCSI Host Structure
- *	@vtarget: per target private data
- *	@sdev: SCSI device
- *
- **/
-static void
-mptspi_setTargetNegoParms(MPT_SCSI_HOST *hd, VirtTarget *target,
-			    struct scsi_device *sdev)
-{
-	SpiCfgData *pspi_data = &hd->ioc->spi_data;
-	int  id = (int) target->id;
-	int  nvram;
-	u8 width = MPT_NARROW;
-	u8 factor = MPT_ASYNC;
-	u8 offset = 0;
-	u8 nfactor;
-	u8 noQas = 1;
-
-	target->negoFlags = pspi_data->noQas;
-
-	if (sdev->scsi_level < SCSI_2) {
-		width = 0;
-		factor = MPT_ULTRA2;
-		offset = pspi_data->maxSyncOffset;
-		target->tflags &= ~MPT_TARGET_FLAGS_Q_YES;
-	} else {
-		if (scsi_device_wide(sdev))
-			width = 1;
-
-		if (scsi_device_sync(sdev)) {
-			factor = pspi_data->minSyncFactor;
-			if (!scsi_device_dt(sdev))
-					factor = MPT_ULTRA2;
-			else {
-				if (!scsi_device_ius(sdev) &&
-				    !scsi_device_qas(sdev))
-					factor = MPT_ULTRA160;
-				else {
-					factor = MPT_ULTRA320;
-					if (scsi_device_qas(sdev)) {
-						ddvprintk((KERN_INFO "Enabling QAS due to byte56=%02x on id=%d!\n", scsi_device_qas(sdev), id));
-						noQas = 0;
-					}
-					if (sdev->type == TYPE_TAPE &&
-					    scsi_device_ius(sdev))
-						target->negoFlags |= MPT_TAPE_NEGO_IDP;
-				}
-			}
-			offset = pspi_data->maxSyncOffset;
-
-			/* If RAID, never disable QAS
-			 * else if non RAID, do not disable
-			 *   QAS if bit 1 is set
-			 * bit 1 QAS support, non-raid only
-			 * bit 0 IU support
-			 */
-			if (target->raidVolume == 1)
-				noQas = 0;
-		} else {
-			factor = MPT_ASYNC;
-			offset = 0;
-		}
-	}
-
-	if (!sdev->tagged_supported)
-		target->tflags &= ~MPT_TARGET_FLAGS_Q_YES;
-
-	/* Update tflags based on NVRAM settings. (SCSI only)
-	 */
-	if (pspi_data->nvram && (pspi_data->nvram[id] != MPT_HOST_NVRAM_INVALID)) {
-		nvram = pspi_data->nvram[id];
-		nfactor = (nvram & MPT_NVRAM_SYNC_MASK) >> 8;
-
-		if (width)
-			width = nvram & MPT_NVRAM_WIDE_DISABLE ? 0 : 1;
-
-		if (offset > 0) {
-			/* Ensure factor is set to the
-			 * maximum of: adapter, nvram, inquiry
-			 */
-			if (nfactor) {
-				if (nfactor < pspi_data->minSyncFactor )
-					nfactor = pspi_data->minSyncFactor;
-
-				factor = max(factor, nfactor);
-				if (factor == MPT_ASYNC)
-					offset = 0;
-			} else {
-				offset = 0;
-				factor = MPT_ASYNC;
-		}
-		} else {
-			factor = MPT_ASYNC;
-		}
-	}
-
-	/* Make sure data is consistent
-	 */
-	if ((!width) && (factor < MPT_ULTRA2))
-		factor = MPT_ULTRA2;
-
-	/* Save the data to the target structure.
-	 */
-	target->minSyncFactor = factor;
-	target->maxOffset = offset;
-	target->maxWidth = width;
-
-	target->tflags |= MPT_TARGET_FLAGS_VALID_NEGO;
-
-	/* Disable unused features.
-	 */
-	if (!width)
-		target->negoFlags |= MPT_TARGET_NO_NEGO_WIDE;
-
-	if (!offset)
-		target->negoFlags |= MPT_TARGET_NO_NEGO_SYNC;
-
-	if ( factor > MPT_ULTRA320 )
-		noQas = 0;
-
-	if (noQas && (pspi_data->noQas == 0)) {
-		pspi_data->noQas |= MPT_TARGET_NO_NEGO_QAS;
-		target->negoFlags |= MPT_TARGET_NO_NEGO_QAS;
-
-		/* Disable QAS in a mixed configuration case
-		 */
-
-		ddvprintk((KERN_INFO "Disabling QAS due to noQas=%02x on id=%d!\n", noQas, id));
-	}
-}
-
-/**
- * 	mptspi_writeIOCPage4  - write IOC Page 4
- *	@hd: Pointer to a SCSI Host Structure
- *	@channel:
- *	@id: write IOC Page4 for this ID & Bus
- *
- *	Return: -EAGAIN if unable to obtain a Message Frame
- *		or 0 if success.
- *
- *	Remark: We do not wait for a return, write pages sequentially.
- **/
-static int
-mptspi_writeIOCPage4(MPT_SCSI_HOST *hd, u8 channel , u8 id)
-{
-	MPT_ADAPTER		*ioc = hd->ioc;
-	Config_t		*pReq;
-	IOCPage4_t		*IOCPage4Ptr;
-	MPT_FRAME_HDR		*mf;
-	dma_addr_t		 dataDma;
-	u16			 req_idx;
-	u32			 frameOffset;
-	u32			 flagsLength;
-	int			 ii;
-
-	/* Get a MF for this command.
-	 */
-	if ((mf = mpt_get_msg_frame(ioc->DoneCtx, ioc)) == NULL) {
-		dfailprintk((MYIOC_s_WARN_FMT "writeIOCPage4 : no msg frames!\n",
-					ioc->name));
-		return -EAGAIN;
-	}
-
-	/* Set the request and the data pointers.
-	 * Place data at end of MF.
-	 */
-	pReq = (Config_t *)mf;
-
-	req_idx = le16_to_cpu(mf->u.frame.hwhdr.msgctxu.fld.req_idx);
-	frameOffset = ioc->req_sz - sizeof(IOCPage4_t);
-
-	/* Complete the request frame (same for all requests).
-	 */
-	pReq->Action = MPI_CONFIG_ACTION_PAGE_WRITE_CURRENT;
-	pReq->Reserved = 0;
-	pReq->ChainOffset = 0;
-	pReq->Function = MPI_FUNCTION_CONFIG;
-	pReq->ExtPageLength = 0;
-	pReq->ExtPageType = 0;
-	pReq->MsgFlags = 0;
-	for (ii=0; ii < 8; ii++) {
-		pReq->Reserved2[ii] = 0;
-	}
-
-	IOCPage4Ptr = ioc->spi_data.pIocPg4;
-	dataDma = ioc->spi_data.IocPg4_dma;
-	ii = IOCPage4Ptr->ActiveSEP++;
-	IOCPage4Ptr->SEP[ii].SEPTargetID = id;
-	IOCPage4Ptr->SEP[ii].SEPBus = channel;
-	pReq->Header = IOCPage4Ptr->Header;
-	pReq->PageAddress = cpu_to_le32(id | (channel << 8 ));
-
-	/* Add a SGE to the config request.
-	 */
-	flagsLength = MPT_SGE_FLAGS_SSIMPLE_WRITE |
-		(IOCPage4Ptr->Header.PageLength + ii) * 4;
-
-	mpt_add_sge((char *)&pReq->PageBufferSGE, flagsLength, dataDma);
-
-	ddvprintk((MYIOC_s_INFO_FMT
-		"writeIOCPage4: MaxSEP=%d ActiveSEP=%d id=%d bus=%d\n",
-			ioc->name, IOCPage4Ptr->MaxSEP, IOCPage4Ptr->ActiveSEP, id, channel));
-
-	mpt_put_msg_frame(ioc->DoneCtx, ioc, mf);
-
-	return 0;
-}
-
-/**
- *	mptspi_initTarget - Target, LUN alloc/free functionality.
- *	@hd: Pointer to MPT_SCSI_HOST structure
- *	@vtarget: per target private data
- *	@sdev: SCSI device
- *
- *	NOTE: It's only SAFE to call this routine if data points to
- *	sane & valid STANDARD INQUIRY data!
- *
- *	Allocate and initialize memory for this target.
- *	Save inquiry data.
- *
- **/
-static void
-mptspi_initTarget(MPT_SCSI_HOST *hd, VirtTarget *vtarget,
-		    struct scsi_device *sdev)
-{
-
-	/* Is LUN supported? If so, upper 2 bits will be 0
-	* in first byte of inquiry data.
-	*/
-	if (sdev->inq_periph_qual != 0)
-		return;
-
-	if (vtarget == NULL)
-		return;
-
-	vtarget->type = sdev->type;
-
-	if ((sdev->type == TYPE_PROCESSOR) && (hd->ioc->spi_data.Saf_Te)) {
-		/* Treat all Processors as SAF-TE if
-		 * command line option is set */
-		vtarget->tflags |= MPT_TARGET_FLAGS_SAF_TE_ISSUED;
-		mptspi_writeIOCPage4(hd, vtarget->channel, vtarget->id);
-	}else if ((sdev->type == TYPE_PROCESSOR) &&
-		!(vtarget->tflags & MPT_TARGET_FLAGS_SAF_TE_ISSUED )) {
-		if (sdev->inquiry_len > 49 ) {
-			if (sdev->inquiry[44] == 'S' &&
-			    sdev->inquiry[45] == 'A' &&
-			    sdev->inquiry[46] == 'F' &&
-			    sdev->inquiry[47] == '-' &&
-			    sdev->inquiry[48] == 'T' &&
-			    sdev->inquiry[49] == 'E' ) {
-				vtarget->tflags |= MPT_TARGET_FLAGS_SAF_TE_ISSUED;
-				mptspi_writeIOCPage4(hd, vtarget->channel, vtarget->id);
-			}
-		}
-	}
-	mptspi_setTargetNegoParms(hd, vtarget, sdev);
-}
 
 /**
  *	mptspi_is_raid - Determines whether target is belonging to volume
@@ -723,16 +460,13 @@ static int mptspi_slave_alloc(struct scs
 
 static int mptspi_slave_configure(struct scsi_device *sdev)
 {
+	int ret = mptscsih_slave_configure(sdev);
 	struct _MPT_SCSI_HOST *hd =
 		(struct _MPT_SCSI_HOST *)sdev->host->hostdata;
-	VirtTarget *vtarget = scsi_target(sdev)->hostdata;
-	int ret = mptscsih_slave_configure(sdev);
 
 	if (ret)
 		return ret;
 
-	mptspi_initTarget(hd, vtarget, sdev);
-
 	ddvprintk((MYIOC_s_INFO_FMT "id=%d min_period=0x%02x"
 		" max_offset=0x%02x max_width=%d\n", hd->ioc->name,
 		sdev->id, spi_min_period(scsi_target(sdev)),
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slab-introduce-krealloc.patch
rm9000-serial-driver.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
smaps-add-clear_refs-file-to-clear-reference.patch
slab-mark-set_up_list3s-__init.patch
slub-core.patch
mm-optimize-kill_bdev.patch
get_unmapped_area-handles-map_fixed-in-hugetlbfs-fix.patch
srmcons-fix-kmallocgfp_kernel-inside-spinlock.patch
uml-driver-formatting-fixes-fix.patch
cx88-video-build-fix.patch
git-acpi.patch
git-alsa.patch
git-agpgart.patch
working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch
git-arm.patch
git-avr32.patch
fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed.patch
git-drm.patch
cinergyt2-fix-file-release-handler.patch
git-gfs2-nmw.patch
git-hid-fixup.patch
git-ieee1394.patch
sbp2-include-fixes.patch
ieee1394-iso-needs-schedh.patch
git-input.patch
git-jfs.patch
git-kbuild.patch
git-kvm.patch
git-mmc.patch
git-mtd.patch
natsemi-allow-users-to-disable-workaround-for-dspcfg-reset-fix.patch
git-e1000.patch
git-e1000-fixup-2.patch
input-rfkill-add-support-for-input-key-to-control-wireless-radio.patch
git-nfs.patch
git-ocfs2.patch
git-parisc.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
git-sh-fixup.patch
git-scsi-misc.patch
revert-fusion-move-spi-api-over-to-mptspic.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-block-fixup.patch
git-unionfs.patch
auerswald-fix-file-release-handler.patch
git-wireless.patch
fix-x86_64-mm-mtrr-save-the-mtrrs-of-the-bsp-before-booting-an-ap.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
i386-add-support-for-picopower-irq-router-fix.patch
xfs-clean-up-shrinker-games.patch
lazy-freeing-of-memory-through-madv_free.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
mm-move-common-segment-checks-to-separate-helper-function-v7.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
virtual_eisa_root_init-should-be-__init.patch
proc-maps-protection.patch
fix-cycladesh-for-x86_64-and-probably-others.patch
rtc-add-rtc-rs5c313-driver.patch
enlarge-console-name.patch
move-die-notifier-handling-to-common-code.patch
fix-sscanf-%n-match-at-end-of-input-string.patch
parport-dev-driver-model-support.patch
add-support-for-deferrable-timers-respun.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
time-smp-friendly-alignment-of-struct-clocksource.patch
move-timekeeping-code-to-timekeepingc.patch
fix-kevents-childs-priority-greediness.patch
display-all-possible-partitions-when-the-root-filesystem-failed-to-mount.patch
enhance-initcall_debug-measure-latency.patch
dtlk-fix-error-checks-in-module_init.patch
document-spin_lock_unlocked-rw_lock_unlocked-deprecation.patch
upper-32-bits.patch
driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core.patch
do_tty_write-can-block-even-with-o_nonblock-tidy.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
kthread-dont-depend-on-work-queues-take-2.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
speedup-divides-by-cpu_power-in-scheduler.patch
utimensat-implementation.patch
revert-rtc-add-rtc_merge_alarm.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout.patch
kprobes-the-on-off-knob-thru-debugfs-updated.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
linux-kernel-markers-i386-optimization.patch
signal-timer-event-fds-v9-signalfd-core.patch
signal-timer-event-fds-v9-timerfd-core.patch
signal-timer-event-fds-v9-eventfd-core.patch
revoke-core-code-fix-shared-mapping-revoke.patch
revoke-wire-up-i386-system-calls.patch
x86-serial-convert-legacy-com-ports-to-platform-devices.patch
lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda.patch
lguest-the-host-code-vs-x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions.patch
lguest-the-host-code-vs-futex-new-private-futexes.patch
fs-convert-core-functions-to-zero_user_page-pass-kmap-type.patch
fs-convert-core-functions-to-zero_user_page-fix-2.patch
ntfs-use-zero_user_page-fix.patch
make-vm-statistics-update-interval-configurable-fix.patch
acpi-keep-tsc-stable-when-lapic_timer_c2_ok-is-set-vs-x86_64-mm-log-reason-why-tsc-was-marked-unstable.patch
rename-thread_info-to-stack-fix.patch
reiser4-slab-allocators-remove-slab_debug_initial-flag.patch
fbdev-hecuba-framebuffer-driver.patch
vt-add-color-support-to-the-underline-and-italic-attributes-fix.patch
sm501fb-printk-warning-fixes.patch
integrity-new-hooks-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix-2.patch
integrity-ima-integrity_measure-support-tidy.patch
integrity-ima-integrity_measure-support-fix.patch
integrity-ima-integrity_measure-support-fix-2.patch
integrity-tpm-internal-kernel-interface-tidy.patch
w1-build-fix.patch
