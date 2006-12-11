From: akpm@osdl.org
Subject: + constify-pipe_buf_operations.patch added to -mm tree
Date: Mon, 11 Dec 2006 12:27:04 -0800
Message-ID: <200612112027.kBBKR4nG006298@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:33761 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763077AbWLKU1p (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Dec 2006 15:27:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dada1@cosmosbay.com, jens.axboe@oracle.com


The patch titled
     constify pipe_buf_operations
has been added to the -mm tree.  Its filename is
     constify-pipe_buf_operations.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: constify pipe_buf_operations
From: Eric Dumazet <dada1@cosmosbay.com>

- pipe/splice should use const pipe_buf_operations and file_operations

- struct pipe_inode_info has an unused field "start" : get rid of it.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/pipe.c                 |   12 ++++++------
 fs/splice.c               |    8 ++++----
 include/linux/pipe_fs_i.h |    3 +--
 3 files changed, 11 insertions(+), 12 deletions(-)

diff -puN fs/pipe.c~constify-pipe_buf_operations fs/pipe.c
--- a/fs/pipe.c~constify-pipe_buf_operations
+++ a/fs/pipe.c
@@ -207,7 +207,7 @@ int generic_pipe_buf_pin(struct pipe_ino
 	return 0;
 }
 
-static struct pipe_buf_operations anon_pipe_buf_ops = {
+static const struct pipe_buf_operations anon_pipe_buf_ops = {
 	.can_merge = 1,
 	.map = generic_pipe_buf_map,
 	.unmap = generic_pipe_buf_unmap,
@@ -243,7 +243,7 @@ pipe_read(struct kiocb *iocb, const stru
 		if (bufs) {
 			int curbuf = pipe->curbuf;
 			struct pipe_buffer *buf = pipe->bufs + curbuf;
-			struct pipe_buf_operations *ops = buf->ops;
+			const struct pipe_buf_operations *ops = buf->ops;
 			void *addr;
 			size_t chars = buf->len;
 			int error, atomic;
@@ -365,7 +365,7 @@ pipe_write(struct kiocb *iocb, const str
 		int lastbuf = (pipe->curbuf + pipe->nrbufs - 1) &
 							(PIPE_BUFFERS-1);
 		struct pipe_buffer *buf = pipe->bufs + lastbuf;
-		struct pipe_buf_operations *ops = buf->ops;
+		const struct pipe_buf_operations *ops = buf->ops;
 		int offset = buf->offset + buf->len;
 
 		if (ops->can_merge && offset + chars <= PAGE_SIZE) {
@@ -756,7 +756,7 @@ const struct file_operations rdwr_fifo_f
 	.fasync		= pipe_rdwr_fasync,
 };
 
-static struct file_operations read_pipe_fops = {
+static const struct file_operations read_pipe_fops = {
 	.llseek		= no_llseek,
 	.read		= do_sync_read,
 	.aio_read	= pipe_read,
@@ -768,7 +768,7 @@ static struct file_operations read_pipe_
 	.fasync		= pipe_read_fasync,
 };
 
-static struct file_operations write_pipe_fops = {
+static const struct file_operations write_pipe_fops = {
 	.llseek		= no_llseek,
 	.read		= bad_pipe_r,
 	.write		= do_sync_write,
@@ -780,7 +780,7 @@ static struct file_operations write_pipe
 	.fasync		= pipe_write_fasync,
 };
 
-static struct file_operations rdwr_pipe_fops = {
+static const struct file_operations rdwr_pipe_fops = {
 	.llseek		= no_llseek,
 	.read		= do_sync_read,
 	.aio_read	= pipe_read,
diff -puN fs/splice.c~constify-pipe_buf_operations fs/splice.c
--- a/fs/splice.c~constify-pipe_buf_operations
+++ a/fs/splice.c
@@ -42,7 +42,7 @@ struct splice_pipe_desc {
 	struct partial_page *partial;	/* pages[] may not be contig */
 	int nr_pages;			/* number of pages in map */
 	unsigned int flags;		/* splice flags */
-	struct pipe_buf_operations *ops;/* ops associated with output pipe */
+	const struct pipe_buf_operations *ops;/* ops associated with output pipe */
 };
 
 /*
@@ -139,7 +139,7 @@ error:
 	return err;
 }
 
-static struct pipe_buf_operations page_cache_pipe_buf_ops = {
+static const struct pipe_buf_operations page_cache_pipe_buf_ops = {
 	.can_merge = 0,
 	.map = generic_pipe_buf_map,
 	.unmap = generic_pipe_buf_unmap,
@@ -159,7 +159,7 @@ static int user_page_pipe_buf_steal(stru
 	return generic_pipe_buf_steal(pipe, buf);
 }
 
-static struct pipe_buf_operations user_page_pipe_buf_ops = {
+static const struct pipe_buf_operations user_page_pipe_buf_ops = {
 	.can_merge = 0,
 	.map = generic_pipe_buf_map,
 	.unmap = generic_pipe_buf_unmap,
@@ -724,7 +724,7 @@ static ssize_t __splice_from_pipe(struct
 	for (;;) {
 		if (pipe->nrbufs) {
 			struct pipe_buffer *buf = pipe->bufs + pipe->curbuf;
-			struct pipe_buf_operations *ops = buf->ops;
+			const struct pipe_buf_operations *ops = buf->ops;
 
 			sd.len = buf->len;
 			if (sd.len > sd.total_len)
diff -puN include/linux/pipe_fs_i.h~constify-pipe_buf_operations include/linux/pipe_fs_i.h
--- a/include/linux/pipe_fs_i.h~constify-pipe_buf_operations
+++ a/include/linux/pipe_fs_i.h
@@ -12,7 +12,7 @@
 struct pipe_buffer {
 	struct page *page;
 	unsigned int offset, len;
-	struct pipe_buf_operations *ops;
+	const struct pipe_buf_operations *ops;
 	unsigned int flags;
 };
 
@@ -43,7 +43,6 @@ struct pipe_inode_info {
 	unsigned int nrbufs, curbuf;
 	struct pipe_buffer bufs[PIPE_BUFFERS];
 	struct page *tmp_page;
-	unsigned int start;
 	unsigned int readers;
 	unsigned int writers;
 	unsigned int waiting_writers;
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

origin.patch
constify-pipe_buf_operations.patch
convert-i386-pda-code-to-use-%fs.patch
convert-i386-pda-code-to-use-%fs-fixes.patch
get-rid-of-arch_have_xtime_lock.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index-tweaks.patch
optimize-calc_load.patch

