From: Andrew Morton <akpm@linux-foundation.org>
Subject: + f2fs-use-attach-detach_page_private.patch added to -mm
 tree
Date: Mon, 18 May 2020 14:46:18 -0700
Message-ID: <20200518214618.UErFgrsRX%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727900AbgERVqT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 May 2020 17:46:19 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guoqing.jiang@cloud.ionos.com, jaegeuk@kernel.org, mm-commits@vger.kernel.org, yuchao0@huawei.com


The patch titled
     Subject: f2fs: use attach/detach_page_private
has been added to the -mm tree.  Its filename is
     f2fs-use-attach-detach_page_private.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/f2fs-use-attach-detach_page_private.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/f2fs-use-attach-detach_page_private.patch

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
