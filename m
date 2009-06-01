From: akpm@linux-foundation.org
Subject: [merged] mtd-add-oob-ioctls-for-4gib-devices.patch removed from -mm tree
Date: Mon, 01 Jun 2009 12:57:08 -0700
Message-ID: <200906011957.n51Jv8vJ021592@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56634 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752375AbZFAT5o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Jun 2009 15:57:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kpc.mtd@gmail.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     mtd: add OOB ioctls for >4GiB devices
has been removed from the -mm tree.  Its filename was
     mtd-add-oob-ioctls-for-4gib-devices.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd: add OOB ioctls for >4GiB devices
From: Kevin Cernekee <kpc.mtd@gmail.com>

Signed-off-by: Kevin Cernekee <kpc.mtd@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/mtdchar.c |   28 ++++++++++++++++++++++++++++
 fs/compat_ioctl.c     |    2 ++
 include/mtd/mtd-abi.h |    9 +++++++++
 3 files changed, 39 insertions(+)

diff -puN drivers/mtd/mtdchar.c~mtd-add-oob-ioctls-for-4gib-devices drivers/mtd/mtdchar.c
--- a/drivers/mtd/mtdchar.c~mtd-add-oob-ioctls-for-4gib-devices
+++ a/drivers/mtd/mtdchar.c
@@ -607,6 +607,34 @@ static int mtd_ioctl(struct inode *inode
 		break;
 	}
 
+	case MEMWRITEOOB64:
+	{
+		struct mtd_oob_buf64 buf;
+		struct mtd_oob_buf64 __user *buf_user = argp;
+
+		if (copy_from_user(&buf, argp, sizeof(buf)))
+			ret = -EFAULT;
+		else
+			ret = mtd_do_writeoob(file, mtd, buf.start, buf.length,
+				(void __user *)(uintptr_t)buf.usr_ptr,
+				&buf_user->length);
+		break;
+	}
+
+	case MEMREADOOB64:
+	{
+		struct mtd_oob_buf64 buf;
+		struct mtd_oob_buf64 __user *buf_user = argp;
+
+		if (copy_from_user(&buf, argp, sizeof(buf)))
+			ret = -EFAULT;
+		else
+			ret = mtd_do_readoob(mtd, buf.start, buf.length,
+				(void __user *)(uintptr_t)buf.usr_ptr,
+				&buf_user->length);
+		break;
+	}
+
 	case MEMLOCK:
 	{
 		struct erase_info_user einfo;
diff -puN fs/compat_ioctl.c~mtd-add-oob-ioctls-for-4gib-devices fs/compat_ioctl.c
--- a/fs/compat_ioctl.c~mtd-add-oob-ioctls-for-4gib-devices
+++ a/fs/compat_ioctl.c
@@ -2411,6 +2411,8 @@ COMPATIBLE_IOCTL(ECCGETLAYOUT)
 COMPATIBLE_IOCTL(ECCGETSTATS)
 COMPATIBLE_IOCTL(MTDFILEMODE)
 COMPATIBLE_IOCTL(MEMERASE64)
+COMPATIBLE_IOCTL(MEMREADOOB64)
+COMPATIBLE_IOCTL(MEMWRITEOOB64)
 /* NBD */
 ULONG_IOCTL(NBD_SET_SOCK)
 ULONG_IOCTL(NBD_SET_BLKSIZE)
diff -puN include/mtd/mtd-abi.h~mtd-add-oob-ioctls-for-4gib-devices include/mtd/mtd-abi.h
--- a/include/mtd/mtd-abi.h~mtd-add-oob-ioctls-for-4gib-devices
+++ a/include/mtd/mtd-abi.h
@@ -23,6 +23,13 @@ struct mtd_oob_buf {
 	unsigned char __user *ptr;
 };
 
+struct mtd_oob_buf64 {
+	__u64 start;
+	__u32 pad;
+	__u32 length;
+	__u64 usr_ptr;
+};
+
 #define MTD_ABSENT		0
 #define MTD_RAM			1
 #define MTD_ROM			2
@@ -101,6 +108,8 @@ struct otp_info {
 #define ECCGETSTATS		_IOR('M', 18, struct mtd_ecc_stats)
 #define MTDFILEMODE		_IO('M', 19)
 #define MEMERASE64		_IOW('M', 20, struct erase_info_user64)
+#define MEMWRITEOOB64		_IOWR('M', 21, struct mtd_oob_buf64)
+#define MEMREADOOB64		_IOWR('M', 22, struct mtd_oob_buf64)
 
 /*
  * Obsolete legacy interface. Keep it in order not to break userspace
_

Patches currently in -mm which might be from kpc.mtd@gmail.com are

linux-next.patch

