From: akpm@linux-foundation.org
Subject: - usb-use-div_round_up.patch removed from -mm tree
Date: Thu, 06 Mar 2008 14:22:20 -0800
Message-ID: <200803062222.m26MMKcl020803@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34448 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755595AbYCFWW4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 17:22:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usb: use DIV_ROUND_UP
has been removed from the -mm tree.  Its filename was
     usb-use-div_round_up.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: use DIV_ROUND_UP
From: Julia Lawall <julia@diku.dk>

The kernel.h macro DIV_ROUND_UP performs the computation (((n) + (d) - 1) /
(d)) but is perhaps more readable.

An extract of the semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@haskernel@
@@

#include <linux/kernel.h>

@depends on haskernel@
expression n,d;
@@

(
- (n + d - 1) / d
+ DIV_ROUND_UP(n,d)
|
- (n + (d - 1)) / d
+ DIV_ROUND_UP(n,d)
)

@depends on haskernel@
expression n,d;
@@

- DIV_ROUND_UP((n),d)
+ DIV_ROUND_UP(n,d)

@depends on haskernel@
expression n,d;
@@

- DIV_ROUND_UP(n,(d))
+ DIV_ROUND_UP(n,d)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/r8a66597-hcd.c |    6 +++---
 drivers/usb/misc/usbtest.c      |    2 +-
 drivers/usb/serial/ftdi_sio.c   |    4 ++--
 drivers/usb/serial/io_ti.c      |    2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/usb/host/r8a66597-hcd.c~usb-use-div_round_up drivers/usb/host/r8a66597-hcd.c
--- a/drivers/usb/host/r8a66597-hcd.c~usb-use-div_round_up
+++ a/drivers/usb/host/r8a66597-hcd.c
@@ -959,9 +959,9 @@ static void prepare_packet_read(struct r
 				r8a66597_write(r8a66597, TRCLR,
 						td->pipe->pipetre);
 				r8a66597_write(r8a66597,
-						(urb->transfer_buffer_length
-						+ td->maxpacket - 1)
-						/ td->maxpacket,
+						DIV_ROUND_UP
+						  (urb->transfer_buffer_length,
+						   td->maxpacket),
 						td->pipe->pipetrn);
 				r8a66597_bset(r8a66597, TRENB,
 						td->pipe->pipetre);
diff -puN drivers/usb/misc/usbtest.c~usb-use-div_round_up drivers/usb/misc/usbtest.c
--- a/drivers/usb/misc/usbtest.c~usb-use-div_round_up
+++ a/drivers/usb/misc/usbtest.c
@@ -1403,7 +1403,7 @@ static struct urb *iso_alloc_urb (
 		return NULL;
 	maxp = 0x7ff & le16_to_cpu(desc->wMaxPacketSize);
 	maxp *= 1 + (0x3 & (le16_to_cpu(desc->wMaxPacketSize) >> 11));
-	packets = (bytes + maxp - 1) / maxp;
+	packets = DIV_ROUND_UP(bytes, maxp);
 
 	urb = usb_alloc_urb (packets, GFP_KERNEL);
 	if (!urb)
diff -puN drivers/usb/serial/ftdi_sio.c~usb-use-div_round_up drivers/usb/serial/ftdi_sio.c
--- a/drivers/usb/serial/ftdi_sio.c~usb-use-div_round_up
+++ a/drivers/usb/serial/ftdi_sio.c
@@ -1380,7 +1380,7 @@ static void ftdi_write_bulk_callback (st
 	data_offset = priv->write_offset;
 	if (data_offset > 0) {
 		/* Subtract the control bytes */
-		countback -= (data_offset * ((countback + (PKTSZ - 1)) / PKTSZ));
+		countback -= (data_offset * DIV_ROUND_UP(countback, PKTSZ));
 	}
 	spin_lock_irqsave(&priv->tx_lock, flags);
 	--priv->tx_outstanding_urbs;
@@ -1480,7 +1480,7 @@ static void ftdi_read_bulk_callback (str
 
 	/* count data bytes, but not status bytes */
 	countread = urb->actual_length;
-	countread -= 2 * ((countread + (PKTSZ - 1)) / PKTSZ);
+	countread -= 2 * DIV_ROUND_UP(countread, PKTSZ);
 	spin_lock_irqsave(&priv->rx_lock, flags);
 	priv->rx_bytes += countread;
 	spin_unlock_irqrestore(&priv->rx_lock, flags);
diff -puN drivers/usb/serial/io_ti.c~usb-use-div_round_up drivers/usb/serial/io_ti.c
--- a/drivers/usb/serial/io_ti.c~usb-use-div_round_up
+++ a/drivers/usb/serial/io_ti.c
@@ -655,7 +655,7 @@ static void TIChasePort(struct edgeport_
 	/* (TIIsTxActive doesn't seem to wait for the last byte) */
 	if ((baud_rate=port->baud_rate) == 0)
 		baud_rate = 50;
-	msleep(max(1,(10000+baud_rate-1)/baud_rate));
+	msleep(max(1, DIV_ROUND_UP(10000, baud_rate)));
 }
 
 static int TIChooseConfiguration (struct usb_device *dev)
_

Patches currently in -mm which might be from julia@diku.dk are

sound-use-bug_on.patch
git-powerpc.patch
drivers-block-viodasdc-use-field_sizeof.patch
git-dvb.patch
git-hid.patch
git-udf.patch
drivers-net-mv643xx_ethc-use-field_sizeof.patch
git-ocfs2.patch
drivers-net-wireless-iwlwifi-iwl-4965c-correct-use-of-and.patch
drivers-acpi-asus_acpic-correct-use-of-and.patch
fs-affs-filec-use-bug_on.patch
fbdev-use-div_round_up-or-roundup.patch
fs-ext2-use-bug_on.patch
fs-ext3-use-bug_on.patch
fs-ext4-use-bug_on.patch

