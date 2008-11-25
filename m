From: akpm@linux-foundation.org
Subject: + fix-similar-typos-to-successfull-v2.patch added to -mm tree
Date: Tue, 25 Nov 2008 14:53:12 -0800
Message-ID: <200811252253.mAPMrCpw025801@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37771 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752369AbYKYWyj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Nov 2008 17:54:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: coyli@suse.de, heiko.carstens@de.ibm.com, jeff@garzik.org, jk@ozlabs.org, mfasheh@suse.com, randy.dunlap@oracle.com, rolandd@cisco.com, schwidefsky@de.ibm.com, sri@us.ibm.com, tytso@mit.edu, vladislav.yasevich@hp.com


The patch titled
     fix similar typos to successfull
has been added to the -mm tree.  Its filename is
     fix-similar-typos-to-successfull-v2.patch

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
Subject: fix similar typos to successfull
From: Coly Li <coyli@suse.de>

When I review ocfs2 code, find there are 2 typos to "successfull".  After
doing grep "successfull " in kernel tree, 22 typos found totally -- great
minds always think alike :)

This patch fixes all the similar typos. Thanks for Randy's ack and comments.

Signed-off-by: Coly Li <coyli@suse.de>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Roland Dreier <rolandd@cisco.com>
Cc: Jeremy Kerr <jk@ozlabs.org>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: Sridhar Samudrala <sri@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/hwmon/abituguru-datasheet   |    4 ++--
 Documentation/scsi/scsi_fc_transport.txt  |    4 ++--
 arch/powerpc/platforms/cell/spufs/spufs.h |    2 +-
 drivers/infiniband/hw/nes/nes_cm.c        |    2 +-
 drivers/isdn/hardware/eicon/debuglib.h    |    2 +-
 drivers/isdn/hardware/eicon/os_4bri.c     |    2 +-
 drivers/isdn/hardware/eicon/os_bri.c      |    2 +-
 drivers/isdn/hardware/eicon/os_pri.c      |    2 +-
 drivers/mtd/ubi/kapi.c                    |    2 +-
 drivers/net/wireless/ath5k/dma.c          |    2 +-
 drivers/net/wireless/zd1211rw/zd_mac.c    |    2 +-
 drivers/s390/block/dasd_3990_erp.c        |    2 +-
 drivers/s390/block/dasd_int.h             |    2 +-
 drivers/s390/char/tape_3590.c             |    2 +-
 drivers/s390/cio/cio.c                    |    2 +-
 drivers/s390/cio/qdio_main.c              |    2 +-
 fs/ext4/extents.c                         |    2 +-
 fs/ocfs2/dlmglue.c                        |    4 ++--
 net/sctp/auth.c                           |    2 +-
 19 files changed, 22 insertions(+), 22 deletions(-)

diff -puN Documentation/hwmon/abituguru-datasheet~fix-similar-typos-to-successfull-v2 Documentation/hwmon/abituguru-datasheet
--- a/Documentation/hwmon/abituguru-datasheet~fix-similar-typos-to-successfull-v2
+++ a/Documentation/hwmon/abituguru-datasheet
@@ -121,7 +121,7 @@ Once all bytes have been read data will 
 test for this. Notice that the number of bytes is bank address dependent see
 above and below.
 
-After completing a successfull read it is advised to put the uGuru back in
+After completing a successful read it is advised to put the uGuru back in
 ready mode, so that it is ready for the next read / write cycle. This way
 if your program / driver is unloaded and later loaded again the detection
 algorithm described above will still work.
@@ -141,7 +141,7 @@ don't ask why this is the way it is.
 
 Once DATA holds 0x01 read CMD it should hold 0xAC now.
 
-After completing a successfull write it is advised to put the uGuru back in
+After completing a successful write it is advised to put the uGuru back in
 ready mode, so that it is ready for the next read / write cycle. This way
 if your program / driver is unloaded and later loaded again the detection
 algorithm described above will still work.
diff -puN Documentation/scsi/scsi_fc_transport.txt~fix-similar-typos-to-successfull-v2 Documentation/scsi/scsi_fc_transport.txt
--- a/Documentation/scsi/scsi_fc_transport.txt~fix-similar-typos-to-successfull-v2
+++ a/Documentation/scsi/scsi_fc_transport.txt
@@ -191,7 +191,7 @@ Vport States:
       This is equivalent to a driver "attach" on an adapter, which is
       independent of the adapter's link state.
     - Instantiation of the vport on the FC link via ELS traffic, etc.
-      This is equivalent to a "link up" and successfull link initialization.
+      This is equivalent to a "link up" and successful link initialization.
   Further information can be found in the interfaces section below for
   Vport Creation.
 
