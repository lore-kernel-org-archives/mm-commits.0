From: akpm@linux-foundation.org
Subject: [merged] nilfs2-segment-buffer.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:08:52 -0700
Message-ID: <200904071908.n37J8qik012006@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45251 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760286AbZDGTKk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:10:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     nilfs2: segment buffer
has been removed from the -mm tree.  Its filename was
     nilfs2-segment-buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nilfs2: segment buffer
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

This adds the segment buffer which is used to constuct logs.

[akpm@linux-foundation.org: BIO_RW_SYNC got removed]
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segbuf.c |  461 +++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/segbuf.h |  203 ++++++++++++++++++
 2 files changed, 664 insertions(+)

diff -puN /dev/null fs/nilfs2/segbuf.c
--- /dev/null
+++ a/fs/nilfs2/segbuf.c
@@ -0,0 +1,461 @@
+/*
+ * segbuf.c - NILFS segment buffer
+ *
+ * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Ryusuke Konishi <ryusuke@osrg.net>
+ *
+ */
+
+#include <linux/buffer_head.h>
+#include <linux/writeback.h>
+#include <linux/crc32.h>
+#include "page.h"
+#include "segbuf.h"
+#include "seglist.h"
+
+
+static struct kmem_cache *nilfs_segbuf_cachep;
+
+static void nilfs_segbuf_init_once(void *obj)
+{
+	memset(obj, 0, sizeof(struct nilfs_segment_buffer));
+}
+
+int __init nilfs_init_segbuf_cache(void)
+{
+	nilfs_segbuf_cachep =
+		kmem_cache_create("nilfs2_segbuf_cache",
+				  sizeof(struct nilfs_segment_buffer),
+				  0, SLAB_RECLAIM_ACCOUNT,
+				  nilfs_segbuf_init_once);
+
+	return (nilfs_segbuf_cachep == NULL) ? -ENOMEM : 0;
+}
+
+void nilfs_destroy_segbuf_cache(void)
+{
+	kmem_cache_destroy(nilfs_segbuf_cachep);
+}
+
+struct nilfs_segment_buffer *nilfs_segbuf_new(struct super_block *sb)
+{
+	struct nilfs_segment_buffer *segbuf;
+
+	segbuf = kmem_cache_alloc(nilfs_segbuf_cachep, GFP_NOFS);
+	if (unlikely(!segbuf))
+		return NULL;
+
+	segbuf->sb_super = sb;
+	INIT_LIST_HEAD(&segbuf->sb_list);
+	INIT_LIST_HEAD(&segbuf->sb_segsum_buffers);
+	INIT_LIST_HEAD(&segbuf->sb_payload_buffers);
+	segbuf->sb_segent = NULL;
+	return segbuf;
+}
+
+void nilfs_segbuf_free(struct nilfs_segment_buffer *segbuf)
+{
+	struct nilfs_segment_entry *ent = segbuf->sb_segent;
+
+	if (ent != NULL && list_empty(&ent->list)) {
+		/* free isolated segment list head */
+		nilfs_free_segment_entry(segbuf->sb_segent);
+		segbuf->sb_segent = NULL;
+	}
+	kmem_cache_free(nilfs_segbuf_cachep, segbuf);
+}
+
+int nilfs_segbuf_map(struct nilfs_segment_buffer *segbuf, __u64 segnum,
+		     unsigned long offset, struct the_nilfs *nilfs)
+{
+	struct nilfs_segment_entry *ent;
+
+	segbuf->sb_segnum = segnum;
+	nilfs_get_segment_range(nilfs, segnum, &segbuf->sb_fseg_start,
+				&segbuf->sb_fseg_end);
+
+	segbuf->sb_pseg_start = segbuf->sb_fseg_start + offset;
+	segbuf->sb_rest_blocks =
+		segbuf->sb_fseg_end - segbuf->sb_pseg_start + 1;
+
+	/* Attach a segment list head */
+	ent = segbuf->sb_segent;
+	if (ent == NULL) {
+		segbuf->sb_segent = nilfs_alloc_segment_entry(segnum);
+		if (unlikely(!segbuf->sb_segent))
+			return -ENOMEM;
+	} else {
+		BUG_ON(ent->bh_su || !list_empty(&ent->list));
+		ent->segnum = segnum;
+	}
+	return 0;
+}
+
+void nilfs_segbuf_set_next_segnum(struct nilfs_segment_buffer *segbuf,
+				  __u64 nextnum, struct the_nilfs *nilfs)
+{
+	segbuf->sb_nextnum = nextnum;
+	segbuf->sb_sum.next = nilfs_get_segment_start_blocknr(nilfs, nextnum);
+}
+
+int nilfs_segbuf_extend_segsum(struct nilfs_segment_buffer *segbuf)
+{
+	struct buffer_head *bh;
+
+	bh = sb_getblk(segbuf->sb_super,
+		       segbuf->sb_pseg_start + segbuf->sb_sum.nsumblk);
+	if (unlikely(!bh))
+		return -ENOMEM;
+
+	nilfs_segbuf_add_segsum_buffer(segbuf, bh);
+	return 0;
+}
+
+int nilfs_segbuf_extend_payload(struct nilfs_segment_buffer *segbuf,
+				struct buffer_head **bhp)
+{
+	struct buffer_head *bh;
+
+	bh = sb_getblk(segbuf->sb_super,
+		       segbuf->sb_pseg_start + segbuf->sb_sum.nblocks);
+	if (unlikely(!bh))
+		return -ENOMEM;
+
+	nilfs_segbuf_add_payload_buffer(segbuf, bh);
+	*bhp = bh;
+	return 0;
+}
+
+int nilfs_segbuf_reset(struct nilfs_segment_buffer *segbuf, unsigned flags,
+		       time_t ctime)
+{
+	int err;
+
+	segbuf->sb_sum.nblocks = segbuf->sb_sum.nsumblk = 0;
+	err = nilfs_segbuf_extend_segsum(segbuf);
+	if (unlikely(err))
+		return err;
+
+	segbuf->sb_sum.flags = flags;
+	segbuf->sb_sum.sumbytes = sizeof(struct nilfs_segment_summary);
+	segbuf->sb_sum.nfinfo = segbuf->sb_sum.nfileblk = 0;
+	segbuf->sb_sum.ctime = ctime;
+
+	segbuf->sb_io_error = 0;
+	return 0;
+}
+
+/*
+ * Setup segument summary
+ */
+void nilfs_segbuf_fill_in_segsum(struct nilfs_segment_buffer *segbuf)
+{
+	struct nilfs_segment_summary *raw_sum;
+	struct buffer_head *bh_sum;
+
+	bh_sum = list_entry(segbuf->sb_segsum_buffers.next,
+			    struct buffer_head, b_assoc_buffers);
+	raw_sum = (struct nilfs_segment_summary *)bh_sum->b_data;
+
+	raw_sum->ss_magic    = cpu_to_le32(NILFS_SEGSUM_MAGIC);
+	raw_sum->ss_bytes    = cpu_to_le16(sizeof(*raw_sum));
+	raw_sum->ss_flags    = cpu_to_le16(segbuf->sb_sum.flags);
+	raw_sum->ss_seq      = cpu_to_le64(segbuf->sb_sum.seg_seq);
+	raw_sum->ss_create   = cpu_to_le64(segbuf->sb_sum.ctime);
+	raw_sum->ss_next     = cpu_to_le64(segbuf->sb_sum.next);
+	raw_sum->ss_nblocks  = cpu_to_le32(segbuf->sb_sum.nblocks);
+	raw_sum->ss_nfinfo   = cpu_to_le32(segbuf->sb_sum.nfinfo);
+	raw_sum->ss_sumbytes = cpu_to_le32(segbuf->sb_sum.sumbytes);
+	raw_sum->ss_pad      = 0;
+}
+
+/*
+ * CRC calculation routines
+ */
+void nilfs_segbuf_fill_in_segsum_crc(struct nilfs_segment_buffer *segbuf,
+				     u32 seed)
+{
+	struct buffer_head *bh;
+	struct nilfs_segment_summary *raw_sum;
+	unsigned long size, bytes = segbuf->sb_sum.sumbytes;
+	u32 crc;
+
+	bh = list_entry(segbuf->sb_segsum_buffers.next, struct buffer_head,
+			b_assoc_buffers);
+
+	raw_sum = (struct nilfs_segment_summary *)bh->b_data;
+	size = min_t(unsigned long, bytes, bh->b_size);
+	crc = crc32_le(seed,
+		       (unsigned char *)raw_sum +
+		       sizeof(raw_sum->ss_datasum) + sizeof(raw_sum->ss_sumsum),
+		       size - (sizeof(raw_sum->ss_datasum) +
+			       sizeof(raw_sum->ss_sumsum)));
+
+	list_for_each_entry_continue(bh, &segbuf->sb_segsum_buffers,
+				     b_assoc_buffers) {
+		bytes -= size;
+		size = min_t(unsigned long, bytes, bh->b_size);
+		crc = crc32_le(crc, bh->b_data, size);
+	}
+	raw_sum->ss_sumsum = cpu_to_le32(crc);
+}
+
+void nilfs_segbuf_fill_in_data_crc(struct nilfs_segment_buffer *segbuf,
+				   u32 seed)
+{
+	struct buffer_head *bh;
+	struct nilfs_segment_summary *raw_sum;
+	void *kaddr;
+	u32 crc;
+
+	bh = list_entry(segbuf->sb_segsum_buffers.next, struct buffer_head,
+			b_assoc_buffers);
+	raw_sum = (struct nilfs_segment_summary *)bh->b_data;
+	crc = crc32_le(seed,
+		       (unsigned char *)raw_sum + sizeof(raw_sum->ss_datasum),
+		       bh->b_size - sizeof(raw_sum->ss_datasum));
+
+	list_for_each_entry_continue(bh, &segbuf->sb_segsum_buffers,
+				     b_assoc_buffers) {
+		crc = crc32_le(crc, bh->b_data, bh->b_size);
+	}
+	list_for_each_entry(bh, &segbuf->sb_payload_buffers, b_assoc_buffers) {
+		kaddr = kmap_atomic(bh->b_page, KM_USER0);
+		crc = crc32_le(crc, kaddr + bh_offset(bh), bh->b_size);
+		kunmap_atomic(kaddr, KM_USER0);
+	}
+	raw_sum->ss_datasum = cpu_to_le32(crc);
+}
+
+void nilfs_release_buffers(struct list_head *list)
+{
+	struct buffer_head *bh, *n;
+
+	list_for_each_entry_safe(bh, n, list, b_assoc_buffers) {
+		list_del_init(&bh->b_assoc_buffers);
+		if (buffer_nilfs_allocated(bh)) {
+			struct page *clone_page = bh->b_page;
+
+			/* remove clone page */
+			brelse(bh);
+			page_cache_release(clone_page); /* for each bh */
+			if (page_count(clone_page) <= 2) {
+				lock_page(clone_page);
+				nilfs_free_private_page(clone_page);
+			}
+			continue;
+		}
+		brelse(bh);
+	}
+}
+
+/*
+ * BIO operations
+ */
+static void nilfs_end_bio_write(struct bio *bio, int err)
+{
+	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
+	struct nilfs_write_info *wi = bio->bi_private;
+
+	if (err == -EOPNOTSUPP) {
+		set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);
+		bio_put(bio);
+		/* to be detected by submit_seg_bio() */
+	}
+
+	if (!uptodate)
+		atomic_inc(&wi->err);
+
+	bio_put(bio);
+	complete(&wi->bio_event);
+}
+
+static int nilfs_submit_seg_bio(struct nilfs_write_info *wi, int mode)
+{
+	struct bio *bio = wi->bio;
+	int err;
+
+	if (wi->nbio > 0 && bdi_write_congested(wi->bdi)) {
+		wait_for_completion(&wi->bio_event);
+		wi->nbio--;
+		if (unlikely(atomic_read(&wi->err))) {
+			bio_put(bio);
+			err = -EIO;
+			goto failed;
+		}
+	}
+
+	bio->bi_end_io = nilfs_end_bio_write;
+	bio->bi_private = wi;
+	bio_get(bio);
+	submit_bio(mode, bio);
+	if (bio_flagged(bio, BIO_EOPNOTSUPP)) {
+		bio_put(bio);
+		err = -EOPNOTSUPP;
+		goto failed;
+	}
+	wi->nbio++;
+	bio_put(bio);
+
+	wi->bio = NULL;
+	wi->rest_blocks -= wi->end - wi->start;
+	wi->nr_vecs = min(wi->max_pages, wi->rest_blocks);
+	wi->start = wi->end;
+	return 0;
+
+ failed:
+	wi->bio = NULL;
+	return err;
+}
+
+/**
+ * nilfs_alloc_seg_bio - allocate a bio for writing segment.
+ * @sb: super block
+ * @start: beginning disk block number of this BIO.
+ * @nr_vecs: request size of page vector.
+ *
+ * alloc_seg_bio() allocates a new BIO structure and initialize it.
+ *
+ * Return Value: On success, pointer to the struct bio is returned.
+ * On error, NULL is returned.
+ */
+static struct bio *nilfs_alloc_seg_bio(struct super_block *sb, sector_t start,
+				       int nr_vecs)
+{
+	struct bio *bio;
+
+	bio = bio_alloc(GFP_NOWAIT, nr_vecs);
+	if (bio == NULL) {
+		while (!bio && (nr_vecs >>= 1))
+			bio = bio_alloc(GFP_NOWAIT, nr_vecs);
+	}
+	if (likely(bio)) {
+		bio->bi_bdev = sb->s_bdev;
+		bio->bi_sector = (sector_t)start << (sb->s_blocksize_bits - 9);
+	}
+	return bio;
+}
+
+void nilfs_segbuf_prepare_write(struct nilfs_segment_buffer *segbuf,
+				struct nilfs_write_info *wi)
+{
+	wi->bio = NULL;
+	wi->rest_blocks = segbuf->sb_sum.nblocks;
+	wi->max_pages = bio_get_nr_vecs(wi->sb->s_bdev);
+	wi->nr_vecs = min(wi->max_pages, wi->rest_blocks);
+	wi->start = wi->end = 0;
+	wi->nbio = 0;
+	wi->blocknr = segbuf->sb_pseg_start;
+
+	atomic_set(&wi->err, 0);
+	init_completion(&wi->bio_event);
+}
+
+static int nilfs_submit_bh(struct nilfs_write_info *wi, struct buffer_head *bh,
+			   int mode)
+{
+	int len, err;
+
+	BUG_ON(wi->nr_vecs <= 0);
+ repeat:
+	if (!wi->bio) {
+		wi->bio = nilfs_alloc_seg_bio(wi->sb, wi->blocknr + wi->end,
+					      wi->nr_vecs);
+		if (unlikely(!wi->bio))
+			return -ENOMEM;
+	}
+
+	len = bio_add_page(wi->bio, bh->b_page, bh->b_size, bh_offset(bh));
+	if (len == bh->b_size) {
+		wi->end++;
+		return 0;
+	}
+	/* bio is FULL */
+	err = nilfs_submit_seg_bio(wi, mode);
+	/* never submit current bh */
+	if (likely(!err))
+		goto repeat;
+	return err;
+}
+
+int nilfs_segbuf_write(struct nilfs_segment_buffer *segbuf,
+		       struct nilfs_write_info *wi)
+{
+	struct buffer_head *bh;
+	int res, rw = WRITE;
+
+	list_for_each_entry(bh, &segbuf->sb_segsum_buffers, b_assoc_buffers) {
+		res = nilfs_submit_bh(wi, bh, rw);
+		if (unlikely(res))
+			goto failed_bio;
+	}
+
+	list_for_each_entry(bh, &segbuf->sb_payload_buffers, b_assoc_buffers) {
+		res = nilfs_submit_bh(wi, bh, rw);
+		if (unlikely(res))
+			goto failed_bio;
+	}
+
+	if (wi->bio) {
+		/*
+		 * Last BIO is always sent through the following
+		 * submission.
+		 */
+		rw |= (1 << BIO_RW_SYNCIO);
+		res = nilfs_submit_seg_bio(wi, rw);
+		if (unlikely(res))
+			goto failed_bio;
+	}
+
+	res = 0;
+ out:
+	return res;
+
+ failed_bio:
+	atomic_inc(&wi->err);
+	goto out;
+}
+
+/**
+ * nilfs_segbuf_wait - wait for completion of requested BIOs
+ * @wi: nilfs_write_info
+ *
+ * Return Value: On Success, 0 is returned. On Error, one of the following
+ * negative error code is returned.
+ *
+ * %-EIO - I/O error
+ */
+int nilfs_segbuf_wait(struct nilfs_segment_buffer *segbuf,
+		      struct nilfs_write_info *wi)
+{
+	int err = 0;
+
+	if (!wi->nbio)
+		return 0;
+
+	do {
+		wait_for_completion(&wi->bio_event);
+	} while (--wi->nbio > 0);
+
+	if (unlikely(atomic_read(&wi->err) > 0)) {
+		printk(KERN_ERR "NILFS: IO error writing segment\n");
+		err = -EIO;
+		segbuf->sb_io_error = 1;
+	}
+	return err;
+}
diff -puN /dev/null fs/nilfs2/segbuf.h
--- /dev/null
+++ a/fs/nilfs2/segbuf.h
@@ -0,0 +1,203 @@
+/*
+ * segbuf.h - NILFS Segment buffer prototypes and definitions
+ *
+ * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Ryusuke Konishi <ryusuke@osrg.net>
+ *
+ */
+#ifndef _NILFS_SEGBUF_H
+#define _NILFS_SEGBUF_H
+
+#include <linux/fs.h>
+#include <linux/buffer_head.h>
+#include <linux/bio.h>
+#include <linux/completion.h>
+#include <linux/backing-dev.h>
+
+/**
+ * struct nilfs_segsum_info - On-memory segment summary
+ * @flags: Flags
+ * @nfinfo: Number of file information structures
+ * @nblocks: Number of blocks included in the partial segment
+ * @nsumblk: Number of summary blocks
+ * @sumbytes: Byte count of segment summary
+ * @nfileblk: Total number of file blocks
+ * @seg_seq: Segment sequence number
+ * @ctime: Creation time
+ * @next: Block number of the next full segment
+ */
+struct nilfs_segsum_info {
+	unsigned int		flags;
+	unsigned long		nfinfo;
+	unsigned long		nblocks;
+	unsigned long		nsumblk;
+	unsigned long		sumbytes;
+	unsigned long		nfileblk;
+	u64			seg_seq;
+	time_t			ctime;
+	sector_t		next;
+};
+
+/* macro for the flags */
+#define NILFS_SEG_HAS_SR(sum)    ((sum)->flags & NILFS_SS_SR)
+#define NILFS_SEG_LOGBGN(sum)    ((sum)->flags & NILFS_SS_LOGBGN)
+#define NILFS_SEG_LOGEND(sum)    ((sum)->flags & NILFS_SS_LOGEND)
+#define NILFS_SEG_DSYNC(sum)     ((sum)->flags & NILFS_SS_SYNDT)
+#define NILFS_SEG_SIMPLEX(sum) \
+	(((sum)->flags & (NILFS_SS_LOGBGN | NILFS_SS_LOGEND)) == \
+	 (NILFS_SS_LOGBGN | NILFS_SS_LOGEND))
+
+#define NILFS_SEG_EMPTY(sum)	((sum)->nblocks == (sum)->nsumblk)
+
+/**
+ * struct nilfs_segment_buffer - Segment buffer
+ * @sb_super: back pointer to a superblock struct
+ * @sb_list: List head to chain this structure
+ * @sb_segent: Pointer for attaching a segment entry
+ * @sb_sum: On-memory segment summary
+ * @sb_segnum: Index number of the full segment
+ * @sb_nextnum: Index number of the next full segment
+ * @sb_fseg_start: Start block number of the full segment
+ * @sb_fseg_end: End block number of the full segment
+ * @sb_pseg_start: Disk block number of partial segment
+ * @sb_rest_blocks: Number of residual blocks in the current segment
+ * @sb_segsum_buffers: List of buffers for segment summaries
+ * @sb_payload_buffers: List of buffers for segment payload
+ * @sb_io_error: I/O error status
+ */
+struct nilfs_segment_buffer {
+	struct super_block     *sb_super;
+	struct list_head	sb_list;
+	struct nilfs_segment_entry *sb_segent;
+
+	/* Segment information */
+	struct nilfs_segsum_info sb_sum;
+	__u64			sb_segnum;
+	__u64			sb_nextnum;
+	sector_t		sb_fseg_start, sb_fseg_end;
+	sector_t		sb_pseg_start;
+	unsigned		sb_rest_blocks;
+
+	/* Buffers */
+	struct list_head	sb_segsum_buffers;
+	struct list_head	sb_payload_buffers; /* including super root */
+
+	/* io status */
+	int			sb_io_error;
+};
+
+#define NILFS_LIST_SEGBUF(head)  \
+	list_entry((head), struct nilfs_segment_buffer, sb_list)
+#define NILFS_NEXT_SEGBUF(segbuf)  NILFS_LIST_SEGBUF((segbuf)->sb_list.next)
+#define NILFS_PREV_SEGBUF(segbuf)  NILFS_LIST_SEGBUF((segbuf)->sb_list.prev)
+#define NILFS_LAST_SEGBUF(head)    NILFS_LIST_SEGBUF((head)->prev)
+#define NILFS_FIRST_SEGBUF(head)   NILFS_LIST_SEGBUF((head)->next)
+#define NILFS_SEGBUF_IS_LAST(segbuf, head)  ((segbuf)->sb_list.next == (head))
+
+#define nilfs_for_each_segbuf_before(s, t, h) \
+	for ((s) = NILFS_FIRST_SEGBUF(h); (s) != (t); \
+	     (s) = NILFS_NEXT_SEGBUF(s))
+
+#define NILFS_SEGBUF_FIRST_BH(head)  \
+	(list_entry((head)->next, struct buffer_head, b_assoc_buffers))
+#define NILFS_SEGBUF_NEXT_BH(bh)  \
+	(list_entry((bh)->b_assoc_buffers.next, struct buffer_head, \
+		    b_assoc_buffers))
+#define NILFS_SEGBUF_BH_IS_LAST(bh, head)  ((bh)->b_assoc_buffers.next == head)
+
+
+int __init nilfs_init_segbuf_cache(void);
+void nilfs_destroy_segbuf_cache(void);
+struct nilfs_segment_buffer *nilfs_segbuf_new(struct super_block *);
+void nilfs_segbuf_free(struct nilfs_segment_buffer *);
+int nilfs_segbuf_map(struct nilfs_segment_buffer *, __u64, unsigned long,
+		     struct the_nilfs *);
+void nilfs_segbuf_set_next_segnum(struct nilfs_segment_buffer *, __u64,
+				  struct the_nilfs *);
+int nilfs_segbuf_reset(struct nilfs_segment_buffer *, unsigned, time_t);
+int nilfs_segbuf_extend_segsum(struct nilfs_segment_buffer *);
+int nilfs_segbuf_extend_payload(struct nilfs_segment_buffer *,
+				struct buffer_head **);
+void nilfs_segbuf_fill_in_segsum(struct nilfs_segment_buffer *);
+void nilfs_segbuf_fill_in_segsum_crc(struct nilfs_segment_buffer *, u32);
+void nilfs_segbuf_fill_in_data_crc(struct nilfs_segment_buffer *, u32);
+
+static inline void
+nilfs_segbuf_add_segsum_buffer(struct nilfs_segment_buffer *segbuf,
+			       struct buffer_head *bh)
+{
+	list_add_tail(&bh->b_assoc_buffers, &segbuf->sb_segsum_buffers);
+	segbuf->sb_sum.nblocks++;
+	segbuf->sb_sum.nsumblk++;
+}
+
+static inline void
+nilfs_segbuf_add_payload_buffer(struct nilfs_segment_buffer *segbuf,
+				struct buffer_head *bh)
+{
+	list_add_tail(&bh->b_assoc_buffers, &segbuf->sb_payload_buffers);
+	segbuf->sb_sum.nblocks++;
+}
+
+static inline void
+nilfs_segbuf_add_file_buffer(struct nilfs_segment_buffer *segbuf,
+			     struct buffer_head *bh)
+{
+	get_bh(bh);
+	nilfs_segbuf_add_payload_buffer(segbuf, bh);
+	segbuf->sb_sum.nfileblk++;
+}
+
+void nilfs_release_buffers(struct list_head *);
+
+static inline void nilfs_segbuf_clear(struct nilfs_segment_buffer *segbuf)
+{
+	nilfs_release_buffers(&segbuf->sb_segsum_buffers);
+	nilfs_release_buffers(&segbuf->sb_payload_buffers);
+}
+
+struct nilfs_write_info {
+	struct bio	       *bio;
+	int 			start, end; /* The region to be submitted */
+	int			rest_blocks;
+	int			max_pages;
+	int			nr_vecs;
+	sector_t		blocknr;
+
+	int			nbio;
+	atomic_t		err;
+	struct completion	bio_event;
+				/* completion event of segment write */
+
+	/*
+	 * The following fields must be set explicitly
+	 */
+	struct super_block     *sb;
+	struct backing_dev_info *bdi; /* backing dev info */
+	struct buffer_head     *bh_sr;
+};
+
+
+void nilfs_segbuf_prepare_write(struct nilfs_segment_buffer *,
+				struct nilfs_write_info *);
+int nilfs_segbuf_write(struct nilfs_segment_buffer *,
+		       struct nilfs_write_info *);
+int nilfs_segbuf_wait(struct nilfs_segment_buffer *,
+		      struct nilfs_write_info *);
+
+#endif /* _NILFS_SEGBUF_H */
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

origin.patch

