From: akpm@linux-foundation.org
Subject: [patch 67/78] scripts/spelling.txt: add "therfore" pattern and
 fix typo instances
Date: Mon, 27 Feb 2017 14:29:53 -0800
Message-ID: <58b4a861.Jh1ukRt5twsYhmOE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45056 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751510AbdB0Wdi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 17:33:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, yamada.masahiro@socionext.com

From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: scripts/spelling.txt: add "therfore" pattern and fix typo instances

Fix typos and add the following to the scripts/spelling.txt:

  therfore||therefore

Besides, tidy up comment blocks for 80-col wrapping.

Link: http://lkml.kernel.org/r/1481573103-11329-31-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/sw/rdmavt/mad.c                            |    6 +++---
 drivers/scsi/aacraid/linit.c                                  |    2 +-
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c |    4 ++--
 scripts/spelling.txt                                          |    1 +
 4 files changed, 7 insertions(+), 6 deletions(-)

diff -puN drivers/infiniband/sw/rdmavt/mad.c~scripts-spellingtxt-add-therfore-pattern-and-fix-typo-instances drivers/infiniband/sw/rdmavt/mad.c
--- a/drivers/infiniband/sw/rdmavt/mad.c~scripts-spellingtxt-add-therfore-pattern-and-fix-typo-instances
+++ a/drivers/infiniband/sw/rdmavt/mad.c
@@ -74,9 +74,9 @@ int rvt_process_mad(struct ib_device *ib
 		    u16 *out_mad_pkey_index)
 {
 	/*
-	 * MAD processing is quite different between hfi1 and qib. Therfore this
-	 * is expected to be provided by the driver. Other drivers in the future
-	 * may chose to implement this but it should not be made into a
+	 * MAD processing is quite different between hfi1 and qib. Therefore
+	 * this is expected to be provided by the driver. Other drivers in the
+	 * future may choose to implement this but it should not be made into a
 	 * requirement.
 	 */
 	if (ibport_num_to_idx(ibdev, port_num) < 0)
diff -puN drivers/scsi/aacraid/linit.c~scripts-spellingtxt-add-therfore-pattern-and-fix-typo-instances drivers/scsi/aacraid/linit.c
--- a/drivers/scsi/aacraid/linit.c~scripts-spellingtxt-add-therfore-pattern-and-fix-typo-instances
+++ a/drivers/scsi/aacraid/linit.c
@@ -1630,7 +1630,7 @@ static int aac_acquire_resources(struct
 
 	if (!dev->sync_mode) {
 		/* After EEH recovery or suspend resume, max_msix count
-		 * may change, therfore updating in init as well.
+		 * may change, therefore updating in init as well.
 		 */
 		dev->init->r7.no_of_msix_vectors = cpu_to_le32(dev->max_msix);
 		aac_adapter_start(dev);
diff -puN drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c~scripts-spellingtxt-add-therfore-pattern-and-fix-typo-instances drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c~scripts-spellingtxt-add-therfore-pattern-and-fix-typo-instances
+++ a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
@@ -1875,8 +1875,8 @@ vchiq_arm_init_state(VCHIQ_STATE_T *stat
 **
 ** VC_RESUME_IDLE - Initialise the resume completion at the same time.  The
 **			resume completion is in it's 'done' state whenever
-**			videcore is running.  Therfore, the VC_RESUME_IDLE state
-**			implies that videocore is suspended.
+**			videcore is running.  Therefore, the VC_RESUME_IDLE
+**			state implies that videocore is suspended.
 **			Hence, any thread which needs to wait until videocore is
 **			running can wait on this completion - it will only block
 **			if videocore is suspended.
diff -puN scripts/spelling.txt~scripts-spellingtxt-add-therfore-pattern-and-fix-typo-instances scripts/spelling.txt
--- a/scripts/spelling.txt~scripts-spellingtxt-add-therfore-pattern-and-fix-typo-instances
+++ a/scripts/spelling.txt
@@ -1041,6 +1041,7 @@ targetting||targeting
 teh||the
 temorary||temporary
 temproarily||temporarily
+therfore||therefore
 thier||their
 threds||threads
 threshhold||threshold
_
