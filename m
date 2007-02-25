From: akpm@linux-foundation.org
Subject: + reiserfs-possible-null-pointer-dereference-during-resize.patch added to -mm tree
Date: Sun, 25 Feb 2007 04:34:48 -0800
Message-ID: <200702251234.l1PCYoBT029379@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34977 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964862AbXBYMf3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Feb 2007 07:35:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmonakhov@sw.ru, dmonakhov@openvz.org


The patch titled
     reiserfs: possible null pointer dereference during resize
has been added to the -mm tree.  Its filename is
     reiserfs-possible-null-pointer-dereference-during-resize.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: reiserfs: possible null pointer dereference during resize
From: Dmitriy Monakhov <dmonakhov@sw.ru>

sb_read may return NULL, let's explicitly check it.
If so free new bitmap blocks array, after this we may 		safely exit as it done
above during bitmap allocation.

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

freevxfs-possible-null-pointer-dereference-fix.patch
reiserfs-possible-null-pointer-dereference-during-resize.patch
