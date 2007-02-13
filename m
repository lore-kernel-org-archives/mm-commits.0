From: akpm@linux-foundation.org
Subject: + sata_nv-handle-serror-status-indication.patch added to -mm tree
Date: Mon, 12 Feb 2007 22:46:58 -0800
Message-ID: <200702130646.l1D6kwCa024247@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56623 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161056AbXBMGrJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Feb 2007 01:47:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hancockr@shaw.ca, htejun@gmail.com, jeff@garzik.org


The patch titled
     sata_nv: handle SError status indication
has been added to the -mm tree.  Its filename is
     sata_nv-handle-serror-status-indication.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sata_nv: handle SError status indication
From: Robert Hancock <hancockr@shaw.ca>

ADMA-capable controllers provide a bit in the status register that appears
to indicate that the controller detected an SError condition.  Update
sata_nv to detect this and trigger error handling in order to handle the
fault.

Signed-off-by: Robert Hancock <hancockr@shaw.ca>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_nv.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/ata/sata_nv.c~sata_nv-handle-serror-status-indication drivers/ata/sata_nv.c
--- a/drivers/ata/sata_nv.c~sata_nv-handle-serror-status-indication
+++ a/drivers/ata/sata_nv.c
@@ -827,7 +827,8 @@ static irqreturn_t nv_adma_interrupt(int
 			/* freeze if hotplugged or controller error */
 			if (unlikely(status & (NV_ADMA_STAT_HOTPLUG |
 					       NV_ADMA_STAT_HOTUNPLUG |
-					       NV_ADMA_STAT_TIMEOUT))) {
+					       NV_ADMA_STAT_TIMEOUT |
+					       NV_ADMA_STAT_SERROR))) {
 				struct ata_eh_info *ehi = &ap->eh_info;
 
 				ata_ehi_clear_desc(ehi);
@@ -841,6 +842,9 @@ static irqreturn_t nv_adma_interrupt(int
 				} else if (status & NV_ADMA_STAT_HOTUNPLUG) {
 					ata_ehi_hotplugged(ehi);
 					ata_ehi_push_desc(ehi, ": hot unplug");
+				} else if (status & NV_ADMA_STAT_SERROR) {
+					/* let libata analyze SError and figure out the cause */
+					ata_ehi_push_desc(ehi, ": SError");
 				}
 				ata_port_freeze(ap);
 				continue;
_

Patches currently in -mm which might be from hancockr@shaw.ca are

origin.patch
libata-warn-if-speed-limited-due-to-40-wire-cable.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler-tidy.patch
sata_nv-handle-serror-status-indication.patch
