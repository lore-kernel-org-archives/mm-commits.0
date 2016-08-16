From: akpm@linux-foundation.org
Subject: + mm-page_ext-rename-offset-to-index.patch added to -mm tree
Date: Tue, 16 Aug 2016 13:41:40 -0700
Message-ID: <57b37a84.kIOAOleRNn5ramnN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37902 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419AbcHPUvy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Aug 2016 16:51:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, mhocko@kernel.org, minchan@kernel.org, sergey.senozhatsky@gmail.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_ext: rename offset to index
has been added to the -mm tree.  Its filename is
     mm-page_ext-rename-offset-to-index.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_ext-rename-offset-to-index.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_ext-rename-offset-to-index.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-debug_pagealloc-clean-up-guard-page-handling-code.patch
mm-debug_pagealloc-dont-allocate-page_ext-if-we-dont-use-guard-page.patch
mm-page_owner-move-page_owner-specific-function-to-page_ownerc.patch
mm-page_ext-rename-offset-to-index.patch
mm-page_ext-support-extra-space-allocation-by-page_ext-user.patch
mm-page_owner-dont-define-fields-on-struct-page_ext-by-hard-coding.patch

