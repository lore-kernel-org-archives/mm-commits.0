From: akpm@linux-foundation.org
Subject: [merged] broadsheetfb-support-storing-waveform.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:56:55 -0400
Message-ID: <201003150657.o2F6vSnY016373@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36509 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756997Ab0COG5p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:57:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jayakumar.lkml@gmail.com, geert@linux-m68k.org, krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     broadsheetfb: support storing waveform
has been removed from the -mm tree.  Its filename was
     broadsheetfb-support-storing-waveform.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: broadsheetfb: support storing waveform
From: Jaya Kumar <jayakumar.lkml@gmail.com>

This patch adds waveform storing capability to broadsheetfb. It uses the
firmware class to retrieve the waveform, and the request to initiate the
waveform storing is done via a driver sysfs entry, loadstore_waveform.

Broadsheet is a framebuffer device.  It is slightly different from a
typical framebuffer controller that drives a normal TFT-LCD display.  Most
E-Ink display panels require a waveform in order to function.  That is, in
order to drive the state of a pixel to black, gray, or white, a specific
waveform is utilized.  Basically, that waveform represents the specific
E-field wiggling needed to get the pixel to its optimal state given
current temperature, and its previous state.  TN/IPS-LCDs use a similar
concept but the driving waveform is sufficiently simple that it is
internalized in the TFT source/gate driver.

These E-Ink waveforms are specific to a production batch.  That is, a
batch of display films are produced, then they get characterized and a
waveform is generated for that batch.  Broadsheet, typically, is attached
to its private SPI flash which is then flashed with this waveform.

Users won't be able to see the waveform and typically won't ever need to
know about it.  If however, the display panel attached to broadsheet is
changed out, then they will need to update their waveform.  That would
typically be done at a factory or repair facility rather than by a user.

[akpm@linux-foundation.org: fix printk warning]
Signed-off-by: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/broadsheetfb.c |  501 ++++++++++++++++++++++++++++++++-
 include/video/broadsheetfb.h |    5 
 2 files changed, 505 insertions(+), 1 deletion(-)

diff -puN drivers/video/broadsheetfb.c~broadsheetfb-support-storing-waveform drivers/video/broadsheetfb.c
--- a/drivers/video/broadsheetfb.c~broadsheetfb-support-storing-waveform
+++ a/drivers/video/broadsheetfb.c
@@ -29,6 +29,7 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/list.h>
+#include <linux/firmware.h>
 #include <linux/uaccess.h>
 
 #include <video/broadsheetfb.h>
@@ -306,6 +307,473 @@ static u16 broadsheet_read_reg(struct br
 	return broadsheet_get_data(par);
 }
 
