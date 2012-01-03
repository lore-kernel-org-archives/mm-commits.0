From: akpm@linux-foundation.org
Subject: [merged] ext4-use-proper-little-endian-bitops.patch removed from -mm tree
Date: Tue, 03 Jan 2012 13:35:53 -0800
Message-ID: <20120103213553.AC946100052@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:40908 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab2ACVfy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jan 2012 16:35:54 -0500
Received: by yenm5 with SMTP id m5so2048311yen.1
        for <mm-commits@vger.kernel.org>; Tue, 03 Jan 2012 13:35:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, adilger.kernel@dilger.ca, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: ext4: use proper little-endian bitops
has been removed from the -mm tree.  Its filename was
     ext4-use-proper-little-endian-bitops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: ext4: use proper little-endian bitops

ext4_{set,clear}_bit() is defined as __test_and_{set,clear}_bit_le() for
ext4.  Only two ext4_{set,clear}_bit() calls check the return value.  The
rest of calls ignore the return value and they can be replaced with
__{set,clear}_bit_le().

This changes ext4_{set,clear}_bit() from __test_and_{set,clear}_bit_le()
to __{set,clear}_bit_le() and introduces ext4_test_and_{set,clear}_bit()
for the two places where old bit needs to be returned.

This ext4_{set,clear}_bit() change is considered safe, because if someone
uses these macros without noticing the change, new ext4_{set,clear}_bit
don't have return value and causes compiler errors where the return value
is used.

This also removes unused ext4_find_first_zero_bit().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/ext4.h   |    7 ++++---
 fs/ext4/ialloc.c |    4 ++--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff -puN fs/ext4/ext4.h~ext4-use-proper-little-endian-bitops fs/ext4/ext4.h
--- a/fs/ext4/ext4.h~ext4-use-proper-little-endian-bitops
+++ a/fs/ext4/ext4.h
@@ -957,12 +957,13 @@ struct ext4_inode_info {
 #define test_opt2(sb, opt)		(EXT4_SB(sb)->s_mount_opt2 & \
 					 EXT4_MOUNT2_##opt)
 
-#define ext4_set_bit			__test_and_set_bit_le
+#define ext4_test_and_set_bit		__test_and_set_bit_le
+#define ext4_set_bit			__set_bit_le
 #define ext4_set_bit_atomic		ext2_set_bit_atomic
-#define ext4_clear_bit			__test_and_clear_bit_le
+#define ext4_test_and_clear_bit		__test_and_clear_bit_le
+#define ext4_clear_bit			__clear_bit_le
 #define ext4_clear_bit_atomic		ext2_clear_bit_atomic
 #define ext4_test_bit			test_bit_le
-#define ext4_find_first_zero_bit	find_first_zero_bit_le
 #define ext4_find_next_zero_bit		find_next_zero_bit_le
 #define ext4_find_next_bit		find_next_bit_le
 
diff -puN fs/ext4/ialloc.c~ext4-use-proper-little-endian-bitops fs/ext4/ialloc.c
--- a/fs/ext4/ialloc.c~ext4-use-proper-little-endian-bitops
+++ a/fs/ext4/ialloc.c
@@ -252,7 +252,7 @@ void ext4_free_inode(handle_t *handle, s
 		fatal = ext4_journal_get_write_access(handle, bh2);
 	}
 	ext4_lock_group(sb, block_group);
-	cleared = ext4_clear_bit(bit, bitmap_bh->b_data);
+	cleared = ext4_test_and_clear_bit(bit, bitmap_bh->b_data);
 	if (fatal || !cleared) {
 		ext4_unlock_group(sb, block_group);
 		goto out;
@@ -618,7 +618,7 @@ static int ext4_claim_inode(struct super
 	 */
 	down_read(&grp->alloc_sem);
 	ext4_lock_group(sb, group);
-	if (ext4_set_bit(ino, inode_bitmap_bh->b_data)) {
+	if (ext4_test_and_set_bit(ino, inode_bitmap_bh->b_data)) {
 		/* not a free inode */
 		retval = 1;
 		goto err_ret;
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch

