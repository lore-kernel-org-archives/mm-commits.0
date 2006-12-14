From: akpm@osdl.org
Subject: - reorder-struct-pipe_buf_operations.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:04:12 -0800
Message-ID: <200612140604.kBE64CUf001803@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51720 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842AbWLNGE2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:04:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dada1@cosmosbay.com, mm-commits@vger.kernel.org


The patch titled
     reorder struct pipe_buf_operations
has been removed from the -mm tree.  Its filename was
     reorder-struct-pipe_buf_operations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 1 insertion(+), 1 deletion(-)

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

convert-i386-pda-code-to-use-%fs.patch
convert-i386-pda-code-to-use-%fs-fixes.patch
get-rid-of-arch_have_xtime_lock.patch
introduce-time_data-a-new-structure-to-hold-jiffies-xtime.patch

