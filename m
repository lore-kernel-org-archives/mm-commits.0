From: akpm@linux-foundation.org
Subject: + usb-imx_udc-fix-leak-in-imx_ep_alloc_request.patch added to -mm tree
Date: Tue, 07 Apr 2009 13:48:03 -0700
Message-ID: <200904072048.n37Km3Cf021179@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41934 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760669AbZDGUwC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 16:52:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daniel@caiaq.de, augulis.darius@gmail.com, david-b@pacbell.net, eemike@gmail.com, greg@kroah.com


The patch titled
     usb: imx_udc: fix leak in imx_ep_alloc_request()
has been added to the -mm tree.  Its filename is
     usb-imx_udc-fix-leak-in-imx_ep_alloc_request.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
linux-next.patch
usb-imx_udc-fix-leak-in-imx_ep_alloc_request.patch

