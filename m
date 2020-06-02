From: akpm@linux-foundation.org
Subject: [merged] orangefs-use-attach-detach_page_private.patch
 removed from -mm tree
Date: Tue, 02 Jun 2020 14:39:35 -0700
Message-ID: <20200602213935.PxRkR0UjU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726320AbgFBVjg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 17:39:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, guoqing.jiang@cloud.ionos.com, hubcap@omnibond.com, martin@omnibond.com, mm-commits@vger.kernel.org


The patch titled
     Subject: orangefs: use attach/detach_page_private
has been removed from the -mm tree.  Its filename was
     orangefs-use-attach-detach_page_private.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: orangefs: use attach/detach_page_private

Since the new pair function is introduced, we can call them to clean the
code in orangefs.

Link: http://lkml.kernel.org/r/20200517214718.468-9-guoqing.jiang@cloud.ionos.com
Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Tested-by: Mike Marshall <hubcap@omnibond.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Martin Brandenburg <martin@omnibond.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/orangefs/inode.c |   32 ++++++--------------------------
 1 file changed, 6 insertions(+), 26 deletions(-)

--- a/fs/orangefs/inode.c~orangefs-use-attach-detach_page_private
+++ a/fs/orangefs/inode.c
@@ -62,12 +62,7 @@ static int orangefs_writepage_locked(str
 	} else {
 		ret = 0;
 	}
-	if (wr) {
-		kfree(wr);
-		set_page_private(page, 0);
-		ClearPagePrivate(page);
-		put_page(page);
-	}
+	kfree(detach_page_private(page));
 	return ret;
 }
 
@@ -409,9 +404,7 @@ static int orangefs_write_begin(struct f
 	wr->len = len;
 	wr->uid = current_fsuid();
 	wr->gid = current_fsgid();
-	SetPagePrivate(page);
-	set_page_private(page, (unsigned long)wr);
-	get_page(page);
+	attach_page_private(page, wr);
 okay:
 	return 0;
 }
@@ -459,18 +452,12 @@ static void orangefs_invalidatepage(stru
 	wr = (struct orangefs_write_range *)page_private(page);
 
 	if (offset == 0 && length == PAGE_SIZE) {
-		kfree((struct orangefs_write_range *)page_private(page));
-		set_page_private(page, 0);
-		ClearPagePrivate(page);
-		put_page(page);
+		kfree(detach_page_private(page));
 		return;
 	/* write range entirely within invalidate range (or equal) */
 	} else if (page_offset(page) + offset <= wr->pos &&
 	    wr->pos + wr->len <= page_offset(page) + offset + length) {
-		kfree((struct orangefs_write_range *)page_private(page));
-		set_page_private(page, 0);
-		ClearPagePrivate(page);
-		put_page(page);
+		kfree(detach_page_private(page));
 		/* XXX is this right? only caller in fs */
 		cancel_dirty_page(page);
 		return;
@@ -535,12 +522,7 @@ static int orangefs_releasepage(struct p
 
 static void orangefs_freepage(struct page *page)
 {
-	if (PagePrivate(page)) {
-		kfree((struct orangefs_write_range *)page_private(page));
-		set_page_private(page, 0);
-		ClearPagePrivate(page);
-		put_page(page);
-	}
+	kfree(detach_page_private(page));
 }
 
 static int orangefs_launder_page(struct page *page)
@@ -740,9 +722,7 @@ vm_fault_t orangefs_page_mkwrite(struct
 	wr->len = PAGE_SIZE;
 	wr->uid = current_fsuid();
 	wr->gid = current_fsgid();
-	SetPagePrivate(page);
-	set_page_private(page, (unsigned long)wr);
-	get_page(page);
+	attach_page_private(page, wr);
 okay:
 
 	file_update_time(vmf->vma->vm_file);
_

Patches currently in -mm which might be from guoqing.jiang@cloud.ionos.com are
