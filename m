From: akpm@linux-foundation.org
Subject: + drivers-char-synclink_gtc-add-extended-sync-feature.patch added to -mm tree
Date: Fri, 22 Oct 2010 13:14:59 -0700
Message-ID: <201010222014.o9MKEx6r005287@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34379 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756900Ab0JVUPd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Oct 2010 16:15:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulkf@microgate.com


The patch titled
     drivers/char/synclink_gt.c: add extended sync feature
has been added to the -mm tree.  Its filename is
     drivers-char-synclink_gtc-add-extended-sync-feature.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/char/synclink_gt.c: add extended sync feature
From: Paul Fulghum <paulkf@microgate.com>

Add support for extended byte synchronous mode feature of hardware.

Signed-off-by: Paul Fulghum <paulkf@microgate.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/synclink_gt.c |  111 ++++++++++++++++++++++++++++++++++-
 include/linux/synclink.h   |    5 +
 2 files changed, 113 insertions(+), 3 deletions(-)

diff -puN drivers/char/synclink_gt.c~drivers-char-synclink_gtc-add-extended-sync-feature drivers/char/synclink_gt.c
--- a/drivers/char/synclink_gt.c~drivers-char-synclink_gtc-add-extended-sync-feature
+++ a/drivers/char/synclink_gt.c
@@ -301,6 +301,8 @@ struct slgt_info {
 	unsigned int rx_pio;
 	unsigned int if_mode;
 	unsigned int base_clock;
+	unsigned int xsync;
+	unsigned int xctrl;
 
 	/* device status */
 
@@ -405,6 +407,8 @@ static MGSL_PARAMS default_params = {
 #define TDCSR 0x94 /* tx DMA control/status */
 #define RDDAR 0x98 /* rx DMA descriptor address */
 #define TDDAR 0x9c /* tx DMA descriptor address */
+#define XSR   0x40 /* extended sync pattern */
+#define XCR   0x44 /* extended control */
 
 #define RXIDLE      BIT14
 #define RXBREAK     BIT14
@@ -517,6 +521,10 @@ static int  set_interface(struct slgt_in
 static int  set_gpio(struct slgt_info *info, struct gpio_desc __user *gpio);
 static int  get_gpio(struct slgt_info *info, struct gpio_desc __user *gpio);
 static int  wait_gpio(struct slgt_info *info, struct gpio_desc __user *gpio);
+static int  get_xsync(struct slgt_info *info, int __user *if_mode);
+static int  set_xsync(struct slgt_info *info, int if_mode);
+static int  get_xctrl(struct slgt_info *info, int __user *if_mode);
+static int  set_xctrl(struct slgt_info *info, int if_mode);
 
 /*
  * driver functions
@@ -1056,6 +1064,14 @@ static int ioctl(struct tty_struct *tty,
 		return get_gpio(info, argp);
 	case MGSL_IOCWAITGPIO:
 		return wait_gpio(info, argp);
+	case MGSL_IOCGXSYNC:
+		return get_xsync(info, argp);
+	case MGSL_IOCSXSYNC:
+		return set_xsync(info, (int)arg);
+	case MGSL_IOCGXCTRL:
+		return get_xctrl(info, argp);
+	case MGSL_IOCSXCTRL:
+		return set_xctrl(info, (int)arg);
 	}
 	mutex_lock(&info->port.mutex);
 	switch (cmd) {
@@ -1213,12 +1229,16 @@ static long slgt_compat_ioctl(struct tty
 	case MGSL_IOCSGPIO:
 	case MGSL_IOCGGPIO:
 	case MGSL_IOCWAITGPIO:
+	case MGSL_IOCGXSYNC:
+	case MGSL_IOCGXCTRL:
 	case MGSL_IOCSTXIDLE:
 	case MGSL_IOCTXENABLE:
 	case MGSL_IOCRXENABLE:
 	case MGSL_IOCTXABORT:
 	case TIOCMIWAIT:
 	case MGSL_IOCSIF:
+	case MGSL_IOCSXSYNC:
+	case MGSL_IOCSXCTRL:
 		rc = ioctl(tty, file, cmd, arg);
 		break;
 	}
@@ -1961,6 +1981,7 @@ static void bh_handler(struct work_struc
 			case MGSL_MODE_RAW:
 			case MGSL_MODE_MONOSYNC:
 			case MGSL_MODE_BISYNC:
+			case MGSL_MODE_XSYNC:
 				while(rx_get_buf(info));
 				break;
 			}
@@ -2889,6 +2910,69 @@ static int set_interface(struct slgt_inf
 	return 0;
 }
 
+static int get_xsync(struct slgt_info *info, int __user *xsync)
+{
+	DBGINFO(("%s get_xsync=%x\n", info->device_name, info->xsync));
+	if (put_user(info->xsync, xsync))
+		return -EFAULT;
+	return 0;
+}
+
+/*
+ * set extended sync pattern (1 to 4 bytes) for extended sync mode
+ *
+ * sync pattern is contained in least significant bytes of value
+ * most significant byte of sync pattern is oldest (1st sent/detected)
+ */
+static int set_xsync(struct slgt_info *info, int xsync)
+{
+	unsigned long flags;
+
+	DBGINFO(("%s set_xsync=%x)\n", info->device_name, xsync));
+	spin_lock_irqsave(&info->lock, flags);
+	info->xsync = xsync;
+	wr_reg32(info, XSR, xsync);
+	spin_unlock_irqrestore(&info->lock, flags);
+	return 0;
+}
+
+static int get_xctrl(struct slgt_info *info, int __user *xctrl)
+{
+	DBGINFO(("%s get_xctrl=%x\n", info->device_name, info->xctrl));
+	if (put_user(info->xctrl, xctrl))
+		return -EFAULT;
+	return 0;
+}
+
+/*
+ * set extended control options
+ *
+ * xctrl[31:19] reserved, must be zero
+ * xctrl[18:17] extended sync pattern length in bytes
+ *              00 = 1 byte  in xsr[7:0]
+ *              01 = 2 bytes in xsr[15:0]
+ *              10 = 3 bytes in xsr[23:0]
+ *              11 = 4 bytes in xsr[31:0]
+ * xctrl[16]    1 = enable terminal count, 0=disabled
+ * xctrl[15:0]  receive terminal count for fixed length packets
+ *              value is count minus one (0 = 1 byte packet)
+ *              when terminal count is reached, receiver
+ *              automatically returns to hunt mode and receive
+ *              FIFO contents are flushed to DMA buffers with
+ *              end of frame (EOF) status
+ */
+static int set_xctrl(struct slgt_info *info, int xctrl)
+{
+	unsigned long flags;
+
+	DBGINFO(("%s set_xctrl=%x)\n", info->device_name, xctrl));
+	spin_lock_irqsave(&info->lock, flags);
+	info->xctrl = xctrl;
+	wr_reg32(info, XCR, xctrl);
+	spin_unlock_irqrestore(&info->lock, flags);
+	return 0;
+}
+
 /*
  * set general purpose IO pin state and direction
  *
@@ -3768,7 +3852,9 @@ module_exit(slgt_exit);
 #define CALC_REGADDR() \
 	unsigned long reg_addr = ((unsigned long)info->reg_addr) + addr; \
 	if (addr >= 0x80) \
-		reg_addr += (info->port_num) * 32;
+		reg_addr += (info->port_num) * 32; \
+	else if (addr >= 0x40)	\
+		reg_addr += (info->port_num) * 16;
 
 static __u8 rd_reg8(struct slgt_info *info, unsigned int addr)
 {
@@ -4187,7 +4273,13 @@ static void sync_mode(struct slgt_info *
 
 	/* TCR (tx control)
 	 *
-	 * 15..13  mode, 000=HDLC 001=raw 010=async 011=monosync 100=bisync
+	 * 15..13  mode
+	 *         000=HDLC/SDLC
+	 *         001=raw bit synchronous
+	 *         010=asynchronous/isochronous
+	 *         011=monosync byte synchronous
+	 *         100=bisync byte synchronous
+	 *         101=xsync byte synchronous
 	 * 12..10  encoding
 	 * 09      CRC enable
 	 * 08      CRC32
@@ -4202,6 +4294,9 @@ static void sync_mode(struct slgt_info *
 	val = BIT2;
 
 	switch(info->params.mode) {
+	case MGSL_MODE_XSYNC:
+		val |= BIT15 + BIT13;
+		break;
 	case MGSL_MODE_MONOSYNC: val |= BIT14 + BIT13; break;
 	case MGSL_MODE_BISYNC:   val |= BIT15; break;
 	case MGSL_MODE_RAW:      val |= BIT13; break;
@@ -4256,7 +4351,13 @@ static void sync_mode(struct slgt_info *
 
 	/* RCR (rx control)
 	 *
-	 * 15..13  mode, 000=HDLC 001=raw 010=async 011=monosync 100=bisync
+	 * 15..13  mode
+	 *         000=HDLC/SDLC
+	 *         001=raw bit synchronous
+	 *         010=asynchronous/isochronous
+	 *         011=monosync byte synchronous
+	 *         100=bisync byte synchronous
+	 *         101=xsync byte synchronous
 	 * 12..10  encoding
 	 * 09      CRC enable
 	 * 08      CRC32
@@ -4268,6 +4369,9 @@ static void sync_mode(struct slgt_info *
 	val = 0;
 
 	switch(info->params.mode) {
+	case MGSL_MODE_XSYNC:
+		val |= BIT15 + BIT13;
+		break;
 	case MGSL_MODE_MONOSYNC: val |= BIT14 + BIT13; break;
 	case MGSL_MODE_BISYNC:   val |= BIT15; break;
 	case MGSL_MODE_RAW:      val |= BIT13; break;
@@ -4684,6 +4788,7 @@ static bool rx_get_buf(struct slgt_info 
 	switch(info->params.mode) {
 	case MGSL_MODE_MONOSYNC:
 	case MGSL_MODE_BISYNC:
+	case MGSL_MODE_XSYNC:
 		/* ignore residue in byte synchronous modes */
 		if (desc_residue(info->rbufs[i]))
 			count--;
diff -puN include/linux/synclink.h~drivers-char-synclink_gtc-add-extended-sync-feature include/linux/synclink.h
--- a/include/linux/synclink.h~drivers-char-synclink_gtc-add-extended-sync-feature
+++ a/include/linux/synclink.h
@@ -126,6 +126,7 @@
 #define MGSL_MODE_BISYNC	4
 #define MGSL_MODE_RAW		6
 #define MGSL_MODE_BASE_CLOCK    7
+#define MGSL_MODE_XSYNC         8
 
 #define MGSL_BUS_TYPE_ISA	1
 #define MGSL_BUS_TYPE_EISA	2
@@ -290,6 +291,10 @@ struct gpio_desc {
 #define MGSL_IOCSGPIO		_IOW(MGSL_MAGIC_IOC,16,struct gpio_desc)
 #define MGSL_IOCGGPIO		_IOR(MGSL_MAGIC_IOC,17,struct gpio_desc)
 #define MGSL_IOCWAITGPIO	_IOWR(MGSL_MAGIC_IOC,18,struct gpio_desc)
+#define MGSL_IOCSXSYNC		_IO(MGSL_MAGIC_IOC, 19)
+#define MGSL_IOCGXSYNC		_IO(MGSL_MAGIC_IOC, 20)
+#define MGSL_IOCSXCTRL		_IO(MGSL_MAGIC_IOC, 21)
+#define MGSL_IOCGXCTRL		_IO(MGSL_MAGIC_IOC, 22)
 
 #ifdef __KERNEL__
 /* provide 32 bit ioctl compatibility on 64 bit systems */
_

Patches currently in -mm which might be from paulkf@microgate.com are

synclink_gt-fix-per-device-locking.patch
drivers-char-synclink_gtc-fix-information-leak-to-userland.patch
drivers-char-synclink_gtc-add-extended-sync-feature.patch

