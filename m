From: akpm@linux-foundation.org
Subject: - usb-try-to-debug-bug-8561.patch removed from -mm tree
Date: Thu, 07 Jun 2007 08:43:25 -0700
Message-ID: <200706071543.l57FhPhx000372@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52628 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750923AbXFGPni (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jun 2007 11:43:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stern@rowland.harvard.edu, pfmp.404@gmail.com, mm-commits@vger.kernel.org


The patch titled
     USB: try to debug Bug 8561
has been removed from the -mm tree.  Its filename was
     usb-try-to-debug-bug-8561.patch

This patch was dropped because it is obsolete

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

git-hid.patch
usb-try-to-debug-bug-8561.patch
usb-serial-fix-something.patch
make-alt-sysrq-p-display-the-debug-register-contents.patch
freezer-run-show_state-when-freezing-times-out.patch
