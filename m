From: akpm@linux-foundation.org
Subject: - v4l-video-replace-remaining-__function__-occurences.patch removed from -mm tree
Date: Tue, 15 Apr 2008 02:10:39 -0700
Message-ID: <200804150910.m3F9Adw3020647@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41797 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756362AbYDOJLS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 05:11:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     v4l: video/ replace remaining __FUNCTION__ occurences
has been removed from the -mm tree.  Its filename was
     v4l-video-replace-remaining-__function__-occurences.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: v4l: video/ replace remaining __FUNCTION__ occurences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/cpia.h                        |    4 
 drivers/media/video/cpia2/cpia2_core.c            |   12 -
 drivers/media/video/cpia_usb.c                    |    2 
 drivers/media/video/cx23885/cx23885-cards.c       |    2 
 drivers/media/video/cx23885/cx23885-core.c        |   98 ++++----
 drivers/media/video/cx23885/cx23885-dvb.c         |   10 
 drivers/media/video/cx23885/cx23885-i2c.c         |   16 -
 drivers/media/video/cx23885/cx23885-video.c       |   54 ++--
 drivers/media/video/cx88/cx88-alsa.c              |    2 
 drivers/media/video/cx88/cx88-blackbird.c         |    8 
 drivers/media/video/cx88/cx88-core.c              |    4 
 drivers/media/video/cx88/cx88-dvb.c               |   14 -
 drivers/media/video/cx88/cx88-mpeg.c              |   16 -
 drivers/media/video/cx88/cx88-tvaudio.c           |   24 +-
 drivers/media/video/em28xx/em28xx-audio.c         |    2 
 drivers/media/video/em28xx/em28xx-core.c          |    6 
 drivers/media/video/em28xx/em28xx-i2c.c           |    2 
 drivers/media/video/em28xx/em28xx-video.c         |    2 
 drivers/media/video/et61x251/et61x251.h           |    6 
 drivers/media/video/ir-kbd-i2c.c                  |    2 
 drivers/media/video/mt20xx.h                      |    2 
 drivers/media/video/mt9m001.c                     |    2 
 drivers/media/video/ov511.h                       |    2 
 drivers/media/video/ovcamchip/ovcamchip_priv.h    |    4 
 drivers/media/video/pvrusb2/pvrusb2-sysfs.c       |   20 -
 drivers/media/video/pwc/pwc-if.c                  |    6 
 drivers/media/video/pxa_camera.c                  |   28 +-
 drivers/media/video/saa7134/saa7134-empress.c     |    4 
 drivers/media/video/se401.c                       |    6 
 drivers/media/video/sn9c102/sn9c102.h             |    6 
 drivers/media/video/soc_camera.c                  |    8 
 drivers/media/video/stk-webcam.c                  |    2 
 drivers/media/video/stv680.c                      |    2 
 drivers/media/video/tcm825x.c                     |    2 
 drivers/media/video/tda8290.c                     |    6 
 drivers/media/video/tda8290.h                     |    4 
 drivers/media/video/tda9840.c                     |    2 
 drivers/media/video/tda9887.h                     |    2 
 drivers/media/video/tea5761.h                     |    4 
 drivers/media/video/tea5767.h                     |    4 
 drivers/media/video/tea6415c.c                    |    2 
 drivers/media/video/tea6420.c                     |    2 
 drivers/media/video/tuner-simple.c                |    2 
 drivers/media/video/tuner-simple.h                |    2 
 drivers/media/video/tuner-xc2028.c                |   28 +-
 drivers/media/video/tuner-xc2028.h                |    2 
 drivers/media/video/usbvideo/konicawc.c           |    2 
 drivers/media/video/usbvideo/quickcam_messenger.c |    2 
 drivers/media/video/usbvideo/usbvideo.c           |  140 ++++++------
 drivers/media/video/usbvideo/vicam.c              |    2 
 drivers/media/video/videobuf-core.c               |    2 
 drivers/media/video/videobuf-dma-sg.c             |    4 
 drivers/media/video/videobuf-vmalloc.c            |    2 
 drivers/media/video/videodev.c                    |    4 
 drivers/media/video/vivi.c                        |   22 -
 drivers/media/video/w9966.c                       |    2 
 drivers/media/video/w9968cf.h                     |    6 
 drivers/media/video/zc0301/zc0301.h               |    6 
 drivers/media/video/zoran_driver.c                |    4 
 59 files changed, 319 insertions(+), 319 deletions(-)

diff -puN drivers/media/video/cpia.h~v4l-video-replace-remaining-__function__-occurences drivers/media/video/cpia.h
--- a/drivers/media/video/cpia.h~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/cpia.h
@@ -412,11 +412,11 @@ void cpia_unregister_camera(struct cam_d
 /* ErrorCode */
 #define ERROR_FLICKER_BELOW_MIN_EXP     0x01 /*flicker exposure got below minimum exposure */
 #define ALOG(fmt,args...) printk(fmt, ##args)
-#define LOG(fmt,args...) ALOG(KERN_INFO __FILE__ ":%s(%d):" fmt, __FUNCTION__ , __LINE__ , ##args)
+#define LOG(fmt,args...) ALOG(KERN_INFO __FILE__ ":%s(%d):" fmt, __func__ , __LINE__ , ##args)
 
 #ifdef _CPIA_DEBUG_
 #define ADBG(fmt,args...) printk(fmt, jiffies, ##args)
-#define DBG(fmt,args...) ADBG(KERN_DEBUG __FILE__" (%ld):%s(%d):" fmt, __FUNCTION__, __LINE__ , ##args)
+#define DBG(fmt,args...) ADBG(KERN_DEBUG __FILE__" (%ld):%s(%d):" fmt, __func__, __LINE__ , ##args)
 #else
 #define DBG(fmn,args...) do {} while(0)
 #endif
diff -puN drivers/media/video/cpia2/cpia2_core.c~v4l-video-replace-remaining-__function__-occurences drivers/media/video/cpia2/cpia2_core.c
--- a/drivers/media/video/cpia2/cpia2_core.c~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/cpia2/cpia2_core.c
@@ -570,7 +570,7 @@ int cpia2_send_command(struct camera_dat
 			    block_name[block_index]);
 		break;
 	default:
-		LOG("%s: invalid request mode\n",__FUNCTION__);
+		LOG("%s: invalid request mode\n",__func__);
 		return -EINVAL;
 	}
 
