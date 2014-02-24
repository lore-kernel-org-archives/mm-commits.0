From: akpm@linux-foundation.org
Subject: + nilfs2-add-fitrim-ioctl-support-for-nilfs2.patch added to -mm
 tree
Date: Mon, 24 Feb 2014 15:01:46 -0800
Message-ID: <530bcf5a.4h1wd+6+HHJSy5W2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51394 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722AbaBXXBr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Feb 2014 18:01:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, konishi.ryusuke@lab.ntt.co.jp, andreas.rohner@gmx.net

Subject: + nilfs2-add-fitrim-ioctl-support-for-nilfs2.patch added to -mm tree
To: andreas.rohner@gmx.net,konishi.ryusuke@lab.ntt.co.jp
From: akpm@linux-foundation.org
Date: Mon, 24 Feb 2014 15:01:46 -0800


The patch titled
     Subject: nilfs2: add FITRIM ioctl support for nilfs2
has been added to the -mm tree.  Its filename is
     nilfs2-add-fitrim-ioctl-support-for-nilfs2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-add-fitrim-ioctl-support-for-nilfs2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-add-fitrim-ioctl-support-for-nilfs2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andreas Rohner <andreas.rohner@gmx.net>
Subject: nilfs2: add FITRIM ioctl support for nilfs2

Add support for the FITRIM ioctl, which enables user space tools to issue
TRIM/DISCARD requests to the underlying device.  Every clean segment
within the specified range will be discarded.

Signed-off-by: Andreas Rohner <andreas.rohner@gmx.net>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/ioctl.c |   45 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff -puN fs/nilfs2/ioctl.c~nilfs2-add-fitrim-ioctl-support-for-nilfs2 fs/nilfs2/ioctl.c
--- a/fs/nilfs2/ioctl.c~nilfs2-add-fitrim-ioctl-support-for-nilfs2
+++ a/fs/nilfs2/ioctl.c
@@ -1072,6 +1072,48 @@ out:
 }
 
 /**
+ * nilfs_ioctl_trim_fs() - trim ioctl handle function
+ * @inode: inode object
+ * @argp: pointer on argument from userspace
+ *
+ * Decription: nilfs_ioctl_trim_fs is the FITRIM ioctl handle function. It
+ * checks the arguments from userspace and calls nilfs_sufile_trim_fs, which
+ * performs the actual trim operation.
+ *
+ * Return Value: On success, 0 is returned or negative error code, otherwise.
+ */
+static int nilfs_ioctl_trim_fs(struct inode *inode, void __user *argp)
+{
+	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
+	struct request_queue *q = bdev_get_queue(nilfs->ns_bdev);
+	struct fstrim_range range;
+	int ret;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (!blk_queue_discard(q))
+		return -EOPNOTSUPP;
+
+	if (copy_from_user(&range, argp, sizeof(range)))
+		return -EFAULT;
+
+	range.minlen = max_t(u64, range.minlen, q->limits.discard_granularity);
+
+	down_read(&nilfs->ns_segctor_sem);
+	ret = nilfs_sufile_trim_fs(nilfs->ns_sufile, &range);
+	up_read(&nilfs->ns_segctor_sem);
+
+	if (ret < 0)
+		return ret;
+
+	if (copy_to_user(argp, &range, sizeof(range)))
+		return -EFAULT;
+
+	return 0;
+}
+
+/**
  * nilfs_ioctl_set_alloc_range - limit range of segments to be allocated
  * @inode: inode object
  * @argp: pointer on argument from userspace
@@ -1296,6 +1338,8 @@ long nilfs_ioctl(struct file *filp, unsi
 		return nilfs_ioctl_resize(inode, filp, argp);
 	case NILFS_IOCTL_SET_ALLOC_RANGE:
 		return nilfs_ioctl_set_alloc_range(inode, argp);
+	case FITRIM:
+		return nilfs_ioctl_trim_fs(inode, argp);
 	default:
 		return -ENOTTY;
 	}
@@ -1327,6 +1371,7 @@ long nilfs_compat_ioctl(struct file *fil
 	case NILFS_IOCTL_SYNC:
 	case NILFS_IOCTL_RESIZE:
 	case NILFS_IOCTL_SET_ALLOC_RANGE:
+	case FITRIM:
 		break;
 	default:
 		return -ENOIOCTLCMD;
_

Patches currently in -mm which might be from andreas.rohner@gmx.net are

nilfs2-add-struct-nilfs_suinfo_update-and-flags.patch
nilfs2-add-nilfs_sufile_set_suinfo-to-update-segment-usage.patch
nilfs2-add-nilfs_sufile_set_suinfo-to-update-segment-usage-fix.patch
nilfs2-implementation-of-nilfs_ioctl_set_suinfo-ioctl.patch
nilfs2-implementation-of-nilfs_ioctl_set_suinfo-ioctl-fix.patch
nilfs2-add-nilfs_sufile_trim_fs-to-trim-clean-segs.patch
nilfs2-add-fitrim-ioctl-support-for-nilfs2.patch
nilfs2-verify-metadata-sizes-read-from-disk.patch

