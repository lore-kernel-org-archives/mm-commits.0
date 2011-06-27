From: akpm@linux-foundation.org
Subject: + reiserfs-use-proper-little-endian-bitops.patch added to -mm tree
Date: Mon, 27 Jun 2011 14:56:13 -0700
Message-ID: <201106272156.p5RLuDaI029666@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58011 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754939Ab1F0V4P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Jun 2011 17:56:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com


The patch titled
     reiserfs: use proper little-endian bitops
has been added to the -mm tree.  Its filename is
     reiserfs-use-proper-little-endian-bitops.patch

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
Subject: reiserfs: use proper little-endian bitops
From: Akinobu Mita <akinobu.mita@gmail.com>

Using __test_and_{set,clear}_bit_le() with ignoring its return value can
be replaced with __{set,clear}_bit_le().

This introduces reiserfs_{set,clear}_le_bit for __{set,clear}_bit_le and
does the above change with them.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/bitmap.c        |    2 +-
 fs/reiserfs/resize.c        |    6 +++---
 include/linux/reiserfs_fs.h |    2 ++
 3 files changed, 6 insertions(+), 4 deletions(-)

diff -puN fs/reiserfs/bitmap.c~reiserfs-use-proper-little-endian-bitops fs/reiserfs/bitmap.c
--- a/fs/reiserfs/bitmap.c~reiserfs-use-proper-little-endian-bitops
+++ a/fs/reiserfs/bitmap.c
@@ -214,7 +214,7 @@ static int scan_bitmap_block(struct reis
 					}
 					/* otherwise we clear all bit were set ... */
 					while (--i >= *beg)
-						reiserfs_test_and_clear_le_bit
+						reiserfs_clear_le_bit
 						    (i, bh->b_data);
 					reiserfs_restore_prepared_buffer(s, bh);
 					*beg = org;
diff -puN fs/reiserfs/resize.c~reiserfs-use-proper-little-endian-bitops fs/reiserfs/resize.c
--- a/fs/reiserfs/resize.c~reiserfs-use-proper-little-endian-bitops
+++ a/fs/reiserfs/resize.c
@@ -136,7 +136,7 @@ int reiserfs_resize(struct super_block *
 				return -EIO;
 			}
 			memset(bh->b_data, 0, sb_blocksize(sb));
-			reiserfs_test_and_set_le_bit(0, bh->b_data);
+			reiserfs_set_le_bit(0, bh->b_data);
 			reiserfs_cache_bitmap_metadata(s, bh, bitmap + i);
 
 			set_buffer_uptodate(bh);
@@ -172,7 +172,7 @@ int reiserfs_resize(struct super_block *
 
 	reiserfs_prepare_for_journal(s, bh, 1);
 	for (i = block_r; i < s->s_blocksize * 8; i++)
-		reiserfs_test_and_clear_le_bit(i, bh->b_data);
+		reiserfs_clear_le_bit(i, bh->b_data);
 	info->free_count += s->s_blocksize * 8 - block_r;
 
 	journal_mark_dirty(&th, s, bh);
@@ -190,7 +190,7 @@ int reiserfs_resize(struct super_block *
 
 	reiserfs_prepare_for_journal(s, bh, 1);
 	for (i = block_r_new; i < s->s_blocksize * 8; i++)
-		reiserfs_test_and_set_le_bit(i, bh->b_data);
+		reiserfs_set_le_bit(i, bh->b_data);
 	journal_mark_dirty(&th, s, bh);
 	brelse(bh);
 
diff -puN include/linux/reiserfs_fs.h~reiserfs-use-proper-little-endian-bitops include/linux/reiserfs_fs.h
--- a/include/linux/reiserfs_fs.h~reiserfs-use-proper-little-endian-bitops
+++ a/include/linux/reiserfs_fs.h
@@ -2332,7 +2332,9 @@ __u32 keyed_hash(const signed char *msg,
 __u32 yura_hash(const signed char *msg, int len);
 __u32 r5_hash(const signed char *msg, int len);
 
+#define reiserfs_set_le_bit		__set_bit_le
 #define reiserfs_test_and_set_le_bit	__test_and_set_bit_le
+#define reiserfs_clear_le_bit		__clear_bit_le
 #define reiserfs_test_and_clear_le_bit	__test_and_clear_bit_le
 #define reiserfs_test_le_bit		test_bit_le
 #define reiserfs_find_next_zero_le_bit	find_next_zero_bit_le
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
dm-use-use-proper-little-endian-bitops.patch
ext4-use-proper-little-endian-bitops.patch
ocfs2-avoid-unaligned-access-to-dqc_bitmap.patch
md-use-proper-little-endian-bitops.patch
reiserfs-use-proper-little-endian-bitops.patch
reiserfs-use-hweight_long.patch
asm-generic-add-another-generic-ext2-atomic-bitops.patch

