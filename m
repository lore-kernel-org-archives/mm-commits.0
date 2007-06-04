From: akpm@linux-foundation.org
Subject: + usb-try-to-debug-bug-8561.patch added to -mm tree
Date: Mon, 04 Jun 2007 13:25:38 -0700
Message-ID: <200706042025.l54KPcKX017914@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41167 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751413AbXFDUZu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jun 2007 16:25:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stern@rowland.harvard.edu, pfmp.404@gmail.com


The patch titled
     USB: try to debug Bug 8561
has been added to the -mm tree.  Its filename is
     usb-try-to-debug-bug-8561.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: USB: try to debug Bug 8561
From: Alan Stern <stern@rowland.harvard.edu>

Maybe the serial device driver is submitting an URB that is already in
use.  This patch might catch the error.

Cc: <pfmp.404@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/core/urb.c |    6 ++++++
 1 files changed, 6 insertions(+)

diff -puN drivers/usb/core/urb.c~usb-try-to-debug-bug-8561 drivers/usb/core/urb.c
--- a/drivers/usb/core/urb.c~usb-try-to-debug-bug-8561
+++ a/drivers/usb/core/urb.c
@@ -288,6 +288,12 @@ int usb_submit_urb(struct urb *urb, gfp_
 			|| dev->state == USB_STATE_SUSPENDED)
 		return -EHOSTUNREACH;
 
+	/* Not a precise test, but useful for debugging */
+	if (urb->status == -EINPROGRESS) {
+		WARN_ON(1);
+		return -EBUSY;
+	}
+
 	urb->status = -EINPROGRESS;
 	urb->actual_length = 0;
 
_

Patches currently in -mm which might be from stern@rowland.harvard.edu are

origin.patch
git-hid.patch
usb-try-to-debug-bug-8561.patch
make-alt-sysrq-p-display-the-debug-register-contents.patch
freezer-run-show_state-when-freezing-times-out.patch
