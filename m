From: akpm@linux-foundation.org
Subject: + page-allocator-inlnie-some-__alloc_pages-wrappers.patch added to -mm tree
Date: Mon, 05 May 2008 16:05:08 -0700
Message-ID: <200805052305.m45N58A9009930@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57707 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752057AbYEEXGf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2008 19:06:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, mel@csn.ul.ie


The patch titled
     page allocator: inlnie some __alloc_pages() wrappers
has been added to the -mm tree.  Its filename is
     page-allocator-inlnie-some-__alloc_pages-wrappers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page allocator: inlnie some __alloc_pages() wrappers
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Two zonelist patch series rewrote __page_alloc() largely.  Now, it is just
a wrapper function.  Inlining them will save a function call.

Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |   21 +++++++++++++++++----
 mm/page_alloc.c     |   18 +-----------------
 2 files changed, 18 insertions(+), 21 deletions(-)

diff -puN include/linux/gfp.h~page-allocator-inlnie-some-__alloc_pages-wrappers include/linux/gfp.h
--- a/include/linux/gfp.h~page-allocator-inlnie-some-__alloc_pages-wrappers
+++ a/include/linux/gfp.h
@@ -174,11 +174,24 @@ static inline void arch_free_page(struct
 static inline void arch_alloc_page(struct page *page, int order) { }
 #endif
 
-extern struct page *__alloc_pages(gfp_t, unsigned int, struct zonelist *);
+struct page *
+__alloc_pages_internal(gfp_t gfp_mask, unsigned int order,
+		       struct zonelist *zonelist, nodemask_t *nodemask);
+
+static inline struct page *
+__alloc_pages(gfp_t gfp_mask, unsigned int order,
+		struct zonelist *zonelist)
+{
+	return __alloc_pages_internal(gfp_mask, order, zonelist, NULL);
+}
+
+static inline struct page *
+__alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
+		struct zonelist *zonelist, nodemask_t *nodemask)
+{
+	return __alloc_pages_internal(gfp_mask, order, zonelist, nodemask);
+}
 
-extern struct page *
-__alloc_pages_nodemask(gfp_t, unsigned int,
-				struct zonelist *, nodemask_t *nodemask);
 
 static inline struct page *alloc_pages_node(int nid, gfp_t gfp_mask,
 						unsigned int order)
diff -puN mm/page_alloc.c~page-allocator-inlnie-some-__alloc_pages-wrappers mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-inlnie-some-__alloc_pages-wrappers
+++ a/mm/page_alloc.c
@@ -1460,7 +1460,7 @@ try_next_zone:
 /*
  * This is the 'heart' of the zoned buddy allocator.
  */
-static struct page *
+struct page *
 __alloc_pages_internal(gfp_t gfp_mask, unsigned int order,
 			struct zonelist *zonelist, nodemask_t *nodemask)
 {
@@ -1667,22 +1667,6 @@ got_pg:
 	return page;
 }
 
-struct page *
-__alloc_pages(gfp_t gfp_mask, unsigned int order,
-		struct zonelist *zonelist)
-{
-	return __alloc_pages_internal(gfp_mask, order, zonelist, NULL);
-}
-
-struct page *
-__alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
-		struct zonelist *zonelist, nodemask_t *nodemask)
-{
-	return __alloc_pages_internal(gfp_mask, order, zonelist, nodemask);
-}
-
-EXPORT_SYMBOL(__alloc_pages);
