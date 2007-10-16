From: akpm@linux-foundation.org
Subject: - nvidiafb-add-boot-option-to-reverse-i2c-port-assignment.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:44:13 -0700
Message-ID: <200710162044.l9GKiDXc016124@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52945 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935067AbXJPVJ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:09:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, adaplas@gail.com, mm-commits@vger.kernel.org


The patch titled
     nvidiafb: Add boot option to reverse i2c port assignment
has been removed from the -mm tree.  Its filename was
     nvidiafb-add-boot-option-to-reverse-i2c-port-assignment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: nvidiafb: Add boot option to reverse i2c port assignment
From: "Antonino A. Daplas" <adaplas@gmail.com>

There are a few nvidia hardware where the i2c port assignments are reversed,
i.e., the 1st i2c port is assigned to the secondary display and the 2nd i2c
port to the primary display.  In most cases, if only 1 display is attached, or
if only 1 flatpanel and 1 analog display is attached, the port reversal is of
no consequence.  However if 2 flatpanels are attached, it can cause display
problems.

There is no sane way of determining if the hardware reversed the i2c port
assignment, so the simplest fix is to add a boot/module option, "reverse_i2c
to explicitly reverse the i2c port.

This also restores i2c ordering back to the pre-2.6.22 state.

Signed-off-by: Antonino Daplas <adaplas@gail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/nvidia/nv_i2c.c  |    8 ++++----
 drivers/video/nvidia/nv_type.h |    1 +
 drivers/video/nvidia/nvidia.c  |    6 ++++++
 3 files changed, 11 insertions(+), 4 deletions(-)

diff -puN drivers/video/nvidia/nv_i2c.c~nvidiafb-add-boot-option-to-reverse-i2c-port-assignment drivers/video/nvidia/nv_i2c.c
--- a/drivers/video/nvidia/nv_i2c.c~nvidiafb-add-boot-option-to-reverse-i2c-port-assignment
+++ a/drivers/video/nvidia/nv_i2c.c
@@ -125,11 +125,11 @@ void nvidia_create_i2c_busses(struct nvi
 	par->chan[1].par = par;
 	par->chan[2].par = par;
 
-	par->chan[0].ddc_base = 0x36;
- 	nvidia_setup_i2c_bus(&par->chan[0], "nvidia #0", I2C_CLASS_HWMON);
+	par->chan[0].ddc_base = (par->reverse_i2c) ? 0x36 : 0x3e;
+ 	nvidia_setup_i2c_bus(&par->chan[0], "nvidia #0", 0);
 
-	par->chan[1].ddc_base = 0x3e;
- 	nvidia_setup_i2c_bus(&par->chan[1], "nvidia #1", 0);
+	par->chan[1].ddc_base = (par->reverse_i2c) ? 0x3e : 0x36;
+ 	nvidia_setup_i2c_bus(&par->chan[1], "nvidia #1", I2C_CLASS_HWMON);
 
 	par->chan[2].ddc_base = 0x50;
  	nvidia_setup_i2c_bus(&par->chan[2], "nvidia #2", 0);
diff -puN drivers/video/nvidia/nv_type.h~nvidiafb-add-boot-option-to-reverse-i2c-port-assignment drivers/video/nvidia/nv_type.h
--- a/drivers/video/nvidia/nv_type.h~nvidiafb-add-boot-option-to-reverse-i2c-port-assignment
+++ a/drivers/video/nvidia/nv_type.h
@@ -135,6 +135,7 @@ struct nvidia_par {
 	int paneltweak;
 	int LVDS;
 	int pm_state;
+	int reverse_i2c;
 	u32 crtcSync_read;
 	u32 fpSyncs;
 	u32 dmaPut;
diff -puN drivers/video/nvidia/nvidia.c~nvidiafb-add-boot-option-to-reverse-i2c-port-assignment drivers/video/nvidia/nvidia.c
--- a/drivers/video/nvidia/nvidia.c~nvidiafb-add-boot-option-to-reverse-i2c-port-assignment
+++ a/drivers/video/nvidia/nvidia.c
@@ -79,6 +79,7 @@ static int noscale __devinitdata = 0;
 static int paneltweak __devinitdata = 0;
 static int vram __devinitdata = 0;
 static int bpp __devinitdata = 8;
+static int reverse_i2c __devinitdata;
 #ifdef CONFIG_MTRR
 static int nomtrr __devinitdata = 0;
 #endif
@@ -1305,6 +1306,7 @@ static int __devinit nvidiafb_probe(stru
 	par->CRTCnumber = forceCRTC;
 	par->FpScale = (!noscale);
 	par->paneltweak = paneltweak;
+	par->reverse_i2c = reverse_i2c;
 
 	/* enable IO and mem if not already done */
 	pci_read_config_word(pd, PCI_COMMAND, &cmd);
@@ -1486,6 +1488,8 @@ static int __devinit nvidiafb_setup(char
 			noaccel = 1;
 		} else if (!strncmp(this_opt, "noscale", 7)) {
 			noscale = 1;
+		} else if (!strncmp(this_opt, "reverse_i2c", 11)) {
+			reverse_i2c = 1;
 		} else if (!strncmp(this_opt, "paneltweak:", 11)) {
 			paneltweak = simple_strtoul(this_opt+11, NULL, 0);
 		} else if (!strncmp(this_opt, "vram:", 5)) {
@@ -1582,6 +1586,8 @@ MODULE_PARM_DESC(mode_option, "Specify i
 module_param(bpp, int, 0);
 MODULE_PARM_DESC(bpp, "pixel width in bits"
 		 "(default=8)");
+module_param(reverse_i2c, int, 0);
+MODULE_PARM_DESC(reverse_i2c, "reverse port assignment of the i2c bus");
 #ifdef CONFIG_MTRR
 module_param(nomtrr, bool, 0);
 MODULE_PARM_DESC(nomtrr, "Disables MTRR support (0 or 1=disabled) "
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
fbcon-delay-the-start-of-the-cursor-timer-until-a-con_switch.patch
cyber2000fb-checkpatch-fixes.patch
