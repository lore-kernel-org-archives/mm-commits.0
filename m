From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-migrate-from-ll_rw_block-usage-to-bio.patch
 added to -mm tree
Date: Mon, 13 Apr 2020 18:37:22 -0700
Message-ID: <20200414013722.ihvbzwwKG%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403806AbgDNBh0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Apr 2020 21:37:26 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adrien+dev@schischi.me, drosen@google.com, groeck@chromium.org, hch@lst.de, mm-commits@vger.kernel.org, phillip@squashfs.org.uk, pliard@google.com


The patch titled
     Subject: squashfs: migrate from ll_rw_block usage to BIO
has been added to the -mm tree.  Its filename is
     squashfs-migrate-from-ll_rw_block-usage-to-bio.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/squashfs-migrate-from-ll_rw_block-usage-to-bio.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/squashfs-migrate-from-ll_rw_block-usage-to-bio.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Philippe Liard <pliard@google.com>
Subject: squashfs: migrate from ll_rw_block usage to BIO

ll_rw_block() function has been deprecated in favor of BIO which appears
to come with large performance improvements.

This patch decreases boot time by close to 40% when using squashfs for the
root file-system.  This is observed at least in the context of starting an
Android VM on Chrome OS using crosvm
(https://chromium.googlesource.com/chromiumos/platform/crosvm).  The patch
was tested on 4.19 as well as master.

This patch is largely based on Adrien Schildknecht's patch that was
originally sent as https://lkml.org/lkml/2017/9/22/814 though with some
significant changes and simplifications while also taking Phillip
Lougher's feedback into account, around preserving support for FILE_CACHE
in particular.

Link: http://lkml.kernel.org/r/20191106074238.186023-1-pliard@google.com
Signed-off-by: Philippe Liard <pliard@google.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Adrien Schildknecht <adrien+dev@schischi.me>
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Daniel Rosenberg <drosen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/block.c               |  273 ++++++++++++++--------------
 fs/squashfs/decompressor.h        |    5 
 fs/squashfs/decompressor_multi.c  |    9 
 fs/squashfs/decompressor_single.c |    9 
 fs/squashfs/lz4_wrapper.c         |   17 +
 fs/squashfs/lzo_wrapper.c         |   17 +
 fs/squashfs/squashfs.h            |    4 
 fs/squashfs/xz_wrapper.c          |   51 ++---
 fs/squashfs/zlib_wrapper.c        |   63 +++---
 fs/squashfs/zstd_wrapper.c        |   62 +++---
 10 files changed, 276 insertions(+), 234 deletions(-)

--- a/fs/squashfs/block.c~squashfs-migrate-from-ll_rw_block-usage-to-bio
+++ a/fs/squashfs/block.c
@@ -13,6 +13,7 @@
  * datablocks and metadata blocks.
  */
 
+#include <linux/blkdev.h>
 #include <linux/fs.h>
 #include <linux/vfs.h>
 #include <linux/slab.h>
@@ -27,45 +28,104 @@
 #include "page_actor.h"
 
 /*
- * Read the metadata block length, this is stored in the first two
- * bytes of the metadata block.
+ * Returns the amount of bytes copied to the page actor.
  */
-static struct buffer_head *get_block_length(struct super_block *sb,
-			u64 *cur_index, int *offset, int *length)
+static int copy_bio_to_actor(struct bio *bio,
+			     struct squashfs_page_actor *actor,
+			     int offset, int req_length)
+{
+	void *actor_addr = squashfs_first_page(actor);
+	struct bvec_iter_all iter_all = {};
+	struct bio_vec *bvec = bvec_init_iter_all(&iter_all);
+	int copied_bytes = 0;
+	int actor_offset = 0;
+
+	if (WARN_ON_ONCE(!bio_next_segment(bio, &iter_all)))
+		return 0;
+
+	while (copied_bytes < req_length) {
+		int bytes_to_copy = min_t(int, bvec->bv_len - offset,
+					  PAGE_SIZE - actor_offset);
+
+		bytes_to_copy = min_t(int, bytes_to_copy,
+				      req_length - copied_bytes);
+		memcpy(actor_addr + actor_offset,
+		       page_address(bvec->bv_page) + bvec->bv_offset + offset,
+		       bytes_to_copy);
+
+		actor_offset += bytes_to_copy;
+		copied_bytes += bytes_to_copy;
+		offset += bytes_to_copy;
+
+		if (actor_offset >= PAGE_SIZE) {
+			actor_addr = squashfs_next_page(actor);
+			if (!actor_addr)
+				break;
+			actor_offset = 0;
+		}
+		if (offset >= bvec->bv_len) {
+			if (!bio_next_segment(bio, &iter_all))
+				break;
+			offset = 0;
+		}
+	}
+	squashfs_finish_page(actor);
+	return copied_bytes;
+}
+
+static int squashfs_bio_read(struct super_block *sb, u64 index, int length,
+			     struct bio **biop, int *block_offset)
 {
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
-	struct buffer_head *bh;
+	const u64 read_start = round_down(index, msblk->devblksize);
+	const sector_t block = read_start >> msblk->devblksize_log2;
+	const u64 read_end = round_up(index + length, msblk->devblksize);
+	const sector_t block_end = read_end >> msblk->devblksize_log2;
+	int offset = read_start - round_down(index, PAGE_SIZE);
+	int total_len = (block_end - block) << msblk->devblksize_log2;
+	const int page_count = DIV_ROUND_UP(total_len + offset, PAGE_SIZE);
+	int error, i;
+	struct bio *bio;
 
-	bh = sb_bread(sb, *cur_index);
-	if (bh == NULL)
-		return NULL;
-
-	if (msblk->devblksize - *offset == 1) {
-		*length = (unsigned char) bh->b_data[*offset];
-		put_bh(bh);
-		bh = sb_bread(sb, ++(*cur_index));
-		if (bh == NULL)
-			return NULL;
-		*length |= (unsigned char) bh->b_data[0] << 8;
-		*offset = 1;
-	} else {
-		*length = (unsigned char) bh->b_data[*offset] |
-			(unsigned char) bh->b_data[*offset + 1] << 8;
-		*offset += 2;
-
-		if (*offset == msblk->devblksize) {
-			put_bh(bh);
-			bh = sb_bread(sb, ++(*cur_index));
-			if (bh == NULL)
-				return NULL;
-			*offset = 0;
+	bio = bio_alloc(GFP_NOIO, page_count);
+	if (!bio)
+		return -ENOMEM;
+
+	bio_set_dev(bio, sb->s_bdev);
+	bio->bi_opf = READ;
+	bio->bi_iter.bi_sector = block * (msblk->devblksize >> SECTOR_SHIFT);
+
+	for (i = 0; i < page_count; ++i) {
+		unsigned int len =
+			min_t(unsigned int, PAGE_SIZE - offset, total_len);
+		struct page *page = alloc_page(GFP_NOIO);
+
+		if (!page) {
+			error = -ENOMEM;
+			goto out_free_bio;
 		}
+		if (!bio_add_page(bio, page, len, offset)) {
+			error = -EIO;
+			goto out_free_bio;
+		}
+		offset = 0;
+		total_len -= len;
 	}
 
-	return bh;
+	error = submit_bio_wait(bio);
+	if (error)
+		goto out_free_bio;
+
+	*biop = bio;
+	*block_offset = index & ((1 << msblk->devblksize_log2) - 1);
+	return 0;
+
+out_free_bio:
+	bio_free_pages(bio);
+	bio_put(bio);
+	return error;
 }
 
-
 /*
  * Read and decompress a metadata block or datablock.  Length is non-zero
  * if a datablock is being read (the size is stored elsewhere in the
@@ -76,129 +136,88 @@ static struct buffer_head *get_block_len
  * algorithms).
  */
 int squashfs_read_data(struct super_block *sb, u64 index, int length,
-		u64 *next_index, struct squashfs_page_actor *output)
+		       u64 *next_index, struct squashfs_page_actor *output)
 {
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
-	struct buffer_head **bh;
-	int offset = index & ((1 << msblk->devblksize_log2) - 1);
-	u64 cur_index = index >> msblk->devblksize_log2;
-	int bytes, compressed, b = 0, k = 0, avail, i;
-
-	bh = kcalloc(((output->length + msblk->devblksize - 1)
-		>> msblk->devblksize_log2) + 1, sizeof(*bh), GFP_KERNEL);
-	if (bh == NULL)
-		return -ENOMEM;
+	struct bio *bio = NULL;
+	int compressed;
+	int res;
+	int offset;
 
 	if (length) {
 		/*
 		 * Datablock.
 		 */
-		bytes = -offset;
 		compressed = SQUASHFS_COMPRESSED_BLOCK(length);
 		length = SQUASHFS_COMPRESSED_SIZE_BLOCK(length);
-		if (next_index)
-			*next_index = index + length;
-
 		TRACE("Block @ 0x%llx, %scompressed size %d, src size %d\n",
 			index, compressed ? "" : "un", length, output->length);
-
-		if (length < 0 || length > output->length ||
-				(index + length) > msblk->bytes_used)
-			goto read_failure;
-
-		for (b = 0; bytes < length; b++, cur_index++) {
-			bh[b] = sb_getblk(sb, cur_index);
-			if (bh[b] == NULL)
-				goto block_release;
-			bytes += msblk->devblksize;
-		}
-		ll_rw_block(REQ_OP_READ, 0, b, bh);
 	} else {
 		/*
 		 * Metadata block.
 		 */
-		if ((index + 2) > msblk->bytes_used)
-			goto read_failure;
-
-		bh[0] = get_block_length(sb, &cur_index, &offset, &length);
-		if (bh[0] == NULL)
-			goto read_failure;
-		b = 1;
+		const u8 *data;
+		struct bvec_iter_all iter_all = {};
+		struct bio_vec *bvec = bvec_init_iter_all(&iter_all);
+
+		if (index + 2 > msblk->bytes_used) {
+			res = -EIO;
+			goto out;
+		}
+		res = squashfs_bio_read(sb, index, 2, &bio, &offset);
+		if (res)
+			goto out;
+
+		if (WARN_ON_ONCE(!bio_next_segment(bio, &iter_all))) {
+			res = -EIO;
+			goto out_free_bio;
+		}
+		/* Extract the length of the metadata block */
+		data = page_address(bvec->bv_page) + bvec->bv_offset;
+		length = data[offset];
+		if (offset <= bvec->bv_len - 1) {
+			length |= data[offset + 1] << 8;
+		} else {
+			if (WARN_ON_ONCE(!bio_next_segment(bio, &iter_all))) {
+				res = -EIO;
+				goto out_free_bio;
+			}
+			data = page_address(bvec->bv_page) + bvec->bv_offset;
+			length |= data[0] << 8;
+		}
+		bio_free_pages(bio);
+		bio_put(bio);
 
-		bytes = msblk->devblksize - offset;
 		compressed = SQUASHFS_COMPRESSED(length);
 		length = SQUASHFS_COMPRESSED_SIZE(length);
-		if (next_index)
-			*next_index = index + length + 2;
+		index += 2;
 
 		TRACE("Block @ 0x%llx, %scompressed size %d\n", index,
-				compressed ? "" : "un", length);
-
-		if (length < 0 || length > output->length ||
-					(index + length) > msblk->bytes_used)
-			goto block_release;
-
-		for (; bytes < length; b++) {
-			bh[b] = sb_getblk(sb, ++cur_index);
-			if (bh[b] == NULL)
-				goto block_release;
-			bytes += msblk->devblksize;
-		}
-		ll_rw_block(REQ_OP_READ, 0, b - 1, bh + 1);
+		      compressed ? "" : "un", length);
 	}
+	if (next_index)
+		*next_index = index + length;
 
-	for (i = 0; i < b; i++) {
-		wait_on_buffer(bh[i]);
-		if (!buffer_uptodate(bh[i]))
-			goto block_release;
-	}
+	res = squashfs_bio_read(sb, index, length, &bio, &offset);
+	if (res)
+		goto out;
 
 	if (compressed) {
-		if (!msblk->stream)
-			goto read_failure;
-		length = squashfs_decompress(msblk, bh, b, offset, length,
-			output);
-		if (length < 0)
-			goto read_failure;
-	} else {
-		/*
-		 * Block is uncompressed.
-		 */
-		int in, pg_offset = 0;
-		void *data = squashfs_first_page(output);
-
-		for (bytes = length; k < b; k++) {
-			in = min(bytes, msblk->devblksize - offset);
-			bytes -= in;
-			while (in) {
-				if (pg_offset == PAGE_SIZE) {
-					data = squashfs_next_page(output);
-					pg_offset = 0;
-				}
-				avail = min_t(int, in, PAGE_SIZE -
-						pg_offset);
-				memcpy(data + pg_offset, bh[k]->b_data + offset,
-						avail);
-				in -= avail;
-				pg_offset += avail;
-				offset += avail;
-			}
-			offset = 0;
-			put_bh(bh[k]);
+		if (!msblk->stream) {
+			res = -EIO;
+			goto out_free_bio;
 		}
-		squashfs_finish_page(output);
+		res = squashfs_decompress(msblk, bio, offset, length, output);
+	} else {
+		res = copy_bio_to_actor(bio, output, offset, length);
 	}
 
-	kfree(bh);
-	return length;
+out_free_bio:
+	bio_free_pages(bio);
+	bio_put(bio);
+out:
+	if (res < 0)
+		ERROR("Failed to read block 0x%llx: %d\n", index, res);
 
-block_release:
-	for (; k < b; k++)
-		put_bh(bh[k]);
-
-read_failure:
-	ERROR("squashfs_read_data failed to read block 0x%llx\n",
-					(unsigned long long) index);
-	kfree(bh);
-	return -EIO;
+	return res;
 }
--- a/fs/squashfs/decompressor.h~squashfs-migrate-from-ll_rw_block-usage-to-bio
+++ a/fs/squashfs/decompressor.h
@@ -10,13 +10,14 @@
  * decompressor.h
  */
 
+#include <linux/bio.h>
+
 struct squashfs_decompressor {
 	void	*(*init)(struct squashfs_sb_info *, void *);
 	void	*(*comp_opts)(struct squashfs_sb_info *, void *, int);
 	void	(*free)(void *);
 	int	(*decompress)(struct squashfs_sb_info *, void *,
-		struct buffer_head **, int, int, int,
-		struct squashfs_page_actor *);
+		struct bio *, int, int, struct squashfs_page_actor *);
 	int	id;
 	char	*name;
 	int	supported;
--- a/fs/squashfs/decompressor_multi.c~squashfs-migrate-from-ll_rw_block-usage-to-bio
+++ a/fs/squashfs/decompressor_multi.c
@@ -6,7 +6,7 @@
 #include <linux/types.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
-#include <linux/buffer_head.h>
+#include <linux/bio.h>
 #include <linux/sched.h>
 #include <linux/wait.h>
 #include <linux/cpumask.h>
@@ -180,14 +180,15 @@ wait:
 }
 
 
-int squashfs_decompress(struct squashfs_sb_info *msblk, struct buffer_head **bh,
-	int b, int offset, int length, struct squashfs_page_actor *output)
+int squashfs_decompress(struct squashfs_sb_info *msblk, struct bio *bio,
+			int offset, int length,
+			struct squashfs_page_actor *output)
 {
 	int res;
 	struct squashfs_stream *stream = msblk->stream;
 	struct decomp_stream *decomp_stream = get_decomp_stream(msblk, stream);
 	res = msblk->decompressor->decompress(msblk, decomp_stream->stream,
-		bh, b, offset, length, output);
+		bio, offset, length, output);
 	put_decomp_stream(decomp_stream, stream);
 	if (res < 0)
 		ERROR("%s decompression failed, data probably corrupt\n",
--- a/fs/squashfs/decompressor_single.c~squashfs-migrate-from-ll_rw_block-usage-to-bio
+++ a/fs/squashfs/decompressor_single.c
@@ -7,7 +7,7 @@
 #include <linux/types.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
-#include <linux/buffer_head.h>
+#include <linux/bio.h>
 
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
@@ -59,14 +59,15 @@ void squashfs_decompressor_destroy(struc
 	}
 }
 
-int squashfs_decompress(struct squashfs_sb_info *msblk, struct buffer_head **bh,
-	int b, int offset, int length, struct squashfs_page_actor *output)
+int squashfs_decompress(struct squashfs_sb_info *msblk, struct bio *bio,
+			int offset, int length,
+			struct squashfs_page_actor *output)
 {
 	int res;
 	struct squashfs_stream *stream = msblk->stream;
 
 	mutex_lock(&stream->mutex);
-	res = msblk->decompressor->decompress(msblk, stream->stream, bh, b,
+	res = msblk->decompressor->decompress(msblk, stream->stream, bio,
 		offset, length, output);
 	mutex_unlock(&stream->mutex);
 
--- a/fs/squashfs/lz4_wrapper.c~squashfs-migrate-from-ll_rw_block-usage-to-bio
+++ a/fs/squashfs/lz4_wrapper.c
@@ -4,7 +4,7 @@
  * Phillip Lougher <phillip@squashfs.org.uk>
  */
 
-#include <linux/buffer_head.h>
+#include <linux/bio.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
@@ -89,20 +89,23 @@ static void lz4_free(void *strm)
 
 
 static int lz4_uncompress(struct squashfs_sb_info *msblk, void *strm,
-	struct buffer_head **bh, int b, int offset, int length,
+	struct bio *bio, int offset, int length,
 	struct squashfs_page_actor *output)
 {
+	struct bvec_iter_all iter_all = {};
+	struct bio_vec *bvec = bvec_init_iter_all(&iter_all);
 	struct squashfs_lz4 *stream = strm;
 	void *buff = stream->input, *data;
-	int avail, i, bytes = length, res;
+	int bytes = length, res;
 
-	for (i = 0; i < b; i++) {
-		avail = min(bytes, msblk->devblksize - offset);
-		memcpy(buff, bh[i]->b_data + offset, avail);
+	while (bio_next_segment(bio, &iter_all)) {
+		int avail = min(bytes, ((int)bvec->bv_len) - offset);
+
+		data = page_address(bvec->bv_page) + bvec->bv_offset;
+		memcpy(buff, data + offset, avail);
 		buff += avail;
 		bytes -= avail;
 		offset = 0;
-		put_bh(bh[i]);
 	}
 
 	res = LZ4_decompress_safe(stream->input, stream->output,
--- a/fs/squashfs/lzo_wrapper.c~squashfs-migrate-from-ll_rw_block-usage-to-bio
+++ a/fs/squashfs/lzo_wrapper.c
@@ -9,7 +9,7 @@
  */
 
 #include <linux/mutex.h>
-#include <linux/buffer_head.h>
+#include <linux/bio.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/lzo.h>
@@ -63,21 +63,24 @@ static void lzo_free(void *strm)
 
 
 static int lzo_uncompress(struct squashfs_sb_info *msblk, void *strm,
-	struct buffer_head **bh, int b, int offset, int length,
+	struct bio *bio, int offset, int length,
 	struct squashfs_page_actor *output)
 {
+	struct bvec_iter_all iter_all = {};
+	struct bio_vec *bvec = bvec_init_iter_all(&iter_all);
 	struct squashfs_lzo *stream = strm;
 	void *buff = stream->input, *data;
-	int avail, i, bytes = length, res;
+	int bytes = length, res;
 	size_t out_len = output->length;
 
-	for (i = 0; i < b; i++) {
-		avail = min(bytes, msblk->devblksize - offset);
-		memcpy(buff, bh[i]->b_data + offset, avail);
+	while (bio_next_segment(bio, &iter_all)) {
+		int avail = min(bytes, ((int)bvec->bv_len) - offset);
+
+		data = page_address(bvec->bv_page) + bvec->bv_offset;
+		memcpy(buff, data + offset, avail);
 		buff += avail;
 		bytes -= avail;
 		offset = 0;
-		put_bh(bh[i]);
 	}
 
 	res = lzo1x_decompress_safe(stream->input, (size_t)length,
--- a/fs/squashfs/squashfs.h~squashfs-migrate-from-ll_rw_block-usage-to-bio
+++ a/fs/squashfs/squashfs.h
@@ -40,8 +40,8 @@ extern void *squashfs_decompressor_setup
 /* decompressor_xxx.c */
 extern void *squashfs_decompressor_create(struct squashfs_sb_info *, void *);
 extern void squashfs_decompressor_destroy(struct squashfs_sb_info *);
-extern int squashfs_decompress(struct squashfs_sb_info *, struct buffer_head **,
-	int, int, int, struct squashfs_page_actor *);
+extern int squashfs_decompress(struct squashfs_sb_info *, struct bio *,
+				int, int, struct squashfs_page_actor *);
 extern int squashfs_max_decompressors(void);
 
 /* export.c */
--- a/fs/squashfs/xz_wrapper.c~squashfs-migrate-from-ll_rw_block-usage-to-bio
+++ a/fs/squashfs/xz_wrapper.c
@@ -10,7 +10,7 @@
 
 
 #include <linux/mutex.h>
-#include <linux/buffer_head.h>
+#include <linux/bio.h>
 #include <linux/slab.h>
 #include <linux/xz.h>
 #include <linux/bitops.h>
@@ -117,11 +117,12 @@ static void squashfs_xz_free(void *strm)
 
 
 static int squashfs_xz_uncompress(struct squashfs_sb_info *msblk, void *strm,
-	struct buffer_head **bh, int b, int offset, int length,
+	struct bio *bio, int offset, int length,
 	struct squashfs_page_actor *output)
 {
-	enum xz_ret xz_err;
-	int avail, total = 0, k = 0;
+	struct bvec_iter_all iter_all = {};
+	struct bio_vec *bvec = bvec_init_iter_all(&iter_all);
+	int total = 0, error = 0;
 	struct squashfs_xz *stream = strm;
 
 	xz_dec_reset(stream->state);
@@ -131,11 +132,23 @@ static int squashfs_xz_uncompress(struct
 	stream->buf.out_size = PAGE_SIZE;
 	stream->buf.out = squashfs_first_page(output);
 
-	do {
-		if (stream->buf.in_pos == stream->buf.in_size && k < b) {
-			avail = min(length, msblk->devblksize - offset);
+	for (;;) {
+		enum xz_ret xz_err;
+
+		if (stream->buf.in_pos == stream->buf.in_size) {
+			const void *data;
+			int avail;
+
+			if (!bio_next_segment(bio, &iter_all)) {
+				/* XZ_STREAM_END must be reached. */
+				error = -EIO;
+				break;
+			}
+
+			avail = min(length, ((int)bvec->bv_len) - offset);
+			data = page_address(bvec->bv_page) + bvec->bv_offset;
 			length -= avail;
-			stream->buf.in = bh[k]->b_data + offset;
+			stream->buf.in = data + offset;
 			stream->buf.in_size = avail;
 			stream->buf.in_pos = 0;
 			offset = 0;
@@ -150,23 +163,17 @@ static int squashfs_xz_uncompress(struct
 		}
 
 		xz_err = xz_dec_run(stream->state, &stream->buf);
-
-		if (stream->buf.in_pos == stream->buf.in_size && k < b)
-			put_bh(bh[k++]);
-	} while (xz_err == XZ_OK);
+		if (xz_err == XZ_STREAM_END)
+			break;
+		if (xz_err != XZ_OK) {
+			error = -EIO;
+			break;
+		}
+	}
 
 	squashfs_finish_page(output);
 
-	if (xz_err != XZ_STREAM_END || k < b)
-		goto out;
-
-	return total + stream->buf.out_pos;
-
-out:
-	for (; k < b; k++)
-		put_bh(bh[k]);
-
-	return -EIO;
+	return error ? error : total + stream->buf.out_pos;
 }
 
 const struct squashfs_decompressor squashfs_xz_comp_ops = {
--- a/fs/squashfs/zlib_wrapper.c~squashfs-migrate-from-ll_rw_block-usage-to-bio
+++ a/fs/squashfs/zlib_wrapper.c
@@ -10,7 +10,7 @@
 
 
 #include <linux/mutex.h>
-#include <linux/buffer_head.h>
+#include <linux/bio.h>
 #include <linux/slab.h>
 #include <linux/zlib.h>
 #include <linux/vmalloc.h>
@@ -50,21 +50,35 @@ static void zlib_free(void *strm)
 
 
 static int zlib_uncompress(struct squashfs_sb_info *msblk, void *strm,
-	struct buffer_head **bh, int b, int offset, int length,
+	struct bio *bio, int offset, int length,
 	struct squashfs_page_actor *output)
 {
-	int zlib_err, zlib_init = 0, k = 0;
+	struct bvec_iter_all iter_all = {};
+	struct bio_vec *bvec = bvec_init_iter_all(&iter_all);
+	int zlib_init = 0, error = 0;
 	z_stream *stream = strm;
 
 	stream->avail_out = PAGE_SIZE;
 	stream->next_out = squashfs_first_page(output);
 	stream->avail_in = 0;
 
-	do {
-		if (stream->avail_in == 0 && k < b) {
-			int avail = min(length, msblk->devblksize - offset);
+	for (;;) {
+		int zlib_err;
+
+		if (stream->avail_in == 0) {
+			const void *data;
+			int avail;
+
+			if (!bio_next_segment(bio, &iter_all)) {
+				/* Z_STREAM_END must be reached. */
+				error = -EIO;
+				break;
+			}
+
+			avail = min(length, ((int)bvec->bv_len) - offset);
+			data = page_address(bvec->bv_page) + bvec->bv_offset;
 			length -= avail;
-			stream->next_in = bh[k]->b_data + offset;
+			stream->next_in = data + offset;
 			stream->avail_in = avail;
 			offset = 0;
 		}
@@ -78,37 +92,28 @@ static int zlib_uncompress(struct squash
 		if (!zlib_init) {
 			zlib_err = zlib_inflateInit(stream);
 			if (zlib_err != Z_OK) {
-				squashfs_finish_page(output);
-				goto out;
+				error = -EIO;
+				break;
 			}
 			zlib_init = 1;
 		}
 
 		zlib_err = zlib_inflate(stream, Z_SYNC_FLUSH);
-
-		if (stream->avail_in == 0 && k < b)
-			put_bh(bh[k++]);
-	} while (zlib_err == Z_OK);
+		if (zlib_err == Z_STREAM_END)
+			break;
+		if (zlib_err != Z_OK) {
+			error = -EIO;
+			break;
+		}
+	}
 
 	squashfs_finish_page(output);
 
-	if (zlib_err != Z_STREAM_END)
-		goto out;
-
-	zlib_err = zlib_inflateEnd(stream);
-	if (zlib_err != Z_OK)
-		goto out;
-
-	if (k < b)
-		goto out;
-
-	return stream->total_out;
-
-out:
-	for (; k < b; k++)
-		put_bh(bh[k]);
+	if (!error)
+		if (zlib_inflateEnd(stream) != Z_OK)
+			error = -EIO;
 
-	return -EIO;
+	return error ? error : stream->total_out;
 }
 
 const struct squashfs_decompressor squashfs_zlib_comp_ops = {
--- a/fs/squashfs/zstd_wrapper.c~squashfs-migrate-from-ll_rw_block-usage-to-bio
+++ a/fs/squashfs/zstd_wrapper.c
@@ -9,7 +9,7 @@
  */
 
 #include <linux/mutex.h>
-#include <linux/buffer_head.h>
+#include <linux/bio.h>
 #include <linux/slab.h>
 #include <linux/zstd.h>
 #include <linux/vmalloc.h>
@@ -59,33 +59,44 @@ static void zstd_free(void *strm)
 
 
 static int zstd_uncompress(struct squashfs_sb_info *msblk, void *strm,
-	struct buffer_head **bh, int b, int offset, int length,
+	struct bio *bio, int offset, int length,
 	struct squashfs_page_actor *output)
 {
 	struct workspace *wksp = strm;
 	ZSTD_DStream *stream;
 	size_t total_out = 0;
-	size_t zstd_err;
-	int k = 0;
+	int error = 0;
 	ZSTD_inBuffer in_buf = { NULL, 0, 0 };
 	ZSTD_outBuffer out_buf = { NULL, 0, 0 };
+	struct bvec_iter_all iter_all = {};
+	struct bio_vec *bvec = bvec_init_iter_all(&iter_all);
 
 	stream = ZSTD_initDStream(wksp->window_size, wksp->mem, wksp->mem_size);
 
 	if (!stream) {
 		ERROR("Failed to initialize zstd decompressor\n");
-		goto out;
+		return -EIO;
 	}
 
 	out_buf.size = PAGE_SIZE;
 	out_buf.dst = squashfs_first_page(output);
 
-	do {
-		if (in_buf.pos == in_buf.size && k < b) {
-			int avail = min(length, msblk->devblksize - offset);
+	for (;;) {
+		size_t zstd_err;
 
+		if (in_buf.pos == in_buf.size) {
+			const void *data;
+			int avail;
+
+			if (!bio_next_segment(bio, &iter_all)) {
+				error = -EIO;
+				break;
+			}
+
+			avail = min(length, ((int)bvec->bv_len) - offset);
+			data = page_address(bvec->bv_page) + bvec->bv_offset;
 			length -= avail;
-			in_buf.src = bh[k]->b_data + offset;
+			in_buf.src = data + offset;
 			in_buf.size = avail;
 			in_buf.pos = 0;
 			offset = 0;
@@ -97,8 +108,8 @@ static int zstd_uncompress(struct squash
 				/* Shouldn't run out of pages
 				 * before stream is done.
 				 */
-				squashfs_finish_page(output);
-				goto out;
+				error = -EIO;
+				break;
 			}
 			out_buf.pos = 0;
 			out_buf.size = PAGE_SIZE;
@@ -107,29 +118,20 @@ static int zstd_uncompress(struct squash
 		total_out -= out_buf.pos;
 		zstd_err = ZSTD_decompressStream(stream, &out_buf, &in_buf);
 		total_out += out_buf.pos; /* add the additional data produced */
+		if (zstd_err == 0)
+			break;
 
-		if (in_buf.pos == in_buf.size && k < b)
-			put_bh(bh[k++]);
-	} while (zstd_err != 0 && !ZSTD_isError(zstd_err));
-
-	squashfs_finish_page(output);
-
-	if (ZSTD_isError(zstd_err)) {
-		ERROR("zstd decompression error: %d\n",
-				(int)ZSTD_getErrorCode(zstd_err));
-		goto out;
+		if (ZSTD_isError(zstd_err)) {
+			ERROR("zstd decompression error: %d\n",
+					(int)ZSTD_getErrorCode(zstd_err));
+			error = -EIO;
+			break;
+		}
 	}
 
-	if (k < b)
-		goto out;
-
-	return (int)total_out;
