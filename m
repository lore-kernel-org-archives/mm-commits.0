From: akpm@linux-foundation.org
Subject: + nilfs2-implementation-of-nilfs_ioctl_set_suinfo-ioctl.patch
 added to -mm tree
Date: Mon, 03 Feb 2014 13:41:15 -0800
Message-ID: <52f00cfb.tsrkU2P61Lizhb+F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46782 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502AbaBCVlQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Feb 2014 16:41:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, konishi.ryusuke@lab.ntt.co.jp, andreas.rohner@gmx.net

Subject: + nilfs2-implementation-of-nilfs_ioctl_set_suinfo-ioctl.patch added to -mm tree
To: andreas.rohner@gmx.net,konishi.ryusuke@lab.ntt.co.jp
From: akpm@linux-foundation.org
Date: Mon, 03 Feb 2014 13:41:15 -0800


The patch titled
     Subject: nilfs2: implementation of NILFS_IOCTL_SET_SUINFO ioctl
has been added to the -mm tree.  Its filename is
     nilfs2-implementation-of-nilfs_ioctl_set_suinfo-ioctl.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-implementation-of-nilfs_ioctl_set_suinfo-ioctl.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-implementation-of-nilfs_ioctl_set_suinfo-ioctl.patch

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
Subject: nilfs2: implementation of NILFS_IOCTL_SET_SUINFO ioctl

With this ioctl the segment usage entries in the SUFILE can be updated
from userspace.

This is useful, because it allows the userspace GC to modify and update
segment usage entries for specific segments, which enables it to avoid
unnecessary write operations.

If a segment needs to be cleaned, but there is no or very little
reclaimable space in it, the cleaning operation basically degrades to a
useless moving operation.  In the end the only thing that changes is the
location of the data and a timestamp in the segment usage information. 
With this ioctl the GC can skip the cleaning and update the segment usage
entries directly instead.

This is basically a shortcut to cleaning the segment.  It is still
necessary to read the segment summary information, but the writing of the
live blocks can be skipped if it's not worth it.

Signed-off-by: Andreas Rohner <andreas.rohner@gmx.net>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/ioctl.c         |   92 ++++++++++++++++++++++++++++++++++++
 include/linux/nilfs2_fs.h |    2 
 2 files changed, 94 insertions(+)

diff -puN fs/nilfs2/ioctl.c~nilfs2-implementation-of-nilfs_ioctl_set_suinfo-ioctl fs/nilfs2/ioctl.c
--- a/fs/nilfs2/ioctl.c~nilfs2-implementation-of-nilfs_ioctl_set_suinfo-ioctl
+++ a/fs/nilfs2/ioctl.c
@@ -1163,6 +1163,95 @@ static int nilfs_ioctl_get_info(struct i
 	return ret;
 }
 
