From: akpm@linux-foundation.org
Subject: + nilfs2-verify-metadata-sizes-read-from-disk.patch added to -mm
 tree
Date: Mon, 24 Feb 2014 15:01:47 -0800
Message-ID: <530bcf5b.IetnYDjOcy5usRWL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51397 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbaBXXBs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Feb 2014 18:01:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, andreas.rohner@gmx.net, konishi.ryusuke@lab.ntt.co.jp

Subject: + nilfs2-verify-metadata-sizes-read-from-disk.patch added to -mm tree
To: konishi.ryusuke@lab.ntt.co.jp,andreas.rohner@gmx.net
From: akpm@linux-foundation.org
Date: Mon, 24 Feb 2014 15:01:47 -0800


The patch titled
     Subject: nilfs2: verify metadata sizes read from disk
has been added to the -mm tree.  Its filename is
     nilfs2-verify-metadata-sizes-read-from-disk.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-verify-metadata-sizes-read-from-disk.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-verify-metadata-sizes-read-from-disk.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: verify metadata sizes read from disk

Add code to check sizes of on-disk data of metadata files such as inode
size, segment usage size, DAT entry size, and checkpoint size.  Although
these sizes are read from disk, the current implementation doesn't check
them.

If these sizes are not sane on disk, it can cause out-of-range access to
metadata or memory access overrun on metadata block buffers due to
overflow in sundry calculations.

Both lower limit and upper limit of metadata sizes are verified to prevent
these issues.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Andreas Rohner <andreas.rohner@gmx.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/cpfile.c        |   12 ++++++++++++
 fs/nilfs2/dat.c           |   12 ++++++++++++
 fs/nilfs2/sufile.c        |   12 ++++++++++++
 fs/nilfs2/the_nilfs.c     |   10 ++++++++++
 include/linux/nilfs2_fs.h |    8 ++++++++
 5 files changed, 54 insertions(+)

