From: akpm@linux-foundation.org
Subject: [merged] mtd-add-memerase64-ioctl-for-4gib-devices.patch removed from -mm tree
Date: Mon, 01 Jun 2009 12:57:04 -0700
Message-ID: <200906011957.n51Jv46t021503@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54508 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756018AbZFAT5b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Jun 2009 15:57:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kpc.mtd@gmail.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     mtd: add MEMERASE64 ioctl for >4GiB devices
has been removed from the -mm tree.  Its filename was
     mtd-add-memerase64-ioctl-for-4gib-devices.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd: add MEMERASE64 ioctl for >4GiB devices
From: Kevin Cernekee <kpc.mtd@gmail.com>

New MEMERASE/MEMREADOOB/MEMWRITEOOB ioctls are needed in order to support
64-bit offsets into large NAND flash devices.

Signed-off-by: Kevin Cernekee <kpc.mtd@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/mtdchar.c |   29 +++++++++++++++++++++--------
 fs/compat_ioctl.c     |    1 +
 include/mtd/mtd-abi.h |    6 ++++++
 3 files changed, 28 insertions(+), 8 deletions(-)

diff -puN drivers/mtd/mtdchar.c~mtd-add-memerase64-ioctl-for-4gib-devices drivers/mtd/mtdchar.c
--- a/drivers/mtd/mtdchar.c~mtd-add-memerase64-ioctl-for-4gib-devices
+++ a/drivers/mtd/mtdchar.c
@@ -417,6 +417,7 @@ static int mtd_ioctl(struct inode *inode
 		break;
 
 	case MEMERASE:
+	case MEMERASE64:
 	{
 		struct erase_info *erase;
 
@@ -427,20 +428,32 @@ static int mtd_ioctl(struct inode *inode
 		if (!erase)
 			ret = -ENOMEM;
 		else {
-			struct erase_info_user einfo;
-
 			wait_queue_head_t waitq;
 			DECLARE_WAITQUEUE(wait, current);
 
 			init_waitqueue_head(&waitq);
 
-			if (copy_from_user(&einfo, argp,
-				    sizeof(struct erase_info_user))) {
-				kfree(erase);
-				return -EFAULT;
+			if (cmd == MEMERASE64) {
+				struct erase_info_user64 einfo64;
+
+				if (copy_from_user(&einfo64, argp,
+					    sizeof(struct erase_info_user64))) {
+					kfree(erase);
+					return -EFAULT;
+				}
+				erase->addr = einfo64.start;
+				erase->len = einfo64.length;
+			} else {
+				struct erase_info_user einfo32;
+
+				if (copy_from_user(&einfo32, argp,
+					    sizeof(struct erase_info_user))) {
+					kfree(erase);
+					return -EFAULT;
+				}
+				erase->addr = einfo32.start;
+				erase->len = einfo32.length;
 			}
-			erase->addr = einfo.start;
-			erase->len = einfo.length;
 			erase->mtd = mtd;
 			erase->callback = mtdchar_erase_callback;
 			erase->priv = (unsigned long)&waitq;
diff -puN fs/compat_ioctl.c~mtd-add-memerase64-ioctl-for-4gib-devices fs/compat_ioctl.c
--- a/fs/compat_ioctl.c~mtd-add-memerase64-ioctl-for-4gib-devices
+++ a/fs/compat_ioctl.c
@@ -2441,6 +2441,7 @@ COMPATIBLE_IOCTL(MEMGETREGIONCOUNT)
 COMPATIBLE_IOCTL(MEMGETREGIONINFO)
 COMPATIBLE_IOCTL(MEMGETBADBLOCK)
 COMPATIBLE_IOCTL(MEMSETBADBLOCK)
+COMPATIBLE_IOCTL(MEMERASE64)
 /* NBD */
 ULONG_IOCTL(NBD_SET_SOCK)
 ULONG_IOCTL(NBD_SET_BLKSIZE)
diff -puN include/mtd/mtd-abi.h~mtd-add-memerase64-ioctl-for-4gib-devices include/mtd/mtd-abi.h
--- a/include/mtd/mtd-abi.h~mtd-add-memerase64-ioctl-for-4gib-devices
+++ a/include/mtd/mtd-abi.h
@@ -12,6 +12,11 @@ struct erase_info_user {
 	__u32 length;
 };
 
+struct erase_info_user64 {
+	__u64 start;
+	__u64 length;
+};
+
 struct mtd_oob_buf {
 	__u32 start;
 	__u32 length;
@@ -95,6 +100,7 @@ struct otp_info {
 #define ECCGETLAYOUT		_IOR('M', 17, struct nand_ecclayout)
 #define ECCGETSTATS		_IOR('M', 18, struct mtd_ecc_stats)
 #define MTDFILEMODE		_IO('M', 19)
+#define MEMERASE64		_IOW('M', 20, struct erase_info_user64)
 
 /*
  * Obsolete legacy interface. Keep it in order not to break userspace
_

Patches currently in -mm which might be from kpc.mtd@gmail.com are

linux-next.patch

