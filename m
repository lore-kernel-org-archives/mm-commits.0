From: Andrew Morton <akpm@linux-foundation.org>
Subject: + btrfs-use-attach-detach_page_private.patch added to -mm
 tree
Date: Mon, 18 May 2020 14:46:13 -0700
Message-ID: <20200518214613.VbMsn1tzY%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726831AbgERVqO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 May 2020 17:46:14 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clm@fb.com, dsterba@suse.com, guoqing.jiang@cloud.ionos.com, josef@toxicpanda.com, mm-commits@vger.kernel.org


The patch titled
     Subject: btrfs: use attach/detach_page_private
has been added to the -mm tree.  Its filename is
     btrfs-use-attach-detach_page_private.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/btrfs-use-attach-detach_page_private.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/btrfs-use-attach-detach_page_private.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: btrfs: use attach/detach_page_private

Since the new pair function is introduced, we can call them to clean the
code in btrfs.

Link: http://lkml.kernel.org/r/20200517214718.468-4-guoqing.jiang@cloud.ionos.com
Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: David Sterba <dsterba@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/disk-io.c   |    4 +---
 fs/btrfs/extent_io.c |   21 ++++++---------------
 fs/btrfs/inode.c     |   23 +++++------------------
 3 files changed, 12 insertions(+), 36 deletions(-)

--- a/fs/btrfs/disk-io.c~btrfs-use-attach-detach_page_private
+++ a/fs/btrfs/disk-io.c
@@ -980,9 +980,7 @@ static void btree_invalidatepage(struct
 		btrfs_warn(BTRFS_I(page->mapping->host)->root->fs_info,
 			   "page private not zero on page %llu",
 			   (unsigned long long)page_offset(page));
-		ClearPagePrivate(page);
-		set_page_private(page, 0);
-		put_page(page);
+		detach_page_private(page);
 	}
 }
 
--- a/fs/btrfs/extent_io.c~btrfs-use-attach-detach_page_private
+++ a/fs/btrfs/extent_io.c
@@ -3076,22 +3076,16 @@ static int submit_extent_page(unsigned i
 static void attach_extent_buffer_page(struct extent_buffer *eb,
 				      struct page *page)
 {
-	if (!PagePrivate(page)) {
-		SetPagePrivate(page);
-		get_page(page);
-		set_page_private(page, (unsigned long)eb);
-	} else {
+	if (!PagePrivate(page))
+		attach_page_private(page, eb);
+	else
 		WARN_ON(page->private != (unsigned long)eb);
-	}
 }
 
 void set_page_extent_mapped(struct page *page)
 {
-	if (!PagePrivate(page)) {
-		SetPagePrivate(page);
-		get_page(page);
-		set_page_private(page, EXTENT_PAGE_PRIVATE);
-	}
+	if (!PagePrivate(page))
+		attach_page_private(page, (void *)EXTENT_PAGE_PRIVATE);
 }
 
 static struct extent_map *
@@ -4910,10 +4904,7 @@ static void btrfs_release_extent_buffer_
 			 * We need to make sure we haven't be attached
 			 * to a new eb.
 			 */
-			ClearPagePrivate(page);
-			set_page_private(page, 0);
-			/* One for the page private */
-			put_page(page);
+			detach_page_private(page);
 		}
 
 		if (mapped)
--- a/fs/btrfs/inode.c~btrfs-use-attach-detach_page_private
+++ a/fs/btrfs/inode.c
@@ -8301,11 +8301,8 @@ static void btrfs_readahead(struct reada
 static int __btrfs_releasepage(struct page *page, gfp_t gfp_flags)
 {
 	int ret = try_release_extent_mapping(page, gfp_flags);
-	if (ret == 1) {
-		ClearPagePrivate(page);
-		set_page_private(page, 0);
-		put_page(page);
-	}
+	if (ret == 1)
+		detach_page_private(page);
 	return ret;
 }
 
@@ -8327,14 +8324,8 @@ static int btrfs_migratepage(struct addr
 	if (ret != MIGRATEPAGE_SUCCESS)
 		return ret;
 
-	if (page_has_private(page)) {
-		ClearPagePrivate(page);
-		get_page(newpage);
-		set_page_private(newpage, page_private(page));
-		set_page_private(page, 0);
-		put_page(page);
-		SetPagePrivate(newpage);
-	}
+	if (page_has_private(page))
+		attach_page_private(newpage, detach_page_private(page));
 
 	if (PagePrivate2(page)) {
 		ClearPagePrivate2(page);
@@ -8456,11 +8447,7 @@ again:
 	}
 
 	ClearPageChecked(page);
-	if (PagePrivate(page)) {
-		ClearPagePrivate(page);
-		set_page_private(page, 0);
-		put_page(page);
-	}
+	detach_page_private(page);
 }
 
 /*
_

Patches currently in -mm which might be from guoqing.jiang@cloud.ionos.com are

include-linux-pagemaph-introduce-attach-detach_page_private.patch
md-remove-__clear_page_buffers-and-use-attach-detach_page_private.patch
btrfs-use-attach-detach_page_private.patch
fs-bufferc-use-attach-detach_page_private.patch
f2fs-use-attach-detach_page_private.patch
iomap-use-attach-detach_page_private.patch
ntfs-replace-attach_page_buffers-with-attach_page_private.patch
orangefs-use-attach-detach_page_private.patch
buffer_headh-remove-attach_page_buffers.patch
mm-migratec-call-detach_page_private-to-cleanup-code.patch
