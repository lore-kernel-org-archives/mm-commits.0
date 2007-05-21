From: akpm@linux-foundation.org
Subject: + md-check-that-internal-bitmap-does-not-overlap-other-data.patch added to -mm tree
Date: Sun, 20 May 2007 21:34:00 -0700
Message-ID: <200705210433.l4L4XxXl002451@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56562 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754540AbXEUEfE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 00:35:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     md: check that internal bitmap does not overlap other data
has been added to the -mm tree.  Its filename is
     md-check-that-internal-bitmap-does-not-overlap-other-data.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: md: check that internal bitmap does not overlap other data
From: NeilBrown <neilb@suse.de>

We current completely trust user-space to set up metadata describing an
consistant array.  In particlar, that the metadata, data, and bitmap do not
overlap.

But userspace can be buggy, and it is better to report an error than corrupt
data.  So put in some appropriate checks.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/bitmap.c |   35 +++++++++++++++++++++++++++++++++--
 drivers/md/md.c     |   22 +++++++++++++++++++++-
 2 files changed, 54 insertions(+), 3 deletions(-)

diff -puN drivers/md/bitmap.c~md-check-that-internal-bitmap-does-not-overlap-other-data drivers/md/bitmap.c
--- a/drivers/md/bitmap.c~md-check-that-internal-bitmap-does-not-overlap-other-data
+++ a/drivers/md/bitmap.c
@@ -268,6 +268,31 @@ static int write_sb_page(struct bitmap *
 			if (page->index == bitmap->file_pages-1)
 				size = roundup(bitmap->last_page_size,
 					       bdev_hardsect_size(rdev->bdev));
+			/* Just make sure we aren't corrupting data or
+			 * metadata
+			 */
+			if (bitmap->offset < 0) {
+				/* DATA  BITMAP METADATA  */
+				if (bitmap->offset
+				    + page->index * (PAGE_SIZE/512)
+				    + size/512 > 0)
+					/* bitmap runs in to metadata */
+					return -EINVAL;
+				if (rdev->data_offset + mddev->size*2
+				    > rdev->sb_offset*2 + bitmap->offset)
+					/* data runs in to bitmap */
+					return -EINVAL;
+			} else if (rdev->sb_offset*2 < rdev->data_offset) {
+				/* METADATA BITMAP DATA */
+				if (rdev->sb_offset*2
+				    + bitmap->offset
+				    + page->index*(PAGE_SIZE/512) + size/512
+				    > rdev->data_offset)
+					/* bitmap runs in to data */
+					return -EINVAL;
+			} else {
+				/* DATA METADATA BITMAP - no problems */
+			}
 			md_super_write(mddev, rdev,
 				       (rdev->sb_offset<<1) + bitmap->offset
 				       + page->index * (PAGE_SIZE/512),
@@ -287,8 +312,14 @@ static int write_page(struct bitmap *bit
 {
 	struct buffer_head *bh;
 
-	if (bitmap->file == NULL)
-		return write_sb_page(bitmap, page, wait);
+	if (bitmap->file == NULL) {
+		switch (write_sb_page(bitmap, page, wait)) {
+		case -EINVAL:
+			bitmap->flags |= BITMAP_WRITE_ERROR;
+			return -EIO;
+		}
+		return 0;
+	}
 
 	bh = page_buffers(page);
 
diff -puN drivers/md/md.c~md-check-that-internal-bitmap-does-not-overlap-other-data drivers/md/md.c
--- a/drivers/md/md.c~md-check-that-internal-bitmap-does-not-overlap-other-data
+++ a/drivers/md/md.c
@@ -3176,13 +3176,33 @@ static int do_md_run(mddev_t * mddev)
 	 * Drop all container device buffers, from now on
 	 * the only valid external interface is through the md
 	 * device.
-	 * Also find largest hardsector size
 	 */
 	ITERATE_RDEV(mddev,rdev,tmp) {
 		if (test_bit(Faulty, &rdev->flags))
 			continue;
 		sync_blockdev(rdev->bdev);
 		invalidate_bdev(rdev->bdev);
+
+		/* perform some consistency tests on the device.
+		 * We don't want the data to overlap the metadata,
+		 * Internal Bitmap issues has handled elsewhere.
+		 */
+		if (rdev->data_offset < rdev->sb_offset) {
+			if (mddev->size &&
+			    rdev->data_offset + mddev->size*2
+			    > rdev->sb_offset*2) {
+				printk("md: %s: data overlaps metadata\n",
+				       mdname(mddev));
+				return -EINVAL;
+			}
+		} else {
+			if (rdev->sb_offset*2 + rdev->sb_size/512
+			    > rdev->data_offset) {
+				printk("md: %s: metadata overlaps data\n",
+				       mdname(mddev));
+				return -EINVAL;
+			}
+		}
 	}
 
 	md_probe(mddev->unit, NULL, NULL);
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
