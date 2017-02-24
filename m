From: akpm@linux-foundation.org
Subject: [patch 117/124] fs/pstore: fs/squashfs: change usage of LZ4 to
 work with new LZ4 version
Date: Fri, 24 Feb 2017 15:01:22 -0800
Message-ID: <58b0bb42.1/OLreXAR2+ObYMp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39268 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751902AbdBXXBe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 18:01:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, 4sschmid@informatik.uni-hamburg.de, anton@enomsg.org, bongkyu.kim@lge.com, ccross@android.com, davem@davemloft.net, gregkh@linuxfoundation.org, herbert@gondor.apana.org.au, keescook@chromium.org, rsalvaterra@gmail.com, sergey.senozhatsky@gmail.com, tony.luck@intel.com

From: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Subject: fs/pstore: fs/squashfs: change usage of LZ4 to work with new LZ4 version

Update fs/pstore and fs/squashfs to use the updated functions from the new
LZ4 module.

Link: http://lkml.kernel.org/r/1486321748-19085-5-git-send-email-4sschmid@informatik.uni-hamburg.de
Signed-off-by: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Cc: Bongkyu Kim <bongkyu.kim@lge.com>
Cc: Rui Salvaterra <rsalvaterra@gmail.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller <davem@davemloft.net>
Cc: Anton Vorontsov <anton@enomsg.org>
Cc: Colin Cross <ccross@android.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pstore/platform.c      |   22 +++++++++++++---------
 fs/squashfs/lz4_wrapper.c |   12 ++++++------
 2 files changed, 19 insertions(+), 15 deletions(-)

diff -puN fs/pstore/platform.c~fs-pstore-fs-squashfs-change-usage-of-lz4-to-work-with-new-lz4-version fs/pstore/platform.c
--- a/fs/pstore/platform.c~fs-pstore-fs-squashfs-change-usage-of-lz4-to-work-with-new-lz4-version
+++ a/fs/pstore/platform.c
@@ -342,31 +342,35 @@ static int compress_lz4(const void *in,
 {
 	int ret;
 
-	ret = lz4_compress(in, inlen, out, &outlen, workspace);
-	if (ret) {
-		pr_err("lz4_compress error, ret = %d!\n", ret);
+	ret = LZ4_compress_default(in, out, inlen, outlen, workspace);
+	if (!ret) {
+		pr_err("LZ4_compress_default error; compression failed!\n");
 		return -EIO;
 	}
 
-	return outlen;
+	return ret;
 }
 
 static int decompress_lz4(void *in, void *out, size_t inlen, size_t outlen)
 {
 	int ret;
 
-	ret = lz4_decompress_unknownoutputsize(in, inlen, out, &outlen);
-	if (ret) {
-		pr_err("lz4_decompress error, ret = %d!\n", ret);
+	ret = LZ4_decompress_safe(in, out, inlen, outlen);
+	if (ret < 0) {
+		/*
+		 * LZ4_decompress_safe will return an error code
+		 * (< 0) if decompression failed
+		 */
+		pr_err("LZ4_decompress_safe error, ret = %d!\n", ret);
 		return -EIO;
 	}
 
-	return outlen;
+	return ret;
 }
 
 static void allocate_lz4(void)
 {
-	big_oops_buf_sz = lz4_compressbound(psinfo->bufsize);
+	big_oops_buf_sz = LZ4_compressBound(psinfo->bufsize);
 	big_oops_buf = kmalloc(big_oops_buf_sz, GFP_KERNEL);
 	if (big_oops_buf) {
 		workspace = kmalloc(LZ4_MEM_COMPRESS, GFP_KERNEL);
diff -puN fs/squashfs/lz4_wrapper.c~fs-pstore-fs-squashfs-change-usage-of-lz4-to-work-with-new-lz4-version fs/squashfs/lz4_wrapper.c
--- a/fs/squashfs/lz4_wrapper.c~fs-pstore-fs-squashfs-change-usage-of-lz4-to-work-with-new-lz4-version
+++ a/fs/squashfs/lz4_wrapper.c
@@ -97,7 +97,6 @@ static int lz4_uncompress(struct squashf
 	struct squashfs_lz4 *stream = strm;
 	void *buff = stream->input, *data;
 	int avail, i, bytes = length, res;
-	size_t dest_len = output->length;
 
 	for (i = 0; i < b; i++) {
 		avail = min(bytes, msblk->devblksize - offset);
@@ -108,12 +107,13 @@ static int lz4_uncompress(struct squashf
 		put_bh(bh[i]);
 	}
 
-	res = lz4_decompress_unknownoutputsize(stream->input, length,
-					stream->output, &dest_len);
-	if (res)
+	res = LZ4_decompress_safe(stream->input, stream->output,
+		length, output->length);
+
+	if (res < 0)
 		return -EIO;
 
-	bytes = dest_len;
+	bytes = res;
 	data = squashfs_first_page(output);
 	buff = stream->output;
 	while (data) {
@@ -128,7 +128,7 @@ static int lz4_uncompress(struct squashf
 	}
 	squashfs_finish_page(output);
 
-	return dest_len;
+	return res;
 }
 
 const struct squashfs_decompressor squashfs_lz4_comp_ops = {
_
