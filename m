From: akpm@linux-foundation.org
Subject: + nilfs2-add-nilfs_sufile_trim_fs-to-trim-clean-segs.patch added
 to -mm tree
Date: Mon, 24 Feb 2014 15:01:44 -0800
Message-ID: <530bcf58.mVDExgO3WGCK3Vbz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51389 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbaBXXBp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Feb 2014 18:01:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, konishi.ryusuke@lab.ntt.co.jp, andreas.rohner@gmx.net

Subject: + nilfs2-add-nilfs_sufile_trim_fs-to-trim-clean-segs.patch added to -mm tree
To: andreas.rohner@gmx.net,konishi.ryusuke@lab.ntt.co.jp
From: akpm@linux-foundation.org
Date: Mon, 24 Feb 2014 15:01:44 -0800


The patch titled
     Subject: nilfs2: add nilfs_sufile_trim_fs to trim clean segs
has been added to the -mm tree.  Its filename is
     nilfs2-add-nilfs_sufile_trim_fs-to-trim-clean-segs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-add-nilfs_sufile_trim_fs-to-trim-clean-segs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-add-nilfs_sufile_trim_fs-to-trim-clean-segs.patch

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
Subject: nilfs2: add nilfs_sufile_trim_fs to trim clean segs

Add nilfs_sufile_trim_fs(), which takes an fstrim_range structure and calls
blkdev_issue_discard for every clean segment in the specified range.  The
range is truncated to file system block boundaries.

Signed-off-by: Andreas Rohner <andreas.rohner@gmx.net>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/sufile.c |  152 +++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/sufile.h |    1 
 2 files changed, 153 insertions(+)