@@ -952,7 +952,7 @@ static int set_default_user_mode(struct 
 			frame_rate = CPIA2_VP_FRAMERATE_30;
 		break;
 	default:
-		LOG("%s: Invalid sensor flag value 0x%0X\n",__FUNCTION__,
+		LOG("%s: Invalid sensor flag value 0x%0X\n",__func__,
 		    cam->params.version.sensor_flags);
 		return -EINVAL;
 	}
@@ -2356,12 +2356,12 @@ long cpia2_read(struct camera_data *cam,
 	}
 
 	if (!buf) {
-		ERR("%s: buffer NULL\n",__FUNCTION__);
+		ERR("%s: buffer NULL\n",__func__);
 		return -EINVAL;
 	}
 
 	if (!cam) {
-		ERR("%s: Internal error, camera_data NULL!\n",__FUNCTION__);
+		ERR("%s: Internal error, camera_data NULL!\n",__func__);
 		return -EINVAL;
 	}
 
@@ -2370,7 +2370,7 @@ long cpia2_read(struct camera_data *cam,
 		return -ERESTARTSYS;
 
 	if (!cam->present) {
-		LOG("%s: camera removed\n",__FUNCTION__);
+		LOG("%s: camera removed\n",__func__);
 		mutex_unlock(&cam->busy_lock);
 		return 0;	/* EOF */
 	}
@@ -2434,7 +2434,7 @@ unsigned int cpia2_poll(struct camera_da
 	unsigned int status=0;
 
 	if(!cam) {
-		ERR("%s: Internal error, camera_data not found!\n",__FUNCTION__);
+		ERR("%s: Internal error, camera_data not found!\n",__func__);
 		return POLLERR;
 	}
 
diff -puN drivers/media/video/cpia_usb.c~v4l-video-replace-remaining-__function__-occurences drivers/media/video/cpia_usb.c
--- a/drivers/media/video/cpia_usb.c~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/cpia_usb.c
@@ -170,7 +170,7 @@ static void cpia_usb_complete(struct urb
 	/* resubmit */
 	urb->dev = ucpia->dev;
 	if ((i = usb_submit_urb(urb, GFP_ATOMIC)) != 0)
-		printk(KERN_ERR "%s: usb_submit_urb ret %d\n", __FUNCTION__,  i);
+		printk(KERN_ERR "%s: usb_submit_urb ret %d\n", __func__,  i);
 }
 
 static int cpia_usb_open(void *privdata)
diff -puN drivers/media/video/cx23885/cx23885-cards.c~v4l-video-replace-remaining-__function__-occurences drivers/media/video/cx23885/cx23885-cards.c
--- a/drivers/media/video/cx23885/cx23885-cards.c~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/cx23885/cx23885-cards.c
@@ -264,7 +264,7 @@ int cx23885_tuner_callback(void *priv, i
 		}
 		else {
 			printk(KERN_ERR
-				"%s(): Unknow command.\n", __FUNCTION__);
+				"%s(): Unknow command.\n", __func__);
 			return -EINVAL;
 		}
 		break;
diff -puN drivers/media/video/cx23885/cx23885-core.c~v4l-video-replace-remaining-__function__-occurences drivers/media/video/cx23885/cx23885-core.c
--- a/drivers/media/video/cx23885/cx23885-core.c~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/cx23885/cx23885-core.c
@@ -260,7 +260,7 @@ void cx23885_wakeup(struct cx23885_tspor
 	}
 	if (bc != 1)
 		printk("%s: %d buffers handled (should be 1)\n",
-		       __FUNCTION__, bc);
+		       __func__, bc);
 }
 
 int cx23885_sram_channel_setup(struct cx23885_dev *dev,
@@ -272,7 +272,7 @@ int cx23885_sram_channel_setup(struct cx
 
 	if (ch->cmds_start == 0)
 	{
-		dprintk(1, "%s() Erasing channel [%s]\n", __FUNCTION__,
+		dprintk(1, "%s() Erasing channel [%s]\n", __func__,
 			ch->name);
 		cx_write(ch->ptr1_reg, 0);
 		cx_write(ch->ptr2_reg, 0);
@@ -280,7 +280,7 @@ int cx23885_sram_channel_setup(struct cx
 		cx_write(ch->cnt1_reg, 0);
 		return 0;
 	} else {
-		dprintk(1, "%s() Configuring channel [%s]\n", __FUNCTION__,
+		dprintk(1, "%s() Configuring channel [%s]\n", __func__,
 			ch->name);
 	}
 
@@ -297,7 +297,7 @@ int cx23885_sram_channel_setup(struct cx
 
 	/* write CDT */
 	for (i = 0; i < lines; i++) {
-		dprintk(2, "%s() 0x%08x <- 0x%08x\n", __FUNCTION__, cdt + 16*i,
+		dprintk(2, "%s() 0x%08x <- 0x%08x\n", __func__, cdt + 16*i,
 			ch->fifo_start + bpl*i);
 		cx_write(cdt + 16*i, ch->fifo_start + bpl*i);
 		cx_write(cdt + 16*i +  4, 0);
@@ -449,7 +449,7 @@ static void cx23885_shutdown(struct cx23
 
 static void cx23885_reset(struct cx23885_dev *dev)
 {
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 
 	cx23885_shutdown(dev);
 
@@ -482,7 +482,7 @@ static void cx23885_reset(struct cx23885
 
 static int cx23885_pci_quirks(struct cx23885_dev *dev)
 {
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 
 	/* The cx23885 bridge has a weird bug which causes NMI to be asserted
 	 * when DMA begins if RDR_TLCTL0 bit4 is not cleared. It does not
@@ -513,7 +513,7 @@ int cx23885_risc_stopper(struct pci_dev 
 
 static int cx23885_init_tsport(struct cx23885_dev *dev, struct cx23885_tsport *port, int portno)
 {
-	dprintk(1, "%s(portno=%d)\n", __FUNCTION__, portno);
+	dprintk(1, "%s(portno=%d)\n", __func__, portno);
 
 	/* Transport bus init dma queue  - Common settings */
 	port->dma_ctl_val        = 0x11; /* Enable RISC controller and Fifo */
@@ -604,14 +604,14 @@ static void cx23885_dev_checkrevision(st
 		break;
 	default:
 		printk(KERN_ERR "%s() New hardware revision found 0x%x\n",
-			__FUNCTION__, dev->hwrevision);
+			__func__, dev->hwrevision);
 	}
 	if (dev->hwrevision)
 		printk(KERN_INFO "%s() Hardware revision = 0x%02x\n",
-			__FUNCTION__, dev->hwrevision);
+			__func__, dev->hwrevision);
 	else
 		printk(KERN_ERR "%s() Hardware revision unknown 0x%x\n",
-			__FUNCTION__, dev->hwrevision);
+			__func__, dev->hwrevision);
 }
 
 static int cx23885_dev_setup(struct cx23885_dev *dev)
@@ -644,7 +644,7 @@ static int cx23885_dev_setup(struct cx23
 		BUG();
 
 	dprintk(1, "%s() Memory configured for PCIe bridge type %d\n",
-		__FUNCTION__, dev->bridge);
+		__func__, dev->bridge);
 
 	/* board config */
 	dev->board = UNSET;
@@ -734,9 +734,9 @@ static int cx23885_dev_setup(struct cx23
 	dev->radio_addr = cx23885_boards[dev->board].radio_addr;
 
 	dprintk(1, "%s() tuner_type = 0x%x tuner_addr = 0x%x\n",
-		__FUNCTION__, dev->tuner_type, dev->tuner_addr);
+		__func__, dev->tuner_type, dev->tuner_addr);
 	dprintk(1, "%s() radio_type = 0x%x radio_addr = 0x%x\n",
-		__FUNCTION__, dev->radio_type, dev->radio_addr);
+		__func__, dev->radio_type, dev->radio_addr);
 
 	/* init hardware */
 	cx23885_reset(dev);
@@ -751,21 +751,21 @@ static int cx23885_dev_setup(struct cx23
 	if (cx23885_boards[dev->board].porta == CX23885_ANALOG_VIDEO) {
 		if (cx23885_video_register(dev) < 0) {
 			printk(KERN_ERR "%s() Failed to register analog "
-				"video adapters on VID_A\n", __FUNCTION__);
+				"video adapters on VID_A\n", __func__);
 		}
 	}
 
 	if (cx23885_boards[dev->board].portb == CX23885_MPEG_DVB) {
 		if (cx23885_dvb_register(&dev->ts1) < 0) {
 			printk(KERN_ERR "%s() Failed to register dvb adapters on VID_B\n",
-			       __FUNCTION__);
+			       __func__);
 		}
 	}
 
 	if (cx23885_boards[dev->board].portc == CX23885_MPEG_DVB) {
 		if (cx23885_dvb_register(&dev->ts2) < 0) {
 			printk(KERN_ERR "%s() Failed to register dvb adapters on VID_C\n",
-			       __FUNCTION__);
+			       __func__);
 		}
 	}
 
@@ -960,50 +960,50 @@ static void cx23885_tsport_reg_dump(stru
 {
 	struct cx23885_dev *dev = port->dev;
 
-	dprintk(1, "%s() Register Dump\n", __FUNCTION__);
-	dprintk(1, "%s() DEV_CNTRL2               0x%08X\n", __FUNCTION__,
+	dprintk(1, "%s() Register Dump\n", __func__);
+	dprintk(1, "%s() DEV_CNTRL2               0x%08X\n", __func__,
 		cx_read(DEV_CNTRL2));
-	dprintk(1, "%s() PCI_INT_MSK              0x%08X\n", __FUNCTION__,
+	dprintk(1, "%s() PCI_INT_MSK              0x%08X\n", __func__,
 		cx_read(PCI_INT_MSK));
-	dprintk(1, "%s() AUD_INT_INT_MSK          0x%08X\n", __FUNCTION__,
+	dprintk(1, "%s() AUD_INT_INT_MSK          0x%08X\n", __func__,
 		cx_read(AUDIO_INT_INT_MSK));
-	dprintk(1, "%s() AUD_INT_DMA_CTL          0x%08X\n", __FUNCTION__,
+	dprintk(1, "%s() AUD_INT_DMA_CTL          0x%08X\n", __func__,
 		cx_read(AUD_INT_DMA_CTL));
-	dprintk(1, "%s() AUD_EXT_INT_MSK          0x%08X\n", __FUNCTION__,
+	dprintk(1, "%s() AUD_EXT_INT_MSK          0x%08X\n", __func__,
 		cx_read(AUDIO_EXT_INT_MSK));
-	dprintk(1, "%s() AUD_EXT_DMA_CTL          0x%08X\n", __FUNCTION__,
+	dprintk(1, "%s() AUD_EXT_DMA_CTL          0x%08X\n", __func__,
 		cx_read(AUD_EXT_DMA_CTL));
-	dprintk(1, "%s() PAD_CTRL                 0x%08X\n", __FUNCTION__,
+	dprintk(1, "%s() PAD_CTRL                 0x%08X\n", __func__,
 		cx_read(PAD_CTRL));
-	dprintk(1, "%s() ALT_PIN_OUT_SEL          0x%08X\n", __FUNCTION__,
+	dprintk(1, "%s() ALT_PIN_OUT_SEL          0x%08X\n", __func__,
 		cx_read(ALT_PIN_OUT_SEL));
-	dprintk(1, "%s() GPIO2                    0x%08X\n", __FUNCTION__,
+	dprintk(1, "%s() GPIO2                    0x%08X\n", __func__,
 		cx_read(GPIO2));
-	dprintk(1, "%s() gpcnt(0x%08X)          0x%08X\n", __FUNCTION__,
+	dprintk(1, "%s() gpcnt(0x%08X)          0x%08X\n", __func__,
 		port->reg_gpcnt, cx_read(port->reg_gpcnt));
-	dprintk(1, "%s() gpcnt_ctl(0x%08X)      0x%08x\n", __FUNCTION__,
+	dprintk(1, "%s() gpcnt_ctl(0x%08X)      0x%08x\n", __func__,
 		port->reg_gpcnt_ctl, cx_read(port->reg_gpcnt_ctl));
-	dprintk(1, "%s() dma_ctl(0x%08X)        0x%08x\n", __FUNCTION__,
+	dprintk(1, "%s() dma_ctl(0x%08X)        0x%08x\n", __func__,
 		port->reg_dma_ctl, cx_read(port->reg_dma_ctl));
-	dprintk(1, "%s() src_sel(0x%08X)        0x%08x\n", __FUNCTION__,
+	dprintk(1, "%s() src_sel(0x%08X)        0x%08x\n", __func__,
 		port->reg_src_sel, cx_read(port->reg_src_sel));
-	dprintk(1, "%s() lngth(0x%08X)          0x%08x\n", __FUNCTION__,
+	dprintk(1, "%s() lngth(0x%08X)          0x%08x\n", __func__,
 		port->reg_lngth, cx_read(port->reg_lngth));
-	dprintk(1, "%s() hw_sop_ctrl(0x%08X)    0x%08x\n", __FUNCTION__,
+	dprintk(1, "%s() hw_sop_ctrl(0x%08X)    0x%08x\n", __func__,
 		port->reg_hw_sop_ctrl, cx_read(port->reg_hw_sop_ctrl));
-	dprintk(1, "%s() gen_ctrl(0x%08X)       0x%08x\n", __FUNCTION__,
+	dprintk(1, "%s() gen_ctrl(0x%08X)       0x%08x\n", __func__,
 		port->reg_gen_ctrl, cx_read(port->reg_gen_ctrl));
-	dprintk(1, "%s() bd_pkt_status(0x%08X)  0x%08x\n", __FUNCTION__,
+	dprintk(1, "%s() bd_pkt_status(0x%08X)  0x%08x\n", __func__,
 		port->reg_bd_pkt_status, cx_read(port->reg_bd_pkt_status));
-	dprintk(1, "%s() sop_status(0x%08X)     0x%08x\n", __FUNCTION__,
+	dprintk(1, "%s() sop_status(0x%08X)     0x%08x\n", __func__,
 		port->reg_sop_status, cx_read(port->reg_sop_status));
-	dprintk(1, "%s() fifo_ovfl_stat(0x%08X) 0x%08x\n", __FUNCTION__,
+	dprintk(1, "%s() fifo_ovfl_stat(0x%08X) 0x%08x\n", __func__,
 		port->reg_fifo_ovfl_stat, cx_read(port->reg_fifo_ovfl_stat));
-	dprintk(1, "%s() vld_misc(0x%08X)       0x%08x\n", __FUNCTION__,
+	dprintk(1, "%s() vld_misc(0x%08X)       0x%08x\n", __func__,
 		port->reg_vld_misc, cx_read(port->reg_vld_misc));
-	dprintk(1, "%s() ts_clk_en(0x%08X)      0x%08x\n", __FUNCTION__,
+	dprintk(1, "%s() ts_clk_en(0x%08X)      0x%08x\n", __func__,
 		port->reg_ts_clk_en, cx_read(port->reg_ts_clk_en));
-	dprintk(1, "%s() ts_int_msk(0x%08X)     0x%08x\n", __FUNCTION__,
+	dprintk(1, "%s() ts_int_msk(0x%08X)     0x%08x\n", __func__,
 		port->reg_ts_int_msk, cx_read(port->reg_ts_int_msk));
 }
 
@@ -1013,7 +1013,7 @@ static int cx23885_start_dma(struct cx23
 {
 	struct cx23885_dev *dev = port->dev;
 
-	dprintk(1, "%s() w: %d, h: %d, f: %d\n", __FUNCTION__,
+	dprintk(1, "%s() w: %d, h: %d, f: %d\n", __func__,
 		buf->vb.width, buf->vb.height, buf->vb.field);
 
 	/* setup fifo + format */
@@ -1031,7 +1031,7 @@ static int cx23885_start_dma(struct cx23
 	if ( (!(cx23885_boards[dev->board].portb & CX23885_MPEG_DVB)) &&
 		(!(cx23885_boards[dev->board].portc & CX23885_MPEG_DVB)) ) {
 		printk( "%s() Failed. Unsupported value in .portb/c (0x%08x)/(0x%08x)\n",
-			__FUNCTION__,
+			__func__,
 			cx23885_boards[dev->board].portb,
 			cx23885_boards[dev->board].portc );
 		return -EINVAL;
@@ -1058,7 +1058,7 @@ static int cx23885_start_dma(struct cx23
 	case CX23885_BRIDGE_885:
 	case CX23885_BRIDGE_887:
 		/* enable irqs */
-		dprintk(1, "%s() enabling TS int's and DMA\n", __FUNCTION__ );
+		dprintk(1, "%s() enabling TS int's and DMA\n", __func__ );
 		cx_set(port->reg_ts_int_msk,  port->ts_int_msk_val);
 		cx_set(port->reg_dma_ctl, port->dma_ctl_val);
 		cx_set(PCI_INT_MSK, dev->pci_irqmask | port->pci_irqmask);
@@ -1078,7 +1078,7 @@ static int cx23885_start_dma(struct cx23
 static int cx23885_stop_dma(struct cx23885_tsport *port)
 {
 	struct cx23885_dev *dev = port->dev;
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 
 	/* Stop interrupts and DMA */
 	cx_clear(port->reg_ts_int_msk, port->ts_int_msk_val);
@@ -1093,13 +1093,13 @@ int cx23885_restart_queue(struct cx23885
 	struct cx23885_dev *dev = port->dev;
 	struct cx23885_buffer *buf;
 
-	dprintk(5, "%s()\n", __FUNCTION__);
+	dprintk(5, "%s()\n", __func__);
 	if (list_empty(&q->active))
 	{
 		struct cx23885_buffer *prev;
 		prev = NULL;
 
-		dprintk(5, "%s() queue is empty\n", __FUNCTION__);
+		dprintk(5, "%s() queue is empty\n", __func__);
 
 		for (;;) {
 			if (list_empty(&q->queued))
@@ -1154,7 +1154,7 @@ int cx23885_buf_prepare(struct videobuf_
 	int size = port->ts_packet_size * port->ts_packet_count;
 	int rc;
 
-	dprintk(1, "%s: %p\n", __FUNCTION__, buf);
+	dprintk(1, "%s: %p\n", __func__, buf);
 	if (0 != buf->vb.baddr  &&  buf->vb.bsize < size)
 		return -EINVAL;
 
@@ -1197,7 +1197,7 @@ void cx23885_buf_queue(struct cx23885_ts
 		buf->count    = cx88q->count++;
 		mod_timer(&cx88q->timeout, jiffies + BUFFER_TIMEOUT);
 		dprintk(1, "[%p/%d] %s - first active\n",
-			buf, buf->vb.i, __FUNCTION__);
+			buf, buf->vb.i, __func__);
 	} else {
 		dprintk( 1, "queue is not empty - append to active\n" );
 		prev = list_entry(cx88q->active.prev, struct cx23885_buffer,
@@ -1208,7 +1208,7 @@ void cx23885_buf_queue(struct cx23885_ts
 		prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
 		prev->risc.jmp[2] = cpu_to_le32(0); /* 64 bit bits 63-32 */
 		dprintk( 1, "[%p/%d] %s - append to active\n",
-			 buf, buf->vb.i, __FUNCTION__);
+			 buf, buf->vb.i, __func__);
 	}
 }
 
@@ -1245,7 +1245,7 @@ static void cx23885_timeout(unsigned lon
 	struct cx23885_tsport *port = (struct cx23885_tsport *)data;
 	struct cx23885_dev *dev = port->dev;
 
-	dprintk(1, "%s()\n",__FUNCTION__);
+	dprintk(1, "%s()\n",__func__);
 
 	if (debug > 5)
 		cx23885_sram_channel_dump(dev, &dev->sram_channels[ port->sram_chno ]);
diff -puN drivers/media/video/cx23885/cx23885-dvb.c~v4l-video-replace-remaining-__function__-occurences drivers/media/video/cx23885/cx23885-dvb.c
--- a/drivers/media/video/cx23885/cx23885-dvb.c~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/cx23885/cx23885-dvb.c
@@ -185,7 +185,7 @@ static int cx23885_hvr1500_xc3028_callba
 	case XC2028_TUNER_RESET:
 		/* Send the tuner in then out of reset */
 		/* GPIO-2 xc3028 tuner */
-		dprintk(1, "%s: XC2028_TUNER_RESET %d\n", __FUNCTION__, arg);
+		dprintk(1, "%s: XC2028_TUNER_RESET %d\n", __func__, arg);
 
 		cx_set(GP0_IO, 0x00040000);
 		cx_clear(GP0_IO, 0x00000004);
@@ -195,10 +195,10 @@ static int cx23885_hvr1500_xc3028_callba
 		msleep(5);
 		break;
 	case XC2028_RESET_CLK:
-		dprintk(1, "%s: XC2028_RESET_CLK %d\n", __FUNCTION__, arg);
+		dprintk(1, "%s: XC2028_RESET_CLK %d\n", __func__, arg);
 		break;
 	default:
-		dprintk(1, "%s: unknown command %d, arg %d\n", __FUNCTION__,
+		dprintk(1, "%s: unknown command %d, arg %d\n", __func__,
 			command, arg);
 		return -EINVAL;
 	}
@@ -341,7 +341,7 @@ int cx23885_dvb_register(struct cx23885_
 	struct cx23885_dev *dev = port->dev;
 	int err;
 
-	dprintk(1, "%s\n", __FUNCTION__);
+	dprintk(1, "%s\n", __func__);
 	dprintk(1, " ->being probed by Card=%d Name=%s, PCI %02x:%02x\n",
 		dev->board,
 		dev->name,
@@ -357,7 +357,7 @@ int cx23885_dvb_register(struct cx23885_
 			    sizeof(struct cx23885_buffer), port);
 	err = dvb_register(port);
 	if (err != 0)
-		printk("%s() dvb_register failed err = %d\n", __FUNCTION__, err);
+		printk("%s() dvb_register failed err = %d\n", __func__, err);
 
 	return err;
 }
diff -puN drivers/media/video/cx23885/cx23885-i2c.c~v4l-video-replace-remaining-__function__-occurences drivers/media/video/cx23885/cx23885-i2c.c
--- a/drivers/media/video/cx23885/cx23885-i2c.c~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/cx23885/cx23885-i2c.c
@@ -87,10 +87,10 @@ static int i2c_sendbytes(struct i2c_adap
 	int retval, cnt;
 
 	if (joined_rlen)
-		dprintk(1, "%s(msg->wlen=%d, nextmsg->rlen=%d)\n", __FUNCTION__,
+		dprintk(1, "%s(msg->wlen=%d, nextmsg->rlen=%d)\n", __func__,
 			msg->len, joined_rlen);
 	else
-		dprintk(1, "%s(msg->len=%d)\n", __FUNCTION__, msg->len);
+		dprintk(1, "%s(msg->len=%d)\n", __func__, msg->len);
 
 	/* Deal with i2c probe functions with zero payload */
 	if (msg->len == 0) {
@@ -101,7 +101,7 @@ static int i2c_sendbytes(struct i2c_adap
 		if (!i2c_slave_did_ack(i2c_adap))
 			return -EIO;
 
-		dprintk(1, "%s() returns 0\n", __FUNCTION__);
+		dprintk(1, "%s() returns 0\n", __func__);
 		return 0;
 	}
 
@@ -176,7 +176,7 @@ static int i2c_readbytes(struct i2c_adap
 
 
 	if (i2c_debug && !joined)
-		dprintk(1, "%s(msg->len=%d)\n", __FUNCTION__, msg->len);
+		dprintk(1, "%s(msg->len=%d)\n", __func__, msg->len);
 
 	/* Deal with i2c probe functions with zero payload */
 	if (msg->len == 0) {
@@ -188,7 +188,7 @@ static int i2c_readbytes(struct i2c_adap
 			return -EIO;
 
 
-		dprintk(1, "%s() returns 0\n", __FUNCTION__);
+		dprintk(1, "%s() returns 0\n", __func__);
 		return 0;
 	}
 
@@ -238,11 +238,11 @@ static int i2c_xfer(struct i2c_adapter *
 	struct cx23885_dev *dev = bus->dev;
 	int i, retval = 0;
 
-	dprintk(1, "%s(num = %d)\n", __FUNCTION__, num);
+	dprintk(1, "%s(num = %d)\n", __func__, num);
 
 	for (i = 0 ; i < num; i++) {
 		dprintk(1, "%s(num = %d) addr = 0x%02x  len = 0x%x\n",
-			__FUNCTION__, num, msgs[i].addr, msgs[i].len);
+			__func__, num, msgs[i].addr, msgs[i].len);
 		if (msgs[i].flags & I2C_M_RD) {
 			/* read */
 			retval = i2c_readbytes(i2c_adap, &msgs[i], 0);
@@ -383,7 +383,7 @@ int cx23885_i2c_register(struct cx23885_
 {
 	struct cx23885_dev *dev = bus->dev;
 
-	dprintk(1, "%s(bus = %d)\n", __FUNCTION__, bus->nr);
+	dprintk(1, "%s(bus = %d)\n", __func__, bus->nr);
 
 	memcpy(&bus->i2c_adap, &cx23885_i2c_adap_template,
 	       sizeof(bus->i2c_adap));
diff -puN drivers/media/video/cx23885/cx23885-video.c~v4l-video-replace-remaining-__function__-occurences drivers/media/video/cx23885/cx23885-video.c
--- a/drivers/media/video/cx23885/cx23885-video.c~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/cx23885/cx23885-video.c
@@ -141,7 +141,7 @@ static struct cx23885_fmt *format_by_fou
 		if (formats[i].fourcc == fourcc)
 			return formats+i;
 
-	printk(KERN_ERR "%s(0x%08x) NOT FOUND\n", __FUNCTION__, fourcc);
+	printk(KERN_ERR "%s(0x%08x) NOT FOUND\n", __func__, fourcc);
 	return NULL;
 }
 
@@ -292,13 +292,13 @@ void cx23885_video_wakeup(struct cx23885
 	}
 	if (bc != 1)
 		printk(KERN_ERR "%s: %d buffers handled (should be 1)\n",
-			__FUNCTION__, bc);
+			__func__, bc);
 }
 
 int cx23885_set_tvnorm(struct cx23885_dev *dev, v4l2_std_id norm)
 {
 	dprintk(1, "%s(norm = 0x%08x) name: [%s]\n",
-		__FUNCTION__,
+		__func__,
 		(unsigned int)norm,
 		v4l2_norm_to_name(norm));
 
@@ -319,7 +319,7 @@ struct video_device *cx23885_vdev_init(s
 				    char *type)
 {
 	struct video_device *vfd;
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 
 	vfd = video_device_alloc();
 	if (NULL == vfd)
@@ -358,7 +358,7 @@ EXPORT_SYMBOL(cx23885_ctrl_query);
 static int res_get(struct cx23885_dev *dev, struct cx23885_fh *fh,
 	unsigned int bit)
 {
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 	if (fh->resources & bit)
 		/* have it already allocated */
 		return 1;
@@ -392,7 +392,7 @@ static void res_free(struct cx23885_dev 
 	unsigned int bits)
 {
 	BUG_ON((fh->resources & bits) != bits);
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 
 	mutex_lock(&dev->lock);
 	fh->resources  &= ~bits;
@@ -407,7 +407,7 @@ int cx23885_video_mux(struct cx23885_dev
 	memset(&route, 0, sizeof(route));
 
 	dprintk(1, "%s() video_mux: %d [vmux=%d, gpio=0x%x,0x%x,0x%x,0x%x]\n",
-		__FUNCTION__,
+		__func__,
 		input, INPUT(input)->vmux,
 		INPUT(input)->gpio0, INPUT(input)->gpio1,
 		INPUT(input)->gpio2, INPUT(input)->gpio3);
@@ -427,7 +427,7 @@ EXPORT_SYMBOL(cx23885_video_mux);
 int cx23885_set_scale(struct cx23885_dev *dev, unsigned int width,
 	unsigned int height, enum v4l2_field field)
 {
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 	return 0;
 }
 
@@ -435,7 +435,7 @@ static int cx23885_start_video_dma(struc
 			   struct cx23885_dmaqueue *q,
 			   struct cx23885_buffer *buf)
 {
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 
 	/* setup fifo + format */
 	cx23885_sram_channel_setup(dev, &dev->sram_channels[SRAM_CH01],
@@ -463,7 +463,7 @@ static int cx23885_restart_video_queue(s
 {
 	struct cx23885_buffer *buf, *prev;
 	struct list_head *item;
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 
 	if (!list_empty(&q->active)) {
 		buf = list_entry(q->active.next, struct cx23885_buffer,
@@ -579,13 +579,13 @@ static int buffer_prepare(struct videobu
 			if (dev->tvnorm & V4L2_STD_NTSC) {
 				/* cx25840 transmits NTSC bottom field first */
 				dprintk(1, "%s() Creating NTSC risc\n",
-					__FUNCTION__);
+					__func__);
 				line0_offset = buf->bpl;
 				line1_offset = 0;
 			} else {
 				/* All other formats are top field first */
 				dprintk(1, "%s() Creating PAL/SECAM risc\n",
-					__FUNCTION__);
+					__func__);
 				line0_offset = 0;
 				line1_offset = buf->bpl;
 			}
@@ -885,7 +885,7 @@ static int video_mmap(struct file *file,
 
 int cx23885_get_control(struct cx23885_dev *dev, struct v4l2_control *ctl)
 {
-	dprintk(1, "%s() calling cx25840(VIDIOC_G_CTRL)\n", __FUNCTION__);
+	dprintk(1, "%s() calling cx25840(VIDIOC_G_CTRL)\n", __func__);
 	cx23885_call_i2c_clients(&dev->i2c_bus[2], VIDIOC_G_CTRL, ctl);
 	return 0;
 }
@@ -894,7 +894,7 @@ EXPORT_SYMBOL(cx23885_get_control);
 int cx23885_set_control(struct cx23885_dev *dev, struct v4l2_control *ctl)
 {
 	dprintk(1, "%s() calling cx25840(VIDIOC_S_CTRL)"
-		" (disabled - no action)\n", __FUNCTION__);
+		" (disabled - no action)\n", __func__);
 	return 0;
 }
 EXPORT_SYMBOL(cx23885_set_control);
@@ -990,7 +990,7 @@ static int vidioc_s_fmt_cap(struct file 
 	struct cx23885_dev *dev  = ((struct cx23885_fh *)priv)->dev;
 	int err;
 
-	dprintk(2, "%s()\n", __FUNCTION__);
+	dprintk(2, "%s()\n", __func__);
 	err = vidioc_try_fmt_cap(file, priv, f);
 
 	if (0 != err)
@@ -999,7 +999,7 @@ static int vidioc_s_fmt_cap(struct file 
 	fh->width      = f->fmt.pix.width;
 	fh->height     = f->fmt.pix.height;
 	fh->vidq.field = f->fmt.pix.field;
-	dprintk(2, "%s() width=%d height=%d field=%d\n", __FUNCTION__,
+	dprintk(2, "%s() width=%d height=%d field=%d\n", __func__,
 		fh->width, fh->height, fh->vidq.field);
 	cx23885_call_i2c_clients(&dev->i2c_bus[2], VIDIOC_S_FMT, f);
 	return 0;
@@ -1101,7 +1101,7 @@ static int vidioc_streamon(struct file *
 {
 	struct cx23885_fh *fh = priv;
 	struct cx23885_dev *dev = fh->dev;
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 
 	if (unlikely(fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE))
 		return -EINVAL;
@@ -1118,7 +1118,7 @@ static int vidioc_streamoff(struct file 
 	struct cx23885_fh *fh = priv;
 	struct cx23885_dev *dev = fh->dev;
 	int err, res;
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 
 	if (fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
@@ -1136,7 +1136,7 @@ static int vidioc_streamoff(struct file 
 static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *tvnorms)
 {
 	struct cx23885_dev *dev = ((struct cx23885_fh *)priv)->dev;
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 
 	mutex_lock(&dev->lock);
 	cx23885_set_tvnorm(dev, *tvnorms);
@@ -1159,7 +1159,7 @@ int cx23885_enum_input(struct cx23885_de
 		[CX23885_VMUX_DEBUG]      = "for debug only",
 	};
 	unsigned int n;
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 
 	n = i->index;
 	if (n >= 4)
@@ -1184,7 +1184,7 @@ static int vidioc_enum_input(struct file
 				struct v4l2_input *i)
 {
 	struct cx23885_dev *dev = ((struct cx23885_fh *)priv)->dev;
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 	return cx23885_enum_input(dev, i);
 }
 
@@ -1193,7 +1193,7 @@ static int vidioc_g_input(struct file *f
 	struct cx23885_dev *dev = ((struct cx23885_fh *)priv)->dev;
 
 	*i = dev->input;
-	dprintk(1, "%s() returns %d\n", __FUNCTION__, *i);
+	dprintk(1, "%s() returns %d\n", __func__, *i);
 	return 0;
 }
 
@@ -1201,10 +1201,10 @@ static int vidioc_s_input(struct file *f
 {
 	struct cx23885_dev *dev = ((struct cx23885_fh *)priv)->dev;
 
-	dprintk(1, "%s(%d)\n", __FUNCTION__, i);
+	dprintk(1, "%s(%d)\n", __func__, i);
 
 	if (i >= 4) {
-		dprintk(1, "%s() -EINVAL\n", __FUNCTION__);
+		dprintk(1, "%s() -EINVAL\n", __func__);
 		return -EINVAL;
 	}
 
@@ -1389,7 +1389,7 @@ int cx23885_video_irq(struct cx23885_dev
 		return handled;
 	cx_write(VID_A_INT_STAT, status);
 
-	dprintk(2, "%s() status = 0x%08x\n", __FUNCTION__, status);
+	dprintk(2, "%s() status = 0x%08x\n", __func__, status);
 	/* risc op code error */
 	if (status & (1 << 16)) {
 		printk(KERN_WARNING "%s/0: video risc op code error\n",
@@ -1487,7 +1487,7 @@ static const struct file_operations radi
 
 void cx23885_video_unregister(struct cx23885_dev *dev)
 {
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 	cx_clear(PCI_INT_MSK, 1);
 
 	if (dev->video_dev) {
@@ -1505,7 +1505,7 @@ int cx23885_video_register(struct cx2388
 {
 	int err;
 
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 	spin_lock_init(&dev->slock);
 
 	/* Initialize VBI template */
diff -puN drivers/media/video/cx88/cx88-alsa.c~v4l-video-replace-remaining-__function__-occurences drivers/media/video/cx88/cx88-alsa.c
--- a/drivers/media/video/cx88/cx88-alsa.c~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/cx88/cx88-alsa.c
@@ -494,7 +494,7 @@ static snd_pcm_uframes_t snd_cx88_pointe
 
 	count = atomic_read(&chip->count);
 
-//	dprintk(2, "%s - count %d (+%u), period %d, frame %lu\n", __FUNCTION__,
+//	dprintk(2, "%s - count %d (+%u), period %d, frame %lu\n", __func__,
 //		count, new, count & (runtime->periods-1),
 //		runtime->period_size * (count & (runtime->periods-1)));
 	return runtime->period_size * (count & (runtime->periods-1));
diff -puN drivers/media/video/cx88/cx88-blackbird.c~v4l-video-replace-remaining-__function__-occurences drivers/media/video/cx88/cx88-blackbird.c
--- a/drivers/media/video/cx88/cx88-blackbird.c~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/cx88/cx88-blackbird.c
@@ -314,7 +314,7 @@ static int blackbird_mbox_func(void *pri
 	u32 value, flag, retval;
 	int i;
 
-	dprintk(1,"%s: 0x%X\n", __FUNCTION__, command);
+	dprintk(1,"%s: 0x%X\n", __func__, command);
 
 	/* this may not be 100% safe if we can't read any memory location
 	   without side effects */
@@ -1055,7 +1055,7 @@ static int mpeg_open(struct inode *inode
 
 	dev = cx8802_get_device(inode);
 
-	dprintk( 1, "%s\n", __FUNCTION__);
+	dprintk( 1, "%s\n", __func__);
 
 	if (dev == NULL)
 		return -ENODEV;
@@ -1065,7 +1065,7 @@ static int mpeg_open(struct inode *inode
 	if (drv) {
 		err = drv->request_acquire(drv);
 		if(err != 0) {
-			dprintk(1,"%s: Unable to acquire hardware, %d\n", __FUNCTION__, err);
+			dprintk(1,"%s: Unable to acquire hardware, %d\n", __func__, err);
 			return err;
 		}
 	}
@@ -1284,7 +1284,7 @@ static int cx8802_blackbird_probe(struct
 	struct cx8802_dev *dev = core->dvbdev;
 	int err;
 
-	dprintk( 1, "%s\n", __FUNCTION__);
+	dprintk( 1, "%s\n", __func__);
 	dprintk( 1, " ->being probed by Card=%d Name=%s, PCI %02x:%02x\n",
 		core->boardnr,
 		core->name,
diff -puN drivers/media/video/cx88/cx88-core.c~v4l-video-replace-remaining-__function__-occurences drivers/media/video/cx88/cx88-core.c
--- a/drivers/media/video/cx88/cx88-core.c~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/cx88/cx88-core.c
@@ -548,7 +548,7 @@ void cx88_wakeup(struct cx88_core *core,
 		mod_timer(&q->timeout, jiffies+BUFFER_TIMEOUT);
 	}
 	if (bc != 1)
-		printk("%s: %d buffers handled (should be 1)\n",__FUNCTION__,bc);
+		printk("%s: %d buffers handled (should be 1)\n",__func__,bc);
 }
 
 void cx88_shutdown(struct cx88_core *core)
@@ -577,7 +577,7 @@ void cx88_shutdown(struct cx88_core *cor
 
 int cx88_reset(struct cx88_core *core)
 {
-	dprintk(1,"%s\n",__FUNCTION__);
+	dprintk(1,"%s\n",__func__);
 	cx88_shutdown(core);
 
 	/* clear irq status */
diff -puN drivers/media/video/cx88/cx88-dvb.c~v4l-video-replace-remaining-__function__-occurences drivers/media/video/cx88/cx88-dvb.c
--- a/drivers/media/video/cx88/cx88-dvb.c~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/cx88/cx88-dvb.c
@@ -282,7 +282,7 @@ static int lgdt330x_pll_rf_set(struct dv
 	struct cx8802_dev *dev= fe->dvb->priv;
 	struct cx88_core *core = dev->core;
 
-	dprintk(1, "%s: index = %d\n", __FUNCTION__, index);
+	dprintk(1, "%s: index = %d\n", __func__, index);
 	if (index == 0)
 		cx_clear(MO_GP0_IO, 8);
 	else
@@ -380,7 +380,7 @@ static int cx88_pci_nano_callback(void *
 	switch (command) {
 	case XC2028_TUNER_RESET:
 		/* Send the tuner in then out of reset */
-		dprintk(1, "%s: XC2028_TUNER_RESET %d\n", __FUNCTION__, arg);
+		dprintk(1, "%s: XC2028_TUNER_RESET %d\n", __func__, arg);
 
 		switch (core->boardnr) {
 		case CX88_BOARD_DVICO_FUSIONHDTV_5_PCI_NANO:
@@ -396,10 +396,10 @@ static int cx88_pci_nano_callback(void *
 
 		break;
 	case XC2028_RESET_CLK:
-		dprintk(1, "%s: XC2028_RESET_CLK %d\n", __FUNCTION__, arg);
+		dprintk(1, "%s: XC2028_RESET_CLK %d\n", __func__, arg);
 		break;
 	default:
-		dprintk(1, "%s: unknown command %d, arg %d\n", __FUNCTION__,
+		dprintk(1, "%s: unknown command %d, arg %d\n", __func__,
 			command, arg);
 		return -EINVAL;
 	}
@@ -872,7 +872,7 @@ static int cx8802_dvb_advise_acquire(str
 {
 	struct cx88_core *core = drv->core;
 	int err = 0;
-	dprintk( 1, "%s\n", __FUNCTION__);
+	dprintk( 1, "%s\n", __func__);
 
 	switch (core->boardnr) {
 	case CX88_BOARD_HAUPPAUGE_HVR1300:
@@ -895,7 +895,7 @@ static int cx8802_dvb_advise_release(str
 {
 	struct cx88_core *core = drv->core;
 	int err = 0;
-	dprintk( 1, "%s\n", __FUNCTION__);
+	dprintk( 1, "%s\n", __func__);
 
 	switch (core->boardnr) {
 	case CX88_BOARD_HAUPPAUGE_HVR1300:
@@ -913,7 +913,7 @@ static int cx8802_dvb_probe(struct cx880
 	struct cx8802_dev *dev = drv->core->dvbdev;
 	int err;
 
-	dprintk( 1, "%s\n", __FUNCTION__);
+	dprintk( 1, "%s\n", __func__);
 	dprintk( 1, " ->being probed by Card=%d Name=%s, PCI %02x:%02x\n",
 		core->boardnr,
 		core->name,
diff -puN drivers/media/video/cx88/cx88-mpeg.c~v4l-video-replace-remaining-__function__-occurences drivers/media/video/cx88/cx88-mpeg.c
--- a/drivers/media/video/cx88/cx88-mpeg.c~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/cx88/cx88-mpeg.c
@@ -146,7 +146,7 @@ static int cx8802_start_dma(struct cx880
 		cx_write(TS_GEN_CNTRL, 0x06); /* punctured clock TS & posedge driven */
 		udelay(100);
 	} else {
-		printk( "%s() Failed. Unsupported value in .mpeg (0x%08x)\n", __FUNCTION__,
+		printk( "%s() Failed. Unsupported value in .mpeg (0x%08x)\n", __func__,
 			core->board.mpeg );
 		return -EINVAL;
 	}
@@ -247,7 +247,7 @@ int cx8802_buf_prepare(struct videobuf_q
 	struct videobuf_dmabuf *dma=videobuf_to_dma(&buf->vb);
 	int rc;
 
-	dprintk(1, "%s: %p\n", __FUNCTION__, buf);
+	dprintk(1, "%s: %p\n", __func__, buf);
 	if (0 != buf->vb.baddr  &&  buf->vb.bsize < size)
 		return -EINVAL;
 
@@ -289,7 +289,7 @@ void cx8802_buf_queue(struct cx8802_dev 
 		buf->count    = cx88q->count++;
 		mod_timer(&cx88q->timeout, jiffies+BUFFER_TIMEOUT);
 		dprintk(1,"[%p/%d] %s - first active\n",
-			buf, buf->vb.i, __FUNCTION__);
+			buf, buf->vb.i, __func__);
 
 	} else {
 		dprintk( 1, "queue is not empty - append to active\n" );
@@ -299,7 +299,7 @@ void cx8802_buf_queue(struct cx8802_dev 
 		buf->count    = cx88q->count++;
 		prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
 		dprintk( 1, "[%p/%d] %s - append to active\n",
-			buf, buf->vb.i, __FUNCTION__);
+			buf, buf->vb.i, __func__);
 	}
 }
 
@@ -342,7 +342,7 @@ static void cx8802_timeout(unsigned long
 {
 	struct cx8802_dev *dev = (struct cx8802_dev*)data;
 
-	dprintk(1, "%s\n",__FUNCTION__);
+	dprintk(1, "%s\n",__func__);
 
 	if (debug)
 		cx88_sram_channel_dump(dev->core, &cx88_sram_channels[SRAM_CH28]);
@@ -625,7 +625,7 @@ static int cx8802_request_acquire(struct
 		}
 		mutex_unlock(&drv->core->lock);
 
-		mpeg_dbg(1,"%s() Post acquire GPIO=%x\n", __FUNCTION__, cx_read(MO_GP0_IO));
+		mpeg_dbg(1,"%s() Post acquire GPIO=%x\n", __func__, cx_read(MO_GP0_IO));
 	}
 
 	return 0;
@@ -641,7 +641,7 @@ static int cx8802_request_release(struct
 	{
 		drv->advise_release(drv);
 		core->active_type_id = CX88_BOARD_NONE;
-		mpeg_dbg(1,"%s() Post release GPIO=%x\n", __FUNCTION__, cx_read(MO_GP0_IO));
+		mpeg_dbg(1,"%s() Post release GPIO=%x\n", __func__, cx_read(MO_GP0_IO));
 	}
 	mutex_unlock(&drv->core->lock);
 
@@ -815,7 +815,7 @@ static void __devexit cx8802_remove(stru
 
 	dev = pci_get_drvdata(pci_dev);
 
-	dprintk( 1, "%s\n", __FUNCTION__);
+	dprintk( 1, "%s\n", __func__);
 
 	if (!list_empty(&dev->drvlist)) {
 		struct cx8802_driver *drv, *tmp;
diff -puN drivers/media/video/cx88/cx88-tvaudio.c~v4l-video-replace-remaining-__function__-occurences drivers/media/video/cx88/cx88-tvaudio.c
--- a/drivers/media/video/cx88/cx88-tvaudio.c~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/cx88/cx88-tvaudio.c
@@ -265,12 +265,12 @@ static void set_audio_standard_BTSC(stru
 	mode |= EN_FMRADIO_EN_RDS;
 
 	if (sap) {
-		dprintk("%s SAP (status: unknown)\n", __FUNCTION__);
+		dprintk("%s SAP (status: unknown)\n", __func__);
 		set_audio_start(core, SEL_SAP);
 		set_audio_registers(core, btsc_sap);
 		set_audio_finish(core, mode);
 	} else {
-		dprintk("%s (status: known-good)\n", __FUNCTION__);
+		dprintk("%s (status: known-good)\n", __func__);
 		set_audio_start(core, SEL_BTSC);
 		set_audio_registers(core, btsc);
 		set_audio_finish(core, mode);
@@ -351,16 +351,16 @@ static void set_audio_standard_NICAM(str
 	set_audio_start(core,SEL_NICAM);
 	switch (core->tvaudio) {
 	case WW_L:
-		dprintk("%s SECAM-L NICAM (status: devel)\n", __FUNCTION__);
+		dprintk("%s SECAM-L NICAM (status: devel)\n", __func__);
 		set_audio_registers(core, nicam_l);
 		break;
 	case WW_I:
-		dprintk("%s PAL-I NICAM (status: known-good)\n", __FUNCTION__);
+		dprintk("%s PAL-I NICAM (status: known-good)\n", __func__);
 		set_audio_registers(core, nicam_bgdki_common);
 		set_audio_registers(core, nicam_i);
 		break;
 	default:
-		dprintk("%s PAL-BGDK NICAM (status: known-good)\n", __FUNCTION__);
+		dprintk("%s PAL-BGDK NICAM (status: known-good)\n", __func__);
 		set_audio_registers(core, nicam_bgdki_common);
 		set_audio_registers(core, nicam_default);
 		break;
@@ -600,28 +600,28 @@ static void set_audio_standard_A2(struct
 	set_audio_start(core, SEL_A2);
 	switch (core->tvaudio) {
 	case WW_BG:
-		dprintk("%s PAL-BG A1/2 (status: known-good)\n", __FUNCTION__);
+		dprintk("%s PAL-BG A1/2 (status: known-good)\n", __func__);
 		set_audio_registers(core, a2_bgdk_common);
 		set_audio_registers(core, a2_bg);
 		set_audio_registers(core, a2_deemph50);
 		break;
 	case WW_DK:
-		dprintk("%s PAL-DK A1/2 (status: known-good)\n", __FUNCTION__);
+		dprintk("%s PAL-DK A1/2 (status: known-good)\n", __func__);
 		set_audio_registers(core, a2_bgdk_common);
 		set_audio_registers(core, a2_dk);
 		set_audio_registers(core, a2_deemph50);
 		break;
 	case WW_I:
-		dprintk("%s PAL-I A1 (status: known-good)\n", __FUNCTION__);
+		dprintk("%s PAL-I A1 (status: known-good)\n", __func__);
 		set_audio_registers(core, a1_i);
 		set_audio_registers(core, a2_deemph50);
 		break;
 	case WW_L:
-		dprintk("%s AM-L (status: devel)\n", __FUNCTION__);
+		dprintk("%s AM-L (status: devel)\n", __func__);
 		set_audio_registers(core, am_l);
 		break;
 	default:
-		dprintk("%s Warning: wrong value\n", __FUNCTION__);
+		dprintk("%s Warning: wrong value\n", __func__);
 		return;
 		break;
 	};
@@ -637,7 +637,7 @@ static void set_audio_standard_EIAJ(stru
 
 		{ /* end of list */ },
 	};
-	dprintk("%s (status: unknown)\n", __FUNCTION__);
+	dprintk("%s (status: unknown)\n", __func__);
 
 	set_audio_start(core, SEL_EIAJ);
 	set_audio_registers(core, eiaj);
@@ -691,7 +691,7 @@ static void set_audio_standard_FM(struct
 		{ /* end of list */ },
 	};
 
-	dprintk("%s (status: unknown)\n", __FUNCTION__);
+	dprintk("%s (status: unknown)\n", __func__);
 	set_audio_start(core, SEL_FMRADIO);
 
 	switch (deemph) {
diff -puN drivers/media/video/em28xx/em28xx-audio.c~v4l-video-replace-remaining-__function__-occurences drivers/media/video/em28xx/em28xx-audio.c
--- a/drivers/media/video/em28xx/em28xx-audio.c~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/em28xx/em28xx-audio.c
@@ -51,7 +51,7 @@ MODULE_PARM_DESC(debug, "activates debug
 #define dprintk(fmt, arg...) do {					\
 	    if (debug)							\
 		printk(KERN_INFO "em28xx-audio %s: " fmt,		\
-				  __FUNCTION__, ##arg); 		\
+				  __func__, ##arg); 		\
 	} while (0)
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;
diff -puN drivers/media/video/em28xx/em28xx-core.c~v4l-video-replace-remaining-__function__-occurences drivers/media/video/em28xx/em28xx-core.c
--- a/drivers/media/video/em28xx/em28xx-core.c~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/em28xx/em28xx-core.c
@@ -38,7 +38,7 @@ MODULE_PARM_DESC(core_debug,"enable debu
 #define em28xx_coredbg(fmt, arg...) do {\
 	if (core_debug) \
 		printk(KERN_INFO "%s %s :"fmt, \
-			 dev->name, __FUNCTION__ , ##arg); } while (0)
+			 dev->name, __func__ , ##arg); } while (0)
 
 static unsigned int reg_debug;
 module_param(reg_debug,int,0644);
@@ -47,7 +47,7 @@ MODULE_PARM_DESC(reg_debug,"enable debug
 #define em28xx_regdbg(fmt, arg...) do {\
 	if (reg_debug) \
 		printk(KERN_INFO "%s %s :"fmt, \
-			 dev->name, __FUNCTION__ , ##arg); } while (0)
+			 dev->name, __func__ , ##arg); } while (0)
 
 static unsigned int isoc_debug;
 module_param(isoc_debug,int,0644);
@@ -56,7 +56,7 @@ MODULE_PARM_DESC(isoc_debug,"enable debu
 #define em28xx_isocdbg(fmt, arg...) do {\
 	if (isoc_debug) \
 		printk(KERN_INFO "%s %s :"fmt, \
-			 dev->name, __FUNCTION__ , ##arg); } while (0)
+			 dev->name, __func__ , ##arg); } while (0)
 
 static int alt = EM28XX_PINOUT;
 module_param(alt, int, 0644);
diff -puN drivers/media/video/em28xx/em28xx-i2c.c~v4l-video-replace-remaining-__function__-occurences drivers/media/video/em28xx/em28xx-i2c.c
--- a/drivers/media/video/em28xx/em28xx-i2c.c~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/em28xx/em28xx-i2c.c
@@ -45,7 +45,7 @@ MODULE_PARM_DESC(i2c_debug, "enable debu
 			printk(fmt, ##args); } while (0)
 #define dprintk2(lvl,fmt, args...) if (i2c_debug>=lvl) do{ \
 			printk(KERN_DEBUG "%s at %s: " fmt, \
-			dev->name, __FUNCTION__ , ##args); } while (0)
+			dev->name, __func__ , ##args); } while (0)
 
 /*
  * em2800_i2c_send_max4()
diff -puN drivers/media/video/em28xx/em28xx-video.c~v4l-video-replace-remaining-__function__-occurences drivers/media/video/em28xx/em28xx-video.c
--- a/drivers/media/video/em28xx/em28xx-video.c~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/em28xx/em28xx-video.c
@@ -52,7 +52,7 @@
 #define em28xx_videodbg(fmt, arg...) do {\
 	if (video_debug) \
 		printk(KERN_INFO "%s %s :"fmt, \
-			 dev->name, __FUNCTION__ , ##arg); } while (0)
+			 dev->name, __func__ , ##arg); } while (0)
 
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
diff -puN drivers/media/video/et61x251/et61x251.h~v4l-video-replace-remaining-__function__-occurences drivers/media/video/et61x251/et61x251.h
--- a/drivers/media/video/et61x251/et61x251.h~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/et61x251/et61x251.h
@@ -199,7 +199,7 @@ do {                                    
 			dev_info(&cam->usbdev->dev, fmt "\n", ## args);       \
 		else if ((level) >= 3)                                        \
 			dev_info(&cam->usbdev->dev, "[%s:%s:%d] " fmt "\n",   \
-				 __FILE__, __FUNCTION__, __LINE__ , ## args); \
+				 __FILE__, __func__, __LINE__ , ## args); \
 	}                                                                     \
 } while (0)
 #	define KDBG(level, fmt, args...)                                      \
@@ -209,7 +209,7 @@ do {                                    
 			pr_info("et61x251: " fmt "\n", ## args);              \
 		else if ((level) == 3)                                        \
 			pr_debug("sn9c102: [%s:%s:%d] " fmt "\n", __FILE__,   \
-				 __FUNCTION__, __LINE__ , ## args);           \
+				 __func__, __LINE__ , ## args);           \
 	}                                                                     \
 } while (0)
 #	define V4LDBG(level, name, cmd)                                       \
@@ -225,7 +225,7 @@ do {                                    
 
 #undef PDBG
 #define PDBG(fmt, args...)                                                    \
-dev_info(&cam->usbdev->dev, "[%s:%s:%d] " fmt "\n", __FILE__, __FUNCTION__,   \
+dev_info(&cam->usbdev->dev, "[%s:%s:%d] " fmt "\n", __FILE__, __func__,   \
 	 __LINE__ , ## args)
 
 #undef PDBGG
diff -puN drivers/media/video/ir-kbd-i2c.c~v4l-video-replace-remaining-__function__-occurences drivers/media/video/ir-kbd-i2c.c
--- a/drivers/media/video/ir-kbd-i2c.c~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/ir-kbd-i2c.c
@@ -154,7 +154,7 @@ static int get_key_fusionhdtv(struct IR_
 	}
 
 	if(buf[0] !=0 || buf[1] !=0 || buf[2] !=0 || buf[3] != 0)
-		dprintk(2, "%s: 0x%2x 0x%2x 0x%2x 0x%2x\n", __FUNCTION__,
+		dprintk(2, "%s: 0x%2x 0x%2x 0x%2x 0x%2x\n", __func__,
 			buf[0], buf[1], buf[2], buf[3]);
 
 	/* no key pressed or signal from other ir remote */
diff -puN drivers/media/video/mt20xx.h~v4l-video-replace-remaining-__function__-occurences drivers/media/video/mt20xx.h
--- a/drivers/media/video/mt20xx.h~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/mt20xx.h
@@ -29,7 +29,7 @@ static inline struct dvb_frontend *micro
 					     struct i2c_adapter* i2c_adap,
 					     u8 i2c_addr)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif
diff -puN drivers/media/video/mt9m001.c~v4l-video-replace-remaining-__function__-occurences drivers/media/video/mt9m001.c
--- a/drivers/media/video/mt9m001.c~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/mt9m001.c
@@ -123,7 +123,7 @@ static int mt9m001_init(struct soc_camer
 	int ret;
 
 	/* Disable chip, synchronous option update */
-	dev_dbg(icd->vdev->dev, "%s\n", __FUNCTION__);
+	dev_dbg(icd->vdev->dev, "%s\n", __func__);
 
 	ret = reg_write(icd, MT9M001_RESET, 1);
 	if (ret >= 0)
diff -puN drivers/media/video/ov511.h~v4l-video-replace-remaining-__function__-occurences drivers/media/video/ov511.h
--- a/drivers/media/video/ov511.h~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/ov511.h
@@ -12,7 +12,7 @@
 #ifdef OV511_DEBUG
 	#define PDEBUG(level, fmt, args...) \
 		if (debug >= (level)) info("[%s:%d] " fmt, \
-		__FUNCTION__, __LINE__ , ## args)
+		__func__, __LINE__ , ## args)
 #else
 	#define PDEBUG(level, fmt, args...) do {} while(0)
 #endif
diff -puN drivers/media/video/ovcamchip/ovcamchip_priv.h~v4l-video-replace-remaining-__function__-occurences drivers/media/video/ovcamchip/ovcamchip_priv.h
--- a/drivers/media/video/ovcamchip/ovcamchip_priv.h~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/ovcamchip/ovcamchip_priv.h
@@ -24,11 +24,11 @@ extern int ovcamchip_debug;
 
 #define PDEBUG(level, fmt, args...) \
 	if (ovcamchip_debug >= (level))	pr_debug("[%s:%d] " fmt "\n", \
-		__FUNCTION__, __LINE__ , ## args)
+		__func__, __LINE__ , ## args)
 
 #define DDEBUG(level, dev, fmt, args...) \
 	if (ovcamchip_debug >= (level))	dev_dbg(dev, "[%s:%d] " fmt "\n", \
-		__FUNCTION__, __LINE__ , ## args)
+		__func__, __LINE__ , ## args)
 
 /* Number of times to retry chip detection. Increase this if you are getting
  * "Failed to init camera chip" */
diff -puN drivers/media/video/pvrusb2/pvrusb2-sysfs.c~v4l-video-replace-remaining-__function__-occurences drivers/media/video/pvrusb2/pvrusb2-sysfs.c
--- a/drivers/media/video/pvrusb2/pvrusb2-sysfs.c~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/pvrusb2/pvrusb2-sysfs.c
@@ -610,7 +610,7 @@ static void pvr2_sysfs_add_control(struc
 	ret = sysfs_create_group(&sfp->class_dev->kobj,&cip->grp);
 	if (ret) {
 		printk(KERN_WARNING "%s: sysfs_create_group error: %d\n",
-		       __FUNCTION__, ret);
+		       __func__, ret);
 		return;
 	}
 	cip->created_ok = !0;
@@ -642,14 +642,14 @@ static void pvr2_sysfs_add_debugifc(stru
 	ret = device_create_file(sfp->class_dev,&dip->attr_debugcmd);
 	if (ret < 0) {
 		printk(KERN_WARNING "%s: device_create_file error: %d\n",
-		       __FUNCTION__, ret);
+		       __func__, ret);
 	} else {
 		dip->debugcmd_created_ok = !0;
 	}
 	ret = device_create_file(sfp->class_dev,&dip->attr_debuginfo);
 	if (ret < 0) {
 		printk(KERN_WARNING "%s: device_create_file error: %d\n",
-		       __FUNCTION__, ret);
+		       __func__, ret);
 	} else {
 		dip->debuginfo_created_ok = !0;
 	}
@@ -853,7 +853,7 @@ static void class_dev_create(struct pvr2
 	ret = device_register(class_dev);
 	if (ret) {
 		printk(KERN_ERR "%s: device_register failed\n",
-		       __FUNCTION__);
+		       __func__);
 		kfree(class_dev);
 		return;
 	}
@@ -866,7 +866,7 @@ static void class_dev_create(struct pvr2
 				       &sfp->attr_v4l_minor_number);
 	if (ret < 0) {
 		printk(KERN_WARNING "%s: device_create_file error: %d\n",
-		       __FUNCTION__, ret);
+		       __func__, ret);
 	} else {
 		sfp->v4l_minor_number_created_ok = !0;
 	}
@@ -879,7 +879,7 @@ static void class_dev_create(struct pvr2
 				       &sfp->attr_v4l_radio_minor_number);
 	if (ret < 0) {
 		printk(KERN_WARNING "%s: device_create_file error: %d\n",
-		       __FUNCTION__, ret);
+		       __func__, ret);
 	} else {
 		sfp->v4l_radio_minor_number_created_ok = !0;
 	}
@@ -891,7 +891,7 @@ static void class_dev_create(struct pvr2
 	ret = device_create_file(sfp->class_dev,&sfp->attr_unit_number);
 	if (ret < 0) {
 		printk(KERN_WARNING "%s: device_create_file error: %d\n",
-		       __FUNCTION__, ret);
+		       __func__, ret);
 	} else {
 		sfp->unit_number_created_ok = !0;
 	}
@@ -904,7 +904,7 @@ static void class_dev_create(struct pvr2
 				       &sfp->attr_bus_info);
 	if (ret < 0) {
 		printk(KERN_WARNING "%s: device_create_file error: %d\n",
-		       __FUNCTION__, ret);
+		       __func__, ret);
 	} else {
 		sfp->bus_info_created_ok = !0;
 	}
@@ -917,7 +917,7 @@ static void class_dev_create(struct pvr2
 				 &sfp->attr_hdw_name);
 	if (ret < 0) {
 		printk(KERN_WARNING "%s: device_create_file error: %d\n",
-		       __FUNCTION__, ret);
+		       __func__, ret);
 	} else {
 		sfp->hdw_name_created_ok = !0;
 	}
@@ -930,7 +930,7 @@ static void class_dev_create(struct pvr2
 				 &sfp->attr_hdw_desc);
 	if (ret < 0) {
 		printk(KERN_WARNING "%s: device_create_file error: %d\n",
-		       __FUNCTION__, ret);
+		       __func__, ret);
 	} else {
 		sfp->hdw_desc_created_ok = !0;
 	}
diff -puN drivers/media/video/pwc/pwc-if.c~v4l-video-replace-remaining-__function__-occurences drivers/media/video/pwc/pwc-if.c
--- a/drivers/media/video/pwc/pwc-if.c~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/pwc/pwc-if.c
@@ -489,7 +489,7 @@ static void pwc_reset_buffers(struct pwc
 	int i;
 	unsigned long flags;
 
-	PWC_DEBUG_MEMORY(">> %s __enter__\n", __FUNCTION__);
+	PWC_DEBUG_MEMORY(">> %s __enter__\n", __func__);
 
 	spin_lock_irqsave(&pdev->ptrlock, flags);
 	pdev->full_frames = NULL;
@@ -511,7 +511,7 @@ static void pwc_reset_buffers(struct pwc
 	pdev->fill_image = 0;
 	spin_unlock_irqrestore(&pdev->ptrlock, flags);
 
-	PWC_DEBUG_MEMORY("<< %s __leaving__\n", __FUNCTION__);
+	PWC_DEBUG_MEMORY("<< %s __leaving__\n", __func__);
 }
 
 
@@ -1428,7 +1428,7 @@ static int pwc_video_mmap(struct file *f
 	unsigned long page, pos = 0;
 	int index;
 
-	PWC_DEBUG_MEMORY(">> %s\n", __FUNCTION__);
+	PWC_DEBUG_MEMORY(">> %s\n", __func__);
 	pdev = vdev->priv;
 	size = vma->vm_end - vma->vm_start;
 	start = vma->vm_start;
diff -puN drivers/media/video/pxa_camera.c~v4l-video-replace-remaining-__function__-occurences drivers/media/video/pxa_camera.c
--- a/drivers/media/video/pxa_camera.c~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/pxa_camera.c
@@ -148,7 +148,7 @@ static void free_buffer(struct videobuf_
 
 	BUG_ON(in_interrupt());
 
-	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __FUNCTION__,
+	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
 		&buf->vb, buf->vb.baddr, buf->vb.bsize);
 
 	/* This waits until this buffer is out of danger, i.e., until it is no
@@ -175,7 +175,7 @@ static int pxa_videobuf_prepare(struct v
 	struct pxa_buffer *buf = container_of(vb, struct pxa_buffer, vb);
 	int i, ret;
 
-	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __FUNCTION__,
+	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
 		vb, vb->baddr, vb->bsize);
 
 	/* Added list head initialization on alloc */
@@ -281,7 +281,7 @@ static void pxa_videobuf_queue(struct vi
 	int nents = dma->sglen;
 	unsigned long flags;
 
-	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __FUNCTION__,
+	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
 		vb, vb->baddr, vb->bsize);
 	spin_lock_irqsave(&pcdev->lock, flags);
 
@@ -354,21 +354,21 @@ static void pxa_videobuf_release(struct 
 #ifdef DEBUG
 	struct soc_camera_device *icd = vq->priv_data;
 
-	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __FUNCTION__,
+	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
 		vb, vb->baddr, vb->bsize);
 
 	switch (vb->state) {
 	case VIDEOBUF_ACTIVE:
-		dev_dbg(&icd->dev, "%s (active)\n", __FUNCTION__);
+		dev_dbg(&icd->dev, "%s (active)\n", __func__);
 		break;
 	case VIDEOBUF_QUEUED:
-		dev_dbg(&icd->dev, "%s (queued)\n", __FUNCTION__);
+		dev_dbg(&icd->dev, "%s (queued)\n", __func__);
 		break;
 	case VIDEOBUF_PREPARED:
-		dev_dbg(&icd->dev, "%s (prepared)\n", __FUNCTION__);
+		dev_dbg(&icd->dev, "%s (prepared)\n", __func__);
 		break;
 	default:
-		dev_dbg(&icd->dev, "%s (unknown)\n", __FUNCTION__);
+		dev_dbg(&icd->dev, "%s (unknown)\n", __func__);
 		break;
 	}
 #endif
@@ -408,7 +408,7 @@ static void pxa_camera_dma_irq_y(int cha
 	vb = &pcdev->active->vb;
 	buf = container_of(vb, struct pxa_buffer, vb);
 	WARN_ON(buf->inwork || list_empty(&vb->queue));
-	dev_dbg(pcdev->dev, "%s (vb=0x%p) 0x%08lx %d\n", __FUNCTION__,
+	dev_dbg(pcdev->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
 		vb, vb->baddr, vb->bsize);
 
 	/* _init is used to debug races, see comment in pxa_camera_reqbufs() */
@@ -466,18 +466,18 @@ static void pxa_camera_activate(struct p
 		pcdev, pdata);
 
 	if (pdata && pdata->init) {
-		dev_dbg(pcdev->dev, "%s: Init gpios\n", __FUNCTION__);
+		dev_dbg(pcdev->dev, "%s: Init gpios\n", __func__);
 		pdata->init(pcdev->dev);
 	}
 
 	if (pdata && pdata->power) {
-		dev_dbg(pcdev->dev, "%s: Power on camera\n", __FUNCTION__);
+		dev_dbg(pcdev->dev, "%s: Power on camera\n", __func__);
 		pdata->power(pcdev->dev, 1);
 	}
 
 	if (pdata && pdata->reset) {
 		dev_dbg(pcdev->dev, "%s: Releasing camera reset\n",
-			__FUNCTION__);
+			__func__);
 		pdata->reset(pcdev->dev, 1);
 	}
 
@@ -507,12 +507,12 @@ static void pxa_camera_deactivate(struct
 
 	if (board && board->reset) {
 		dev_dbg(pcdev->dev, "%s: Asserting camera reset\n",
-			__FUNCTION__);
+			__func__);
 		board->reset(pcdev->dev, 0);
 	}
 
 	if (board && board->power) {
-		dev_dbg(pcdev->dev, "%s: Power off camera\n", __FUNCTION__);
+		dev_dbg(pcdev->dev, "%s: Power off camera\n", __func__);
 		board->power(pcdev->dev, 0);
 	}
 }
diff -puN drivers/media/video/saa7134/saa7134-empress.c~v4l-video-replace-remaining-__function__-occurences drivers/media/video/saa7134/saa7134-empress.c
--- a/drivers/media/video/saa7134/saa7134-empress.c~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/saa7134/saa7134-empress.c
@@ -402,7 +402,7 @@ static int empress_init(struct saa7134_d
 {
 	int err;
 
-	dprintk("%s: %s\n",dev->name,__FUNCTION__);
+	dprintk("%s: %s\n",dev->name,__func__);
 	dev->empress_dev = video_device_alloc();
 	if (NULL == dev->empress_dev)
 		return -ENOMEM;
@@ -440,7 +440,7 @@ static int empress_init(struct saa7134_d
 
 static int empress_fini(struct saa7134_dev *dev)
 {
-	dprintk("%s: %s\n",dev->name,__FUNCTION__);
+	dprintk("%s: %s\n",dev->name,__func__);
 
 	if (NULL == dev->empress_dev)
 		return 0;
diff -puN drivers/media/video/se401.c~v4l-video-replace-remaining-__function__-occurences drivers/media/video/se401.c
--- a/drivers/media/video/se401.c~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/se401.c
@@ -300,10 +300,10 @@ static void se401_button_irq(struct urb 
 	case -ENOENT:
 	case -ESHUTDOWN:
 		/* this urb is terminated, clean up */
-		dbg("%s - urb shutting down with status: %d", __FUNCTION__, urb->status);
+		dbg("%s - urb shutting down with status: %d", __func__, urb->status);
 		return;
 	default:
-		dbg("%s - nonzero urb status received: %d", __FUNCTION__, urb->status);
+		dbg("%s - nonzero urb status received: %d", __func__, urb->status);
 		goto exit;
 	}
 
@@ -315,7 +315,7 @@ exit:
 	status = usb_submit_urb (urb, GFP_ATOMIC);
 	if (status)
 		err ("%s - usb_submit_urb failed with result %d",
-		     __FUNCTION__, status);
+		     __func__, status);
 }
 
 static void se401_video_irq(struct urb *urb)
diff -puN drivers/media/video/sn9c102/sn9c102.h~v4l-video-replace-remaining-__function__-occurences drivers/media/video/sn9c102/sn9c102.h
--- a/drivers/media/video/sn9c102/sn9c102.h~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/sn9c102/sn9c102.h
@@ -176,7 +176,7 @@ do {                                    
 			dev_info(&cam->usbdev->dev, fmt "\n", ## args);       \
 		else if ((level) >= 3)                                        \
 			dev_info(&cam->usbdev->dev, "[%s:%d] " fmt "\n",      \
-				 __FUNCTION__, __LINE__ , ## args);           \
+				 __func__, __LINE__ , ## args);           \
 	}                                                                     \
 } while (0)
 #	define V4LDBG(level, name, cmd)                                       \
@@ -191,7 +191,7 @@ do {                                    
 			pr_info("sn9c102: " fmt "\n", ## args);               \
 		else if ((level) == 3)                                        \
 			pr_debug("sn9c102: [%s:%d] " fmt "\n",                \
-				 __FUNCTION__, __LINE__ , ## args);           \
+				 __func__, __LINE__ , ## args);           \
 	}                                                                     \
 } while (0)
 #else
@@ -202,7 +202,7 @@ do {                                    
 
 #undef PDBG
 #define PDBG(fmt, args...)                                                    \
-dev_info(&cam->usbdev->dev, "[%s:%s:%d] " fmt "\n", __FILE__, __FUNCTION__,   \
+dev_info(&cam->usbdev->dev, "[%s:%s:%d] " fmt "\n", __FILE__, __func__,   \
 	 __LINE__ , ## args)
 
 #undef PDBGG
diff -puN drivers/media/video/soc_camera.c~v4l-video-replace-remaining-__function__-occurences drivers/media/video/soc_camera.c
--- a/drivers/media/video/soc_camera.c~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/soc_camera.c
@@ -137,7 +137,7 @@ static int soc_camera_reqbufs(struct fil
 
 	WARN_ON(priv != file->private_data);
 
-	dev_dbg(&icd->dev, "%s: %d\n", __FUNCTION__, p->memory);
+	dev_dbg(&icd->dev, "%s: %d\n", __func__, p->memory);
 
 	ret = videobuf_reqbufs(&icf->vb_vidq, p);
 	if (ret < 0)
@@ -453,7 +453,7 @@ static int soc_camera_streamon(struct fi
 
 	WARN_ON(priv != file->private_data);
 
-	dev_dbg(&icd->dev, "%s\n", __FUNCTION__);
+	dev_dbg(&icd->dev, "%s\n", __func__);
 
 	if (i != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
@@ -472,7 +472,7 @@ static int soc_camera_streamoff(struct f
 
 	WARN_ON(priv != file->private_data);
 
-	dev_dbg(&icd->dev, "%s\n", __FUNCTION__);
+	dev_dbg(&icd->dev, "%s\n", __func__);
 
 	if (i != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
@@ -985,7 +985,7 @@ void soc_camera_video_stop(struct soc_ca
 {
 	struct video_device *vdev = icd->vdev;
 
-	dev_dbg(&icd->dev, "%s\n", __FUNCTION__);
+	dev_dbg(&icd->dev, "%s\n", __func__);
 
 	if (!icd->dev.parent || !vdev)
 		return;
diff -puN drivers/media/video/stk-webcam.c~v4l-video-replace-remaining-__function__-occurences drivers/media/video/stk-webcam.c
--- a/drivers/media/video/stk-webcam.c~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/stk-webcam.c
@@ -1100,7 +1100,7 @@ static int stk_setup_format(struct stk_c
 			&& i < ARRAY_SIZE(stk_sizes))
 		i++;
 	if (i == ARRAY_SIZE(stk_sizes)) {
-		STK_ERROR("Something is broken in %s\n", __FUNCTION__);
+		STK_ERROR("Something is broken in %s\n", __func__);
 		return -EFAULT;
 	}
 	/* This registers controls some timings, not sure of what. */
diff -puN drivers/media/video/stv680.c~v4l-video-replace-remaining-__function__-occurences drivers/media/video/stv680.c
--- a/drivers/media/video/stv680.c~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/stv680.c
@@ -83,7 +83,7 @@ static unsigned int debug;
 #define PDEBUG(level, fmt, args...) \
 	do { \
 	if (debug >= level)	\
-		info("[%s:%d] " fmt, __FUNCTION__, __LINE__ , ## args);	\
+		info("[%s:%d] " fmt, __func__, __LINE__ , ## args);	\
 	} while (0)
 
 
diff -puN drivers/media/video/tcm825x.c~v4l-video-replace-remaining-__function__-occurences drivers/media/video/tcm825x.c
--- a/drivers/media/video/tcm825x.c~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/tcm825x.c
@@ -906,7 +906,7 @@ static int __init tcm825x_init(void)
 	rval = i2c_add_driver(&tcm825x_i2c_driver);
 	if (rval)
 		printk(KERN_INFO "%s: failed registering " TCM825X_NAME "\n",
-		       __FUNCTION__);
+		       __func__);
 
 	return rval;
 }
diff -puN drivers/media/video/tda8290.c~v4l-video-replace-remaining-__function__-occurences drivers/media/video/tda8290.c
--- a/drivers/media/video/tda8290.c~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/tda8290.c
@@ -363,7 +363,7 @@ static void tda8295_set_params(struct dv
 
 	set_audio(fe, params);
 
-	tuner_dbg("%s: freq = %d\n", __FUNCTION__, params->frequency);
+	tuner_dbg("%s: freq = %d\n", __func__, params->frequency);
 
 	tda8295_power(fe, 1);
 	tda8295_agc1_out(fe, 1);
@@ -613,7 +613,7 @@ static int tda8290_probe(struct tuner_i2
 	if (tda8290_id[1] == TDA8290_ID) {
 		if (debug)
 			printk(KERN_DEBUG "%s: tda8290 detected @ %d-%04x\n",
-			       __FUNCTION__, i2c_adapter_id(i2c_props->adap),
+			       __func__, i2c_adapter_id(i2c_props->adap),
 			       i2c_props->addr);
 		return 0;
 	}
@@ -633,7 +633,7 @@ static int tda8295_probe(struct tuner_i2
 	if (tda8295_id[1] == TDA8295_ID) {
 		if (debug)
 			printk(KERN_DEBUG "%s: tda8295 detected @ %d-%04x\n",
-			       __FUNCTION__, i2c_adapter_id(i2c_props->adap),
+			       __func__, i2c_adapter_id(i2c_props->adap),
 			       i2c_props->addr);
 		return 0;
 	}
diff -puN drivers/media/video/tda8290.h~v4l-video-replace-remaining-__function__-occurences drivers/media/video/tda8290.h
--- a/drivers/media/video/tda8290.h~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/tda8290.h
@@ -39,7 +39,7 @@ extern struct dvb_frontend *tda829x_atta
 #else
 static inline int tda829x_probe(struct i2c_adapter *i2c_adap, u8 i2c_addr)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return -EINVAL;
 }
 
@@ -49,7 +49,7 @@ static inline struct dvb_frontend *tda82
 						  struct tda829x_config *cfg)
 {
 	printk(KERN_INFO "%s: not probed - driver disabled by Kconfig\n",
-	       __FUNCTION__);
+	       __func__);
 	return NULL;
 }
 #endif
diff -puN drivers/media/video/tda9840.c~v4l-video-replace-remaining-__function__-occurences drivers/media/video/tda9840.c
--- a/drivers/media/video/tda9840.c~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/tda9840.c
@@ -35,7 +35,7 @@ static int debug;		/* insmod parameter *
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Turn on/off device debugging (default:off).");
 #define dprintk(args...) \
-	    do { if (debug) { printk("%s: %s()[%d]: ", KBUILD_MODNAME, __FUNCTION__, __LINE__); printk(args); } } while (0)
+	    do { if (debug) { printk("%s: %s()[%d]: ", KBUILD_MODNAME, __func__, __LINE__); printk(args); } } while (0)
 
 #define	SWITCH		0x00
 #define	LEVEL_ADJUST	0x02
diff -puN drivers/media/video/tda9887.h~v4l-video-replace-remaining-__function__-occurences drivers/media/video/tda9887.h
--- a/drivers/media/video/tda9887.h~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/tda9887.h
@@ -30,7 +30,7 @@ static inline struct dvb_frontend *tda98
 						  struct i2c_adapter *i2c_adap,
 						  u8 i2c_addr)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif
diff -puN drivers/media/video/tea5761.h~v4l-video-replace-remaining-__function__-occurences drivers/media/video/tea5761.h
--- a/drivers/media/video/tea5761.h~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/tea5761.h
@@ -31,7 +31,7 @@ static inline int tea5761_autodetection(
 					u8 i2c_addr)
 {
 	printk(KERN_INFO "%s: not probed - driver disabled by Kconfig\n",
-	       __FUNCTION__);
+	       __func__);
 	return -EINVAL;
 }
 
@@ -39,7 +39,7 @@ static inline struct dvb_frontend *tea57
 						   struct i2c_adapter* i2c_adap,
 						   u8 i2c_addr)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif
diff -puN drivers/media/video/tea5767.h~v4l-video-replace-remaining-__function__-occurences drivers/media/video/tea5767.h
--- a/drivers/media/video/tea5767.h~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/tea5767.h
@@ -50,7 +50,7 @@ static inline int tea5767_autodetection(
 					u8 i2c_addr)
 {
 	printk(KERN_INFO "%s: not probed - driver disabled by Kconfig\n",
-	       __FUNCTION__);
+	       __func__);
 	return -EINVAL;
 }
 
@@ -58,7 +58,7 @@ static inline struct dvb_frontend *tea57
 						   struct i2c_adapter* i2c_adap,
 						   u8 i2c_addr)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif
diff -puN drivers/media/video/tea6415c.c~v4l-video-replace-remaining-__function__-occurences drivers/media/video/tea6415c.c
--- a/drivers/media/video/tea6415c.c~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/tea6415c.c
@@ -37,7 +37,7 @@ static int debug;		/* insmod parameter *
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Turn on/off device debugging (default:off).");
 #define dprintk(args...) \
-	    do { if (debug) { printk("%s: %s()[%d]: ", KBUILD_MODNAME, __FUNCTION__, __LINE__); printk(args); } } while (0)
+	    do { if (debug) { printk("%s: %s()[%d]: ", KBUILD_MODNAME, __func__, __LINE__); printk(args); } } while (0)
 
 #define TEA6415C_NUM_INPUTS	8
 #define TEA6415C_NUM_OUTPUTS	6
diff -puN drivers/media/video/tea6420.c~v4l-video-replace-remaining-__function__-occurences drivers/media/video/tea6420.c
--- a/drivers/media/video/tea6420.c~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/tea6420.c
@@ -37,7 +37,7 @@ static int debug;		/* insmod parameter *
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Turn on/off device debugging (default:off).");
 #define dprintk(args...) \
-	    do { if (debug) { printk("%s: %s()[%d]: ", KBUILD_MODNAME, __FUNCTION__, __LINE__); printk(args); } } while (0)
+	    do { if (debug) { printk("%s: %s()[%d]: ", KBUILD_MODNAME, __func__, __LINE__); printk(args); } } while (0)
 
 /* addresses to scan, found only at 0x4c and/or 0x4d (7-Bit) */
 static unsigned short normal_i2c[] = { I2C_ADDR_TEA6420_1, I2C_ADDR_TEA6420_2, I2C_CLIENT_END };
diff -puN drivers/media/video/tuner-simple.c~v4l-video-replace-remaining-__function__-occurences drivers/media/video/tuner-simple.c
--- a/drivers/media/video/tuner-simple.c~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/tuner-simple.c
@@ -999,7 +999,7 @@ struct dvb_frontend *simple_tuner_attach
 
 	if (type >= tuner_count) {
 		printk(KERN_WARNING "%s: invalid tuner type: %d (max: %d)\n",
-		       __FUNCTION__, type, tuner_count-1);
+		       __func__, type, tuner_count-1);
 		return NULL;
 	}
 
diff -puN drivers/media/video/tuner-simple.h~v4l-video-replace-remaining-__function__-occurences drivers/media/video/tuner-simple.h
--- a/drivers/media/video/tuner-simple.h~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/tuner-simple.h
@@ -31,7 +31,7 @@ static inline struct dvb_frontend *simpl
 						       u8 i2c_addr,
 						       unsigned int type)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif
diff -puN drivers/media/video/tuner-xc2028.c~v4l-video-replace-remaining-__function__-occurences drivers/media/video/tuner-xc2028.c
--- a/drivers/media/video/tuner-xc2028.c~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/tuner-xc2028.c
@@ -135,7 +135,7 @@ static unsigned int xc2028_get_reg(struc
 	unsigned char buf[2];
 	unsigned char ibuf[2];
 
-	tuner_dbg("%s %04x called\n", __FUNCTION__, reg);
+	tuner_dbg("%s %04x called\n", __func__, reg);
 
 	buf[0] = reg >> 8;
 	buf[1] = (unsigned char) reg;
@@ -260,7 +260,7 @@ static int load_all_firmwares(struct dvb
 	char		      name[33];
 	char		      *fname;
 
-	tuner_dbg("%s called\n", __FUNCTION__);
+	tuner_dbg("%s called\n", __func__);
 
 	if (!firmware_name[0])
 		fname = priv->ctrl.fname;
@@ -405,7 +405,7 @@ static int seek_firmware(struct dvb_fron
 	int                 i, best_i = -1, best_nr_matches = 0;
 	unsigned int        ign_firm_type_mask = 0;
 
-	tuner_dbg("%s called, want type=", __FUNCTION__);
+	tuner_dbg("%s called, want type=", __func__);
 	if (debug) {
 		dump_firm_type(type);
 		printk("(%x), id %016llx.\n", type, (unsigned long long)*id);
@@ -491,7 +491,7 @@ static int load_firmware(struct dvb_fron
 	int                pos, rc;
 	unsigned char      *p, *endp, buf[priv->ctrl.max_len];
 
-	tuner_dbg("%s called\n", __FUNCTION__);
+	tuner_dbg("%s called\n", __func__);
 
 	pos = seek_firmware(fe, type, id);
 	if (pos < 0)
@@ -594,7 +594,7 @@ static int load_scode(struct dvb_fronten
 	int                pos, rc;
 	unsigned char	   *p;
 
-	tuner_dbg("%s called\n", __FUNCTION__);
+	tuner_dbg("%s called\n", __func__);
 
 	if (!int_freq) {
 		pos = seek_firmware(fe, type, id);
@@ -658,7 +658,7 @@ static int check_firmware(struct dvb_fro
 	u16			   version, hwmodel;
 	v4l2_std_id		   std0;
 
-	tuner_dbg("%s called\n", __FUNCTION__);
+	tuner_dbg("%s called\n", __func__);
 
 	if (!priv->firm) {
 		if (!priv->ctrl.fname) {
@@ -832,7 +832,7 @@ static int xc2028_signal(struct dvb_fron
 	u16                 frq_lock, signal = 0;
 	int                 rc;
 
-	tuner_dbg("%s called\n", __FUNCTION__);
+	tuner_dbg("%s called\n", __func__);
 
 	mutex_lock(&priv->lock);
 
@@ -869,7 +869,7 @@ static int generic_set_freq(struct dvb_f
 	unsigned char	   buf[4];
 	u32		   div, offset = 0;
 
-	tuner_dbg("%s called\n", __FUNCTION__);
+	tuner_dbg("%s called\n", __func__);
 
 	mutex_lock(&priv->lock);
 
@@ -952,7 +952,7 @@ static int xc2028_set_analog_freq(struct
 	struct xc2028_data *priv = fe->tuner_priv;
 	unsigned int       type=0;
 
-	tuner_dbg("%s called\n", __FUNCTION__);
+	tuner_dbg("%s called\n", __func__);
 
 	if (p->mode == V4L2_TUNER_RADIO) {
 		type |= FM;
@@ -985,7 +985,7 @@ static int xc2028_set_params(struct dvb_
 	fe_bandwidth_t     bw = BANDWIDTH_8_MHZ;
 	u16                demod = 0;
 
-	tuner_dbg("%s called\n", __FUNCTION__);
+	tuner_dbg("%s called\n", __func__);
 
 	if (priv->ctrl.d2633)
 		type |= D2633;
@@ -1055,7 +1055,7 @@ static int xc2028_sleep(struct dvb_front
 	struct xc2028_data *priv = fe->tuner_priv;
 	int rc = 0;
 
-	tuner_dbg("%s called\n", __FUNCTION__);
+	tuner_dbg("%s called\n", __func__);
 
 	mutex_lock(&priv->lock);
 
@@ -1076,7 +1076,7 @@ static int xc2028_dvb_release(struct dvb
 {
 	struct xc2028_data *priv = fe->tuner_priv;
 
-	tuner_dbg("%s called\n", __FUNCTION__);
+	tuner_dbg("%s called\n", __func__);
 
 	mutex_lock(&xc2028_list_mutex);
 
@@ -1101,7 +1101,7 @@ static int xc2028_get_frequency(struct d
 {
 	struct xc2028_data *priv = fe->tuner_priv;
 
-	tuner_dbg("%s called\n", __FUNCTION__);
+	tuner_dbg("%s called\n", __func__);
 
 	*frequency = priv->frequency;
 
@@ -1114,7 +1114,7 @@ static int xc2028_set_config(struct dvb_
 	struct xc2028_ctrl *p    = priv_cfg;
 	int                 rc   = 0;
 
-	tuner_dbg("%s called\n", __FUNCTION__);
+	tuner_dbg("%s called\n", __func__);
 
 	mutex_lock(&priv->lock);
 
diff -puN drivers/media/video/tuner-xc2028.h~v4l-video-replace-remaining-__function__-occurences drivers/media/video/tuner-xc2028.h
--- a/drivers/media/video/tuner-xc2028.h~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/tuner-xc2028.h
@@ -55,7 +55,7 @@ static inline struct dvb_frontend *xc202
 						 struct xc2028_config *cfg)
 {
 	printk(KERN_INFO "%s: not probed - driver disabled by Kconfig\n",
-	       __FUNCTION__);
+	       __func__);
 	return NULL;
 }
 #endif
diff -puN drivers/media/video/usbvideo/konicawc.c~v4l-video-replace-remaining-__function__-occurences drivers/media/video/usbvideo/konicawc.c
--- a/drivers/media/video/usbvideo/konicawc.c~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/usbvideo/konicawc.c
@@ -57,7 +57,7 @@ static struct usbvideo *cams;
 static int debug;
 #define DEBUG(n, format, arg...) \
 	if (n <= debug) {	 \
-		printk(KERN_DEBUG __FILE__ ":%s(): " format "\n", __FUNCTION__ , ## arg); \
+		printk(KERN_DEBUG __FILE__ ":%s(): " format "\n", __func__ , ## arg); \
 	}
 #else
 #define DEBUG(n, arg...)
diff -puN drivers/media/video/usbvideo/quickcam_messenger.c~v4l-video-replace-remaining-__function__-occurences drivers/media/video/usbvideo/quickcam_messenger.c
--- a/drivers/media/video/usbvideo/quickcam_messenger.c~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/usbvideo/quickcam_messenger.c
@@ -46,7 +46,7 @@
 static int debug;
 #define DEBUG(n, format, arg...) \
 	if (n <= debug) {	 \
-		printk(KERN_DEBUG __FILE__ ":%s(): " format "\n", __FUNCTION__ , ## arg); \
+		printk(KERN_DEBUG __FILE__ ":%s(): " format "\n", __func__ , ## arg); \
 	}
 #else
 #define DEBUG(n, arg...)
diff -puN drivers/media/video/usbvideo/usbvideo.c~v4l-video-replace-remaining-__function__-occurences drivers/media/video/usbvideo/usbvideo.c
--- a/drivers/media/video/usbvideo/usbvideo.c~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/usbvideo/usbvideo.c
@@ -525,11 +525,11 @@ void usbvideo_TestPattern(struct uvd *uv
 	static int num_pass;
 
 	if (uvd == NULL) {
-		err("%s: uvd == NULL", __FUNCTION__);
+		err("%s: uvd == NULL", __func__);
 		return;
 	}
 	if ((uvd->curframe < 0) || (uvd->curframe >= USBVIDEO_NUMFRAMES)) {
-		err("%s: uvd->curframe=%d.", __FUNCTION__, uvd->curframe);
+		err("%s: uvd->curframe=%d.", __func__, uvd->curframe);
 		return;
 	}
 
@@ -630,15 +630,15 @@ EXPORT_SYMBOL(usbvideo_HexDump);
 static int usbvideo_ClientIncModCount(struct uvd *uvd)
 {
 	if (uvd == NULL) {
-		err("%s: uvd == NULL", __FUNCTION__);
+		err("%s: uvd == NULL", __func__);
 		return -EINVAL;
 	}
 	if (uvd->handle == NULL) {
-		err("%s: uvd->handle == NULL", __FUNCTION__);
+		err("%s: uvd->handle == NULL", __func__);
 		return -EINVAL;
 	}
 	if (!try_module_get(uvd->handle->md_module)) {
-		err("%s: try_module_get() == 0", __FUNCTION__);
+		err("%s: try_module_get() == 0", __func__);
 		return -ENODEV;
 	}
 	return 0;
@@ -647,15 +647,15 @@ static int usbvideo_ClientIncModCount(st
 static void usbvideo_ClientDecModCount(struct uvd *uvd)
 {
 	if (uvd == NULL) {
-		err("%s: uvd == NULL", __FUNCTION__);
+		err("%s: uvd == NULL", __func__);
 		return;
 	}
 	if (uvd->handle == NULL) {
-		err("%s: uvd->handle == NULL", __FUNCTION__);
+		err("%s: uvd->handle == NULL", __func__);
 		return;
 	}
 	if (uvd->handle->md_module == NULL) {
-		err("%s: uvd->handle->md_module == NULL", __FUNCTION__);
+		err("%s: uvd->handle->md_module == NULL", __func__);
 		return;
 	}
 	module_put(uvd->handle->md_module);
@@ -675,13 +675,13 @@ int usbvideo_register(
 
 	/* Check parameters for sanity */
 	if ((num_cams <= 0) || (pCams == NULL) || (cbTbl == NULL)) {
-		err("%s: Illegal call", __FUNCTION__);
+		err("%s: Illegal call", __func__);
 		return -EINVAL;
 	}
 
 	/* Check registration callback - must be set! */
 	if (cbTbl->probe == NULL) {
-		err("%s: probe() is required!", __FUNCTION__);
+		err("%s: probe() is required!", __func__);
 		return -EINVAL;
 	}
 
@@ -692,7 +692,7 @@ int usbvideo_register(
 		return -ENOMEM;
 	}
 	dbg("%s: Allocated $%p (%d. bytes) for %d. cameras",
-	    __FUNCTION__, cams, base_size, num_cams);
+	    __func__, cams, base_size, num_cams);
 
 	/* Copy callbacks, apply defaults for those that are not set */
 	memmove(&cams->cb, cbTbl, sizeof(cams->cb));
@@ -721,7 +721,7 @@ int usbvideo_register(
 			up->user_data = kmalloc(up->user_size, GFP_KERNEL);
 			if (up->user_data == NULL) {
 				err("%s: Failed to allocate user_data (%d. bytes)",
-				    __FUNCTION__, up->user_size);
+				    __func__, up->user_size);
 				while (i) {
 					up = &cams->cam[--i];
 					kfree(up->user_data);
@@ -730,7 +730,7 @@ int usbvideo_register(
 				return -ENOMEM;
 			}
 			dbg("%s: Allocated cams[%d].user_data=$%p (%d. bytes)",
-			     __FUNCTION__, i, up->user_data, up->user_size);
+			     __func__, i, up->user_data, up->user_size);
 		}
 	}
 
@@ -776,19 +776,19 @@ void usbvideo_Deregister(struct usbvideo
 	int i;
 
 	if (pCams == NULL) {
-		err("%s: pCams == NULL", __FUNCTION__);
+		err("%s: pCams == NULL", __func__);
 		return;
 	}
 	cams = *pCams;
 	if (cams == NULL) {
-		err("%s: cams == NULL", __FUNCTION__);
+		err("%s: cams == NULL", __func__);
 		return;
 	}
 
-	dbg("%s: Deregistering %s driver.", __FUNCTION__, cams->drvName);
+	dbg("%s: Deregistering %s driver.", __func__, cams->drvName);
 	usb_deregister(&cams->usbdrv);
 
-	dbg("%s: Deallocating cams=$%p (%d. cameras)", __FUNCTION__, cams, cams->num_cameras);
+	dbg("%s: Deallocating cams=$%p (%d. cameras)", __func__, cams, cams->num_cameras);
 	for (i=0; i < cams->num_cameras; i++) {
 		struct uvd *up = &cams->cam[i];
 		int warning = 0;
@@ -802,16 +802,16 @@ void usbvideo_Deregister(struct usbvideo
 		}
 		if (warning) {
 			err("%s: Warning: user_data=$%p user_size=%d.",
-			    __FUNCTION__, up->user_data, up->user_size);
+			    __func__, up->user_data, up->user_size);
 		} else {
 			dbg("%s: Freeing %d. $%p->user_data=$%p",
-			    __FUNCTION__, i, up, up->user_data);
+			    __func__, i, up, up->user_data);
 			kfree(up->user_data);
 		}
 	}
 	/* Whole array was allocated in one chunk */
 	dbg("%s: Freed %d uvd structures",
-	    __FUNCTION__, cams->num_cameras);
+	    __func__, cams->num_cameras);
 	kfree(cams);
 	*pCams = NULL;
 }
@@ -846,7 +846,7 @@ static void usbvideo_Disconnect(struct u
 	int i;
 
 	if (uvd == NULL) {
-		err("%s($%p): Illegal call.", __FUNCTION__, intf);
+		err("%s($%p): Illegal call.", __func__, intf);
 		return;
 	}
 
@@ -854,7 +854,7 @@ static void usbvideo_Disconnect(struct u
 
 	usbvideo_ClientIncModCount(uvd);
 	if (uvd->debug > 0)
-		info("%s(%p.)", __FUNCTION__, intf);
+		info("%s(%p.)", __func__, intf);
 
 	mutex_lock(&uvd->lock);
 	uvd->remove_pending = 1; /* Now all ISO data will be ignored */
@@ -870,10 +870,10 @@ static void usbvideo_Disconnect(struct u
 
 	video_unregister_device(&uvd->vdev);
 	if (uvd->debug > 0)
-		info("%s: Video unregistered.", __FUNCTION__);
+		info("%s: Video unregistered.", __func__);
 
 	if (uvd->user)
-		info("%s: In use, disconnect pending.", __FUNCTION__);
+		info("%s: In use, disconnect pending.", __func__);
 	else
 		usbvideo_CameraRelease(uvd);
 	mutex_unlock(&uvd->lock);
@@ -895,7 +895,7 @@ static void usbvideo_Disconnect(struct u
 static void usbvideo_CameraRelease(struct uvd *uvd)
 {
 	if (uvd == NULL) {
-		err("%s: Illegal call", __FUNCTION__);
+		err("%s: Illegal call", __func__);
 		return;
 	}
 
@@ -1013,18 +1013,18 @@ int usbvideo_RegisterVideoDevice(struct 
 	char tmp1[20], tmp2[20];	/* Buffers for printing */
 
 	if (uvd == NULL) {
-		err("%s: Illegal call.", __FUNCTION__);
+		err("%s: Illegal call.", __func__);
 		return -EINVAL;
 	}
 	if (uvd->video_endp == 0) {
-		info("%s: No video endpoint specified; data pump disabled.", __FUNCTION__);
+		info("%s: No video endpoint specified; data pump disabled.", __func__);
 	}
 	if (uvd->paletteBits == 0) {
-		err("%s: No palettes specified!", __FUNCTION__);
+		err("%s: No palettes specified!", __func__);
 		return -EINVAL;
 	}
 	if (uvd->defaultPalette == 0) {
-		info("%s: No default palette!", __FUNCTION__);
+		info("%s: No default palette!", __func__);
 	}
 
 	uvd->max_frame_size = VIDEOSIZE_X(uvd->canvas) *
@@ -1034,7 +1034,7 @@ int usbvideo_RegisterVideoDevice(struct 
 
 	if (uvd->debug > 0) {
 		info("%s: iface=%d. endpoint=$%02x paletteBits=$%08lx",
-		     __FUNCTION__, uvd->iface, uvd->video_endp, uvd->paletteBits);
+		     __func__, uvd->iface, uvd->video_endp, uvd->paletteBits);
 	}
 	if (uvd->dev == NULL) {
 		err("%s: uvd->dev == NULL", __func__);
@@ -1042,11 +1042,11 @@ int usbvideo_RegisterVideoDevice(struct 
 	}
 	uvd->vdev.dev = &uvd->dev->dev;
 	if (video_register_device(&uvd->vdev, VFL_TYPE_GRABBER, video_nr) == -1) {
-		err("%s: video_register_device failed", __FUNCTION__);
+		err("%s: video_register_device failed", __func__);
 		return -EPIPE;
 	}
 	if (uvd->debug > 1) {
-		info("%s: video_register_device() successful", __FUNCTION__);
+		info("%s: video_register_device() successful", __func__);
 	}
 
 	info("%s on /dev/video%d: canvas=%s videosize=%s",
@@ -1113,14 +1113,14 @@ static int usbvideo_v4l_open(struct inod
 	int i, errCode = 0;
 
 	if (uvd->debug > 1)
-		info("%s($%p)", __FUNCTION__, dev);
+		info("%s($%p)", __func__, dev);
 
 	if (0 < usbvideo_ClientIncModCount(uvd))
 		return -ENODEV;
 	mutex_lock(&uvd->lock);
 
 	if (uvd->user) {
-		err("%s: Someone tried to open an already opened device!", __FUNCTION__);
+		err("%s: Someone tried to open an already opened device!", __func__);
 		errCode = -EBUSY;
 	} else {
 		/* Clear statistics */
@@ -1136,7 +1136,7 @@ static int usbvideo_v4l_open(struct inod
 		RingQueue_Allocate(&uvd->dp, RING_QUEUE_SIZE);
 		if ((uvd->fbuf == NULL) ||
 		    (!RingQueue_IsAllocated(&uvd->dp))) {
-			err("%s: Failed to allocate fbuf or dp", __FUNCTION__);
+			err("%s: Failed to allocate fbuf or dp", __func__);
 			errCode = -ENOMEM;
 		} else {
 			/* Allocate all buffers */
@@ -1180,19 +1180,19 @@ static int usbvideo_v4l_open(struct inod
 		if (errCode == 0) {
 			if (VALID_CALLBACK(uvd, setupOnOpen)) {
 				if (uvd->debug > 1)
-					info("%s: setupOnOpen callback", __FUNCTION__);
+					info("%s: setupOnOpen callback", __func__);
 				errCode = GET_CALLBACK(uvd, setupOnOpen)(uvd);
 				if (errCode < 0) {
 					err("%s: setupOnOpen callback failed (%d.).",
-					    __FUNCTION__, errCode);
+					    __func__, errCode);
 				} else if (uvd->debug > 1) {
-					info("%s: setupOnOpen callback successful", __FUNCTION__);
+					info("%s: setupOnOpen callback successful", __func__);
 				}
 			}
 			if (errCode == 0) {
 				uvd->settingsAdjusted = 0;
 				if (uvd->debug > 1)
-					info("%s: Open succeeded.", __FUNCTION__);
+					info("%s: Open succeeded.", __func__);
 				uvd->user++;
 				file->private_data = uvd;
 			}
@@ -1202,7 +1202,7 @@ static int usbvideo_v4l_open(struct inod
 	if (errCode != 0)
 		usbvideo_ClientDecModCount(uvd);
 	if (uvd->debug > 0)
-		info("%s: Returning %d.", __FUNCTION__, errCode);
+		info("%s: Returning %d.", __func__, errCode);
 	return errCode;
 }
 
@@ -1225,7 +1225,7 @@ static int usbvideo_v4l_close(struct ino
 	int i;
 
 	if (uvd->debug > 1)
-		info("%s($%p)", __FUNCTION__, dev);
+		info("%s($%p)", __func__, dev);
 
 	mutex_lock(&uvd->lock);
 	GET_CALLBACK(uvd, stopDataPump)(uvd);
@@ -1252,7 +1252,7 @@ static int usbvideo_v4l_close(struct ino
 	usbvideo_ClientDecModCount(uvd);
 
 	if (uvd->debug > 1)
-		info("%s: Completed.", __FUNCTION__);
+		info("%s: Completed.", __func__);
 	file->private_data = NULL;
 	return 0;
 }
@@ -1506,7 +1506,7 @@ static ssize_t usbvideo_v4l_read(struct 
 		return -EFAULT;
 
 	if (uvd->debug >= 1)
-		info("%s: %Zd. bytes, noblock=%d.", __FUNCTION__, count, noblock);
+		info("%s: %Zd. bytes, noblock=%d.", __func__, count, noblock);
 
 	mutex_lock(&uvd->lock);
 
@@ -1553,7 +1553,7 @@ static ssize_t usbvideo_v4l_read(struct 
 	 */
 	if (frmx == -1) {
 		if (uvd->defaultPalette == 0) {
-			err("%s: No default palette; don't know what to do!", __FUNCTION__);
+			err("%s: No default palette; don't know what to do!", __func__);
 			count = -EFAULT;
 			goto read_done;
 		}
@@ -1625,7 +1625,7 @@ static ssize_t usbvideo_v4l_read(struct 
 	frame->seqRead_Index += count;
 	if (uvd->debug >= 1) {
 		err("%s: {copy} count used=%Zd, new seqRead_Index=%ld",
-			__FUNCTION__, count, frame->seqRead_Index);
+			__func__, count, frame->seqRead_Index);
 	}
 
 	/* Finally check if the frame is done with and "release" it */
@@ -1636,7 +1636,7 @@ static ssize_t usbvideo_v4l_read(struct 
 		/* Mark it as available to be used again. */
 		uvd->frame[frmx].frameState = FrameState_Unused;
 		if (usbvideo_NewFrame(uvd, (frmx + 1) % USBVIDEO_NUMFRAMES)) {
-			err("%s: usbvideo_NewFrame failed.", __FUNCTION__);
+			err("%s: usbvideo_NewFrame failed.", __func__);
 		}
 	}
 read_done:
@@ -1743,10 +1743,10 @@ static int usbvideo_StartDataPump(struct
 	int i, errFlag;
 
 	if (uvd->debug > 1)
-		info("%s($%p)", __FUNCTION__, uvd);
+		info("%s($%p)", __func__, uvd);
 
 	if (!CAMERA_IS_OPERATIONAL(uvd)) {
-		err("%s: Camera is not operational", __FUNCTION__);
+		err("%s: Camera is not operational", __func__);
 		return -EFAULT;
 	}
 	uvd->curframe = -1;
@@ -1754,14 +1754,14 @@ static int usbvideo_StartDataPump(struct
 	/* Alternate interface 1 is is the biggest frame size */
 	i = usb_set_interface(dev, uvd->iface, uvd->ifaceAltActive);
 	if (i < 0) {
-		err("%s: usb_set_interface error", __FUNCTION__);
+		err("%s: usb_set_interface error", __func__);
 		uvd->last_error = i;
 		return -EBUSY;
 	}
 	if (VALID_CALLBACK(uvd, videoStart))
 		GET_CALLBACK(uvd, videoStart)(uvd);
 	else
-		err("%s: videoStart not set", __FUNCTION__);
+		err("%s: videoStart not set", __func__);
 
 	/* We double buffer the Iso lists */
 	for (i=0; i < USBVIDEO_NUMSBUF; i++) {
@@ -1786,12 +1786,12 @@ static int usbvideo_StartDataPump(struct
 	for (i=0; i < USBVIDEO_NUMSBUF; i++) {
 		errFlag = usb_submit_urb(uvd->sbuf[i].urb, GFP_KERNEL);
 		if (errFlag)
-			err("%s: usb_submit_isoc(%d) ret %d", __FUNCTION__, i, errFlag);
+			err("%s: usb_submit_isoc(%d) ret %d", __func__, i, errFlag);
 	}
 
 	uvd->streaming = 1;
 	if (uvd->debug > 1)
-		info("%s: streaming=1 video_endp=$%02x", __FUNCTION__, uvd->video_endp);
+		info("%s: streaming=1 video_endp=$%02x", __func__, uvd->video_endp);
 	return 0;
 }
 
@@ -1813,14 +1813,14 @@ static void usbvideo_StopDataPump(struct
 		return;
 
 	if (uvd->debug > 1)
-		info("%s($%p)", __FUNCTION__, uvd);
+		info("%s($%p)", __func__, uvd);
 
 	/* Unschedule all of the iso td's */
 	for (i=0; i < USBVIDEO_NUMSBUF; i++) {
 		usb_kill_urb(uvd->sbuf[i].urb);
 	}
 	if (uvd->debug > 1)
-		info("%s: streaming=0", __FUNCTION__);
+		info("%s: streaming=0", __func__);
 	uvd->streaming = 0;
 
 	if (!uvd->remove_pending) {
@@ -1828,12 +1828,12 @@ static void usbvideo_StopDataPump(struct
 		if (VALID_CALLBACK(uvd, videoStop))
 			GET_CALLBACK(uvd, videoStop)(uvd);
 		else
-			err("%s: videoStop not set", __FUNCTION__);
+			err("%s: videoStop not set", __func__);
 
 		/* Set packet size to 0 */
 		j = usb_set_interface(uvd->dev, uvd->iface, uvd->ifaceAltInactive);
 		if (j < 0) {
-			err("%s: usb_set_interface() error %d.", __FUNCTION__, j);
+			err("%s: usb_set_interface() error %d.", __func__, j);
 			uvd->last_error = j;
 		}
 	}
@@ -1957,12 +1957,12 @@ static int usbvideo_GetFrame(struct uvd 
 	struct usbvideo_frame *frame = &uvd->frame[frameNum];
 
 	if (uvd->debug >= 2)
-		info("%s($%p,%d.)", __FUNCTION__, uvd, frameNum);
+		info("%s($%p,%d.)", __func__, uvd, frameNum);
 
 	switch (frame->frameState) {
 	case FrameState_Unused:
 		if (uvd->debug >= 2)
-			info("%s: FrameState_Unused", __FUNCTION__);
+			info("%s: FrameState_Unused", __func__);
 		return -EINVAL;
 	case FrameState_Ready:
 	case FrameState_Grabbing:
@@ -1972,7 +1972,7 @@ static int usbvideo_GetFrame(struct uvd 
 	redo:
 		if (!CAMERA_IS_OPERATIONAL(uvd)) {
 			if (uvd->debug >= 2)
-				info("%s: Camera is not operational (1)", __FUNCTION__);
+				info("%s: Camera is not operational (1)", __func__);
 			return -EIO;
 		}
 		ntries = 0;
@@ -1981,24 +1981,24 @@ static int usbvideo_GetFrame(struct uvd 
 			signalPending = signal_pending(current);
 			if (!CAMERA_IS_OPERATIONAL(uvd)) {
 				if (uvd->debug >= 2)
-					info("%s: Camera is not operational (2)", __FUNCTION__);
+					info("%s: Camera is not operational (2)", __func__);
 				return -EIO;
 			}
 			assert(uvd->fbuf != NULL);
 			if (signalPending) {
 				if (uvd->debug >= 2)
-					info("%s: Signal=$%08x", __FUNCTION__, signalPending);
+					info("%s: Signal=$%08x", __func__, signalPending);
 				if (uvd->flags & FLAGS_RETRY_VIDIOCSYNC) {
 					usbvideo_TestPattern(uvd, 1, 0);
 					uvd->curframe = -1;
 					uvd->stats.frame_num++;
 					if (uvd->debug >= 2)
-						info("%s: Forced test pattern screen", __FUNCTION__);
+						info("%s: Forced test pattern screen", __func__);
 					return 0;
 				} else {
 					/* Standard answer: Interrupted! */
 					if (uvd->debug >= 2)
-						info("%s: Interrupted!", __FUNCTION__);
+						info("%s: Interrupted!", __func__);
 					return -EINTR;
 				}
 			} else {
@@ -2008,17 +2008,17 @@ static int usbvideo_GetFrame(struct uvd 
 				else if (VALID_CALLBACK(uvd, processData))
 					GET_CALLBACK(uvd, processData)(uvd, frame);
 				else
-					err("%s: processData not set", __FUNCTION__);
+					err("%s: processData not set", __func__);
 			}
 		} while (frame->frameState == FrameState_Grabbing);
 		if (uvd->debug >= 2) {
 			info("%s: Grabbing done; state=%d. (%lu. bytes)",
-			     __FUNCTION__, frame->frameState, frame->seqRead_Length);
+			     __func__, frame->frameState, frame->seqRead_Length);
 		}
 		if (frame->frameState == FrameState_Error) {
 			int ret = usbvideo_NewFrame(uvd, frameNum);
 			if (ret < 0) {
-				err("%s: usbvideo_NewFrame() failed (%d.)", __FUNCTION__, ret);
+				err("%s: usbvideo_NewFrame() failed (%d.)", __func__, ret);
 				return ret;
 			}
 			goto redo;
@@ -2050,7 +2050,7 @@ static int usbvideo_GetFrame(struct uvd 
 		}
 		frame->frameState = FrameState_Done_Hold;
 		if (uvd->debug >= 2)
-			info("%s: Entered FrameState_Done_Hold state.", __FUNCTION__);
+			info("%s: Entered FrameState_Done_Hold state.", __func__);
 		return 0;
 
 	case FrameState_Done_Hold:
@@ -2061,12 +2061,12 @@ static int usbvideo_GetFrame(struct uvd 
 		 * it will be released back into the wild to roam freely.
 		 */
 		if (uvd->debug >= 2)
-			info("%s: FrameState_Done_Hold state.", __FUNCTION__);
+			info("%s: FrameState_Done_Hold state.", __func__);
 		return 0;
 	}
 
 	/* Catch-all for other cases. We shall not be here. */
-	err("%s: Invalid state %d.", __FUNCTION__, frame->frameState);
+	err("%s: Invalid state %d.", __func__, frame->frameState);
 	frame->frameState = FrameState_Unused;
 	return 0;
 }
@@ -2162,7 +2162,7 @@ static void usbvideo_SoftwareContrastAdj
 	const int ccm = 128; /* Color correction median - see below */
 
 	if ((uvd == NULL) || (frame == NULL)) {
-		err("%s: Illegal call.", __FUNCTION__);
+		err("%s: Illegal call.", __func__);
 		return;
 	}
 	adj = (uvd->vpic.contrast - 0x8000) >> 8; /* -128..+127 = -ccm..+(ccm-1)*/
diff -puN drivers/media/video/usbvideo/vicam.c~v4l-video-replace-remaining-__function__-occurences drivers/media/video/usbvideo/vicam.c
--- a/drivers/media/video/usbvideo/vicam.c~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/usbvideo/vicam.c
@@ -48,7 +48,7 @@
 // #define VICAM_DEBUG
 
 #ifdef VICAM_DEBUG
-#define ADBG(lineno,fmt,args...) printk(fmt, jiffies, __FUNCTION__, lineno, ##args)
+#define ADBG(lineno,fmt,args...) printk(fmt, jiffies, __func__, lineno, ##args)
 #define DBG(fmt,args...) ADBG((__LINE__),KERN_DEBUG __FILE__"(%ld):%s (%d):"fmt,##args)
 #else
 #define DBG(fmn,args...) do {} while(0)
diff -puN drivers/media/video/videobuf-core.c~v4l-video-replace-remaining-__function__-occurences drivers/media/video/videobuf-core.c
--- a/drivers/media/video/videobuf-core.c~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/videobuf-core.c
@@ -966,7 +966,7 @@ ssize_t videobuf_read_stream(struct vide
 
 	MAGIC_CHECK(q->int_ops->magic, MAGIC_QTYPE_OPS);
 
-	dprintk(2, "%s\n", __FUNCTION__);
+	dprintk(2, "%s\n", __func__);
 	mutex_lock(&q->vb_lock);
 	retval = -EBUSY;
 	if (q->streaming)
diff -puN drivers/media/video/videobuf-dma-sg.c~v4l-video-replace-remaining-__function__-occurences drivers/media/video/videobuf-dma-sg.c
--- a/drivers/media/video/videobuf-dma-sg.c~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/videobuf-dma-sg.c
@@ -252,7 +252,7 @@ int videobuf_dma_map(struct videobuf_que
 					dma->nr_pages, dma->direction);
 		if (0 == dma->sglen) {
 			printk(KERN_WARNING
-			       "%s: videobuf_map_sg failed\n",__FUNCTION__);
+			       "%s: videobuf_map_sg failed\n",__func__);
 			kfree(dma->sglist);
 			dma->sglist = NULL;
 			dma->sglen = 0;
@@ -430,7 +430,7 @@ static void *__videobuf_alloc(size_t siz
 	videobuf_dma_init(&mem->dma);
 
 	dprintk(1,"%s: allocated at %p(%ld+%ld) & %p(%ld)\n",
-		__FUNCTION__,vb,(long)sizeof(*vb),(long)size-sizeof(*vb),
+		__func__,vb,(long)sizeof(*vb),(long)size-sizeof(*vb),
 		mem,(long)sizeof(*mem));
 
 	return vb;
diff -puN drivers/media/video/videobuf-vmalloc.c~v4l-video-replace-remaining-__function__-occurences drivers/media/video/videobuf-vmalloc.c
--- a/drivers/media/video/videobuf-vmalloc.c~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/videobuf-vmalloc.c
@@ -114,7 +114,7 @@ static void *__videobuf_alloc(size_t siz
 	mem->magic=MAGIC_VMAL_MEM;
 
 	dprintk(1,"%s: allocated at %p(%ld+%ld) & %p(%ld)\n",
-		__FUNCTION__,vb,(long)sizeof(*vb),(long)size-sizeof(*vb),
+		__func__,vb,(long)sizeof(*vb),(long)size-sizeof(*vb),
 		mem,(long)sizeof(*mem));
 
 	return vb;
diff -puN drivers/media/video/videodev.c~v4l-video-replace-remaining-__function__-occurences drivers/media/video/videodev.c
--- a/drivers/media/video/videodev.c~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/videodev.c
@@ -2019,7 +2019,7 @@ int video_register_device(struct video_d
 			break;
 		default:
 			printk(KERN_ERR "%s called with unknown type: %d\n",
-			       __FUNCTION__, type);
+			       __func__, type);
 			return -1;
 	}
 
@@ -2057,7 +2057,7 @@ int video_register_device(struct video_d
 	ret = device_register(&vfd->class_dev);
 	if (ret < 0) {
 		printk(KERN_ERR "%s: device_register failed\n",
-		       __FUNCTION__);
+		       __func__);
 		goto fail_minor;
 	}
 
diff -puN drivers/media/video/vivi.c~v4l-video-replace-remaining-__function__-occurences drivers/media/video/vivi.c
--- a/drivers/media/video/vivi.c~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/vivi.c
@@ -426,7 +426,7 @@ static void vivi_sleep(struct vivi_fh *f
 	int timeout;
 	DECLARE_WAITQUEUE(wait, current);
 
-	dprintk(dev, 1, "%s dma_q=0x%08lx\n", __FUNCTION__,
+	dprintk(dev, 1, "%s dma_q=0x%08lx\n", __func__,
 		(unsigned long)dma_q);
 
 	add_wait_queue(&dma_q->wq, &wait);
@@ -472,7 +472,7 @@ static int vivi_start_thread(struct vivi
 	dma_q->frame = 0;
 	dma_q->ini_jiffies = jiffies;
 
-	dprintk(dev, 1, "%s\n", __FUNCTION__);
+	dprintk(dev, 1, "%s\n", __func__);
 
 	dma_q->kthread = kthread_run(vivi_thread, fh, "vivi");
 
@@ -483,7 +483,7 @@ static int vivi_start_thread(struct vivi
 	/* Wakes thread */
 	wake_up_interruptible(&dma_q->wq);
 
-	dprintk(dev, 1, "returning from %s\n", __FUNCTION__);
+	dprintk(dev, 1, "returning from %s\n", __func__);
 	return 0;
 }
 
@@ -491,7 +491,7 @@ static void vivi_stop_thread(struct vivi
 {
 	struct vivi_dev *dev = container_of(dma_q, struct vivi_dev, vidq);
 
-	dprintk(dev, 1, "%s\n", __FUNCTION__);
+	dprintk(dev, 1, "%s\n", __func__);
 	/* shutdown control thread */
 	if (dma_q->kthread) {
 		kthread_stop(dma_q->kthread);
@@ -516,7 +516,7 @@ buffer_setup(struct videobuf_queue *vq, 
 	while (*size * *count > vid_limit * 1024 * 1024)
 		(*count)--;
 
-	dprintk(dev, 1, "%s, count=%d, size=%d\n", __FUNCTION__,
+	dprintk(dev, 1, "%s, count=%d, size=%d\n", __func__,
 		*count, *size);
 
 	return 0;
@@ -527,7 +527,7 @@ static void free_buffer(struct videobuf_
 	struct vivi_fh  *fh = vq->priv_data;
 	struct vivi_dev *dev  = fh->dev;
 
-	dprintk(dev, 1, "%s, state: %i\n", __FUNCTION__, buf->vb.state);
+	dprintk(dev, 1, "%s, state: %i\n", __func__, buf->vb.state);
 
 	if (in_interrupt())
 		BUG();
@@ -548,7 +548,7 @@ buffer_prepare(struct videobuf_queue *vq
 	struct vivi_buffer *buf = container_of(vb, struct vivi_buffer, vb);
 	int rc;
 
-	dprintk(dev, 1, "%s, field=%d\n", __FUNCTION__, field);
+	dprintk(dev, 1, "%s, field=%d\n", __func__, field);
 
 	BUG_ON(NULL == fh->fmt);
 
@@ -589,7 +589,7 @@ buffer_queue(struct videobuf_queue *vq, 
 	struct vivi_dev       *dev  = fh->dev;
 	struct vivi_dmaqueue *vidq = &dev->vidq;
 
-	dprintk(dev, 1, "%s\n", __FUNCTION__);
+	dprintk(dev, 1, "%s\n", __func__);
 
 	buf->vb.state = VIDEOBUF_QUEUED;
 	list_add_tail(&buf->vb.queue, &vidq->active);
@@ -602,7 +602,7 @@ static void buffer_release(struct videob
 	struct vivi_fh       *fh   = vq->priv_data;
 	struct vivi_dev      *dev  = (struct vivi_dev *)fh->dev;
 
-	dprintk(dev, 1, "%s\n", __FUNCTION__);
+	dprintk(dev, 1, "%s\n", __func__);
 
 	free_buffer(vq, buf);
 }
@@ -718,7 +718,7 @@ static int vidioc_s_fmt_cap(struct file 
 	mutex_lock(&q->vb_lock);
 
 	if (videobuf_queue_is_busy(&fh->vb_vidq)) {
-		dprintk(fh->dev, 1, "%s queue busy\n", __FUNCTION__);
+		dprintk(fh->dev, 1, "%s queue busy\n", __func__);
 		ret = -EBUSY;
 		goto out;
 	}
@@ -974,7 +974,7 @@ vivi_poll(struct file *file, struct poll
 	struct vivi_dev       *dev = fh->dev;
 	struct videobuf_queue *q = &fh->vb_vidq;
 
-	dprintk(dev, 1, "%s\n", __FUNCTION__);
+	dprintk(dev, 1, "%s\n", __func__);
 
 	if (V4L2_BUF_TYPE_VIDEO_CAPTURE != fh->type)
 		return POLLERR;
diff -puN drivers/media/video/w9966.c~v4l-video-replace-remaining-__function__-occurences drivers/media/video/w9966.c
--- a/drivers/media/video/w9966.c~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/w9966.c
@@ -64,7 +64,7 @@
 /*#define DEBUG*/				/* Undef me for production */
 
 #ifdef DEBUG
-#define DPRINTF(x, a...) printk(KERN_DEBUG "W9966: %s(): "x, __FUNCTION__ , ##a)
+#define DPRINTF(x, a...) printk(KERN_DEBUG "W9966: %s(): "x, __func__ , ##a)
 #else
 #define DPRINTF(x...)
 #endif
diff -puN drivers/media/video/w9968cf.h~v4l-video-replace-remaining-__function__-occurences drivers/media/video/w9968cf.h
--- a/drivers/media/video/w9968cf.h~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/w9968cf.h
@@ -298,7 +298,7 @@ struct w9968cf_device {
 			dev_warn(&cam->dev, fmt "\n", ## args);               \
 		else if ((level) >= 5)                                        \
 			dev_info(&cam->dev, "[%s:%d] " fmt "\n",              \
-				 __FUNCTION__, __LINE__ , ## args);           \
+				 __func__, __LINE__ , ## args);           \
 	}                                                                     \
 }
 /* For generic kernel (not device specific) messages */
@@ -309,7 +309,7 @@ struct w9968cf_device {
 		if ((level) >= 1 && (level) <= 4)                             \
 			pr_info("w9968cf: " fmt "\n", ## args);               \
 		else if ((level) >= 5)                                        \
-			pr_debug("w9968cf: [%s:%d] " fmt "\n", __FUNCTION__,  \
+			pr_debug("w9968cf: [%s:%d] " fmt "\n", __func__,  \
 				 __LINE__ , ## args);                         \
 	}                                                                     \
 }
@@ -321,7 +321,7 @@ struct w9968cf_device {
 
 #undef PDBG
 #define PDBG(fmt, args...)                                                    \
-dev_info(&cam->dev, "[%s:%d] " fmt "\n", __FUNCTION__, __LINE__ , ## args);
+dev_info(&cam->dev, "[%s:%d] " fmt "\n", __func__, __LINE__ , ## args);
 
 #undef PDBGG
 #define PDBGG(fmt, args...) do {;} while(0); /* nothing: it's a placeholder */
diff -puN drivers/media/video/zc0301/zc0301.h~v4l-video-replace-remaining-__function__-occurences drivers/media/video/zc0301/zc0301.h
--- a/drivers/media/video/zc0301/zc0301.h~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/zc0301/zc0301.h
@@ -160,7 +160,7 @@ do {                                    
 			dev_info(&cam->usbdev->dev, fmt "\n", ## args);       \
 		else if ((level) >= 3)                                        \
 			dev_info(&cam->usbdev->dev, "[%s:%s:%d] " fmt "\n",   \
-				 __FILE__, __FUNCTION__, __LINE__ , ## args); \
+				 __FILE__, __func__, __LINE__ , ## args); \
 	}                                                                     \
 } while (0)
 #	define KDBG(level, fmt, args...)                                      \
@@ -170,7 +170,7 @@ do {                                    
 			pr_info("zc0301: " fmt "\n", ## args);                \
 		else if ((level) == 3)                                        \
 			pr_debug("sn9c102: [%s:%s:%d] " fmt "\n", __FILE__,   \
-				 __FUNCTION__, __LINE__ , ## args);           \
+				 __func__, __LINE__ , ## args);           \
 	}                                                                     \
 } while (0)
 #	define V4LDBG(level, name, cmd)                                       \
@@ -186,7 +186,7 @@ do {                                    
 
 #undef PDBG
 #define PDBG(fmt, args...)                                                    \
-dev_info(&cam->usbdev->dev, "[%s:%s:%d] " fmt "\n", __FILE__, __FUNCTION__,   \
+dev_info(&cam->usbdev->dev, "[%s:%s:%d] " fmt "\n", __FILE__, __func__,   \
 	 __LINE__ , ## args)
 
 #undef PDBGG
diff -puN drivers/media/video/zoran_driver.c~v4l-video-replace-remaining-__function__-occurences drivers/media/video/zoran_driver.c
--- a/drivers/media/video/zoran_driver.c~v4l-video-replace-remaining-__function__-occurences
+++ a/drivers/media/video/zoran_driver.c
@@ -4247,7 +4247,7 @@ zoran_poll (struct file *file,
 		dprintk(3,
 			KERN_DEBUG
 			"%s: %s() raw - active=%c, sync_tail=%lu/%c, pend_tail=%lu, pend_head=%lu\n",
-			ZR_DEVNAME(zr), __FUNCTION__,
+			ZR_DEVNAME(zr), __func__,
 			"FAL"[fh->v4l_buffers.active], zr->v4l_sync_tail,
 			"UPMD"[zr->v4l_buffers.buffer[frame].state],
 			zr->v4l_pend_tail, zr->v4l_pend_head);
@@ -4269,7 +4269,7 @@ zoran_poll (struct file *file,
 		dprintk(3,
 			KERN_DEBUG
 			"%s: %s() jpg - active=%c, que_tail=%lu/%c, que_head=%lu, dma=%lu/%lu\n",
-			ZR_DEVNAME(zr), __FUNCTION__,
+			ZR_DEVNAME(zr), __func__,
 			"FAL"[fh->jpg_buffers.active], zr->jpg_que_tail,
 			"UPMD"[zr->jpg_buffers.buffer[frame].state],
 			zr->jpg_que_head, zr->jpg_dma_tail, zr->jpg_dma_head);
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

