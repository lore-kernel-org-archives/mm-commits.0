From: akpm@linux-foundation.org
Subject: [merged]
 mm-slubc-replace-cpu_slab-partial-with-wrapped-apis.patch removed from -mm
 tree
Date: Fri, 03 Apr 2020 13:35:46 -0700
Message-ID: <20200403203546.CA2GEeBjS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgDCUfr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:35:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chenqiwu@xiaomi.com, cl@linux.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com


The patch titled
     Subject: mm/slub.c: replace cpu_slab->partial with wrapped APIs
has been removed from the -mm tree.  Its filename was
     mm-slubc-replace-cpu_slab-partial-with-wrapped-apis.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from chenqiwu@xiaomi.com are

mm-memory_hotplug-use-__pfn_to_section-instead-of-open-coding.patch
mm-fix-ambiguous-comments-for-better-code-readability.patch
lib-rbtree-fix-coding-style-of-assignments.patch
