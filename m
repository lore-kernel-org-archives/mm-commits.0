From: akpm@linux-foundation.org
Subject: - jens-broke-reiser4patch-added-to-mm-tree.patch removed from -mm tree
Date: Thu, 01 May 2008 02:23:09 -0700
Message-ID: <200805010923.m419N9IW030073@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50518 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755145AbYEAJXt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:23:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jens.axboe@oracle.com, akpm@linux-foundation.org, edward.shishkin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     jens-fixed-reiser4
has been removed from the -mm tree.  Its filename was
     jens-broke-reiser4patch-added-to-mm-tree.patch

This patch was dropped because it was folded into reiser4.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jens-fixed-reiser4
From: Jens Axboe <jens.axboe@oracle.com>

On Tue, Nov 06 2007, akpm@linux-foundation.org wrote:
>
> The patch titled
>      jens-broke-reiser4
> has been added to the -mm tree.  Its filename is
>      jens-broke-reiser4.patch
>
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>
> See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> out what to do about this
>
> ------------------------------------------------------
> Subject: jens-broke-reiser4
> From: Andrew Morton <akpm@linux-foundation.org>
>
> fs/reiser4/plugin/file/cryptcompress.c: In function 'reiser4_deflate_cluster':
> fs/reiser4/plugin/file/cryptcompress.c:1120: error: 'struct scatterlist' has no member named 'page'
> fs/reiser4/plugin/file/cryptcompress.c:1124: error: 'struct scatterlist' has no member named 'page'
> fs/reiser4/plugin/file/cryptcompress.c: In function 'reiser4_inflate_cluster':
> fs/reiser4/plugin/file/cryptcompress.c:1184: error: 'struct scatterlist' has no member named 'page'
> fs/reiser4/plugin/file/cryptcompress.c:1188: error: 'struct scatterlist' has no member named 'page'
>
> Please send a fix against next -mm.

Here's one for 2.6.23-mm1, should apply fine for you now.

Cc: Edward Shishkin <edward.shishkin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/plugin/file/cryptcompress.c |   24 +++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

diff -puN fs/reiser4/plugin/file/cryptcompress.c~jens-broke-reiser4patch-added-to-mm-tree fs/reiser4/plugin/file/cryptcompress.c
--- a/fs/reiser4/plugin/file/cryptcompress.c~jens-broke-reiser4patch-added-to-mm-tree
+++ a/fs/reiser4/plugin/file/cryptcompress.c
@@ -15,12 +15,12 @@
 #include "../../tree_walk.h"
 #include "cryptcompress.h"
 
-#include <asm/scatterlist.h>
 #include <linux/pagevec.h>
 #include <asm/uaccess.h>
 #include <linux/swap.h>
 #include <linux/writeback.h>
 #include <linux/random.h>
+#include <linux/scatterlist.h>
 
 /*
                Managing primary and secondary caches by Reiser4
@@ -206,9 +206,7 @@ static int create_keyid (struct reiser4_
 	memcpy(cmem, data->keyid, data->keyid_size);
 	memset(cmem + data->keyid_size, 0, pad);
 
-	sg.page = virt_to_page(cmem);
-	sg.offset = offset_in_page(cmem);
-	sg.length = data->keyid_size + pad;
+	sg_init_one(&sg, cmem, data->keyid_size + pad);
 
 	ret = crypto_blkcipher_encrypt(&cdesc, &sg, &sg,
 				       data->keyid_size + pad);
@@ -1117,13 +1115,8 @@ int reiser4_deflate_cluster(struct clust
 			return result;
 
 		align_or_cut_overhead(inode, clust, WRITE_OP);
-		src.page = virt_to_page(tfm_input_data(clust));
-		src.offset = offset_in_page(tfm_input_data(clust));
-		src.length = tc->len;
-
-		dst.page = virt_to_page(tfm_output_data(clust));
-		dst.offset = offset_in_page(tfm_output_data(clust));
-		dst.length = tc->len;
+		sg_init_one(&src, tfm_input_data(clust), tc->len);
+		sg_init_one(&dst, tfm_output_data(clust), tc->len);
 
 		result = crypto_blkcipher_encrypt(&desc, &dst, &src, tc->len);
 		if (result) {
@@ -1181,13 +1174,8 @@ int reiser4_inflate_cluster(struct clust
 			return result;
 		assert("edward-909", tfm_cluster_is_set(tc));
 
-		src.page   =   virt_to_page(tfm_input_data(clust));
-		src.offset = offset_in_page(tfm_input_data(clust));
-		src.length = tc->len;
