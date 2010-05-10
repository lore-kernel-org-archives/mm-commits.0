From: akpm@linux-foundation.org
Subject: + include-linux-gfph-fix-coding-style.patch added to -mm tree
Date: Mon, 10 May 2010 15:56:18 -0700
Message-ID: <201005102256.o4AMuIjB027749@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58910 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932834Ab0EJW4t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 May 2010 18:56:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mfmooney@gmail.com, error27@gmail.com, mfm@muteddisk.com


The patch titled
     include/linux/gfp.h: fix coding style
has been added to the -mm tree.  Its filename is
     include-linux-gfph-fix-coding-style.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: include/linux/gfp.h: fix coding style
From: matt mooney <mfmooney@gmail.com>

Add parenthesis in a define.  This doesn't change functionality.

checkpatch errors:
1) white space fixes
2) add spaces after comas

Signed-off-by: matt mooney <mfm@muteddisk.com>
Cc: Dan Carpenter <error27@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN include/linux/gfp.h~include-linux-gfph-fix-coding-style include/linux/gfp.h
--- a/include/linux/gfp.h~include-linux-gfph-fix-coding-style
+++ a/include/linux/gfp.h
@@ -101,7 +101,7 @@ struct vm_area_struct;
 			__GFP_NORETRY|__GFP_NOMEMALLOC)
 
 /* Control slab gfp mask during early boot */
-#define GFP_BOOT_MASK __GFP_BITS_MASK & ~(__GFP_WAIT|__GFP_IO|__GFP_FS)
+#define GFP_BOOT_MASK (__GFP_BITS_MASK & ~(__GFP_WAIT|__GFP_IO|__GFP_FS))
 
 /* Control allocation constraints */
 #define GFP_CONSTRAINT_MASK (__GFP_HARDWALL|__GFP_THISNODE)
@@ -187,7 +187,7 @@ static inline int allocflags_to_migratet
 
 #define GFP_ZONE_TABLE ( \
 	(ZONE_NORMAL << 0 * ZONES_SHIFT)				\
-	| (OPT_ZONE_DMA << __GFP_DMA * ZONES_SHIFT) 			\
+	| (OPT_ZONE_DMA << __GFP_DMA * ZONES_SHIFT)			\
 	| (OPT_ZONE_HIGHMEM << __GFP_HIGHMEM * ZONES_SHIFT)		\
 	| (OPT_ZONE_DMA32 << __GFP_DMA32 * ZONES_SHIFT)			\
 	| (ZONE_NORMAL << __GFP_MOVABLE * ZONES_SHIFT)			\
@@ -320,17 +320,17 @@ void *alloc_pages_exact(size_t size, gfp
 void free_pages_exact(void *virt, size_t size);
 
 #define __get_free_page(gfp_mask) \
-		__get_free_pages((gfp_mask),0)
+		__get_free_pages((gfp_mask), 0)
 
 #define __get_dma_pages(gfp_mask, order) \
-		__get_free_pages((gfp_mask) | GFP_DMA,(order))
+		__get_free_pages((gfp_mask) | GFP_DMA, (order))
 
 extern void __free_pages(struct page *page, unsigned int order);
 extern void free_pages(unsigned long addr, unsigned int order);
 extern void free_hot_cold_page(struct page *page, int cold);
 
 #define __free_page(page) __free_pages((page), 0)
-#define free_page(addr) free_pages((addr),0)
+#define free_page(addr) free_pages((addr), 0)
 
 void page_alloc_init(void);
 void drain_zone_pages(struct zone *zone, struct per_cpu_pages *pcp);
_

Patches currently in -mm which might be from mfmooney@gmail.com are

include-linux-gfph-spelling-fixes.patch
include-linux-gfph-fix-coding-style.patch

