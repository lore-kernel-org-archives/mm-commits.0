From: akpm@linux-foundation.org
Subject: [patch 032/127] mm/page_ext: rename offset to index
Date: Fri, 07 Oct 2016 16:58:24 -0700
Message-ID: <57f836a0.IIxih0ktETTIDE79%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38980 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932775AbcJGX60 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 19:58:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, mhocko@kernel.org, minchan@kernel.org, sergey.senozhatsky@gmail.com, vbabka@suse.cz

From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/page_ext: rename offset to index

Here, 'offset' means entry index in page_ext array.  Following patch will
use 'offset' for field offset in each entry so rename current 'offset' to
prevent confusion.

Link: http://lkml.kernel.org/r/1471315879-32294-5-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_ext.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/page_ext.c~mm-page_ext-rename-offset-to-index mm/page_ext.c
--- a/mm/page_ext.c~mm-page_ext-rename-offset-to-index
+++ a/mm/page_ext.c
@@ -102,7 +102,7 @@ void __meminit pgdat_page_ext_init(struc
 struct page_ext *lookup_page_ext(struct page *page)
 {
 	unsigned long pfn = page_to_pfn(page);
-	unsigned long offset;
+	unsigned long index;
 	struct page_ext *base;
 
 	base = NODE_DATA(page_to_nid(page))->node_page_ext;
@@ -119,9 +119,9 @@ struct page_ext *lookup_page_ext(struct
 	if (unlikely(!base))
 		return NULL;
 #endif
-	offset = pfn - round_down(node_start_pfn(page_to_nid(page)),
+	index = pfn - round_down(node_start_pfn(page_to_nid(page)),
 					MAX_ORDER_NR_PAGES);
-	return base + offset;
+	return base + index;
 }
 
 static int __init alloc_node_page_ext(int nid)
_
