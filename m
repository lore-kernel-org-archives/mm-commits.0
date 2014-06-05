From: akpm@linux-foundation.org
Subject: [merged] fs-mpagec-factor-page_endio-out-of-mpage_end_io.patch
 removed from -mm tree
Date: Thu, 05 Jun 2014 12:50:32 -0700
Message-ID: <5390ca08.FvVagczPuqPy6E6B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56014 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaFETud (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:50:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hughd@google.com, dheeraj.reddy@intel.com, david@fromorbit.com, matthew.r.wilcox@intel.com

Subject: [merged] fs-mpagec-factor-page_endio-out-of-mpage_end_io.patch removed from -mm tree
To: matthew.r.wilcox@intel.com,david@fromorbit.com,dheeraj.reddy@intel.com,hughd@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:50:32 -0700


The patch titled
     Subject: fs/mpage.c: factor page_endio() out of mpage_end_io()
has been removed from the -mm tree.  Its filename was
     fs-mpagec-factor-page_endio-out-of-mpage_end_io.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: fs/mpage.c: factor page_endio() out of mpage_end_io()

page_endio() takes care of updating all the appropriate page flags once
I/O has finished to a page.  Switch to using mapping_set_error() instead
of setting AS_EIO directly; this will handle thin-provisioned devices
correctly.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dheeraj Reddy <dheeraj.reddy@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/mpage.c              |   18 +-----------------
 include/linux/pagemap.h |    2 ++
 mm/filemap.c            |   25 +++++++++++++++++++++++++
 3 files changed, 28 insertions(+), 17 deletions(-)

diff -puN fs/mpage.c~fs-mpagec-factor-page_endio-out-of-mpage_end_io fs/mpage.c
--- a/fs/mpage.c~fs-mpagec-factor-page_endio-out-of-mpage_end_io
+++ a/fs/mpage.c
@@ -48,23 +48,7 @@ static void mpage_end_io(struct bio *bio
 
 	bio_for_each_segment_all(bv, bio, i) {
 		struct page *page = bv->bv_page;
-
-		if (bio_data_dir(bio) == READ) {
-			if (!err) {
-				SetPageUptodate(page);
-			} else {
-				ClearPageUptodate(page);
-				SetPageError(page);
-			}
-			unlock_page(page);
-		} else { /* bio_data_dir(bio) == WRITE */
-			if (err) {
-				SetPageError(page);
-				if (page->mapping)
-					set_bit(AS_EIO, &page->mapping->flags);
-			}
-			end_page_writeback(page);
-		}
+		page_endio(page, bio_data_dir(bio), err);
 	}
 
 	bio_put(bio);
diff -puN include/linux/pagemap.h~fs-mpagec-factor-page_endio-out-of-mpage_end_io include/linux/pagemap.h
--- a/include/linux/pagemap.h~fs-mpagec-factor-page_endio-out-of-mpage_end_io
+++ a/include/linux/pagemap.h
@@ -425,6 +425,8 @@ static inline void wait_on_page_writebac
 extern void end_page_writeback(struct page *page);
 void wait_for_stable_page(struct page *page);
 
+void page_endio(struct page *page, int rw, int err);
+
 /*
  * Add an arbitrary waiter to a page's wait queue
  */
diff -puN mm/filemap.c~fs-mpagec-factor-page_endio-out-of-mpage_end_io mm/filemap.c
--- a/mm/filemap.c~fs-mpagec-factor-page_endio-out-of-mpage_end_io
+++ a/mm/filemap.c
@@ -764,6 +764,31 @@ void end_page_writeback(struct page *pag
 }
 EXPORT_SYMBOL(end_page_writeback);
 
+/*
+ * After completing I/O on a page, call this routine to update the page
+ * flags appropriately
+ */
+void page_endio(struct page *page, int rw, int err)
+{
+	if (rw == READ) {
+		if (!err) {
+			SetPageUptodate(page);
+		} else {
+			ClearPageUptodate(page);
+			SetPageError(page);
+		}
+		unlock_page(page);
+	} else { /* rw == WRITE */
+		if (err) {
+			SetPageError(page);
+			if (page->mapping)
+				mapping_set_error(page->mapping, err);
+		}
+		end_page_writeback(page);
+	}
+}
+EXPORT_SYMBOL_GPL(page_endio);
+
 /**
  * __lock_page - get a lock on the page, assuming we need to sleep to get it
  * @page: the page to lock
_

Patches currently in -mm which might be from matthew.r.wilcox@intel.com are

origin.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