diff -puN fs/nilfs2/cpfile.c~nilfs2-verify-metadata-sizes-read-from-disk fs/nilfs2/cpfile.c
--- a/fs/nilfs2/cpfile.c~nilfs2-verify-metadata-sizes-read-from-disk
+++ a/fs/nilfs2/cpfile.c
@@ -942,6 +942,18 @@ int nilfs_cpfile_read(struct super_block
 	struct inode *cpfile;
 	int err;
 
+	if (cpsize > sb->s_blocksize) {
+		printk(KERN_ERR
+		       "NILFS: too large checkpoint size: %zu bytes.\n",
+		       cpsize);
+		return -EINVAL;
+	} else if (cpsize < NILFS_MIN_CHECKPOINT_SIZE) {
+		printk(KERN_ERR
+		       "NILFS: too small checkpoint size: %zu bytes.\n",
+		       cpsize);
+		return -EINVAL;
+	}
+
 	cpfile = nilfs_iget_locked(sb, NULL, NILFS_CPFILE_INO);
 	if (unlikely(!cpfile))
 		return -ENOMEM;
diff -puN fs/nilfs2/dat.c~nilfs2-verify-metadata-sizes-read-from-disk fs/nilfs2/dat.c
--- a/fs/nilfs2/dat.c~nilfs2-verify-metadata-sizes-read-from-disk
+++ a/fs/nilfs2/dat.c
@@ -484,6 +484,18 @@ int nilfs_dat_read(struct super_block *s
 	struct nilfs_dat_info *di;
 	int err;
 
+	if (entry_size > sb->s_blocksize) {
+		printk(KERN_ERR
+		       "NILFS: too large DAT entry size: %zu bytes.\n",
+		       entry_size);
+		return -EINVAL;
+	} else if (entry_size < NILFS_MIN_DAT_ENTRY_SIZE) {
+		printk(KERN_ERR
+		       "NILFS: too small DAT entry size: %zu bytes.\n",
+		       entry_size);
+		return -EINVAL;
+	}
+
 	dat = nilfs_iget_locked(sb, NULL, NILFS_DAT_INO);
 	if (unlikely(!dat))
 		return -ENOMEM;
diff -puN fs/nilfs2/sufile.c~nilfs2-verify-metadata-sizes-read-from-disk fs/nilfs2/sufile.c
--- a/fs/nilfs2/sufile.c~nilfs2-verify-metadata-sizes-read-from-disk
+++ a/fs/nilfs2/sufile.c
@@ -1169,6 +1169,18 @@ int nilfs_sufile_read(struct super_block
 	void *kaddr;
 	int err;
 
+	if (susize > sb->s_blocksize) {
+		printk(KERN_ERR
+		       "NILFS: too large segment usage size: %zu bytes.\n",
+		       susize);
+		return -EINVAL;
+	} else if (susize < NILFS_MIN_SEGMENT_USAGE_SIZE) {
+		printk(KERN_ERR
+		       "NILFS: too small segment usage size: %zu bytes.\n",
+		       susize);
+		return -EINVAL;
+	}
+
 	sufile = nilfs_iget_locked(sb, NULL, NILFS_SUFILE_INO);
 	if (unlikely(!sufile))
 		return -ENOMEM;
diff -puN fs/nilfs2/the_nilfs.c~nilfs2-verify-metadata-sizes-read-from-disk fs/nilfs2/the_nilfs.c
--- a/fs/nilfs2/the_nilfs.c~nilfs2-verify-metadata-sizes-read-from-disk
+++ a/fs/nilfs2/the_nilfs.c
@@ -399,6 +399,16 @@ static int nilfs_store_disk_layout(struc
 		return -EINVAL;
 
 	nilfs->ns_inode_size = le16_to_cpu(sbp->s_inode_size);
+	if (nilfs->ns_inode_size > nilfs->ns_blocksize) {
+		printk(KERN_ERR "NILFS: too large inode size: %d bytes.\n",
+		       nilfs->ns_inode_size);
+		return -EINVAL;
+	} else if (nilfs->ns_inode_size < NILFS_MIN_INODE_SIZE) {
+		printk(KERN_ERR "NILFS: too small inode size: %d bytes.\n",
+		       nilfs->ns_inode_size);
+		return -EINVAL;
+	}
+
 	nilfs->ns_first_ino = le32_to_cpu(sbp->s_first_ino);
 
 	nilfs->ns_blocks_per_segment = le32_to_cpu(sbp->s_blocks_per_segment);
diff -puN include/linux/nilfs2_fs.h~nilfs2-verify-metadata-sizes-read-from-disk include/linux/nilfs2_fs.h
--- a/include/linux/nilfs2_fs.h~nilfs2-verify-metadata-sizes-read-from-disk
+++ a/include/linux/nilfs2_fs.h
@@ -82,6 +82,8 @@ struct nilfs_inode {
 	__le32	i_pad;
 };
 
+#define NILFS_MIN_INODE_SIZE		128
+
 /**
  * struct nilfs_super_root - structure of super root
  * @sr_sum: check sum
@@ -482,6 +484,8 @@ struct nilfs_dat_entry {
 	__le64 de_rsv;
 };
 
+#define NILFS_MIN_DAT_ENTRY_SIZE	32
+
 /**
  * struct nilfs_snapshot_list - snapshot list
  * @ssl_next: next checkpoint number on snapshot list
@@ -520,6 +524,8 @@ struct nilfs_checkpoint {
 	struct nilfs_inode cp_ifile_inode;
 };
 
+#define NILFS_MIN_CHECKPOINT_SIZE	(64 + NILFS_MIN_INODE_SIZE)
+
 /* checkpoint flags */
 enum {
 	NILFS_CHECKPOINT_SNAPSHOT,
@@ -615,6 +621,8 @@ struct nilfs_segment_usage {
 	__le32 su_flags;
 };
 
+#define NILFS_MIN_SEGMENT_USAGE_SIZE	16
+
 /* segment usage flag */
 enum {
 	NILFS_SEGMENT_USAGE_ACTIVE,
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

nilfs2-update-maintainers-file-entries.patch
nilfs2-add-struct-nilfs_suinfo_update-and-flags.patch
nilfs2-add-nilfs_sufile_set_suinfo-to-update-segment-usage.patch
nilfs2-add-nilfs_sufile_set_suinfo-to-update-segment-usage-fix.patch
nilfs2-implementation-of-nilfs_ioctl_set_suinfo-ioctl.patch
nilfs2-implementation-of-nilfs_ioctl_set_suinfo-ioctl-fix.patch
nilfs2-add-nilfs_sufile_trim_fs-to-trim-clean-segs.patch
nilfs2-add-fitrim-ioctl-support-for-nilfs2.patch
nilfs2-verify-metadata-sizes-read-from-disk.patch