diff -puN fs/nilfs2/sufile.c~nilfs2-add-nilfs_sufile_trim_fs-to-trim-clean-segs fs/nilfs2/sufile.c
--- a/fs/nilfs2/sufile.c~nilfs2-add-nilfs_sufile_trim_fs-to-trim-clean-segs
+++ a/fs/nilfs2/sufile.c
@@ -1001,6 +1001,158 @@ ssize_t nilfs_sufile_set_suinfo(struct i
 }
 
 /**
+ * nilfs_sufile_trim_fs() - trim ioctl handle function
+ * @sufile: inode of segment usage file
+ * @range: fstrim_range structure
+ *
+ * start:	First Byte to trim
+ * len:		number of Bytes to trim from start
+ * minlen:	minimum extent length in Bytes
+ *
+ * Decription: nilfs_sufile_trim_fs goes through all segments containing bytes
+ * from start to start+len. start is rounded up to the next block boundary
+ * and start+len is rounded down. For each clean segment blkdev_issue_discard
+ * function is invoked.
+ *
+ * Return Value: On success, 0 is returned or negative error code, otherwise.
+ */
+int nilfs_sufile_trim_fs(struct inode *sufile, struct fstrim_range *range)
+{
+	struct the_nilfs *nilfs = sufile->i_sb->s_fs_info;
+	struct buffer_head *su_bh;
+	struct nilfs_segment_usage *su;
+	void *kaddr;
+	size_t n, i, susz = NILFS_MDT(sufile)->mi_entry_size;
+	sector_t seg_start, seg_end, start_block, end_block;
+	sector_t start = 0, nblocks = 0;
+	u64 segnum, segnum_end, minlen, len, max_blocks, ndiscarded = 0;
+	int ret = 0;
+	unsigned int sects_per_block;
+
+	sects_per_block = (1 << nilfs->ns_blocksize_bits) /
+			bdev_logical_block_size(nilfs->ns_bdev);
+	len = range->len >> nilfs->ns_blocksize_bits;
+	minlen = range->minlen >> nilfs->ns_blocksize_bits;
+	max_blocks = ((u64)nilfs->ns_nsegments * nilfs->ns_blocks_per_segment);
+
+	if (!len || range->start >= max_blocks << nilfs->ns_blocksize_bits)
+		return -EINVAL;
+
+	start_block = (range->start + nilfs->ns_blocksize - 1) >>
+			nilfs->ns_blocksize_bits;
+
+	/*
+	 * range->len can be very large (actually, it is set to
+	 * ULLONG_MAX by default) - truncate upper end of the range
+	 * carefully so as not to overflow.
+	 */
+	if (max_blocks - start_block < len)
+		end_block = max_blocks - 1;
+	else
+		end_block = start_block + len - 1;
+
+	segnum = nilfs_get_segnum_of_block(nilfs, start_block);
+	segnum_end = nilfs_get_segnum_of_block(nilfs, end_block);
+
+	down_read(&NILFS_MDT(sufile)->mi_sem);
+
+	while (segnum <= segnum_end) {
+		n = nilfs_sufile_segment_usages_in_block(sufile, segnum,
+				segnum_end);
+
+		ret = nilfs_sufile_get_segment_usage_block(sufile, segnum, 0,
+							   &su_bh);
+		if (ret < 0) {
+			if (ret != -ENOENT)
+				goto out_sem;
+			/* hole */
+			segnum += n;
+			continue;
+		}
+
+		kaddr = kmap_atomic(su_bh->b_page);
+		su = nilfs_sufile_block_get_segment_usage(sufile, segnum,
+				su_bh, kaddr);
+		for (i = 0; i < n; ++i, ++segnum, su = (void *)su + susz) {
+			if (!nilfs_segment_usage_clean(su))
+				continue;
+
+			nilfs_get_segment_range(nilfs, segnum, &seg_start,
+						&seg_end);
+
+			if (!nblocks) {
+				/* start new extent */
+				start = seg_start;
+				nblocks = seg_end - seg_start + 1;
+				continue;
+			}
+
+			if (start + nblocks == seg_start) {
+				/* add to previous extent */
+				nblocks += seg_end - seg_start + 1;
+				continue;
+			}
+
+			/* discard previous extent */
+			if (start < start_block) {
+				nblocks -= start_block - start;
+				start = start_block;
+			}
+
+			if (nblocks >= minlen) {
+				kunmap_atomic(kaddr);
+
+				ret = blkdev_issue_discard(nilfs->ns_bdev,
+						start * sects_per_block,
+						nblocks * sects_per_block,
+						GFP_NOFS, 0);
+				if (ret < 0) {
+					put_bh(su_bh);
+					goto out_sem;
+				}
+
+				ndiscarded += nblocks;
+				kaddr = kmap_atomic(su_bh->b_page);
+				su = nilfs_sufile_block_get_segment_usage(
+					sufile, segnum, su_bh, kaddr);
+			}
+
+			/* start new extent */
+			start = seg_start;
+			nblocks = seg_end - seg_start + 1;
+		}
+		kunmap_atomic(kaddr);
+		put_bh(su_bh);
+	}
+
+
+	if (nblocks) {
+		/* discard last extent */
+		if (start < start_block) {
+			nblocks -= start_block - start;
+			start = start_block;
+		}
+		if (start + nblocks > end_block + 1)
+			nblocks = end_block - start + 1;
+
+		if (nblocks >= minlen) {
+			ret = blkdev_issue_discard(nilfs->ns_bdev,
+					start * sects_per_block,
+					nblocks * sects_per_block,
+					GFP_NOFS, 0);
+			if (!ret)
+				ndiscarded += nblocks;
+		}
+	}
+
+out_sem:
+	up_read(&NILFS_MDT(sufile)->mi_sem);
+
+	range->len = ndiscarded << nilfs->ns_blocksize_bits;
+	return ret;
+}
+
+/**
  * nilfs_sufile_read - read or get sufile inode
  * @sb: super block instance
  * @susize: size of a segment usage entry
diff -puN fs/nilfs2/sufile.h~nilfs2-add-nilfs_sufile_trim_fs-to-trim-clean-segs fs/nilfs2/sufile.h
--- a/fs/nilfs2/sufile.h~nilfs2-add-nilfs_sufile_trim_fs-to-trim-clean-segs
+++ a/fs/nilfs2/sufile.h
@@ -66,6 +66,7 @@ void nilfs_sufile_do_set_error(struct in
 int nilfs_sufile_resize(struct inode *sufile, __u64 newnsegs);
 int nilfs_sufile_read(struct super_block *sb, size_t susize,
 		      struct nilfs_inode *raw_inode, struct inode **inodep);
+int nilfs_sufile_trim_fs(struct inode *sufile, struct fstrim_range *range);
 
 /**
  * nilfs_sufile_scrap - make a segment garbage
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

