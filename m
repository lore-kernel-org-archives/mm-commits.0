From: akpm@linux-foundation.org
Subject: + add-missing-newlines-to-some-uses-of-dev_level-messages.patch added to -mm tree
Date: Wed, 15 Aug 2007 13:37:19 -0700
Message-ID: <200708152037.l7FKbJ7T013799@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51424 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936357AbXHOUkN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 16:40:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, James.Smart@Emulex.Com, a.zummo@towertech.it, adaplas@pol.net, andrew.vasquez@qlogic.com, david-b@pacbell.net, dwmw2@infradead.org, geert@linux-m68k.org, greg@kroah.com, jeff@garzik.org, jens.axboe@oracle.com, jeremy@goop.org, johnpol@2ka.mipt.ru, mhoffman@lightlink.com, perex@suse.cz, rmk@arm.linux.org.uk, rolandd@cisco.com, shemminger@linux-foundation.org, tilman@imap.cc, tiwai@suse.de, tony.luck@intel.com


The patch titled
     Add missing newlines to some uses of dev_<level> messages
has been added to the -mm tree.  Its filename is
     add-missing-newlines-to-some-uses-of-dev_level-messages.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add missing newlines to some uses of dev_<level> messages
From: Joe Perches <joe@perches.com>

Found these while looking at printk uses.

Add missing newlines to dev_<level> uses
Add missing KERN_<level> prefixes to multiline dev_<level>s
Fixed a wierd->weird spelling typo
Added a newline to a printk

Signed-off-by: Joe Perches <joe@perches.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Mark M. Hoffman <mhoffman@lightlink.com>
Cc: Roland Dreier <rolandd@cisco.com>
Cc: Tilman Schmidt <tilman@imap.cc>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Stephen Hemminger <shemminger@osdl.org>
Cc: Greg KH <greg@kroah.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Cc: James Smart <James.Smart@Emulex.Com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/sn/kernel/xpnet.c            |   13 ++++----
 drivers/block/xsysace.c                |    4 +-
 drivers/char/isicom.c                  |   10 ++++--
 drivers/hwmon/adm1026.c                |    2 -
 drivers/hwmon/lm63.c                   |    2 -
 drivers/hwmon/vt1211.c                 |    2 -
 drivers/hwmon/w83791d.c                |    2 -
 drivers/hwmon/w83792d.c                |    4 +-
 drivers/i2c/busses/i2c-pmcmsp.c        |    8 ++---
 drivers/i2c/busses/i2c-pnx.c           |    2 -
 drivers/i2c/chips/menelaus.c           |    2 -
 drivers/infiniband/hw/ehca/ehca_main.c |    4 +-
 drivers/isdn/gigaset/common.c          |    3 +-
 drivers/mtd/nand/s3c2410.c             |    2 -
 drivers/net/ax88796.c                  |    2 -
 drivers/net/bnx2.c                     |    2 -
 drivers/net/ehea/ehea_main.c           |    9 +++---
 drivers/net/myri10ge/myri10ge.c        |    3 +-
 drivers/net/sky2.c                     |    2 -
 drivers/net/usb/mcs7830.c              |   16 +++++-----
 drivers/net/xen-netfront.c             |    2 -
 drivers/power/ds2760_battery.c         |    2 -
 drivers/ps3/ps3stor_lib.c              |    2 -
 drivers/rtc/rtc-sysfs.c                |    5 +--
 drivers/scsi/lpfc/lpfc_sli.c           |    8 +++--
 drivers/scsi/qla4xxx/ql4_os.c          |    2 -
 drivers/spi/atmel_spi.c                |    2 -
 drivers/spi/spi_bfin5xx.c              |    2 -
 drivers/spi/spi_imx.c                  |    4 +-
 drivers/usb/class/cdc-acm.c            |   34 +++++++++++------------
 drivers/usb/core/endpoint.c            |    2 -
 drivers/usb/core/message.c             |    4 +-
 drivers/usb/host/ohci-s3c2410.c        |    2 -
 drivers/usb/misc/adutux.c              |    4 +-
 drivers/usb/misc/iowarrior.c           |    8 ++---
 drivers/usb/misc/phidgetmotorcontrol.c |    2 -
 drivers/usb/serial/ftdi_sio.c          |    4 +-
 drivers/usb/serial/io_edgeport.c       |    2 -
 drivers/usb/serial/ipw.c               |   18 ++++++------
 drivers/usb/serial/mos7720.c           |    4 +-
 drivers/usb/serial/oti6858.c           |    2 -
 drivers/usb/serial/sierra.c            |   10 +++---
 drivers/video/gxt4500.c                |    2 -
 drivers/video/omap/blizzard.c          |    2 -
 drivers/video/omap/dispc.c             |    6 ++--
 drivers/video/omap/hwa742.c            |    2 -
 drivers/video/omap/rfbi.c              |    4 +-
 drivers/video/s3c2410fb.c              |    2 -
 drivers/w1/masters/ds1wm.c             |    2 -
 drivers/xen/xenbus/xenbus_probe.c      |    5 ++-
 sound/arm/aaci.c                       |    4 +-
 51 files changed, 129 insertions(+), 119 deletions(-)

