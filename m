From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 043/128] f2fs: use attach/detach_page_private
Date: Mon, 01 Jun 2020 21:47:51 -0700
Message-ID: <20200602044751.1jOMa3cVa%akpm@linux-foundation.org>
References: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725835AbgFBErw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 00:47:52 -0400
In-Reply-To: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, guoqing.jiang@cloud.ionos.com, jaegeuk@kernel.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, yuchao0@huawei.com

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
