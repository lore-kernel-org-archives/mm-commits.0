From: akpm@linux-foundation.org
Subject: +
 nilfs2-add-nilfs_sufile_set_suinfo-to-update-segment-usage.patch added to
 -mm tree
Date: Mon, 03 Feb 2014 13:41:14 -0800
Message-ID: <52f00cfa.A/4LXGd50RgCfA4K%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46779 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbaBCVlP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Feb 2014 16:41:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, konishi.ryusuke@lab.ntt.co.jp, andreas.rohner@gmx.net

Subject: + nilfs2-add-nilfs_sufile_set_suinfo-to-update-segment-usage.patch added to -mm tree
To: andreas.rohner@gmx.net,konishi.ryusuke@lab.ntt.co.jp
From: akpm@linux-foundation.org
Date: Mon, 03 Feb 2014 13:41:14 -0800


The patch titled
     Subject: nilfs2: add nilfs_sufile_set_suinfo to update segment usage
has been added to the -mm tree.  Its filename is
     nilfs2-add-nilfs_sufile_set_suinfo-to-update-segment-usage.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-add-nilfs_sufile_set_suinfo-to-update-segment-usage.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-add-nilfs_sufile_set_suinfo-to-update-segment-usage.patch

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
Subject: nilfs2: add nilfs_sufile_set_suinfo to update segment usage

Introduce nilfs_sufile_set_suinfo(), which expects an array of
nilfs_suinfo_update structures and updates the segment usage information
accordingly.

This is basically a helper function for the newly introduced
NILFS_IOCTL_SET_SUINFO ioctl.

Signed-off-by: Andreas Rohner <andreas.rohner@gmx.net>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/sufile.c |  131 +++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/sufile.h |    1 
 2 files changed, 132 insertions(+)

