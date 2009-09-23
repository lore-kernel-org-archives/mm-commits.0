From: akpm@linux-foundation.org
Subject: + bfin-otp-add-writing-support.patch added to -mm tree
Date: Wed, 23 Sep 2009 13:39:31 -0700
Message-ID: <200909232039.n8NKdV4A026119@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44455 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751289AbZIWUkc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:40:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, cooloney@kernel.org


The patch titled
     bfin-otp: add writing support
has been added to the -mm tree.  Its filename is
     bfin-otp-add-writing-support.patch

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
Subject: bfin-otp: add writing support
From: Mike Frysinger <vapier@gentoo.org>

The on-chip OTP may be written at runtime, so enable support for it in the
driver.  However, since writing should really be done only on development
systems, don't bend over backwards to make sure the simple software lock
is per-fd -- per-device is OK.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/bfin-otp.c |  173 ++++++++++++++++++++++++++++----------
 1 file changed, 129 insertions(+), 44 deletions(-)

diff -puN drivers/char/bfin-otp.c~bfin-otp-add-writing-support drivers/char/bfin-otp.c
--- a/drivers/char/bfin-otp.c~bfin-otp-add-writing-support
+++ a/drivers/char/bfin-otp.c
@@ -1,8 +1,7 @@
 /*
  * Blackfin On-Chip OTP Memory Interface
- *  Supports BF52x/BF54x
  *
- * Copyright 2007-2008 Analog Devices Inc.
+ * Copyright 2007-2009 Analog Devices Inc.
  *
  * Enter bugs at http://blackfin.uclinux.org/
  *
@@ -17,8 +16,10 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/types.h>
+#include <mtd/mtd-abi.h>
 
 #include <asm/blackfin.h>
+#include <asm/bfrom.h>
 #include <asm/uaccess.h>
 
 #define stamp(fmt, args...) pr_debug("%s:%i: " fmt "\n", __func__, __LINE__, ## args)
@@ -30,39 +31,6 @@
 
 static DEFINE_MUTEX(bfin_otp_lock);
 
-/* OTP Boot ROM functions */
-#define _BOOTROM_OTP_COMMAND           0xEF000018
-#define _BOOTROM_OTP_READ              0xEF00001A
-#define _BOOTROM_OTP_WRITE             0xEF00001C
-
-static u32 (* const otp_command)(u32 command, u32 value) = (void *)_BOOTROM_OTP_COMMAND;
-static u32 (* const otp_read)(u32 page, u32 flags, u64 *page_content) = (void *)_BOOTROM_OTP_READ;
-static u32 (* const otp_write)(u32 page, u32 flags, u64 *page_content) = (void *)_BOOTROM_OTP_WRITE;
-
-/* otp_command(): defines for "command" */
-#define OTP_INIT             0x00000001
-#define OTP_CLOSE            0x00000002
-
-/* otp_{read,write}(): defines for "flags" */
-#define OTP_LOWER_HALF       0x00000000 /* select upper/lower 64-bit half (bit 0) */
-#define OTP_UPPER_HALF       0x00000001
-#define OTP_NO_ECC           0x00000010 /* do not use ECC */
-#define OTP_LOCK             0x00000020 /* sets page protection bit for page */
-#define OTP_ACCESS_READ      0x00001000
-#define OTP_ACCESS_READWRITE 0x00002000
-
-/* Return values for all functions */
-#define OTP_SUCCESS          0x00000000
-#define OTP_MASTER_ERROR     0x001
-#define OTP_WRITE_ERROR      0x003
-#define OTP_READ_ERROR       0x005
-#define OTP_ACC_VIO_ERROR    0x009
-#define OTP_DATA_MULT_ERROR  0x011
-#define OTP_ECC_MULT_ERROR   0x021
-#define OTP_PREV_WR_ERROR    0x041
-#define OTP_DATA_SB_WARN     0x100
-#define OTP_ECC_SB_WARN      0x200
-
 /**
  *	bfin_otp_read - Read OTP pages
  *
@@ -86,9 +54,11 @@ static ssize_t bfin_otp_read(struct file
 	page = *pos / (sizeof(u64) * 2);
 	while (bytes_done < count) {
 		flags = (*pos % (sizeof(u64) * 2) ? OTP_UPPER_HALF : OTP_LOWER_HALF);
-		stamp("processing page %i (%s)", page, (flags == OTP_UPPER_HALF ? "upper" : "lower"));
-		ret = otp_read(page, flags, &content);
+		stamp("processing page %i (0x%x:%s)", page, flags,
+			(flags & OTP_UPPER_HALF ? "upper" : "lower"));
+		ret = bfrom_OtpRead(page, flags, &content);
 		if (ret & OTP_MASTER_ERROR) {
+			stamp("error from otp: 0x%x", ret);
 			bytes_done = -EIO;
 			break;
 		}
@@ -96,7 +66,7 @@ static ssize_t bfin_otp_read(struct file
 			bytes_done = -EFAULT;
 			break;
 		}
-		if (flags == OTP_UPPER_HALF)
+		if (flags & OTP_UPPER_HALF)
 			++page;
 		bytes_done += sizeof(content);
 		*pos += sizeof(content);
@@ -108,14 +78,53 @@ static ssize_t bfin_otp_read(struct file
 }
 
 #ifdef CONFIG_BFIN_OTP_WRITE_ENABLE
+static bool allow_writes;
+
+/**
+ *	bfin_otp_init_timing - setup OTP timing parameters
+ *
+ *	Required before doing any write operation.  Algorithms from HRM.
+ */
+static u32 bfin_otp_init_timing(void)
+{
+	u32 tp1, tp2, tp3, timing;
+
+	tp1 = get_sclk() / 1000000;
+	tp2 = (2 * get_sclk() / 10000000) << 8;
+	tp3 = (0x1401) << 15;
+	timing = tp1 | tp2 | tp3;
+	if (bfrom_OtpCommand(OTP_INIT, timing))
+		return 0;
+
+	return timing;
+}
+
+/**
+ *	bfin_otp_deinit_timing - set timings to only allow reads
+ *
+ *	Should be called after all writes are done.
+ */
+static void bfin_otp_deinit_timing(u32 timing)
+{
+	/* mask bits [31:15] so that any attempts to write fail */
+	bfrom_OtpCommand(OTP_CLOSE, 0);
+	bfrom_OtpCommand(OTP_INIT, timing & ~(-1 << 15));
+	bfrom_OtpCommand(OTP_CLOSE, 0);
+}
+
 /**
- *	bfin_otp_write - Write OTP pages
+ *	bfin_otp_write - write OTP pages
  *
  *	All writes must be in half page chunks (half page == 64 bits).
  */
 static ssize_t bfin_otp_write(struct file *filp, const char __user *buff, size_t count, loff_t *pos)
 {
-	stampit();
+	ssize_t bytes_done;
+	u32 timing, page, base_flags, flags, ret;
+	u64 content;
+
+	if (!allow_writes)
+		return -EACCES;
 
 	if (count % sizeof(u64))
 		return -EMSGSIZE;
@@ -123,20 +132,96 @@ static ssize_t bfin_otp_write(struct fil
 	if (mutex_lock_interruptible(&bfin_otp_lock))
 		return -ERESTARTSYS;
 
-	/* need otp_init() documentation before this can be implemented */
+	stampit();
+
+	timing = bfin_otp_init_timing();
+	if (timing == 0) {
+		mutex_unlock(&bfin_otp_lock);
+		return -EIO;
+	}
+
+	base_flags = OTP_CHECK_FOR_PREV_WRITE;
+
+	bytes_done = 0;
+	page = *pos / (sizeof(u64) * 2);
+	while (bytes_done < count) {
+		flags = base_flags | (*pos % (sizeof(u64) * 2) ? OTP_UPPER_HALF : OTP_LOWER_HALF);
+		stamp("processing page %i (0x%x:%s) from %p", page, flags,
+			(flags & OTP_UPPER_HALF ? "upper" : "lower"), buff + bytes_done);
+		if (copy_from_user(&content, buff + bytes_done, sizeof(content))) {
+			bytes_done = -EFAULT;
+			break;
+		}
+		ret = bfrom_OtpWrite(page, flags, &content);
+		if (ret & OTP_MASTER_ERROR) {
+			stamp("error from otp: 0x%x", ret);
+			bytes_done = -EIO;
+			break;
+		}
+		if (flags & OTP_UPPER_HALF)
+			++page;
+		bytes_done += sizeof(content);
+		*pos += sizeof(content);
+	}
+
+	bfin_otp_deinit_timing(timing);
 
 	mutex_unlock(&bfin_otp_lock);
 
+	return bytes_done;
+}
+
+static long bfin_otp_ioctl(struct file *filp, unsigned cmd, unsigned long arg)
+{
+	stampit();
+
+	switch (cmd) {
+	case OTPLOCK: {
+		u32 timing;
+		int ret = -EIO;
+
+		if (!allow_writes)
+			return -EACCES;
+
+		if (mutex_lock_interruptible(&bfin_otp_lock))
+			return -ERESTARTSYS;
+
+		timing = bfin_otp_init_timing();
+		if (timing) {
+			u32 otp_result = bfrom_OtpWrite(arg, OTP_LOCK, NULL);
+			stamp("locking page %lu resulted in 0x%x", arg, otp_result);
+			if (!(otp_result & OTP_MASTER_ERROR))
+				ret = 0;
+
+			bfin_otp_deinit_timing(timing);
+		}
+
+		mutex_unlock(&bfin_otp_lock);
+
+		return ret;
+	}
+
+	case MEMLOCK:
+		allow_writes = false;
+		return 0;
+
+	case MEMUNLOCK:
+		allow_writes = true;
+		return 0;
+	}
+
 	return -EINVAL;
 }
 #else
 # define bfin_otp_write NULL
+# define bfin_otp_ioctl NULL
 #endif
 
 static struct file_operations bfin_otp_fops = {
-	.owner    = THIS_MODULE,
-	.read     = bfin_otp_read,
-	.write    = bfin_otp_write,
+	.owner          = THIS_MODULE,
+	.unlocked_ioctl = bfin_otp_ioctl,
+	.read           = bfin_otp_read,
+	.write          = bfin_otp_write,
 };
 
 static struct miscdevice bfin_otp_misc_device = {
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
linux-next.patch
md-dm-log-fix-cn_ulog_callback-declaration.patch
fdpic-ignore-the-loaders-pt_gnu_stack-when-calculating-the-stack-size.patch
flat-use-is_err_value-helper-macro.patch
bfin-otp-add-writing-support.patch
linux-futexh-place-kernel-types-behind-__kernel__.patch

