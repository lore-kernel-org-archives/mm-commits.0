From: akpm@linux-foundation.org
Subject: + vmalloc-adjust-gfp-mask-passed-on-nested-vmalloc-invocation.patch added to -mm tree
Date: Tue, 13 Oct 2009 14:28:52 -0700
Message-ID: <200910132128.n9DLSqjp013895@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34544 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753063AbZJMVaV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Oct 2009 17:30:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: JBeulich@novell.com, hugh.dickins@tiscali.co.uk, jbeulich@novell.com, nickpiggin@yahoo.com.au


The patch titled
     vmalloc(): adjust gfp mask passed on nested vmalloc() invocation
has been added to the -mm tree.  Its filename is
     vmalloc-adjust-gfp-mask-passed-on-nested-vmalloc-invocation.patch

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
Subject: vmalloc(): adjust gfp mask passed on nested vmalloc() invocation
From: "Jan Beulich" <JBeulich@novell.com>

- avoid wasting more precious resources (DMA or DMA32 pools), when
  being called through vmalloc_32{,_user}()
- explicitly allow using high memory here even if the outer allocation
  request doesn't allow it

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN mm/vmalloc.c~vmalloc-adjust-gfp-mask-passed-on-nested-vmalloc-invocation mm/vmalloc.c
--- a/mm/vmalloc.c~vmalloc-adjust-gfp-mask-passed-on-nested-vmalloc-invocation
+++ a/mm/vmalloc.c
@@ -1411,6 +1411,7 @@ static void *__vmalloc_area_node(struct 
 {
 	struct page **pages;
 	unsigned int nr_pages, array_size, i;
+	gfp_t nested_gfp = (gfp_mask & GFP_RECLAIM_MASK) | __GFP_ZERO;
 
 	nr_pages = (area->size - PAGE_SIZE) >> PAGE_SHIFT;
 	array_size = (nr_pages * sizeof(struct page *));
@@ -1418,13 +1419,11 @@ static void *__vmalloc_area_node(struct 
 	area->nr_pages = nr_pages;
 	/* Please note that the recursion is strictly bounded. */
 	if (array_size > PAGE_SIZE) {
-		pages = __vmalloc_node(array_size, 1, gfp_mask | __GFP_ZERO,
+		pages = __vmalloc_node(array_size, 1, nested_gfp|__GFP_HIGHMEM,
 				PAGE_KERNEL, node, caller);
 		area->flags |= VM_VPAGES;
 	} else {
-		pages = kmalloc_node(array_size,
-				(gfp_mask & GFP_RECLAIM_MASK) | __GFP_ZERO,
-				node);
+		pages = kmalloc_node(array_size, nested_gfp, node);
 	}
 	area->pages = pages;
 	area->caller = caller;
_

Patches currently in -mm which might be from JBeulich@novell.com are

linux-next.patch
kbuild-generate-modulesbuiltin.patch
kbuild-rebuild-fix-for-makefilemodbuiltin.patch
drm-make-sure-page-protections-are-updated-after-changing-vm_flags.patch
vmalloc-adjust-gfp-mask-passed-on-nested-vmalloc-invocation.patch

