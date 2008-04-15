From: akpm@linux-foundation.org
Subject: - v4l-dvb-replace-remaining-__function__-occurences.patch removed from -mm tree
Date: Tue, 15 Apr 2008 02:10:36 -0700
Message-ID: <200804150910.m3F9AaU5020642@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56238 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756490AbYDOJLY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 05:11:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     v4l: dvb/ replace remaining __FUNCTION__ occurences
has been removed from the -mm tree.  Its filename was
     v4l-dvb-replace-remaining-__function__-occurences.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: v4l: dvb/ replace remaining __FUNCTION__ occurences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/b2c2/flexcop-dma.c              |    4 
 drivers/media/dvb/b2c2/flexcop-sram.c             |   28 +--
 drivers/media/dvb/bt8xx/dst.c                     |    2 
 drivers/media/dvb/bt8xx/dst_ca.c                  |   10 -
 drivers/media/dvb/bt8xx/dvb-bt8xx.c               |    2 
 drivers/media/dvb/cinergyT2/cinergyT2.c           |    2 
 drivers/media/dvb/dvb-core/dmxdev.c               |   10 -
 drivers/media/dvb/dvb-core/dvb_ca_en50221.c       |   36 ++--
 drivers/media/dvb/dvb-core/dvb_demux.c            |    4 
 drivers/media/dvb/dvb-core/dvb_frontend.c         |   30 +--
 drivers/media/dvb/dvb-core/dvb_net.c              |   30 +--
 drivers/media/dvb/dvb-core/dvbdev.c               |    4 
 drivers/media/dvb/dvb-usb/cxusb.c                 |    6 
 drivers/media/dvb/dvb-usb/gp8psk-fe.c             |    4 
 drivers/media/dvb/dvb-usb/m920x.c                 |   12 -
 drivers/media/dvb/dvb-usb/vp702x-fe.c             |   18 +-
 drivers/media/dvb/frontends/bcm3510.c             |    4 
 drivers/media/dvb/frontends/bcm3510.h             |    2 
 drivers/media/dvb/frontends/cx22700.c             |   12 -
 drivers/media/dvb/frontends/cx22700.h             |    2 
 drivers/media/dvb/frontends/cx22702.c             |   24 +-
 drivers/media/dvb/frontends/cx22702.h             |    2 
 drivers/media/dvb/frontends/cx24110.c             |    6 
 drivers/media/dvb/frontends/cx24110.h             |    2 
 drivers/media/dvb/frontends/dib3000.h             |    2 
 drivers/media/dvb/frontends/dib3000mc.h           |    2 
 drivers/media/dvb/frontends/dvb-pll.h             |    2 
 drivers/media/dvb/frontends/isl6405.h             |    2 
 drivers/media/dvb/frontends/isl6421.h             |    2 
 drivers/media/dvb/frontends/l64781.c              |    2 
 drivers/media/dvb/frontends/l64781.h              |    2 
 drivers/media/dvb/frontends/lgdt330x.c            |   38 ++--
 drivers/media/dvb/frontends/lgdt330x.h            |    2 
 drivers/media/dvb/frontends/lnbp21.h              |    2 
 drivers/media/dvb/frontends/mt2060.h              |    2 
 drivers/media/dvb/frontends/mt2131.c              |   14 -
 drivers/media/dvb/frontends/mt2131.h              |    2 
 drivers/media/dvb/frontends/mt2266.h              |    2 
 drivers/media/dvb/frontends/mt312.c               |    6 
 drivers/media/dvb/frontends/mt312.h               |    2 
 drivers/media/dvb/frontends/mt352.c               |    8 
 drivers/media/dvb/frontends/mt352.h               |    2 
 drivers/media/dvb/frontends/nxt200x.c             |   26 +-
 drivers/media/dvb/frontends/nxt200x.h             |    2 
 drivers/media/dvb/frontends/nxt6000.h             |    2 
 drivers/media/dvb/frontends/or51132.c             |    6 
 drivers/media/dvb/frontends/or51132.h             |    2 
 drivers/media/dvb/frontends/or51211.c             |    6 
 drivers/media/dvb/frontends/or51211.h             |    2 
 drivers/media/dvb/frontends/qt1010.h              |    2 
 drivers/media/dvb/frontends/s5h1409.c             |   48 ++---
 drivers/media/dvb/frontends/s5h1409.h             |    2 
 drivers/media/dvb/frontends/s5h1420.c             |    2 
 drivers/media/dvb/frontends/s5h1420.h             |    2 
 drivers/media/dvb/frontends/sp8870.c              |   26 +-
 drivers/media/dvb/frontends/sp8870.h              |    2 
 drivers/media/dvb/frontends/sp887x.c              |   18 +-
 drivers/media/dvb/frontends/sp887x.h              |    2 
 drivers/media/dvb/frontends/stv0297.c             |   14 -
 drivers/media/dvb/frontends/stv0297.h             |    2 
 drivers/media/dvb/frontends/stv0299.c             |   40 ++--
 drivers/media/dvb/frontends/stv0299.h             |    2 
 drivers/media/dvb/frontends/tda10021.c            |    4 
 drivers/media/dvb/frontends/tda10023.c            |    4 
 drivers/media/dvb/frontends/tda1002x.h            |    4 
 drivers/media/dvb/frontends/tda1004x.c            |   56 +++---
 drivers/media/dvb/frontends/tda1004x.h            |    4 
 drivers/media/dvb/frontends/tda10086.c            |   40 ++--
 drivers/media/dvb/frontends/tda10086.h            |    2 
 drivers/media/dvb/frontends/tda18271-priv.h       |    2 
 drivers/media/dvb/frontends/tda18271.h            |    2 
 drivers/media/dvb/frontends/tda8083.c             |    4 
 drivers/media/dvb/frontends/tda8083.h             |    2 
 drivers/media/dvb/frontends/tda826x.c             |   10 -
 drivers/media/dvb/frontends/tda826x.h             |    2 
 drivers/media/dvb/frontends/tda827x.h             |    2 
 drivers/media/dvb/frontends/tua6100.c             |    2 
 drivers/media/dvb/frontends/tua6100.h             |    2 
 drivers/media/dvb/frontends/ves1820.c             |    4 
 drivers/media/dvb/frontends/ves1820.h             |    2 
 drivers/media/dvb/frontends/ves1x93.c             |    6 
 drivers/media/dvb/frontends/ves1x93.h             |    2 
 drivers/media/dvb/frontends/xc5000.c              |   44 ++--
 drivers/media/dvb/frontends/xc5000.h              |    2 
 drivers/media/dvb/frontends/zl10353.c             |    6 
 drivers/media/dvb/frontends/zl10353.h             |    2 
 drivers/media/dvb/ttpci/av7110.c                  |   12 -
 drivers/media/dvb/ttpci/av7110.h                  |    2 
 drivers/media/dvb/ttpci/av7110_hw.c               |   42 ++--
 drivers/media/dvb/ttpci/av7110_ir.c               |    6 
 drivers/media/dvb/ttpci/av7110_v4l.c              |    4 
 drivers/media/dvb/ttpci/budget-ci.c               |    2 
 drivers/media/dvb/ttpci/budget-core.c             |    2 
 drivers/media/dvb/ttpci/budget.c                  |    6 
 drivers/media/dvb/ttpci/budget.h                  |    2 
 drivers/media/dvb/ttpci/ttpci-eeprom.c            |    2 
 drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c |   44 ++--
 drivers/media/dvb/ttusb-dec/ttusb_dec.c           |  106 ++++++------
 drivers/media/dvb/ttusb-dec/ttusbdecfe.c          |    4 
 99 files changed, 501 insertions(+), 501 deletions(-)

