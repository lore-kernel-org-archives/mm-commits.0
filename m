From: akpm@linux-foundation.org
Subject: - scsi-handle-bad-inquiry-responses.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:16:55 -0800
Message-ID: <200702170716.l1H7GtV2021752@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51240 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946547AbXBQHRV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:17:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stern@rowland.harvard.edu, James.Bottomley@steeleye.com, mroos@linux.ee, mm-commits@vger.kernel.org


The patch titled
     scsi: handle bad inquiry responses
has been removed from the -mm tree.  Its filename was
     scsi-handle-bad-inquiry-responses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: scsi: handle bad inquiry responses
From: Alan Stern <stern@rowland.harvard.edu>

From Meelis's USB device: It contains the device's response to an INQUIRY
command.

> ffff8100795e84c0 1469131296 C Bi:006:02 0 36 = 00800001 00000000 47454e45 52494320 55534220 4449534b 20444556 49434520

The fifth byte of the response is 0, meaning that all bytes past the fifth are
invalid.  This is kind of an odd thing to do; it says the device hasn't really
sent any vendor or product information at all.  That's why you've been seeing
garbage.

The Vendor string starts at byte position 8, the Product string at
position 16, and the Revision string at position 32 (not captured by
usbmon).  Translating the bytes from hex to ASCII gives:

	Vendor:  GENERIC
	Product: USB DISK DEVICE

These certainly _seem_ valid, albeit not very specific.  Perhaps the device's
USB firmware was never customized for any OEM and the default state is marked
invalid.

There's a comment about this in the source code, asking what should be done if
the INQUIRY response is too short (as it is here).  Maybe the best approach
would be always to assume the first 36 bytes are valid, even when the device
says they aren't.  It ought to solve your problem, and it's no worse than what
we're doing now.

Cc: Meelis Roos <mroos@linux.ee>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_scan.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN drivers/scsi/scsi_scan.c~scsi-handle-bad-inquiry-responses drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c~scsi-handle-bad-inquiry-responses
+++ a/drivers/scsi/scsi_scan.c
@@ -654,6 +654,19 @@ static int scsi_probe_lun(struct scsi_de
 	 * short INQUIRY), an abort here prevents any further use of the
 	 * device, including spin up.
 	 *
+	 * On the whole, the best approach seems to be to assume the first
+	 * 36 bytes are valid no matter what the device says.  That's
+	 * better than copying < 36 bytes to the inquiry-result buffer
+	 * and displaying garbage for the Vendor, Product, or Revision
+	 * strings.
+	 */
+	if (sdev->inquiry_len < 36) {
+		printk(KERN_INFO "scsi scan: INQUIRY result too short (%d),"
+				" using 36\n", sdev->inquiry_len);
+		sdev->inquiry_len = 36;
+	}
+
+	/*
 	 * Related to the above issue:
 	 *
 	 * XXX Devices (disk or all?) should be sent a TEST UNIT READY,
_

Patches currently in -mm which might be from stern@rowland.harvard.edu are

origin.patch
git-scsi-misc.patch
