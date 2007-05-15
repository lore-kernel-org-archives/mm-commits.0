From: akpm@linux-foundation.org
Subject: + usb-dont-try-to-kzalloc-0-bytes.patch added to -mm tree
Date: Tue, 15 May 2007 14:47:57 -0700
Message-ID: <200705152147.l4FLlvPe018808@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52686 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755770AbXEOVtw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 17:49:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stern@rowland.harvard.edu, greg@kroah.com


The patch titled
     USB: don't try to kzalloc 0 bytes
has been added to the -mm tree.  Its filename is
     usb-dont-try-to-kzalloc-0-bytes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

usb-dont-try-to-kzalloc-0-bytes.patch
