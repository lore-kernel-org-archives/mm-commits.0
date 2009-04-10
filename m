From: akpm@linux-foundation.org
Subject: + mtd-compat_ioctl-cleanup.patch added to -mm tree
Date: Fri, 10 Apr 2009 15:06:29 -0700
Message-ID: <200904102206.n3AM6Tkf014484@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46873 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752051AbZDJWIf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 18:08:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kpc.mtd@gmail.com, dwmw2@infradead.org


The patch titled
     mtd: compat_ioctl cleanup
has been added to the -mm tree.  Its filename is
     mtd-compat_ioctl-cleanup.patch

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
Subject: mtd: compat_ioctl cleanup
From: Kevin Cernekee <kpc.mtd@gmail.com>

1) Move the MEMREADOOB/MEMWRITEOOB compat_ioctl wrappers from
fs/compat_ioctl.c into mtdchar.c .  Original request was here:

http://lkml.org/lkml/2009/4/1/295

2) Add missing COMPATIBLE_IOCTL lines, so that mtd-utils does not error
out when running in 64/32 compatibility mode.

Signed-off-by: Kevin Cernekee <kpc.mtd@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/mtdchar.c |  255 ++++++++++++++++++++++++++--------------
 fs/compat_ioctl.c     |   51 +-------
 2 files changed, 180 insertions(+), 126 deletions(-)

diff -puN drivers/mtd/mtdchar.c~mtd-compat_ioctl-cleanup drivers/mtd/mtdchar.c
--- a/drivers/mtd/mtdchar.c~mtd-compat_ioctl-cleanup
+++ a/drivers/mtd/mtdchar.c
@@ -14,6 +14,7 @@
 #include <linux/sched.h>
 #include <linux/smp_lock.h>
 #include <linux/backing-dev.h>
