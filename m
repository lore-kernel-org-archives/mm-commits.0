From: akpm@linux-foundation.org
Subject: - usb-fix-possible-memory-leak-in-pxa27x_udc.patch removed from -mm tree
Date: Fri, 04 Jul 2008 00:28:40 -0700
Message-ID: <200807040728.m647Sewv019392@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45306 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750899AbYGDH3Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jul 2008 03:29:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin.slusarz@gmail.com, danielm77@spray.se, dbrownell@users.sourceforge.net, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     usb: fix possible memory leak in pxa27x_udc
has been removed from the -mm tree.  Its filename was
     usb-fix-possible-memory-leak-in-pxa27x_udc.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: fix possible memory leak in pxa27x_udc
From: Marcin Slusarz <marcin.slusarz@gmail.com>

Fix memory leak when _ep is null.
http://bugzilla.kernel.org/show_bug.cgi?id=10660

Reported-by: Daniel Marjamaki <danielm77@spray.se>
Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/pxa27x_udc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/usb/gadget/pxa27x_udc.c~usb-fix-possible-memory-leak-in-pxa27x_udc drivers/usb/gadget/pxa27x_udc.c
--- a/drivers/usb/gadget/pxa27x_udc.c~usb-fix-possible-memory-leak-in-pxa27x_udc
+++ a/drivers/usb/gadget/pxa27x_udc.c
@@ -650,8 +650,11 @@ pxa_ep_alloc_request(struct usb_ep *_ep,
 {
 	struct pxa27x_request *req;
 
+	if (!_ep)
+		return NULL;
+
 	req = kzalloc(sizeof *req, gfp_flags);
-	if (!req || !_ep)
+	if (!req)
 		return NULL;
 
 	INIT_LIST_HEAD(&req->queue);
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

origin.patch
linux-next.patch
usb-fix-possible-memory-leak-in-pxa27x_udc.patch

