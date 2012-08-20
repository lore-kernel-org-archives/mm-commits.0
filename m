From: akpm@linux-foundation.org
Subject: [merged] slub-use-free_page-instead-of-put_page-for-freeing-kmalloc-allocation.patch removed from -mm tree
Date: Mon, 20 Aug 2012 12:56:38 -0700
Message-ID: <20120820195639.42FF220005C@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:45267 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab2HTT4l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 15:56:41 -0400
Received: by mail-lb0-f202.google.com with SMTP id ge1so313971lbb.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 12:56:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glommer@parallels.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: use free_page() instead of put_page() for freeing kmalloc() allocation
has been removed from the -mm tree.  Its filename was
     slub-use-free_page-instead-of-put_page-for-freeing-kmalloc-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: slub: use free_page() instead of put_page() for freeing kmalloc() allocation

When freeing objects, the slub allocator will most of the time freeing
empty pages by calling __free_pages().  But high-order kmalloc() will be
diposed by means of put_page() instead.  It makes no sense to call
put_page() against kernel pages that are provided by the object
allocators, so we shouldn't be doing this ourselves.  Aside from the
consistency change, we don't change the flow too much.  put_page()'s would
call its dtor function, which is __free_pages.  We also already do all of
the Compound page tests ourselves, and the Mlock test we lose don't really
matter.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slub.c~slub-use-free_page-instead-of-put_page-for-freeing-kmalloc-allocation mm/slub.c
--- a/mm/slub.c~slub-use-free_page-instead-of-put_page-for-freeing-kmalloc-allocation
+++ a/mm/slub.c
@@ -3477,7 +3477,7 @@ void kfree(const void *x)
 	if (unlikely(!PageSlab(page))) {
 		BUG_ON(!PageCompound(page));
 		kmemleak_free(x);
-		put_page(page);
+		__free_pages(page, compound_order(page));
 		return;
 	}
 	slab_free(page->slab, page, object, _RET_IP_);
_

Patches currently in -mm which might be from glommer@parallels.com are

linux-next.patch

