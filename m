From: akpm@linux-foundation.org
Subject: [merged] f2fs-use-attach-detach_page_private.patch
 removed from -mm tree
Date: Tue, 02 Jun 2020 14:39:29 -0700
Message-ID: <20200602213929.NDl9blYSy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726320AbgFBVja (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 17:39:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guoqing.jiang@cloud.ionos.com, jaegeuk@kernel.org, mm-commits@vger.kernel.org, yuchao0@huawei.com


The patch titled
     Subject: f2fs: use attach/detach_page_private
has been removed from the -mm tree.  Its filename was
     f2fs-use-attach-detach_page_private.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: f2fs: use attach/detach_page_private

Since the new pair function is introduced, we can call them to clean the
code in f2fs.h.

Link: http://lkml.kernel.org/r/20200517214718.468-6-guoqing.jiang@cloud.ionos.com
Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Acked-by: Chao Yu <yuchao0@huawei.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/f2fs/f2fs.h |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/fs/f2fs/f2fs.h~f2fs-use-attach-detach_page_private
+++ a/fs/f2fs/f2fs.h
@@ -3051,19 +3051,12 @@ static inline void f2fs_set_page_private
 	if (PagePrivate(page))
 		return;
 
-	get_page(page);
-	SetPagePrivate(page);
-	set_page_private(page, data);
+	attach_page_private(page, (void *)data);
 }
 
 static inline void f2fs_clear_page_private(struct page *page)
 {
-	if (!PagePrivate(page))
-		return;
