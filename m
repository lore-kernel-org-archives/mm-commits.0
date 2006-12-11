From: akpm@osdl.org
Subject: + reorder-struct-pipe_buf_operations.patch added to -mm tree
Date: Mon, 11 Dec 2006 14:07:07 -0800
Message-ID: <200612112207.kBBM77vG009328@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:41820 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763144AbWLKWHP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Dec 2006 17:07:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dada1@cosmosbay.com


The patch titled
     reorder struct pipe_buf_operations
has been added to the -mm tree.  Its filename is
     reorder-struct-pipe_buf_operations.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: reorder struct pipe_buf_operations
From: Eric Dumazet <dada1@cosmosbay.com>

Fields of struct pipe_buf_operations have not a precise layout (ie not
optimized to fit cache lines nor reduce cache line ping pongs)

The bufs[] array is *large* and is placed near the beginning of the
structure, so all following fields have a large offset.  This is
unfortunate because many archs have smaller instructions when using small
offsets relative to a base register.  On x86 for example, 7 bits offsets
have smaller instruction lengths.

Moving bufs[] at the end of pipe_buf_operations permits all fields to have
small offsets, and reduce text size, and icache pressure.

# size vmlinux.pre vmlinux
    text    data     bss     dec     hex filename
3268989  664356  492196 4425541  438745 vmlinux.pre
3268765  664356  492196 4425317  438665 vmlinux

So this patch reduces text size by 224 bytes on my x86_64 machine. Similar
results on ia32.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/pipe_fs_i.h |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/pipe_fs_i.h~reorder-struct-pipe_buf_operations include/linux/pipe_fs_i.h
--- a/include/linux/pipe_fs_i.h~reorder-struct-pipe_buf_operations
+++ a/include/linux/pipe_fs_i.h
@@ -41,7 +41,6 @@ struct pipe_buf_operations {
 struct pipe_inode_info {
 	wait_queue_head_t wait;
 	unsigned int nrbufs, curbuf;
-	struct pipe_buffer bufs[PIPE_BUFFERS];
 	struct page *tmp_page;
 	unsigned int readers;
 	unsigned int writers;
@@ -51,6 +50,7 @@ struct pipe_inode_info {
 	struct fasync_struct *fasync_readers;
 	struct fasync_struct *fasync_writers;
 	struct inode *inode;
+	struct pipe_buffer bufs[PIPE_BUFFERS];
 };
 
 /* Differs from PIPE_BUF in that PIPE_SIZE is the length of the actual
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

origin.patch
constify-pipe_buf_operations.patch
reorder-struct-pipe_buf_operations.patch
convert-i386-pda-code-to-use-%fs.patch
convert-i386-pda-code-to-use-%fs-fixes.patch
get-rid-of-arch_have_xtime_lock.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index-tweaks.patch
optimize-calc_load.patch

