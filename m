From: akpm@linux-foundation.org
Subject: + slab-do-not-call-compound_head-in-page_get_cache.patch added to -mm tree
Date: Thu, 21 Jun 2012 16:48:32 -0700
Message-ID: <20120621234832.9F8D4A020E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:42624 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760553Ab2FUXsf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jun 2012 19:48:35 -0400
Received: by bkty5 with SMTP id y5so70907bkt.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Jun 2012 16:48:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, cl@linux-foundation.org, penberg@kernel.org, rientjes@google.com


The patch titled
     Subject: slab: do not call compound_head() in page_get_cache()
has been added to the -mm tree.  Its filename is
     slab-do-not-call-compound_head-in-page_get_cache.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: slab: do not call compound_head() in page_get_cache()

page_get_cache() does not need to call compound_head(), as its unique
caller virt_to_slab() already makes sure to return a head page.

Additionally, removing the compound_head() call makes page_get_cache()
consistent with page_get_slab().

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/slab.c~slab-do-not-call-compound_head-in-page_get_cache mm/slab.c
--- a/mm/slab.c~slab-do-not-call-compound_head-in-page_get_cache
+++ a/mm/slab.c
@@ -485,7 +485,6 @@ static bool slab_max_order_set __initdat
 
 static inline struct kmem_cache *page_get_cache(struct page *page)
 {
-	page = compound_head(page);
 	BUG_ON(!PageSlab(page));
 	return page->slab_cache;
 }
_
Subject: Subject: slab: do not call compound_head() in page_get_cache()

Patches currently in -mm which might be from walken@google.com are

slab-do-not-call-compound_head-in-page_get_cache.patch

