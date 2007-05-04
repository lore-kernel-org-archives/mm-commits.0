From: akpm@linux-foundation.org
Subject: + synclink_gt-add-compat_ioctl.patch added to -mm tree
Date: Thu, 03 May 2007 17:53:13 -0700
Message-ID: <200705040053.l440rEc8026167@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52026 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767557AbXEDAxZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 20:53:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulkf@microgate.com, alan@lxorguk.ukuu.org.uk, arnd@arndb.de


The patch titled
     synclink_gt: add compat_ioctl
has been added to the -mm tree.  Its filename is
     synclink_gt-add-compat_ioctl.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: synclink_gt: add compat_ioctl
From: Paul Fulghum <paulkf@microgate.com>

Add compat_ioctl handler to synclink_gt driver.

The one case requiring a separate 32 bit handler could be removed by
redefining the associated structure in a way compatible with both 32 and 64
bit systems.  But that approach would break existing native 64 bit user
applications.

Signed-off-by: Paul Fulghum <paulkf@microgate.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/synclink_gt.c |  111 +++++++++++++++++++++++++++++++++++
 include/linux/synclink.h   |   22 ++++++
 2 files changed, 133 insertions(+)

diff -puN drivers/char/synclink_gt.c~synclink_gt-add-compat_ioctl drivers/char/synclink_gt.c
--- a/drivers/char/synclink_gt.c~synclink_gt-add-compat_ioctl
+++ a/drivers/char/synclink_gt.c
@@ -73,6 +73,7 @@
 #include <linux/bitops.h>
 #include <linux/workqueue.h>
 #include <linux/hdlc.h>
+#include <linux/compat.h>
 
 #include <asm/system.h>
 #include <asm/io.h>
