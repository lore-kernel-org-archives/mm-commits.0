From: akpm@linux-foundation.org
Subject: [merged] usb-imx_udc-fix-leak-in-imx_ep_alloc_request.patch removed from -mm tree
Date: Wed, 03 Jun 2009 13:02:24 -0700
Message-ID: <200906032002.n53K2Od0001749@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43868 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754857AbZFCUCh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jun 2009 16:02:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel@caiaq.de, augulis.darius@gmail.com, david-b@pacbell.net, eemike@gmail.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usb: imx_udc: fix leak in imx_ep_alloc_request()
has been removed from the -mm tree.  Its filename was
     usb-imx_udc-fix-leak-in-imx_ep_alloc_request.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: imx_udc: fix leak in imx_ep_alloc_request()
From: Daniel Mack <daniel@caiaq.de>

cppcheck found another leak in drivers/usb/gadget/imx_udc.c

Cc: Mike Lee <eemike@gmail.com>
Cc: Darius Augulis <augulis.darius@gmail.com>
Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: David Brownell <david-b@pacbell.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/imx_udc.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/usb/gadget/imx_udc.c~usb-imx_udc-fix-leak-in-imx_ep_alloc_request drivers/usb/gadget/imx_udc.c
--- a/drivers/usb/gadget/imx_udc.c~usb-imx_udc-fix-leak-in-imx_ep_alloc_request
+++ a/drivers/usb/gadget/imx_udc.c
@@ -734,9 +734,12 @@ static struct usb_request *imx_ep_alloc_
 {
 	struct imx_request *req;
 
+	if (!usb_ep)
+		return NULL;
+
 	req = kzalloc(sizeof *req, gfp_flags);
-	if (!req || !usb_ep)
-		return 0;
+	if (!req)
+		return NULL;
 
 	INIT_LIST_HEAD(&req->queue);
 	req->in_use = 0;
_

Patches currently in -mm which might be from daniel@caiaq.de are

linux-next.patch
w1-gpio-add-external-pull-up-enable-callback.patch

