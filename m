From: akpm@linux-foundation.org
Subject: - dvb-usb-fix-crash-in-drivers-media-dvb-dvb-usb-cxusbc.patch removed from -mm tree
Date: Wed, 30 Jul 2008 15:19:48 -0700
Message-ID: <200807302219.m6UMJm8L020550@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46035 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751587AbYG3WUW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 18:20:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rglowery@exemail.com.au, c.pascoe@itee.uq.edu.au, mchehab@infradead.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     dvb-usb: fix crash in drivers/media/dvb/dvb-usb/cxusb.c
has been removed from the -mm tree.  Its filename was
     dvb-usb-fix-crash-in-drivers-media-dvb-dvb-usb-cxusbc.patch

This patch was dropped because an updated version will be merged

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

