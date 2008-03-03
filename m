From: akpm@linux-foundation.org
Subject: + docbook-fix-fusion-source-files.patch added to -mm tree
Date: Sun, 02 Mar 2008 23:23:37 -0800
Message-ID: <200803030723.m237Nbph004400@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57614 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751922AbYCCHXw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 02:23:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, Eric.Moore@lsil.com, James.Bottomley@HansenPartnership.com


The patch titled
     docbook: fix fusion source files
has been added to the -mm tree.  Its filename is
     docbook-fix-fusion-source-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: docbook: fix fusion source files
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix docbook problems in fusion source files.  These cause the generated
docbook to be incorrect.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptbase.c  |   25 +++++++++++++------------
 drivers/message/fusion/mptscsih.c |   14 +++++---------
 2 files changed, 18 insertions(+), 21 deletions(-)

diff -puN drivers/message/fusion/mptbase.c~docbook-fix-fusion-source-files drivers/message/fusion/mptbase.c
--- a/drivers/message/fusion/mptbase.c~docbook-fix-fusion-source-files
+++ a/drivers/message/fusion/mptbase.c
@@ -632,8 +632,7 @@ mpt_deregister(u8 cb_idx)
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
- *	mpt_event_register - Register protocol-specific event callback
- *	handler.
+ *	mpt_event_register - Register protocol-specific event callback handler.
  *	@cb_idx: previously registered (via mpt_register) callback handle
  *	@ev_cbfunc: callback function
  *
@@ -654,8 +653,7 @@ mpt_event_register(u8 cb_idx, MPT_EVHAND
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
- *	mpt_event_deregister - Deregister protocol-specific event callback
- *	handler.
+ *	mpt_event_deregister - Deregister protocol-specific event callback handler
  *	@cb_idx: previously registered callback handle
  *
  *	Each protocol-specific driver should call this routine
@@ -765,11 +763,13 @@ mpt_device_driver_deregister(u8 cb_idx)
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
- *	mpt_get_msg_frame - Obtain a MPT request frame from the pool (of 1024)
- *	allocated per MPT adapter.
+ *	mpt_get_msg_frame - Obtain an MPT request frame from the pool
  *	@cb_idx: Handle of registered MPT protocol driver
  *	@ioc: Pointer to MPT adapter structure
  *
+ *	Obtain an MPT request frame from the pool (of 1024) that are
+ *	allocated per MPT adapter.
+ *
  *	Returns pointer to a MPT request frame or %NULL if none are available
  *	or IOC is not active.
  */
@@ -834,13 +834,12 @@ mpt_get_msg_frame(u8 cb_idx, MPT_ADAPTER
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
- *	mpt_put_msg_frame - Send a protocol specific MPT request frame
- *	to a IOC.
+ *	mpt_put_msg_frame - Send a protocol-specific MPT request frame to an IOC
  *	@cb_idx: Handle of registered MPT protocol driver
  *	@ioc: Pointer to MPT adapter structure
  *	@mf: Pointer to MPT request frame
  *
- *	This routine posts a MPT request frame to the request post FIFO of a
+ *	This routine posts an MPT request frame to the request post FIFO of a
  *	specific MPT adapter.
  */
 void
@@ -868,13 +867,15 @@ mpt_put_msg_frame(u8 cb_idx, MPT_ADAPTER
 }
 
 /**
- *	mpt_put_msg_frame_hi_pri - Send a protocol specific MPT request frame
- *	to a IOC using hi priority request queue.
+ *	mpt_put_msg_frame_hi_pri - Send a hi-pri protocol-specific MPT request frame
  *	@cb_idx: Handle of registered MPT protocol driver
  *	@ioc: Pointer to MPT adapter structure
  *	@mf: Pointer to MPT request frame
  *
- *	This routine posts a MPT request frame to the request post FIFO of a
+ *	Send a protocol-specific MPT request frame to an IOC using
+ *	hi-priority request queue.
+ *
+ *	This routine posts an MPT request frame to the request post FIFO of a
  *	specific MPT adapter.
  **/
 void
diff -puN drivers/message/fusion/mptscsih.c~docbook-fix-fusion-source-files drivers/message/fusion/mptscsih.c
--- a/drivers/message/fusion/mptscsih.c~docbook-fix-fusion-source-files
+++ a/drivers/message/fusion/mptscsih.c
@@ -1533,7 +1533,7 @@ mptscsih_freeChainBuffers(MPT_ADAPTER *i
  *
  *	Remark: Currently invoked from a non-interrupt thread (_bh).
  *
- *	Remark: With old EH code, at most 1 SCSI TaskMgmt function per IOC
+ *	Note: With old EH code, at most 1 SCSI TaskMgmt function per IOC
  *	will be active.
  *
  *	Returns 0 for SUCCESS, or %FAILED.
@@ -2537,14 +2537,12 @@ mptscsih_copy_sense_data(struct scsi_cmn
 
 /**
  * mptscsih_get_scsi_lookup
- *
- * retrieves scmd entry from ScsiLookup[] array list
- *
  * @ioc: Pointer to MPT_ADAPTER structure
  * @i: index into the array
  *
- * Returns the scsi_cmd pointer
+ * retrieves scmd entry from ScsiLookup[] array list
  *
+ * Returns the scsi_cmd pointer
  **/
 static struct scsi_cmnd *
 mptscsih_get_scsi_lookup(MPT_ADAPTER *ioc, int i)
@@ -2561,14 +2559,12 @@ mptscsih_get_scsi_lookup(MPT_ADAPTER *io
 
 /**
  * mptscsih_getclear_scsi_lookup
- *
- * retrieves and clears scmd entry from ScsiLookup[] array list
- *
  * @ioc: Pointer to MPT_ADAPTER structure
  * @i: index into the array
  *
- * Returns the scsi_cmd pointer
+ * retrieves and clears scmd entry from ScsiLookup[] array list
  *
+ * Returns the scsi_cmd pointer
  **/
 static struct scsi_cmnd *
 mptscsih_getclear_scsi_lookup(MPT_ADAPTER *ioc, int i)
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-acpi.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-unionfs.patch
wireless-rt2x00-fix-driver-menu-indenting.patch
kprobes-move-kprobe-examples-to-samples.patch
x86-visws-fix-printk-format-warnings.patch
apanel-fix-kconfig-dependencies.patch
let-log_buf_shift-default-to-17.patch
documentation-move-spidev_fdx-example-to-its-own-source-file.patch
profile-likely-unlikely-macros.patch
docbook-fix-filesystemstmpl-source-files.patch
docbook-fix-rapidio-source-files.patch
docbook-fix-scsi-source-file.patch
docbook-fix-kernel-api-source-files.patch
docbook-fix-fusion-source-files.patch