+/**
+ * nilfs_ioctl_set_suinfo - set segment usage info
+ * @inode: inode object
+ * @filp: file object
+ * @cmd: ioctl's request code
+ * @argp: pointer on argument from userspace
+ *
+ * Description: Expects an array of nilfs_suinfo_update structures
+ * encapsulated in nilfs_argv and updates the segment usage info
+ * according to the flags in nilfs_suinfo_update.
+ *
+ * Return Value: On success, 0 is returned. On error, one of the
+ * following negative error codes is returned.
+ *
+ * %-EPERM - Not enough permissions
+ *
+ * %-EFAULT - Error copying input data
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ *
+ * %-EINVAL - Invalid values in input (segment number, flags or nblocks)
+ */
+static int nilfs_ioctl_set_suinfo(struct inode *inode, struct file *filp,
+				unsigned int cmd, void __user *argp)
+{
+	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
+	struct nilfs_transaction_info ti;
+	struct nilfs_argv argv;
+	size_t len;
+	void __user *base;
+	void *kbuf;
+	int ret;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	ret = mnt_want_write_file(filp);
+	if (ret)
+		return ret;
+
+	ret = -EFAULT;
+	if (copy_from_user(&argv, argp, sizeof(argv)))
+		goto out;
+
+	ret = -EINVAL;
+	if (argv.v_size < sizeof(struct nilfs_suinfo_update))
+		goto out;
+
+	if (argv.v_nmembs > nilfs->ns_nsegments)
+		goto out;
+
+	if (argv.v_nmembs >= UINT_MAX / argv.v_size)
+		goto out;
+
+	len = argv.v_size * argv.v_nmembs;
+	if (!len) {
+		ret = 0;
+		goto out;
+	}
+
+	base = (void __user *)(unsigned long)argv.v_base;
+	kbuf = vmalloc(len);
+	if (!kbuf) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	if (copy_from_user(kbuf, base, len)) {
+		ret = -EFAULT;
+		goto out_free;
+	}
+
+	nilfs_transaction_begin(inode->i_sb, &ti, 0);
+	ret = nilfs_sufile_set_suinfo(nilfs->ns_sufile, kbuf, argv.v_size,
+			argv.v_nmembs);
+	if (unlikely(ret < 0))
+		nilfs_transaction_abort(inode->i_sb);
+	else
+		nilfs_transaction_commit(inode->i_sb); /* never fails */
+
+out_free:
+	vfree(kbuf);
+out:
+	mnt_drop_write_file(filp);
+	return ret;
+}
+
 long nilfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
@@ -1189,6 +1278,8 @@ long nilfs_ioctl(struct file *filp, unsi
 		return nilfs_ioctl_get_info(inode, filp, cmd, argp,
 					    sizeof(struct nilfs_suinfo),
 					    nilfs_ioctl_do_get_suinfo);
+	case NILFS_IOCTL_SET_SUINFO:
+		return nilfs_ioctl_set_suinfo(inode, filp, cmd, argp);
 	case NILFS_IOCTL_GET_SUSTAT:
 		return nilfs_ioctl_get_sustat(inode, filp, cmd, argp);
 	case NILFS_IOCTL_GET_VINFO:
@@ -1228,6 +1319,7 @@ long nilfs_compat_ioctl(struct file *fil
 	case NILFS_IOCTL_GET_CPINFO:
 	case NILFS_IOCTL_GET_CPSTAT:
 	case NILFS_IOCTL_GET_SUINFO:
+	case NILFS_IOCTL_SET_SUINFO:
 	case NILFS_IOCTL_GET_SUSTAT:
 	case NILFS_IOCTL_GET_VINFO:
 	case NILFS_IOCTL_GET_BDESCS:
diff -puN include/linux/nilfs2_fs.h~nilfs2-implementation-of-nilfs_ioctl_set_suinfo-ioctl include/linux/nilfs2_fs.h
--- a/include/linux/nilfs2_fs.h~nilfs2-implementation-of-nilfs_ioctl_set_suinfo-ioctl
+++ a/include/linux/nilfs2_fs.h
@@ -905,5 +905,7 @@ struct nilfs_bdesc {
 	_IOW(NILFS_IOCTL_IDENT, 0x8B, __u64)
 #define NILFS_IOCTL_SET_ALLOC_RANGE  \
 	_IOW(NILFS_IOCTL_IDENT, 0x8C, __u64[2])
+#define NILFS_IOCTL_SET_SUINFO  \
+	_IOW(NILFS_IOCTL_IDENT, 0x8D, struct nilfs_argv)
 
 #endif	/* _LINUX_NILFS_FS_H */
_

Patches currently in -mm which might be from andreas.rohner@gmx.net are

nilfs2-add-struct-nilfs_suinfo_update-and-flags.patch
nilfs2-add-nilfs_sufile_set_suinfo-to-update-segment-usage.patch
nilfs2-implementation-of-nilfs_ioctl_set_suinfo-ioctl.patch