+/* functions for waveform manipulation */
+static int is_broadsheet_pll_locked(struct broadsheetfb_par *par)
+{
+	return broadsheet_read_reg(par, 0x000A) & 0x0001;
+}
+
+static int broadsheet_setup_plls(struct broadsheetfb_par *par)
+{
+	int retry_count = 0;
+	u16 tmp;
+
+	/* disable arral saemipu mode */
+	broadsheet_write_reg(par, 0x0006, 0x0000);
+
+	broadsheet_write_reg(par, 0x0010, 0x0004);
+	broadsheet_write_reg(par, 0x0012, 0x5949);
+	broadsheet_write_reg(par, 0x0014, 0x0040);
+	broadsheet_write_reg(par, 0x0016, 0x0000);
+
+	do {
+		if (retry_count++ > 100)
+			return -ETIMEDOUT;
+		mdelay(1);
+	} while (!is_broadsheet_pll_locked(par));
+
+	tmp = broadsheet_read_reg(par, 0x0006);
+	tmp &= ~0x1;
+	broadsheet_write_reg(par, 0x0006, tmp);
+
+	return 0;
+}
+
+static int broadsheet_setup_spi(struct broadsheetfb_par *par)
+{
+
+	broadsheet_write_reg(par, 0x0204, ((3 << 3) | 1));
+	broadsheet_write_reg(par, 0x0208, 0x0001);
+
+	return 0;
+}
+
+static int broadsheet_setup_spiflash(struct broadsheetfb_par *par,
+						u16 *orig_sfmcd)
+{
+
+	*orig_sfmcd = broadsheet_read_reg(par, 0x0204);
+	broadsheet_write_reg(par, 0x0208, 0);
+	broadsheet_write_reg(par, 0x0204, 0);
+	broadsheet_write_reg(par, 0x0204, ((3 << 3) | 1));
+
+	return 0;
+}
+
+static int broadsheet_spiflash_wait_for_bit(struct broadsheetfb_par *par,
+						u16 reg, int bitnum, int val,
+						int timeout)
+{
+	u16 tmp;
+
+	do {
+		tmp = broadsheet_read_reg(par, reg);
+		if (((tmp >> bitnum) & 1) == val)
+			return 0;
+		mdelay(1);
+	} while (timeout--);
+
+	return -ETIMEDOUT;
+}
+
+static int broadsheet_spiflash_write_byte(struct broadsheetfb_par *par, u8 data)
+{
+	broadsheet_write_reg(par, 0x0202, (data | 0x100));
+
+	return broadsheet_spiflash_wait_for_bit(par, 0x0206, 3, 0, 100);
+}
+
+static int broadsheet_spiflash_read_byte(struct broadsheetfb_par *par, u8 *data)
+{
+	int err;
+	u16 tmp;
+
+	broadsheet_write_reg(par, 0x0202, 0);
+
+	err = broadsheet_spiflash_wait_for_bit(par, 0x0206, 3, 0, 100);
+	if (err)
+		return err;
+
+	tmp = broadsheet_read_reg(par, 0x200);
+
+	*data = tmp & 0xFF;
+
+	return 0;
+}
+
+static int broadsheet_spiflash_wait_for_status(struct broadsheetfb_par *par,
+								int timeout)
+{
+	u8 tmp;
+	int err;
+
+	do {
+		broadsheet_write_reg(par, 0x0208, 1);
+
+		err = broadsheet_spiflash_write_byte(par, 0x05);
+		if (err)
+			goto failout;
+
+		err = broadsheet_spiflash_read_byte(par, &tmp);
+		if (err)
+			goto failout;
+
+		broadsheet_write_reg(par, 0x0208, 0);
+
+		if (!(tmp & 0x1))
+			return 0;
+
+		mdelay(5);
+	} while (timeout--);
+
+	dev_err(par->info->device, "Timed out waiting for spiflash status\n");
+	return -ETIMEDOUT;
+
+failout:
+	broadsheet_write_reg(par, 0x0208, 0);
+	return err;
+}
+
+static int broadsheet_spiflash_op_on_address(struct broadsheetfb_par *par,
+							u8 op, u32 addr)
+{
+	int i;
+	u8 tmp;
+	int err;
+
+	broadsheet_write_reg(par, 0x0208, 1);
+
+	err = broadsheet_spiflash_write_byte(par, op);
+	if (err)
+		return err;
+
+	for (i = 2; i >= 0; i--) {
+		tmp = ((addr >> (i * 8)) & 0xFF);
+		err = broadsheet_spiflash_write_byte(par, tmp);
+		if (err)
+			return err;
+	}
+
+	return err;
+}
+
+static int broadsheet_verify_spiflash(struct broadsheetfb_par *par,
+						int *flash_type)
+{
+	int err = 0;
+	u8 sig;
+
+	err = broadsheet_spiflash_op_on_address(par, 0xAB, 0x00000000);
+	if (err)
+		goto failout;
+
+	err = broadsheet_spiflash_read_byte(par, &sig);
+	if (err)
+		goto failout;
+
+	if ((sig != 0x10) && (sig != 0x11)) {
+		dev_err(par->info->device, "Unexpected flash type\n");
+		err = -EINVAL;
+		goto failout;
+	}
+
+	*flash_type = sig;
+
+failout:
+	broadsheet_write_reg(par, 0x0208, 0);
+	return err;
+}
+
+static int broadsheet_setup_for_wfm_write(struct broadsheetfb_par *par,
+					u16 *initial_sfmcd, int *flash_type)
+
+{
+	int err;
+
+	err = broadsheet_setup_plls(par);
+	if (err)
+		return err;
+
+	broadsheet_write_reg(par, 0x0106, 0x0203);
+
+	err = broadsheet_setup_spi(par);
+	if (err)
+		return err;
+
+	err = broadsheet_setup_spiflash(par, initial_sfmcd);
+	if (err)
+		return err;
+
+	return broadsheet_verify_spiflash(par, flash_type);
+}
+
+static int broadsheet_spiflash_write_control(struct broadsheetfb_par *par,
+						int mode)
+{
+	int err;
+
+	broadsheet_write_reg(par, 0x0208, 1);
+	if (mode)
+		err = broadsheet_spiflash_write_byte(par, 0x06);
+	else
+		err = broadsheet_spiflash_write_byte(par, 0x04);
+
+	broadsheet_write_reg(par, 0x0208, 0);
+	return err;
+}
+
+static int broadsheet_spiflash_erase_sector(struct broadsheetfb_par *par,
+						int addr)
+{
+	int err;
+
+	broadsheet_spiflash_write_control(par, 1);
+
+	err = broadsheet_spiflash_op_on_address(par, 0xD8, addr);
+
+	broadsheet_write_reg(par, 0x0208, 0);
+
+	if (err)
+		return err;
+
+	err = broadsheet_spiflash_wait_for_status(par, 1000);
+
+	return err;
+}
+
+static int broadsheet_spiflash_read_range(struct broadsheetfb_par *par,
+						int addr, int size, char *data)
+{
+	int err;
+	int i;
+
+	err = broadsheet_spiflash_op_on_address(par, 0x03, addr);
+	if (err)
+		goto failout;
+
+	for (i = 0; i < size; i++) {
+		err = broadsheet_spiflash_read_byte(par, &data[i]);
+		if (err)
+			goto failout;
+	}
+
+failout:
+	broadsheet_write_reg(par, 0x0208, 0);
+	return err;
+}
+
+#define BS_SPIFLASH_PAGE_SIZE 256
+static int broadsheet_spiflash_write_page(struct broadsheetfb_par *par,
+						int addr, const char *data)
+{
+	int err;
+	int i;
+
+	broadsheet_spiflash_write_control(par, 1);
+
+	err = broadsheet_spiflash_op_on_address(par, 0x02, addr);
+	if (err)
+		goto failout;
+
+	for (i = 0; i < BS_SPIFLASH_PAGE_SIZE; i++) {
+		err = broadsheet_spiflash_write_byte(par, data[i]);
+		if (err)
+			goto failout;
+	}
+
+	broadsheet_write_reg(par, 0x0208, 0);
+
+	err = broadsheet_spiflash_wait_for_status(par, 100);
+
+failout:
+	return err;
+}
+
+static int broadsheet_spiflash_write_sector(struct broadsheetfb_par *par,
+				int addr, const char *data, int sector_size)
+{
+	int i;
+	int err;
+
+	for (i = 0; i < sector_size; i += BS_SPIFLASH_PAGE_SIZE) {
+		err = broadsheet_spiflash_write_page(par, addr + i, &data[i]);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
+/*
+ * The caller must guarantee that the data to be rewritten is entirely
+ * contained within this sector. That is, data_start_addr + data_len
+ * must be less than sector_start_addr + sector_size.
+ */
+static int broadsheet_spiflash_rewrite_sector(struct broadsheetfb_par *par,
+					int sector_size, int data_start_addr,
+					int data_len, const char *data)
+{
+	int err;
+	char *sector_buffer;
+	int tail_start_addr;
+	int start_sector_addr;
+
+	sector_buffer = kzalloc(sizeof(char)*sector_size, GFP_KERNEL);
+	if (!sector_buffer)
+		return -ENOMEM;
+
+	/* the start address of the sector is the 0th byte of that sector */
+	start_sector_addr = (data_start_addr / sector_size) * sector_size;
+
+	/*
+	 * check if there is head data that we need to readback into our sector
+	 * buffer first
+	 */
+	if (data_start_addr != start_sector_addr) {
+		/*
+		 * we need to read every byte up till the start address of our
+		 * data and we put it into our sector buffer.
+		 */
+		err = broadsheet_spiflash_read_range(par, start_sector_addr,
+						data_start_addr, sector_buffer);
+		if (err)
+			return err;
+	}
+
+	/* now we copy our data into the right place in the sector buffer */
+	memcpy(sector_buffer + data_start_addr, data, data_len);
+
+	/*
+	 * now we check if there is a tail section of the sector that we need to
+	 * readback.
+	 */
+	tail_start_addr = (data_start_addr + data_len) % sector_size;
+
+	if (tail_start_addr) {
+		int tail_len;
+
+		tail_len = sector_size - tail_start_addr;
+
+		/* now we read this tail into our sector buffer */
+		err = broadsheet_spiflash_read_range(par, tail_start_addr,
+			tail_len, sector_buffer + tail_start_addr);
+		if (err)
+			return err;
+	}
+
+	/* if we got here we have the full sector that we want to rewrite. */
+
+	/* first erase the sector */
+	err = broadsheet_spiflash_erase_sector(par, start_sector_addr);
+	if (err)
+		return err;
+
+	/* now write it */
+	err = broadsheet_spiflash_write_sector(par, start_sector_addr,
+					sector_buffer, sector_size);
+	return err;
+}
+
+static int broadsheet_write_spiflash(struct broadsheetfb_par *par, u32 wfm_addr,
+				const u8 *wfm, int bytecount, int flash_type)
+{
+	int sector_size;
+	int err;
+	int cur_addr;
+	int writecount;
+	int maxlen;
+	int offset = 0;
+
+	switch (flash_type) {
+	case 0x10:
+		sector_size = 32*1024;
+		break;
+	case 0x11:
+	default:
+		sector_size = 64*1024;
+		break;
+	}
+
+	while (bytecount) {
+		cur_addr = wfm_addr + offset;
+		maxlen = roundup(cur_addr, sector_size) - cur_addr;
+		writecount = min(bytecount, maxlen);
+
+		err = broadsheet_spiflash_rewrite_sector(par, sector_size,
+				cur_addr, writecount, wfm + offset);
+		if (err)
+			return err;
+
+		offset += writecount;
+		bytecount -= writecount;
+	}
+
+	return 0;
+}
+
+static int broadsheet_store_waveform_to_spiflash(struct broadsheetfb_par *par,
+						const u8 *wfm, size_t wfm_size)
+{
+	int err = 0;
+	u16 initial_sfmcd = 0;
+	int flash_type = 0;
+
+	err = broadsheet_setup_for_wfm_write(par, &initial_sfmcd, &flash_type);
+	if (err)
+		goto failout;
+
+	err = broadsheet_write_spiflash(par, 0x886, wfm, wfm_size, flash_type);
+
+failout:
+	broadsheet_write_reg(par, 0x0204, initial_sfmcd);
+	return err;
+}
+
+static ssize_t broadsheet_loadstore_waveform(struct device *dev,
+						struct device_attribute *attr,
+						const char *buf, size_t len)
+{
+	int err;
+	struct fb_info *info = dev_get_drvdata(dev);
+	struct broadsheetfb_par *par = info->par;
+	const struct firmware *fw_entry;
+
+	if (len < 1)
+		return -EINVAL;
+
+	err = request_firmware(&fw_entry, "broadsheet.wbf", dev);
+	if (err < 0) {
+		dev_err(dev, "Failed to get broadsheet waveform\n");
+		goto err_failed;
+	}
+
+	/* try to enforce reasonable min max on waveform */
+	if ((fw_entry->size < 8*1024) || (fw_entry->size > 64*1024)) {
+		dev_err(dev, "Invalid waveform\n");
+		err = -EINVAL;
+		goto err_failed;
+	}
+
+	mutex_lock(&(par->io_lock));
+	err = broadsheet_store_waveform_to_spiflash(par, fw_entry->data,
+							fw_entry->size);
+
+	mutex_unlock(&(par->io_lock));
+	if (err < 0) {
+		dev_err(dev, "Failed to store broadsheet waveform\n");
+		goto err_failed;
+	}
+
+	dev_info(dev, "Stored broadsheet waveform, size %zd\n", fw_entry->size);
+
+	return len;
+
+err_failed:
+	return err;
+}
+static DEVICE_ATTR(loadstore_waveform, S_IWUSR, NULL,
+			broadsheet_loadstore_waveform);
+
+/* upper level functions that manipulate the display and other stuff */
 static void __devinit broadsheet_init_display(struct broadsheetfb_par *par)
 {
 	u16 args[5];
@@ -366,6 +834,21 @@ static void __devinit broadsheet_init_di
 	par->board->wait_for_rdy(par);
 }
 
+static void __devinit broadsheet_identify(struct broadsheetfb_par *par)
+{
+	u16 rev, prc;
+	struct device *dev = par->info->device;
+
+	rev = broadsheet_read_reg(par, BS_REG_REV);
+	prc = broadsheet_read_reg(par, BS_REG_PRC);
+	dev_info(dev, "Broadsheet Rev 0x%x, Product Code 0x%x\n", rev, prc);
+
+	if (prc != 0x0047)
+		dev_warn(dev, "Unrecognized Broadsheet Product Code\n");
+	if (rev != 0x0100)
+		dev_warn(dev, "Unrecognized Broadsheet Revision\n");
+}
+
 static void __devinit broadsheet_init(struct broadsheetfb_par *par)
 {
 	broadsheet_send_command(par, BS_CMD_INIT_SYS_RUN);
@@ -380,6 +863,7 @@ static void broadsheetfb_dpy_update_page
 	u16 args[5];
 	unsigned char *buf = (unsigned char *)par->info->screen_base;
 
+	mutex_lock(&(par->io_lock));
 	/* y1 must be a multiple of 4 so drop the lower bits */
 	y1 &= 0xFFFC;
 	/* y2 must be a multiple of 4 , but - 1 so up the lower bits */
@@ -409,6 +893,7 @@ static void broadsheetfb_dpy_update_page
 	broadsheet_send_command(par, BS_CMD_WAIT_DSPE_FREND);
 
 	par->board->wait_for_rdy(par);
+	mutex_unlock(&(par->io_lock));
 
 }
 
@@ -416,6 +901,7 @@ static void broadsheetfb_dpy_update(stru
 {
 	u16 args[5];
 
+	mutex_lock(&(par->io_lock));
 	args[0] = 0x3 << 4;
 	broadsheet_send_cmdargs(par, BS_CMD_LD_IMG, 1, args);
 
@@ -435,7 +921,7 @@ static void broadsheetfb_dpy_update(stru
 	broadsheet_send_command(par, BS_CMD_WAIT_DSPE_FREND);
 
 	par->board->wait_for_rdy(par);
-
+	mutex_unlock(&(par->io_lock));
 }
 
 /* this is called back from the deferred io workqueue */
@@ -641,6 +1127,8 @@ static int __devinit broadsheetfb_probe(
 	par->read_reg = broadsheet_read_reg;
 	init_waitqueue_head(&par->waitq);
 
+	mutex_init(&par->io_lock);
+
 	info->flags = FBINFO_FLAG_DEFAULT | FBINFO_VIRTFB;
 
 	info->fbdefio = &broadsheetfb_defio;
@@ -667,13 +1155,20 @@ static int __devinit broadsheetfb_probe(
 	if (retval < 0)
 		goto err_free_irq;
 
+	broadsheet_identify(par);
+
 	broadsheet_init(par);
 
 	retval = register_framebuffer(info);
 	if (retval < 0)
 		goto err_free_irq;
+
 	platform_set_drvdata(dev, info);
 
+	retval = device_create_file(&dev->dev, &dev_attr_loadstore_waveform);
+	if (retval < 0)
+		goto err_unreg_fb;
+
 	printk(KERN_INFO
 	       "fb%d: Broadsheet frame buffer, using %dK of video memory\n",
 	       info->node, videomemorysize >> 10);
@@ -681,6 +1176,8 @@ static int __devinit broadsheetfb_probe(
 
 	return 0;
 
+err_unreg_fb:
+	unregister_framebuffer(info);
 err_free_irq:
 	board->cleanup(par);
 err_cmap:
@@ -701,6 +1198,8 @@ static int __devexit broadsheetfb_remove
 
 	if (info) {
 		struct broadsheetfb_par *par = info->par;
+
+		device_remove_file(info->dev, &dev_attr_loadstore_waveform);
 		unregister_framebuffer(info);
 		fb_deferred_io_cleanup(info);
 		par->board->cleanup(par);
diff -puN include/video/broadsheetfb.h~broadsheetfb-support-storing-waveform include/video/broadsheetfb.h
--- a/include/video/broadsheetfb.h~broadsheetfb-support-storing-waveform
+++ a/include/video/broadsheetfb.h
@@ -29,6 +29,10 @@
 #define BS_CMD_UPD_FULL		0x33
 #define BS_CMD_UPD_GDRV_CLR	0x37
 
+/* Broadsheet register interface defines */
+#define BS_REG_REV		0x00
+#define BS_REG_PRC		0x02
+
 /* Broadsheet pin interface specific defines */
 #define BS_CS	0x01
 #define BS_DC 	0x02
@@ -46,6 +50,7 @@ struct broadsheetfb_par {
 	u16 (*read_reg)(struct broadsheetfb_par *, u16 reg);
 	wait_queue_head_t waitq;
 	int panel_index;
+	struct mutex io_lock;
 };
 
 /* board specific routines */
_

Patches currently in -mm which might be from jayakumar.lkml@gmail.com are

origin.patch

