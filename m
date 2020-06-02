From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 047/128] buffer_head.h: remove attach_page_buffers
Date: Tue, 02 Jun 2020 13:12:43 -0700
Message-ID: <20200602201243.NAGqQBczu%akpm@linux-foundation.org>
References: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728326AbgFBUMp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 16:12:45 -0400
In-Reply-To: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adilger@dilger.ca, akpm@linux-foundation.org, bigeasy@linutronix.de, guoqing.jiang@cloud.ionos.com, guro@fb.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, tglx@linutronix.de, torvalds@linux-foundation.org

From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: buffer_head.h: remove attach_page_buffers

All the callers have replaced attach_page_buffers with the new function
attach_page_private, so remove it.

Link: http://lkml.kernel.org/r/20200517214718.468-10-guoqing.jiang@cloud.ionos.com
Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Roman Gushchin <guro@fb.com>
Cc: Andreas Dilger <adilger@dilger.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/buffer_head.h |    8 --------
 1 file changed, 8 deletions(-)

--- a/include/linux/buffer_head.h~buffer_headh-remove-attach_page_buffers
+++ a/include/linux/buffer_head.h
@@ -272,14 +272,6 @@ void buffer_init(void);
  * inline definitions
  */
 
-static inline void attach_page_buffers(struct page *page,
-		struct buffer_head *head)
-{
-	get_page(page);
-	SetPagePrivate(page);
-	set_page_private(page, (unsigned long)head);
-}
