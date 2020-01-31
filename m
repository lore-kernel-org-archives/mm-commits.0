From: akpm@linux-foundation.org
Subject: [merged] mm-clean-up-filemap_write_and_wait.patch removed
 from -mm tree
Date: Fri, 31 Jan 2020 15:17:23 -0800
Message-ID: <20200131231723.GvsyfWJls%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbgAaXRY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:17:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ira.weiny@intel.com, mm-commits@vger.kernel.org, nborisov@suse.com, willy@infradead.org


The patch titled
     Subject: mm/filemap.c: clean up filemap_write_and_wait()
has been removed from the -mm tree.  Its filename was
     mm-clean-up-filemap_write_and_wait.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ira Weiny <ira.weiny@intel.com>
Subject: mm/filemap.c: clean up filemap_write_and_wait()

At some point filemap_write_and_wait() and filemap_write_and_wait_range()
got the exact same implementation with the exception of the range being
specified in *_range()

Similar to other functions in fs.h which call *_range(..., 0, LLONG_MAX),
change filemap_write_and_wait() to be a static inline which calls
filemap_write_and_wait_range()

Link: http://lkml.kernel.org/r/20191129160713.30892-1-ira.weiny@intel.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    6 +++++-
 mm/filemap.c       |   34 ++++++----------------------------
 2 files changed, 11 insertions(+), 29 deletions(-)

--- a/include/linux/fs.h~mm-clean-up-filemap_write_and_wait
+++ a/include/linux/fs.h
@@ -2737,7 +2737,6 @@ static inline int filemap_fdatawait(stru
 
 extern bool filemap_range_has_page(struct address_space *, loff_t lstart,
 				  loff_t lend);
-extern int filemap_write_and_wait(struct address_space *mapping);
 extern int filemap_write_and_wait_range(struct address_space *mapping,
 				        loff_t lstart, loff_t lend);
 extern int __filemap_fdatawrite_range(struct address_space *mapping,
@@ -2747,6 +2746,11 @@ extern int filemap_fdatawrite_range(stru
 extern int filemap_check_errors(struct address_space *mapping);
 extern void __filemap_set_wb_err(struct address_space *mapping, int err);
 
+static inline int filemap_write_and_wait(struct address_space *mapping)
+{
+	return filemap_write_and_wait_range(mapping, 0, LLONG_MAX);
+}
+
 extern int __must_check file_fdatawait_range(struct file *file, loff_t lstart,
 						loff_t lend);
 extern int __must_check file_check_and_advance_wb_err(struct file *file);
--- a/mm/filemap.c~mm-clean-up-filemap_write_and_wait
+++ a/mm/filemap.c
@@ -632,33 +632,6 @@ static bool mapping_needs_writeback(stru
 	return mapping->nrpages;
 }
 
-int filemap_write_and_wait(struct address_space *mapping)
-{
-	int err = 0;
-
-	if (mapping_needs_writeback(mapping)) {
-		err = filemap_fdatawrite(mapping);
-		/*
-		 * Even if the above returned error, the pages may be
-		 * written partially (e.g. -ENOSPC), so we wait for it.
-		 * But the -EIO is special case, it may indicate the worst
-		 * thing (e.g. bug) happened, so we avoid waiting for it.
-		 */
-		if (err != -EIO) {
-			int err2 = filemap_fdatawait(mapping);
-			if (!err)
-				err = err2;
-		} else {
-			/* Clear any previously stored errors */
-			filemap_check_errors(mapping);
-		}
-	} else {
-		err = filemap_check_errors(mapping);
-	}
-	return err;
-}
-EXPORT_SYMBOL(filemap_write_and_wait);
