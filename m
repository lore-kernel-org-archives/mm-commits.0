From: akpm@linux-foundation.org
Subject: - usb-dont-try-to-kzalloc-0-bytes.patch removed from -mm tree
Date: Mon, 21 May 2007 16:17:22 -0700
Message-ID: <200705212317.l4LNHL93022464@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41684 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755412AbXEUXS5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 19:18:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stern@rowland.harvard.edu, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     USB: don't try to kzalloc 0 bytes
has been removed from the -mm tree.  Its filename was
     usb-dont-try-to-kzalloc-0-bytes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: USB: don't try to kzalloc 0 bytes
From: Alan Stern <stern@rowland.harvard.edu>

This patch (as907) prevents us from trying to allocate 0 bytes
when an interface has no endpoint descriptors.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/core/config.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/usb/core/config.c~usb-dont-try-to-kzalloc-0-bytes drivers/usb/core/config.c
--- a/drivers/usb/core/config.c~usb-dont-try-to-kzalloc-0-bytes
+++ a/drivers/usb/core/config.c
@@ -185,10 +185,12 @@ static int usb_parse_interface(struct de
 		num_ep = USB_MAXENDPOINTS;
 	}
 
-	len = sizeof(struct usb_host_endpoint) * num_ep;
-	alt->endpoint = kzalloc(len, GFP_KERNEL);
-	if (!alt->endpoint)
-		return -ENOMEM;
+	if (num_ep > 0) {	/* Can't allocate 0 bytes */
+		len = sizeof(struct usb_host_endpoint) * num_ep;
+		alt->endpoint = kzalloc(len, GFP_KERNEL);
+		if (!alt->endpoint)
+			return -ENOMEM;
+	}
 
 	/* Parse all the endpoint descriptors */
 	n = 0;
_

Patches currently in -mm which might be from stern@rowland.harvard.edu are

revert-gregkh-usb-usb-make-the-autosuspend-workqueue-thread-freezable.patch
fix-usb-ohci-subvendor-for-toshiba-portege-4000.patch
hisax-fix-error-checking-for-hisax_register.patch
usb-fix-suspend-to-ram.patch
