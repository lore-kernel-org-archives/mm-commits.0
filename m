From: akpm@linux-foundation.org
Subject: [merged] viafb-improve-viafb_par.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:02:04 -0700
Message-ID: <200909232002.n8NK24Tt016460@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37857 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753875AbZIWUCk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:02:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn, corbet@lwn.net, laforge@gnumonks.org, mm-commits@vger.kernel.org


The patch titled
     viafb: improve viafb_par
has been removed from the -mm tree.  Its filename was
     viafb-improve-viafb_par.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: viafb: improve viafb_par
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

This patch introduces viafb_shared and is the beginning of a smooth
transition to use it.

viafb_shared should contain all general, non-surface specific data that
should be shared along all viafb framebuffers while viafb_par should only
contain things that are specific to each surface or in other words extend
fb_info.  This change is intended to clean the dual/multi framebuffer
handling up.

This removes the annoyance that viafbinfo1->par points to a different
structure than viaparinfo1.

As the last change is fundamental it is difficult to ensure that all parts
of the driver do not depend on the previous brokenness but the chance of
regressions is very low.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Harald Welte <laforge@gnumonks.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/dvi.c      |    6 +--
 drivers/video/via/lcd.c      |    6 +--
 drivers/video/via/via_i2c.c  |   62 ++++++++++++++++-----------------
 drivers/video/via/viafbdev.c |   35 ++++++------------
 drivers/video/via/viafbdev.h |   19 ++++++++--
 drivers/video/via/vt1636.c   |    4 +-
 6 files changed, 68 insertions(+), 64 deletions(-)

