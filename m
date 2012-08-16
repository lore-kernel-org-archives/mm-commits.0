From: akpm@linux-foundation.org
Subject: + mm-slab-remove-page_get_cache.patch added to -mm tree
Date: Thu, 16 Aug 2012 12:27:02 -0700
Message-ID: <20120816192702.9AD741E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:64716 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab2HPT1E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Aug 2012 15:27:04 -0400
Received: by obbwc20 with SMTP id wc20so2175612obb.1
        for <mm-commits@vger.kernel.org>; Thu, 16 Aug 2012 12:27:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, penberg@kernel.org


The patch titled
     Subject: mm/slab.c: remove page_get_cache
has been added to the -mm tree.  Its filename is
     mm-slab-remove-page_get_cache.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm/slab.c: remove page_get_cache

page_get_cache() isn't called from anything, so remove it.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN mm/slab.c~mm-slab-remove-page_get_cache mm/slab.c
--- a/mm/slab.c~mm-slab-remove-page_get_cache
+++ a/mm/slab.c
@@ -515,12 +515,6 @@ EXPORT_SYMBOL(slab_buffer_size);
 static int slab_max_order = SLAB_MAX_ORDER_LO;
 static bool slab_max_order_set __initdata;
 
-static inline struct kmem_cache *page_get_cache(struct page *page)
-{
-	BUG_ON(!PageSlab(page));
-	return page->slab_cache;
-}
