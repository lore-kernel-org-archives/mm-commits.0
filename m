From: Andrew Morton <akpm@linux-foundation.org>
Subject: + buffer_headh-remove-attach_page_buffers.patch added to
 -mm tree
Date: Mon, 18 May 2020 14:46:28 -0700
Message-ID: <20200518214628.CI5UY7YSh%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727819AbgERVq3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 May 2020 17:46:29 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adilger@dilger.ca, bigeasy@linutronix.de, guoqing.jiang@cloud.ionos.com, guro@fb.com, mm-commits@vger.kernel.org, tglx@linutronix.de


The patch titled
     Subject: buffer_head.h: remove attach_page_buffers
has been added to the -mm tree.  Its filename is
     buffer_headh-remove-attach_page_buffers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/buffer_headh-remove-attach_page_buffers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/buffer_headh-remove-attach_page_buffers.patch

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
Subject: buffer_head.h: remove attach_page_buffers

All the callers have replaced attach_page_buffers with the new function
attach_page_private, so remove it.

Link: http://lkml.kernel.org/r/20200517214718.468-10-guoqing.jiang@cloud.ionos.com
Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
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
