From: akpm@linux-foundation.org
Subject: [merged] reiserfs-use-hweight_long.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:56:44 -0700
Message-ID: <201107260755.p6Q7tlog003490@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50865 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753099Ab1GZH4g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:56:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     reiserfs: use hweight_long()
has been removed from the -mm tree.  Its filename was
     reiserfs-use-hweight_long.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiserfs: use hweight_long()
From: Akinobu Mita <akinobu.mita@gmail.com>

Use hweight_long() to count free bits in the bitmap.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/bitmap.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN fs/reiserfs/bitmap.c~reiserfs-use-hweight_long fs/reiserfs/bitmap.c
--- a/fs/reiserfs/bitmap.c~reiserfs-use-hweight_long
+++ a/fs/reiserfs/bitmap.c
@@ -1222,15 +1222,11 @@ void reiserfs_cache_bitmap_metadata(stru
 	info->free_count = 0;
 
 	while (--cur >= (unsigned long *)bh->b_data) {
-		int i;
-
 		/* 0 and ~0 are special, we can optimize for them */
 		if (*cur == 0)
 			info->free_count += BITS_PER_LONG;
 		else if (*cur != ~0L)	/* A mix, investigate */
-			for (i = BITS_PER_LONG - 1; i >= 0; i--)
-				if (!reiserfs_test_le_bit(i, cur))
-					info->free_count++;
+			info->free_count += BITS_PER_LONG - hweight_long(*cur);
 	}
 }
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
ext4-use-proper-little-endian-bitops.patch
ocfs2-avoid-unaligned-access-to-dqc_bitmap.patch
fault-injection-do-not-include-unneeded-header.patch
fault-injection-remove-nonexistent-function-extern.patch
fault-injection-cleanup-simple-attribute-of-stacktrace_depth.patch
fault-injection-use-debugfs_remove_recursive.patch
failslab-simplify-debugfs-initialization.patch
fail_page_alloc-simplify-debugfs-initialization.patch
fail_make_request-cleanup-should_fail_request.patch
asm-generic-add-another-generic-ext2-atomic-bitops.patch

