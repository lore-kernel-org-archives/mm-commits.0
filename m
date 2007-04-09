From: akpm@linux-foundation.org
Subject: + rivafb-nvidiafb-enable-hardware-monitoring.patch added to -mm tree
Date: Mon, 09 Apr 2007 12:38:05 -0700
Message-ID: <200704091938.l39Jc5u6021580@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57144 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886AbXDITiH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 9 Apr 2007 15:38:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr, adaplas@gmail.com


The patch titled
     rivafb/nvidiafb: Enable hardware monitoring
has been added to the -mm tree.  Its filename is
     rivafb-nvidiafb-enable-hardware-monitoring.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rivafb/nvidiafb: Enable hardware monitoring
From: Jean Delvare <khali@linux-fr>

Let the hardware monitoring drivers probe the second rivafb/nvidiafb I2C bus
for devices.

Signed-off-by: Jean Delvare <khali@linux-fr>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/nvidia/nv_i2c.c   |   10 ++++++----
 drivers/video/riva/rivafb-i2c.c |   10 ++++++----
 2 files changed, 12 insertions(+), 8 deletions(-)

diff -puN drivers/video/nvidia/nv_i2c.c~rivafb-nvidiafb-enable-hardware-monitoring drivers/video/nvidia/nv_i2c.c
--- a/drivers/video/nvidia/nv_i2c.c~rivafb-nvidiafb-enable-hardware-monitoring
+++ a/drivers/video/nvidia/nv_i2c.c
@@ -86,13 +86,15 @@ static int nvidia_gpio_getsda(void *data
 	return val;
 }
 
-static int nvidia_setup_i2c_bus(struct nvidia_i2c_chan *chan, const char *name)
+static int nvidia_setup_i2c_bus(struct nvidia_i2c_chan *chan, const char *name,
+				unsigned int i2c_class)
 {
 	int rc;
 
 	strcpy(chan->adapter.name, name);
 	chan->adapter.owner = THIS_MODULE;
 	chan->adapter.id = I2C_HW_B_NVIDIA;
+	chan->adapter.class = i2c_class;
 	chan->adapter.algo_data = &chan->algo;
 	chan->adapter.dev.parent = &chan->par->pci_dev->dev;
 	chan->algo.setsda = nvidia_gpio_setsda;
@@ -132,13 +134,13 @@ void nvidia_create_i2c_busses(struct nvi
 	par->chan[2].par = par;
 
 	par->chan[0].ddc_base = 0x36;
-	nvidia_setup_i2c_bus(&par->chan[0], "nvidia #0");
+ 	nvidia_setup_i2c_bus(&par->chan[0], "nvidia #0", I2C_CLASS_HWMON);
 
 	par->chan[1].ddc_base = 0x3e;
-	nvidia_setup_i2c_bus(&par->chan[1], "nvidia #1");
+ 	nvidia_setup_i2c_bus(&par->chan[1], "nvidia #1", 0);
 
 	par->chan[2].ddc_base = 0x50;
-	nvidia_setup_i2c_bus(&par->chan[2], "nvidia #2");
+ 	nvidia_setup_i2c_bus(&par->chan[2], "nvidia #2", 0);
 }
 
 void nvidia_delete_i2c_busses(struct nvidia_par *par)
diff -puN drivers/video/riva/rivafb-i2c.c~rivafb-nvidiafb-enable-hardware-monitoring drivers/video/riva/rivafb-i2c.c
--- a/drivers/video/riva/rivafb-i2c.c~rivafb-nvidiafb-enable-hardware-monitoring
+++ a/drivers/video/riva/rivafb-i2c.c
@@ -88,13 +88,15 @@ static int riva_gpio_getsda(void* data)
 	return val;
 }
 
-static int riva_setup_i2c_bus(struct riva_i2c_chan *chan, const char *name)
+static int riva_setup_i2c_bus(struct riva_i2c_chan *chan, const char *name,
+			      unsigned int i2c_class)
 {
 	int rc;
 
 	strcpy(chan->adapter.name, name);
 	chan->adapter.owner		= THIS_MODULE;
 	chan->adapter.id		= I2C_HW_B_RIVA;
+	chan->adapter.class		= i2c_class;
 	chan->adapter.algo_data		= &chan->algo;
 	chan->adapter.dev.parent	= &chan->par->pdev->dev;
 	chan->algo.setsda		= riva_gpio_setsda;
@@ -135,9 +137,9 @@ void riva_create_i2c_busses(struct riva_
 	par->chan[0].ddc_base = 0x3e;
 	par->chan[1].ddc_base = 0x36;
 	par->chan[2].ddc_base = 0x50;
-	riva_setup_i2c_bus(&par->chan[0], "BUS1");
-	riva_setup_i2c_bus(&par->chan[1], "BUS2");
-	riva_setup_i2c_bus(&par->chan[2], "BUS3");
+	riva_setup_i2c_bus(&par->chan[0], "BUS1", 0);
+	riva_setup_i2c_bus(&par->chan[1], "BUS2", I2C_CLASS_HWMON);
+	riva_setup_i2c_bus(&par->chan[2], "BUS3", 0);
 }
 
 void riva_delete_i2c_busses(struct riva_par *par)
_

Patches currently in -mm which might be from khali@linux-fr are

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
rivafb-nvidiafb-enable-hardware-monitoring.patch
rivafb-handle-i2c-bus-creation-failure.patch
rivafb-nvidiafb-various-cleanups.patch
rivafb-fixed-reversed-ddc-ports.patch
