From: akpm@linux-foundation.org
Subject: - rivafb-fixed-reversed-ddc-ports.patch removed from -mm tree
Date: Tue, 08 May 2007 20:00:28 -0700
Message-ID: <200705090300.l4930SOS010568@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45861 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032871AbXEIDAn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:00:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, adaplas@pol.net, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     rivafb: fixed reversed DDC ports
has been removed from the -mm tree.  Its filename was
     rivafb-fixed-reversed-ddc-ports.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rivafb: fixed reversed DDC ports
From: "Antonino A. Daplas" <adaplas@gmail.com>

Fixed reversed DDC port so assignments are congruent with nvidiafb's and X's
nv driver.

Signed-off-by: Antonino Daplas <adaplas@pol.net>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/riva/rivafb-i2c.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/video/riva/rivafb-i2c.c~rivafb-fixed-reversed-ddc-ports drivers/video/riva/rivafb-i2c.c
--- a/drivers/video/riva/rivafb-i2c.c~rivafb-fixed-reversed-ddc-ports
+++ a/drivers/video/riva/rivafb-i2c.c
@@ -133,11 +133,11 @@ void __devinit riva_create_i2c_busses(st
 	par->chan[1].par	= par;
 	par->chan[2].par        = par;
 
-	par->chan[0].ddc_base = 0x3e;
-	par->chan[1].ddc_base = 0x36;
+	par->chan[0].ddc_base = 0x36;
+	par->chan[1].ddc_base = 0x3e;
 	par->chan[2].ddc_base = 0x50;
-	riva_setup_i2c_bus(&par->chan[0], "BUS1", 0);
-	riva_setup_i2c_bus(&par->chan[1], "BUS2", I2C_CLASS_HWMON);
+	riva_setup_i2c_bus(&par->chan[0], "BUS1", I2C_CLASS_HWMON);
+	riva_setup_i2c_bus(&par->chan[1], "BUS2", 0);
 	riva_setup_i2c_bus(&par->chan[2], "BUS3", 0);
 }
 
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
vt8623fb-new-framebuffer-driver-for-via-vt8623.patch
vt8623fb-fix-compile-warnings.patch
vt8623fb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards.patch
arkfb-fix-compiler-warnings.patch
arkfb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards-fix.patch
svgalib-move-fb_get_caps-to-svgalib.patch
