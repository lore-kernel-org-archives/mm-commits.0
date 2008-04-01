From: akpm@linux-foundation.org
Subject: - xilinx-hwicap-verify-sync-before-reading-idcode.patch removed from -mm tree
Date: Tue, 01 Apr 2008 14:38:41 -0700
Message-ID: <200804012138.m31Lcf4B014944@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49128 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759014AbYDAVj6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Apr 2008 17:39:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stephen.neuendorffer@xilinx.com, grant.likely@secretlab.ca, jwboyer@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     xilinx: hwicap: verify sync before reading idcode
has been removed from the -mm tree.  Its filename was
     xilinx-hwicap-verify-sync-before-reading-idcode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-powerpc.patch

