From: akpm@linux-foundation.org
Subject: + dvb-usb-fix-crash-in-drivers-media-dvb-dvb-usb-cxusbc.patch added to -mm tree
Date: Tue, 29 Jul 2008 15:29:01 -0700
Message-ID: <200807292229.m6TMT1bs025069@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32891 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755147AbYG2W3x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 18:29:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rglowery@exemail.com.au, c.pascoe@itee.uq.edu.au, mchehab@infradead.org, stable@kernel.org


The patch titled
     dvb-usb: fix crash in drivers/media/dvb/dvb-usb/cxusb.c
has been added to the -mm tree.  Its filename is
     dvb-usb-fix-crash-in-drivers-media-dvb-dvb-usb-cxusbc.patch

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
Subject: dvb-usb: fix crash in drivers/media/dvb/dvb-usb/cxusb.c
From: "Robert Lowery" <rglowery@exemail.com.au>

fe->dvb->priv is a dvb_usb_adapter, but the callback is expecting a
dvb_usb_device.  I'm not sure the best way to handle this as
tuner-xc2028.c does not know about any dvb-usb code currently.

In any case, the following patch seems to get it past the oops until the
proper fix is in place.

Chris Pascoe <c.pascoe@itee.uq.edu.au>
Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/dvb-usb/cxusb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/dvb/dvb-usb/cxusb.c~dvb-usb-fix-crash-in-drivers-media-dvb-dvb-usb-cxusbc drivers/media/dvb/dvb-usb/cxusb.c
--- a/drivers/media/dvb/dvb-usb/cxusb.c~dvb-usb-fix-crash-in-drivers-media-dvb-dvb-usb-cxusbc
+++ a/drivers/media/dvb/dvb-usb/cxusb.c
@@ -565,7 +565,7 @@ static int cxusb_lgh064f_tuner_attach(st
 
 static int dvico_bluebird_xc2028_callback(void *ptr, int command, int arg)
 {
-	struct dvb_usb_device *d = ptr;
+	struct dvb_usb_device *d = ((struct dvb_usb_adapter *)ptr)->dev;
 
 	switch (command) {
 	case XC2028_TUNER_RESET:
_

Patches currently in -mm which might be from rglowery@exemail.com.au are

dvb-usb-fix-crash-in-drivers-media-dvb-dvb-usb-cxusbc.patch

