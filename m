From: akpm@linux-foundation.org
Subject: + fs-bufferc-add-device-information-for-error-output-in-__find_get_block_slow.patch added to -mm tree
Date: Wed, 14 Sep 2011 13:51:55 -0700
Message-ID: <201109142051.p8EKptQO008356@hpaq13.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:20294 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933235Ab1INUwG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Sep 2011 16:52:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: boyu.mt@taobao.com, tytso@mit.edu, viro@zeniv.linux.org.uk


The patch titled
     fs/buffer.c: add device information for error output in __find_get_block_slow()
has been added to the -mm tree.  Its filename is
     fs-bufferc-add-device-information-for-error-output-in-__find_get_block_slow.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/buffer.c: add device information for error output in __find_get_block_slow()
From: Tao Ma <boyu.mt@taobao.com>

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

fs-bufferc-add-device-information-for-error-output-in-__find_get_block_slow.patch