+#include <linux/compat.h>
 
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/compatmac.h>
@@ -355,6 +356,100 @@ static int otp_select_filemode(struct mt
 # define otp_select_filemode(f,m)	-EOPNOTSUPP
 #endif
 
+static int mtd_do_writeoob(struct file *file, struct mtd_info *mtd,
+	uint64_t start, uint32_t length, void __user *ptr,
+	uint32_t __user *retp)
+{
+	struct mtd_oob_ops ops;
+	uint32_t retlen;
+	int ret = 0;
+
+	if (!(file->f_mode & FMODE_WRITE))
+		return -EPERM;
+
+	if (length > 4096)
+		return -EINVAL;
+
+	if (!mtd->write_oob)
+		ret = -EOPNOTSUPP;
+	else
+		ret = access_ok(VERIFY_READ, ptr, length) ? 0 : EFAULT;
+
+	if (ret)
+		return ret;
+
+	ops.ooblen = length;
+	ops.ooboffs = start & (mtd->oobsize - 1);
+	ops.datbuf = NULL;
+	ops.mode = MTD_OOB_PLACE;
+
+	if (ops.ooboffs && ops.ooblen > (mtd->oobsize - ops.ooboffs))
+		return -EINVAL;
+
+	ops.oobbuf = kmalloc(length, GFP_KERNEL);
+	if (!ops.oobbuf)
+		return -ENOMEM;
+
+	if (copy_from_user(ops.oobbuf, ptr, length)) {
+		kfree(ops.oobbuf);
+		return -EFAULT;
+	}
+
+	start &= ~((uint64_t)mtd->oobsize - 1);
+	ret = mtd->write_oob(mtd, start, &ops);
+
+	if (ops.oobretlen > 0xFFFFFFFFU)
+		ret = -EOVERFLOW;
+	retlen = ops.oobretlen;
+	if (copy_to_user(retp, &retlen, sizeof(length)))
+		ret = -EFAULT;
+
+	kfree(ops.oobbuf);
+	return ret;
+}
+
+static int mtd_do_readoob(struct mtd_info *mtd, uint64_t start,
+	uint32_t length, void __user *ptr, uint32_t __user *retp)
+{
+	struct mtd_oob_ops ops;
+	int ret = 0;
+
+	if (length > 4096)
+		return -EINVAL;
+
+	if (!mtd->read_oob)
+		ret = -EOPNOTSUPP;
+	else
+		ret = access_ok(VERIFY_WRITE, ptr,
+				length) ? 0 : -EFAULT;
+	if (ret)
+		return ret;
+
+	ops.ooblen = length;
+	ops.ooboffs = start & (mtd->oobsize - 1);
+	ops.datbuf = NULL;
+	ops.mode = MTD_OOB_PLACE;
+
+	if (ops.ooboffs && ops.ooblen > (mtd->oobsize - ops.ooboffs))
+		return -EINVAL;
+
+	ops.oobbuf = kmalloc(length, GFP_KERNEL);
+	if (!ops.oobbuf)
+		return -ENOMEM;
+
+	start &= ~((uint64_t)mtd->oobsize - 1);
+	ret = mtd->read_oob(mtd, start, &ops);
+
+	if (put_user(ops.oobretlen, retp))
+		ret = -EFAULT;
+	else if (ops.oobretlen && copy_to_user(ptr, ops.oobbuf,
+					    ops.oobretlen))
+		ret = -EFAULT;
+
+	kfree(ops.oobbuf);
+	return ret;
+}
+
 static int mtd_ioctl(struct inode *inode, struct file *file,
 		     u_int cmd, u_long arg)
 {
@@ -487,100 +582,28 @@ static int mtd_ioctl(struct inode *inode
 	case MEMWRITEOOB:
 	{
 		struct mtd_oob_buf buf;
-		struct mtd_oob_ops ops;
-		struct mtd_oob_buf __user *user_buf = argp;
-	        uint32_t retlen;
-
-		if(!(file->f_mode & FMODE_WRITE))
-			return -EPERM;
-
-		if (copy_from_user(&buf, argp, sizeof(struct mtd_oob_buf)))
-			return -EFAULT;
-
-		if (buf.length > 4096)
-			return -EINVAL;
-
-		if (!mtd->write_oob)
-			ret = -EOPNOTSUPP;
-		else
-			ret = access_ok(VERIFY_READ, buf.ptr,
-					buf.length) ? 0 : EFAULT;
-
-		if (ret)
-			return ret;
-
-		ops.ooblen = buf.length;
-		ops.ooboffs = buf.start & (mtd->oobsize - 1);
-		ops.datbuf = NULL;
-		ops.mode = MTD_OOB_PLACE;
-
-		if (ops.ooboffs && ops.ooblen > (mtd->oobsize - ops.ooboffs))
-			return -EINVAL;
-
-		ops.oobbuf = kmalloc(buf.length, GFP_KERNEL);
-		if (!ops.oobbuf)
-			return -ENOMEM;
-
-		if (copy_from_user(ops.oobbuf, buf.ptr, buf.length)) {
-			kfree(ops.oobbuf);
-			return -EFAULT;
-		}
+		struct mtd_oob_buf __user *buf_user = argp;
 
-		buf.start &= ~(mtd->oobsize - 1);
-		ret = mtd->write_oob(mtd, buf.start, &ops);
-
-		if (ops.oobretlen > 0xFFFFFFFFU)
-			ret = -EOVERFLOW;
-		retlen = ops.oobretlen;
-		if (copy_to_user(&user_buf->length, &retlen, sizeof(buf.length)))
+		/* NOTE: writes return length to buf_user->length */
+		if (copy_from_user(&buf, argp, sizeof(buf)))
 			ret = -EFAULT;
-
-		kfree(ops.oobbuf);
+		else
+			ret = mtd_do_writeoob(file, mtd, buf.start, buf.length,
+				buf.ptr, &buf_user->length);
 		break;
-
 	}
 
 	case MEMREADOOB:
 	{
 		struct mtd_oob_buf buf;
-		struct mtd_oob_ops ops;
-
-		if (copy_from_user(&buf, argp, sizeof(struct mtd_oob_buf)))
-			return -EFAULT;
-
-		if (buf.length > 4096)
-			return -EINVAL;
-
-		if (!mtd->read_oob)
-			ret = -EOPNOTSUPP;
-		else
-			ret = access_ok(VERIFY_WRITE, buf.ptr,
-					buf.length) ? 0 : -EFAULT;
-		if (ret)
-			return ret;
-
-		ops.ooblen = buf.length;
-		ops.ooboffs = buf.start & (mtd->oobsize - 1);
-		ops.datbuf = NULL;
-		ops.mode = MTD_OOB_PLACE;
-
-		if (ops.ooboffs && ops.ooblen > (mtd->oobsize - ops.ooboffs))
-			return -EINVAL;
-
-		ops.oobbuf = kmalloc(buf.length, GFP_KERNEL);
-		if (!ops.oobbuf)
-			return -ENOMEM;
-
-		buf.start &= ~(mtd->oobsize - 1);
-		ret = mtd->read_oob(mtd, buf.start, &ops);
+		struct mtd_oob_buf __user *buf_user = argp;
 
-		if (put_user(ops.oobretlen, (uint32_t __user *)argp))
+		/* NOTE: writes return length to buf_user->start */
+		if (copy_from_user(&buf, argp, sizeof(buf)))
 			ret = -EFAULT;
-		else if (ops.oobretlen && copy_to_user(buf.ptr, ops.oobbuf,
-						    ops.oobretlen))
-			ret = -EFAULT;
-
-		kfree(ops.oobbuf);
+		else
+			ret = mtd_do_readoob(mtd, buf.start, buf.length,
+				buf.ptr, &buf_user->start);
 		break;
 	}
 
@@ -771,6 +794,67 @@ static int mtd_ioctl(struct inode *inode
 	return ret;
 } /* memory_ioctl */
 
+#ifdef CONFIG_COMPAT
+
+struct mtd_oob_buf32 {
+	u_int32_t start;
+	u_int32_t length;
+	compat_caddr_t ptr;	/* unsigned char* */
+};
+
+#define MEMWRITEOOB32		_IOWR('M', 3, struct mtd_oob_buf32)
+#define MEMREADOOB32		_IOWR('M', 4, struct mtd_oob_buf32)
+
+static long mtd_compat_ioctl(struct file *file, unsigned int cmd,
+	unsigned long arg)
+{
+	struct mtd_file_info *mfi = file->private_data;
+	struct mtd_info *mtd = mfi->mtd;
+	void __user *argp = (void __user *)arg;
+	int ret = 0;
+
+	lock_kernel();
+
+	switch (cmd) {
+	case MEMWRITEOOB32:
+	{
+		struct mtd_oob_buf32 buf;
+		struct mtd_oob_buf32 __user *buf_user = argp;
+
+		if (copy_from_user(&buf, argp, sizeof(buf)))
+			ret = -EFAULT;
+		else
+			ret = mtd_do_writeoob(file, mtd, buf.start,
+				buf.length, compat_ptr(buf.ptr),
+				&buf_user->length);
+		break;
+	}
+
+	case MEMREADOOB32:
+	{
+		struct mtd_oob_buf32 buf;
+		struct mtd_oob_buf32 __user *buf_user = argp;
+
+		/* NOTE: writes return length to buf->start */
+		if (copy_from_user(&buf, argp, sizeof(buf)))
+			ret = -EFAULT;
+		else
+			ret = mtd_do_readoob(mtd, buf.start,
+				buf.length, compat_ptr(buf.ptr),
+				&buf_user->start);
+		break;
+	}
+	default:
+		ret = -ENOIOCTLCMD;
+	}
+
+	unlock_kernel();
+
+	return ret;
+}
+
+#endif /* CONFIG_COMPAT */
+
 /*
  * try to determine where a shared mapping can be made
  * - only supported for NOMMU at the moment (MMU can't doesn't copy private
@@ -830,6 +914,9 @@ static const struct file_operations mtd_
 	.read		= mtd_read,
 	.write		= mtd_write,
 	.ioctl		= mtd_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= mtd_compat_ioctl,
+#endif
 	.open		= mtd_open,
 	.release	= mtd_close,
 	.mmap		= mtd_mmap,
diff -puN fs/compat_ioctl.c~mtd-compat_ioctl-cleanup fs/compat_ioctl.c
--- a/fs/compat_ioctl.c~mtd-compat_ioctl-cleanup
+++ a/fs/compat_ioctl.c
@@ -1411,46 +1411,6 @@ static int ioc_settimeout(unsigned int f
 #define HIDPGETCONNLIST	_IOR('H', 210, int)
 #define HIDPGETCONNINFO	_IOR('H', 211, int)
 
-struct mtd_oob_buf32 {
-	u_int32_t start;
-	u_int32_t length;
-	compat_caddr_t ptr;	/* unsigned char* */
-};
-
-#define MEMWRITEOOB32 	_IOWR('M',3,struct mtd_oob_buf32)
-#define MEMREADOOB32 	_IOWR('M',4,struct mtd_oob_buf32)
-
-static int mtd_rw_oob(unsigned int fd, unsigned int cmd, unsigned long arg)
-{
-	struct mtd_oob_buf __user *buf = compat_alloc_user_space(sizeof(*buf));
-	struct mtd_oob_buf32 __user *buf32 = compat_ptr(arg);
-	u32 data;
-	char __user *datap;
-	unsigned int real_cmd;
-	int err;
-
-	real_cmd = (cmd == MEMREADOOB32) ?
-		MEMREADOOB : MEMWRITEOOB;
-
-	if (copy_in_user(&buf->start, &buf32->start,
-			 2 * sizeof(u32)) ||
-	    get_user(data, &buf32->ptr))
-		return -EFAULT;
-	datap = compat_ptr(data);
-	if (put_user(datap, &buf->ptr))
-		return -EFAULT;
-
-	err = sys_ioctl(fd, real_cmd, (unsigned long) buf);
-
-	if (!err) {
-		if (copy_in_user(&buf32->start, &buf->start,
-				 2 * sizeof(u32)))
-			err = -EFAULT;
-	}
-
-	return err;
-}	
-
 #ifdef CONFIG_BLOCK
 struct raw32_config_request
 {
@@ -2439,8 +2399,17 @@ COMPATIBLE_IOCTL(MEMLOCK)
 COMPATIBLE_IOCTL(MEMUNLOCK)
 COMPATIBLE_IOCTL(MEMGETREGIONCOUNT)
 COMPATIBLE_IOCTL(MEMGETREGIONINFO)
+COMPATIBLE_IOCTL(MEMSETOOBSEL)
+COMPATIBLE_IOCTL(MEMGETOOBSEL)
 COMPATIBLE_IOCTL(MEMGETBADBLOCK)
 COMPATIBLE_IOCTL(MEMSETBADBLOCK)
+COMPATIBLE_IOCTL(OTPSELECT)
+COMPATIBLE_IOCTL(OTPGETREGIONCOUNT)
+COMPATIBLE_IOCTL(OTPGETREGIONINFO)
+COMPATIBLE_IOCTL(OTPLOCK)
+COMPATIBLE_IOCTL(ECCGETLAYOUT)
+COMPATIBLE_IOCTL(ECCGETSTATS)
+COMPATIBLE_IOCTL(MTDFILEMODE)
 COMPATIBLE_IOCTL(MEMERASE64)
 /* NBD */
 ULONG_IOCTL(NBD_SET_SOCK)
@@ -2551,8 +2520,6 @@ COMPATIBLE_IOCTL(JSIOCGBUTTONS)
 COMPATIBLE_IOCTL(JSIOCGNAME(0))
 
 /* now things that need handlers */
-HANDLE_IOCTL(MEMREADOOB32, mtd_rw_oob)
-HANDLE_IOCTL(MEMWRITEOOB32, mtd_rw_oob)
 #ifdef CONFIG_NET
 HANDLE_IOCTL(SIOCGIFNAME, dev_ifname32)
 HANDLE_IOCTL(SIOCGIFCONF, dev_ifconf)
_

Patches currently in -mm which might be from kpc.mtd@gmail.com are

mtd-update-sysfs-documentation.patch
mtd-add-memerase64-ioctl-for-4gib-devices.patch
mtd-compat_ioctl-cleanup.patch
mtd-add-oob-ioctls-for-4gib-devices.patch

