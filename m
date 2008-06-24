From: akpm@linux-foundation.org
Subject: + usb-fix-possible-memory-leak-in-pxa27x_udc.patch added to -mm tree
Date: Tue, 24 Jun 2008 00:40:19 -0700
Message-ID: <200806240740.m5O7eJbY007292@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54631 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755803AbYFXHku (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jun 2008 03:40:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, danielm77@spray.se, dbrownell@users.sourceforge.net, gregkh@suse.de


The patch titled
     usb: fix possible memory leak in pxa27x_udc
has been added to the -mm tree.  Its filename is
     usb-fix-possible-memory-leak-in-pxa27x_udc.patch

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

vfs-fix-err_ptr-abuse-in-generic_readlink.patch
usb-fix-possible-memory-leak-in-pxa27x_udc.patch

