From: akpm@linux-foundation.org
Subject: + rivafb-nvidiafb-various-cleanups.patch added to -mm tree
Date: Mon, 09 Apr 2007 12:38:10 -0700
Message-ID: <200704091938.l39JcA4I021589@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57173 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979AbXDITiZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 9 Apr 2007 15:38:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, adaplas@gmail.com


The patch titled
     rivafb/nvidiafb: Various cleanups
has been added to the -mm tree.  Its filename is
     rivafb-nvidiafb-various-cleanups.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rivafb/nvidiafb: Various cleanups
From: Jean Delvare <khali@linux-fr.org>

Various cleanups to rivafb/nvidiafb's I2C code:
* Drop useless par->bus.
* Refactor I2C bus deletion code.
* Drop useless variable initialization.
* Remove unneeded include of <linux/i2c-id.h>.
* Simplify +1/-1.
* Add __devinit tags where possible.

[adaplas]
The varible initialization are not useless. However, rivafb must
check if i2c bus are created properly before reading the EDID
block.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/nvidia/nv_i2c.c   |   20 ++++++------------
 drivers/video/nvidia/nv_type.h  |    2 -
 drivers/video/riva/fbdev.c      |    4 +--
 drivers/video/riva/rivafb-i2c.c |   33 +++++++++++++-----------------
 drivers/video/riva/rivafb.h     |    2 -
 5 files changed, 24 insertions(+), 37 deletions(-)