diff -puN drivers/video/via/dvi.c~viafb-improve-viafb_par drivers/video/via/dvi.c
--- a/drivers/video/via/dvi.c~viafb-improve-viafb_par
+++ a/drivers/video/via/dvi.c
@@ -160,7 +160,7 @@ int viafb_tmds_trasmitter_identify(void)
 
 static void tmds_register_write(int index, u8 data)
 {
-	viaparinfo->i2c_stuff.i2c_port =
+	viaparinfo->shared->i2c_stuff.i2c_port =
 		viaparinfo->chip_info->tmds_chip_info.i2c_port;
 
 	viafb_i2c_writebyte(viaparinfo->chip_info->tmds_chip_info.
@@ -172,7 +172,7 @@ static int tmds_register_read(int index)
 {
 	u8 data;
 
-	viaparinfo->i2c_stuff.i2c_port =
+	viaparinfo->shared->i2c_stuff.i2c_port =
 		viaparinfo->chip_info->tmds_chip_info.i2c_port;
 	viafb_i2c_readbyte((u8) viaparinfo->chip_info->
 	    tmds_chip_info.tmds_chip_slave_addr,
@@ -182,7 +182,7 @@ static int tmds_register_read(int index)
 
 static int tmds_register_read_bytes(int index, u8 *buff, int buff_len)
 {
-	viaparinfo->i2c_stuff.i2c_port =
+	viaparinfo->shared->i2c_stuff.i2c_port =
 		viaparinfo->chip_info->tmds_chip_info.i2c_port;
 	viafb_i2c_readbytes((u8) viaparinfo->chip_info->tmds_chip_info.
 			 tmds_chip_slave_addr, (u8) index, buff, buff_len);
diff -puN drivers/video/via/lcd.c~viafb-improve-viafb_par drivers/video/via/lcd.c
--- a/drivers/video/via/lcd.c~viafb-improve-viafb_par
+++ a/drivers/video/via/lcd.c
@@ -207,13 +207,13 @@ static bool lvds_identify_integratedlvds
 
 int viafb_lvds_trasmitter_identify(void)
 {
-	viaparinfo->i2c_stuff.i2c_port = I2CPORTINDEX;
+	viaparinfo->shared->i2c_stuff.i2c_port = I2CPORTINDEX;
 	if (viafb_lvds_identify_vt1636()) {
 		viaparinfo->chip_info->lvds_chip_info.i2c_port = I2CPORTINDEX;
 		DEBUG_MSG(KERN_INFO
 			  "Found VIA VT1636 LVDS on port i2c 0x31 \n");
 	} else {
-		viaparinfo->i2c_stuff.i2c_port = GPIOPORTINDEX;
+		viaparinfo->shared->i2c_stuff.i2c_port = GPIOPORTINDEX;
 		if (viafb_lvds_identify_vt1636()) {
 			viaparinfo->chip_info->lvds_chip_info.i2c_port =
 				GPIOPORTINDEX;
@@ -470,7 +470,7 @@ static int lvds_register_read(int index)
 {
 	u8 data;
 
-	viaparinfo->i2c_stuff.i2c_port = GPIOPORTINDEX;
+	viaparinfo->shared->i2c_stuff.i2c_port = GPIOPORTINDEX;
 	viafb_i2c_readbyte((u8) viaparinfo->chip_info->
 	    lvds_chip_info.lvds_chip_slave_addr,
 			(u8) index, &data);
diff -puN drivers/video/via/via_i2c.c~viafb-improve-viafb_par drivers/video/via/via_i2c.c
--- a/drivers/video/via/via_i2c.c~viafb-improve-viafb_par
+++ a/drivers/video/via/via_i2c.c
@@ -97,7 +97,7 @@ int viafb_i2c_readbyte(u8 slave_addr, u8
 	mm1[0] = index;
 	msgs[0].len = 1; msgs[1].len = 1;
 	msgs[0].buf = mm1; msgs[1].buf = pdata;
-	i2c_transfer(&viaparinfo->i2c_stuff.adapter, msgs, 2);
+	i2c_transfer(&viaparinfo->shared->i2c_stuff.adapter, msgs, 2);
 
 	return 0;
 }
@@ -111,7 +111,7 @@ int viafb_i2c_writebyte(u8 slave_addr, u
 	msgs.addr = slave_addr / 2;
 	msgs.len = 2;
 	msgs.buf = msg;
-	return i2c_transfer(&viaparinfo->i2c_stuff.adapter, &msgs, 1);
+	return i2c_transfer(&viaparinfo->shared->i2c_stuff.adapter, &msgs, 1);
 }
 
 int viafb_i2c_readbytes(u8 slave_addr, u8 index, u8 *buff, int buff_len)
@@ -125,53 +125,53 @@ int viafb_i2c_readbytes(u8 slave_addr, u
 	mm1[0] = index;
 	msgs[0].len = 1; msgs[1].len = buff_len;
 	msgs[0].buf = mm1; msgs[1].buf = buff;
-	i2c_transfer(&viaparinfo->i2c_stuff.adapter, msgs, 2);
+	i2c_transfer(&viaparinfo->shared->i2c_stuff.adapter, msgs, 2);
 	return 0;
 }
 
 int viafb_create_i2c_bus(void *viapar)
 {
 	int ret;
-	struct viafb_par *par = (struct viafb_par *)viapar;
+	struct via_i2c_stuff *i2c_stuff =
+		&((struct viafb_par *)viapar)->shared->i2c_stuff;
 
-	strcpy(par->i2c_stuff.adapter.name, "via_i2c");
-	par->i2c_stuff.i2c_port = 0x0;
-	par->i2c_stuff.adapter.owner = THIS_MODULE;
-	par->i2c_stuff.adapter.id = 0x01FFFF;
-	par->i2c_stuff.adapter.class = 0;
-	par->i2c_stuff.adapter.algo_data = &par->i2c_stuff.algo;
-	par->i2c_stuff.adapter.dev.parent = NULL;
-	par->i2c_stuff.algo.setsda = via_i2c_setsda;
-	par->i2c_stuff.algo.setscl = via_i2c_setscl;
-	par->i2c_stuff.algo.getsda = via_i2c_getsda;
-	par->i2c_stuff.algo.getscl = via_i2c_getscl;
-	par->i2c_stuff.algo.udelay = 40;
-	par->i2c_stuff.algo.timeout = 20;
-	par->i2c_stuff.algo.data = &par->i2c_stuff;
+	strcpy(i2c_stuff->adapter.name, "via_i2c");
+	i2c_stuff->i2c_port = 0x0;
+	i2c_stuff->adapter.owner = THIS_MODULE;
+	i2c_stuff->adapter.id = 0x01FFFF;
+	i2c_stuff->adapter.class = 0;
+	i2c_stuff->adapter.algo_data = &i2c_stuff->algo;
+	i2c_stuff->adapter.dev.parent = NULL;
+	i2c_stuff->algo.setsda = via_i2c_setsda;
+	i2c_stuff->algo.setscl = via_i2c_setscl;
+	i2c_stuff->algo.getsda = via_i2c_getsda;
+	i2c_stuff->algo.getscl = via_i2c_getscl;
+	i2c_stuff->algo.udelay = 40;
+	i2c_stuff->algo.timeout = 20;
+	i2c_stuff->algo.data = i2c_stuff;
 
-	i2c_set_adapdata(&par->i2c_stuff.adapter, &par->i2c_stuff);
+	i2c_set_adapdata(&i2c_stuff->adapter, i2c_stuff);
 
 	/* Raise SCL and SDA */
-	par->i2c_stuff.i2c_port = I2CPORTINDEX;
-	via_i2c_setsda(&par->i2c_stuff, 1);
-	via_i2c_setscl(&par->i2c_stuff, 1);
-
-	par->i2c_stuff.i2c_port = GPIOPORTINDEX;
-	via_i2c_setsda(&par->i2c_stuff, 1);
-	via_i2c_setscl(&par->i2c_stuff, 1);
+	i2c_stuff->i2c_port = I2CPORTINDEX;
+	via_i2c_setsda(i2c_stuff, 1);
+	via_i2c_setscl(i2c_stuff, 1);
+
+	i2c_stuff->i2c_port = GPIOPORTINDEX;
+	via_i2c_setsda(i2c_stuff, 1);
+	via_i2c_setscl(i2c_stuff, 1);
 	udelay(20);
 
-	ret = i2c_bit_add_bus(&par->i2c_stuff.adapter);
+	ret = i2c_bit_add_bus(&i2c_stuff->adapter);
 	if (ret == 0)
-		DEBUG_MSG("I2C bus %s registered.\n",
-		par->i2c_stuff.adapter.name);
+		DEBUG_MSG("I2C bus %s registered.\n", i2c_stuff->adapter.name);
 	else
 		DEBUG_MSG("Failed to register I2C bus %s.\n",
-			par->i2c_stuff.adapter.name);
+			i2c_stuff->adapter.name);
 	return ret;
 }
 
 void viafb_delete_i2c_buss(void *par)
 {
-	i2c_del_adapter(&((struct viafb_par *)par)->i2c_stuff.adapter);
+	i2c_del_adapter(&((struct viafb_par *)par)->shared->i2c_stuff.adapter);
 }
diff -puN drivers/video/via/viafbdev.c~viafb-improve-viafb_par drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~viafb-improve-viafb_par
+++ a/drivers/video/via/viafbdev.c
@@ -1943,40 +1943,30 @@ static int __devinit via_pci_probe(void)
 	char *tmpc, *tmpm;
 	char *tmpc_sec, *tmpm_sec;
 	int vmode_index;
-	u32 tmds_length, lvds_length, crt_length, chip_length, viafb_par_length;
+	u32 viafb_par_length;
 
 	DEBUG_MSG(KERN_INFO "VIAFB PCI Probe!!\n");
 
 	viafb_par_length = ALIGN(sizeof(struct viafb_par), BITS_PER_LONG/8);
-	tmds_length = ALIGN(sizeof(struct tmds_setting_information),
-		BITS_PER_LONG/8);
-	lvds_length = ALIGN(sizeof(struct lvds_setting_information),
-		BITS_PER_LONG/8);
-	crt_length = ALIGN(sizeof(struct lvds_setting_information),
-		BITS_PER_LONG/8);
-	chip_length = ALIGN(sizeof(struct chip_information), BITS_PER_LONG/8);
 
 	/* Allocate fb_info and ***_par here, also including some other needed
 	 * variables
 	*/
-	viafbinfo = framebuffer_alloc(viafb_par_length + 2 * lvds_length +
-	tmds_length + crt_length + chip_length, NULL);
+	viafbinfo = framebuffer_alloc(viafb_par_length +
+		ALIGN(sizeof(struct viafb_shared), BITS_PER_LONG/8), NULL);
 	if (!viafbinfo) {
 		printk(KERN_ERR"Could not allocate memory for viafb_info.\n");
 		return -ENODEV;
 	}
 
 	viaparinfo = (struct viafb_par *)viafbinfo->par;
-	viaparinfo->tmds_setting_info = (struct tmds_setting_information *)
-		((unsigned long)viaparinfo + viafb_par_length);
-	viaparinfo->lvds_setting_info = (struct lvds_setting_information *)
-		((unsigned long)viaparinfo->tmds_setting_info + tmds_length);
-	viaparinfo->lvds_setting_info2 = (struct lvds_setting_information *)
-		((unsigned long)viaparinfo->lvds_setting_info + lvds_length);
-	viaparinfo->crt_setting_info = (struct crt_setting_information *)
-		((unsigned long)viaparinfo->lvds_setting_info2 + lvds_length);
-	viaparinfo->chip_info = (struct chip_information *)
-		((unsigned long)viaparinfo->crt_setting_info + crt_length);
+	viaparinfo->shared = viafbinfo->par + viafb_par_length;
+	viaparinfo->tmds_setting_info = &viaparinfo->shared->tmds_setting_info;
+	viaparinfo->lvds_setting_info = &viaparinfo->shared->lvds_setting_info;
+	viaparinfo->lvds_setting_info2 =
+		&viaparinfo->shared->lvds_setting_info2;
+	viaparinfo->crt_setting_info = &viaparinfo->shared->crt_setting_info;
+	viaparinfo->chip_info = &viaparinfo->shared->chip_info;
 
 	if (viafb_dual_fb)
 		viafb_SAMM_ON = 1;
@@ -2142,6 +2132,7 @@ static int __devinit via_pci_probe(void)
 		viaparinfo->iga_path = IGA1;
 		viaparinfo1->iga_path = IGA2;
 		memcpy(viafbinfo1, viafbinfo, sizeof(struct fb_info));
+		viafbinfo1->par = viaparinfo1;
 		viafbinfo1->screen_base = viafbinfo->screen_base +
 			viafb_second_offset;
 
@@ -2193,7 +2184,7 @@ static int __devinit via_pci_probe(void)
 		  viafbinfo->node, viafbinfo->fix.id, default_var.xres,
 		  default_var.yres, default_var.bits_per_pixel);
 
-	viafb_init_proc(&viaparinfo->proc_entry);
+	viafb_init_proc(&viaparinfo->shared->proc_entry);
 	viafb_init_dac(IGA2);
 	return 0;
 }
@@ -2214,7 +2205,7 @@ static void __devexit via_pci_remove(voi
 	if (viafb_dual_fb)
 		framebuffer_release(viafbinfo1);
 
-	viafb_remove_proc(viaparinfo->proc_entry);
+	viafb_remove_proc(viaparinfo->shared->proc_entry);
 }
 
 #ifndef MODULE
diff -puN drivers/video/via/viafbdev.h~viafb-improve-viafb_par drivers/video/via/viafbdev.h
--- a/drivers/video/via/viafbdev.h~viafb-improve-viafb_par
+++ a/drivers/video/via/viafbdev.h
@@ -37,6 +37,20 @@
 #define VERSION_OS          0	/* 0: for 32 bits OS, 1: for 64 bits OS */
 #define VERSION_MINOR       4
 
+struct viafb_shared {
+	struct proc_dir_entry *proc_entry;	/*viafb proc entry */
+
+	/* I2C stuff */
+	struct via_i2c_stuff i2c_stuff;
+
+	/* All the information will be needed to set engine */
+	struct tmds_setting_information tmds_setting_info;
+	struct crt_setting_information crt_setting_info;
+	struct lvds_setting_information lvds_setting_info;
+	struct lvds_setting_information lvds_setting_info2;
+	struct chip_information chip_info;
+};
+
 struct viafb_par {
 	void __iomem *io_virt;	/*iospace virtual memory address */
 	unsigned int fbmem;	/*framebuffer physical memory address */
@@ -47,12 +61,11 @@ struct viafb_par {
 	u32 VQ_start;		/* Virtual Queue Start Address */
 	u32 VQ_end;		/* Virtual Queue End Address */
 	u32 iga_path;
-	struct proc_dir_entry *proc_entry;	/*viafb proc entry */
 
-	/* I2C stuff */
-	struct via_i2c_stuff i2c_stuff;
+	struct viafb_shared *shared;
 
 	/* All the information will be needed to set engine */
+	/* depreciated, use the ones in shared directly */
 	struct tmds_setting_information *tmds_setting_info;
 	struct crt_setting_information *crt_setting_info;
 	struct lvds_setting_information *lvds_setting_info;
diff -puN drivers/video/via/vt1636.c~viafb-improve-viafb_par drivers/video/via/vt1636.c
--- a/drivers/video/via/vt1636.c~viafb-improve-viafb_par
+++ a/drivers/video/via/vt1636.c
@@ -27,7 +27,7 @@ u8 viafb_gpio_i2c_read_lvds(struct lvds_
 {
 	u8 data;
 
-	viaparinfo->i2c_stuff.i2c_port = plvds_chip_info->i2c_port;
+	viaparinfo->shared->i2c_stuff.i2c_port = plvds_chip_info->i2c_port;
 	viafb_i2c_readbyte(plvds_chip_info->lvds_chip_slave_addr, index, &data);
 
 	return data;
@@ -39,7 +39,7 @@ void viafb_gpio_i2c_write_mask_lvds(stru
 {
 	int index, data;
 
-	viaparinfo->i2c_stuff.i2c_port = plvds_chip_info->i2c_port;
+	viaparinfo->shared->i2c_stuff.i2c_port = plvds_chip_info->i2c_port;
 
 	index = io_data.Index;
 	data = viafb_gpio_i2c_read_lvds(plvds_setting_info, plvds_chip_info,
_

Patches currently in -mm which might be from FlorianSchandinat@gmx.de are

origin.patch

