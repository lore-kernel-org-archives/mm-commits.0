From: akpm@linux-foundation.org
Subject: + md-fix-an-unsigned-compare-to-allow-creation-of-bitmaps-with-v10-metadata.patch added to -mm tree
Date: Mon, 22 Oct 2007 00:40:02 -0700
Message-ID: <200710220740.l9M7e2nR016720@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52062 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751305AbXJVHkU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Oct 2007 03:40:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de, stable@kernel.org


The patch titled
     md: fix an unsigned compare to allow creation of bitmaps with v1.0 metadata
has been added to the -mm tree.  Its filename is
     md-fix-an-unsigned-compare-to-allow-creation-of-bitmaps-with-v10-metadata.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: md: fix an unsigned compare to allow creation of bitmaps with v1.0 metadata
From: NeilBrown <neilb@suse.de>

As page->index is unsigned, this all becomes an unsigned comparison, which
 almost always returns an error.

Signed-off-by: Neil Brown <neilb@suse.de>
Cc: Stable <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/bitmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/md/bitmap.c~md-fix-an-unsigned-compare-to-allow-creation-of-bitmaps-with-v10-metadata drivers/md/bitmap.c
--- a/drivers/md/bitmap.c~md-fix-an-unsigned-compare-to-allow-creation-of-bitmaps-with-v10-metadata
+++ a/drivers/md/bitmap.c
@@ -274,7 +274,7 @@ static int write_sb_page(struct bitmap *
 			if (bitmap->offset < 0) {
 				/* DATA  BITMAP METADATA  */
 				if (bitmap->offset
-				    + page->index * (PAGE_SIZE/512)
+				    + (long)(page->index * (PAGE_SIZE/512))
 				    + size/512 > 0)
 					/* bitmap runs in to metadata */
 					return -EINVAL;
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
exportfs-add-fid-type.patch
exportfs-add-new-methods.patch
ext2-new-export-ops.patch
ext3-new-export-ops.patch
ext4-new-export-ops.patch
efs-new-export-ops.patch
jfs-new-export-ops.patch
ntfs-new-export-ops.patch
xfs-new-export-ops.patch
fat-new-export-ops.patch
isofs-new-export-ops.patch
shmem-new-export-ops.patch
reiserfs-new-export-ops.patch
gfs2-new-export-ops.patch
ocfs2-new-export-ops.patch
exportfs-remove-old-methods.patch
exportfs-make-struct-export_operations-const.patch
exportfs-update-documentation.patch
md-fix-an-unsigned-compare-to-allow-creation-of-bitmaps-with-v10-metadata.patch
md-raid5-fix-clearing-of-biofill-operations.patch
git-md-accel.patch
