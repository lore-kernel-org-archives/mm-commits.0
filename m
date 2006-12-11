From: akpm@osdl.org
Subject: + fix-drivers-media-video-usbvision-usbvision-i2cc-on-ia64.patch added to -mm tree
Date: Mon, 11 Dec 2006 00:59:56 -0800
Message-ID: <200612110859.kBB8xub8019566@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:60467 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762669AbWLKJAF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Dec 2006 04:00:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mchehab@infradead.org


The patch titled
     Fix: On ia64, i2c adap->inb/adap->outb are wrongly evaluated
has been added to the -mm tree.  Its filename is
     fix-drivers-media-video-usbvision-usbvision-i2cc-on-ia64.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix: On ia64, i2c adap->inb/adap->outb are wrongly evaluated
From: Mauro Carvalho Chehab <mchehab@infradead.org>


i2c defines two callbacks (inb/outb).  On ia64, since it defines also two
macros with those names, it causes the following errors:

drivers/media/video/usbvision/usbvision-i2c.c:64:39: macro "outb" passed 4 arguments, but takes just 2
drivers/media/video/usbvision/usbvision-i2c.c: In function `try_write_address':
drivers/media/video/usbvision/usbvision-i2c.c:64: warning: assignment makes integer from pointer without a cast
drivers/media/video/usbvision/usbvision-i2c.c:89:38: macro "inb" passed 4 arguments, but takes just 1
drivers/media/video/usbvision/usbvision-i2c.c: In function `try_read_address':
drivers/media/video/usbvision/usbvision-i2c.c:89: warning: assignment makes integer from pointer without a cast
drivers/media/video/usbvision/usbvision-i2c.c:85: warning: unused variable `buf'
drivers/media/video/usbvision/usbvision-i2c.c:173:53: macro "inb" passed 4 arguments, but takes just 1
drivers/media/video/usbvision/usbvision-i2c.c: In function `usb_xfer':
drivers/media/video/usbvision/usbvision-i2c.c:173: warning: assignment makes integer from pointer without a cast
drivers/media/video/usbvision/usbvision-i2c.c:179:54: macro "outb" passed 4 arguments, but takes just 2
drivers/media/video/usbvision/usbvision-i2c.c:179: warning: assignment makes integer from pointer without a cast
thanks to Andrew Morton for pointing this.

Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/media/video/usbvision/usbvision-i2c.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff -puN drivers/media/video/usbvision/usbvision-i2c.c~fix-drivers-media-video-usbvision-usbvision-i2cc-on-ia64 drivers/media/video/usbvision/usbvision-i2c.c
--- a/drivers/media/video/usbvision/usbvision-i2c.c~fix-drivers-media-video-usbvision-usbvision-i2cc-on-ia64
+++ a/drivers/media/video/usbvision/usbvision-i2c.c
@@ -50,6 +50,11 @@ MODULE_PARM_DESC(i2c_debug, "enable debu
 #define PDEBUG(level, fmt, args...) \
 		if (i2c_debug & (level)) info("[%s:%d] " fmt, __PRETTY_FUNCTION__, __LINE__ , ## args)
 
+static int usbvision_i2c_write(void *data, unsigned char addr, char *buf,
+			    short len);
+static int usbvision_i2c_read(void *data, unsigned char addr, char *buf,
+			   short len);
+
 static inline int try_write_address(struct i2c_adapter *i2c_adap,
 				    unsigned char addr, int retries)
 {
@@ -61,7 +66,7 @@ static inline int try_write_address(stru
 	data = i2c_get_adapdata(i2c_adap);
 	buf[0] = 0x00;
 	for (i = 0; i <= retries; i++) {
-		ret = (adap->outb(data, addr, buf, 1));
+		ret = (usbvision_i2c_write(data, addr, buf, 1));
 		if (ret == 1)
 			break;	/* success! */
 		udelay(5 /*adap->udelay */ );
@@ -86,7 +91,7 @@ static inline int try_read_address(struc
 
 	data = i2c_get_adapdata(i2c_adap);
 	for (i = 0; i <= retries; i++) {
-		ret = (adap->inb(data, addr, buf, 1));
+		ret = (usbvision_i2c_read(data, addr, buf, 1));
 		if (ret == 1)
 			break;	/* success! */
 		udelay(5 /*adap->udelay */ );
@@ -153,7 +158,6 @@ static int
 usb_xfer(struct i2c_adapter *i2c_adap, struct i2c_msg msgs[], int num)
 {
 	struct i2c_msg *pmsg;
-	struct i2c_algo_usb_data *adap = i2c_adap->algo_data;
 	void *data;
 	int i, ret;
 	unsigned char addr;
@@ -170,13 +174,13 @@ usb_xfer(struct i2c_adapter *i2c_adap, s
 
 		if (pmsg->flags & I2C_M_RD) {
 			/* read bytes into buffer */
-			ret = (adap->inb(data, addr, pmsg->buf, pmsg->len));
+			ret = (usbvision_i2c_read(data, addr, pmsg->buf, pmsg->len));
 			if (ret < pmsg->len) {
 				return (ret < 0) ? ret : -EREMOTEIO;
 			}
 		} else {
 			/* write bytes from buffer */
-			ret = (adap->outb(data, addr, pmsg->buf, pmsg->len));
+			ret = (usbvision_i2c_write(data, addr, pmsg->buf, pmsg->len));
 			if (ret < pmsg->len) {
 				return (ret < 0) ? ret : -EREMOTEIO;
 			}
_

Patches currently in -mm which might be from mchehab@infradead.org are

origin.patch
saa7134-add-support-for-the-encore-enl-tv.patch
drivers-media-video-cpia2-cpia2_usbc-free.patch
fix-namespace-conflict-between-w9968cfc-on-mips.patch
avoid-race-when-deregistering-the-ir-control-for-dvb-usb.patch
fix-drivers-media-video-usbvision-usbvision-i2cc-on-ia64.patch
getting-rid-of-all-casts-of-kalloc-calls.patch

