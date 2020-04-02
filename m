From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 022/155] mm/slub.c: replace cpu_slab->partial with
 wrapped APIs
Date: Wed, 01 Apr 2020 21:04:16 -0700
Message-ID: <20200402040416.1PpRnkdgc%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgDBEER (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:04:17 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chenqiwu@xiaomi.com, cl@linux.com, iamjoonsoo.kim@lge.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com, torvalds@linux-foundation.org

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
@@ -2205,11 +2205,11 @@ static void unfreeze_partials(struct kme
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
