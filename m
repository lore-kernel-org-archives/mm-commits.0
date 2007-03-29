From: akpm@linux-foundation.org
Subject: - splice-partial-write-handling-fix.patch removed from -mm tree
Date: Thu, 29 Mar 2007 16:39:44 -0700
Message-ID: <200703292339.l2TNdiBO015455@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43268 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934373AbXC2Xk1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:40:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmonakhov@sw.ru, dmonakhov@openvz.org, jens.axboe@oracle.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     splice: partial write handling fix
has been removed from the -mm tree.  Its filename was
     splice-partial-write-handling-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: splice: partial write handling fix
From: Dmitriy Monakhov <dmonakhov@sw.ru>

Currently if partial write has happened while ->commit_write() then page
wasn't marked as accessed and rebalanced.

Signed-off-by: Monakhov Dmitriy <dmonakhov@openvz.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/splice.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff -puN fs/splice.c~splice-partial-write-handling-fix fs/splice.c
--- a/fs/splice.c~splice-partial-write-handling-fix
+++ a/fs/splice.c
@@ -627,18 +627,25 @@ find_page:
 	}
 
 	ret = mapping->a_ops->commit_write(file, page, offset, offset+this_len);
-	if (!ret) {
+	if (ret) {
+		if (ret == AOP_TRUNCATED_PAGE) {
+			page_cache_release(page);
+			goto find_page;
+		}
+		if (ret < 0)
+			goto out;
 		/*
-		 * Return the number of bytes written and mark page as
-		 * accessed, we are now done!
+		 * Partial write has happened, so 'ret' already initialized by
+		 * number of bytes written, Where is nothing we have to do here.
 		 */
+	} else
 		ret = this_len;
-		mark_page_accessed(page);
-		balance_dirty_pages_ratelimited(mapping);
-	} else if (ret == AOP_TRUNCATED_PAGE) {
-		page_cache_release(page);
-		goto find_page;
-	}
+	/*
+	 * Return the number of bytes written and mark page as
+	 * accessed, we are now done!
+	 */
+	mark_page_accessed(page);
+	balance_dirty_pages_ratelimited(mapping);
 out:
 	page_cache_release(page);
 	unlock_page(page);
_

Patches currently in -mm which might be from dmonakhov@sw.ru are

origin.patch
git-libata-all.patch
freevxfs-possible-null-pointer-dereference-fix.patch
reiserfs-possible-null-pointer-dereference-during-resize.patch
ext3-dirindex-error-pointer-issues.patch
ext3-dirindex-error-pointer-issues-fix.patch
floppy-handle-device_create_file-failure-while-init.patch
