From: akpm@linux-foundation.org
Subject: - rivafb-nvidiafb-enable-hardware-monitoring.patch removed from -mm tree
Date: Tue, 08 May 2007 20:00:21 -0700
Message-ID: <200705090300.l4930LNu010552@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35139 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032813AbXEIDAX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:00:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     rivafb/nvidiafb: Enable hardware monitoring
has been removed from the -mm tree.  Its filename was
     rivafb-nvidiafb-enable-hardware-monitoring.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
applesmc-use-the-address-as-platform-device-id.patch
applesmc-use-standard-sysfs-names-for-labels.patch
git-alsa.patch
git-dvb.patch
scx200-use-mutex-instead-of-semaphore.patch
