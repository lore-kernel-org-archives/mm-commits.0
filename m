From: akpm@linux-foundation.org
Subject: + md-dont-write-more-than-is-required-of-the-last-page-of-a-bitmap.patch added to -mm tree
Date: Sun, 20 May 2007 21:31:24 -0700
Message-ID: <200705210431.l4L4VNPL002407@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42898 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752864AbXEUEe3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 00:34:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de, stable@kernel.org


The patch titled
     md: don't write more than is required of the last page of a bitmap
has been added to the -mm tree.  Its filename is
     md-dont-write-more-than-is-required-of-the-last-page-of-a-bitmap.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: md: don't write more than is required of the last page of a bitmap
From: NeilBrown <neilb@suse.de>

It is possible that real data or metadata follows the bitmap without full page
alignment.

So limit the last write to be only the required number of bytes, rounded up to
the hard sector size of the device.

Signed-off-by: Neil Brown <neilb@suse.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/bitmap.c         |   17 ++++++++++++-----
 include/linux/raid/bitmap.h |    1 +
 2 files changed, 13 insertions(+), 5 deletions(-)

diff -puN drivers/md/bitmap.c~md-dont-write-more-than-is-required-of-the-last-page-of-a-bitmap drivers/md/bitmap.c
--- a/drivers/md/bitmap.c~md-dont-write-more-than-is-required-of-the-last-page-of-a-bitmap
+++ a/drivers/md/bitmap.c
@@ -255,19 +255,25 @@ static struct page *read_sb_page(mddev_t
 
 }
 
-static int write_sb_page(mddev_t *mddev, long offset, struct page *page, int wait)
+static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
 {
 	mdk_rdev_t *rdev;
 	struct list_head *tmp;
+	mddev_t *mddev = bitmap->mddev;
 
 	ITERATE_RDEV(mddev, rdev, tmp)
 		if (test_bit(In_sync, &rdev->flags)
-		    && !test_bit(Faulty, &rdev->flags))
+		    && !test_bit(Faulty, &rdev->flags)) {
+			int size = PAGE_SIZE;
+			if (page->index == bitmap->file_pages-1)
+				size = roundup(bitmap->last_page_size,
+					       bdev_hardsect_size(rdev->bdev));
 			md_super_write(mddev, rdev,
-				       (rdev->sb_offset<<1) + offset
+				       (rdev->sb_offset<<1) + bitmap->offset
 				       + page->index * (PAGE_SIZE/512),
-				       PAGE_SIZE,
+				       size,
 				       page);
+		}
 
 	if (wait)
 		md_super_wait(mddev);
@@ -282,7 +288,7 @@ static int write_page(struct bitmap *bit
 	struct buffer_head *bh;
 
 	if (bitmap->file == NULL)
-		return write_sb_page(bitmap->mddev, bitmap->offset, page, wait);
+		return write_sb_page(bitmap, page, wait);
 
 	bh = page_buffers(page);
 
@@ -923,6 +929,7 @@ static int bitmap_init_from_disk(struct 
 			}
 
 			bitmap->filemap[bitmap->file_pages++] = page;
+			bitmap->last_page_size = count;
 		}
 		paddr = kmap_atomic(page, KM_USER0);
 		if (bitmap->flags & BITMAP_HOSTENDIAN)
diff -puN include/linux/raid/bitmap.h~md-dont-write-more-than-is-required-of-the-last-page-of-a-bitmap include/linux/raid/bitmap.h
--- a/include/linux/raid/bitmap.h~md-dont-write-more-than-is-required-of-the-last-page-of-a-bitmap
+++ a/include/linux/raid/bitmap.h
@@ -232,6 +232,7 @@ struct bitmap {
 	struct page **filemap; /* list of cache pages for the file */
 	unsigned long *filemap_attr; /* attributes associated w/ filemap pages */
 	unsigned long file_pages; /* number of pages in the file */
+	int last_page_size; /* bytes in the last page */
 
 	unsigned long flags;
 
_

Patches currently in -mm which might be from neilb@suse.de are

git-md-accel.patch
md-avoid-overflow-in-raid0-calculation-with-large-components.patch
md-dont-write-more-than-is-required-of-the-last-page-of-a-bitmap.patch
md-fix-bug-with-linear-hot-add-and-elsewhere.patch
knfsd-exportfs-add-exportfsh-header.patch
knfsd-exportfs-add-exportfsh-header-fix.patch
knfsd-exportfs-remove-iget-abuse.patch
knfsd-exportfs-remove-iget-abuse-fix.patch
knfsd-exportfs-add-procedural-interface-for-nfsd.patch
knfsd-exportfs-remove-call-macro.patch
knfsd-exportfs-untangle-isdir-logic-in-find_exported_dentry.patch
knfsd-exportfs-move-acceptable-check-into-find_acceptable_alias.patch
knfsd-exportfs-add-find_disconnected_root-helper.patch
knfsd-exportfs-split-out-reconnecting-a-dentry-from-find_exported_dentry.patch
nfsd-warning-fix.patch
use-menuconfig-objects-ii-md.patch
md-improve-message-about-invalid-superblock-during-autodetect.patch
md-improve-the-is_mddev_idle-test-fix.patch
md-check-that-internal-bitmap-does-not-overlap-other-data.patch
md-change-bitmap_unplug-and-others-to-void-functions.patch