diff -puN drivers/media/dvb/b2c2/flexcop-dma.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/b2c2/flexcop-dma.c
--- a/drivers/media/dvb/b2c2/flexcop-dma.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/b2c2/flexcop-dma.c
@@ -112,7 +112,7 @@ static int flexcop_dma_remap(struct flex
 {
 	flexcop_ibi_register r = (dma_idx & FC_DMA_1) ? dma1_00c : dma2_01c;
 	flexcop_ibi_value v = fc->read_ibi_reg(fc,r);
-	deb_info("%s\n",__FUNCTION__);
+	deb_info("%s\n",__func__);
 	v.dma_0xc.remap_enable = onoff;
 	fc->write_ibi_reg(fc,r,v);
 	return 0;
@@ -162,7 +162,7 @@ int flexcop_dma_config_timer(struct flex
 
 	flexcop_dma_remap(fc,dma_idx,0);
 
-	deb_info("%s\n",__FUNCTION__);
+	deb_info("%s\n",__func__);
 	v.dma_0x4_write.dmatimer = cycles;
 	fc->write_ibi_reg(fc,r,v);
 	return 0;
diff -puN drivers/media/dvb/b2c2/flexcop-sram.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/b2c2/flexcop-sram.c
--- a/drivers/media/dvb/b2c2/flexcop-sram.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/b2c2/flexcop-sram.c
@@ -90,7 +90,7 @@ static void flexcop_sram_write(struct ad
 		};
 
 		if (retries == 0)
-			printk("%s: SRAM timeout\n", __FUNCTION__);
+			printk("%s: SRAM timeout\n", __func__);
 
 		write_reg_dw(adapter, 0x700, command);
 
@@ -115,7 +115,7 @@ static void flex_sram_read(struct adapte
 		};
 
 		if (retries == 0)
-			printk("%s: SRAM timeout\n", __FUNCTION__);
+			printk("%s: SRAM timeout\n", __func__);
 
 		write_reg_dw(adapter, 0x700, command);
 
@@ -127,7 +127,7 @@ static void flex_sram_read(struct adapte
 		};
 
 		if (retries == 0)
-			printk("%s: SRAM timeout\n", __FUNCTION__);
+			printk("%s: SRAM timeout\n", __func__);
 
 		value = read_reg_dw(adapter, 0x700) >> 0x10;
 
@@ -240,13 +240,13 @@ static void sram_init(struct adapter *ad
 
 		adapter->dw_sram_type = tmp & 0x30000;
 
-		ddprintk("%s: dw_sram_type = %x\n", __FUNCTION__, adapter->dw_sram_type);
+		ddprintk("%s: dw_sram_type = %x\n", __func__, adapter->dw_sram_type);
 
 	} else {
 
 		adapter->dw_sram_type = 0x10000;
 
-		ddprintk("%s: dw_sram_type = %x\n", __FUNCTION__, adapter->dw_sram_type);
+		ddprintk("%s: dw_sram_type = %x\n", __func__, adapter->dw_sram_type);
 	}
 
 	/* return value is never used? */
@@ -257,7 +257,7 @@ static int sram_test_location(struct ada
 {
 	u8 tmp1, tmp2;
 
-	dprintk("%s: mask = %x, addr = %x\n", __FUNCTION__, mask, addr);
+	dprintk("%s: mask = %x, addr = %x\n", __func__, mask, addr);
 
 	sram_set_size(adapter, mask);
 	sram_init(adapter);
@@ -275,7 +275,7 @@ static int sram_test_location(struct ada
 	sram_read(adapter, addr, &tmp2, 1);
 	sram_read(adapter, addr, &tmp2, 1);
 
-	dprintk("%s: wrote 0xa5, read 0x%2x\n", __FUNCTION__, tmp2);
+	dprintk("%s: wrote 0xa5, read 0x%2x\n", __func__, tmp2);
 
 	if (tmp2 != 0xa5)
 		return 0;
@@ -293,7 +293,7 @@ static int sram_test_location(struct ada
 	sram_read(adapter, addr, &tmp2, 1);
 	sram_read(adapter, addr, &tmp2, 1);
 
-	dprintk("%s: wrote 0x5a, read 0x%2x\n", __FUNCTION__, tmp2);
+	dprintk("%s: wrote 0x5a, read 0x%2x\n", __func__, tmp2);
 
 	if (tmp2 != 0x5a)
 		return 0;
@@ -340,7 +340,7 @@ static int flexcop_sram_detect(struct fl
 
 	tmp3 = read_reg_dw(adapter, 0x71c);
 
-	dprintk("%s: tmp3 = %x\n", __FUNCTION__, tmp3);
+	dprintk("%s: tmp3 = %x\n", __func__, tmp3);
 
 	write_reg_dw(adapter, 0x71c, tmp2);
 
@@ -351,7 +351,7 @@ static int flexcop_sram_detect(struct fl
 		sram_init(adapter);
 		write_reg_dw(adapter, 0x208, tmp);
 
-		dprintk("%s: sram size = 32K\n", __FUNCTION__);
+		dprintk("%s: sram size = 32K\n", __func__);
 
 		return 32;
 	}
@@ -361,7 +361,7 @@ static int flexcop_sram_detect(struct fl
 		sram_init(adapter);
 		write_reg_dw(adapter, 0x208, tmp);
 
-		dprintk("%s: sram size = 128K\n", __FUNCTION__);
+		dprintk("%s: sram size = 128K\n", __func__);
 
 		return 128;
 	}
@@ -371,7 +371,7 @@ static int flexcop_sram_detect(struct fl
 		sram_init(adapter);
 		write_reg_dw(adapter, 0x208, tmp);
 
-		dprintk("%s: sram size = 64K\n", __FUNCTION__);
+		dprintk("%s: sram size = 64K\n", __func__);
 
 		return 64;
 	}
@@ -381,7 +381,7 @@ static int flexcop_sram_detect(struct fl
 		sram_init(adapter);
 		write_reg_dw(adapter, 0x208, tmp);
 
-		dprintk("%s: sram size = 32K\n", __FUNCTION__);
+		dprintk("%s: sram size = 32K\n", __func__);
 
 		return 32;
 	}
@@ -390,7 +390,7 @@ static int flexcop_sram_detect(struct fl
 	sram_init(adapter);
 	write_reg_dw(adapter, 0x208, tmp);
 
-	dprintk("%s: SRAM detection failed. Set to 32K \n", __FUNCTION__);
+	dprintk("%s: SRAM detection failed. Set to 32K \n", __func__);
 
 	return 0;
 }
diff -puN drivers/media/dvb/bt8xx/dst.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/bt8xx/dst.c
--- a/drivers/media/dvb/bt8xx/dst.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/bt8xx/dst.c
@@ -1290,7 +1290,7 @@ static int dst_get_signal(struct dst_sta
 {
 	int retval;
 	u8 get_signal[] = { 0x00, 0x05, 0x00, 0x00, 0x00, 0x00, 0x00, 0xfb };
-	//dprintk("%s: Getting Signal strength and other parameters\n", __FUNCTION__);
+	//dprintk("%s: Getting Signal strength and other parameters\n", __func__);
 	if ((state->diseq_flags & ATTEMPT_TUNE) == 0) {
 		state->decode_lock = state->decode_strength = state->decode_snr = 0;
 		return 0;
diff -puN drivers/media/dvb/bt8xx/dst_ca.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/bt8xx/dst_ca.c
--- a/drivers/media/dvb/bt8xx/dst_ca.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/bt8xx/dst_ca.c
@@ -36,13 +36,13 @@
 #define dprintk(x, y, z, format, arg...) do {						\
 	if (z) {									\
 		if	((x > DST_CA_ERROR) && (x > y))					\
-			printk(KERN_ERR "%s: " format "\n", __FUNCTION__ , ##arg);	\
+			printk(KERN_ERR "%s: " format "\n", __func__ , ##arg);	\
 		else if	((x > DST_CA_NOTICE) && (x > y))				\
-			printk(KERN_NOTICE "%s: " format "\n", __FUNCTION__ , ##arg);	\
+			printk(KERN_NOTICE "%s: " format "\n", __func__ , ##arg);	\
 		else if ((x > DST_CA_INFO) && (x > y))					\
-			printk(KERN_INFO "%s: " format "\n", __FUNCTION__ , ##arg);	\
+			printk(KERN_INFO "%s: " format "\n", __func__ , ##arg);	\
 		else if ((x > DST_CA_DEBUG) && (x > y))					\
-			printk(KERN_DEBUG "%s: " format "\n", __FUNCTION__ , ##arg);	\
+			printk(KERN_DEBUG "%s: " format "\n", __func__ , ##arg);	\
 	} else {									\
 		if (x > y)								\
 			printk(format, ## arg);						\
@@ -162,7 +162,7 @@ static int ca_get_app_info(struct dst_st
 	dprintk(verbose, DST_CA_INFO, 1, " ================================ CI Module Application Info ======================================");
 	dprintk(verbose, DST_CA_INFO, 1, " Application Type=[%d], Application Vendor=[%d], Vendor Code=[%d]\n%s: Application info=[%s]",
 		state->messages[7], (state->messages[8] << 8) | state->messages[9],
-		(state->messages[10] << 8) | state->messages[11], __FUNCTION__, (char *)(&state->messages[12]));
+		(state->messages[10] << 8) | state->messages[11], __func__, (char *)(&state->messages[12]));
 	dprintk(verbose, DST_CA_INFO, 1, " ==================================================================================================");
 
 	// Transform dst message to correct application_info message
diff -puN drivers/media/dvb/bt8xx/dvb-bt8xx.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/bt8xx/dvb-bt8xx.c
--- a/drivers/media/dvb/bt8xx/dvb-bt8xx.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/bt8xx/dvb-bt8xx.c
@@ -671,7 +671,7 @@ static void frontend_init(struct dvb_bt8
 		state->dst_ca = NULL;
 		/*	DST is not a frontend, attaching the ASIC	*/
 		if (dvb_attach(dst_attach, state, &card->dvb_adapter) == NULL) {
-			printk("%s: Could not find a Twinhan DST.\n", __FUNCTION__);
+			printk("%s: Could not find a Twinhan DST.\n", __func__);
 			break;
 		}
 		/*	Attach other DST peripherals if any		*/
diff -puN drivers/media/dvb/cinergyT2/cinergyT2.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/cinergyT2/cinergyT2.c
--- a/drivers/media/dvb/cinergyT2/cinergyT2.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/cinergyT2/cinergyT2.c
@@ -62,7 +62,7 @@ MODULE_PARM_DESC(debug, "Turn on/off deb
 do {									\
 	if ((debug & level)) {						\
 		printk("%s: %s(): ", KBUILD_MODNAME,			\
-		       __FUNCTION__);					\
+		       __func__);					\
 		printk(args); }						\
 } while (0)
 
diff -puN drivers/media/dvb/dvb-core/dmxdev.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/dvb-core/dmxdev.c
--- a/drivers/media/dvb/dvb-core/dmxdev.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/dvb-core/dmxdev.c
@@ -126,7 +126,7 @@ static int dvb_dvr_open(struct inode *in
 	struct dmxdev *dmxdev = dvbdev->priv;
 	struct dmx_frontend *front;
 
-	dprintk("function : %s\n", __FUNCTION__);
+	dprintk("function : %s\n", __func__);
 
 	if (mutex_lock_interruptible(&dmxdev->mutex))
 		return -ERESTARTSYS;
@@ -551,7 +551,7 @@ static int dvb_dmxdev_filter_start(struc
 								   dvb_dmxdev_section_callback);
 			if (ret < 0) {
 				printk("DVB (%s): could not alloc feed\n",
-				       __FUNCTION__);
+				       __func__);
 				return ret;
 			}
 
@@ -559,7 +559,7 @@ static int dvb_dmxdev_filter_start(struc
 					      (para->flags & DMX_CHECK_CRC) ? 1 : 0);
 			if (ret < 0) {
 				printk("DVB (%s): could not set feed\n",
-				       __FUNCTION__);
+				       __func__);
 				dvb_dmxdev_feed_restart(filter);
 				return ret;
 			}
@@ -734,7 +734,7 @@ static int dvb_dmxdev_filter_set(struct 
 				 struct dmxdev_filter *dmxdevfilter,
 				 struct dmx_sct_filter_params *params)
 {
-	dprintk("function : %s\n", __FUNCTION__);
+	dprintk("function : %s\n", __func__);
 
 	dvb_dmxdev_filter_stop(dmxdevfilter);
 
@@ -1040,7 +1040,7 @@ static unsigned int dvb_dvr_poll(struct 
 	struct dmxdev *dmxdev = dvbdev->priv;
 	unsigned int mask = 0;
 
-	dprintk("function : %s\n", __FUNCTION__);
+	dprintk("function : %s\n", __func__);
 
 	poll_wait(file, &dmxdev->dvr_buffer.queue, wait);
 
diff -puN drivers/media/dvb/dvb-core/dvb_ca_en50221.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/dvb-core/dvb_ca_en50221.c
--- a/drivers/media/dvb/dvb-core/dvb_ca_en50221.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
@@ -250,7 +250,7 @@ static int dvb_ca_en50221_wait_if_status
 	unsigned long timeout;
 	unsigned long start;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	/* loop until timeout elapsed */
 	start = jiffies;
@@ -263,7 +263,7 @@ static int dvb_ca_en50221_wait_if_status
 
 		/* if we got the flags, it was successful! */
 		if (res & waitfor) {
-			dprintk("%s succeeded timeout:%lu\n", __FUNCTION__, jiffies - start);
+			dprintk("%s succeeded timeout:%lu\n", __func__, jiffies - start);
 			return 0;
 		}
 
@@ -276,7 +276,7 @@ static int dvb_ca_en50221_wait_if_status
 		msleep(1);
 	}
 
-	dprintk("%s failed timeout:%lu\n", __FUNCTION__, jiffies - start);
+	dprintk("%s failed timeout:%lu\n", __func__, jiffies - start);
 
 	/* if we get here, we've timed out */
 	return -ETIMEDOUT;
@@ -297,7 +297,7 @@ static int dvb_ca_en50221_link_init(stru
 	int buf_size;
 	u8 buf[2];
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	/* we'll be determining these during this function */
 	ca->slot_info[slot].da_irq_supported = 0;
@@ -549,7 +549,7 @@ static int dvb_ca_en50221_set_configopti
 {
 	int configoption;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	/* set the config option */
 	ca->pub->write_attribute_mem(ca->pub, slot,
@@ -587,7 +587,7 @@ static int dvb_ca_en50221_read_data(stru
 	u8 buf[HOST_LINK_BUF_SIZE];
 	int i;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	/* check if we have space for a link buf in the rx_buffer */
 	if (ebuf == NULL) {
@@ -708,7 +708,7 @@ static int dvb_ca_en50221_write_data(str
 	int status;
 	int i;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 
 	// sanity check
@@ -785,7 +785,7 @@ EXPORT_SYMBOL(dvb_ca_en50221_camchange_i
  */
 static int dvb_ca_en50221_slot_shutdown(struct dvb_ca_private *ca, int slot)
 {
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	ca->pub->slot_shutdown(ca->pub, slot);
 	ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_NONE;
@@ -892,7 +892,7 @@ void dvb_ca_en50221_frda_irq(struct dvb_
 static void dvb_ca_en50221_thread_wakeup(struct dvb_ca_private *ca)
 {
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	ca->wakeup = 1;
 	mb();
@@ -964,7 +964,7 @@ static int dvb_ca_en50221_thread(void *d
 	int pktcount;
 	void *rxbuf;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	/* choose the correct initial delay */
 	dvb_ca_en50221_thread_update_delay(ca);
@@ -1172,7 +1172,7 @@ static int dvb_ca_en50221_io_do_ioctl(st
 	int err = 0;
 	int slot;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	switch (cmd) {
 	case CA_RESET:
@@ -1266,7 +1266,7 @@ static ssize_t dvb_ca_en50221_io_write(s
 	unsigned long timeout;
 	int written;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	/* Incoming packet has a 2 byte header. hdr[0] = slot_id, hdr[1] = connection_id */
 	if (count < 2)
@@ -1401,7 +1401,7 @@ static ssize_t dvb_ca_en50221_io_read(st
 	int pktlen;
 	int dispose = 0;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	/* Outgoing packet has a 2 byte header. hdr[0] = slot_id, hdr[1] = connection_id */
 	if (count < 2)
@@ -1490,7 +1490,7 @@ static int dvb_ca_en50221_io_open(struct
 	int err;
 	int i;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	if (!try_module_get(ca->pub->owner))
 		return -EIO;
@@ -1534,7 +1534,7 @@ static int dvb_ca_en50221_io_release(str
 	struct dvb_ca_private *ca = dvbdev->priv;
 	int err;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	/* mark the CA device as closed */
 	ca->open = 0;
@@ -1564,7 +1564,7 @@ static unsigned int dvb_ca_en50221_io_po
 	int slot;
 	int result = 0;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	if (dvb_ca_en50221_io_read_condition(ca, &result, &slot) == 1) {
 		mask |= POLLIN;
@@ -1626,7 +1626,7 @@ int dvb_ca_en50221_init(struct dvb_adapt
 	struct dvb_ca_private *ca = NULL;
 	int i;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	if (slot_count < 1)
 		return -EINVAL;
@@ -1704,7 +1704,7 @@ void dvb_ca_en50221_release(struct dvb_c
 	struct dvb_ca_private *ca = pubca->private;
 	int i;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	/* shutdown the thread if there was one */
 	kthread_stop(ca->thread);
diff -puN drivers/media/dvb/dvb-core/dvb_demux.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/dvb-core/dvb_demux.c
--- a/drivers/media/dvb/dvb-core/dvb_demux.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/dvb-core/dvb_demux.c
@@ -553,7 +553,7 @@ static void dvb_demux_feed_add(struct dv
 	spin_lock_irq(&feed->demux->lock);
 	if (dvb_demux_feed_find(feed)) {
 		printk(KERN_ERR "%s: feed already in list (type=%x state=%x pid=%x)\n",
-		       __FUNCTION__, feed->type, feed->state, feed->pid);
+		       __func__, feed->type, feed->state, feed->pid);
 		goto out;
 	}
 
@@ -567,7 +567,7 @@ static void dvb_demux_feed_del(struct dv
 	spin_lock_irq(&feed->demux->lock);
 	if (!(dvb_demux_feed_find(feed))) {
 		printk(KERN_ERR "%s: feed not in list (type=%x state=%x pid=%x)\n",
-		       __FUNCTION__, feed->type, feed->state, feed->pid);
+		       __func__, feed->type, feed->state, feed->pid);
 		goto out;
 	}
 
diff -puN drivers/media/dvb/dvb-core/dvb_frontend.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/dvb-core/dvb_frontend.c
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -135,7 +135,7 @@ static void dvb_frontend_add_event(struc
 	struct dvb_frontend_event *e;
 	int wp;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	if (mutex_lock_interruptible (&events->mtx))
 		return;
@@ -171,7 +171,7 @@ static int dvb_frontend_get_event(struct
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	struct dvb_fe_events *events = &fepriv->events;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	if (events->overflow) {
 		events->overflow = 0;
@@ -237,7 +237,7 @@ static void dvb_frontend_swzigzag_update
 {
 	int q2;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	if (locked)
 		(fepriv->quality) = (fepriv->quality * 220 + 36*256) / 256;
@@ -329,7 +329,7 @@ static int dvb_frontend_swzigzag_autotun
 
 	dprintk("%s: drift:%i inversion:%i auto_step:%i "
 		"auto_sub_step:%i started_auto_step:%i\n",
-		__FUNCTION__, fepriv->lnb_drift, fepriv->inversion,
+		__func__, fepriv->lnb_drift, fepriv->inversion,
 		fepriv->auto_step, fepriv->auto_sub_step, fepriv->started_auto_step);
 
 	/* set the frontend itself */
@@ -511,7 +511,7 @@ static int dvb_frontend_thread(void *dat
 	fe_status_t s;
 	struct dvb_frontend_parameters *params;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	fepriv->check_wrapped = 0;
 	fepriv->quality = 0;
@@ -597,7 +597,7 @@ static void dvb_frontend_stop(struct dvb
 {
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	fepriv->exit = 1;
 	mb();
@@ -665,7 +665,7 @@ static int dvb_frontend_start(struct dvb
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	struct task_struct *fe_thread;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	if (fepriv->thread) {
 		if (!fepriv->exit)
@@ -763,7 +763,7 @@ static int dvb_frontend_ioctl(struct ino
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	int err = -EOPNOTSUPP;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	if (fepriv->exit)
 		return -ENODEV;
@@ -895,7 +895,7 @@ static int dvb_frontend_ioctl(struct ino
 			int i;
 			u8 last = 1;
 			if (dvb_frontend_debug)
-				printk("%s switch command: 0x%04lx\n", __FUNCTION__, cmd);
+				printk("%s switch command: 0x%04lx\n", __func__, cmd);
 			do_gettimeofday(&nexttime);
 			if (dvb_frontend_debug)
 				memcpy(&tv[0], &nexttime, sizeof(struct timeval));
@@ -919,7 +919,7 @@ static int dvb_frontend_ioctl(struct ino
 			}
 			if (dvb_frontend_debug) {
 				printk("%s(%d): switch delay (should be 32k followed by all 8k\n",
-					__FUNCTION__, fe->dvb->num);
+					__func__, fe->dvb->num);
 				for (i = 1; i < 10; i++)
 					printk("%d: %d\n", i, timeval_usec_diff(tv[i-1] , tv[i]));
 			}
@@ -1037,7 +1037,7 @@ static unsigned int dvb_frontend_poll(st
 	struct dvb_frontend *fe = dvbdev->priv;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	poll_wait (file, &fepriv->events.wait_queue, wait);
 
@@ -1054,7 +1054,7 @@ static int dvb_frontend_open(struct inod
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	int ret;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	if (dvbdev->users == -1 && fe->ops.ts_bus_ctrl) {
 		if ((ret = fe->ops.ts_bus_ctrl(fe, 1)) < 0)
@@ -1095,7 +1095,7 @@ static int dvb_frontend_release(struct i
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	int ret;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	if ((file->f_flags & O_ACCMODE) != O_RDONLY)
 		fepriv->release_jiffies = jiffies;
@@ -1135,7 +1135,7 @@ int dvb_register_frontend(struct dvb_ada
 		.kernel_ioctl = dvb_frontend_ioctl
 	};
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	if (mutex_lock_interruptible(&frontend_mutex))
 		return -ERESTARTSYS;
@@ -1169,7 +1169,7 @@ EXPORT_SYMBOL(dvb_register_frontend);
 int dvb_unregister_frontend(struct dvb_frontend* fe)
 {
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	mutex_lock(&frontend_mutex);
 	dvb_frontend_stop (fe);
diff -puN drivers/media/dvb/dvb-core/dvb_net.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/dvb-core/dvb_net.c
--- a/drivers/media/dvb/dvb-core/dvb_net.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/dvb-core/dvb_net.c
@@ -965,17 +965,17 @@ static int dvb_net_feed_start(struct net
 	struct dmx_demux *demux = priv->demux;
 	unsigned char *mac = (unsigned char *) dev->dev_addr;
 
-	dprintk("%s: rx_mode %i\n", __FUNCTION__, priv->rx_mode);
+	dprintk("%s: rx_mode %i\n", __func__, priv->rx_mode);
 	mutex_lock(&priv->mutex);
 	if (priv->tsfeed || priv->secfeed || priv->secfilter || priv->multi_secfilter[0])
-		printk("%s: BUG %d\n", __FUNCTION__, __LINE__);
+		printk("%s: BUG %d\n", __func__, __LINE__);
 
 	priv->secfeed=NULL;
 	priv->secfilter=NULL;
 	priv->tsfeed = NULL;
 
 	if (priv->feedtype == DVB_NET_FEEDTYPE_MPE) {
-		dprintk("%s: alloc secfeed\n", __FUNCTION__);
+		dprintk("%s: alloc secfeed\n", __func__);
 		ret=demux->allocate_section_feed(demux, &priv->secfeed,
 					 dvb_net_sec_callback);
 		if (ret<0) {
@@ -993,38 +993,38 @@ static int dvb_net_feed_start(struct net
 		}
 
 		if (priv->rx_mode != RX_MODE_PROMISC) {
-			dprintk("%s: set secfilter\n", __FUNCTION__);
+			dprintk("%s: set secfilter\n", __func__);
 			dvb_net_filter_sec_set(dev, &priv->secfilter, mac, mask_normal);
 		}
 
 		switch (priv->rx_mode) {
 		case RX_MODE_MULTI:
 			for (i = 0; i < priv->multi_num; i++) {
-				dprintk("%s: set multi_secfilter[%d]\n", __FUNCTION__, i);
+				dprintk("%s: set multi_secfilter[%d]\n", __func__, i);
 				dvb_net_filter_sec_set(dev, &priv->multi_secfilter[i],
 						       priv->multi_macs[i], mask_normal);
 			}
 			break;
 		case RX_MODE_ALL_MULTI:
 			priv->multi_num=1;
-			dprintk("%s: set multi_secfilter[0]\n", __FUNCTION__);
+			dprintk("%s: set multi_secfilter[0]\n", __func__);
 			dvb_net_filter_sec_set(dev, &priv->multi_secfilter[0],
 					       mac_allmulti, mask_allmulti);
 			break;
 		case RX_MODE_PROMISC:
 			priv->multi_num=0;
-			dprintk("%s: set secfilter\n", __FUNCTION__);
+			dprintk("%s: set secfilter\n", __func__);
 			dvb_net_filter_sec_set(dev, &priv->secfilter, mac, mask_promisc);
 			break;
 		}
 
-		dprintk("%s: start filtering\n", __FUNCTION__);
+		dprintk("%s: start filtering\n", __func__);
 		priv->secfeed->start_filtering(priv->secfeed);
 	} else if (priv->feedtype == DVB_NET_FEEDTYPE_ULE) {
 		struct timespec timeout = { 0, 10000000 }; // 10 msec
 
 		/* we have payloads encapsulated in TS */
-		dprintk("%s: alloc tsfeed\n", __FUNCTION__);
+		dprintk("%s: alloc tsfeed\n", __func__);
 		ret = demux->allocate_ts_feed(demux, &priv->tsfeed, dvb_net_ts_callback);
 		if (ret < 0) {
 			printk("%s: could not allocate ts feed\n", dev->name);
@@ -1048,7 +1048,7 @@ static int dvb_net_feed_start(struct net
 			goto error;
 		}
 
-		dprintk("%s: start filtering\n", __FUNCTION__);
+		dprintk("%s: start filtering\n", __func__);
 		priv->tsfeed->start_filtering(priv->tsfeed);
 	} else
 		ret = -EINVAL;
@@ -1063,17 +1063,17 @@ static int dvb_net_feed_stop(struct net_
 	struct dvb_net_priv *priv = dev->priv;
 	int i, ret = 0;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 	mutex_lock(&priv->mutex);
 	if (priv->feedtype == DVB_NET_FEEDTYPE_MPE) {
 		if (priv->secfeed) {
 			if (priv->secfeed->is_filtering) {
-				dprintk("%s: stop secfeed\n", __FUNCTION__);
+				dprintk("%s: stop secfeed\n", __func__);
 				priv->secfeed->stop_filtering(priv->secfeed);
 			}
 
 			if (priv->secfilter) {
-				dprintk("%s: release secfilter\n", __FUNCTION__);
+				dprintk("%s: release secfilter\n", __func__);
 				priv->secfeed->release_filter(priv->secfeed,
 							      priv->secfilter);
 				priv->secfilter=NULL;
@@ -1082,7 +1082,7 @@ static int dvb_net_feed_stop(struct net_
 			for (i=0; i<priv->multi_num; i++) {
 				if (priv->multi_secfilter[i]) {
 					dprintk("%s: release multi_filter[%d]\n",
-						__FUNCTION__, i);
+						__func__, i);
 					priv->secfeed->release_filter(priv->secfeed,
 								      priv->multi_secfilter[i]);
 					priv->multi_secfilter[i] = NULL;
@@ -1096,7 +1096,7 @@ static int dvb_net_feed_stop(struct net_
 	} else if (priv->feedtype == DVB_NET_FEEDTYPE_ULE) {
 		if (priv->tsfeed) {
 			if (priv->tsfeed->is_filtering) {
-				dprintk("%s: stop tsfeed\n", __FUNCTION__);
+				dprintk("%s: stop tsfeed\n", __func__);
 				priv->tsfeed->stop_filtering(priv->tsfeed);
 			}
 			priv->demux->release_ts_feed(priv->demux, priv->tsfeed);
diff -puN drivers/media/dvb/dvb-core/dvbdev.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/dvb-core/dvbdev.c
--- a/drivers/media/dvb/dvb-core/dvbdev.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/dvb-core/dvbdev.c
@@ -196,7 +196,7 @@ int dvb_register_device(struct dvb_adapt
 	if ((id = dvbdev_get_free_id (adap, type)) < 0){
 		mutex_unlock(&dvbdev_register_lock);
 		*pdvbdev = NULL;
-		printk(KERN_ERR "%s: couldn't find free device id\n", __FUNCTION__);
+		printk(KERN_ERR "%s: couldn't find free device id\n", __func__);
 		return -ENFILE;
 	}
 
@@ -235,7 +235,7 @@ int dvb_register_device(struct dvb_adapt
 			       "dvb%d.%s%d", adap->num, dnames[type], id);
 	if (IS_ERR(clsdev)) {
 		printk(KERN_ERR "%s: failed to create device dvb%d.%s%d (%ld)\n",
-		       __FUNCTION__, adap->num, dnames[type], id, PTR_ERR(clsdev));
+		       __func__, adap->num, dnames[type], id, PTR_ERR(clsdev));
 		return PTR_ERR(clsdev);
 	}
 
diff -puN drivers/media/dvb/dvb-usb/cxusb.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/dvb-usb/cxusb.c
--- a/drivers/media/dvb/dvb-usb/cxusb.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/dvb-usb/cxusb.c
@@ -492,14 +492,14 @@ static int dvico_bluebird_xc2028_callbac
 
 	switch (command) {
 	case XC2028_TUNER_RESET:
-		deb_info("%s: XC2028_TUNER_RESET %d\n", __FUNCTION__, arg);
+		deb_info("%s: XC2028_TUNER_RESET %d\n", __func__, arg);
 		cxusb_bluebird_gpio_pulse(d, 0x01, 1);
 		break;
 	case XC2028_RESET_CLK:
-		deb_info("%s: XC2028_RESET_CLK %d\n", __FUNCTION__, arg);
+		deb_info("%s: XC2028_RESET_CLK %d\n", __func__, arg);
 		break;
 	default:
-		deb_info("%s: unknown command %d, arg %d\n", __FUNCTION__,
+		deb_info("%s: unknown command %d, arg %d\n", __func__,
 			 command, arg);
 		return -EINVAL;
 	}
diff -puN drivers/media/dvb/dvb-usb/gp8psk-fe.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/dvb-usb/gp8psk-fe.c
--- a/drivers/media/dvb/dvb-usb/gp8psk-fe.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/dvb-usb/gp8psk-fe.c
@@ -152,7 +152,7 @@ static int gp8psk_fe_send_diseqc_msg (st
 {
 	struct gp8psk_fe_state *st = fe->demodulator_priv;
 
-	deb_fe("%s\n",__FUNCTION__);
+	deb_fe("%s\n",__func__);
 
 	if (gp8psk_usb_out_op(st->d,SEND_DISEQC_COMMAND, m->msg[0], 0,
 			m->msg, m->msg_len)) {
@@ -167,7 +167,7 @@ static int gp8psk_fe_send_diseqc_burst (
 	struct gp8psk_fe_state *st = fe->demodulator_priv;
 	u8 cmd;
 
-	deb_fe("%s\n",__FUNCTION__);
+	deb_fe("%s\n",__func__);
 
 	/* These commands are certainly wrong */
 	cmd = (burst == SEC_MINI_A) ? 0x00 : 0x01;
diff -puN drivers/media/dvb/dvb-usb/m920x.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/dvb-usb/m920x.c
--- a/drivers/media/dvb/dvb-usb/m920x.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/dvb-usb/m920x.c
@@ -477,7 +477,7 @@ static struct qt1010_config m920x_qt1010
 /* Callbacks for DVB USB */
 static int m920x_mt352_frontend_attach(struct dvb_usb_adapter *adap)
 {
-	deb("%s\n",__FUNCTION__);
+	deb("%s\n",__func__);
 
 	if ((adap->fe = dvb_attach(mt352_attach,
 				   &m920x_mt352_config,
@@ -489,7 +489,7 @@ static int m920x_mt352_frontend_attach(s
 
 static int m920x_tda10046_08_frontend_attach(struct dvb_usb_adapter *adap)
 {
-	deb("%s\n",__FUNCTION__);
+	deb("%s\n",__func__);
 
 	if ((adap->fe = dvb_attach(tda10046_attach,
 				   &m920x_tda10046_08_config,
@@ -501,7 +501,7 @@ static int m920x_tda10046_08_frontend_at
 
 static int m920x_tda10046_0b_frontend_attach(struct dvb_usb_adapter *adap)
 {
-	deb("%s\n",__FUNCTION__);
+	deb("%s\n",__func__);
 
 	if ((adap->fe = dvb_attach(tda10046_attach,
 				   &m920x_tda10046_0b_config,
@@ -513,7 +513,7 @@ static int m920x_tda10046_0b_frontend_at
 
 static int m920x_qt1010_tuner_attach(struct dvb_usb_adapter *adap)
 {
-	deb("%s\n",__FUNCTION__);
+	deb("%s\n",__func__);
 
 	if (dvb_attach(qt1010_attach, adap->fe, &adap->dev->i2c_adap, &m920x_qt1010_config) == NULL)
 		return -ENODEV;
@@ -523,7 +523,7 @@ static int m920x_qt1010_tuner_attach(str
 
 static int m920x_tda8275_60_tuner_attach(struct dvb_usb_adapter *adap)
 {
-	deb("%s\n",__FUNCTION__);
+	deb("%s\n",__func__);
 
 	if (dvb_attach(tda827x_attach, adap->fe, 0x60, &adap->dev->i2c_adap, NULL) == NULL)
 		return -ENODEV;
@@ -533,7 +533,7 @@ static int m920x_tda8275_60_tuner_attach
 
 static int m920x_tda8275_61_tuner_attach(struct dvb_usb_adapter *adap)
 {
-	deb("%s\n",__FUNCTION__);
+	deb("%s\n",__func__);
 
 	if (dvb_attach(tda827x_attach, adap->fe, 0x61, &adap->dev->i2c_adap, NULL) == NULL)
 		return -ENODEV;
diff -puN drivers/media/dvb/dvb-usb/vp702x-fe.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/dvb-usb/vp702x-fe.c
--- a/drivers/media/dvb/dvb-usb/vp702x-fe.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/dvb-usb/vp702x-fe.c
@@ -67,7 +67,7 @@ static int vp702x_fe_read_status(struct 
 {
 	struct vp702x_fe_state *st = fe->demodulator_priv;
 	vp702x_fe_refresh_state(st);
-	deb_fe("%s\n",__FUNCTION__);
+	deb_fe("%s\n",__func__);
 
 	if (st->lock == 0)
 		*status = FE_HAS_LOCK | FE_HAS_SYNC | FE_HAS_VITERBI | FE_HAS_SIGNAL | FE_HAS_CARRIER;
@@ -121,7 +121,7 @@ static int vp702x_fe_read_snr(struct dvb
 
 static int vp702x_fe_get_tune_settings(struct dvb_frontend* fe, struct dvb_frontend_tune_settings *tune)
 {
-	deb_fe("%s\n",__FUNCTION__);
+	deb_fe("%s\n",__func__);
 	tune->min_delay_ms = 2000;
 	return 0;
 }
@@ -183,21 +183,21 @@ static int vp702x_fe_set_frontend(struct
 static int vp702x_fe_init(struct dvb_frontend *fe)
 {
 	struct vp702x_fe_state *st = fe->demodulator_priv;
-	deb_fe("%s\n",__FUNCTION__);
+	deb_fe("%s\n",__func__);
 	vp702x_usb_in_op(st->d, RESET_TUNER, 0, 0, NULL, 0);
 	return 0;
 }
 
 static int vp702x_fe_sleep(struct dvb_frontend *fe)
 {
-	deb_fe("%s\n",__FUNCTION__);
+	deb_fe("%s\n",__func__);
 	return 0;
 }
 
 static int vp702x_fe_get_frontend(struct dvb_frontend* fe,
 				  struct dvb_frontend_parameters *fep)
 {
-	deb_fe("%s\n",__FUNCTION__);
+	deb_fe("%s\n",__func__);
 	return 0;
 }
 
@@ -208,7 +208,7 @@ static int vp702x_fe_send_diseqc_msg (st
 	u8 cmd[8],ibuf[10];
 	memset(cmd,0,8);
 
-	deb_fe("%s\n",__FUNCTION__);
+	deb_fe("%s\n",__func__);
 
 	if (m->msg_len > 4)
 		return -EINVAL;
@@ -230,7 +230,7 @@ static int vp702x_fe_send_diseqc_msg (st
 
 static int vp702x_fe_send_diseqc_burst (struct dvb_frontend* fe, fe_sec_mini_cmd_t burst)
 {
-	deb_fe("%s\n",__FUNCTION__);
+	deb_fe("%s\n",__func__);
 	return 0;
 }
 
@@ -238,7 +238,7 @@ static int vp702x_fe_set_tone(struct dvb
 {
 	struct vp702x_fe_state *st = fe->demodulator_priv;
 	u8 ibuf[10];
-	deb_fe("%s\n",__FUNCTION__);
+	deb_fe("%s\n",__func__);
 
 	st->tone_mode = tone;
 
@@ -263,7 +263,7 @@ static int vp702x_fe_set_voltage (struct
 {
 	struct vp702x_fe_state *st = fe->demodulator_priv;
 	u8 ibuf[10];
-	deb_fe("%s\n",__FUNCTION__);
+	deb_fe("%s\n",__func__);
 
 	st->voltage = voltage;
 
diff -puN drivers/media/dvb/frontends/bcm3510.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/bcm3510.c
--- a/drivers/media/dvb/frontends/bcm3510.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/bcm3510.c
@@ -91,7 +91,7 @@ static int bcm3510_writebytes (struct bc
 	if ((err = i2c_transfer (state->i2c, &msg, 1)) != 1) {
 
 		deb_info("%s: i2c write error (addr %02x, reg %02x, err == %i)\n",
-			__FUNCTION__, state->config->demod_address, reg,  err);
+			__func__, state->config->demod_address, reg,  err);
 		return -EREMOTEIO;
 	}
 
@@ -110,7 +110,7 @@ static int bcm3510_readbytes (struct bcm
 
 	if ((err = i2c_transfer (state->i2c, msg, 2)) != 2) {
 		deb_info("%s: i2c read error (addr %02x, reg %02x, err == %i)\n",
-			__FUNCTION__, state->config->demod_address, reg,  err);
+			__func__, state->config->demod_address, reg,  err);
 		return -EREMOTEIO;
 	}
 	deb_i2c("i2c rd %02x: ",reg);
diff -puN drivers/media/dvb/frontends/bcm3510.h~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/bcm3510.h
--- a/drivers/media/dvb/frontends/bcm3510.h~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/bcm3510.h
@@ -41,7 +41,7 @@ extern struct dvb_frontend* bcm3510_atta
 static inline struct dvb_frontend* bcm3510_attach(const struct bcm3510_config* config,
 						  struct i2c_adapter* i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_BCM3510
diff -puN drivers/media/dvb/frontends/cx22700.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/cx22700.c
--- a/drivers/media/dvb/frontends/cx22700.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/cx22700.c
@@ -73,13 +73,13 @@ static int cx22700_writereg (struct cx22
 	u8 buf [] = { reg, data };
 	struct i2c_msg msg = { .addr = state->config->demod_address, .flags = 0, .buf = buf, .len = 2 };
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	ret = i2c_transfer (state->i2c, &msg, 1);
 
 	if (ret != 1)
 		printk("%s: writereg error (reg == 0x%02x, val == 0x%02x, ret == %i)\n",
-			__FUNCTION__, reg, data, ret);
+			__func__, reg, data, ret);
 
 	return (ret != 1) ? -1 : 0;
 }
@@ -92,7 +92,7 @@ static int cx22700_readreg (struct cx227
 	struct i2c_msg msg [] = { { .addr = state->config->demod_address, .flags = 0, .buf = b0, .len = 1 },
 			   { .addr = state->config->demod_address, .flags = I2C_M_RD, .buf = b1, .len = 1 } };
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	ret = i2c_transfer (state->i2c, msg, 2);
 
@@ -105,7 +105,7 @@ static int cx22700_set_inversion (struct
 {
 	u8 val;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	switch (inversion) {
 	case INVERSION_AUTO:
@@ -127,7 +127,7 @@ static int cx22700_set_tps (struct cx227
 	static const u8 fec_tab [6] = { 0, 1, 2, 0, 3, 4 };
 	u8 val;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	if (p->code_rate_HP < FEC_1_2 || p->code_rate_HP > FEC_7_8)
 		return -EINVAL;
@@ -191,7 +191,7 @@ static int cx22700_get_tps (struct cx227
 						    FEC_5_6, FEC_7_8 };
 	u8 val;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	if (!(cx22700_readreg(state, 0x07) & 0x20))  /*  tps valid? */
 		return -EAGAIN;
diff -puN drivers/media/dvb/frontends/cx22700.h~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/cx22700.h
--- a/drivers/media/dvb/frontends/cx22700.h~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/cx22700.h
@@ -38,7 +38,7 @@ extern struct dvb_frontend* cx22700_atta
 static inline struct dvb_frontend* cx22700_attach(const struct cx22700_config* config,
 					   struct i2c_adapter* i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_CX22700
diff -puN drivers/media/dvb/frontends/cx22702.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/cx22702.c
--- a/drivers/media/dvb/frontends/cx22702.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/cx22702.c
@@ -90,7 +90,7 @@ static int cx22702_writereg (struct cx22
 
 	if (ret != 1)
 		printk("%s: writereg error (reg == 0x%02x, val == 0x%02x, ret == %i)\n",
-			__FUNCTION__, reg, data, ret);
+			__func__, reg, data, ret);
 
 	return (ret != 1) ? -1 : 0;
 }
@@ -108,7 +108,7 @@ static u8 cx22702_readreg (struct cx2270
 	ret = i2c_transfer(state->i2c, msg, 2);
 
 	if (ret != 2)
-		printk("%s: readreg error (ret == %i)\n", __FUNCTION__, ret);
+		printk("%s: readreg error (ret == %i)\n", __func__, ret);
 
 	return b1[0];
 }
@@ -195,7 +195,7 @@ static int cx22702_get_tps (struct cx227
 static int cx22702_i2c_gate_ctrl(struct dvb_frontend* fe, int enable)
 {
 	struct cx22702_state* state = fe->demodulator_priv;
-	dprintk ("%s(%d)\n", __FUNCTION__, enable);
+	dprintk ("%s(%d)\n", __func__, enable);
 	if (enable)
 		return cx22702_writereg (state, 0x0D, cx22702_readreg(state, 0x0D) & 0xfe);
 	else
@@ -228,7 +228,7 @@ static int cx22702_set_tps (struct dvb_f
 		cx22702_writereg(state, 0x0C, cx22702_readreg(state, 0x0C) &0xcf );
 		break;
 	default:
-		dprintk ("%s: invalid bandwidth\n",__FUNCTION__);
+		dprintk ("%s: invalid bandwidth\n",__func__);
 		return -EINVAL;
 	}
 
@@ -250,7 +250,7 @@ static int cx22702_set_tps (struct dvb_f
 		cx22702_writereg(state, 0x0B, cx22702_readreg(state, 0x0B) & 0xfc );
 		cx22702_writereg(state, 0x0C, (cx22702_readreg(state, 0x0C) & 0xBF) | 0x40 );
 		cx22702_writereg(state, 0x00, 0x01); /* Begin aquisition */
-		dprintk("%s: Autodetecting\n",__FUNCTION__);
+		dprintk("%s: Autodetecting\n",__func__);
 		return 0;
 	}
 
@@ -261,7 +261,7 @@ static int cx22702_set_tps (struct dvb_f
 		case QAM_16: val = (val&0xe7)|0x08; break;
 		case QAM_64: val = (val&0xe7)|0x10; break;
 		default:
-			dprintk ("%s: invalid constellation\n",__FUNCTION__);
+			dprintk ("%s: invalid constellation\n",__func__);
 			return -EINVAL;
 	}
 	switch(p->u.ofdm.hierarchy_information) {
@@ -270,7 +270,7 @@ static int cx22702_set_tps (struct dvb_f
 		case    HIERARCHY_2: val = (val&0xf8)|2; break;
 		case    HIERARCHY_4: val = (val&0xf8)|3; break;
 		default:
-			dprintk ("%s: invalid hierarchy\n",__FUNCTION__);
+			dprintk ("%s: invalid hierarchy\n",__func__);
 			return -EINVAL;
 	}
 	cx22702_writereg (state, 0x06, val);
@@ -284,7 +284,7 @@ static int cx22702_set_tps (struct dvb_f
 		case FEC_5_6: val = (val&0xc7)|0x18; break;
 		case FEC_7_8: val = (val&0xc7)|0x20; break;
 		default:
-			dprintk ("%s: invalid code_rate_HP\n",__FUNCTION__);
+			dprintk ("%s: invalid code_rate_HP\n",__func__);
 			return -EINVAL;
 	}
 	switch(p->u.ofdm.code_rate_LP) {
@@ -295,7 +295,7 @@ static int cx22702_set_tps (struct dvb_f
 		case FEC_5_6: val = (val&0xf8)|3; break;
 		case FEC_7_8: val = (val&0xf8)|4; break;
 		default:
-			dprintk ("%s: invalid code_rate_LP\n",__FUNCTION__);
+			dprintk ("%s: invalid code_rate_LP\n",__func__);
 			return -EINVAL;
 	}
 	cx22702_writereg (state, 0x07, val);
@@ -307,14 +307,14 @@ static int cx22702_set_tps (struct dvb_f
 		case  GUARD_INTERVAL_1_8: val = (val&0xf3)|0x08; break;
 		case  GUARD_INTERVAL_1_4: val = (val&0xf3)|0x0c; break;
 		default:
-			dprintk ("%s: invalid guard_interval\n",__FUNCTION__);
+			dprintk ("%s: invalid guard_interval\n",__func__);
 			return -EINVAL;
 	}
 	switch(p->u.ofdm.transmission_mode) {
 		case TRANSMISSION_MODE_2K: val = (val&0xfc); break;
 		case TRANSMISSION_MODE_8K: val = (val&0xfc)|1; break;
 		default:
-			dprintk ("%s: invalid transmission_mode\n",__FUNCTION__);
+			dprintk ("%s: invalid transmission_mode\n",__func__);
 			return -EINVAL;
 	}
 	cx22702_writereg(state, 0x08, val);
@@ -360,7 +360,7 @@ static int cx22702_read_status(struct dv
 	reg23 = cx22702_readreg (state, 0x23);
 
 	dprintk ("%s: status demod=0x%02x agc=0x%02x\n"
-		,__FUNCTION__,reg0A,reg23);
+		,__func__,reg0A,reg23);
 
 	if(reg0A & 0x10) {
 		*status |= FE_HAS_LOCK;
diff -puN drivers/media/dvb/frontends/cx22702.h~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/cx22702.h
--- a/drivers/media/dvb/frontends/cx22702.h~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/cx22702.h
@@ -48,7 +48,7 @@ extern struct dvb_frontend* cx22702_atta
 static inline struct dvb_frontend* cx22702_attach(const struct cx22702_config* config,
 					   struct i2c_adapter* i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_CX22702
diff -puN drivers/media/dvb/frontends/cx24110.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/cx24110.c
--- a/drivers/media/dvb/frontends/cx24110.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/cx24110.c
@@ -121,7 +121,7 @@ static int cx24110_writereg (struct cx24
 
 	if ((err = i2c_transfer(state->i2c, &msg, 1)) != 1) {
 		dprintk ("%s: writereg error (err == %i, reg == 0x%02x,"
-			 " data == 0x%02x)\n", __FUNCTION__, err, reg, data);
+			 " data == 0x%02x)\n", __func__, err, reg, data);
 		return -EREMOTEIO;
 	}
 
@@ -247,7 +247,7 @@ static int cx24110_set_symbolrate (struc
 	static const u32 bands[]={5000000UL,15000000UL,90999000UL/2};
 	int i;
 
-	dprintk("cx24110 debug: entering %s(%d)\n",__FUNCTION__,srate);
+	dprintk("cx24110 debug: entering %s(%d)\n",__func__,srate);
 	if (srate>90999000UL/2)
 		srate=90999000UL/2;
 	if (srate<500000)
@@ -358,7 +358,7 @@ static int cx24110_initfe(struct dvb_fro
 /* fixme (low): error handling */
 	int i;
 
-	dprintk("%s: init chip\n", __FUNCTION__);
+	dprintk("%s: init chip\n", __func__);
 
 	for(i = 0; i < ARRAY_SIZE(cx24110_regdata); i++) {
 		cx24110_writereg(state, cx24110_regdata[i].reg, cx24110_regdata[i].data);
diff -puN drivers/media/dvb/frontends/cx24110.h~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/cx24110.h
--- a/drivers/media/dvb/frontends/cx24110.h~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/cx24110.h
@@ -48,7 +48,7 @@ extern struct dvb_frontend* cx24110_atta
 static inline struct dvb_frontend* cx24110_attach(const struct cx24110_config* config,
 						  struct i2c_adapter* i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_CX24110
diff -puN drivers/media/dvb/frontends/dib3000.h~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/dib3000.h
--- a/drivers/media/dvb/frontends/dib3000.h~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/dib3000.h
@@ -48,7 +48,7 @@ extern struct dvb_frontend* dib3000mb_at
 static inline struct dvb_frontend* dib3000mb_attach(const struct dib3000_config* config,
 					     struct i2c_adapter* i2c, struct dib_fe_xfer_ops *xfer_ops)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_DIB3000MB
diff -puN drivers/media/dvb/frontends/dib3000mc.h~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/dib3000mc.h
--- a/drivers/media/dvb/frontends/dib3000mc.h~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/dib3000mc.h
@@ -44,7 +44,7 @@ extern struct dvb_frontend * dib3000mc_a
 #else
 static inline struct dvb_frontend * dib3000mc_attach(struct i2c_adapter *i2c_adap, u8 i2c_addr, struct dib3000mc_config *cfg)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_DIB3000MC
diff -puN drivers/media/dvb/frontends/dvb-pll.h~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/dvb-pll.h
--- a/drivers/media/dvb/frontends/dvb-pll.h~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/dvb-pll.h
@@ -43,7 +43,7 @@ static inline struct dvb_frontend *dvb_p
 					   struct i2c_adapter *i2c,
 					   unsigned int pll_desc_id)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif
diff -puN drivers/media/dvb/frontends/isl6405.h~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/isl6405.h
--- a/drivers/media/dvb/frontends/isl6405.h~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/isl6405.h
@@ -66,7 +66,7 @@ static inline struct dvb_frontend *isl64
 						  struct i2c_adapter *i2c, u8 i2c_addr,
 						  u8 override_set, u8 override_clear)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif /* CONFIG_DVB_ISL6405 */
diff -puN drivers/media/dvb/frontends/isl6421.h~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/isl6421.h
--- a/drivers/media/dvb/frontends/isl6421.h~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/isl6421.h
@@ -47,7 +47,7 @@ extern struct dvb_frontend *isl6421_atta
 static inline struct dvb_frontend *isl6421_attach(struct dvb_frontend *fe, struct i2c_adapter *i2c, u8 i2c_addr,
 						  u8 override_set, u8 override_clear)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_ISL6421
diff -puN drivers/media/dvb/frontends/l64781.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/l64781.c
--- a/drivers/media/dvb/frontends/l64781.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/l64781.c
@@ -57,7 +57,7 @@ static int l64781_writereg (struct l6478
 
 	if ((ret = i2c_transfer(state->i2c, &msg, 1)) != 1)
 		dprintk ("%s: write_reg error (reg == %02x) = %02x!\n",
-			 __FUNCTION__, reg, ret);
+			 __func__, reg, ret);
 
 	return (ret != 1) ? -1 : 0;
 }
diff -puN drivers/media/dvb/frontends/l64781.h~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/l64781.h
--- a/drivers/media/dvb/frontends/l64781.h~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/l64781.h
@@ -38,7 +38,7 @@ extern struct dvb_frontend* l64781_attac
 static inline struct dvb_frontend* l64781_attach(const struct l64781_config* config,
 					  struct i2c_adapter* i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_L64781
diff -puN drivers/media/dvb/frontends/lgdt330x.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/lgdt330x.c
--- a/drivers/media/dvb/frontends/lgdt330x.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/lgdt330x.c
@@ -88,7 +88,7 @@ static int i2c_write_demod_bytes (struct
 
 	for (i=0; i<len-1; i+=2){
 		if ((err = i2c_transfer(state->i2c, &msg, 1)) != 1) {
-			printk(KERN_WARNING "lgdt330x: %s error (addr %02x <- %02x, err = %i)\n", __FUNCTION__, msg.buf[0], msg.buf[1], err);
+			printk(KERN_WARNING "lgdt330x: %s error (addr %02x <- %02x, err = %i)\n", __func__, msg.buf[0], msg.buf[1], err);
 			if (err < 0)
 				return err;
 			else
@@ -117,7 +117,7 @@ static u8 i2c_read_demod_bytes (struct l
 	int ret;
 	ret = i2c_transfer(state->i2c, msg, 2);
 	if (ret != 2) {
-		printk(KERN_WARNING "lgdt330x: %s: addr 0x%02x select 0x%02x error (ret == %i)\n", __FUNCTION__, state->config->demod_address, reg, ret);
+		printk(KERN_WARNING "lgdt330x: %s: addr 0x%02x select 0x%02x error (ret == %i)\n", __func__, state->config->demod_address, reg, ret);
 	} else {
 		ret = 0;
 	}
@@ -256,7 +256,7 @@ static int lgdt330x_init(struct dvb_fron
 		printk (KERN_WARNING "Only LGDT3302 and LGDT3303 are supported chips.\n");
 		err = -ENODEV;
 	}
-	dprintk("%s entered as %s\n", __FUNCTION__, chip_name);
+	dprintk("%s entered as %s\n", __func__, chip_name);
 	if (err < 0)
 		return err;
 	return lgdt330x_SwReset(state);
@@ -334,7 +334,7 @@ static int lgdt330x_set_parameters(struc
 	if (state->current_modulation != param->u.vsb.modulation) {
 		switch(param->u.vsb.modulation) {
 		case VSB_8:
-			dprintk("%s: VSB_8 MODE\n", __FUNCTION__);
+			dprintk("%s: VSB_8 MODE\n", __func__);
 
 			/* Select VSB mode */
 			top_ctrl_cfg[1] = 0x03;
@@ -350,7 +350,7 @@ static int lgdt330x_set_parameters(struc
 			break;
 
 		case QAM_64:
-			dprintk("%s: QAM_64 MODE\n", __FUNCTION__);
+			dprintk("%s: QAM_64 MODE\n", __func__);
 
 			/* Select QAM_64 mode */
 			top_ctrl_cfg[1] = 0x00;
@@ -366,7 +366,7 @@ static int lgdt330x_set_parameters(struc
 			break;
 
 		case QAM_256:
-			dprintk("%s: QAM_256 MODE\n", __FUNCTION__);
+			dprintk("%s: QAM_256 MODE\n", __func__);
 
 			/* Select QAM_256 mode */
 			top_ctrl_cfg[1] = 0x01;
@@ -381,7 +381,7 @@ static int lgdt330x_set_parameters(struc
 			}
 			break;
 		default:
-			printk(KERN_WARNING "lgdt330x: %s: Modulation type(%d) UNSUPPORTED\n", __FUNCTION__, param->u.vsb.modulation);
+			printk(KERN_WARNING "lgdt330x: %s: Modulation type(%d) UNSUPPORTED\n", __func__, param->u.vsb.modulation);
 			return -1;
 		}
 		/*
@@ -431,7 +431,7 @@ static int lgdt3302_read_status(struct d
 
 	/* AGC status register */
 	i2c_read_demod_bytes(state, AGC_STATUS, buf, 1);
-	dprintk("%s: AGC_STATUS = 0x%02x\n", __FUNCTION__, buf[0]);
+	dprintk("%s: AGC_STATUS = 0x%02x\n", __func__, buf[0]);
 	if ((buf[0] & 0x0c) == 0x8){
 		/* Test signal does not exist flag */
 		/* as well as the AGC lock flag.   */
@@ -445,7 +445,7 @@ static int lgdt3302_read_status(struct d
 	 */
 	/* signal status */
 	i2c_read_demod_bytes(state, TOP_CONTROL, buf, sizeof(buf));
-	dprintk("%s: TOP_CONTROL = 0x%02x, IRO_MASK = 0x%02x, IRQ_STATUS = 0x%02x\n", __FUNCTION__, buf[0], buf[1], buf[2]);
+	dprintk("%s: TOP_CONTROL = 0x%02x, IRO_MASK = 0x%02x, IRQ_STATUS = 0x%02x\n", __func__, buf[0], buf[1], buf[2]);
 
 
 	/* sync status */
@@ -461,7 +461,7 @@ static int lgdt3302_read_status(struct d
 
 	/* Carrier Recovery Lock Status Register */
 	i2c_read_demod_bytes(state, CARRIER_LOCK, buf, 1);
-	dprintk("%s: CARRIER_LOCK = 0x%02x\n", __FUNCTION__, buf[0]);
+	dprintk("%s: CARRIER_LOCK = 0x%02x\n", __func__, buf[0]);
 	switch (state->current_modulation) {
 	case QAM_256:
 	case QAM_64:
@@ -474,7 +474,7 @@ static int lgdt3302_read_status(struct d
 			*status |= FE_HAS_CARRIER;
 		break;
 	default:
-		printk(KERN_WARNING "lgdt330x: %s: Modulation set to unsupported value\n", __FUNCTION__);
+		printk(KERN_WARNING "lgdt330x: %s: Modulation set to unsupported value\n", __func__);
 	}
 
 	return 0;
@@ -493,7 +493,7 @@ static int lgdt3303_read_status(struct d
 	if (err < 0)
 		return err;
 
-	dprintk("%s: AGC_STATUS = 0x%02x\n", __FUNCTION__, buf[0]);
+	dprintk("%s: AGC_STATUS = 0x%02x\n", __func__, buf[0]);
 	if ((buf[0] & 0x21) == 0x01){
 		/* Test input signal does not exist flag */
 		/* as well as the AGC lock flag.   */
@@ -502,7 +502,7 @@ static int lgdt3303_read_status(struct d
 
 	/* Carrier Recovery Lock Status Register */
 	i2c_read_demod_bytes(state, CARRIER_LOCK, buf, 1);
-	dprintk("%s: CARRIER_LOCK = 0x%02x\n", __FUNCTION__, buf[0]);
+	dprintk("%s: CARRIER_LOCK = 0x%02x\n", __func__, buf[0]);
 	switch (state->current_modulation) {
 	case QAM_256:
 	case QAM_64:
@@ -533,7 +533,7 @@ static int lgdt3303_read_status(struct d
 		}
 		break;
 	default:
-		printk(KERN_WARNING "lgdt330x: %s: Modulation set to unsupported value\n", __FUNCTION__);
+		printk(KERN_WARNING "lgdt330x: %s: Modulation set to unsupported value\n", __func__);
 	}
 	return 0;
 }
@@ -607,14 +607,14 @@ static int lgdt3302_read_snr(struct dvb_
 		break;
 	default:
 		printk(KERN_ERR "lgdt330x: %s: Modulation set to unsupported value\n",
-		       __FUNCTION__);
+		       __func__);
 		return -EREMOTEIO; /* return -EDRIVER_IS_GIBBERED; */
 	}
 
 	state->snr = calculate_snr(noise, c);
 	*snr = (state->snr) >> 16; /* Convert from 8.24 fixed-point to 8.8 */
 
-	dprintk("%s: noise = 0x%08x, snr = %d.%02d dB\n", __FUNCTION__, noise,
+	dprintk("%s: noise = 0x%08x, snr = %d.%02d dB\n", __func__, noise,
 		state->snr >> 24, (((state->snr>>8) & 0xffff) * 100) >> 16);
 
 	return 0;
@@ -651,14 +651,14 @@ static int lgdt3303_read_snr(struct dvb_
 		break;
 	default:
 		printk(KERN_ERR "lgdt330x: %s: Modulation set to unsupported value\n",
-		       __FUNCTION__);
+		       __func__);
 		return -EREMOTEIO; /* return -EDRIVER_IS_GIBBERED; */
 	}
 
 	state->snr = calculate_snr(noise, c);
 	*snr = (state->snr) >> 16; /* Convert from 8.24 fixed-point to 8.8 */
 
-	dprintk("%s: noise = 0x%08x, snr = %d.%02d dB\n", __FUNCTION__, noise,
+	dprintk("%s: noise = 0x%08x, snr = %d.%02d dB\n", __func__, noise,
 		state->snr >> 24, (((state->snr >> 8) & 0xffff) * 100) >> 16);
 
 	return 0;
@@ -743,7 +743,7 @@ struct dvb_frontend* lgdt330x_attach(con
 
 error:
 	kfree(state);
-	dprintk("%s: ERROR\n",__FUNCTION__);
+	dprintk("%s: ERROR\n",__func__);
 	return NULL;
 }
 
diff -puN drivers/media/dvb/frontends/lgdt330x.h~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/lgdt330x.h
--- a/drivers/media/dvb/frontends/lgdt330x.h~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/lgdt330x.h
@@ -59,7 +59,7 @@ extern struct dvb_frontend* lgdt330x_att
 static inline struct dvb_frontend* lgdt330x_attach(const struct lgdt330x_config* config,
 					    struct i2c_adapter* i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_LGDT330X
diff -puN drivers/media/dvb/frontends/lnbp21.h~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/lnbp21.h
--- a/drivers/media/dvb/frontends/lnbp21.h~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/lnbp21.h
@@ -45,7 +45,7 @@ extern struct dvb_frontend *lnbp21_attac
 #else
 static inline struct dvb_frontend *lnbp21_attach(struct dvb_frontend *fe, struct i2c_adapter *i2c, u8 override_set, u8 override_clear)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_LNBP21
diff -puN drivers/media/dvb/frontends/mt2060.h~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/mt2060.h
--- a/drivers/media/dvb/frontends/mt2060.h~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/mt2060.h
@@ -35,7 +35,7 @@ extern struct dvb_frontend * mt2060_atta
 #else
 static inline struct dvb_frontend * mt2060_attach(struct dvb_frontend *fe, struct i2c_adapter *i2c, struct mt2060_config *cfg, u16 if1)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_TUNER_MT2060
diff -puN drivers/media/dvb/frontends/mt2131.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/mt2131.c
--- a/drivers/media/dvb/frontends/mt2131.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/mt2131.c
@@ -110,7 +110,7 @@ static int mt2131_set_params(struct dvb_
 		priv->bandwidth = 0;
 
 	freq = params->frequency / 1000;  // Hz -> kHz
-	dprintk(1, "%s() freq=%d\n", __FUNCTION__, freq);
+	dprintk(1, "%s() freq=%d\n", __func__, freq);
 
 	f_lo1 = freq + MT2131_IF1 * 1000;
 	f_lo1 = (f_lo1 / 250) * 250;
@@ -187,7 +187,7 @@ static int mt2131_set_params(struct dvb_
 static int mt2131_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
 	struct mt2131_priv *priv = fe->tuner_priv;
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 	*frequency = priv->frequency;
 	return 0;
 }
@@ -195,7 +195,7 @@ static int mt2131_get_frequency(struct d
 static int mt2131_get_bandwidth(struct dvb_frontend *fe, u32 *bandwidth)
 {
 	struct mt2131_priv *priv = fe->tuner_priv;
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 	*bandwidth = priv->bandwidth;
 	return 0;
 }
@@ -214,7 +214,7 @@ static int mt2131_get_status(struct dvb_
 
 	mt2131_readreg(priv, 0x09, &afc_status);
 	dprintk(1, "%s() - LO Status = 0x%x, AFC Status = 0x%x\n",
-		__FUNCTION__, lock_status, afc_status);
+		__func__, lock_status, afc_status);
 
 	return 0;
 }
@@ -223,7 +223,7 @@ static int mt2131_init(struct dvb_fronte
 {
 	struct mt2131_priv *priv = fe->tuner_priv;
 	int ret;
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 
 	if ((ret = mt2131_writeregs(priv, mt2131_config1,
 				    sizeof(mt2131_config1))) < 0)
@@ -243,7 +243,7 @@ static int mt2131_init(struct dvb_fronte
 
 static int mt2131_release(struct dvb_frontend *fe)
 {
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 	kfree(fe->tuner_priv);
 	fe->tuner_priv = NULL;
 	return 0;
@@ -273,7 +273,7 @@ struct dvb_frontend * mt2131_attach(stru
 	struct mt2131_priv *priv = NULL;
 	u8 id = 0;
 
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 
 	priv = kzalloc(sizeof(struct mt2131_priv), GFP_KERNEL);
 	if (priv == NULL)
diff -puN drivers/media/dvb/frontends/mt2131.h~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/mt2131.h
--- a/drivers/media/dvb/frontends/mt2131.h~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/mt2131.h
@@ -41,7 +41,7 @@ static inline struct dvb_frontend* mt213
 						 struct mt2131_config *cfg,
 						 u16 if1)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif /* CONFIG_DVB_TUNER_MT2131 */
diff -puN drivers/media/dvb/frontends/mt2266.h~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/mt2266.h
--- a/drivers/media/dvb/frontends/mt2266.h~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/mt2266.h
@@ -29,7 +29,7 @@ extern struct dvb_frontend * mt2266_atta
 #else
 static inline struct dvb_frontend * mt2266_attach(struct dvb_frontend *fe, struct i2c_adapter *i2c, struct mt2266_config *cfg)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_TUNER_MT2266
diff -puN drivers/media/dvb/frontends/mt312.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/mt312.c
--- a/drivers/media/dvb/frontends/mt312.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/mt312.c
@@ -76,7 +76,7 @@ static int mt312_read(struct mt312_state
 	ret = i2c_transfer(state->i2c, msg, 2);
 
 	if (ret != 2) {
-		printk(KERN_ERR "%s: ret == %d\n", __FUNCTION__, ret);
+		printk(KERN_ERR "%s: ret == %d\n", __func__, ret);
 		return -EREMOTEIO;
 	}
 
@@ -117,7 +117,7 @@ static int mt312_write(struct mt312_stat
 	ret = i2c_transfer(state->i2c, &msg, 1);
 
 	if (ret != 1) {
-		dprintk("%s: ret == %d\n", __FUNCTION__, ret);
+		dprintk("%s: ret == %d\n", __func__, ret);
 		return -EREMOTEIO;
 	}
 
@@ -499,7 +499,7 @@ static int mt312_set_frontend(struct dvb
 	    { 0x00, 0x01, 0x02, 0x04, 0x3f, 0x08, 0x10, 0x20, 0x3f, 0x3f };
 	const u8 inv_tab[3] = { 0x00, 0x40, 0x80 };
 
-	dprintk("%s: Freq %d\n", __FUNCTION__, p->frequency);
+	dprintk("%s: Freq %d\n", __func__, p->frequency);
 
 	if ((p->frequency < fe->ops.info.frequency_min)
 	    || (p->frequency > fe->ops.info.frequency_max))
diff -puN drivers/media/dvb/frontends/mt312.h~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/mt312.h
--- a/drivers/media/dvb/frontends/mt312.h~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/mt312.h
@@ -40,7 +40,7 @@ struct dvb_frontend *vp310_mt312_attach(
 static inline struct dvb_frontend *vp310_mt312_attach(
 	const struct mt312_config *config, struct i2c_adapter *i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif /* CONFIG_DVB_MT312 */
diff -puN drivers/media/dvb/frontends/mt352.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/mt352.c
--- a/drivers/media/dvb/frontends/mt352.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/mt352.c
@@ -95,7 +95,7 @@ static int mt352_read_register(struct mt
 
 	if (ret != 2) {
 		printk("%s: readreg error (reg=%d, ret==%i)\n",
-		       __FUNCTION__, reg, ret);
+		       __func__, reg, ret);
 		return ret;
 	}
 
@@ -135,7 +135,7 @@ static void mt352_calc_nominal_rate(stru
 	value = 64 * bw * (1<<16) / (7 * 8);
 	value = value * 1000 / adc_clock;
 	dprintk("%s: bw %d, adc_clock %d => 0x%x\n",
-		__FUNCTION__, bw, adc_clock, value);
+		__func__, bw, adc_clock, value);
 	buf[0] = msb(value);
 	buf[1] = lsb(value);
 }
@@ -161,7 +161,7 @@ static void mt352_calc_input_freq(struct
 	}
 	value = -16374 * ife / adc_clock;
 	dprintk("%s: if2 %d, ife %d, adc_clock %d => %d / 0x%x\n",
-		__FUNCTION__, if2, ife, adc_clock, value, value & 0x3fff);
+		__func__, if2, ife, adc_clock, value, value & 0x3fff);
 	buf[0] = msb(value);
 	buf[1] = lsb(value);
 }
@@ -521,7 +521,7 @@ static int mt352_init(struct dvb_fronten
 
 	static u8 mt352_reset_attach [] = { RESET, 0xC0 };
 
-	dprintk("%s: hello\n",__FUNCTION__);
+	dprintk("%s: hello\n",__func__);
 
 	if ((mt352_read_register(state, CLOCK_CTL) & 0x10) == 0 ||
 	    (mt352_read_register(state, CONFIG) & 0x20) == 0) {
diff -puN drivers/media/dvb/frontends/mt352.h~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/mt352.h
--- a/drivers/media/dvb/frontends/mt352.h~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/mt352.h
@@ -58,7 +58,7 @@ extern struct dvb_frontend* mt352_attach
 static inline struct dvb_frontend* mt352_attach(const struct mt352_config* config,
 					 struct i2c_adapter* i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_MT352
diff -puN drivers/media/dvb/frontends/nxt200x.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/nxt200x.c
--- a/drivers/media/dvb/frontends/nxt200x.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/nxt200x.c
@@ -74,7 +74,7 @@ static int i2c_writebytes (struct nxt200
 
 	if ((err = i2c_transfer (state->i2c, &msg, 1)) != 1) {
 		printk (KERN_WARNING "nxt200x: %s: i2c write error (addr 0x%02x, err == %i)\n",
-			__FUNCTION__, addr, err);
+			__func__, addr, err);
 		return -EREMOTEIO;
 	}
 	return 0;
@@ -87,7 +87,7 @@ static u8 i2c_readbytes (struct nxt200x_
 
 	if ((err = i2c_transfer (state->i2c, &msg, 1)) != 1) {
 		printk (KERN_WARNING "nxt200x: %s: i2c read error (addr 0x%02x, err == %i)\n",
-			__FUNCTION__, addr, err);
+			__func__, addr, err);
 		return -EREMOTEIO;
 	}
 	return 0;
@@ -104,7 +104,7 @@ static int nxt200x_writebytes (struct nx
 
 	if ((err = i2c_transfer (state->i2c, &msg, 1)) != 1) {
 		printk (KERN_WARNING "nxt200x: %s: i2c write error (addr 0x%02x, err == %i)\n",
-			__FUNCTION__, state->config->demod_address, err);
+			__func__, state->config->demod_address, err);
 		return -EREMOTEIO;
 	}
 	return 0;
@@ -121,7 +121,7 @@ static u8 nxt200x_readbytes (struct nxt2
 
 	if ((err = i2c_transfer (state->i2c, msg, 2)) != 2) {
 		printk (KERN_WARNING "nxt200x: %s: i2c read error (addr 0x%02x, err == %i)\n",
-			__FUNCTION__, state->config->demod_address, err);
+			__func__, state->config->demod_address, err);
 		return -EREMOTEIO;
 	}
 	return 0;
@@ -146,7 +146,7 @@ static u16 nxt200x_crc(u16 crc, u8 c)
 static int nxt200x_writereg_multibyte (struct nxt200x_state* state, u8 reg, u8* data, u8 len)
 {
 	u8 attr, len2, buf;
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	/* set mutli register register */
 	nxt200x_writebytes(state, 0x35, &reg, 1);
@@ -207,7 +207,7 @@ static int nxt200x_readreg_multibyte (st
 {
 	int i;
 	u8 buf, len2, attr;
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	/* set mutli register register */
 	nxt200x_writebytes(state, 0x35, &reg, 1);
@@ -254,7 +254,7 @@ static int nxt200x_readreg_multibyte (st
 static void nxt200x_microcontroller_stop (struct nxt200x_state* state)
 {
 	u8 buf, stopval, counter = 0;
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	/* set correct stop value */
 	switch (state->demod_chip) {
@@ -287,7 +287,7 @@ static void nxt200x_microcontroller_stop
 static void nxt200x_microcontroller_start (struct nxt200x_state* state)
 {
 	u8 buf;
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	buf = 0x00;
 	nxt200x_writebytes(state, 0x22, &buf, 1);
@@ -297,7 +297,7 @@ static void nxt2004_microcontroller_init
 {
 	u8 buf[9];
 	u8 counter = 0;
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	buf[0] = 0x00;
 	nxt200x_writebytes(state, 0x2b, buf, 1);
@@ -328,7 +328,7 @@ static int nxt200x_writetuner (struct nx
 {
 	u8 buf, count = 0;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	dprintk("Tuner Bytes: %02X %02X %02X %02X\n", data[1], data[2], data[3], data[4]);
 
@@ -387,7 +387,7 @@ static int nxt200x_writetuner (struct nx
 static void nxt200x_agc_reset(struct nxt200x_state* state)
 {
 	u8 buf;
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	switch (state->demod_chip) {
 		case NXT2002:
@@ -416,7 +416,7 @@ static int nxt2002_load_firmware (struct
 	u8 buf[3], written = 0, chunkpos = 0;
 	u16 rambase, position, crc = 0;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 	dprintk("Firmware is %zu bytes\n", fw->size);
 
 	/* Get the RAM base for this nxt2002 */
@@ -483,7 +483,7 @@ static int nxt2004_load_firmware (struct
 	u8 buf[3];
 	u16 rambase, position, crc=0;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 	dprintk("Firmware is %zu bytes\n", fw->size);
 
 	/* set rambase */
diff -puN drivers/media/dvb/frontends/nxt200x.h~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/nxt200x.h
--- a/drivers/media/dvb/frontends/nxt200x.h~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/nxt200x.h
@@ -49,7 +49,7 @@ extern struct dvb_frontend* nxt200x_atta
 static inline struct dvb_frontend* nxt200x_attach(const struct nxt200x_config* config,
 					   struct i2c_adapter* i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_NXT200X
diff -puN drivers/media/dvb/frontends/nxt6000.h~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/nxt6000.h
--- a/drivers/media/dvb/frontends/nxt6000.h~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/nxt6000.h
@@ -40,7 +40,7 @@ extern struct dvb_frontend* nxt6000_atta
 static inline struct dvb_frontend* nxt6000_attach(const struct nxt6000_config* config,
 					   struct i2c_adapter* i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_NXT6000
diff -puN drivers/media/dvb/frontends/or51132.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/or51132.c
--- a/drivers/media/dvb/frontends/or51132.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/or51132.c
@@ -419,7 +419,7 @@ static int or51132_read_status(struct dv
 		*status = 0;
 		return -EREMOTEIO;
 	}
-	dprintk("%s: read_status %04x\n", __FUNCTION__, reg);
+	dprintk("%s: read_status %04x\n", __func__, reg);
 
 	if (reg & 0x0100) /* Receiver Lock */
 		*status = FE_HAS_SIGNAL|FE_HAS_CARRIER|FE_HAS_VITERBI|
@@ -504,14 +504,14 @@ start:
 		if (retry--) goto start;
 		return -EREMOTEIO;
 	}
-	dprintk("%s: modulation %02x, NTSC rej O%s\n", __FUNCTION__,
+	dprintk("%s: modulation %02x, NTSC rej O%s\n", __func__,
 		reg&0xff, reg&0x1000?"n":"ff");
 
 	/* Calculate SNR using noise, c, and NTSC rejection correction */
 	state->snr = calculate_snr(noise, c) - usK;
 	*snr = (state->snr) >> 16;
 
-	dprintk("%s: noise = 0x%08x, snr = %d.%02d dB\n", __FUNCTION__, noise,
+	dprintk("%s: noise = 0x%08x, snr = %d.%02d dB\n", __func__, noise,
 		state->snr >> 24, (((state->snr>>8) & 0xffff) * 100) >> 16);
 
 	return 0;
diff -puN drivers/media/dvb/frontends/or51132.h~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/or51132.h
--- a/drivers/media/dvb/frontends/or51132.h~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/or51132.h
@@ -41,7 +41,7 @@ extern struct dvb_frontend* or51132_atta
 static inline struct dvb_frontend* or51132_attach(const struct or51132_config* config,
 					   struct i2c_adapter* i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_OR51132
diff -puN drivers/media/dvb/frontends/or51211.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/or51211.c
--- a/drivers/media/dvb/frontends/or51211.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/or51211.c
@@ -307,19 +307,19 @@ static int or51211_read_snr(struct dvb_f
 
 	if (i2c_writebytes(state,state->config->demod_address,snd_buf,3)) {
 		printk(KERN_WARNING "%s: error writing snr reg\n",
-		       __FUNCTION__);
+		       __func__);
 		return -1;
 	}
 	if (i2c_readbytes(state,state->config->demod_address,rec_buf,2)) {
 		printk(KERN_WARNING "%s: read_status read error\n",
-		       __FUNCTION__);
+		       __func__);
 		return -1;
 	}
 
 	state->snr = calculate_snr(rec_buf[0], 89599047);
 	*snr = (state->snr) >> 16;
 
-	dprintk("%s: noise = 0x%02x, snr = %d.%02d dB\n", __FUNCTION__, rec_buf[0],
+	dprintk("%s: noise = 0x%02x, snr = %d.%02d dB\n", __func__, rec_buf[0],
 		state->snr >> 24, (((state->snr>>8) & 0xffff) * 100) >> 16);
 
 	return 0;
diff -puN drivers/media/dvb/frontends/or51211.h~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/or51211.h
--- a/drivers/media/dvb/frontends/or51211.h~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/or51211.h
@@ -44,7 +44,7 @@ extern struct dvb_frontend* or51211_atta
 static inline struct dvb_frontend* or51211_attach(const struct or51211_config* config,
 					   struct i2c_adapter* i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_OR51211
diff -puN drivers/media/dvb/frontends/qt1010.h~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/qt1010.h
--- a/drivers/media/dvb/frontends/qt1010.h~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/qt1010.h
@@ -45,7 +45,7 @@ static inline struct dvb_frontend *qt101
 						 struct i2c_adapter *i2c,
 						 struct qt1010_config *cfg)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_TUNER_QT1010
diff -puN drivers/media/dvb/frontends/s5h1409.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/s5h1409.c
--- a/drivers/media/dvb/frontends/s5h1409.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/s5h1409.c
@@ -312,7 +312,7 @@ static int s5h1409_writereg(struct s5h14
 
 	if (ret != 1)
 		printk("%s: writereg error (reg == 0x%02x, val == 0x%04x, "
-		       "ret == %i)\n", __FUNCTION__, reg, data, ret);
+		       "ret == %i)\n", __func__, reg, data, ret);
 
 	return (ret != 1) ? -1 : 0;
 }
@@ -332,7 +332,7 @@ static u16 s5h1409_readreg(struct s5h140
 	ret = i2c_transfer(state->i2c, msg, 2);
 
 	if (ret != 2)
-		printk("%s: readreg error (ret == %i)\n", __FUNCTION__, ret);
+		printk("%s: readreg error (ret == %i)\n", __func__, ret);
 	return (b1[0] << 8) | b1[1];
 }
 
@@ -340,7 +340,7 @@ static int s5h1409_softreset(struct dvb_
 {
 	struct s5h1409_state* state = fe->demodulator_priv;
 
-	dprintk("%s()\n", __FUNCTION__);
+	dprintk("%s()\n", __func__);
 
 	s5h1409_writereg(state, 0xf5, 0);
 	s5h1409_writereg(state, 0xf5, 1);
@@ -356,7 +356,7 @@ static int s5h1409_set_if_freq(struct dv
 {
 	struct s5h1409_state* state = fe->demodulator_priv;
 
-	dprintk("%s(%d KHz)\n", __FUNCTION__, KHz);
+	dprintk("%s(%d KHz)\n", __func__, KHz);
 
 	switch (KHz) {
 	case 4000:
@@ -381,7 +381,7 @@ static int s5h1409_set_spectralinversion
 {
 	struct s5h1409_state* state = fe->demodulator_priv;
 
-	dprintk("%s(%d)\n", __FUNCTION__, inverted);
+	dprintk("%s(%d)\n", __func__, inverted);
 
 	if(inverted == 1)
 		return s5h1409_writereg(state, 0x1b, 0x1101); /* Inverted */
@@ -394,25 +394,25 @@ static int s5h1409_enable_modulation(str
 {
 	struct s5h1409_state* state = fe->demodulator_priv;
 
-	dprintk("%s(0x%08x)\n", __FUNCTION__, m);
+	dprintk("%s(0x%08x)\n", __func__, m);
 
 	switch(m) {
 	case VSB_8:
-		dprintk("%s() VSB_8\n", __FUNCTION__);
+		dprintk("%s() VSB_8\n", __func__);
 		if (state->if_freq != S5H1409_VSB_IF_FREQ)
 			s5h1409_set_if_freq(fe, S5H1409_VSB_IF_FREQ);
 		s5h1409_writereg(state, 0xf4, 0);
 		break;
 	case QAM_64:
 	case QAM_256:
-		dprintk("%s() QAM_AUTO (64/256)\n", __FUNCTION__);
+		dprintk("%s() QAM_AUTO (64/256)\n", __func__);
 		if (state->if_freq != S5H1409_QAM_IF_FREQ)
 			s5h1409_set_if_freq(fe, S5H1409_QAM_IF_FREQ);
 		s5h1409_writereg(state, 0xf4, 1);
 		s5h1409_writereg(state, 0x85, 0x110);
 		break;
 	default:
-		dprintk("%s() Invalid modulation\n", __FUNCTION__);
+		dprintk("%s() Invalid modulation\n", __func__);
 		return -EINVAL;
 	}
 
@@ -426,7 +426,7 @@ static int s5h1409_i2c_gate_ctrl(struct 
 {
 	struct s5h1409_state* state = fe->demodulator_priv;
 
-	dprintk("%s(%d)\n", __FUNCTION__, enable);
+	dprintk("%s(%d)\n", __func__, enable);
 
 	if (enable)
 		return s5h1409_writereg(state, 0xf3, 1);
@@ -438,7 +438,7 @@ static int s5h1409_set_gpio(struct dvb_f
 {
 	struct s5h1409_state* state = fe->demodulator_priv;
 
-	dprintk("%s(%d)\n", __FUNCTION__, enable);
+	dprintk("%s(%d)\n", __func__, enable);
 
 	if (enable)
 		return s5h1409_writereg(state, 0xe3,
@@ -452,7 +452,7 @@ static int s5h1409_sleep(struct dvb_fron
 {
 	struct s5h1409_state* state = fe->demodulator_priv;
 
-	dprintk("%s(%d)\n", __FUNCTION__, enable);
+	dprintk("%s(%d)\n", __func__, enable);
 
 	return s5h1409_writereg(state, 0xf2, enable);
 }
@@ -461,7 +461,7 @@ static int s5h1409_register_reset(struct
 {
 	struct s5h1409_state* state = fe->demodulator_priv;
 
-	dprintk("%s()\n", __FUNCTION__);
+	dprintk("%s()\n", __func__);
 
 	return s5h1409_writereg(state, 0xfa, 0);
 }
@@ -534,7 +534,7 @@ static int s5h1409_set_frontend (struct 
 {
 	struct s5h1409_state* state = fe->demodulator_priv;
 
-	dprintk("%s(frequency=%d)\n", __FUNCTION__, p->frequency);
+	dprintk("%s(frequency=%d)\n", __func__, p->frequency);
 
 	s5h1409_softreset(fe);
 
@@ -565,7 +565,7 @@ static int s5h1409_set_mpeg_timing(struc
 	struct s5h1409_state *state = fe->demodulator_priv;
 	u16 val;
 
-	dprintk("%s(%d)\n", __FUNCTION__, mode);
+	dprintk("%s(%d)\n", __func__, mode);
 
 	val = s5h1409_readreg(state, 0xac) & 0xcfff;
 	switch (mode) {
@@ -573,7 +573,7 @@ static int s5h1409_set_mpeg_timing(struc
 		val |= 0x0000;
 		break;
 	case S5H1409_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK:
-		dprintk("%s(%d) Mode1 or Defaulting\n", __FUNCTION__, mode);
+		dprintk("%s(%d) Mode1 or Defaulting\n", __func__, mode);
 		val |= 0x1000;
 		break;
 	case S5H1409_MPEGTIMING_NONCONTINOUS_INVERTING_CLOCK:
@@ -597,7 +597,7 @@ static int s5h1409_init (struct dvb_fron
 	int i;
 
 	struct s5h1409_state* state = fe->demodulator_priv;
-	dprintk("%s()\n", __FUNCTION__);
+	dprintk("%s()\n", __func__);
 
 	s5h1409_sleep(fe, 0);
 	s5h1409_register_reset(fe);
@@ -663,7 +663,7 @@ static int s5h1409_read_status(struct dv
 		break;
 	}
 
-	dprintk("%s() status 0x%08x\n", __FUNCTION__, *status);
+	dprintk("%s() status 0x%08x\n", __func__, *status);
 
 	return 0;
 }
@@ -671,7 +671,7 @@ static int s5h1409_read_status(struct dv
 static int s5h1409_qam256_lookup_snr(struct dvb_frontend* fe, u16* snr, u16 v)
 {
 	int i, ret = -EINVAL;
-	dprintk("%s()\n", __FUNCTION__);
+	dprintk("%s()\n", __func__);
 
 	for (i=0; i < ARRAY_SIZE(qam256_snr_tab); i++) {
 		if (v < qam256_snr_tab[i].val) {
@@ -686,7 +686,7 @@ static int s5h1409_qam256_lookup_snr(str
 static int s5h1409_qam64_lookup_snr(struct dvb_frontend* fe, u16* snr, u16 v)
 {
 	int i, ret = -EINVAL;
-	dprintk("%s()\n", __FUNCTION__);
+	dprintk("%s()\n", __func__);
 
 	for (i=0; i < ARRAY_SIZE(qam64_snr_tab); i++) {
 		if (v < qam64_snr_tab[i].val) {
@@ -701,7 +701,7 @@ static int s5h1409_qam64_lookup_snr(stru
 static int s5h1409_vsb_lookup_snr(struct dvb_frontend* fe, u16* snr, u16 v)
 {
 	int i, ret = -EINVAL;
-	dprintk("%s()\n", __FUNCTION__);
+	dprintk("%s()\n", __func__);
 
 	for (i=0; i < ARRAY_SIZE(vsb_snr_tab); i++) {
 		if (v > vsb_snr_tab[i].val) {
@@ -710,7 +710,7 @@ static int s5h1409_vsb_lookup_snr(struct
 			break;
 		}
 	}
-	dprintk("%s() snr=%d\n", __FUNCTION__, *snr);
+	dprintk("%s() snr=%d\n", __func__, *snr);
 	return ret;
 }
 
@@ -718,7 +718,7 @@ static int s5h1409_read_snr(struct dvb_f
 {
 	struct s5h1409_state* state = fe->demodulator_priv;
 	u16 reg;
-	dprintk("%s()\n", __FUNCTION__);
+	dprintk("%s()\n", __func__);
 
 	switch(state->current_modulation) {
 	case QAM_64:
@@ -812,7 +812,7 @@ struct dvb_frontend* s5h1409_attach(cons
 
 	if (s5h1409_init(&state->frontend) != 0) {
 		printk(KERN_ERR "%s: Failed to initialize correctly\n",
-			__FUNCTION__);
+			__func__);
 		goto error;
 	}
 
diff -puN drivers/media/dvb/frontends/s5h1409.h~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/s5h1409.h
--- a/drivers/media/dvb/frontends/s5h1409.h~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/s5h1409.h
@@ -67,7 +67,7 @@ extern struct dvb_frontend* s5h1409_atta
 static inline struct dvb_frontend* s5h1409_attach(const struct s5h1409_config* config,
 						  struct i2c_adapter* i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif /* CONFIG_DVB_S5H1409 */
diff -puN drivers/media/dvb/frontends/s5h1420.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/s5h1420.c
--- a/drivers/media/dvb/frontends/s5h1420.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/s5h1420.c
@@ -63,7 +63,7 @@ static int s5h1420_writereg (struct s5h1
 	int err;
 
 	if ((err = i2c_transfer (state->i2c, &msg, 1)) != 1) {
-		dprintk ("%s: writereg error (err == %i, reg == 0x%02x, data == 0x%02x)\n", __FUNCTION__, err, reg, data);
+		dprintk ("%s: writereg error (err == %i, reg == 0x%02x, data == 0x%02x)\n", __func__, err, reg, data);
 		return -EREMOTEIO;
 	}
 
diff -puN drivers/media/dvb/frontends/s5h1420.h~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/s5h1420.h
--- a/drivers/media/dvb/frontends/s5h1420.h~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/s5h1420.h
@@ -41,7 +41,7 @@ extern struct dvb_frontend* s5h1420_atta
 static inline struct dvb_frontend* s5h1420_attach(const struct s5h1420_config* config,
 					   struct i2c_adapter* i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_S5H1420
diff -puN drivers/media/dvb/frontends/sp8870.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/sp8870.c
--- a/drivers/media/dvb/frontends/sp8870.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/sp8870.c
@@ -70,7 +70,7 @@ static int sp8870_writereg (struct sp887
 	int err;
 
 	if ((err = i2c_transfer (state->i2c, &msg, 1)) != 1) {
-		dprintk ("%s: writereg error (err == %i, reg == 0x%02x, data == 0x%02x)\n", __FUNCTION__, err, reg, data);
+		dprintk ("%s: writereg error (err == %i, reg == 0x%02x, data == 0x%02x)\n", __func__, err, reg, data);
 		return -EREMOTEIO;
 	}
 
@@ -88,7 +88,7 @@ static int sp8870_readreg (struct sp8870
 	ret = i2c_transfer (state->i2c, msg, 2);
 
 	if (ret != 2) {
-		dprintk("%s: readreg error (ret == %i)\n", __FUNCTION__, ret);
+		dprintk("%s: readreg error (ret == %i)\n", __func__, ret);
 		return -1;
 	}
 
@@ -104,7 +104,7 @@ static int sp8870_firmware_upload (struc
 	int tx_len;
 	int err = 0;
 
-	dprintk ("%s: ...\n", __FUNCTION__);
+	dprintk ("%s: ...\n", __func__);
 
 	if (fw->size < SP8870_FIRMWARE_SIZE + SP8870_FIRMWARE_OFFSET)
 		return -EINVAL;
@@ -131,14 +131,14 @@ static int sp8870_firmware_upload (struc
 		msg.buf = tx_buf;
 		msg.len = tx_len + 2;
 		if ((err = i2c_transfer (state->i2c, &msg, 1)) != 1) {
-			printk("%s: firmware upload failed!\n", __FUNCTION__);
-			printk ("%s: i2c error (err == %i)\n", __FUNCTION__, err);
+			printk("%s: firmware upload failed!\n", __func__);
+			printk ("%s: i2c error (err == %i)\n", __func__, err);
 			return err;
 		}
 		fw_pos += tx_len;
 	}
 
-	dprintk ("%s: done!\n", __FUNCTION__);
+	dprintk ("%s: done!\n", __func__);
 	return 0;
 };
 
@@ -310,7 +310,7 @@ static int sp8870_init (struct dvb_front
 	if (state->initialised) return 0;
 	state->initialised = 1;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 
 	/* request the firmware, this will block until someone uploads it */
@@ -475,7 +475,7 @@ static int sp8870_set_frontend (struct d
 	int trials = 0;
 	int check_count = 0;
 
-	dprintk("%s: frequency = %i\n", __FUNCTION__, p->frequency);
+	dprintk("%s: frequency = %i\n", __func__, p->frequency);
 
 	for (trials = 1; trials <= MAXTRIALS; trials++) {
 
@@ -487,7 +487,7 @@ static int sp8870_set_frontend (struct d
 			valid = sp8870_read_data_valid_signal(state);
 			if (valid) {
 				dprintk("%s: delay = %i usec\n",
-					__FUNCTION__, check_count * 10);
+					__func__, check_count * 10);
 				break;
 			}
 			udelay(10);
@@ -497,20 +497,20 @@ static int sp8870_set_frontend (struct d
 	}
 
 	if (!valid) {
-		printk("%s: firmware crash!!!!!!\n", __FUNCTION__);
+		printk("%s: firmware crash!!!!!!\n", __func__);
 		return -EIO;
 	}
 
 	if (debug) {
 		if (valid) {
 			if (trials > 1) {
-				printk("%s: firmware lockup!!!\n", __FUNCTION__);
-				printk("%s: recovered after %i trial(s))\n",  __FUNCTION__, trials - 1);
+				printk("%s: firmware lockup!!!\n", __func__);
+				printk("%s: recovered after %i trial(s))\n",  __func__, trials - 1);
 				lockups++;
 			}
 		}
 		switches++;
-		printk("%s: switches = %i lockups = %i\n", __FUNCTION__, switches, lockups);
+		printk("%s: switches = %i lockups = %i\n", __func__, switches, lockups);
 	}
 
 	return 0;
diff -puN drivers/media/dvb/frontends/sp8870.h~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/sp8870.h
--- a/drivers/media/dvb/frontends/sp8870.h~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/sp8870.h
@@ -42,7 +42,7 @@ extern struct dvb_frontend* sp8870_attac
 static inline struct dvb_frontend* sp8870_attach(const struct sp8870_config* config,
 					  struct i2c_adapter* i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_SP8870
diff -puN drivers/media/dvb/frontends/sp887x.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/sp887x.c
--- a/drivers/media/dvb/frontends/sp887x.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/sp887x.c
@@ -43,7 +43,7 @@ static int i2c_writebytes (struct sp887x
 
 	if ((err = i2c_transfer (state->i2c, &msg, 1)) != 1) {
 		printk ("%s: i2c write error (addr %02x, err == %i)\n",
-			__FUNCTION__, state->config->demod_address, err);
+			__func__, state->config->demod_address, err);
 		return -EREMOTEIO;
 	}
 
@@ -65,7 +65,7 @@ static int sp887x_writereg (struct sp887
 		{
 			printk("%s: writereg error "
 			       "(reg %03x, data %03x, ret == %i)\n",
-			       __FUNCTION__, reg & 0xffff, data & 0xffff, ret);
+			       __func__, reg & 0xffff, data & 0xffff, ret);
 			return ret;
 		}
 	}
@@ -82,7 +82,7 @@ static int sp887x_readreg (struct sp887x
 			 { .addr = state->config->demod_address, .flags = I2C_M_RD, .buf = b1, .len = 2 }};
 
 	if ((ret = i2c_transfer(state->i2c, msg, 2)) != 2) {
-		printk("%s: readreg error (ret == %i)\n", __FUNCTION__, ret);
+		printk("%s: readreg error (ret == %i)\n", __func__, ret);
 		return -1;
 	}
 
@@ -91,7 +91,7 @@ static int sp887x_readreg (struct sp887x
 
 static void sp887x_microcontroller_stop (struct sp887x_state* state)
 {
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 	sp887x_writereg(state, 0xf08, 0x000);
 	sp887x_writereg(state, 0xf09, 0x000);
 
@@ -101,7 +101,7 @@ static void sp887x_microcontroller_stop 
 
 static void sp887x_microcontroller_start (struct sp887x_state* state)
 {
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 	sp887x_writereg(state, 0xf08, 0x000);
 	sp887x_writereg(state, 0xf09, 0x000);
 
@@ -112,7 +112,7 @@ static void sp887x_microcontroller_start
 static void sp887x_setup_agc (struct sp887x_state* state)
 {
 	/* setup AGC parameters */
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 	sp887x_writereg(state, 0x33c, 0x054);
 	sp887x_writereg(state, 0x33b, 0x04c);
 	sp887x_writereg(state, 0x328, 0x000);
@@ -142,7 +142,7 @@ static int sp887x_initial_setup (struct 
 	int fw_size = fw->size;
 	unsigned char *mem = fw->data;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	/* ignore the first 10 bytes, then we expect 0x4000 bytes of firmware */
 	if (fw_size < FW_SIZE+10)
@@ -155,7 +155,7 @@ static int sp887x_initial_setup (struct 
 
 	sp887x_microcontroller_stop (state);
 
-	printk ("%s: firmware upload... ", __FUNCTION__);
+	printk ("%s: firmware upload... ", __func__);
 
 	/* setup write pointer to -1 (end of memory) */
 	/* bit 0x8000 in address is set to enable 13bit mode */
@@ -181,7 +181,7 @@ static int sp887x_initial_setup (struct 
 
 		if ((err = i2c_writebytes (state, buf, c+2)) < 0) {
 			printk ("failed.\n");
-			printk ("%s: i2c error (err == %i)\n", __FUNCTION__, err);
+			printk ("%s: i2c error (err == %i)\n", __func__, err);
 			return err;
 		}
 	}
diff -puN drivers/media/dvb/frontends/sp887x.h~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/sp887x.h
--- a/drivers/media/dvb/frontends/sp887x.h~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/sp887x.h
@@ -24,7 +24,7 @@ extern struct dvb_frontend* sp887x_attac
 static inline struct dvb_frontend* sp887x_attach(const struct sp887x_config* config,
 					  struct i2c_adapter* i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_SP887X
diff -puN drivers/media/dvb/frontends/stv0297.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/stv0297.c
--- a/drivers/media/dvb/frontends/stv0297.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/stv0297.c
@@ -58,7 +58,7 @@ static int stv0297_writereg(struct stv02
 
 	if (ret != 1)
 		dprintk("%s: writereg error (reg == 0x%02x, val == 0x%02x, "
-			"ret == %i)\n", __FUNCTION__, reg, data, ret);
+			"ret == %i)\n", __func__, reg, data, ret);
 
 	return (ret != 1) ? -1 : 0;
 }
@@ -75,16 +75,16 @@ static int stv0297_readreg(struct stv029
 	// this device needs a STOP between the register and data
 	if (state->config->stop_during_read) {
 		if ((ret = i2c_transfer(state->i2c, &msg[0], 1)) != 1) {
-			dprintk("%s: readreg error (reg == 0x%02x, ret == %i)\n", __FUNCTION__, reg, ret);
+			dprintk("%s: readreg error (reg == 0x%02x, ret == %i)\n", __func__, reg, ret);
 			return -1;
 		}
 		if ((ret = i2c_transfer(state->i2c, &msg[1], 1)) != 1) {
-			dprintk("%s: readreg error (reg == 0x%02x, ret == %i)\n", __FUNCTION__, reg, ret);
+			dprintk("%s: readreg error (reg == 0x%02x, ret == %i)\n", __func__, reg, ret);
 			return -1;
 		}
 	} else {
 		if ((ret = i2c_transfer(state->i2c, msg, 2)) != 2) {
-			dprintk("%s: readreg error (reg == 0x%02x, ret == %i)\n", __FUNCTION__, reg, ret);
+			dprintk("%s: readreg error (reg == 0x%02x, ret == %i)\n", __func__, reg, ret);
 			return -1;
 		}
 	}
@@ -115,16 +115,16 @@ static int stv0297_readregs(struct stv02
 	// this device needs a STOP between the register and data
 	if (state->config->stop_during_read) {
 		if ((ret = i2c_transfer(state->i2c, &msg[0], 1)) != 1) {
-			dprintk("%s: readreg error (reg == 0x%02x, ret == %i)\n", __FUNCTION__, reg1, ret);
+			dprintk("%s: readreg error (reg == 0x%02x, ret == %i)\n", __func__, reg1, ret);
 			return -1;
 		}
 		if ((ret = i2c_transfer(state->i2c, &msg[1], 1)) != 1) {
-			dprintk("%s: readreg error (reg == 0x%02x, ret == %i)\n", __FUNCTION__, reg1, ret);
+			dprintk("%s: readreg error (reg == 0x%02x, ret == %i)\n", __func__, reg1, ret);
 			return -1;
 		}
 	} else {
 		if ((ret = i2c_transfer(state->i2c, msg, 2)) != 2) {
-			dprintk("%s: readreg error (reg == 0x%02x, ret == %i)\n", __FUNCTION__, reg1, ret);
+			dprintk("%s: readreg error (reg == 0x%02x, ret == %i)\n", __func__, reg1, ret);
 			return -1;
 		}
 	}
diff -puN drivers/media/dvb/frontends/stv0297.h~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/stv0297.h
--- a/drivers/media/dvb/frontends/stv0297.h~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/stv0297.h
@@ -49,7 +49,7 @@ extern struct dvb_frontend* stv0297_atta
 static inline struct dvb_frontend* stv0297_attach(const struct stv0297_config* config,
 					   struct i2c_adapter* i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_STV0297
diff -puN drivers/media/dvb/frontends/stv0299.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/stv0299.c
--- a/drivers/media/dvb/frontends/stv0299.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/stv0299.c
@@ -86,7 +86,7 @@ static int stv0299_writeregI (struct stv
 
 	if (ret != 1)
 		dprintk("%s: writereg error (reg == 0x%02x, val == 0x%02x, "
-			"ret == %i)\n", __FUNCTION__, reg, data, ret);
+			"ret == %i)\n", __func__, reg, data, ret);
 
 	return (ret != 1) ? -EREMOTEIO : 0;
 }
@@ -113,7 +113,7 @@ static u8 stv0299_readreg (struct stv029
 
 	if (ret != 2)
 		dprintk("%s: readreg error (reg == 0x%02x, ret == %i)\n",
-				__FUNCTION__, reg, ret);
+				__func__, reg, ret);
 
 	return b1[0];
 }
@@ -127,14 +127,14 @@ static int stv0299_readregs (struct stv0
 	ret = i2c_transfer (state->i2c, msg, 2);
 
 	if (ret != 2)
-		dprintk("%s: readreg error (ret == %i)\n", __FUNCTION__, ret);
+		dprintk("%s: readreg error (ret == %i)\n", __func__, ret);
 
 	return ret == 2 ? 0 : ret;
 }
 
 static int stv0299_set_FEC (struct stv0299_state* state, fe_code_rate_t fec)
 {
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	switch (fec) {
 	case FEC_AUTO:
@@ -174,7 +174,7 @@ static fe_code_rate_t stv0299_get_fec (s
 					     FEC_7_8, FEC_1_2 };
 	u8 index;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	index = stv0299_readreg (state, 0x1b);
 	index &= 0x7;
@@ -189,11 +189,11 @@ static int stv0299_wait_diseqc_fifo (str
 {
 	unsigned long start = jiffies;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	while (stv0299_readreg(state, 0x0a) & 1) {
 		if (jiffies - start > timeout) {
-			dprintk ("%s: timeout!!\n", __FUNCTION__);
+			dprintk ("%s: timeout!!\n", __func__);
 			return -ETIMEDOUT;
 		}
 		msleep(10);
@@ -206,11 +206,11 @@ static int stv0299_wait_diseqc_idle (str
 {
 	unsigned long start = jiffies;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	while ((stv0299_readreg(state, 0x0a) & 3) != 2 ) {
 		if (jiffies - start > timeout) {
-			dprintk ("%s: timeout!!\n", __FUNCTION__);
+			dprintk ("%s: timeout!!\n", __func__);
 			return -ETIMEDOUT;
 		}
 		msleep(10);
@@ -245,7 +245,7 @@ static int stv0299_get_symbolrate (struc
 	u8 sfr[3];
 	s8 rtf;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	stv0299_readregs (state, 0x1f, sfr, 3);
 	stv0299_readregs (state, 0x1a, (u8 *)&rtf, 1);
@@ -257,8 +257,8 @@ static int stv0299_get_symbolrate (struc
 	offset = (s32) rtf * (srate / 4096L);
 	offset /= 128;
 
-	dprintk ("%s : srate = %i\n", __FUNCTION__, srate);
-	dprintk ("%s : ofset = %i\n", __FUNCTION__, offset);
+	dprintk ("%s : srate = %i\n", __func__, srate);
+	dprintk ("%s : ofset = %i\n", __func__, offset);
 
 	srate += offset;
 
@@ -276,7 +276,7 @@ static int stv0299_send_diseqc_msg (stru
 	u8 val;
 	int i;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	if (stv0299_wait_diseqc_idle (state, 100) < 0)
 		return -ETIMEDOUT;
@@ -305,7 +305,7 @@ static int stv0299_send_diseqc_burst (st
 	struct stv0299_state* state = fe->demodulator_priv;
 	u8 val;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	if (stv0299_wait_diseqc_idle (state, 100) < 0)
 		return -ETIMEDOUT;
@@ -355,7 +355,7 @@ static int stv0299_set_voltage (struct d
 	u8 reg0x08;
 	u8 reg0x0c;
 
-	dprintk("%s: %s\n", __FUNCTION__,
+	dprintk("%s: %s\n", __func__,
 		voltage == SEC_VOLTAGE_13 ? "SEC_VOLTAGE_13" :
 		voltage == SEC_VOLTAGE_18 ? "SEC_VOLTAGE_18" : "??");
 
@@ -408,7 +408,7 @@ static int stv0299_send_legacy_dish_cmd 
 
 	cmd = cmd << 1;
 	if (debug_legacy_dish_switch)
-		printk ("%s switch command: 0x%04lx\n",__FUNCTION__, cmd);
+		printk ("%s switch command: 0x%04lx\n",__func__, cmd);
 
 	do_gettimeofday (&nexttime);
 	if (debug_legacy_dish_switch)
@@ -433,7 +433,7 @@ static int stv0299_send_legacy_dish_cmd 
 	}
 	if (debug_legacy_dish_switch) {
 		printk ("%s(%d): switch delay (should be 32k followed by all 8k\n",
-			__FUNCTION__, fe->dvb->num);
+			__func__, fe->dvb->num);
 		for (i = 1; i < 10; i++)
 			printk ("%d: %d\n", i, timeval_usec_diff(tv[i-1] , tv[i]));
 	}
@@ -461,7 +461,7 @@ static int stv0299_read_status(struct dv
 	u8 signal = 0xff - stv0299_readreg (state, 0x18);
 	u8 sync = stv0299_readreg (state, 0x1b);
 
-	dprintk ("%s : FE_READ_STATUS : VSTATUS: 0x%02x\n", __FUNCTION__, sync);
+	dprintk ("%s : FE_READ_STATUS : VSTATUS: 0x%02x\n", __func__, sync);
 	*status = 0;
 
 	if (signal > 10)
@@ -499,7 +499,7 @@ static int stv0299_read_signal_strength(
 	s32 signal =  0xffff - ((stv0299_readreg (state, 0x18) << 8)
 			       | stv0299_readreg (state, 0x19));
 
-	dprintk ("%s : FE_READ_SIGNAL_STRENGTH : AGC2I: 0x%02x%02x, signal=0x%04x\n", __FUNCTION__,
+	dprintk ("%s : FE_READ_SIGNAL_STRENGTH : AGC2I: 0x%02x%02x, signal=0x%04x\n", __func__,
 		 stv0299_readreg (state, 0x18),
 		 stv0299_readreg (state, 0x19), (int) signal);
 
@@ -536,7 +536,7 @@ static int stv0299_set_frontend(struct d
 	struct stv0299_state* state = fe->demodulator_priv;
 	int invval = 0;
 
-	dprintk ("%s : FE_SET_FRONTEND\n", __FUNCTION__);
+	dprintk ("%s : FE_SET_FRONTEND\n", __func__);
 
 	// set the inversion
 	if (p->inversion == INVERSION_OFF) invval = 0;
diff -puN drivers/media/dvb/frontends/stv0299.h~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/stv0299.h
--- a/drivers/media/dvb/frontends/stv0299.h~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/stv0299.h
@@ -96,7 +96,7 @@ extern struct dvb_frontend* stv0299_atta
 static inline struct dvb_frontend* stv0299_attach(const struct stv0299_config* config,
 					   struct i2c_adapter* i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_STV0299
diff -puN drivers/media/dvb/frontends/tda10021.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/tda10021.c
--- a/drivers/media/dvb/frontends/tda10021.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/tda10021.c
@@ -79,7 +79,7 @@ static int _tda10021_writereg (struct td
 	if (ret != 1)
 		printk("DVB: TDA10021(%d): %s, writereg error "
 			"(reg == 0x%02x, val == 0x%02x, ret == %i)\n",
-			state->frontend.dvb->num, __FUNCTION__, reg, data, ret);
+			state->frontend.dvb->num, __func__, reg, data, ret);
 
 	msleep(10);
 	return (ret != 1) ? -EREMOTEIO : 0;
@@ -97,7 +97,7 @@ static u8 tda10021_readreg (struct tda10
 	// Don't print an error message if the id is read.
 	if (ret != 2 && reg != 0x1a)
 		printk("DVB: TDA10021: %s: readreg error (ret == %i)\n",
-				__FUNCTION__, ret);
+				__func__, ret);
 	return b1[0];
 }
 
diff -puN drivers/media/dvb/frontends/tda10023.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/tda10023.c
--- a/drivers/media/dvb/frontends/tda10023.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/tda10023.c
@@ -118,7 +118,7 @@ static u8 tda10023_readreg (struct tda10
 	ret = i2c_transfer (state->i2c, msg, 2);
 	if (ret != 2)
 		printk("DVB: TDA10023: %s: readreg error (ret == %i)\n",
-				 __FUNCTION__, ret);
+				 __func__, ret);
 	return b1[0];
 }
 
@@ -132,7 +132,7 @@ static int tda10023_writereg (struct tda
 	if (ret != 1)
 		printk("DVB: TDA10023(%d): %s, writereg error "
 			"(reg == 0x%02x, val == 0x%02x, ret == %i)\n",
-			state->frontend.dvb->num, __FUNCTION__, reg, data, ret);
+			state->frontend.dvb->num, __func__, reg, data, ret);
 
 	return (ret != 1) ? -EREMOTEIO : 0;
 }
diff -puN drivers/media/dvb/frontends/tda1002x.h~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/tda1002x.h
--- a/drivers/media/dvb/frontends/tda1002x.h~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/tda1002x.h
@@ -40,7 +40,7 @@ extern struct dvb_frontend* tda10021_att
 static inline struct dvb_frontend* tda10021_attach(const struct tda1002x_config* config,
 					    struct i2c_adapter* i2c, u8 pwm)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_TDA10021
@@ -52,7 +52,7 @@ extern struct dvb_frontend* tda10023_att
 static inline struct dvb_frontend* tda10023_attach(const struct tda1002x_config* config,
 					    struct i2c_adapter* i2c, u8 pwm)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_TDA10023
diff -puN drivers/media/dvb/frontends/tda1004x.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/tda1004x.c
--- a/drivers/media/dvb/frontends/tda1004x.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/tda1004x.c
@@ -131,16 +131,16 @@ static int tda1004x_write_byteI(struct t
 	u8 buf[] = { reg, data };
 	struct i2c_msg msg = { .flags = 0, .buf = buf, .len = 2 };
 
-	dprintk("%s: reg=0x%x, data=0x%x\n", __FUNCTION__, reg, data);
+	dprintk("%s: reg=0x%x, data=0x%x\n", __func__, reg, data);
 
 	msg.addr = state->config->demod_address;
 	ret = i2c_transfer(state->i2c, &msg, 1);
 
 	if (ret != 1)
 		dprintk("%s: error reg=0x%x, data=0x%x, ret=%i\n",
-			__FUNCTION__, reg, data, ret);
+			__func__, reg, data, ret);
 
-	dprintk("%s: success reg=0x%x, data=0x%x, ret=%i\n", __FUNCTION__,
+	dprintk("%s: success reg=0x%x, data=0x%x, ret=%i\n", __func__,
 		reg, data, ret);
 	return (ret != 1) ? -1 : 0;
 }
@@ -153,19 +153,19 @@ static int tda1004x_read_byte(struct tda
 	struct i2c_msg msg[] = {{ .flags = 0, .buf = b0, .len = 1 },
 				{ .flags = I2C_M_RD, .buf = b1, .len = 1 }};
 
-	dprintk("%s: reg=0x%x\n", __FUNCTION__, reg);
+	dprintk("%s: reg=0x%x\n", __func__, reg);
 
 	msg[0].addr = state->config->demod_address;
 	msg[1].addr = state->config->demod_address;
 	ret = i2c_transfer(state->i2c, msg, 2);
 
 	if (ret != 2) {
-		dprintk("%s: error reg=0x%x, ret=%i\n", __FUNCTION__, reg,
+		dprintk("%s: error reg=0x%x, ret=%i\n", __func__, reg,
 			ret);
 		return -1;
 	}
 
-	dprintk("%s: success reg=0x%x, data=0x%x, ret=%i\n", __FUNCTION__,
+	dprintk("%s: success reg=0x%x, data=0x%x, ret=%i\n", __func__,
 		reg, b1[0], ret);
 	return b1[0];
 }
@@ -173,7 +173,7 @@ static int tda1004x_read_byte(struct tda
 static int tda1004x_write_mask(struct tda1004x_state *state, int reg, int mask, int data)
 {
 	int val;
-	dprintk("%s: reg=0x%x, mask=0x%x, data=0x%x\n", __FUNCTION__, reg,
+	dprintk("%s: reg=0x%x, mask=0x%x, data=0x%x\n", __func__, reg,
 		mask, data);
 
 	// read a byte and check
@@ -194,7 +194,7 @@ static int tda1004x_write_buf(struct tda
 	int i;
 	int result;
 
-	dprintk("%s: reg=0x%x, len=0x%x\n", __FUNCTION__, reg, len);
+	dprintk("%s: reg=0x%x, len=0x%x\n", __func__, reg, len);
 
 	result = 0;
 	for (i = 0; i < len; i++) {
@@ -209,7 +209,7 @@ static int tda1004x_write_buf(struct tda
 static int tda1004x_enable_tuner_i2c(struct tda1004x_state *state)
 {
 	int result;
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	result = tda1004x_write_mask(state, TDA1004X_CONFC4, 2, 2);
 	msleep(20);
@@ -218,7 +218,7 @@ static int tda1004x_enable_tuner_i2c(str
 
 static int tda1004x_disable_tuner_i2c(struct tda1004x_state *state)
 {
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	return tda1004x_write_mask(state, TDA1004X_CONFC4, 2, 0);
 }
@@ -345,7 +345,7 @@ static int tda1004x_do_upload(struct tda
 		}
 		pos += tx_size;
 
-		dprintk("%s: fw_pos=0x%x\n", __FUNCTION__, pos);
+		dprintk("%s: fw_pos=0x%x\n", __func__, pos);
 	}
 	// give the DSP a chance to settle 03/10/05 Hac
 	msleep(100);
@@ -444,10 +444,10 @@ static void tda10046_init_plls(struct dv
 		tda1004x_write_byteI(state, TDA10046H_CONFPLL2, 0x03); // PLL M = 3
 	}
 	if (state->config->xtal_freq == TDA10046_XTAL_4M ) {
-		dprintk("%s: setting up PLLs for a 4 MHz Xtal\n", __FUNCTION__);
+		dprintk("%s: setting up PLLs for a 4 MHz Xtal\n", __func__);
 		tda1004x_write_byteI(state, TDA10046H_CONFPLL3, 0); // PLL P = N = 0
 	} else {
-		dprintk("%s: setting up PLLs for a 16 MHz Xtal\n", __FUNCTION__);
+		dprintk("%s: setting up PLLs for a 16 MHz Xtal\n", __func__);
 		tda1004x_write_byteI(state, TDA10046H_CONFPLL3, 3); // PLL P = 0, N = 3
 	}
 	if(tda10046_clk53m)
@@ -488,7 +488,7 @@ static int tda10046_fwupload(struct dvb_
 	if (state->config->xtal_freq == TDA10046_XTAL_4M) {
 		tda1004x_write_byteI(state, TDA1004X_CONFC4, 0);
 	} else {
-		dprintk("%s: 16MHz Xtal, reducing I2C speed\n", __FUNCTION__);
+		dprintk("%s: 16MHz Xtal, reducing I2C speed\n", __func__);
 		tda1004x_write_byteI(state, TDA1004X_CONFC4, 0x80);
 	}
 	tda1004x_write_mask(state, TDA10046H_CONF_TRISTATE1, 1, 0);
@@ -594,7 +594,7 @@ static int tda10045_init(struct dvb_fron
 {
 	struct tda1004x_state* state = fe->demodulator_priv;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	if (tda10045_fwupload(fe)) {
 		printk("tda1004x: firmware upload failed\n");
@@ -624,7 +624,7 @@ static int tda10045_init(struct dvb_fron
 static int tda10046_init(struct dvb_frontend* fe)
 {
 	struct tda1004x_state* state = fe->demodulator_priv;
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	if (tda10046_fwupload(fe)) {
 		printk("tda1004x: firmware upload failed\n");
@@ -686,7 +686,7 @@ static int tda1004x_set_fe(struct dvb_fr
 	int tmp;
 	int inversion;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	if (state->demod_type == TDA1004X_DEMOD_TDA10046) {
 		// setup auto offset
@@ -881,7 +881,7 @@ static int tda1004x_get_fe(struct dvb_fr
 {
 	struct tda1004x_state* state = fe->demodulator_priv;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	// inversion status
 	fe_params->inversion = INVERSION_OFF;
@@ -989,7 +989,7 @@ static int tda1004x_read_status(struct d
 	int cber;
 	int vber;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	// read status
 	status = tda1004x_read_byte(state, TDA1004X_STATUS_CD);
@@ -1048,7 +1048,7 @@ static int tda1004x_read_status(struct d
 	}
 
 	// success
-	dprintk("%s: fe_status=0x%x\n", __FUNCTION__, *fe_status);
+	dprintk("%s: fe_status=0x%x\n", __func__, *fe_status);
 	return 0;
 }
 
@@ -1058,7 +1058,7 @@ static int tda1004x_read_signal_strength
 	int tmp;
 	int reg = 0;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	// determine the register to use
 	switch (state->demod_type) {
@@ -1077,7 +1077,7 @@ static int tda1004x_read_signal_strength
 		return -EIO;
 
 	*signal = (tmp << 8) | tmp;
-	dprintk("%s: signal=0x%x\n", __FUNCTION__, *signal);
+	dprintk("%s: signal=0x%x\n", __func__, *signal);
 	return 0;
 }
 
@@ -1086,7 +1086,7 @@ static int tda1004x_read_snr(struct dvb_
 	struct tda1004x_state* state = fe->demodulator_priv;
 	int tmp;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	// read it
 	tmp = tda1004x_read_byte(state, TDA1004X_SNR);
@@ -1095,7 +1095,7 @@ static int tda1004x_read_snr(struct dvb_
 	tmp = 255 - tmp;
 
 	*snr = ((tmp << 8) | tmp);
-	dprintk("%s: snr=0x%x\n", __FUNCTION__, *snr);
+	dprintk("%s: snr=0x%x\n", __func__, *snr);
 	return 0;
 }
 
@@ -1106,7 +1106,7 @@ static int tda1004x_read_ucblocks(struct
 	int tmp2;
 	int counter;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	// read the UCBLOCKS and reset
 	counter = 0;
@@ -1132,7 +1132,7 @@ static int tda1004x_read_ucblocks(struct
 	else
 		*ucblocks = 0xffffffff;
 
-	dprintk("%s: ucblocks=0x%x\n", __FUNCTION__, *ucblocks);
+	dprintk("%s: ucblocks=0x%x\n", __func__, *ucblocks);
 	return 0;
 }
 
@@ -1141,7 +1141,7 @@ static int tda1004x_read_ber(struct dvb_
 	struct tda1004x_state* state = fe->demodulator_priv;
 	int tmp;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	// read it in
 	tmp = tda1004x_read_byte(state, TDA1004X_CBER_LSB);
@@ -1155,7 +1155,7 @@ static int tda1004x_read_ber(struct dvb_
 	// The address 0x20 should be read to cope with a TDA10046 bug
 	tda1004x_read_byte(state, TDA1004X_CBER_RESET);
 
-	dprintk("%s: ber=0x%x\n", __FUNCTION__, *ber);
+	dprintk("%s: ber=0x%x\n", __func__, *ber);
 	return 0;
 }
 
diff -puN drivers/media/dvb/frontends/tda1004x.h~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/tda1004x.h
--- a/drivers/media/dvb/frontends/tda1004x.h~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/tda1004x.h
@@ -127,13 +127,13 @@ extern struct dvb_frontend* tda10046_att
 static inline struct dvb_frontend* tda10045_attach(const struct tda1004x_config* config,
 					    struct i2c_adapter* i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 static inline struct dvb_frontend* tda10046_attach(const struct tda1004x_config* config,
 					    struct i2c_adapter* i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_TDA1004X
diff -puN drivers/media/dvb/frontends/tda10086.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/tda10086.c
--- a/drivers/media/dvb/frontends/tda10086.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/tda10086.c
@@ -60,7 +60,7 @@ static int tda10086_write_byte(struct td
 
 	if (ret != 1)
 		dprintk("%s: error reg=0x%x, data=0x%x, ret=%i\n",
-			__FUNCTION__, reg, data, ret);
+			__func__, reg, data, ret);
 
 	return (ret != 1) ? ret : 0;
 }
@@ -78,7 +78,7 @@ static int tda10086_read_byte(struct tda
 	ret = i2c_transfer(state->i2c, msg, 2);
 
 	if (ret != 2) {
-		dprintk("%s: error reg=0x%x, ret=%i\n", __FUNCTION__, reg,
+		dprintk("%s: error reg=0x%x, ret=%i\n", __func__, reg,
 			ret);
 		return ret;
 	}
@@ -108,7 +108,7 @@ static int tda10086_init(struct dvb_fron
 	struct tda10086_state* state = fe->demodulator_priv;
 	u8 t22k_off = 0x80;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	if (state->config->diseqc_tone)
 		t22k_off = 0;
@@ -173,7 +173,7 @@ static void tda10086_diseqc_wait(struct 
 	unsigned long timeout = jiffies + msecs_to_jiffies(200);
 	while (!(tda10086_read_byte(state, 0x50) & 0x01)) {
 		if(time_after(jiffies, timeout)) {
-			printk("%s: diseqc queue not ready, command may be lost.\n", __FUNCTION__);
+			printk("%s: diseqc queue not ready, command may be lost.\n", __func__);
 			break;
 		}
 		msleep(10);
@@ -185,7 +185,7 @@ static int tda10086_set_tone (struct dvb
 	struct tda10086_state* state = fe->demodulator_priv;
 	u8 t22k_off = 0x80;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	if (state->config->diseqc_tone)
 		t22k_off = 0;
@@ -211,7 +211,7 @@ static int tda10086_send_master_cmd (str
 	u8 oldval;
 	u8 t22k_off = 0x80;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	if (state->config->diseqc_tone)
 		t22k_off = 0;
@@ -239,7 +239,7 @@ static int tda10086_send_burst (struct d
 	u8 oldval = tda10086_read_byte(state, 0x36);
 	u8 t22k_off = 0x80;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	if (state->config->diseqc_tone)
 		t22k_off = 0;
@@ -266,7 +266,7 @@ static int tda10086_set_inversion(struct
 {
 	u8 invval = 0x80;
 
-	dprintk ("%s %i %i\n", __FUNCTION__, fe_params->inversion, state->config->invert);
+	dprintk ("%s %i %i\n", __func__, fe_params->inversion, state->config->invert);
 
 	switch(fe_params->inversion) {
 	case INVERSION_OFF:
@@ -300,7 +300,7 @@ static int tda10086_set_symbol_rate(stru
 	u32 bdri;
 	u32 symbol_rate = fe_params->u.qpsk.symbol_rate;
 
-	dprintk ("%s %i\n", __FUNCTION__, symbol_rate);
+	dprintk ("%s %i\n", __func__, symbol_rate);
 
 	// setup the decimation and anti-aliasing filters..
 	if (symbol_rate < (u32) (SACLK * 0.0137)) {
@@ -366,7 +366,7 @@ static int tda10086_set_fec(struct tda10
 {
 	u8 fecval;
 
-	dprintk ("%s %i\n", __FUNCTION__, fe_params->u.qpsk.fec_inner);
+	dprintk ("%s %i\n", __func__, fe_params->u.qpsk.fec_inner);
 
 	switch(fe_params->u.qpsk.fec_inner) {
 	case FEC_1_2:
@@ -412,7 +412,7 @@ static int tda10086_set_frontend(struct 
 	u32 freq = 0;
 	int freqoff;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	// modify parameters for tuning
 	tda10086_write_byte(state, 0x02, 0x35);
@@ -459,7 +459,7 @@ static int tda10086_get_frontend(struct 
 	int tmp;
 	u64 tmp64;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	// check for invalid symbol rate
 	if (fe_params->u.qpsk.symbol_rate < 500000)
@@ -550,7 +550,7 @@ static int tda10086_read_status(struct d
 	struct tda10086_state* state = fe->demodulator_priv;
 	u8 val;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	val = tda10086_read_byte(state, 0x0e);
 	*fe_status = 0;
@@ -579,7 +579,7 @@ static int tda10086_read_signal_strength
 	struct tda10086_state* state = fe->demodulator_priv;
 	u8 _str;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	_str = 0xff - tda10086_read_byte(state, 0x43);
 	*signal = (_str << 8) | _str;
@@ -592,7 +592,7 @@ static int tda10086_read_snr(struct dvb_
 	struct tda10086_state* state = fe->demodulator_priv;
 	u8 _snr;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	_snr = 0xff - tda10086_read_byte(state, 0x1c);
 	*snr = (_snr << 8) | _snr;
@@ -604,7 +604,7 @@ static int tda10086_read_ucblocks(struct
 {
 	struct tda10086_state* state = fe->demodulator_priv;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	// read it
 	*ucblocks = tda10086_read_byte(state, 0x18) & 0x7f;
@@ -620,7 +620,7 @@ static int tda10086_read_ber(struct dvb_
 {
 	struct tda10086_state* state = fe->demodulator_priv;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	// read it
 	*ber = 0;
@@ -635,7 +635,7 @@ static int tda10086_sleep(struct dvb_fro
 {
 	struct tda10086_state* state = fe->demodulator_priv;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	tda10086_write_mask(state, 0x00, 0x08, 0x08);
 
@@ -646,7 +646,7 @@ static int tda10086_i2c_gate_ctrl(struct
 {
 	struct tda10086_state* state = fe->demodulator_priv;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	if (enable) {
 		tda10086_write_mask(state, 0x00, 0x10, 0x10);
@@ -737,7 +737,7 @@ struct dvb_frontend* tda10086_attach(con
 {
 	struct tda10086_state *state;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	/* allocate memory for the internal state */
 	state = kmalloc(sizeof(struct tda10086_state), GFP_KERNEL);
diff -puN drivers/media/dvb/frontends/tda10086.h~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/tda10086.h
--- a/drivers/media/dvb/frontends/tda10086.h~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/tda10086.h
@@ -45,7 +45,7 @@ extern struct dvb_frontend* tda10086_att
 static inline struct dvb_frontend* tda10086_attach(const struct tda10086_config* config,
 						   struct i2c_adapter* i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_TDA10086
diff -puN drivers/media/dvb/frontends/tda18271-priv.h~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/tda18271-priv.h
--- a/drivers/media/dvb/frontends/tda18271-priv.h~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/tda18271-priv.h
@@ -139,7 +139,7 @@ extern int tda18271_debug;
 #define DBG_CAL  16
 
 #define tda_printk(kern, fmt, arg...) \
-	printk(kern "%s: " fmt, __FUNCTION__, ##arg)
+	printk(kern "%s: " fmt, __func__, ##arg)
 
 #define dprintk(kern, lvl, fmt, arg...) do {\
 	if (tda18271_debug & lvl) \
diff -puN drivers/media/dvb/frontends/tda18271.h~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/tda18271.h
--- a/drivers/media/dvb/frontends/tda18271.h~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/tda18271.h
@@ -91,7 +91,7 @@ static inline struct dvb_frontend *tda18
 						   struct i2c_adapter *i2c,
 						   struct tda18271_config *cfg)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif
diff -puN drivers/media/dvb/frontends/tda8083.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/tda8083.c
--- a/drivers/media/dvb/frontends/tda8083.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/tda8083.c
@@ -68,7 +68,7 @@ static int tda8083_writereg (struct tda8
 
 	if (ret != 1)
 		dprintk ("%s: writereg error (reg %02x, ret == %i)\n",
-			__FUNCTION__, reg, ret);
+			__func__, reg, ret);
 
 	return (ret != 1) ? -1 : 0;
 }
@@ -83,7 +83,7 @@ static int tda8083_readregs (struct tda8
 
 	if (ret != 2)
 		dprintk ("%s: readreg error (reg %02x, ret == %i)\n",
-			__FUNCTION__, reg1, ret);
+			__func__, reg1, ret);
 
 	return ret == 2 ? 0 : -1;
 }
diff -puN drivers/media/dvb/frontends/tda8083.h~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/tda8083.h
--- a/drivers/media/dvb/frontends/tda8083.h~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/tda8083.h
@@ -42,7 +42,7 @@ extern struct dvb_frontend* tda8083_atta
 static inline struct dvb_frontend* tda8083_attach(const struct tda8083_config* config,
 					   struct i2c_adapter* i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_TDA8083
diff -puN drivers/media/dvb/frontends/tda826x.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/tda826x.c
--- a/drivers/media/dvb/frontends/tda826x.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/tda826x.c
@@ -54,7 +54,7 @@ static int tda826x_sleep(struct dvb_fron
 	u8 buf [] = { 0x00, 0x8d };
 	struct i2c_msg msg = { .addr = priv->i2c_address, .flags = 0, .buf = buf, .len = 2 };
 
-	dprintk("%s:\n", __FUNCTION__);
+	dprintk("%s:\n", __func__);
 
 	if (!priv->has_loopthrough)
 		buf[1] = 0xad;
@@ -62,7 +62,7 @@ static int tda826x_sleep(struct dvb_fron
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 	if ((ret = i2c_transfer (priv->i2c, &msg, 1)) != 1) {
-		dprintk("%s: i2c error\n", __FUNCTION__);
+		dprintk("%s: i2c error\n", __func__);
 	}
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0);
@@ -78,7 +78,7 @@ static int tda826x_set_params(struct dvb
 	u8 buf [11];
 	struct i2c_msg msg = { .addr = priv->i2c_address, .flags = 0, .buf = buf, .len = 11 };
 
-	dprintk("%s:\n", __FUNCTION__);
+	dprintk("%s:\n", __func__);
 
 	div = (params->frequency + (1000-1)) / 1000;
 
@@ -99,7 +99,7 @@ static int tda826x_set_params(struct dvb
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 	if ((ret = i2c_transfer (priv->i2c, &msg, 1)) != 1) {
-		dprintk("%s: i2c error\n", __FUNCTION__);
+		dprintk("%s: i2c error\n", __func__);
 	}
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0);
@@ -138,7 +138,7 @@ struct dvb_frontend *tda826x_attach(stru
 	};
 	int ret;
 
-	dprintk("%s:\n", __FUNCTION__);
+	dprintk("%s:\n", __func__);
 
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
diff -puN drivers/media/dvb/frontends/tda826x.h~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/tda826x.h
--- a/drivers/media/dvb/frontends/tda826x.h~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/tda826x.h
@@ -45,7 +45,7 @@ static inline struct dvb_frontend* tda82
 						  struct i2c_adapter *i2c,
 						  int has_loopthrough)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_TDA826X
diff -puN drivers/media/dvb/frontends/tda827x.h~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/tda827x.h
--- a/drivers/media/dvb/frontends/tda827x.h~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/tda827x.h
@@ -61,7 +61,7 @@ static inline struct dvb_frontend* tda82
 						  struct i2c_adapter *i2c,
 						  struct tda827x_config *cfg)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_TDA827X
diff -puN drivers/media/dvb/frontends/tua6100.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/tua6100.c
--- a/drivers/media/dvb/frontends/tua6100.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/tua6100.c
@@ -58,7 +58,7 @@ static int tua6100_sleep(struct dvb_fron
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 	if ((ret = i2c_transfer (priv->i2c, &msg, 1)) != 1) {
-		printk("%s: i2c error\n", __FUNCTION__);
+		printk("%s: i2c error\n", __func__);
 	}
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0);
diff -puN drivers/media/dvb/frontends/tua6100.h~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/tua6100.h
--- a/drivers/media/dvb/frontends/tua6100.h~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/tua6100.h
@@ -39,7 +39,7 @@ extern struct dvb_frontend *tua6100_atta
 #else
 static inline struct dvb_frontend* tua6100_attach(struct dvb_frontend *fe, int addr, struct i2c_adapter *i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_TUA6100
diff -puN drivers/media/dvb/frontends/ves1820.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/ves1820.c
--- a/drivers/media/dvb/frontends/ves1820.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/ves1820.c
@@ -66,7 +66,7 @@ static int ves1820_writereg(struct ves18
 
 	if (ret != 1)
 		printk("ves1820: %s(): writereg error (reg == 0x%02x, "
-			"val == 0x%02x, ret == %i)\n", __FUNCTION__, reg, data, ret);
+			"val == 0x%02x, ret == %i)\n", __func__, reg, data, ret);
 
 	return (ret != 1) ? -EREMOTEIO : 0;
 }
@@ -85,7 +85,7 @@ static u8 ves1820_readreg(struct ves1820
 
 	if (ret != 2)
 		printk("ves1820: %s(): readreg error (reg == 0x%02x, "
-		"ret == %i)\n", __FUNCTION__, reg, ret);
+		"ret == %i)\n", __func__, reg, ret);
 
 	return b1[0];
 }
diff -puN drivers/media/dvb/frontends/ves1820.h~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/ves1820.h
--- a/drivers/media/dvb/frontends/ves1820.h~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/ves1820.h
@@ -48,7 +48,7 @@ extern struct dvb_frontend* ves1820_atta
 static inline struct dvb_frontend* ves1820_attach(const struct ves1820_config* config,
 					   struct i2c_adapter* i2c, u8 pwm)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_VES1820
diff -puN drivers/media/dvb/frontends/ves1x93.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/ves1x93.c
--- a/drivers/media/dvb/frontends/ves1x93.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/ves1x93.c
@@ -98,7 +98,7 @@ static int ves1x93_writereg (struct ves1
 	int err;
 
 	if ((err = i2c_transfer (state->i2c, &msg, 1)) != 1) {
-		dprintk ("%s: writereg error (err == %i, reg == 0x%02x, data == 0x%02x)\n", __FUNCTION__, err, reg, data);
+		dprintk ("%s: writereg error (err == %i, reg == 0x%02x, data == 0x%02x)\n", __func__, err, reg, data);
 		return -EREMOTEIO;
 	}
 
@@ -179,7 +179,7 @@ static int ves1x93_set_symbolrate (struc
 	u32 tmp;
 	u32 FIN;
 
-	dprintk("%s: srate == %d\n", __FUNCTION__, (unsigned int) srate);
+	dprintk("%s: srate == %d\n", __func__, (unsigned int) srate);
 
 	if (srate > state->config->xin/2)
 		srate = state->config->xin/2;
@@ -266,7 +266,7 @@ static int ves1x93_init (struct dvb_fron
 	int i;
 	int val;
 
-	dprintk("%s: init chip\n", __FUNCTION__);
+	dprintk("%s: init chip\n", __func__);
 
 	for (i = 0; i < state->tab_size; i++) {
 		if (state->init_1x93_wtab[i]) {
diff -puN drivers/media/dvb/frontends/ves1x93.h~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/ves1x93.h
--- a/drivers/media/dvb/frontends/ves1x93.h~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/ves1x93.h
@@ -47,7 +47,7 @@ extern struct dvb_frontend* ves1x93_atta
 static inline struct dvb_frontend* ves1x93_attach(const struct ves1x93_config* config,
 					   struct i2c_adapter* i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_VES1X93
diff -puN drivers/media/dvb/frontends/xc5000.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/xc5000.c
--- a/drivers/media/dvb/frontends/xc5000.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/xc5000.c
@@ -209,7 +209,7 @@ static void xc5000_TunerReset(struct dvb
 	struct xc5000_priv *priv = fe->tuner_priv;
 	int ret;
 
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 
 	if (priv->cfg->tuner_callback) {
 		ret = priv->cfg->tuner_callback(priv->cfg->priv,
@@ -330,7 +330,7 @@ static int xc_load_i2c_sequence(struct d
 
 static int xc_initialize(struct xc5000_priv *priv)
 {
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 	return xc_write_reg(priv, XREG_INIT, 0);
 }
 
@@ -338,9 +338,9 @@ static int xc_SetTVStandard(struct xc500
 	u16 VideoMode, u16 AudioMode)
 {
 	int ret;
-	dprintk(1, "%s(0x%04x,0x%04x)\n", __FUNCTION__, VideoMode, AudioMode);
+	dprintk(1, "%s(0x%04x,0x%04x)\n", __func__, VideoMode, AudioMode);
 	dprintk(1, "%s() Standard = %s\n",
-		__FUNCTION__,
+		__func__,
 		XC5000_Standard[priv->video_standard].Name);
 
 	ret = xc_write_reg(priv, XREG_VIDEO_MODE, VideoMode);
@@ -361,7 +361,7 @@ static int xc_shutdown(struct xc5000_pri
 
 static int xc_SetSignalSource(struct xc5000_priv *priv, u16 rf_mode)
 {
-	dprintk(1, "%s(%d) Source = %s\n", __FUNCTION__, rf_mode,
+	dprintk(1, "%s(%d) Source = %s\n", __func__, rf_mode,
 		rf_mode == XC_RF_MODE_AIR ? "ANTENNA" : "CABLE");
 
 	if ((rf_mode != XC_RF_MODE_AIR) && (rf_mode != XC_RF_MODE_CABLE))
@@ -369,7 +369,7 @@ static int xc_SetSignalSource(struct xc5
 		rf_mode = XC_RF_MODE_CABLE;
 		printk(KERN_ERR
 			"%s(), Invalid mode, defaulting to CABLE",
-			__FUNCTION__);
+			__func__);
 	}
 	return xc_write_reg(priv, XREG_SIGNALSOURCE, rf_mode);
 }
@@ -380,7 +380,7 @@ static int xc_set_RF_frequency(struct xc
 {
 	u16 freq_code;
 
-	dprintk(1, "%s(%u)\n", __FUNCTION__, freq_hz);
+	dprintk(1, "%s(%u)\n", __func__, freq_hz);
 
 	if ((freq_hz > xc5000_tuner_ops.info.frequency_max) ||
 		(freq_hz < xc5000_tuner_ops.info.frequency_min))
@@ -396,7 +396,7 @@ static int xc_set_IF_frequency(struct xc
 {
 	u32 freq_code = (freq_khz * 1024)/1000;
 	dprintk(1, "%s(freq_khz = %d) freq_code = 0x%x\n",
-		__FUNCTION__, freq_khz, freq_code);
+		__func__, freq_khz, freq_code);
 
 	return xc_write_reg(priv, XREG_IF_OUT, freq_code);
 }
@@ -488,7 +488,7 @@ static int xc_tune_channel(struct xc5000
 {
 	int found = 0;
 
-	dprintk(1, "%s(%u)\n", __FUNCTION__, freq_hz);
+	dprintk(1, "%s(%u)\n", __func__, freq_hz);
 
 	if (xc_set_RF_frequency(priv, freq_hz) != XC_RESULT_SUCCESS)
 		return 0;
@@ -627,12 +627,12 @@ static int xc5000_set_params(struct dvb_
 	struct xc5000_priv *priv = fe->tuner_priv;
 	int ret;
 
-	dprintk(1, "%s() frequency=%d (Hz)\n", __FUNCTION__, params->frequency);
+	dprintk(1, "%s() frequency=%d (Hz)\n", __func__, params->frequency);
 
 	switch(params->u.vsb.modulation) {
 	case VSB_8:
 	case VSB_16:
-		dprintk(1, "%s() VSB modulation\n", __FUNCTION__);
+		dprintk(1, "%s() VSB modulation\n", __func__);
 		priv->rf_mode = XC_RF_MODE_AIR;
 		priv->freq_hz = params->frequency - 1750000;
 		priv->bandwidth = BANDWIDTH_6_MHZ;
@@ -641,7 +641,7 @@ static int xc5000_set_params(struct dvb_
 	case QAM_64:
 	case QAM_256:
 	case QAM_AUTO:
-		dprintk(1, "%s() QAM modulation\n", __FUNCTION__);
+		dprintk(1, "%s() QAM modulation\n", __func__);
 		priv->rf_mode = XC_RF_MODE_CABLE;
 		priv->freq_hz = params->frequency - 1750000;
 		priv->bandwidth = BANDWIDTH_6_MHZ;
@@ -652,7 +652,7 @@ static int xc5000_set_params(struct dvb_
 	}
 
 	dprintk(1, "%s() frequency=%d (compensated)\n",
-		__FUNCTION__, priv->freq_hz);
+		__func__, priv->freq_hz);
 
 	ret = xc_SetSignalSource(priv, priv->rf_mode);
 	if (ret != XC_RESULT_SUCCESS) {
@@ -697,7 +697,7 @@ static int xc5000_set_analog_params(stru
 		xc_load_fw_and_init_tuner(fe);
 
 	dprintk(1, "%s() frequency=%d (in units of 62.5khz)\n",
-		__FUNCTION__, params->frequency);
+		__func__, params->frequency);
 
 	priv->rf_mode = XC_RF_MODE_CABLE; /* Fix me: it could be air. */
 
@@ -775,7 +775,7 @@ tune_channel:
 static int xc5000_get_frequency(struct dvb_frontend *fe, u32 *freq)
 {
 	struct xc5000_priv *priv = fe->tuner_priv;
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 	*freq = priv->freq_hz;
 	return 0;
 }
@@ -783,7 +783,7 @@ static int xc5000_get_frequency(struct d
 static int xc5000_get_bandwidth(struct dvb_frontend *fe, u32 *bw)
 {
 	struct xc5000_priv *priv = fe->tuner_priv;
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 
 	*bw = priv->bandwidth;
 	return 0;
@@ -796,7 +796,7 @@ static int xc5000_get_status(struct dvb_
 
 	xc_get_lock_status(priv, &lock_status);
 
-	dprintk(1, "%s() lock_status = 0x%08x\n", __FUNCTION__, lock_status);
+	dprintk(1, "%s() lock_status = 0x%08x\n", __func__, lock_status);
 
 	*status = lock_status;
 
@@ -836,7 +836,7 @@ static int xc5000_sleep(struct dvb_front
 	struct xc5000_priv *priv = fe->tuner_priv;
 	int ret;
 
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 
 	/* On Pinnacle PCTV HD 800i, the tuner cannot be reinitialized
 	 * once shutdown without reloading the driver. Maybe I am not
@@ -848,7 +848,7 @@ static int xc5000_sleep(struct dvb_front
 	if(ret != XC_RESULT_SUCCESS) {
 		printk(KERN_ERR
 			"xc5000: %s() unable to shutdown tuner\n",
-			__FUNCTION__);
+			__func__);
 		return -EREMOTEIO;
 	}
 	else {
@@ -860,7 +860,7 @@ static int xc5000_sleep(struct dvb_front
 static int xc5000_init(struct dvb_frontend *fe)
 {
 	struct xc5000_priv *priv = fe->tuner_priv;
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 
 	if (xc_load_fw_and_init_tuner(fe) != XC_RESULT_SUCCESS) {
 		printk(KERN_ERR "xc5000: Unable to initialise tuner\n");
@@ -875,7 +875,7 @@ static int xc5000_init(struct dvb_fronte
 
 static int xc5000_release(struct dvb_frontend *fe)
 {
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 	kfree(fe->tuner_priv);
 	fe->tuner_priv = NULL;
 	return 0;
@@ -907,7 +907,7 @@ struct dvb_frontend * xc5000_attach(stru
 	struct xc5000_priv *priv = NULL;
 	u16 id = 0;
 
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 
 	priv = kzalloc(sizeof(struct xc5000_priv), GFP_KERNEL);
 	if (priv == NULL)
diff -puN drivers/media/dvb/frontends/xc5000.h~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/xc5000.h
--- a/drivers/media/dvb/frontends/xc5000.h~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/xc5000.h
@@ -55,7 +55,7 @@ static inline struct dvb_frontend* xc500
 						 struct i2c_adapter *i2c,
 						 struct xc5000_config *cfg)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_TUNER_XC5000
diff -puN drivers/media/dvb/frontends/zl10353.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/zl10353.c
--- a/drivers/media/dvb/frontends/zl10353.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/zl10353.c
@@ -88,7 +88,7 @@ static int zl10353_read_register(struct 
 
 	if (ret != 2) {
 		printk("%s: readreg error (reg=%d, ret==%i)\n",
-		       __FUNCTION__, reg, ret);
+		       __func__, reg, ret);
 		return ret;
 	}
 
@@ -152,7 +152,7 @@ static void zl10353_calc_nominal_rate(st
 	*nominal_rate = value;
 
 	dprintk("%s: bw %d, adc_clock %d => 0x%x\n",
-		__FUNCTION__, bw, adc_clock, *nominal_rate);
+		__func__, bw, adc_clock, *nominal_rate);
 }
 
 static void zl10353_calc_input_freq(struct dvb_frontend *fe,
@@ -181,7 +181,7 @@ static void zl10353_calc_input_freq(stru
 	*input_freq = -value;
 
 	dprintk("%s: if2 %d, ife %d, adc_clock %d => %d / 0x%x\n",
-		__FUNCTION__, if2, ife, adc_clock, -(int)value, *input_freq);
+		__func__, if2, ife, adc_clock, -(int)value, *input_freq);
 }
 
 static int zl10353_sleep(struct dvb_frontend *fe)
diff -puN drivers/media/dvb/frontends/zl10353.h~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/frontends/zl10353.h
--- a/drivers/media/dvb/frontends/zl10353.h~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/frontends/zl10353.h
@@ -47,7 +47,7 @@ extern struct dvb_frontend* zl10353_atta
 static inline struct dvb_frontend* zl10353_attach(const struct zl10353_config *config,
 					   struct i2c_adapter *i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif /* CONFIG_DVB_ZL10353 */
diff -puN drivers/media/dvb/ttpci/av7110.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/ttpci/av7110.c
--- a/drivers/media/dvb/ttpci/av7110.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/ttpci/av7110.c
@@ -359,7 +359,7 @@ static inline void start_debi_dma(struct
 {
 	dprintk(8, "%c %08lx %u\n", dir == DEBI_READ ? 'R' : 'W', addr, len);
 	if (saa7146_wait_for_debi_done(av7110->dev, 0)) {
-		printk(KERN_ERR "%s: saa7146_wait_for_debi_done timed out\n", __FUNCTION__);
+		printk(KERN_ERR "%s: saa7146_wait_for_debi_done timed out\n", __func__);
 		return;
 	}
 
@@ -497,7 +497,7 @@ static void gpioirq(unsigned long data)
 		       saa7146_read(av7110->dev, SSR));
 
 	if (saa7146_wait_for_debi_done(av7110->dev, 0)) {
-		printk(KERN_ERR "%s: saa7146_wait_for_debi_done timed out\n", __FUNCTION__);
+		printk(KERN_ERR "%s: saa7146_wait_for_debi_done timed out\n", __func__);
 		BUG(); /* maybe we should try resetting the debi? */
 	}
 
@@ -827,7 +827,7 @@ static int StartHWFilter(struct dvb_demu
 	if (ret != 0 || handle >= 32) {
 		printk("dvb-ttpci: %s error  buf %04x %04x %04x %04x  "
 				"ret %d  handle %04x\n",
-				__FUNCTION__, buf[0], buf[1], buf[2], buf[3],
+				__func__, buf[0], buf[1], buf[2], buf[3],
 				ret, handle);
 		dvbdmxfilter->hw_handle = 0xffff;
 		if (!ret)
@@ -854,7 +854,7 @@ static int StopHWFilter(struct dvb_demux
 	handle = dvbdmxfilter->hw_handle;
 	if (handle >= 32) {
 		printk("%s tried to stop invalid filter %04x, filter type = %x\n",
-				__FUNCTION__, handle, dvbdmxfilter->type);
+				__func__, handle, dvbdmxfilter->type);
 		return -EINVAL;
 	}
 
@@ -867,7 +867,7 @@ static int StopHWFilter(struct dvb_demux
 	if (ret != 0 || answ[1] != handle) {
 		printk("dvb-ttpci: %s error  cmd %04x %04x %04x  ret %x  "
 				"resp %04x %04x  pid %d\n",
-				__FUNCTION__, buf[0], buf[1], buf[2], ret,
+				__func__, buf[0], buf[1], buf[2], ret,
 				answ[0], answ[1], dvbdmxfilter->feed->pid);
 		if (!ret)
 			ret = -1;
@@ -1122,7 +1122,7 @@ static int dvb_get_stc(struct dmx_demux 
 
 	ret = av7110_fw_request(av7110, &tag, 0, fwstc, 4);
 	if (ret) {
-		printk(KERN_ERR "%s: av7110_fw_request error\n", __FUNCTION__);
+		printk(KERN_ERR "%s: av7110_fw_request error\n", __func__);
 		return ret;
 	}
 	dprintk(2, "fwstc = %04hx %04hx %04hx %04hx\n",
diff -puN drivers/media/dvb/ttpci/av7110.h~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/ttpci/av7110.h
--- a/drivers/media/dvb/ttpci/av7110.h~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/ttpci/av7110.h
@@ -40,7 +40,7 @@
 extern int av7110_debug;
 
 #define dprintk(level,args...) \
-	    do { if ((av7110_debug & level)) { printk("dvb-ttpci: %s(): ", __FUNCTION__); printk(args); } } while (0)
+	    do { if ((av7110_debug & level)) { printk("dvb-ttpci: %s(): ", __func__); printk(args); } } while (0)
 
 #define MAXFILT 32
 
diff -puN drivers/media/dvb/ttpci/av7110_hw.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/ttpci/av7110_hw.c
--- a/drivers/media/dvb/ttpci/av7110_hw.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/ttpci/av7110_hw.c
@@ -53,11 +53,11 @@ int av7110_debiwrite(struct av7110 *av71
 	struct saa7146_dev *dev = av7110->dev;
 
 	if (count <= 0 || count > 32764) {
-		printk("%s: invalid count %d\n", __FUNCTION__, count);
+		printk("%s: invalid count %d\n", __func__, count);
 		return -1;
 	}
 	if (saa7146_wait_for_debi_done(av7110->dev, 0) < 0) {
-		printk("%s: wait_for_debi_done failed\n", __FUNCTION__);
+		printk("%s: wait_for_debi_done failed\n", __func__);
 		return -1;
 	}
 	saa7146_write(dev, DEBI_CONFIG, config);
@@ -76,11 +76,11 @@ u32 av7110_debiread(struct av7110 *av711
 	u32 result = 0;
 
 	if (count > 32764 || count <= 0) {
-		printk("%s: invalid count %d\n", __FUNCTION__, count);
+		printk("%s: invalid count %d\n", __func__, count);
 		return 0;
 	}
 	if (saa7146_wait_for_debi_done(av7110->dev, 0) < 0) {
-		printk("%s: wait_for_debi_done #1 failed\n", __FUNCTION__);
+		printk("%s: wait_for_debi_done #1 failed\n", __func__);
 		return 0;
 	}
 	saa7146_write(dev, DEBI_AD, av7110->debi_bus);
@@ -91,7 +91,7 @@ u32 av7110_debiread(struct av7110 *av711
 	if (count > 4)
 		return count;
 	if (saa7146_wait_for_debi_done(av7110->dev, 0) < 0) {
-		printk("%s: wait_for_debi_done #2 failed\n", __FUNCTION__);
+		printk("%s: wait_for_debi_done #2 failed\n", __func__);
 		return 0;
 	}
 
@@ -332,7 +332,7 @@ int av7110_wait_msgstate(struct av7110 *
 			break;
 		if (err) {
 			printk(KERN_ERR "%s: timeout waiting for MSGSTATE %04x\n",
-				__FUNCTION__, stat & flags);
+				__func__, stat & flags);
 			return -ETIMEDOUT;
 		}
 		msleep(1);
@@ -362,7 +362,7 @@ static int __av7110_send_fw_cmd(struct a
 		if (rdebi(av7110, DEBINOSWAP, COMMAND, 0, 2) == 0)
 			break;
 		if (err) {
-			printk(KERN_ERR "dvb-ttpci: %s(): timeout waiting for COMMAND idle\n", __FUNCTION__);
+			printk(KERN_ERR "dvb-ttpci: %s(): timeout waiting for COMMAND idle\n", __func__);
 			av7110->arm_errors++;
 			return -ETIMEDOUT;
 		}
@@ -379,7 +379,7 @@ static int __av7110_send_fw_cmd(struct a
 		if (rdebi(av7110, DEBINOSWAP, HANDSHAKE_REG, 0, 2) == 0)
 			break;
 		if (err) {
-			printk(KERN_ERR "dvb-ttpci: %s(): timeout waiting for HANDSHAKE_REG\n", __FUNCTION__);
+			printk(KERN_ERR "dvb-ttpci: %s(): timeout waiting for HANDSHAKE_REG\n", __func__);
 			return -ETIMEDOUT;
 		}
 		msleep(1);
@@ -419,14 +419,14 @@ static int __av7110_send_fw_cmd(struct a
 			stat = rdebi(av7110, DEBINOSWAP, MSGSTATE, 0, 2);
 			if (stat & flags[0]) {
 				printk(KERN_ERR "%s: %s QUEUE overflow\n",
-					__FUNCTION__, type);
+					__func__, type);
 				return -1;
 			}
 			if ((stat & flags[1]) == 0)
 				break;
 			if (err) {
 				printk(KERN_ERR "%s: timeout waiting on busy %s QUEUE\n",
-					__FUNCTION__, type);
+					__func__, type);
 				return -ETIMEDOUT;
 			}
 			msleep(1);
@@ -454,7 +454,7 @@ static int __av7110_send_fw_cmd(struct a
 			break;
 		if (err) {
 			printk(KERN_ERR "dvb-ttpci: %s(): timeout waiting for COMMAND %d to complete\n",
-			       __FUNCTION__, (buf[0] >> 8) & 0xff);
+			       __func__, (buf[0] >> 8) & 0xff);
 			return -ETIMEDOUT;
 		}
 		msleep(1);
@@ -462,11 +462,11 @@ static int __av7110_send_fw_cmd(struct a
 
 	stat = rdebi(av7110, DEBINOSWAP, MSGSTATE, 0, 2);
 	if (stat & GPMQOver) {
-		printk(KERN_ERR "dvb-ttpci: %s(): GPMQOver\n", __FUNCTION__);
+		printk(KERN_ERR "dvb-ttpci: %s(): GPMQOver\n", __func__);
 		return -ENOSPC;
 	}
 	else if (stat & OSDQOver) {
-		printk(KERN_ERR "dvb-ttpci: %s(): OSDQOver\n", __FUNCTION__);
+		printk(KERN_ERR "dvb-ttpci: %s(): OSDQOver\n", __func__);
 		return -ENOSPC;
 	}
 #endif
@@ -491,7 +491,7 @@ static int av7110_send_fw_cmd(struct av7
 	mutex_unlock(&av7110->dcomlock);
 	if (ret && ret!=-ERESTARTSYS)
 		printk(KERN_ERR "dvb-ttpci: %s(): av7110_send_fw_cmd error %d\n",
-		       __FUNCTION__, ret);
+		       __func__, ret);
 	return ret;
 }
 
@@ -575,7 +575,7 @@ int av7110_fw_request(struct av7110 *av7
 		if (rdebi(av7110, DEBINOSWAP, COMMAND, 0, 2) == 0)
 			break;
 		if (err) {
-			printk(KERN_ERR "%s: timeout waiting for COMMAND to complete\n", __FUNCTION__);
+			printk(KERN_ERR "%s: timeout waiting for COMMAND to complete\n", __func__);
 			mutex_unlock(&av7110->dcomlock);
 			return -ETIMEDOUT;
 		}
@@ -591,7 +591,7 @@ int av7110_fw_request(struct av7110 *av7
 		if (rdebi(av7110, DEBINOSWAP, HANDSHAKE_REG, 0, 2) == 0)
 			break;
 		if (err) {
-			printk(KERN_ERR "%s: timeout waiting for HANDSHAKE_REG\n", __FUNCTION__);
+			printk(KERN_ERR "%s: timeout waiting for HANDSHAKE_REG\n", __func__);
 			mutex_unlock(&av7110->dcomlock);
 			return -ETIMEDOUT;
 		}
@@ -602,12 +602,12 @@ int av7110_fw_request(struct av7110 *av7
 #ifdef COM_DEBUG
 	stat = rdebi(av7110, DEBINOSWAP, MSGSTATE, 0, 2);
 	if (stat & GPMQOver) {
-		printk(KERN_ERR "%s: GPMQOver\n", __FUNCTION__);
+		printk(KERN_ERR "%s: GPMQOver\n", __func__);
 		mutex_unlock(&av7110->dcomlock);
 		return -1;
 	}
 	else if (stat & OSDQOver) {
-		printk(KERN_ERR "%s: OSDQOver\n", __FUNCTION__);
+		printk(KERN_ERR "%s: OSDQOver\n", __func__);
 		mutex_unlock(&av7110->dcomlock);
 		return -1;
 	}
@@ -741,7 +741,7 @@ static int FlushText(struct av7110 *av71
 			break;
 		if (err) {
 			printk(KERN_ERR "dvb-ttpci: %s(): timeout waiting for BUFF1_BASE == 0\n",
-			       __FUNCTION__);
+			       __func__);
 			mutex_unlock(&av7110->dcomlock);
 			return -ETIMEDOUT;
 		}
@@ -768,7 +768,7 @@ static int WriteText(struct av7110 *av71
 			break;
 		if (ret) {
 			printk(KERN_ERR "dvb-ttpci: %s: timeout waiting for BUFF1_BASE == 0\n",
-			       __FUNCTION__);
+			       __func__);
 			mutex_unlock(&av7110->dcomlock);
 			return -ETIMEDOUT;
 		}
@@ -782,7 +782,7 @@ static int WriteText(struct av7110 *av71
 			break;
 		if (ret) {
 			printk(KERN_ERR "dvb-ttpci: %s: timeout waiting for HANDSHAKE_REG\n",
-			       __FUNCTION__);
+			       __func__);
 			mutex_unlock(&av7110->dcomlock);
 			return -ETIMEDOUT;
 		}
diff -puN drivers/media/dvb/ttpci/av7110_ir.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/ttpci/av7110_ir.c
--- a/drivers/media/dvb/ttpci/av7110_ir.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/ttpci/av7110_ir.c
@@ -133,7 +133,7 @@ static void av7110_emit_key(unsigned lon
 		break;
 
 	default:
-		printk("%s invalid protocol %x\n", __FUNCTION__, ir->protocol);
+		printk("%s invalid protocol %x\n", __func__, ir->protocol);
 		return;
 	}
 
@@ -143,7 +143,7 @@ static void av7110_emit_key(unsigned lon
 	keycode = ir->key_map[data];
 
 	dprintk(16, "%s: code %08x -> addr %i data 0x%02x -> keycode %i\n",
-		__FUNCTION__, ircom, addr, data, keycode);
+		__func__, ircom, addr, data, keycode);
 
 	/* check device address */
 	if (!(ir->device_mask & (1 << addr)))
@@ -151,7 +151,7 @@ static void av7110_emit_key(unsigned lon
 
 	if (!keycode) {
 		printk ("%s: code %08x -> addr %i data 0x%02x -> unknown key!\n",
-			__FUNCTION__, ircom, addr, data);
+			__func__, ircom, addr, data);
 		return;
 	}
 
diff -puN drivers/media/dvb/ttpci/av7110_v4l.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/ttpci/av7110_v4l.c
--- a/drivers/media/dvb/ttpci/av7110_v4l.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/ttpci/av7110_v4l.c
@@ -573,7 +573,7 @@ static int av7110_vbi_reset(struct inode
 	struct saa7146_dev *dev = fh->dev;
 	struct av7110 *av7110 = (struct av7110*) dev->ext_priv;
 
-	dprintk(2, "%s\n", __FUNCTION__);
+	dprintk(2, "%s\n", __func__);
 	av7110->wssMode = 0;
 	av7110->wssData = 0;
 	if (FW_VERSION(av7110->arm_app) < 0x2623)
@@ -590,7 +590,7 @@ static ssize_t av7110_vbi_write(struct f
 	struct v4l2_sliced_vbi_data d;
 	int rc;
 
-	dprintk(2, "%s\n", __FUNCTION__);
+	dprintk(2, "%s\n", __func__);
 	if (FW_VERSION(av7110->arm_app) < 0x2623 || !av7110->wssMode || count != sizeof d)
 		return -EINVAL;
 	if (copy_from_user(&d, data, count))
diff -puN drivers/media/dvb/ttpci/budget-ci.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/ttpci/budget-ci.c
--- a/drivers/media/dvb/ttpci/budget-ci.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/ttpci/budget-ci.c
@@ -1121,7 +1121,7 @@ static void frontend_init(struct budget_
 
 			budget_ci->budget.dvb_frontend->ops.dishnetwork_send_legacy_command = NULL;
 			if (dvb_attach(lnbp21_attach, budget_ci->budget.dvb_frontend, &budget_ci->budget.i2c_adap, LNBP21_LLC, 0) == NULL) {
-				printk("%s: No LNBP21 found!\n", __FUNCTION__);
+				printk("%s: No LNBP21 found!\n", __func__);
 				dvb_frontend_detach(budget_ci->budget.dvb_frontend);
 				budget_ci->budget.dvb_frontend = NULL;
 			}
diff -puN drivers/media/dvb/ttpci/budget-core.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/ttpci/budget-core.c
--- a/drivers/media/dvb/ttpci/budget-core.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/ttpci/budget-core.c
@@ -223,7 +223,7 @@ static void vpeirq(unsigned long data)
 
 	if (budget->buffer_warnings && time_after(jiffies, budget->buffer_warning_time)) {
 		printk("%s %s: used %d times >80%% of buffer (%u bytes now)\n",
-			budget->dev->name, __FUNCTION__, budget->buffer_warnings, count);
+			budget->dev->name, __func__, budget->buffer_warnings, count);
 		budget->buffer_warning_time = jiffies + BUFFER_WARNING_WAIT;
 		budget->buffer_warnings = 0;
 	}
diff -puN drivers/media/dvb/ttpci/budget.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/ttpci/budget.c
--- a/drivers/media/dvb/ttpci/budget.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/ttpci/budget.c
@@ -438,7 +438,7 @@ static void frontend_init(struct budget 
 		if (budget->dvb_frontend) {
 			budget->dvb_frontend->ops.tuner_ops.set_params = s5h1420_tuner_set_params;
 			if (dvb_attach(lnbp21_attach, budget->dvb_frontend, &budget->i2c_adap, 0, 0) == NULL) {
-				printk("%s: No LNBP21 found!\n", __FUNCTION__);
+				printk("%s: No LNBP21 found!\n", __func__);
 				goto error_out;
 			}
 			break;
@@ -454,9 +454,9 @@ static void frontend_init(struct budget 
 		budget->dvb_frontend = dvb_attach(tda10086_attach, &tda10086_config, &budget->i2c_adap);
 		if (budget->dvb_frontend) {
 			if (dvb_attach(tda826x_attach, budget->dvb_frontend, 0x60, &budget->i2c_adap, 0) == NULL)
-				printk("%s: No tda826x found!\n", __FUNCTION__);
+				printk("%s: No tda826x found!\n", __func__);
 			if (dvb_attach(lnbp21_attach, budget->dvb_frontend, &budget->i2c_adap, 0, 0) == NULL) {
-				printk("%s: No LNBP21 found!\n", __FUNCTION__);
+				printk("%s: No LNBP21 found!\n", __func__);
 				goto error_out;
 			}
 			break;
diff -puN drivers/media/dvb/ttpci/budget.h~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/ttpci/budget.h
--- a/drivers/media/dvb/ttpci/budget.h~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/ttpci/budget.h
@@ -21,7 +21,7 @@ extern int budget_debug;
 #endif
 
 #define dprintk(level,args...) \
-	    do { if ((budget_debug & level)) { printk("%s: %s(): ", KBUILD_MODNAME, __FUNCTION__); printk(args); } } while (0)
+	    do { if ((budget_debug & level)) { printk("%s: %s(): ", KBUILD_MODNAME, __func__); printk(args); } } while (0)
 
 struct budget_info {
 	char *name;
diff -puN drivers/media/dvb/ttpci/ttpci-eeprom.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/ttpci/ttpci-eeprom.c
--- a/drivers/media/dvb/ttpci/ttpci-eeprom.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/ttpci/ttpci-eeprom.c
@@ -95,7 +95,7 @@ static int ttpci_eeprom_read_encodedMAC(
 		{ .addr = 0x50, .flags = I2C_M_RD, .buf = encodedMAC, .len = 20 }
 	};
 
-	/* dprintk("%s\n", __FUNCTION__); */
+	/* dprintk("%s\n", __func__); */
 
 	ret = i2c_transfer(adapter, msg, 2);
 
diff -puN drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
--- a/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
@@ -153,12 +153,12 @@ static int ttusb_cmd(struct ttusb *ttusb
 			   (u8 *) data, len, &actual_len, 1000);
 	if (err != 0) {
 		dprintk("%s: usb_bulk_msg(send) failed, err == %i!\n",
-			__FUNCTION__, err);
+			__func__, err);
 		mutex_unlock(&ttusb->semusb);
 		return err;
 	}
 	if (actual_len != len) {
-		dprintk("%s: only wrote %d of %d bytes\n", __FUNCTION__,
+		dprintk("%s: only wrote %d of %d bytes\n", __func__,
 			actual_len, len);
 		mutex_unlock(&ttusb->semusb);
 		return -1;
@@ -168,7 +168,7 @@ static int ttusb_cmd(struct ttusb *ttusb
 			   ttusb->last_result, 32, &actual_len, 1000);
 
 	if (err != 0) {
-		printk("%s: failed, receive error %d\n", __FUNCTION__,
+		printk("%s: failed, receive error %d\n", __func__,
 		       err);
 		mutex_unlock(&ttusb->semusb);
 		return err;
@@ -229,7 +229,7 @@ static int ttusb_i2c_msg(struct ttusb *t
 		if (err || b[0] != 0x55 || b[1] != id) {
 			dprintk
 			    ("%s: usb_bulk_msg(recv) failed, err == %i, id == %02x, b == ",
-			     __FUNCTION__, err, id);
+			     __func__, err, id);
 			return -EREMOTEIO;
 		}
 
@@ -273,7 +273,7 @@ static int master_xfer(struct i2c_adapte
 				    snd_buf, snd_len, rcv_buf, rcv_len);
 
 		if (err < rcv_len) {
-			dprintk("%s: i == %i\n", __FUNCTION__, i);
+			dprintk("%s: i == %i\n", __func__, i);
 			break;
 		}
 
@@ -327,7 +327,7 @@ static int ttusb_boot_dsp(struct ttusb *
       done:
 	if (err) {
 		dprintk("%s: usb_bulk_msg() failed, return value %i!\n",
-			__FUNCTION__, err);
+			__func__, err);
 	}
 
 	return err;
@@ -427,7 +427,7 @@ static int ttusb_init_controller(struct 
 	if ((err = ttusb_result(ttusb, get_version, sizeof(get_version))))
 		return err;
 
-	dprintk("%s: stc-version: %c%c%c%c%c\n", __FUNCTION__,
+	dprintk("%s: stc-version: %c%c%c%c%c\n", __func__,
 		get_version[4], get_version[5], get_version[6],
 		get_version[7], get_version[8]);
 
@@ -437,7 +437,7 @@ static int ttusb_init_controller(struct 
 	    memcmp(get_version + 4, "V 2.2", 5)) {
 		printk
 		    ("%s: unknown STC version %c%c%c%c%c, please report!\n",
-		     __FUNCTION__, get_version[4], get_version[5],
+		     __func__, get_version[4], get_version[5],
 		     get_version[6], get_version[7], get_version[8]);
 	}
 
@@ -453,7 +453,7 @@ static int ttusb_init_controller(struct 
 	    ttusb_result(ttusb, get_dsp_version, sizeof(get_dsp_version));
 	if (err)
 		return err;
-	printk("%s: dsp-version: %c%c%c\n", __FUNCTION__,
+	printk("%s: dsp-version: %c%c%c\n", __func__,
 	       get_dsp_version[4], get_dsp_version[5], get_dsp_version[6]);
 	return 0;
 }
@@ -476,7 +476,7 @@ static int ttusb_send_diseqc(struct dvb_
 	/* Diseqc */
 	if ((err = ttusb_cmd(ttusb, b, 4 + b[3], 0))) {
 		dprintk("%s: usb_bulk_msg() failed, return value %i!\n",
-			__FUNCTION__, err);
+			__func__, err);
 	}
 
 	return err;
@@ -494,7 +494,7 @@ static int ttusb_update_lnb(struct ttusb
 	/* SetLNB */
 	if ((err = ttusb_cmd(ttusb, b, sizeof(b), 0))) {
 		dprintk("%s: usb_bulk_msg() failed, return value %i!\n",
-			__FUNCTION__, err);
+			__func__, err);
 	}
 
 	return err;
@@ -528,7 +528,7 @@ static void ttusb_set_led_freq(struct tt
 	err = ttusb_cmd(ttusb, b, sizeof(b), 0);
 	if (err) {
 		dprintk("%s: usb_bulk_msg() failed, return value %i!\n",
-			__FUNCTION__, err);
+			__func__, err);
 	}
 }
 #endif
@@ -554,7 +554,7 @@ static void ttusb_process_muxpack(struct
 		csum ^= le16_to_cpup((u16 *) (muxpack + i));
 	if (csum) {
 		printk("%s: muxpack with incorrect checksum, ignoring\n",
-		       __FUNCTION__);
+		       __func__);
 		numinvalid++;
 		return;
 	}
@@ -563,7 +563,7 @@ static void ttusb_process_muxpack(struct
 	cc &= 0x7FFF;
 	if ((cc != ttusb->cc) && (ttusb->cc != -1))
 		printk("%s: cc discontinuity (%d frames missing)\n",
-		       __FUNCTION__, (cc - ttusb->cc) & 0x7FFF);
+		       __func__, (cc - ttusb->cc) & 0x7FFF);
 	ttusb->cc = (cc + 1) & 0x7FFF;
 	if (muxpack[0] & 0x80) {
 #ifdef TTUSB_HWSECTIONS
@@ -613,7 +613,7 @@ static void ttusb_process_frame(struct t
 	int maxwork = 1024;
 	while (len) {
 		if (!(maxwork--)) {
-			printk("%s: too much work\n", __FUNCTION__);
+			printk("%s: too much work\n", __func__);
 			break;
 		}
 
@@ -632,7 +632,7 @@ static void ttusb_process_frame(struct t
 #else
 				if (ttusb->insync) {
 					printk("%s: lost sync.\n",
-					       __FUNCTION__);
+					       __func__);
 					ttusb->insync = 0;
 				}
 #endif
@@ -691,7 +691,7 @@ static void ttusb_process_frame(struct t
 					else {
 						dprintk
 						    ("%s: invalid state: first byte is %x\n",
-						     __FUNCTION__,
+						     __func__,
 						     ttusb->muxpack[0]);
 						ttusb->mux_state = 0;
 					}
@@ -740,7 +740,7 @@ static void ttusb_iso_irq(struct urb *ur
 
 #if 0
 	printk("%s: status %d, errcount == %d, length == %i\n",
-	       __FUNCTION__,
+	       __func__,
 	       urb->status, urb->error_count, urb->actual_length);
 #endif
 
@@ -833,7 +833,7 @@ static int ttusb_start_iso_xfer(struct t
 	int i, j, err, buffer_offset = 0;
 
 	if (ttusb->iso_streaming) {
-		printk("%s: iso xfer already running!\n", __FUNCTION__);
+		printk("%s: iso xfer already running!\n", __func__);
 		return 0;
 	}
 
@@ -869,7 +869,7 @@ static int ttusb_start_iso_xfer(struct t
 			ttusb_stop_iso_xfer(ttusb);
 			printk
 			    ("%s: failed urb submission (%i: err = %i)!\n",
-			     __FUNCTION__, i, err);
+			     __func__, i, err);
 			return err;
 		}
 	}
@@ -1643,7 +1643,7 @@ static int ttusb_probe(struct usb_interf
 	struct ttusb *ttusb;
 	int result;
 
-	dprintk("%s: TTUSB DVB connected\n", __FUNCTION__);
+	dprintk("%s: TTUSB DVB connected\n", __func__);
 
 	udev = interface_to_usbdev(intf);
 
@@ -1773,7 +1773,7 @@ static void ttusb_disconnect(struct usb_
 
 	kfree(ttusb);
 
-	dprintk("%s: TTUSB DVB disconnected\n", __FUNCTION__);
+	dprintk("%s: TTUSB DVB disconnected\n", __func__);
 }
 
 static struct usb_device_id ttusb_table[] = {
diff -puN drivers/media/dvb/ttusb-dec/ttusb_dec.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/ttusb-dec/ttusb_dec.c
--- a/drivers/media/dvb/ttusb-dec/ttusb_dec.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/ttusb-dec/ttusb_dec.c
@@ -217,11 +217,11 @@ static void ttusb_dec_handle_irq( struct
 		case -ETIME:
 			/* this urb is dead, cleanup */
 			dprintk("%s:urb shutting down with status: %d\n",
-					__FUNCTION__, urb->status);
+					__func__, urb->status);
 			return;
 		default:
 			dprintk("%s:nonzero status received: %d\n",
-					__FUNCTION__,urb->status);
+					__func__,urb->status);
 			goto exit;
 	}
 
@@ -235,7 +235,7 @@ static void ttusb_dec_handle_irq( struct
 		 * keyrepeat signal is recieved for lets say 200ms.
 		 * this should/could be added later ...
 		 * for now lets report each signal as a key down and up*/
-		dprintk("%s:rc signal:%d\n", __FUNCTION__, buffer[4]);
+		dprintk("%s:rc signal:%d\n", __func__, buffer[4]);
 		input_report_key(dec->rc_input_dev, rc_keys[buffer[4] - 1], 1);
 		input_sync(dec->rc_input_dev);
 		input_report_key(dec->rc_input_dev, rc_keys[buffer[4] - 1], 0);
@@ -245,7 +245,7 @@ static void ttusb_dec_handle_irq( struct
 exit:	retval = usb_submit_urb(urb, GFP_ATOMIC);
 	if(retval)
 		printk("%s - usb_commit_urb failed with result: %d\n",
-			__FUNCTION__, retval);
+			__func__, retval);
 }
 
 static u16 crc16(u16 crc, const u8 *buf, size_t len)
@@ -268,7 +268,7 @@ static int ttusb_dec_send_command(struct
 	int result, actual_len, i;
 	u8 *b;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	b = kmalloc(COMMAND_PACKET_SIZE + 4, GFP_KERNEL);
 	if (!b)
@@ -276,7 +276,7 @@ static int ttusb_dec_send_command(struct
 
 	if ((result = mutex_lock_interruptible(&dec->usb_mutex))) {
 		kfree(b);
-		printk("%s: Failed to lock usb mutex.\n", __FUNCTION__);
+		printk("%s: Failed to lock usb mutex.\n", __func__);
 		return result;
 	}
 
@@ -289,7 +289,7 @@ static int ttusb_dec_send_command(struct
 		memcpy(&b[4], params, param_length);
 
 	if (debug) {
-		printk("%s: command: ", __FUNCTION__);
+		printk("%s: command: ", __func__);
 		for (i = 0; i < param_length + 4; i++)
 			printk("0x%02X ", b[i]);
 		printk("\n");
@@ -300,7 +300,7 @@ static int ttusb_dec_send_command(struct
 
 	if (result) {
 		printk("%s: command bulk message failed: error %d\n",
-		       __FUNCTION__, result);
+		       __func__, result);
 		mutex_unlock(&dec->usb_mutex);
 		kfree(b);
 		return result;
@@ -311,13 +311,13 @@ static int ttusb_dec_send_command(struct
 
 	if (result) {
 		printk("%s: result bulk message failed: error %d\n",
-		       __FUNCTION__, result);
+		       __func__, result);
 		mutex_unlock(&dec->usb_mutex);
 		kfree(b);
 		return result;
 	} else {
 		if (debug) {
-			printk("%s: result: ", __FUNCTION__);
+			printk("%s: result: ", __func__);
 			for (i = 0; i < actual_len; i++)
 				printk("0x%02X ", b[i]);
 			printk("\n");
@@ -343,7 +343,7 @@ static int ttusb_dec_get_stb_state (stru
 	int result;
 	unsigned int tmp;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	result = ttusb_dec_send_command(dec, 0x08, 0, NULL, &c_length, c);
 	if (result)
@@ -400,7 +400,7 @@ static void ttusb_dec_set_pids(struct tt
 	u16 audio = htons(dec->pid[DMX_PES_AUDIO]);
 	u16 video = htons(dec->pid[DMX_PES_VIDEO]);
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	memcpy(&b[0], &pcr, 2);
 	memcpy(&b[2], &audio, 2);
@@ -419,12 +419,12 @@ static void ttusb_dec_set_pids(struct tt
 static void ttusb_dec_process_pva(struct ttusb_dec *dec, u8 *pva, int length)
 {
 	if (length < 8) {
-		printk("%s: packet too short - discarding\n", __FUNCTION__);
+		printk("%s: packet too short - discarding\n", __func__);
 		return;
 	}
 
 	if (length > 8 + MAX_PVA_LENGTH) {
-		printk("%s: packet too long - discarding\n", __FUNCTION__);
+		printk("%s: packet too long - discarding\n", __func__);
 		return;
 	}
 
@@ -507,7 +507,7 @@ static void ttusb_dec_process_pva(struct
 		break;
 
 	default:
-		printk("%s: unknown PVA type: %02x.\n", __FUNCTION__,
+		printk("%s: unknown PVA type: %02x.\n", __func__,
 		       pva[2]);
 		break;
 	}
@@ -546,7 +546,7 @@ static void ttusb_dec_process_packet(str
 	u16 packet_id;
 
 	if (dec->packet_length % 2) {
-		printk("%s: odd sized packet - discarding\n", __FUNCTION__);
+		printk("%s: odd sized packet - discarding\n", __func__);
 		return;
 	}
 
@@ -554,7 +554,7 @@ static void ttusb_dec_process_packet(str
 		csum ^= ((dec->packet[i] << 8) + dec->packet[i + 1]);
 
 	if (csum) {
-		printk("%s: checksum failed - discarding\n", __FUNCTION__);
+		printk("%s: checksum failed - discarding\n", __func__);
 		return;
 	}
 
@@ -563,7 +563,7 @@ static void ttusb_dec_process_packet(str
 
 	if ((packet_id != dec->next_packet_id) && dec->next_packet_id) {
 		printk("%s: warning: lost packets between %u and %u\n",
-		       __FUNCTION__, dec->next_packet_id - 1, packet_id);
+		       __func__, dec->next_packet_id - 1, packet_id);
 	}
 
 	if (packet_id == 0xffff)
@@ -652,7 +652,7 @@ static void ttusb_dec_process_urb_frame(
 					dec->packet_state = 7;
 				} else {
 					printk("%s: unknown packet type: "
-					       "%02x%02x\n", __FUNCTION__,
+					       "%02x%02x\n", __func__,
 					       dec->packet[0], dec->packet[1]);
 					dec->packet_state = 0;
 				}
@@ -724,7 +724,7 @@ static void ttusb_dec_process_urb_frame(
 
 		default:
 			printk("%s: illegal packet state encountered.\n",
-			       __FUNCTION__);
+			       __func__);
 			dec->packet_state = 0;
 		}
 	}
@@ -792,7 +792,7 @@ static void ttusb_dec_process_urb(struct
 	} else {
 		 /* -ENOENT is expected when unlinking urbs */
 		if (urb->status != -ENOENT)
-			dprintk("%s: urb error: %d\n", __FUNCTION__,
+			dprintk("%s: urb error: %d\n", __func__,
 				urb->status);
 	}
 
@@ -804,7 +804,7 @@ static void ttusb_dec_setup_urbs(struct 
 {
 	int i, j, buffer_offset = 0;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	for (i = 0; i < ISO_BUF_COUNT; i++) {
 		int frame_offset = 0;
@@ -834,7 +834,7 @@ static void ttusb_dec_stop_iso_xfer(stru
 {
 	int i;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	if (mutex_lock_interruptible(&dec->iso_mutex))
 		return;
@@ -889,7 +889,7 @@ static int ttusb_dec_start_iso_xfer(stru
 {
 	int i, result;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	if (mutex_lock_interruptible(&dec->iso_mutex))
 		return -EAGAIN;
@@ -905,7 +905,7 @@ static int ttusb_dec_start_iso_xfer(stru
 			if ((result = usb_submit_urb(dec->iso_urb[i],
 						     GFP_ATOMIC))) {
 				printk("%s: failed urb submission %d: "
-				       "error %d\n", __FUNCTION__, i, result);
+				       "error %d\n", __func__, i, result);
 
 				while (i) {
 					usb_kill_urb(dec->iso_urb[i - 1]);
@@ -932,7 +932,7 @@ static int ttusb_dec_start_ts_feed(struc
 	u8 b0[] = { 0x05 };
 	int result = 0;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	dprintk("  ts_type:");
 
@@ -1012,7 +1012,7 @@ static int ttusb_dec_start_sec_feed(stru
 	unsigned long flags;
 	u8 x = 1;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	pid = htons(dvbdmxfeed->pid);
 	memcpy(&b0[0], &pid, 2);
@@ -1052,7 +1052,7 @@ static int ttusb_dec_start_feed(struct d
 {
 	struct dvb_demux *dvbdmx = dvbdmxfeed->demux;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	if (!dvbdmx->dmx.frontend)
 		return -EINVAL;
@@ -1113,7 +1113,7 @@ static int ttusb_dec_stop_sec_feed(struc
 
 static int ttusb_dec_stop_feed(struct dvb_demux_feed *dvbdmxfeed)
 {
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	switch (dvbdmxfeed->type) {
 	case DMX_TYPE_TS:
@@ -1132,7 +1132,7 @@ static void ttusb_dec_free_iso_urbs(stru
 {
 	int i;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	for (i = 0; i < ISO_BUF_COUNT; i++)
 		usb_free_urb(dec->iso_urb[i]);
@@ -1147,7 +1147,7 @@ static int ttusb_dec_alloc_iso_urbs(stru
 {
 	int i;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	dec->iso_buffer = pci_alloc_consistent(NULL,
 					       ISO_FRAME_SIZE *
@@ -1214,7 +1214,7 @@ static int ttusb_init_rc( struct ttusb_d
 
 	dec->rc_input_dev = input_dev;
 	if (usb_submit_urb(dec->irq_urb, GFP_KERNEL))
-		printk("%s: usb_submit_urb failed\n",__FUNCTION__);
+		printk("%s: usb_submit_urb failed\n",__func__);
 	/* enable irq pipe */
 	ttusb_dec_send_command(dec,0xb0,sizeof(b),b,NULL,NULL);
 
@@ -1223,7 +1223,7 @@ static int ttusb_init_rc( struct ttusb_d
 
 static void ttusb_dec_init_v_pes(struct ttusb_dec *dec)
 {
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	dec->v_pes[0] = 0x00;
 	dec->v_pes[1] = 0x00;
@@ -1233,7 +1233,7 @@ static void ttusb_dec_init_v_pes(struct 
 
 static int ttusb_dec_init_usb(struct ttusb_dec *dec)
 {
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	mutex_init(&dec->usb_mutex);
 	mutex_init(&dec->iso_mutex);
@@ -1281,11 +1281,11 @@ static int ttusb_dec_boot_dsp(struct ttu
 	u32 crc32_csum, crc32_check, tmp;
 	const struct firmware *fw_entry = NULL;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	if (request_firmware(&fw_entry, dec->firmware_name, &dec->udev->dev)) {
 		printk(KERN_ERR "%s: Firmware (%s) unavailable.\n",
-		       __FUNCTION__, dec->firmware_name);
+		       __func__, dec->firmware_name);
 		return 1;
 	}
 
@@ -1294,7 +1294,7 @@ static int ttusb_dec_boot_dsp(struct ttu
 
 	if (firmware_size < 60) {
 		printk("%s: firmware size too small for DSP code (%zu < 60).\n",
-			__FUNCTION__, firmware_size);
+			__func__, firmware_size);
 		release_firmware(fw_entry);
 		return -1;
 	}
@@ -1308,7 +1308,7 @@ static int ttusb_dec_boot_dsp(struct ttu
 	if (crc32_csum != crc32_check) {
 		printk("%s: crc32 check of DSP code failed (calculated "
 		       "0x%08x != 0x%08x in file), file invalid.\n",
-			__FUNCTION__, crc32_csum, crc32_check);
+			__func__, crc32_csum, crc32_check);
 		release_firmware(fw_entry);
 		return -1;
 	}
@@ -1376,7 +1376,7 @@ static int ttusb_dec_init_stb(struct ttu
 	int result;
 	unsigned int mode, model, version;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	result = ttusb_dec_get_stb_state(dec, &mode, &model, &version);
 
@@ -1415,7 +1415,7 @@ static int ttusb_dec_init_stb(struct ttu
 			default:
 				printk(KERN_ERR "%s: unknown model returned "
 				       "by firmware (%08x) - please report\n",
-				       __FUNCTION__, model);
+				       __func__, model);
 				return -1;
 				break;
 			}
@@ -1434,12 +1434,12 @@ static int ttusb_dec_init_dvb(struct ttu
 {
 	int result;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	if ((result = dvb_register_adapter(&dec->adapter,
 					   dec->model_name, THIS_MODULE, &dec->udev->dev)) < 0) {
 		printk("%s: dvb_register_adapter failed: error %d\n",
-		       __FUNCTION__, result);
+		       __func__, result);
 
 		return result;
 	}
@@ -1454,7 +1454,7 @@ static int ttusb_dec_init_dvb(struct ttu
 	dec->demux.write_to_decoder = NULL;
 
 	if ((result = dvb_dmx_init(&dec->demux)) < 0) {
-		printk("%s: dvb_dmx_init failed: error %d\n", __FUNCTION__,
+		printk("%s: dvb_dmx_init failed: error %d\n", __func__,
 		       result);
 
 		dvb_unregister_adapter(&dec->adapter);
@@ -1468,7 +1468,7 @@ static int ttusb_dec_init_dvb(struct ttu
 
 	if ((result = dvb_dmxdev_init(&dec->dmxdev, &dec->adapter)) < 0) {
 		printk("%s: dvb_dmxdev_init failed: error %d\n",
-		       __FUNCTION__, result);
+		       __func__, result);
 
 		dvb_dmx_release(&dec->demux);
 		dvb_unregister_adapter(&dec->adapter);
@@ -1480,7 +1480,7 @@ static int ttusb_dec_init_dvb(struct ttu
 
 	if ((result = dec->demux.dmx.add_frontend(&dec->demux.dmx,
 						  &dec->frontend)) < 0) {
-		printk("%s: dvb_dmx_init failed: error %d\n", __FUNCTION__,
+		printk("%s: dvb_dmx_init failed: error %d\n", __func__,
 		       result);
 
 		dvb_dmxdev_release(&dec->dmxdev);
@@ -1492,7 +1492,7 @@ static int ttusb_dec_init_dvb(struct ttu
 
 	if ((result = dec->demux.dmx.connect_frontend(&dec->demux.dmx,
 						      &dec->frontend)) < 0) {
-		printk("%s: dvb_dmx_init failed: error %d\n", __FUNCTION__,
+		printk("%s: dvb_dmx_init failed: error %d\n", __func__,
 		       result);
 
 		dec->demux.dmx.remove_frontend(&dec->demux.dmx, &dec->frontend);
@@ -1510,7 +1510,7 @@ static int ttusb_dec_init_dvb(struct ttu
 
 static void ttusb_dec_exit_dvb(struct ttusb_dec *dec)
 {
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	dvb_net_release(&dec->dvb_net);
 	dec->demux.dmx.close(&dec->demux.dmx);
@@ -1528,7 +1528,7 @@ static void ttusb_dec_exit_dvb(struct tt
 static void ttusb_dec_exit_rc(struct ttusb_dec *dec)
 {
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 	/* we have to check whether the irq URB is already submitted.
 	  * As the irq is submitted after the interface is changed,
 	  * this is the best method i figured out.
@@ -1552,7 +1552,7 @@ static void ttusb_dec_exit_usb(struct tt
 {
 	int i;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	dec->iso_stream_count = 0;
 
@@ -1612,12 +1612,12 @@ static int ttusb_dec_probe(struct usb_in
 	struct usb_device *udev;
 	struct ttusb_dec *dec;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	udev = interface_to_usbdev(intf);
 
 	if (!(dec = kzalloc(sizeof(struct ttusb_dec), GFP_KERNEL))) {
-		printk("%s: couldn't allocate memory.\n", __FUNCTION__);
+		printk("%s: couldn't allocate memory.\n", __func__);
 		return -ENOMEM;
 	}
 
@@ -1692,7 +1692,7 @@ static void ttusb_dec_disconnect(struct 
 
 	usb_set_intfdata(intf, NULL);
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	if (dec->active) {
 		ttusb_dec_exit_tasklet(dec);
@@ -1749,7 +1749,7 @@ static int __init ttusb_dec_init(void)
 	int result;
 
 	if ((result = usb_register(&ttusb_dec_driver)) < 0) {
-		printk("%s: initialisation failed: error %d.\n", __FUNCTION__,
+		printk("%s: initialisation failed: error %d.\n", __func__,
 		       result);
 		return result;
 	}
diff -puN drivers/media/dvb/ttusb-dec/ttusbdecfe.c~v4l-dvb-replace-remaining-__function__-occurences drivers/media/dvb/ttusb-dec/ttusbdecfe.c
--- a/drivers/media/dvb/ttusb-dec/ttusbdecfe.c~v4l-dvb-replace-remaining-__function__-occurences
+++ a/drivers/media/dvb/ttusb-dec/ttusbdecfe.c
@@ -53,7 +53,7 @@ static int ttusbdecfe_read_status(struct
 		return ret;
 
 	if(len != 4) {
-		printk(KERN_ERR "%s: unexpected reply\n", __FUNCTION__);
+		printk(KERN_ERR "%s: unexpected reply\n", __func__);
 		return -EIO;
 	}
 
@@ -70,7 +70,7 @@ static int ttusbdecfe_read_status(struct
 			break;
 		default:
 			pr_info("%s: returned unknown value: %d\n",
-				__FUNCTION__, result[3]);
+				__func__, result[3]);
 			return -EIO;
 	}
 
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

git-x86.patch
git-alsa-tiwai.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
cifs-remove-global_extern-macro.patch
git-powerpc.patch
power-replace-remaining-__function__-occurrences.patch
git-dvb.patch
git-dlm.patch
git-ieee1394.patch
git-infiniband.patch
input-replace-remaining-__function__-occurrences.patch
git-jfs.patch
git-libata-all.patch
git-mips.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
mtd-replace-remaining-__function__-occurrences.patch
git-net.patch
blackfin-replace-remaining-__function__-occurences.patch
git-nfsd.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
git-selinux.patch
git-s390.patch
git-scsi-misc.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
block-replace-remaining-__function__-occurrences.patch
git-watchdog.patch
mac80211-tkipcc-michaelc-use-kernel-bit-rotation-helpers.patch
mac80211-tkipc-remove-opencoded-swab16-in-tkip_s.patch
mac80211-tkipc-eliminate-the-hi16-lo16-functions.patch
mac80211-tkipc-remove-mk16-hi8-lo8-helpers.patch
mac80211-michaelc-replace-macro-with-function.patch
mac80211-michaelc-use-unaligned-byteorder-helpers.patch
mac80211-michaelc-fold-initial-xor-into-block-helper.patch
xtensa-replace-remaining-__function__-occurences.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
smack-fix-integer-as-null-pointer-warning-in-smack_lsmc.patch
alpha-remove-remaining-__function__-occurences.patch
alpha-replace-__inline-with-inline.patch
m68k-replace-remaining-__function__-occurences.patch
uml-replace-remaining-__function__-occurences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
firmware-replace-remaining-__function__-occurrences.patch
drivers-misc-replace-remaining-__function__-occurrences.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
char-make-functions-static-in-synclinkmpc.patch
spi-replace-remaining-__function__-occurrences.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
isdn-replace-remaining-__function__-occurrences.patch
xen-make-blkif_getgeo-static.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
rtc-replace-remaining-__function__-occurrences.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
video-replace-remaining-__function__-occurrences.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch
md-replace-remaining-__function__-occurrences.patch
ext2-replace-remaining-__function__-occurrences.patch
ext3-replace-remaining-__function__-occurrences.patch
jbd-replace-remaining-__function__-occurrences.patch
ufs-replace-remaining-__function__-occurrences.patch
ufs-replace-__inline-with-inline.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
reiserfs-replace-remaining-__function__-occurrences.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
ext4-replace-remaining-__function__-occurrences.patch
jdb2-replace-remaining-__function__-occurrences.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
add-macros-similar-to-min-max-min_t-max_t.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
drivers-replace-remaining-__function__-occurrences.patch
kernel-add-common-infrastructure-for-unaligned-access.patch
kernel-move-arches-to-use-common-unaligned-access.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