diff -puN fs/nilfs2/sufile.c~nilfs2-add-nilfs_sufile_set_suinfo-to-update-segment-usage fs/nilfs2/sufile.c
--- a/fs/nilfs2/sufile.c~nilfs2-add-nilfs_sufile_set_suinfo-to-update-segment-usage
+++ a/fs/nilfs2/sufile.c
@@ -870,6 +870,137 @@ ssize_t nilfs_sufile_get_suinfo(struct i
 }
 
 /**
+ * nilfs_sufile_set_suinfo - sets segment usage info
+ * @sufile: inode of segment usage file
+ * @buf: array of suinfo_update
+ * @supsz: byte size of suinfo_update
+ * @nsup: size of suinfo_update array
+ *
+ * Description: Takes an array of nilfs_suinfo_update structs and updates
+ * segment usage accordingly. Only the fields indicated by the sup_flags
+ * are updated.
+ *
+ * Return Value: On success, 0 is returned. On error, one of the
+ * following negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ *
+ * %-EINVAL - Invalid values in input (segment number, flags or nblocks)
+ */
+ssize_t nilfs_sufile_set_suinfo(struct inode *sufile, void *buf,
+				unsigned supsz, size_t nsup)
+{
+	struct the_nilfs *nilfs = sufile->i_sb->s_fs_info;
+	struct buffer_head *header_bh, *bh;
+	struct nilfs_suinfo_update *sup, *supend = buf + supsz * nsup;
+	struct nilfs_segment_usage *su;
+	void *kaddr;
+	unsigned long blkoff, prev_blkoff;
+	int cleansi, cleansu, dirtysi, dirtysu;
+	long ncleaned = 0, ndirtied = 0;
+	int ret = 0;
+
+	if (unlikely(nsup == 0))
+		return ret;
+
+	for (sup = buf; sup < supend; sup = (void *)sup + supsz) {
+		if (sup->sup_segnum >= nilfs->ns_nsegments
+			|| (sup->sup_flags &
+				(~0UL << __NR_NILFS_SUINFO_UPDATE_FIELDS))
+			|| (nilfs_suinfo_update_nblocks(sup) &&
+				sup->sup_sui.sui_nblocks >
+				nilfs->ns_blocks_per_segment))
+			return -EINVAL;
+	}
+
+	down_write(&NILFS_MDT(sufile)->mi_sem);
+
+	ret = nilfs_sufile_get_header_block(sufile, &header_bh);
+	if (ret < 0)
+		goto out_sem;
+
+	sup = buf;
+	blkoff = nilfs_sufile_get_blkoff(sufile, sup->sup_segnum);
+	ret = nilfs_mdt_get_block(sufile, blkoff, 1, NULL, &bh);
+	if (ret < 0)
+		goto out_header;
+
+	for (;;) {
+		kaddr = kmap_atomic(bh->b_page);
+		su = nilfs_sufile_block_get_segment_usage(
+			sufile, sup->sup_segnum, bh, kaddr);
+
+		if (nilfs_suinfo_update_lastmod(sup))
+			su->su_lastmod = cpu_to_le64(sup->sup_sui.sui_lastmod);
+
+		if (nilfs_suinfo_update_nblocks(sup))
+			su->su_nblocks = cpu_to_le32(sup->sup_sui.sui_nblocks);
+
+		if (nilfs_suinfo_update_flags(sup)) {
+			/*
+			 * Active flag is a virtual flag projected by running
+			 * nilfs kernel code - drop it not to write it to
+			 * disk.
+			 */
+			sup->sup_sui.sui_flags &=
+					~(1UL << NILFS_SEGMENT_USAGE_ACTIVE);
+
+			cleansi = nilfs_suinfo_clean(&sup->sup_sui);
+			cleansu = nilfs_segment_usage_clean(su);
+			dirtysi = nilfs_suinfo_dirty(&sup->sup_sui);
+			dirtysu = nilfs_segment_usage_dirty(su);
+
+			if (cleansi && !cleansu)
+				++ncleaned;
+			else if (!cleansi && cleansu)
+				--ncleaned;
+
+			if (dirtysi && !dirtysu)
+				++ndirtied;
+			else if (!dirtysi && dirtysu)
+				--ndirtied;
+
+			su->su_flags = cpu_to_le32(sup->sup_sui.sui_flags);
+		}
+
+		kunmap_atomic(kaddr);
+
+		sup = (void *)sup + supsz;
+		if (sup >= supend)
+			break;
+
+		prev_blkoff = blkoff;
+		blkoff = nilfs_sufile_get_blkoff(sufile, sup->sup_segnum);
+		if (blkoff == prev_blkoff)
+			continue;
+
+		/* get different block */
+		mark_buffer_dirty(bh);
+		brelse(bh);
+		ret = nilfs_mdt_get_block(sufile, blkoff, 1, NULL, &bh);
+		if (unlikely(ret < 0))
+			goto out_mark;
+	}
+	mark_buffer_dirty(bh);
+	brelse(bh);
+
+ out_mark:
+	if (ncleaned || ndirtied) {
+		nilfs_sufile_mod_counter(header_bh, (u64)ncleaned,
+				(u64)ndirtied);
+		NILFS_SUI(sufile)->ncleansegs += ncleaned;
+	}
+	nilfs_mdt_mark_dirty(sufile);
+ out_header:
+	brelse(header_bh);
+ out_sem:
+	up_write(&NILFS_MDT(sufile)->mi_sem);
+	return ret;
+}
+
+/**
  * nilfs_sufile_read - read or get sufile inode
  * @sb: super block instance
  * @susize: size of a segment usage entry
diff -puN fs/nilfs2/sufile.h~nilfs2-add-nilfs_sufile_set_suinfo-to-update-segment-usage fs/nilfs2/sufile.h
--- a/fs/nilfs2/sufile.h~nilfs2-add-nilfs_sufile_set_suinfo-to-update-segment-usage
+++ a/fs/nilfs2/sufile.h
@@ -44,6 +44,7 @@ int nilfs_sufile_set_segment_usage(struc
 int nilfs_sufile_get_stat(struct inode *, struct nilfs_sustat *);
 ssize_t nilfs_sufile_get_suinfo(struct inode *, __u64, void *, unsigned,
 				size_t);
+ssize_t nilfs_sufile_set_suinfo(struct inode *, void *, unsigned , size_t);
 
 int nilfs_sufile_updatev(struct inode *, __u64 *, size_t, int, size_t *,
 			 void (*dofunc)(struct inode *, __u64,
_

Patches currently in -mm which might be from andreas.rohner@gmx.net are

nilfs2-add-struct-nilfs_suinfo_update-and-flags.patch
nilfs2-add-nilfs_sufile_set_suinfo-to-update-segment-usage.patch
nilfs2-implementation-of-nilfs_ioctl_set_suinfo-ioctl.patch

