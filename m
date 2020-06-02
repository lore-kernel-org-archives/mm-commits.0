From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 051/128] mm/page-writeback.c: remove unused
 variable
Date: Mon, 01 Jun 2020 21:48:15 -0700
Message-ID: <20200602044815.avRQl4X5j%akpm@linux-foundation.org>
References: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725835AbgFBEsQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 00:48:16 -0400
In-Reply-To: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, yuchao0@huawei.com

From: Chao Yu <yuchao0@huawei.com>
Subject: mm/page-writeback.c: remove unused variable

Commit 64081362e8ff ("mm/page-writeback.c: fix range_cyclic writeback
vs writepages deadlock") left unused variable, remove it.

Link: http://lkml.kernel.org/r/20200528033740.17269-1-yuchao0@huawei.com
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/page-writeback.c~writeback-remove-unused-variable
+++ a/mm/page-writeback.c
@@ -2164,7 +2164,6 @@ int write_cache_pages(struct address_spa
 	int error;
 	struct pagevec pvec;
 	int nr_pages;
-	pgoff_t uninitialized_var(writeback_index);
 	pgoff_t index;
 	pgoff_t end;		/* Inclusive */
 	pgoff_t done_index;
@@ -2173,8 +2172,7 @@ int write_cache_pages(struct address_spa
 
 	pagevec_init(&pvec);
 	if (wbc->range_cyclic) {
-		writeback_index = mapping->writeback_index; /* prev offset */
-		index = writeback_index;
+		index = mapping->writeback_index; /* prev offset */
 		end = -1;
 	} else {
 		index = wbc->range_start >> PAGE_SHIFT;
_
