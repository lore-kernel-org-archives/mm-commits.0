From: akpm@linux-foundation.org
Subject: [wrecked] ir-kbd-i2c-support-hauppauge-hvr-1600-r-c-port.patch removed from -mm tree
Date: Tue, 05 May 2009 11:46:17 -0700
Message-ID: <200905051846.n45IkHUF014101@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39414 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751619AbZEESys (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 May 2009 14:54:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lkml@rtr.ca, mchehab@infradead.org, mlord@pobox.com, mm-commits@vger.kernel.org


The patch titled
     ir-kbd-i2c: support Hauppauge HVR-1600 R/C port
has been removed from the -mm tree.  Its filename was
     ir-kbd-i2c-support-hauppauge-hvr-1600-r-c-port.patch

This patch was dropped because other changes were merged, which wrecked this patch

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
@@ -390,6 +390,11 @@ static int ir_attach(struct i2c_adapter 
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
@@ -487,7 +492,7 @@ static int ir_probe(struct i2c_adapter *
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