diff -puN arch/ia64/sn/kernel/xpnet.c~add-missing-newlines-to-some-uses-of-dev_level-messages arch/ia64/sn/kernel/xpnet.c
--- a/arch/ia64/sn/kernel/xpnet.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/arch/ia64/sn/kernel/xpnet.c
@@ -269,8 +269,9 @@ xpnet_receive(partid_t partid, int chann
 	skb->protocol = eth_type_trans(skb, xpnet_device);
 	skb->ip_summed = CHECKSUM_UNNECESSARY;
 
-	dev_dbg(xpnet, "passing skb to network layer; \n\tskb->head=0x%p "
-		"skb->data=0x%p skb->tail=0x%p skb->end=0x%p skb->len=%d\n",
+	dev_dbg(xpnet, "passing skb to network layer\n"
+		KERN_DEBUG "\tskb->head=0x%p skb->data=0x%p skb->tail=0x%p "
+		"skb->end=0x%p skb->len=%d\n",
 		(void *)skb->head, (void *)skb->data, skb_tail_pointer(skb),
 		skb_end_pointer(skb), skb->len);
 
@@ -576,10 +577,10 @@ xpnet_dev_hard_start_xmit(struct sk_buff
 		msg->tailout_ignore = end_addr - (u64)skb_tail_pointer(skb);
 		msg->buf_pa = __pa(start_addr);
 
-		dev_dbg(xpnet, "sending XPC message to %d:%d\nmsg->buf_pa="
-			"0x%lx, msg->size=%u, msg->leadin_ignore=%u, "
-			"msg->tailout_ignore=%u\n", dest_partid,
-			XPC_NET_CHANNEL, msg->buf_pa, msg->size,
+		dev_dbg(xpnet, "sending XPC message to %d:%d\n"
+			KERN_DEBUG "msg->buf_pa=0x%lx, msg->size=%u, "
+			"msg->leadin_ignore=%u, msg->tailout_ignore=%u\n",
+			dest_partid, XPC_NET_CHANNEL, msg->buf_pa, msg->size,
 			msg->leadin_ignore, msg->tailout_ignore);
 
 
diff -puN drivers/block/xsysace.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/block/xsysace.c
--- a/drivers/block/xsysace.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/block/xsysace.c
@@ -383,8 +383,8 @@ static inline void ace_dump_mem(void *ba
 static void ace_dump_regs(struct ace_device *ace)
 {
 	dev_info(ace->dev, "    ctrl:  %.8x  seccnt/cmd: %.4x      ver:%.4x\n"
-		 "    status:%.8x  mpu_lba:%.8x  busmode:%4x\n"
-		 "    error: %.8x  cfg_lba:%.8x  fatstat:%.4x\n",
+		 KERN_INFO "    status:%.8x  mpu_lba:%.8x  busmode:%4x\n"
+		 KERN_INFO "    error: %.8x  cfg_lba:%.8x  fatstat:%.4x\n",
 		 ace_in32(ace, ACE_CTRL),
 		 ace_in(ace, ACE_SECCNTCMD),
 		 ace_in(ace, ACE_VERSION),
diff -puN drivers/char/isicom.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/char/isicom.c
--- a/drivers/char/isicom.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/char/isicom.c
@@ -1529,7 +1529,7 @@ static int __devinit reset_card(struct p
 	portcount = inw(base + 0x2);
 	if (!inw(base + 0xe) & 0x1 || (portcount != 0 && portcount != 4 &&
 				portcount != 8 && portcount != 16)) {
-		dev_err(&pdev->dev, "ISILoad:PCI Card%d reset failure.",
+		dev_err(&pdev->dev, "ISILoad:PCI Card%d reset failure.\n",
 			card + 1);
 		retval = -EIO;
 		goto end;
@@ -1622,7 +1622,9 @@ static int __devinit load_firmware(struc
 
 		if ((status = inw(base + 0x4)) != 0) {
 			dev_warn(&pdev->dev, "Card%d rejected load header:\n"
-				"Address:0x%x\nCount:0x%x\nStatus:0x%x\n",
+				KERN_WARNING "Address:0x%x\n"
+				KERN_WARNING "Count:0x%x\n"
+				KERN_WARNING "Status:0x%x\n",
 				index + 1, frame->addr, frame->count, status);
 			goto errrelfw;
 		}
@@ -1666,7 +1668,9 @@ static int __devinit load_firmware(struc
 
 		if ((status = inw(base + 0x4)) != 0) {
 			dev_warn(&pdev->dev, "Card%d rejected verify header:\n"
-				"Address:0x%x\nCount:0x%x\nStatus: 0x%x\n",
+				KERN_WARNING "Address:0x%x\n"
+				KERN_WARNING "Count:0x%x\n"
+				KERN_WARNING "Status: 0x%x\n",
 				index + 1, frame->addr, frame->count, status);
 			goto errrelfw;
 		}
diff -puN drivers/hwmon/adm1026.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/hwmon/adm1026.c
--- a/drivers/hwmon/adm1026.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/hwmon/adm1026.c
@@ -1651,7 +1651,7 @@ static int adm1026_detect(struct i2c_ada
 		break;
 	default :
 		dev_err(&adapter->dev, ": Internal error, invalid "
-			"kind (%d)!", kind);
+			"kind (%d)!\n", kind);
 		err = -EFAULT;
 		goto exitfree;
 	}
diff -puN drivers/hwmon/lm63.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/hwmon/lm63.c
--- a/drivers/hwmon/lm63.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/hwmon/lm63.c
@@ -533,7 +533,7 @@ static void lm63_init_client(struct i2c_
 
 	/* Start converting if needed */
 	if (data->config & 0x40) { /* standby */
-		dev_dbg(&client->dev, "Switching to operational mode");
+		dev_dbg(&client->dev, "Switching to operational mode\n");
 		data->config &= 0xA7;
 		i2c_smbus_write_byte_data(client, LM63_REG_CONFIG1,
 					  data->config);
diff -puN drivers/hwmon/vt1211.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/hwmon/vt1211.c
--- a/drivers/hwmon/vt1211.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/hwmon/vt1211.c
@@ -795,7 +795,7 @@ static ssize_t set_pwm_auto_point_pwm(st
 
 	if ((val < 0) || (val > 255)) {
 		dev_err(dev, "pwm value %ld is out of range. "
-			"Choose a value between 0 and 255." , val);
+			"Choose a value between 0 and 255.\n" , val);
 		return -EINVAL;
 	}
 
diff -puN drivers/hwmon/w83791d.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/hwmon/w83791d.c
--- a/drivers/hwmon/w83791d.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/hwmon/w83791d.c
@@ -982,7 +982,7 @@ static int w83791d_detect(struct i2c_ada
 	if (kind == w83791d) {
 		client_name = "w83791d";
 	} else {
-		dev_err(dev, "w83791d: Internal error: unknown kind (%d)?!?",
+		dev_err(dev, "w83791d: Internal error: unknown kind (%d)?!?\n",
 			kind);
 		goto error1;
 	}
diff -puN drivers/hwmon/w83792d.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/hwmon/w83792d.c
--- a/drivers/hwmon/w83792d.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/hwmon/w83792d.c
@@ -1385,8 +1385,8 @@ w83792d_detect(struct i2c_adapter *adapt
 	if (kind == w83792d) {
 		client_name = "w83792d";
 	} else {
-		dev_err(dev, "w83792d: Internal error: unknown"
-					  " kind (%d)?!?", kind);
+		dev_err(dev, "w83792d: Internal error: unknown kind (%d)?!?\n",
+			kind);
 		goto ERROR1;
 	}
 
diff -puN drivers/i2c/busses/i2c-pmcmsp.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/i2c/busses/i2c-pmcmsp.c
--- a/drivers/i2c/busses/i2c-pmcmsp.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/i2c/busses/i2c-pmcmsp.c
@@ -591,18 +591,18 @@ static int pmcmsptwi_master_xfer(struct 
 	if (msg->flags & I2C_M_TEN)
 		pmcmsptwi_set_twi_config(&oldcfg, data);
 
-	dev_dbg(&adap->dev, "I2C %s of %d bytes ",
-		(msg->flags & I2C_M_RD) ? "read" : "write", msg->len);
+	dev_dbg(&adap->dev, "I2C %s of %d bytes %s\n",
+		(msg->flags & I2C_M_RD) ? "read" : "write", msg->len,
+		(ret == MSP_TWI_XFER_OK) ? "succeeded" : "failed");
+
 	if (ret != MSP_TWI_XFER_OK) {
 		/*
 		 * TODO: We could potentially loop and retry in the case
 		 * of MSP_TWI_XFER_TIMEOUT.
 		 */
-		dev_dbg(&adap->dev, "failed\n");
 		return -1;
 	}
 
-	dev_dbg(&adap->dev, "succeeded\n");
 	return 0;
 }
 
diff -puN drivers/i2c/busses/i2c-pnx.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/i2c/busses/i2c-pnx.c
--- a/drivers/i2c/busses/i2c-pnx.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/i2c/busses/i2c-pnx.c
@@ -575,7 +575,7 @@ static int __devinit i2c_pnx_probe(struc
 	else {
 		freq_mhz = PNX_DEFAULT_FREQ;
 		dev_info(&pdev->dev, "Setting bus frequency to default value: "
-		       "%d MHz", freq_mhz);
+		       "%d MHz\n", freq_mhz);
 	}
 
 	i2c_pnx->adapter->algo = &pnx_algorithm;
diff -puN drivers/i2c/chips/menelaus.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/i2c/chips/menelaus.c
--- a/drivers/i2c/chips/menelaus.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/i2c/chips/menelaus.c
@@ -1197,7 +1197,7 @@ static int menelaus_probe(struct i2c_cli
 		err = request_irq(client->irq, menelaus_irq, IRQF_DISABLED,
 				  DRIVER_NAME, menelaus);
 		if (err) {
-			dev_dbg(&client->dev,  "can't get IRQ %d, err %d",
+			dev_dbg(&client->dev,  "can't get IRQ %d, err %d\n",
 					client->irq, err);
 			goto fail1;
 		}
diff -puN drivers/infiniband/hw/ehca/ehca_main.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/infiniband/hw/ehca/ehca_main.c
--- a/drivers/infiniband/hw/ehca/ehca_main.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/infiniband/hw/ehca/ehca_main.c
@@ -577,12 +577,12 @@ static ssize_t  ehca_show_##name(struct 
 									   \
 	rblock = ehca_alloc_fw_ctrlblock(GFP_KERNEL);			   \
 	if (!rblock) {						           \
-		dev_err(dev, "Can't allocate rblock memory.");		   \
+		dev_err(dev, "Can't allocate rblock memory.\n");           \
 		return 0;						   \
 	}								   \
 									   \
 	if (hipz_h_query_hca(shca->ipz_hca_handle, rblock) != H_SUCCESS) { \
-		dev_err(dev, "Can't query device properties");	   	   \
+		dev_err(dev, "Can't query device properties\n");           \
 		ehca_free_fw_ctrlblock(rblock);			   	   \
 		return 0;					   	   \
 	}								   \
diff -puN drivers/isdn/gigaset/common.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/isdn/gigaset/common.c
--- a/drivers/isdn/gigaset/common.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/isdn/gigaset/common.c
@@ -534,7 +534,8 @@ int gigaset_fill_inbuf(struct inbuf_t *i
 			n = RBUFSIZE - tail;
 		if (!n) {
 			dev_err(inbuf->cs->dev,
-				"buffer overflow (%u bytes lost)", bytesleft);
+				"buffer overflow (%u bytes lost)\n",
+				bytesleft);
 			break;
 		}
 		if (n > bytesleft)
diff -puN drivers/mtd/nand/s3c2410.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/mtd/nand/s3c2410.c
--- a/drivers/mtd/nand/s3c2410.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/mtd/nand/s3c2410.c
@@ -696,7 +696,7 @@ static int s3c24xx_nand_probe(struct pla
 
 	info->clk = clk_get(&pdev->dev, "nand");
 	if (IS_ERR(info->clk)) {
-		dev_err(&pdev->dev, "failed to get clock");
+		dev_err(&pdev->dev, "failed to get clock\n");
 		err = -ENOENT;
 		goto exit_error;
 	}
diff -puN drivers/net/ax88796.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/net/ax88796.c
--- a/drivers/net/ax88796.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/net/ax88796.c
@@ -851,7 +851,7 @@ static int ax_probe(struct platform_devi
 
 		ax->map2 = ioremap(res->start, size);
 		if (ax->map2 == NULL) {
-			dev_err(&pdev->dev, "cannot map reset register");
+			dev_err(&pdev->dev, "cannot map reset register\n");
 			ret = -ENXIO;
 			goto exit_mem2;
 		}
diff -puN drivers/net/bnx2.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/net/bnx2.c
--- a/drivers/net/bnx2.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/net/bnx2.c
@@ -6471,7 +6471,7 @@ bnx2_init_board(struct pci_dev *pdev, st
 	/* enable device (incl. PCI PM wakeup), and bus-mastering */
 	rc = pci_enable_device(pdev);
 	if (rc) {
-		dev_err(&pdev->dev, "Cannot enable PCI device, aborting.");
+		dev_err(&pdev->dev, "Cannot enable PCI device, aborting.\n");
 		goto err_out;
 	}
 
diff -puN drivers/net/ehea/ehea_main.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/net/ehea/ehea_main.c
--- a/drivers/net/ehea/ehea_main.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/net/ehea/ehea_main.c
@@ -2991,7 +2991,8 @@ static int __devinit ehea_probe_adapter(
 	/* get adapter properties */
 	ret = ehea_sense_adapter_attr(adapter);
 	if (ret) {
-		dev_err(&dev->ofdev.dev, "sense_adapter_attr failed: %d", ret);
+		dev_err(&dev->ofdev.dev, "sense_adapter_attr failed: %d\n",
+			ret);
 		goto out_free_ad;
 	}
 
@@ -2999,7 +3000,7 @@ static int __devinit ehea_probe_adapter(
 				      EHEA_NEQ, EHEA_MAX_ENTRIES_EQ, 1);
 	if (!adapter->neq) {
 		ret = -EIO;
-		dev_err(&dev->ofdev.dev, "NEQ creation failed");
+		dev_err(&dev->ofdev.dev, "NEQ creation failed\n");
 		goto out_free_ad;
 	}
 
@@ -3010,7 +3011,7 @@ static int __devinit ehea_probe_adapter(
 				  ehea_interrupt_neq, IRQF_DISABLED,
 				  "ehea_neq", adapter);
 	if (ret) {
-		dev_err(&dev->ofdev.dev, "requesting NEQ IRQ failed");
+		dev_err(&dev->ofdev.dev, "requesting NEQ IRQ failed\n");
 		goto out_kill_eq;
 	}
 
@@ -3026,7 +3027,7 @@ static int __devinit ehea_probe_adapter(
 
 	ret = ehea_setup_ports(adapter);
 	if (ret) {
-		dev_err(&dev->ofdev.dev, "setup_ports failed");
+		dev_err(&dev->ofdev.dev, "setup_ports failed\n");
 		goto out_rem_dev_sysfs;
 	}
 
diff -puN drivers/net/myri10ge/myri10ge.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/net/myri10ge/myri10ge.c
--- a/drivers/net/myri10ge/myri10ge.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/net/myri10ge/myri10ge.c
@@ -3010,7 +3010,8 @@ static int myri10ge_probe(struct pci_dev
 	if (status != 0) {
 		dac_enabled = 0;
 		dev_err(&pdev->dev,
-			"64-bit pci address mask was refused, trying 32-bit");
+			"64-bit pci address mask was refused, "
+			"trying 32-bit\n");
 		status = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
 	}
 	if (status != 0) {
diff -puN drivers/net/sky2.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/net/sky2.c
--- a/drivers/net/sky2.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/net/sky2.c
@@ -3742,7 +3742,7 @@ static __devinit struct net_device *sky2
 	struct net_device *dev = alloc_etherdev(sizeof(*sky2));
 
 	if (!dev) {
-		dev_err(&hw->pdev->dev, "etherdev alloc failed");
+		dev_err(&hw->pdev->dev, "etherdev alloc failed\n");
 		return NULL;
 	}
 
diff -puN drivers/net/usb/mcs7830.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/net/usb/mcs7830.c
--- a/drivers/net/usb/mcs7830.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/net/usb/mcs7830.c
@@ -114,8 +114,8 @@ static void mcs7830_async_cmd_callback(s
 	struct usb_ctrlrequest *req = (struct usb_ctrlrequest *)urb->context;
 
 	if (urb->status < 0)
-		printk(KERN_DEBUG "mcs7830_async_cmd_callback() failed with %d",
-			urb->status);
+		printk(KERN_DEBUG "%s() failed with %d\n",
+		       __FUNCTION__, urb->status);
 
 	kfree(req);
 	usb_free_urb(urb);
@@ -129,15 +129,15 @@ static void mcs7830_set_reg_async(struct
 
 	urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if (!urb) {
-		dev_dbg(&dev->udev->dev, "Error allocating URB "
-				"in write_cmd_async!");
+		dev_dbg(&dev->udev->dev,
+			"Error allocating URB in write_cmd_async!\n");
 		return;
 	}
 
 	req = kmalloc(sizeof *req, GFP_ATOMIC);
 	if (!req) {
-		dev_err(&dev->udev->dev, "Failed to allocate memory for "
-				"control request");
+		dev_err(&dev->udev->dev,
+			"Failed to allocate memory for control request\n");
 		goto out;
 	}
 	req->bRequestType = MCS7830_WR_BMREQ;
@@ -153,8 +153,8 @@ static void mcs7830_set_reg_async(struct
 
 	ret = usb_submit_urb(urb, GFP_ATOMIC);
 	if (ret < 0) {
-		dev_err(&dev->udev->dev, "Error submitting the control "
-				"message: ret=%d", ret);
+		dev_err(&dev->udev->dev,
+			"Error submitting the control message: ret=%d\n", ret);
 		goto out;
 	}
 	return;
diff -puN drivers/net/xen-netfront.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/net/xen-netfront.c
--- a/drivers/net/xen-netfront.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/net/xen-netfront.c
@@ -1537,7 +1537,7 @@ static int xennet_connect(struct net_dev
 
 	if (!feature_rx_copy) {
 		dev_info(&dev->dev,
-			 "backend does not support copying recieve path");
+			 "backend does not support copying receive path\n");
 		return -ENODEV;
 	}
 
diff -puN drivers/power/ds2760_battery.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/power/ds2760_battery.c
--- a/drivers/power/ds2760_battery.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/power/ds2760_battery.c
@@ -366,7 +366,7 @@ static int ds2760_battery_probe(struct p
 
 	retval = power_supply_register(&pdev->dev, &di->bat);
 	if (retval) {
-		dev_err(di->dev, "failed to register battery");
+		dev_err(di->dev, "failed to register battery\n");
 		goto batt_failed;
 	}
 
diff -puN drivers/ps3/ps3stor_lib.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/ps3/ps3stor_lib.c
--- a/drivers/ps3/ps3stor_lib.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/ps3/ps3stor_lib.c
@@ -66,7 +66,7 @@ static int ps3stor_probe_access(struct p
 	if (n > 1)
 		dev_info(&dev->sbd.core,
 			 "%s:%u: %lu accessible regions found. Only the first "
-			 "one will be used",
+			 "one will be used\n",
 			 __func__, __LINE__, n);
 	dev->region_idx = __ffs(dev->accessible_regions);
 	dev_info(&dev->sbd.core,
diff -puN drivers/rtc/rtc-sysfs.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/rtc/rtc-sysfs.c
--- a/drivers/rtc/rtc-sysfs.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/rtc/rtc-sysfs.c
@@ -176,9 +176,8 @@ void rtc_sysfs_add_device(struct rtc_dev
 
 	err = device_create_file(&rtc->dev, &dev_attr_wakealarm);
 	if (err)
-		dev_err(rtc->dev.parent, "failed to create "
-				"alarm attribute, %d",
-				err);
+		dev_err(rtc->dev.parent,
+			"failed to create alarm attribute, %d\n", err);
 }
 
 void rtc_sysfs_del_device(struct rtc_device *rtc)
diff -puN drivers/scsi/lpfc/lpfc_sli.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/scsi/lpfc/lpfc_sli.c
@@ -1243,7 +1243,8 @@ void lpfc_sli_poll_fcp_ring(struct lpfc_
 				memset(adaptermsg, 0, LPFC_MAX_ADPTMSG);
 				memcpy(&adaptermsg[0], (uint8_t *) irsp,
 				       MAX_MSG_DATA);
-				dev_warn(&((phba->pcidev)->dev), "lpfc%d: %s",
+				dev_warn(&((phba->pcidev)->dev),
+					 "lpfc%d: %s\n",
 					 phba->brd_no, adaptermsg);
 			} else {
 				/* Unknown IOCB command */
@@ -1430,7 +1431,8 @@ lpfc_sli_handle_fast_ring_event(struct l
 				memset(adaptermsg, 0, LPFC_MAX_ADPTMSG);
 				memcpy(&adaptermsg[0], (uint8_t *) irsp,
 				       MAX_MSG_DATA);
-				dev_warn(&((phba->pcidev)->dev), "lpfc%d: %s",
+				dev_warn(&((phba->pcidev)->dev),
+					 "lpfc%d: %s\n",
 					 phba->brd_no, adaptermsg);
 			} else {
 				/* Unknown IOCB command */
@@ -1681,7 +1683,7 @@ lpfc_sli_handle_slow_ring_event(struct l
 					memcpy(&adaptermsg[0], (uint8_t *) irsp,
 					       MAX_MSG_DATA);
 					dev_warn(&((phba->pcidev)->dev),
-						 "lpfc%d: %s",
+						 "lpfc%d: %s\n",
 						 phba->brd_no, adaptermsg);
 				} else {
 					/* Unknown IOCB command */
diff -puN drivers/scsi/qla4xxx/ql4_os.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/scsi/qla4xxx/ql4_os.c
--- a/drivers/scsi/qla4xxx/ql4_os.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/scsi/qla4xxx/ql4_os.c
@@ -1285,7 +1285,7 @@ static int __devinit qla4xxx_probe_adapt
 
         ret = scsi_init_shared_tag_map(host, MAX_SRBS);
         if (ret) {
-                dev_warn(&ha->pdev->dev, "scsi_init_shared_tag_map failed");
+                dev_warn(&ha->pdev->dev, "scsi_init_shared_tag_map failed\n");
                 goto probe_failed;
         }
 
diff -puN drivers/spi/atmel_spi.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/spi/atmel_spi.c
--- a/drivers/spi/atmel_spi.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/spi/atmel_spi.c
@@ -364,7 +364,7 @@ atmel_spi_interrupt(int irq, void *dev_i
 				break;
 		if (!timeout)
 			dev_warn(master->cdev.dev,
-				 "timeout waiting for TXEMPTY");
+				 "timeout waiting for TXEMPTY\n");
 		while (spi_readl(as, SR) & SPI_BIT(RDRF))
 			spi_readl(as, RDR);
 
diff -puN drivers/spi/spi_bfin5xx.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/spi/spi_bfin5xx.c
@@ -1070,7 +1070,7 @@ static int setup(struct spi_device *spi)
 		return -ENODEV;
 	}
 
-	dev_dbg(&spi->dev, "setup spi chip %s, width is %d, dma is %d,",
+	dev_dbg(&spi->dev, "setup spi chip %s, width is %d, dma is %d\n",
 			spi->modalias, chip->width, chip->enable_dma);
 	dev_dbg(&spi->dev, "ctl_reg is 0x%x, flag_reg is 0x%x\n",
 			chip->ctl_reg, chip->flag);
diff -puN drivers/spi/spi_imx.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/spi/spi_imx.c
--- a/drivers/spi/spi_imx.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/spi/spi_imx.c
@@ -1194,7 +1194,7 @@ static int setup(struct spi_device *spi)
 		chip = kzalloc(sizeof(struct chip_data), GFP_KERNEL);
 		if (!chip) {
 			dev_err(&spi->dev,
-				"setup - cannot allocate controller state");
+				"setup - cannot allocate controller state\n");
 			return -ENOMEM;
 		}
 		chip->control = SPI_DEFAULT_CONTROL;
@@ -1206,7 +1206,7 @@ static int setup(struct spi_device *spi)
 			if (!chip_info) {
 				dev_err(&spi->dev,
 					"setup - "
-					"cannot allocate controller data");
+					"cannot allocate controller data\n");
 				status = -ENOMEM;
 				goto err_first_setup;
 			}
diff -puN drivers/usb/class/cdc-acm.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/usb/class/cdc-acm.c
--- a/drivers/usb/class/cdc-acm.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/usb/class/cdc-acm.c
@@ -332,7 +332,7 @@ static void acm_read_bulk(struct urb *ur
 		return;
 
 	if (status)
-		dev_dbg(&acm->data->dev, "bulk rx status %d", status);
+		dev_dbg(&acm->data->dev, "bulk rx status %d\n", status);
 
 	buf = rcv->buffer;
 	buf->size = urb->actual_length;
@@ -831,13 +831,13 @@ static int acm_probe (struct usb_interfa
 	
 	/* normal probing*/
 	if (!buffer) {
-		err("Wierd descriptor references\n");
+		err("Weird descriptor references\n");
 		return -EINVAL;
 	}
 
 	if (!buflen) {
 		if (intf->cur_altsetting->endpoint->extralen && intf->cur_altsetting->endpoint->extra) {
-			dev_dbg(&intf->dev,"Seeking extra descriptors on endpoint");
+			dev_dbg(&intf->dev,"Seeking extra descriptors on endpoint\n");
 			buflen = intf->cur_altsetting->endpoint->extralen;
 			buffer = intf->cur_altsetting->endpoint->extra;
 		} else {
@@ -887,24 +887,24 @@ next_desc:
 
 	if (!union_header) {
 		if (call_interface_num > 0) {
-			dev_dbg(&intf->dev,"No union descriptor, using call management descriptor");
+			dev_dbg(&intf->dev,"No union descriptor, using call management descriptor\n");
 			data_interface = usb_ifnum_to_if(usb_dev, (data_interface_num = call_interface_num));
 			control_interface = intf;
 		} else {
-			dev_dbg(&intf->dev,"No union descriptor, giving up");
+			dev_dbg(&intf->dev,"No union descriptor, giving up\n");
 			return -ENODEV;
 		}
 	} else {
 		control_interface = usb_ifnum_to_if(usb_dev, union_header->bMasterInterface0);
 		data_interface = usb_ifnum_to_if(usb_dev, (data_interface_num = union_header->bSlaveInterface0));
 		if (!control_interface || !data_interface) {
-			dev_dbg(&intf->dev,"no interfaces");
+			dev_dbg(&intf->dev,"no interfaces\n");
 			return -ENODEV;
 		}
 	}
 	
 	if (data_interface_num != call_interface_num)
-		dev_dbg(&intf->dev,"Seperate call control interface. That is not fully supported.");
+		dev_dbg(&intf->dev,"Seperate call control interface. That is not fully supported.\n");
 
 skip_normal_probe:
 
@@ -912,7 +912,7 @@ skip_normal_probe:
 	if (data_interface->cur_altsetting->desc.bInterfaceClass != CDC_DATA_INTERFACE_TYPE) {
 		if (control_interface->cur_altsetting->desc.bInterfaceClass == CDC_DATA_INTERFACE_TYPE) {
 			struct usb_interface *t;
-			dev_dbg(&intf->dev,"Your device has switched interfaces.");
+			dev_dbg(&intf->dev,"Your device has switched interfaces.\n");
 
 			t = control_interface;
 			control_interface = data_interface;
@@ -927,7 +927,7 @@ skip_normal_probe:
 		return -ENODEV;
 	
 	if (usb_interface_claimed(data_interface)) { /* valid in this context */
-		dev_dbg(&intf->dev,"The data interface isn't available");
+		dev_dbg(&intf->dev,"The data interface isn't available\n");
 		return -EBUSY;
 	}
 
@@ -944,7 +944,7 @@ skip_normal_probe:
 	if (!usb_endpoint_dir_in(epread)) {
 		/* descriptors are swapped */
 		struct usb_endpoint_descriptor *t;
-		dev_dbg(&intf->dev,"The data interface has switched endpoints");
+		dev_dbg(&intf->dev,"The data interface has switched endpoints\n");
 		
 		t = epread;
 		epread = epwrite;
@@ -959,7 +959,7 @@ skip_normal_probe:
 	}
 
 	if (!(acm = kzalloc(sizeof(struct acm), GFP_KERNEL))) {
-		dev_dbg(&intf->dev, "out of memory (acm kzalloc)");
+		dev_dbg(&intf->dev, "out of memory (acm kzalloc)\n");
 		goto alloc_fail;
 	}
 
@@ -985,26 +985,26 @@ skip_normal_probe:
 
 	buf = usb_buffer_alloc(usb_dev, ctrlsize, GFP_KERNEL, &acm->ctrl_dma);
 	if (!buf) {
-		dev_dbg(&intf->dev, "out of memory (ctrl buffer alloc)");
+		dev_dbg(&intf->dev, "out of memory (ctrl buffer alloc)\n");
 		goto alloc_fail2;
 	}
 	acm->ctrl_buffer = buf;
 
 	if (acm_write_buffers_alloc(acm) < 0) {
-		dev_dbg(&intf->dev, "out of memory (write buffer alloc)");
+		dev_dbg(&intf->dev, "out of memory (write buffer alloc)\n");
 		goto alloc_fail4;
 	}
 
 	acm->ctrlurb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!acm->ctrlurb) {
-		dev_dbg(&intf->dev, "out of memory (ctrlurb kmalloc)");
+		dev_dbg(&intf->dev, "out of memory (ctrlurb kmalloc)\n");
 		goto alloc_fail5;
 	}
 	for (i = 0; i < num_rx_buf; i++) {
 		struct acm_ru *rcv = &(acm->ru[i]);
 
 		if (!(rcv->urb = usb_alloc_urb(0, GFP_KERNEL))) {
-			dev_dbg(&intf->dev, "out of memory (read urbs usb_alloc_urb)");
+			dev_dbg(&intf->dev, "out of memory (read urbs usb_alloc_urb)\n");
 			goto alloc_fail7;
 		}
 
@@ -1015,13 +1015,13 @@ skip_normal_probe:
 		struct acm_rb *buf = &(acm->rb[i]);
 
 		if (!(buf->base = usb_buffer_alloc(acm->dev, readsize, GFP_KERNEL, &buf->dma))) {
-			dev_dbg(&intf->dev, "out of memory (read bufs usb_buffer_alloc)");
+			dev_dbg(&intf->dev, "out of memory (read bufs usb_buffer_alloc)\n");
 			goto alloc_fail7;
 		}
 	}
 	acm->writeurb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!acm->writeurb) {
-		dev_dbg(&intf->dev, "out of memory (writeurb kmalloc)");
+		dev_dbg(&intf->dev, "out of memory (writeurb kmalloc)\n");
 		goto alloc_fail7;
 	}
 
diff -puN drivers/usb/core/endpoint.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/usb/core/endpoint.c
--- a/drivers/usb/core/endpoint.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/usb/core/endpoint.c
@@ -292,7 +292,7 @@ int usb_create_ep_files(struct device *p
 
 	retval = endpoint_get_minor(ep_dev);
 	if (retval) {
-		dev_err(parent, "can not allocate minor number for %s",
+		dev_err(parent, "can not allocate minor number for %s\n",
 			ep_dev->dev.bus_id);
 		goto error_register;
 	}
diff -puN drivers/usb/core/message.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/usb/core/message.c
--- a/drivers/usb/core/message.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/usb/core/message.c
@@ -1515,7 +1515,7 @@ int usb_set_configuration(struct usb_dev
 		new_interfaces = kmalloc(nintf * sizeof(*new_interfaces),
 				GFP_KERNEL);
 		if (!new_interfaces) {
-			dev_err(&dev->dev, "Out of memory");
+			dev_err(&dev->dev, "Out of memory\n");
 			return -ENOMEM;
 		}
 
@@ -1524,7 +1524,7 @@ int usb_set_configuration(struct usb_dev
 					sizeof(struct usb_interface),
 					GFP_KERNEL);
 			if (!new_interfaces[n]) {
-				dev_err(&dev->dev, "Out of memory");
+				dev_err(&dev->dev, "Out of memory\n");
 				ret = -ENOMEM;
 free_interfaces:
 				while (--n >= 0)
diff -puN drivers/usb/host/ohci-s3c2410.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/usb/host/ohci-s3c2410.c
--- a/drivers/usb/host/ohci-s3c2410.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/usb/host/ohci-s3c2410.c
@@ -358,7 +358,7 @@ static int usb_hcd_s3c2410_probe (const 
 	hcd->rsrc_len   = dev->resource[0].end - dev->resource[0].start + 1;
 
 	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, hcd_name)) {
-		dev_err(&dev->dev, "request_mem_region failed");
+		dev_err(&dev->dev, "request_mem_region failed\n");
 		retval = -EBUSY;
 		goto err_put;
 	}
diff -puN drivers/usb/misc/adutux.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/usb/misc/adutux.c
--- a/drivers/usb/misc/adutux.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/usb/misc/adutux.c
@@ -804,7 +804,7 @@ static int adu_probe(struct usb_interfac
 	dev->minor = interface->minor;
 
 	/* let the user know what node this device is now attached to */
-	dev_info(&interface->dev, "ADU%d %s now attached to /dev/usb/adutux%d",
+	dev_info(&interface->dev, "ADU%d %s now attached to /dev/usb/adutux%d\n",
 		 udev->descriptor.idProduct, dev->serial_number,
 		 (dev->minor - ADU_MINOR_BASE));
 exit:
@@ -850,7 +850,7 @@ static void adu_disconnect(struct usb_in
 		mutex_unlock(&dev->mtx);
 	}
 
-	dev_info(&interface->dev, "ADU device adutux%d now disconnected",
+	dev_info(&interface->dev, "ADU device adutux%d now disconnected\n",
 		 (minor - ADU_MINOR_BASE));
 
 	dbg(2," %s : leave", __FUNCTION__);
diff -puN drivers/usb/misc/iowarrior.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/usb/misc/iowarrior.c
--- a/drivers/usb/misc/iowarrior.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/usb/misc/iowarrior.c
@@ -216,7 +216,7 @@ static void iowarrior_callback(struct ur
 exit:
 	retval = usb_submit_urb(urb, GFP_ATOMIC);
 	if (retval)
-		dev_err(&dev->interface->dev, "%s - usb_submit_urb failed with result %d",
+		dev_err(&dev->interface->dev, "%s - usb_submit_urb failed with result %d\n",
 			__FUNCTION__, retval);
 
 }
@@ -451,7 +451,7 @@ static ssize_t iowarrior_write(struct fi
 		break;
 	default:
 		/* what do we have here ? An unsupported Product-ID ? */
-		dev_err(&dev->interface->dev, "%s - not supported for product=0x%x",
+		dev_err(&dev->interface->dev, "%s - not supported for product=0x%x\n",
 			__FUNCTION__, dev->product_id);
 		retval = -EFAULT;
 		goto exit;
@@ -526,7 +526,7 @@ static int iowarrior_ioctl(struct inode 
 		} else {
 			retval = -EINVAL;
 			dev_err(&dev->interface->dev,
-				"ioctl 'IOW_WRITE' is not supported for product=0x%x.",
+				"ioctl 'IOW_WRITE' is not supported for product=0x%x.\n",
 				dev->product_id);
 		}
 		break;
@@ -752,7 +752,7 @@ static int iowarrior_probe(struct usb_in
 	/* allocate memory for our device state and intialize it */
 	dev = kzalloc(sizeof(struct iowarrior), GFP_KERNEL);
 	if (dev == NULL) {
-		dev_err(&interface->dev, "Out of memory");
+		dev_err(&interface->dev, "Out of memory\n");
 		return retval;
 	}
 
diff -puN drivers/usb/misc/phidgetmotorcontrol.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/usb/misc/phidgetmotorcontrol.c
--- a/drivers/usb/misc/phidgetmotorcontrol.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/usb/misc/phidgetmotorcontrol.c
@@ -155,7 +155,7 @@ resubmit:
 	retval = usb_submit_urb(urb, GFP_ATOMIC);
 	if (retval)
 		dev_err(&mc->intf->dev,
-			"can't resubmit intr, %s-%s/motorcontrol0, retval %d",
+			"can't resubmit intr, %s-%s/motorcontrol0, retval %d\n",
 			mc->udev->bus->bus_name,
 			mc->udev->devpath, retval);
 }
diff -puN drivers/usb/serial/ftdi_sio.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/usb/serial/ftdi_sio.c
--- a/drivers/usb/serial/ftdi_sio.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/usb/serial/ftdi_sio.c
@@ -1070,7 +1070,7 @@ static ssize_t show_latency_timer(struct
 			     (char*) &latency, 1, WDR_TIMEOUT);
 
 	if (rv < 0) {
-		dev_err(dev, "Unable to read latency timer: %i", rv);
+		dev_err(dev, "Unable to read latency timer: %i\n", rv);
 		return -EIO;
 	}
 	return sprintf(buf, "%i\n", latency);
@@ -1097,7 +1097,7 @@ static ssize_t store_latency_timer(struc
 			     buf, 0, WDR_TIMEOUT);
 
 	if (rv < 0) {
-		dev_err(dev, "Unable to write latency timer: %i", rv);
+		dev_err(dev, "Unable to write latency timer: %i\n", rv);
 		return -EIO;
 	}
 
diff -puN drivers/usb/serial/io_edgeport.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/usb/serial/io_edgeport.c
--- a/drivers/usb/serial/io_edgeport.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/usb/serial/io_edgeport.c
@@ -2882,7 +2882,7 @@ static int edge_startup (struct usb_seri
 	    (edge_serial->product_info.NumPorts != serial->num_ports)) {
 		dev_warn(&serial->dev->dev, "Device Reported %d serial ports "
 			 "vs. core thinking we have %d ports, email "
-			 "greg@kroah.com this information.",
+			 "greg@kroah.com this information.\n",
 			 edge_serial->product_info.NumPorts,
 			 serial->num_ports);
 	}
diff -puN drivers/usb/serial/ipw.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/usb/serial/ipw.c
--- a/drivers/usb/serial/ipw.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/usb/serial/ipw.c
@@ -227,7 +227,7 @@ static int ipw_open(struct usb_serial_po
 				 0,
 				 100000);
 	if (result < 0)
-		dev_err(&port->dev, "Init of modem failed (error = %d)", result);
+		dev_err(&port->dev, "Init of modem failed (error = %d)\n", result);
 
 	/* reset the bulk pipes */
 	usb_clear_halt(dev, usb_rcvbulkpipe(dev, port->bulk_in_endpointAddress));
@@ -255,7 +255,7 @@ static int ipw_open(struct usb_serial_po
 				 0,
 				 100000);
 	if (result < 0) 
-		dev_err(&port->dev, "Enabling bulk RxRead failed (error = %d)", result);
+		dev_err(&port->dev, "Enabling bulk RxRead failed (error = %d)\n", result);
 
 	/*--4: setup the initial flowcontrol */
 	dbg("%s:setting init flowcontrol (%s)",__FUNCTION__,buf_flow_init);
@@ -268,7 +268,7 @@ static int ipw_open(struct usb_serial_po
 				 0x10,
 				 200000);
 	if (result < 0)
-		dev_err(&port->dev, "initial flowcontrol failed (error = %d)", result);
+		dev_err(&port->dev, "initial flowcontrol failed (error = %d)\n", result);
 
 
 	/*--5: raise the dtr */
@@ -282,7 +282,7 @@ static int ipw_open(struct usb_serial_po
 				 0,
 				 200000);
 	if (result < 0)
-		dev_err(&port->dev, "setting dtr failed (error = %d)", result);
+		dev_err(&port->dev, "setting dtr failed (error = %d)\n", result);
 
 	/*--6: raise the rts */
 	dbg("%s:raising rts",__FUNCTION__);
@@ -295,7 +295,7 @@ static int ipw_open(struct usb_serial_po
 				 0,
 				 200000);
 	if (result < 0)
-		dev_err(&port->dev, "setting dtr failed (error = %d)", result);
+		dev_err(&port->dev, "setting dtr failed (error = %d)\n", result);
 	
 	kfree(buf_flow_init);
 	return 0;
@@ -322,7 +322,7 @@ static void ipw_close(struct usb_serial_
 				 0,
 				 200000);
 	if (result < 0)
-		dev_err(&port->dev, "dropping dtr failed (error = %d)", result);
+		dev_err(&port->dev, "dropping dtr failed (error = %d)\n", result);
 
 	/*--2: drop the rts */
 	dbg("%s:dropping rts",__FUNCTION__);
@@ -334,7 +334,7 @@ static void ipw_close(struct usb_serial_
 				 0,
 				 200000);
 	if (result < 0)
-		dev_err(&port->dev, "dropping rts failed (error = %d)", result);
+		dev_err(&port->dev, "dropping rts failed (error = %d)\n", result);
 
 
 	/*--3: purge */
@@ -347,7 +347,7 @@ static void ipw_close(struct usb_serial_
 				 0,
 				 200000);
 	if (result < 0)
-		dev_err(&port->dev, "purge failed (error = %d)", result);
+		dev_err(&port->dev, "purge failed (error = %d)\n", result);
 
 
 	/* send RXBULK_off (tell modem to stop transmitting bulk data on rx chan) */
@@ -361,7 +361,7 @@ static void ipw_close(struct usb_serial_
 				 100000);
 
 	if (result < 0)
-		dev_err(&port->dev, "Disabling bulk RxRead failed (error = %d)", result);
+		dev_err(&port->dev, "Disabling bulk RxRead failed (error = %d)\n", result);
 
 	/* shutdown any in-flight urbs that we know about */
 	usb_kill_urb(port->read_urb);
diff -puN drivers/usb/serial/mos7720.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/usb/serial/mos7720.c
--- a/drivers/usb/serial/mos7720.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/usb/serial/mos7720.c
@@ -478,7 +478,7 @@ static int mos7720_open(struct usb_seria
 		response = usb_submit_urb(port0->interrupt_in_urb, GFP_KERNEL);
 		if (response)
 			dev_err(&port->dev,
-				"%s - Error %d submitting control urb",
+				"%s - Error %d submitting control urb\n",
 				__FUNCTION__, response);
 	}
 
@@ -492,7 +492,7 @@ static int mos7720_open(struct usb_seria
 	response = usb_submit_urb(port->read_urb, GFP_KERNEL);
 	if (response)
 		dev_err(&port->dev,
-			"%s - Error %d submitting read urb", __FUNCTION__, response);
+			"%s - Error %d submitting read urb\n", __FUNCTION__, response);
 
 	/* initialize our icount structure */
 	memset(&(mos7720_port->icount), 0x00, sizeof(mos7720_port->icount));
diff -puN drivers/usb/serial/oti6858.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/usb/serial/oti6858.c
--- a/drivers/usb/serial/oti6858.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/usb/serial/oti6858.c
@@ -256,7 +256,7 @@ static void setup_line(struct work_struc
 				100);
 
 	if (result != OTI6858_CTRL_PKT_SIZE) {
-		dev_err(&port->dev, "%s(): error reading status", __FUNCTION__);
+		dev_err(&port->dev, "%s(): error reading status\n", __FUNCTION__);
 		kfree(new_setup);
 		/* we will try again */
 		schedule_delayed_work(&priv->delayed_setup_work, msecs_to_jiffies(2));
diff -puN drivers/usb/serial/sierra.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/usb/serial/sierra.c
--- a/drivers/usb/serial/sierra.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/usb/serial/sierra.c
@@ -48,7 +48,7 @@ enum devicetype {
 static int sierra_set_power_state(struct usb_device *udev, __u16 swiState)
 {
 	int result;
-	dev_dbg(&udev->dev, "%s", "SET POWER STATE");
+	dev_dbg(&udev->dev, "%s", "SET POWER STATE\n");
 	result = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 			0x00,			/* __u8 request      */
 			0x40,			/* __u8 request type */
@@ -63,7 +63,7 @@ static int sierra_set_power_state(struct
 static int sierra_set_ms_mode(struct usb_device *udev, __u16 eSocMode)
 {
 	int result;
-	dev_dbg(&udev->dev, "%s", "DEVICE MODE SWITCH");
+	dev_dbg(&udev->dev, "%s", "DEVICE MODE SWITCH\n");
 	result = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 			SWIMS_USB_REQUEST_SetMode,	/* __u8 request      */
 			SWIMS_USB_REQUEST_TYPE_SetMode,	/* __u8 request type */
@@ -397,7 +397,7 @@ static void sierra_indat_callback(struct
 			err = usb_submit_urb(urb, GFP_ATOMIC);
 			if (err)
 				dev_err(&port->dev, "resubmit read urb failed."
-					"(%d)", err);
+					"(%d)\n", err);
 		}
 	}
 	return;
@@ -525,7 +525,7 @@ static int sierra_open(struct usb_serial
 
 		result = usb_submit_urb(urb, GFP_KERNEL);
 		if (result) {
-			dev_err(&port->dev, "submit urb %d failed (%d) %d",
+			dev_err(&port->dev, "submit urb %d failed (%d) %d\n",
 				i, result, urb->transfer_buffer_length);
 		}
 	}
@@ -538,7 +538,7 @@ static int sierra_open(struct usb_serial
 	if (port->interrupt_in_urb) {
 		result = usb_submit_urb(port->interrupt_in_urb, GFP_KERNEL);
 		if (result)
-			dev_err(&port->dev, "submit irq_in urb failed %d",
+			dev_err(&port->dev, "submit irq_in urb failed %d\n",
 				result);
 	}
 	return 0;
diff -puN drivers/video/gxt4500.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/video/gxt4500.c
--- a/drivers/video/gxt4500.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/video/gxt4500.c
@@ -636,7 +636,7 @@ static int __devinit gxt4500_probe(struc
 
 	info = framebuffer_alloc(sizeof(struct gxt4500_par), &pdev->dev);
 	if (!info) {
-		dev_err(&pdev->dev, "gxt4500: cannot alloc FB info record");
+		dev_err(&pdev->dev, "gxt4500: cannot alloc FB info record\n");
 		goto err_free_fb;
 	}
 	par = info->par;
diff -puN drivers/video/omap/blizzard.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/video/omap/blizzard.c
--- a/drivers/video/omap/blizzard.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/video/omap/blizzard.c
@@ -225,7 +225,7 @@ static void blizzard_restart_sdram(void)
 	while (!(blizzard_read_reg(BLIZZARD_MEM_BANK0_STATUS) & 0x01)) {
 		if (time_after(jiffies, tmo)) {
 			dev_err(blizzard.fbdev->dev,
-					"s1d1374x: SDRAM not ready");
+					"s1d1374x: SDRAM not ready\n");
 			break;
 		}
 		msleep(1);
diff -puN drivers/video/omap/dispc.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/video/omap/dispc.c
--- a/drivers/video/omap/dispc.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/video/omap/dispc.c
@@ -880,19 +880,19 @@ static irqreturn_t omap_dispc_irq_handle
 static int get_dss_clocks(void)
 {
 	if (IS_ERR((dispc.dss_ick = clk_get(dispc.fbdev->dev, "dss_ick")))) {
-		dev_err(dispc.fbdev->dev, "can't get dss_ick");
+		dev_err(dispc.fbdev->dev, "can't get dss_ick\n");
 		return PTR_ERR(dispc.dss_ick);
 	}
 
 	if (IS_ERR((dispc.dss1_fck = clk_get(dispc.fbdev->dev, "dss1_fck")))) {
-		dev_err(dispc.fbdev->dev, "can't get dss1_fck");
+		dev_err(dispc.fbdev->dev, "can't get dss1_fck\n");
 		clk_put(dispc.dss_ick);
 		return PTR_ERR(dispc.dss1_fck);
 	}
 
 	if (IS_ERR((dispc.dss_54m_fck =
 				clk_get(dispc.fbdev->dev, "dss_54m_fck")))) {
-		dev_err(dispc.fbdev->dev, "can't get dss_54m_fck");
+		dev_err(dispc.fbdev->dev, "can't get dss_54m_fck\n");
 		clk_put(dispc.dss_ick);
 		clk_put(dispc.dss1_fck);
 		return PTR_ERR(dispc.dss_54m_fck);
diff -puN drivers/video/omap/hwa742.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/video/omap/hwa742.c
--- a/drivers/video/omap/hwa742.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/video/omap/hwa742.c
@@ -508,7 +508,7 @@ int hwa742_update_window_async(struct fb
 	if (unlikely(win->format &
 	    ~(0x03 | OMAPFB_FORMAT_FLAG_DOUBLE |
 	    OMAPFB_FORMAT_FLAG_TEARSYNC | OMAPFB_FORMAT_FLAG_FORCE_VSYNC))) {
-		dev_dbg(hwa742.fbdev->dev, "invalid window flag");
+		dev_dbg(hwa742.fbdev->dev, "invalid window flag\n");
 		r = -EINVAL;
 		goto out;
 	}
diff -puN drivers/video/omap/rfbi.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/video/omap/rfbi.c
--- a/drivers/video/omap/rfbi.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/video/omap/rfbi.c
@@ -84,12 +84,12 @@ static inline u32 rfbi_read_reg(int idx)
 static int rfbi_get_clocks(void)
 {
 	if (IS_ERR((rfbi.dss_ick = clk_get(rfbi.fbdev->dev, "dss_ick")))) {
-		dev_err(rfbi.fbdev->dev, "can't get dss_ick");
+		dev_err(rfbi.fbdev->dev, "can't get dss_ick\n");
 		return PTR_ERR(rfbi.dss_ick);
 	}
 
 	if (IS_ERR((rfbi.dss1_fck = clk_get(rfbi.fbdev->dev, "dss1_fck")))) {
-		dev_err(rfbi.fbdev->dev, "can't get dss1_fck");
+		dev_err(rfbi.fbdev->dev, "can't get dss1_fck\n");
 		clk_put(rfbi.dss_ick);
 		return PTR_ERR(rfbi.dss1_fck);
 	}
diff -puN drivers/video/s3c2410fb.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/video/s3c2410fb.c
--- a/drivers/video/s3c2410fb.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/video/s3c2410fb.c
@@ -800,7 +800,7 @@ static int __init s3c2410fb_probe(struct
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (res == NULL) {
-		dev_err(&pdev->dev, "failed to get memory registersn");
+		dev_err(&pdev->dev, "failed to get memory registers\n");
 		ret = -ENXIO;
 		goto dealloc_fb;
 	}
diff -puN drivers/w1/masters/ds1wm.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/w1/masters/ds1wm.c
--- a/drivers/w1/masters/ds1wm.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/w1/masters/ds1wm.c
@@ -307,7 +307,7 @@ static void ds1wm_search(void *data, u8 
 		rom_id |= (unsigned long long) r << (i * 4);
 
 	}
-	dev_dbg(&ds1wm_data->pdev->dev, "found 0x%08llX", rom_id);
+	dev_dbg(&ds1wm_data->pdev->dev, "found 0x%08llX\n", rom_id);
 
 	ds1wm_write_register(ds1wm_data, DS1WM_CMD, ~DS1WM_CMD_SRA);
 	ds1wm_reset(ds1wm_data);
diff -puN drivers/xen/xenbus/xenbus_probe.c~add-missing-newlines-to-some-uses-of-dev_level-messages drivers/xen/xenbus/xenbus_probe.c
--- a/drivers/xen/xenbus/xenbus_probe.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/drivers/xen/xenbus/xenbus_probe.c
@@ -185,13 +185,14 @@ static void otherend_changed(struct xenb
 	if (!dev->otherend ||
 	    strncmp(dev->otherend, vec[XS_WATCH_PATH],
 		    strlen(dev->otherend))) {
-		dev_dbg(&dev->dev, "Ignoring watch at %s", vec[XS_WATCH_PATH]);
+		dev_dbg(&dev->dev, "Ignoring watch at %s\n",
+			vec[XS_WATCH_PATH]);
 		return;
 	}
 
 	state = xenbus_read_driver_state(dev->otherend);
 
-	dev_dbg(&dev->dev, "state is %d, (%s), %s, %s",
+	dev_dbg(&dev->dev, "state is %d, (%s), %s, %s\n",
 		state, xenbus_strstate(state), dev->otherend_watch.node,
 		vec[XS_WATCH_PATH]);
 
diff -puN sound/arm/aaci.c~add-missing-newlines-to-some-uses-of-dev_level-messages sound/arm/aaci.c
--- a/sound/arm/aaci.c~add-missing-newlines-to-some-uses-of-dev_level-messages
+++ a/sound/arm/aaci.c
@@ -209,7 +209,7 @@ static void aaci_fifo_irq(struct aaci *a
 		void *ptr;
 
 		if (!aacirun->substream || !aacirun->start) {
-			dev_warn(&aaci->dev->dev, "RX interrupt???");
+			dev_warn(&aaci->dev->dev, "RX interrupt???\n");
 			writel(0, aacirun->base + AACI_IE);
 			return;
 		}
@@ -263,7 +263,7 @@ static void aaci_fifo_irq(struct aaci *a
 		void *ptr;
 
 		if (!aacirun->substream || !aacirun->start) {
-			dev_warn(&aaci->dev->dev, "TX interrupt???");
+			dev_warn(&aaci->dev->dev, "TX interrupt???\n");
 			writel(0, aacirun->base + AACI_IE);
 			return;
 		}
_

Patches currently in -mm which might be from joe@perches.com are

add-missing-newlines-to-some-uses-of-dev_level-messages.patch
