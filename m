From: akpm@linux-foundation.org
Subject: + mm-slubc-replace-cpu_slab-partial-with-wrapped-apis.patch
 added to -mm tree
Date: Mon, 17 Feb 2020 13:57:47 -0800
Message-ID: <20200217215747.fdMmM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729558AbgBQV5t (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 17 Feb 2020 16:57:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, penberg@kernel.org, iamjoonsoo.kim@lge.com, cl@linux.com, akpm@linux-foundation.org, chenqiwu@xiaomi.com


The patch titled
     Subject: mm/slub.c: replace cpu_slab->partial with wrapped APIs
has been added to the -mm tree.  Its filename is
     mm-slubc-replace-cpu_slab-partial-with-wrapped-apis.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slubc-replace-cpu_slab-partial-with-wrapped-apis.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slubc-replace-cpu_slab-partial-with-wrapped-apis.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: chenqiwu <chenqiwu@xiaomi.com>
Subject: mm/slub.c: replace cpu_slab->partial with wrapped APIs

There are slub_percpu_partial() and slub_set_percpu_partial() APIs to wrap
kmem_cache->cpu_partial.  This patch will use the two to replace
cpu_slab->partial in slub code.

Link: http://lkml.kernel.org/r/1581951895-3038-1-git-send-email-qiwuchen55@gmail.com
Signed-off-by: chenqiwu <chenqiwu@xiaomi.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/slub.c~mm-slubc-replace-cpu_slab-partial-with-wrapped-apis
+++ a/mm/slub.c
@@ -2207,11 +2207,11 @@ static void unfreeze_partials(struct kme
 	struct kmem_cache_node *n = NULL, *n2 = NULL;
 	struct page *page, *discard_page = NULL;
 
-	while ((page = c->partial)) {
+	while ((page = slub_percpu_partial(c))) {
 		struct page new;
 		struct page old;
 
-		c->partial = page->next;
+		slub_set_percpu_partial(c, page);
 
 		n2 = get_node(s, page_to_nid(page));
 		if (n != n2) {
_

Patches currently in -mm which might be from chenqiwu@xiaomi.com are

mm-slubc-replace-cpu_slab-partial-with-wrapped-apis.patch