@@ -530,6 +531,10 @@ static int  set_interface(struct slgt_in
 static int  set_gpio(struct slgt_info *info, struct gpio_desc __user *gpio);
 static int  get_gpio(struct slgt_info *info, struct gpio_desc __user *gpio);
 static int  wait_gpio(struct slgt_info *info, struct gpio_desc __user *gpio);
+#ifdef CONFIG_COMPAT
+static long set_params32(struct slgt_info *info, struct MGSL_PARAMS32 __user *new_params);
+static long get_params32(struct slgt_info *info, struct MGSL_PARAMS32 __user *new_params);
+#endif
 
 /*
  * driver functions
@@ -1170,6 +1175,55 @@ static int ioctl(struct tty_struct *tty,
 	return 0;
 }
 
+#ifdef CONFIG_COMPAT
+static long compat_ioctl(struct tty_struct *tty, struct file *file,
+			 unsigned int cmd, unsigned long arg)
+{
+	struct slgt_info *info = tty->driver_data;
+	int rc = -ENOIOCTLCMD;
+
+	if (sanity_check(info, tty->name, "compat_ioctl"))
+		return -ENODEV;
+	DBGINFO(("%s compat_ioctl() cmd=%08X\n", info->device_name, cmd));
+
+	switch (cmd) {
+
+	case MGSL_IOCSPARAMS32:
+		rc = set_params32(info, compat_ptr(arg));
+		break;
+
+	case MGSL_IOCGPARAMS32:
+		rc = get_params32(info, compat_ptr(arg));
+		break;
+
+	case MGSL_IOCGPARAMS:
+	case MGSL_IOCSPARAMS:
+	case MGSL_IOCGTXIDLE:
+	case MGSL_IOCGSTATS:
+	case MGSL_IOCWAITEVENT:
+	case MGSL_IOCGIF:
+	case MGSL_IOCSGPIO:
+	case MGSL_IOCGGPIO:
+	case MGSL_IOCWAITGPIO:
+	case TIOCGICOUNT:
+		rc = ioctl(tty, file, cmd, (unsigned long)(compat_ptr(arg)));
+		break;
+
+	case MGSL_IOCSTXIDLE:
+	case MGSL_IOCTXENABLE:
+	case MGSL_IOCRXENABLE:
+	case MGSL_IOCTXABORT:
+	case TIOCMIWAIT:
+	case MGSL_IOCSIF:
+		rc = ioctl(tty, file, cmd, arg);
+		break;
+	}
+
+	DBGINFO(("%s compat_ioctl() cmd=%08X rc=%d\n", info->device_name, cmd, rc));
+	return rc;
+}
+#endif
+
 /*
  * proc fs support
  */
@@ -2507,6 +2561,60 @@ static int set_params(struct slgt_info *
 	return 0;
 }
 
+#ifdef CONFIG_COMPAT
+static long get_params32(struct slgt_info *info, struct MGSL_PARAMS32 __user *user_params)
+{
+	struct MGSL_PARAMS32 tmp_params;
+
+	DBGINFO(("%s get_params32\n", info->device_name));
+	tmp_params.mode            = (compat_ulong_t)info->params.mode;
+	tmp_params.loopback        = info->params.loopback;
+	tmp_params.flags           = info->params.flags;
+	tmp_params.encoding        = info->params.encoding;
+	tmp_params.clock_speed     = (compat_ulong_t)info->params.clock_speed;
+	tmp_params.addr_filter     = info->params.addr_filter;
+	tmp_params.crc_type        = info->params.crc_type;
+	tmp_params.preamble_length = info->params.preamble_length;
+	tmp_params.preamble        = info->params.preamble;
+	tmp_params.data_rate       = (compat_ulong_t)info->params.data_rate;
+	tmp_params.data_bits       = info->params.data_bits;
+	tmp_params.stop_bits       = info->params.stop_bits;
+	tmp_params.parity          = info->params.parity;
+	if (copy_to_user(user_params, &tmp_params, sizeof(struct MGSL_PARAMS32)))
+		return -EFAULT;
+	return 0;
+}
+
+static long set_params32(struct slgt_info *info, struct MGSL_PARAMS32 __user *new_params)
+{
+	struct MGSL_PARAMS32 tmp_params;
+
+	DBGINFO(("%s set_params32\n", info->device_name));
+	if (copy_from_user(&tmp_params, new_params, sizeof(struct MGSL_PARAMS32)))
+		return -EFAULT;
+
+	spin_lock(&info->lock);
+	info->params.mode            = tmp_params.mode;
+	info->params.loopback        = tmp_params.loopback;
+	info->params.flags           = tmp_params.flags;
+	info->params.encoding        = tmp_params.encoding;
+	info->params.clock_speed     = tmp_params.clock_speed;
+	info->params.addr_filter     = tmp_params.addr_filter;
+	info->params.crc_type        = tmp_params.crc_type;
+	info->params.preamble_length = tmp_params.preamble_length;
+	info->params.preamble        = tmp_params.preamble;
+	info->params.data_rate       = tmp_params.data_rate;
+	info->params.data_bits       = tmp_params.data_bits;
+	info->params.stop_bits       = tmp_params.stop_bits;
+	info->params.parity          = tmp_params.parity;
+	spin_unlock(&info->lock);
+
+ 	change_params(info);
+
+	return 0;
+}
+#endif
+
 static int get_txidle(struct slgt_info *info, int __user *idle_mode)
 {
 	DBGINFO(("%s get_txidle=%d\n", info->device_name, info->idle_mode));
@@ -3446,6 +3554,9 @@ static const struct tty_operations ops =
 	.chars_in_buffer = chars_in_buffer,
 	.flush_buffer = flush_buffer,
 	.ioctl = ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = compat_ioctl,
+#endif
 	.throttle = throttle,
 	.unthrottle = unthrottle,
 	.send_xchar = send_xchar,
diff -puN include/linux/synclink.h~synclink_gt-add-compat_ioctl include/linux/synclink.h
--- a/include/linux/synclink.h~synclink_gt-add-compat_ioctl
+++ a/include/linux/synclink.h
@@ -9,6 +9,8 @@
  * the terms of the GNU Public License (GPL)
  */
 
+#include <linux/compat.h>
+
 #ifndef _SYNCLINK_H_
 #define _SYNCLINK_H_
 #define SYNCLINK_H_VERSION 3.6
@@ -167,6 +169,24 @@ typedef struct _MGSL_PARAMS
 
 } MGSL_PARAMS, *PMGSL_PARAMS;
 
+/* provide 32 bit ioctl compatibility on 64 bit systems */
+struct MGSL_PARAMS32
+{
+	compat_ulong_t	mode;
+	unsigned char	loopback;
+	unsigned short	flags;
+	unsigned char	encoding;
+	compat_ulong_t	clock_speed;
+	unsigned char	addr_filter;
+	unsigned short	crc_type;
+	unsigned char	preamble_length;
+	unsigned char	preamble;
+	compat_ulong_t	data_rate;
+	unsigned char	data_bits;
+	unsigned char	stop_bits;
+	unsigned char	parity;
+};
+
 #define MICROGATE_VENDOR_ID 0x13c0
 #define SYNCLINK_DEVICE_ID 0x0010
 #define MGSCC_DEVICE_ID 0x0020
@@ -276,6 +296,8 @@ struct gpio_desc {
 #define MGSL_MAGIC_IOC	'm'
 #define MGSL_IOCSPARAMS		_IOW(MGSL_MAGIC_IOC,0,struct _MGSL_PARAMS)
 #define MGSL_IOCGPARAMS		_IOR(MGSL_MAGIC_IOC,1,struct _MGSL_PARAMS)
+#define MGSL_IOCSPARAMS32	_IOW(MGSL_MAGIC_IOC,0,struct MGSL_PARAMS32)
+#define MGSL_IOCGPARAMS32	_IOR(MGSL_MAGIC_IOC,1,struct MGSL_PARAMS32)
 #define MGSL_IOCSTXIDLE		_IO(MGSL_MAGIC_IOC,2)
 #define MGSL_IOCGTXIDLE		_IO(MGSL_MAGIC_IOC,3)
 #define MGSL_IOCTXENABLE	_IO(MGSL_MAGIC_IOC,4)
_

Patches currently in -mm which might be from paulkf@microgate.com are

drivers-char-synclinkc-check-kmalloc-return-value.patch
synclink_gt-use-dynamic-tty-device-registration.patch
tty-add-compat_ioctl.patch
tty-add-compat_ioctl-fix.patch
synclink_gt-add-compat_ioctl.patch
synclink_gt-add-compat_ioctl-fix.patch
