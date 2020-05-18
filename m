From: Andrew Morton <akpm@linux-foundation.org>
Subject: + iomap-use-attach-detach_page_private.patch added to -mm
 tree
Date: Mon, 18 May 2020 14:46:20 -0700
Message-ID: <20200518214620.XLTFHBznt%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727819AbgERVqW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 May 2020 17:46:22 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darrick.wong@oracle.com, david@fromorbit.com, guoqing.jiang@cloud.ionos.com, hch@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: iomap: use attach/detach_page_private
has been added to the -mm tree.  Its filename is
     iomap-use-attach-detach_page_private.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/iomap-use-attach-detach_page_private.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/iomap-use-attach-detach_page_private.patch

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
Subject: iomap: use attach/detach_page_private

Since the new pair function is introduced, we can call them to clean the
code in iomap.

Link: http://lkml.kernel.org/r/20200517214718.468-7-guoqing.jiang@cloud.ionos.com
Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/iomap/buffered-io.c |   19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

--- a/fs/iomap/buffered-io.c~iomap-use-attach-detach_page_private
+++ a/fs/iomap/buffered-io.c
@@ -59,24 +59,19 @@ iomap_page_create(struct inode *inode, s
 	 * migrate_page_move_mapping() assumes that pages with private data have
 	 * their count elevated by 1.
 	 */
-	get_page(page);
-	set_page_private(page, (unsigned long)iop);
-	SetPagePrivate(page);
+	attach_page_private(page, iop);
 	return iop;
 }
 
 static void
 iomap_page_release(struct page *page)
 {
-	struct iomap_page *iop = to_iomap_page(page);
+	struct iomap_page *iop = detach_page_private(page);
 
 	if (!iop)
 		return;
 	WARN_ON_ONCE(atomic_read(&iop->read_count));
 	WARN_ON_ONCE(atomic_read(&iop->write_count));
-	ClearPagePrivate(page);
-	set_page_private(page, 0);
-	put_page(page);
 	kfree(iop);
 }
 
@@ -526,14 +521,8 @@ iomap_migrate_page(struct address_space
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
 
 	if (mode != MIGRATE_SYNC_NO_COPY)
 		migrate_page_copy(newpage, page);
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
