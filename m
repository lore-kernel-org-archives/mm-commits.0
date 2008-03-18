From: akpm@linux-foundation.org
Subject: + xilinx-hwicap-verify-sync-before-reading-idcode.patch added to -mm tree
Date: Tue, 18 Mar 2008 13:25:22 -0700
Message-ID: <200803182025.m2IKPN0b014713@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758014AbYCSTmw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Mar 2008 15:42:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stephen.neuendorffer@xilinx.com, grant.likely@secretlab.ca, jwboyer@linux.vnet.ibm.com


The patch titled
     xilinx: hwicap: verify sync before reading idcode
has been added to the -mm tree.  Its filename is
     xilinx-hwicap-verify-sync-before-reading-idcode.patch

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
Subject: xilinx: hwicap: verify sync before reading idcode
From: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>

It appears that in some cases, the sync word might not be recognized by the
hardware correctly.  If this happens, then attempting to read from the port
results in an unrecoverable error because of the design of the FPGA core. 
This patch updates the code to check the status of the device before reading
the IDCODE, in order to avoid entering this unrecoverable state.  This patch
also adds additional NOOP commands into the sychronization sequence, which
appears to be necessary to avoid the condition on some hardware.

Signed-off-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/xilinx_hwicap/xilinx_hwicap.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff -puN drivers/char/xilinx_hwicap/xilinx_hwicap.c~xilinx-hwicap-verify-sync-before-reading-idcode drivers/char/xilinx_hwicap/xilinx_hwicap.c
--- a/drivers/char/xilinx_hwicap/xilinx_hwicap.c~xilinx-hwicap-verify-sync-before-reading-idcode
+++ a/drivers/char/xilinx_hwicap/xilinx_hwicap.c
@@ -250,8 +250,26 @@ static int hwicap_get_configuration_regi
 	 * Create the data to be written to the ICAP.
 	 */
 	buffer[index++] = XHI_DUMMY_PACKET;
+	buffer[index++] = XHI_NOOP_PACKET;
 	buffer[index++] = XHI_SYNC_PACKET;
 	buffer[index++] = XHI_NOOP_PACKET;
+	buffer[index++] = XHI_NOOP_PACKET;
+
+	/*
+	 * Write the data to the FIFO and initiate the transfer of data present
+	 * in the FIFO to the ICAP device.
+	 */
+	status = drvdata->config->set_configuration(drvdata,
+						    &buffer[0], index);
+	if (status)
+		return status;
+
+	/* If the syncword was not found, then we need to start over. */
+	status = drvdata->config->get_status(drvdata);
+	if ((status & XHI_SR_DALIGN_MASK) != XHI_SR_DALIGN_MASK)
+		return -EIO;
+
+	index = 0;
 	buffer[index++] = hwicap_type_1_read(reg) | 1;
 	buffer[index++] = XHI_NOOP_PACKET;
 	buffer[index++] = XHI_NOOP_PACKET;
_

Patches currently in -mm which might be from stephen.neuendorffer@xilinx.com are

xilinx-hwicap-refactor-status-handling-code.patch
xilinx-hwicap-verify-sync-before-reading-idcode.patch
xilinx-hwicap-use-fixed-device-major.patch

