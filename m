From: akpm@linux-foundation.org
Subject: +
 mm-debug_pagealloc-dont-allocate-page_ext-if-we-dont-use-guard-page.patch
 added to -mm tree
Date: Tue, 16 Aug 2016 13:41:36 -0700
Message-ID: <57b37a80.ZTOn4GKrV26SEk8j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37906 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbcHPUvy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Aug 2016 16:51:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, mhocko@kernel.org, minchan@kernel.org, sergey.senozhatsky@gmail.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug_pagealloc.c: don't allocate page_ext if we don't use guard page
has been added to the -mm tree.  Its filename is
     mm-debug_pagealloc-dont-allocate-page_ext-if-we-dont-use-guard-page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-debug_pagealloc-dont-allocate-page_ext-if-we-dont-use-guard-page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-debug_pagealloc-dont-allocate-page_ext-if-we-dont-use-guard-page.patch

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

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-debug_pagealloc-clean-up-guard-page-handling-code.patch
mm-debug_pagealloc-dont-allocate-page_ext-if-we-dont-use-guard-page.patch
mm-page_owner-move-page_owner-specific-function-to-page_ownerc.patch
mm-page_ext-rename-offset-to-index.patch
mm-page_ext-support-extra-space-allocation-by-page_ext-user.patch
mm-page_owner-dont-define-fields-on-struct-page_ext-by-hard-coding.patch