diff -puN drivers/video/nvidia/nv_i2c.c~rivafb-nvidiafb-various-cleanups drivers/video/nvidia/nv_i2c.c
--- a/drivers/video/nvidia/nv_i2c.c~rivafb-nvidiafb-various-cleanups
+++ a/drivers/video/nvidia/nv_i2c.c
@@ -127,8 +127,6 @@ static int nvidia_setup_i2c_bus(struct n
 
 void nvidia_create_i2c_busses(struct nvidia_par *par)
 {
-	par->bus = 3;
-
 	par->chan[0].par = par;
 	par->chan[1].par = par;
 	par->chan[2].par = par;
@@ -145,18 +143,14 @@ void nvidia_create_i2c_busses(struct nvi
 
 void nvidia_delete_i2c_busses(struct nvidia_par *par)
 {
-	if (par->chan[0].par)
-		i2c_del_adapter(&par->chan[0].adapter);
-	par->chan[0].par = NULL;
-
-	if (par->chan[1].par)
-		i2c_del_adapter(&par->chan[1].adapter);
-	par->chan[1].par = NULL;
-
-	if (par->chan[2].par)
-		i2c_del_adapter(&par->chan[2].adapter);
-	par->chan[2].par = NULL;
+	int i;
 
+	for (i = 0; i < 3; i++) {
+		if (!par->chan[i].par)
+			continue;
+		i2c_del_adapter(&par->chan[i].adapter);
+		par->chan[i].par = NULL;
+	}
 }
 
 int nvidia_probe_i2c_connector(struct fb_info *info, int conn, u8 **out_edid)
diff -puN drivers/video/nvidia/nv_type.h~rivafb-nvidiafb-various-cleanups drivers/video/nvidia/nv_type.h
--- a/drivers/video/nvidia/nv_type.h~rivafb-nvidiafb-various-cleanups
+++ a/drivers/video/nvidia/nv_type.h
@@ -4,7 +4,6 @@
 #include <linux/fb.h>
 #include <linux/types.h>
 #include <linux/i2c.h>
-#include <linux/i2c-id.h>
 #include <linux/i2c-algo-bit.h>
 
 #define NV_ARCH_04  0x04
@@ -100,7 +99,6 @@ struct nvidia_par {
 	u32 Architecture;
 	u32 CursorStart;
 	int Chipset;
-	int bus;
 	unsigned long FbAddress;
 	u8 __iomem *FbStart;
 	u32 FbMapSize;
diff -puN drivers/video/riva/fbdev.c~rivafb-nvidiafb-various-cleanups drivers/video/riva/fbdev.c
--- a/drivers/video/riva/fbdev.c~rivafb-nvidiafb-various-cleanups
+++ a/drivers/video/riva/fbdev.c
@@ -1788,10 +1788,10 @@ static int __devinit riva_get_EDID_i2c(s
 
 	NVTRACE_ENTER();
 	riva_create_i2c_busses(par);
-	for (i = 0; i < par->bus; i++) {
+	for (i = 0; i < 3; i++) {
 		if (!par->chan[i].par)
 			continue;
-		riva_probe_i2c_connector(par, i+1, &par->EDID);
+		riva_probe_i2c_connector(par, i, &par->EDID);
 		if (par->EDID && !fb_parse_edid(par->EDID, &var)) {
 			printk(PFX "Found EDID Block from BUS %i\n", i);
 			break;
diff -puN drivers/video/riva/rivafb-i2c.c~rivafb-nvidiafb-various-cleanups drivers/video/riva/rivafb-i2c.c
--- a/drivers/video/riva/rivafb-i2c.c~rivafb-nvidiafb-various-cleanups
+++ a/drivers/video/riva/rivafb-i2c.c
@@ -88,8 +88,9 @@ static int riva_gpio_getsda(void* data)
 	return val;
 }
 
-static int riva_setup_i2c_bus(struct riva_i2c_chan *chan, const char *name,
-			      unsigned int i2c_class)
+static int __devinit riva_setup_i2c_bus(struct riva_i2c_chan *chan,
+					const char *name,
+					unsigned int i2c_class)
 {
 	int rc;
 
@@ -126,10 +127,8 @@ static int riva_setup_i2c_bus(struct riv
 	return rc;
 }
 
-void riva_create_i2c_busses(struct riva_par *par)
+void __devinit riva_create_i2c_busses(struct riva_par *par)
 {
-	par->bus = 3;
-
 	par->chan[0].par	= par;
 	par->chan[1].par	= par;
 	par->chan[2].par        = par;
@@ -144,24 +143,22 @@ void riva_create_i2c_busses(struct riva_
 
 void riva_delete_i2c_busses(struct riva_par *par)
 {
-	if (par->chan[0].par)
-		i2c_del_adapter(&par->chan[0].adapter);
-	par->chan[0].par = NULL;
-
-	if (par->chan[1].par)
-		i2c_del_adapter(&par->chan[1].adapter);
-	par->chan[1].par = NULL;
-
-	if (par->chan[2].par)
-		i2c_del_adapter(&par->chan[2].adapter);
-	par->chan[2].par = NULL;
+	int i;
+
+	for (i = 0; i < 3; i++) {
+		if (!par->chan[i].par)
+			continue;
+		i2c_del_adapter(&par->chan[i].adapter);
+		par->chan[i].par = NULL;
+	}
 }
 
-int riva_probe_i2c_connector(struct riva_par *par, int conn, u8 **out_edid)
+int __devinit riva_probe_i2c_connector(struct riva_par *par, int conn, u8 **out_edid)
 {
 	u8 *edid = NULL;
 
-	edid = fb_ddc_read(&par->chan[conn-1].adapter);
+	if (par->chan[conn].par)
+		edid = fb_ddc_read(&par->chan[conn].adapter);
 
 	if (out_edid)
 		*out_edid = edid;
diff -puN drivers/video/riva/rivafb.h~rivafb-nvidiafb-various-cleanups drivers/video/riva/rivafb.h
--- a/drivers/video/riva/rivafb.h~rivafb-nvidiafb-various-cleanups
+++ a/drivers/video/riva/rivafb.h
@@ -4,7 +4,6 @@
 #include <linux/fb.h>
 #include <video/vga.h>
 #include <linux/i2c.h>
-#include <linux/i2c-id.h>
 #include <linux/i2c-algo-bit.h>
 
 #include "riva_hw.h"
@@ -61,7 +60,6 @@ struct riva_par {
 	Bool SecondCRTC;
 	int FlatPanel;
 	struct pci_dev *pdev;
-	int bus;
 	int cursor_reset;
 #ifdef CONFIG_MTRR
 	struct { int vram; int vram_valid; } mtrr;
_

Patches currently in -mm which might be from khali@linux-fr.org are

x86-msr-add-support-for-safe-variants.patch
git-alsa.patch
git-dvb.patch
i2c-replace-more-deprecated-sa_xxx-interrupt-flags.patch
apple-smc-driver-hardware-monitoring-and-control.patch
git-ieee1394.patch
git-netdev-all.patch
git-net.patch
xtensa-strlcpy-is-smart-enough.patch
oss-strlcpy-is-smart-enough.patch
rtc-add-rtc-class-driver-for-the-maxim-max6900.patch
legacy-pc-parports-support-parport-dev.patch
layered-parport-code-uses-parport-dev.patch
fbdev-dont-show-logo-if-driver-or-fbcon-are-modular.patch
rivafb-handle-i2c-bus-creation-failure.patch
rivafb-nvidiafb-various-cleanups.patch
rivafb-fixed-reversed-ddc-ports.patch