@@ -320,7 +320,7 @@ Vport Creation:
       This is equivalent to a driver "attach" on an adapter, which is
       independent of the adapter's link state.
     - Instantiation of the vport on the FC link via ELS traffic, etc.
-      This is equivalent to a "link up" and successfull link initialization.
+      This is equivalent to a "link up" and successful link initialization.
 
   The LLDD's vport_create() function will not synchronously wait for both
   parts to be fully completed before returning. It must validate that the
diff -puN arch/powerpc/platforms/cell/spufs/spufs.h~fix-similar-typos-to-successfull-v2 arch/powerpc/platforms/cell/spufs/spufs.h
--- a/arch/powerpc/platforms/cell/spufs/spufs.h~fix-similar-typos-to-successfull-v2
+++ a/arch/powerpc/platforms/cell/spufs/spufs.h
@@ -314,7 +314,7 @@ extern char *isolated_loader;
  *	we need to call spu_release(ctx) before sleeping, and
  *	then spu_acquire(ctx) when awoken.
  *
- * 	Returns with state_mutex re-acquired when successfull or
+ * 	Returns with state_mutex re-acquired when successful or
  * 	with -ERESTARTSYS and the state_mutex dropped when interrupted.
  */
 
diff -puN drivers/infiniband/hw/nes/nes_cm.c~fix-similar-typos-to-successfull-v2 drivers/infiniband/hw/nes/nes_cm.c
--- a/drivers/infiniband/hw/nes/nes_cm.c~fix-similar-typos-to-successfull-v2
+++ a/drivers/infiniband/hw/nes/nes_cm.c
@@ -2712,7 +2712,7 @@ int nes_accept(struct iw_cm_id *cm_id, s
 	attr.qp_state = IB_QPS_RTS;
 	nes_modify_qp(&nesqp->ibqp, &attr, IB_QP_STATE, NULL);
 
-	/* notify OF layer that accept event was successfull */
+	/* notify OF layer that accept event was successful */
 	cm_id->add_ref(cm_id);
 
 	cm_event.event = IW_CM_EVENT_ESTABLISHED;
diff -puN drivers/isdn/hardware/eicon/debuglib.h~fix-similar-typos-to-successfull-v2 drivers/isdn/hardware/eicon/debuglib.h
--- a/drivers/isdn/hardware/eicon/debuglib.h~fix-similar-typos-to-successfull-v2
+++ a/drivers/isdn/hardware/eicon/debuglib.h
@@ -235,7 +235,7 @@ typedef void ( * DbgOld) (unsigned short
 typedef void ( * DbgEv)  (unsigned short, unsigned long, va_list) ;
 typedef void ( * DbgIrq) (unsigned short, int, char *, va_list) ;
 typedef struct _DbgHandle_
-{ char    Registered ; /* driver successfull registered */
+{ char    Registered ; /* driver successfully registered */
 #define DBG_HANDLE_REG_NEW 0x01  /* this (new) structure    */
 #define DBG_HANDLE_REG_OLD 0x7f  /* old structure (see below)  */
  char    Version;  /* version of this structure  */
diff -puN drivers/isdn/hardware/eicon/os_4bri.c~fix-similar-typos-to-successfull-v2 drivers/isdn/hardware/eicon/os_4bri.c
--- a/drivers/isdn/hardware/eicon/os_4bri.c~fix-similar-typos-to-successfull-v2
+++ a/drivers/isdn/hardware/eicon/os_4bri.c
@@ -997,7 +997,7 @@ diva_4bri_start_adapter(PISDN_ADAPTER Io
 	diva_xdi_display_adapter_features(IoAdapter->ANum);
 
 	for (i = 0; i < IoAdapter->tasks; i++) {
-		DBG_LOG(("A(%d) %s adapter successfull started",
+		DBG_LOG(("A(%d) %s adapter successfully started",
 			 IoAdapter->QuadroList->QuadroAdapter[i]->ANum,
 			 (IoAdapter->tasks == 1) ? "BRI 2.0" : "4BRI"))
 		diva_xdi_didd_register_adapter(IoAdapter->QuadroList->QuadroAdapter[i]->ANum);
diff -puN drivers/isdn/hardware/eicon/os_bri.c~fix-similar-typos-to-successfull-v2 drivers/isdn/hardware/eicon/os_bri.c
--- a/drivers/isdn/hardware/eicon/os_bri.c~fix-similar-typos-to-successfull-v2
+++ a/drivers/isdn/hardware/eicon/os_bri.c
@@ -736,7 +736,7 @@ diva_bri_start_adapter(PISDN_ADAPTER IoA
 
 	IoAdapter->Properties.Features = (word) features;
 	diva_xdi_display_adapter_features(IoAdapter->ANum);
-	DBG_LOG(("A(%d) BRI adapter successfull started", IoAdapter->ANum))
+	DBG_LOG(("A(%d) BRI adapter successfully started", IoAdapter->ANum))
 	    /*
 	       Register with DIDD
 	     */
diff -puN drivers/isdn/hardware/eicon/os_pri.c~fix-similar-typos-to-successfull-v2 drivers/isdn/hardware/eicon/os_pri.c
--- a/drivers/isdn/hardware/eicon/os_pri.c~fix-similar-typos-to-successfull-v2
+++ a/drivers/isdn/hardware/eicon/os_pri.c
@@ -513,7 +513,7 @@ diva_pri_start_adapter(PISDN_ADAPTER IoA
 
 	diva_xdi_display_adapter_features(IoAdapter->ANum);
 
-	DBG_LOG(("A(%d) PRI adapter successfull started", IoAdapter->ANum))
+	DBG_LOG(("A(%d) PRI adapter successfully started", IoAdapter->ANum))
 	/*
 	   Register with DIDD
 	 */
diff -puN drivers/mtd/ubi/kapi.c~fix-similar-typos-to-successfull-v2 drivers/mtd/ubi/kapi.c
--- a/drivers/mtd/ubi/kapi.c~fix-similar-typos-to-successfull-v2
+++ a/drivers/mtd/ubi/kapi.c
@@ -564,7 +564,7 @@ EXPORT_SYMBOL_GPL(ubi_leb_unmap);
  * @dtype: expected data type
  *
  * This function maps an un-mapped logical eraseblock @lnum to a physical
- * eraseblock. This means, that after a successfull invocation of this
+ * eraseblock. This means, that after a successful invocation of this
  * function the logical eraseblock @lnum will be empty (contain only %0xFF
  * bytes) and be mapped to a physical eraseblock, even if an unclean reboot
  * happens.
diff -puN drivers/net/wireless/ath5k/dma.c~fix-similar-typos-to-successfull-v2 drivers/net/wireless/ath5k/dma.c
--- a/drivers/net/wireless/ath5k/dma.c~fix-similar-typos-to-successfull-v2
+++ a/drivers/net/wireless/ath5k/dma.c
@@ -594,7 +594,7 @@ int ath5k_hw_get_isr(struct ath5k_hw *ah
 		 * XXX: BMISS interrupts may occur after association.
 		 * I found this on 5210 code but it needs testing. If this is
 		 * true we should disable them before assoc and re-enable them
-		 * after a successfull assoc + some jiffies.
+		 * after a successful assoc + some jiffies.
 			interrupt_mask &= ~AR5K_INT_BMISS;
 		 */
 	}
diff -puN drivers/net/wireless/zd1211rw/zd_mac.c~fix-similar-typos-to-successfull-v2 drivers/net/wireless/zd1211rw/zd_mac.c
--- a/drivers/net/wireless/zd1211rw/zd_mac.c~fix-similar-typos-to-successfull-v2
+++ a/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -287,7 +287,7 @@ static void zd_op_stop(struct ieee80211_
  * @skb - a sk-buffer
  * @flags: extra flags to set in the TX status info
  * @ackssi: ACK signal strength
- * @success - True for successfull transmission of the frame
+ * @success - True for successful transmission of the frame
  *
  * This information calls ieee80211_tx_status_irqsafe() if required by the
  * control information. It copies the control information into the status
diff -puN drivers/s390/block/dasd_3990_erp.c~fix-similar-typos-to-successfull-v2 drivers/s390/block/dasd_3990_erp.c
--- a/drivers/s390/block/dasd_3990_erp.c~fix-similar-typos-to-successfull-v2
+++ a/drivers/s390/block/dasd_3990_erp.c
@@ -2621,7 +2621,7 @@ dasd_3990_erp_action(struct dasd_ccw_req
 		}
 	}
 
-	/* double-check if current erp/cqr was successfull */
+	/* double-check if current erp/cqr was successful */
 	if ((cqr->irb.scsw.cmd.cstat == 0x00) &&
 	    (cqr->irb.scsw.cmd.dstat ==
 	     (DEV_STAT_CHN_END | DEV_STAT_DEV_END))) {
diff -puN drivers/s390/block/dasd_int.h~fix-similar-typos-to-successfull-v2 drivers/s390/block/dasd_int.h
--- a/drivers/s390/block/dasd_int.h~fix-similar-typos-to-successfull-v2
+++ a/drivers/s390/block/dasd_int.h
@@ -199,7 +199,7 @@ struct dasd_ccw_req {
 #define DASD_CQR_ERROR		0x82	/* request is completed with error */
 #define DASD_CQR_CLEAR_PENDING	0x83	/* request is clear pending */
 #define DASD_CQR_CLEARED	0x84	/* request was cleared */
-#define DASD_CQR_SUCCESS	0x85	/* request was successfull */
+#define DASD_CQR_SUCCESS	0x85	/* request was successful */
 
 
 /* per dasd_ccw_req flags */
diff -puN drivers/s390/char/tape_3590.c~fix-similar-typos-to-successfull-v2 drivers/s390/char/tape_3590.c
--- a/drivers/s390/char/tape_3590.c~fix-similar-typos-to-successfull-v2
+++ a/drivers/s390/char/tape_3590.c
@@ -804,7 +804,7 @@ tape_3590_done(struct tape_device *devic
 static inline int
 tape_3590_erp_succeded(struct tape_device *device, struct tape_request *request)
 {
-	DBF_EVENT(3, "Error Recovery successfull for %s\n",
+	DBF_EVENT(3, "Error Recovery successful for %s\n",
 		  tape_op_verbose[request->op]);
 	return tape_3590_done(device, request);
 }
diff -puN drivers/s390/cio/cio.c~fix-similar-typos-to-successfull-v2 drivers/s390/cio/cio.c
--- a/drivers/s390/cio/cio.c~fix-similar-typos-to-successfull-v2
+++ a/drivers/s390/cio/cio.c
@@ -345,7 +345,7 @@ cio_modify (struct subchannel *sch)
 		if (ccode < 0)	/* -EIO if msch gets a program check. */
 			return ccode;
 		switch (ccode) {
-		case 0: /* successfull */
+		case 0: /* successful */
 			return 0;
 		case 1:	/* status pending */
 			return -EBUSY;
diff -puN drivers/s390/cio/qdio_main.c~fix-similar-typos-to-successfull-v2 drivers/s390/cio/qdio_main.c
--- a/drivers/s390/cio/qdio_main.c~fix-similar-typos-to-successfull-v2
+++ a/drivers/s390/cio/qdio_main.c
@@ -113,7 +113,7 @@ static inline int qdio_check_ccq(struct 
  * @start: buffer number to start at
  * @count: count of buffers to examine
  *
- * Returns the number of successfull extracted equal buffer states.
+ * Returns the number of successfully extracted equal buffer states.
  * Stops processing if a state is different from the last buffers state.
  */
 static int qdio_do_eqbs(struct qdio_q *q, unsigned char *state,
diff -puN fs/ext4/extents.c~fix-similar-typos-to-successfull-v2 fs/ext4/extents.c
--- a/fs/ext4/extents.c~fix-similar-typos-to-successfull-v2
+++ a/fs/ext4/extents.c
@@ -2536,7 +2536,7 @@ static int ext4_ext_convert_to_initializ
 		 */
 		newdepth = ext_depth(inode);
 		/*
-		 * update the extent length after successfull insert of the
+		 * update the extent length after successful insert of the
 		 * split extent
 		 */
 		orig_ex.ee_len = cpu_to_le16(ee_len -
diff -puN fs/ocfs2/dlmglue.c~fix-similar-typos-to-successfull-v2 fs/ocfs2/dlmglue.c
--- a/fs/ocfs2/dlmglue.c~fix-similar-typos-to-successfull-v2
+++ a/fs/ocfs2/dlmglue.c
@@ -1325,7 +1325,7 @@ again:
 			goto out;
 		}
 
-		mlog(0, "lock %s, successfull return from ocfs2_dlm_lock\n",
+		mlog(0, "lock %s, successful return from ocfs2_dlm_lock\n",
 		     lockres->l_name);
 
 		/* At this point we've gone inside the dlm and need to
@@ -2953,7 +2953,7 @@ static int ocfs2_drop_lock(struct ocfs2_
 		ocfs2_dlm_dump_lksb(&lockres->l_lksb);
 		BUG();
 	}
-	mlog(0, "lock %s, successfull return from ocfs2_dlm_unlock\n",
+	mlog(0, "lock %s, successful return from ocfs2_dlm_unlock\n",
 	     lockres->l_name);
 
 	ocfs2_wait_on_busy_lock(lockres);
diff -puN net/sctp/auth.c~fix-similar-typos-to-successfull-v2 net/sctp/auth.c
--- a/net/sctp/auth.c~fix-similar-typos-to-successfull-v2
+++ a/net/sctp/auth.c
@@ -489,7 +489,7 @@ int sctp_auth_init_hmacs(struct sctp_end
 	return 0;
 
 out_err:
-	/* Clean up any successfull allocations */
+	/* Clean up any successful allocations */
 	sctp_auth_destroy_hmacs(ep->auth_hmacs);
 	return -ENOMEM;
 }
_

Patches currently in -mm which might be from coyli@suse.de are

linux-next.patch
fix-similar-typos-to-successfull-v2.patch

