From: akpm@linux-foundation.org
Subject: + slub-use-free_page-instead-of-put_page-for-freeing-kmalloc-allocation.patch added to -mm tree
Date: Wed, 15 Aug 2012 15:50:07 -0700
Message-ID: <20120815225008.3319120004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:63879 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab2HOWuL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Aug 2012 18:50:11 -0400
Received: by wibhr14 with SMTP id hr14so3730wib.1
        for <mm-commits@vger.kernel.org>; Wed, 15 Aug 2012 15:50:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: glommer@parallels.com, cl@linux.com, penberg@kernel.org, rientjes@google.com


The patch titled
     Subject: slub: use free_page() instead of put_page() for freeing kmalloc() allocation
has been added to the -mm tree.  Its filename is
     slub-use-free_page-instead-of-put_page-for-freeing-kmalloc-allocation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

slub-use-free_page-instead-of-put_page-for-freeing-kmalloc-allocation.patch

