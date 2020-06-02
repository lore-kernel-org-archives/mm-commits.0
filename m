From: akpm@linux-foundation.org
Subject: [merged]
 mm_typesh-change-set_page_private-to-inline-function.patch removed from -mm
 tree
Date: Tue, 02 Jun 2020 14:39:42 -0700
Message-ID: <20200602213942.J1_FV6UUF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726647AbgFBVjm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 17:39:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, guoqing.jiang@cloud.ionos.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm_types.h: change set_page_private to inline function
has been removed from the -mm tree.  Its filename was
     mm_typesh-change-set_page_private-to-inline-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: mm_types.h: change set_page_private to inline function

Change it to inline function to make callers use the proper argument.  And
no need for it to be macro per Andrew's comment [1].

[1] https://lore.kernel.org/lkml/20200518221235.1fa32c38e5766113f78e3f0d@linux-foundation.org/

Link: http://lkml.kernel.org/r/20200525203149.18802-1-guoqing.jiang@cloud.ionos.com
Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/include/linux/mm_types.h~mm_typesh-change-set_page_private-to-inline-function
+++ a/include/linux/mm_types.h
@@ -240,7 +240,11 @@ static inline atomic_t *compound_pincoun
 #define PAGE_FRAG_CACHE_MAX_ORDER	get_order(PAGE_FRAG_CACHE_MAX_SIZE)
 
 #define page_private(page)		((page)->private)
-#define set_page_private(page, v)	((page)->private = (v))
+
+static inline void set_page_private(struct page *page, unsigned long private)
+{
+	page->private = private;
+}
 
 struct page_frag_cache {
 	void * va;
_

Patches currently in -mm which might be from guoqing.jiang@cloud.ionos.com are
