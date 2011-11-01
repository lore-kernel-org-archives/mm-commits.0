From: akpm@linux-foundation.org
Subject: [merged] fs-bufferc-add-device-information-for-error-output-in-__find_get_block_slow.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:11:10 -0700
Message-ID: <201111012111.pA1LBAB5004937@hpaq11.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:15835 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab1KAVLX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:11:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: boyu.mt@taobao.com, tytso@mit.edu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/buffer.c: add device information for error output in __find_get_block_slow()
has been removed from the -mm tree.  Its filename was
     fs-bufferc-add-device-information-for-error-output-in-__find_get_block_slow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Tao Ma <boyu.mt@taobao.com>
Subject: fs/buffer.c: add device information for error output in __find_get_block_slow()

On the ext4 mailing list[1], we got some report about errors in
__find_get_block_slow(), but the information is very limited.

If the device information is given, we can know the name of the sick
volume.  Futhermore, we can get the corresponding status of that
block(group, inode block etc) by analyzing the disk layout.

[1] http://marc.info/?l=linux-ext4&m=131379831421147&w=2

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/buffer.c~fs-bufferc-add-device-information-for-error-output-in-__find_get_block_slow fs/buffer.c
--- a/fs/buffer.c~fs-bufferc-add-device-information-for-error-output-in-__find_get_block_slow
+++ a/fs/buffer.c
@@ -213,13 +213,16 @@ __find_get_block_slow(struct block_devic
 	 * elsewhere, don't buffer_error if we had some unmapped buffers
 	 */
 	if (all_mapped) {
+		char b[BDEVNAME_SIZE];
+
 		printk("__find_get_block_slow() failed. "
 			"block=%llu, b_blocknr=%llu\n",
 			(unsigned long long)block,
 			(unsigned long long)bh->b_blocknr);
 		printk("b_state=0x%08lx, b_size=%zu\n",
 			bh->b_state, bh->b_size);
-		printk("device blocksize: %d\n", 1 << bd_inode->i_blkbits);
+		printk("device %s blocksize: %d\n", bdevname(bdev, b),
+			1 << bd_inode->i_blkbits);
 	}
 out_unlock:
 	spin_unlock(&bd_mapping->private_lock);
_

Patches currently in -mm which might be from boyu.mt@taobao.com are

origin.patch
linux-next.patch
fs-direct-ioc-calcuate-fs_count-correctly-in-get_more_blocks.patch

