From: akpm@linux-foundation.org
Subject: + usb-dma-bounce-buffer-support-v3-fix.patch added to -mm tree
Date: Mon, 21 Jan 2008 23:05:48 -0800
Message-ID: <200801220705.m0M75Sif009598@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39107 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751359AbYAVHGN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jan 2008 02:06:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: magnus.damm@gmail.com, david-b@pacbell.net, greg@kroah.com, stern@rowland.harvard.edu


The patch titled
     usb: dma bounce buffer support V3 (fix)
has been added to the -mm tree.  Its filename is
     usb-dma-bounce-buffer-support-v3-fix.patch

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

usb-dma-bounce-buffer-support-v3.patch
usb-dma-bounce-buffer-support-v3-checkpatch-fixes.patch
usb-dma-bounce-buffer-support-v3-fix.patch
usb-ohci-sm501-driver-v2.patch
usb-ohci-sm501-driver-v2-fix.patch
sm501fb-control-panel-pin-usage-with-platform-data-flags.patch
sm501fb-clear-framebuffer-memory-and-palette.patch
