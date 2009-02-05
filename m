From: akpm@linux-foundation.org
Subject: + ir-kbd-i2c-support-hauppauge-hvr-1600-r-c-port.patch added to -mm tree
Date: Thu, 05 Feb 2009 12:06:04 -0800
Message-ID: <200902052006.n15K64X7016546@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40206 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751166AbZBEUGc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Feb 2009 15:06:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lkml@rtr.ca, mchehab@infradead.org, mlord@pobox.com


The patch titled
     ir-kbd-i2c: support Hauppauge HVR-1600 R/C port
has been added to the -mm tree.  Its filename is
     ir-kbd-i2c-support-hauppauge-hvr-1600-r-c-port.patch

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
Subject: ir-kbd-i2c: support Hauppauge HVR-1600 R/C port
From: Mark Lord <lkml@rtr.ca>

Update the ir-kbd-i2c driver to recognize the remote-control port
on the Hauppauge HV-1600 hybrid tuner card.

Signed-off-by: Mark Lord <mlord@pobox.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/ir-kbd-i2c.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/media/video/ir-kbd-i2c.c~ir-kbd-i2c-support-hauppauge-hvr-1600-r-c-port drivers/media/video/ir-kbd-i2c.c
--- a/drivers/media/video/ir-kbd-i2c.c~ir-kbd-i2c-support-hauppauge-hvr-1600-r-c-port
+++ a/drivers/media/video/ir-kbd-i2c.c
@@ -354,6 +354,11 @@ static int ir_attach(struct i2c_adapter 
 			} else {
 				ir_codes    = ir_codes_rc5_tv;
 			}
+		} else if (adap->id == I2C_HW_B_CX2341X) {
+			name        = "Hauppauge";
+			ir_type     = IR_TYPE_RC5;
+			ir->get_key = get_key_haup_xvr;
+			ir_codes    = ir_codes_hauppauge_new;
 		} else {
 			/* Handled by saa7134-input */
 			name        = "SAA713x remote";
@@ -449,7 +454,7 @@ static int ir_probe(struct i2c_adapter *
 	   That's why we probe 0x1a (~0x34) first. CB
 	*/
 
-	static const int probe_bttv[] = { 0x1a, 0x18, 0x4b, 0x64, 0x30, -1};
+	static const int probe_bttv[] = { 0x1a, 0x18, 0x4b, 0x64, 0x30, 0x71, -1};
 	static const int probe_saa7134[] = { 0x7a, 0x47, 0x71, 0x2d, -1 };
 	static const int probe_em28XX[] = { 0x30, 0x47, -1 };
 	static const int probe_cx88[] = { 0x18, 0x6b, 0x71, -1 };
_

Patches currently in -mm which might be from lkml@rtr.ca are

ir-kbd-i2c-support-hauppauge-hvr-1600-r-c-port.patch
radio-si470x-add-usb-id-for-dealextreme-usb-radio.patch

