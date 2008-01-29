From: akpm@linux-foundation.org
Subject: - usb-dma-bounce-buffer-support-v3-fix.patch removed from -mm tree
Date: Mon, 28 Jan 2008 17:49:38 -0800
Message-ID: <200801290149.m0T1ncOv027517@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38263 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753613AbYA2B7O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 20:59:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: magnus.damm@gmail.com, david-b@pacbell.net, greg@kroah.com, stern@rowland.harvard.edu, mm-commits@vger.kernel.org


The patch titled
     usb: dma bounce buffer support V3 (fix)
has been removed from the -mm tree.  Its filename was
     usb-dma-bounce-buffer-support-v3-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: dma bounce buffer support V3 (fix)
From: "Magnus Damm" <magnus.damm@gmail.com>

Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/core/hcd.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN drivers/usb/core/hcd.c~usb-dma-bounce-buffer-support-v3-fix drivers/usb/core/hcd.c
--- a/drivers/usb/core/hcd.c~usb-dma-bounce-buffer-support-v3-fix
+++ a/drivers/usb/core/hcd.c
@@ -1125,6 +1125,14 @@ static int hcd_alloc_coherent(struct usb
 	if (!vaddr)
 		return -ENOMEM;
 
+	/*
+	 * Store the virtual address of the buffer at the end
+	 * of the allocated dma buffer. The size of the buffer
+	 * may be uneven so use unaligned functions instead
+	 * of just rounding up. It makes sense to optimize for
+	 * memory footprint over access speed since the amount
+	 * of memory available for dma may be limited.
+	 */
 	put_unaligned((unsigned long)*vaddr_handle,
 		      (unsigned long *)(vaddr + size));
 
_

Patches currently in -mm which might be from magnus.damm@gmail.com are

git-sh.patch
usb-ohci-sm501-driver-v2-fix.patch
spi-superh-spi-using-sci.patch
rtc-add-support-for-epson-rtc-9701je-v2.patch
rtc-add-support-for-epson-rtc-9701je-v4.patch
sm501fb-control-panel-pin-usage-with-platform-data-flags.patch
sm501fb-clear-framebuffer-memory-and-palette.patch
