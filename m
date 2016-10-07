From: akpm@linux-foundation.org
Subject: [patch 030/127] mm/debug_pagealloc.c: don't allocate page_ext if
 we don't use guard page
Date: Fri, 07 Oct 2016 16:58:18 -0700
Message-ID: <57f8369a.XANPLG4ATtwpxCW5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38966 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932902AbcJGX6Z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 19:58:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, mhocko@kernel.org, minchan@kernel.org, sergey.senozhatsky@gmail.com, vbabka@suse.cz

From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/debug_pagealloc.c: don't allocate page_ext if we don't use guard page

What debug_pagealloc does is just mapping/unmapping page table. 
Basically, it doesn't need additional memory space to memorize something. 
But, with guard page feature, it requires additional memory to distinguish
if the page is for guard or not.  Guard page is only used when
debug_guardpage_minorder is non-zero so this patch removes additional
memory allocation (page_ext) if debug_guardpage_minorder is zero.

It saves memory if we just use debug_pagealloc and not guard page.

Link: http://lkml.kernel.org/r/1471315879-32294-3-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-debug_pagealloc-dont-allocate-page_ext-if-we-dont-use-guard-page mm/page_alloc.c
--- a/mm/page_alloc.c~mm-debug_pagealloc-dont-allocate-page_ext-if-we-dont-use-guard-page
+++ a/mm/page_alloc.c
@@ -607,6 +607,9 @@ static bool need_debug_guardpage(void)
 	if (!debug_pagealloc_enabled())
 		return false;
 
+	if (!debug_guardpage_minorder())
+		return false;
+
 	return true;
 }
 
@@ -615,6 +618,9 @@ static void init_debug_guardpage(void)
 	if (!debug_pagealloc_enabled())
 		return;
 
+	if (!debug_guardpage_minorder())
+		return;
+
 	_debug_guardpage_enabled = true;
 }
 
@@ -635,7 +641,7 @@ static int __init debug_guardpage_minord
 	pr_info("Setting debug_guardpage_minorder to %lu\n", res);
 	return 0;
 }
-__setup("debug_guardpage_minorder=", debug_guardpage_minorder_setup);
+early_param("debug_guardpage_minorder", debug_guardpage_minorder_setup);
 
 static inline bool set_page_guard(struct zone *zone, struct page *page,
 				unsigned int order, int migratetype)
_
