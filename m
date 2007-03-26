From: akpm@linux-foundation.org
Subject: - pwc-cisco-vt-camera-support.patch removed from -mm tree
Date: Sun, 25 Mar 2007 17:06:04 -0800
Message-ID: <200703260106.l2Q164K1008752@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38971 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933464AbXCZBMl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 21:12:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jt@hpl.hp.com, luc@saillard.org, m.kozlowski@tuxland.pl, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     pwc: cisco VT Camera support
has been removed from the -mm tree.  Its filename was
     pwc-cisco-vt-camera-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pwc: cisco VT Camera support
From: Jean Tourrilhes <jt@hpl.hp.com>

I have a Cisco VT Camera, and it was just collecting dust.  I decided to
try connecting it to my Linux box at home.

Just a disgression about the product.  The Cisco VT Camera is a webcam
Cisco sold to work with their IP phone hardware and software.  It's mostly
useless on Windows, as it interfaces only to Cisco software.  You can find
some for cheap on eBay...

Physically, it's just a Logitech Pro 4000.  The only difference with the
Pro 4000 is the Cisco logo and that it's grey like the Pro 3000.  I believe
Cisco is now selling the Cisco VT Camera II, which look to be something
else...

So, assuming that it was a Pro 4000 inside, I created the little patch
attached.

I'm new to webcam under Linux, but I managed to get an image from it using
xawtv, and the image looked all right, so I consider that a success.  The
imaged seemed a bit small and I could not get the microphone driver loaded,
but I assume it's my lack of experience.  Note that I did not try any other
type_id, but this one works great.

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Luc Saillard <luc@saillard.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/pwc/pwc-if.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/media/video/pwc/pwc-if.c~pwc-cisco-vt-camera-support drivers/media/video/pwc/pwc-if.c
--- a/drivers/media/video/pwc/pwc-if.c~pwc-cisco-vt-camera-support
+++ a/drivers/media/video/pwc/pwc-if.c
@@ -1547,6 +1547,10 @@ static int usb_pwc_probe(struct usb_inte
 			features |= FEATURE_MOTOR_PANTILT;
 			break;
 		case 0x08b6:
+			PWC_INFO("Logitech/Cisco VT Camera webcam detected.\n");
+			name = "Cisco VT Camera";
+			type_id = 740; /* CCD sensor */
+			break;
 		case 0x08b7:
 		case 0x08b8:
 			PWC_INFO("Logitech QuickCam detected (reserved ID).\n");
_

Patches currently in -mm which might be from jt@hpl.hp.com are

git-dvb.patch
