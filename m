From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 049/128] mm_types.h: change set_page_private to
 inline function
Date: Tue, 02 Jun 2020 13:12:50 -0700
Message-ID: <20200602201250.RXGRFiyht%akpm@linux-foundation.org>
References: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728326AbgFBUMv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 16:12:51 -0400
In-Reply-To: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, guoqing.jiang@cloud.ionos.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
