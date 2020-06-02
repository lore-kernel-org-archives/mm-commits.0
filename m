From: akpm@linux-foundation.org
Subject: [merged] buffer_headh-remove-attach_page_buffers.patch
 removed from -mm tree
Date: Tue, 02 Jun 2020 14:39:37 -0700
Message-ID: <20200602213937.TX87aC7le%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726174AbgFBVji (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 17:39:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adilger@dilger.ca, akpm@linux-foundation.org, bigeasy@linutronix.de, guoqing.jiang@cloud.ionos.com, guro@fb.com, mm-commits@vger.kernel.org, tglx@linutronix.de


The patch titled
     Subject: buffer_head.h: remove attach_page_buffers
has been removed from the -mm tree.  Its filename was
     buffer_headh-remove-attach_page_buffers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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
