From: akpm@linux-foundation.org
Subject: - reiserfs-possible-null-pointer-dereference-during-resize.patch removed from -mm tree
Date: Tue, 08 May 2007 19:44:57 -0700
Message-ID: <200705090244.l492ivb5008657@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34532 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967626AbXEICpg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:45:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmonakhov@sw.ru, dmonakhov@openvz.org, mm-commits@vger.kernel.org


The patch titled
     reiserfs: possible null pointer dereference during resize
has been removed from the -mm tree.  Its filename was
     reiserfs-possible-null-pointer-dereference-during-resize.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: reiserfs: possible null pointer dereference during resize
From: Dmitriy Monakhov <dmonakhov@sw.ru>

sb_read may return NULL, let's explicitly check it.  If so free new bitmap
blocks array, after this we may safely exit as it done above during bitmap
allocation.

Signed-off-by: Dmitriy Monakhov <dmonakhov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/resize.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/reiserfs/resize.c~reiserfs-possible-null-pointer-dereference-during-resize fs/reiserfs/resize.c
--- a/fs/reiserfs/resize.c~reiserfs-possible-null-pointer-dereference-during-resize
+++ a/fs/reiserfs/resize.c
@@ -131,6 +131,10 @@ int reiserfs_resize(struct super_block *
 			/* don't use read_bitmap_block since it will cache
 			 * the uninitialized bitmap */
 			bh = sb_bread(s, i * s->s_blocksize * 8);
+			if (!bh) {
+				vfree(bitmap);
+				return -EIO;
+			}
 			memset(bh->b_data, 0, sb_blocksize(sb));
 			reiserfs_test_and_set_le_bit(0, bh->b_data);
 			reiserfs_cache_bitmap_metadata(s, bh, bitmap + i);
_

Patches currently in -mm which might be from dmonakhov@sw.ru are

origin.patch
