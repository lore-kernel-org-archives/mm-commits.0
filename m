From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 023/155] mm/slub.c: replace
 kmem_cache->cpu_partial with wrapped APIs
Date: Wed, 01 Apr 2020 21:04:19 -0700
Message-ID: <20200402040419.bP0XlMVpa%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgDBEEU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:04:20 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chenqiwu@xiaomi.com, cl@linux.com, iamjoonsoo.kim@lge.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com, torvalds@linux-foundation.org

From: chenqiwu <chenqiwu@xiaomi.com>
Subject: mm/slub.c: replace kmem_cache->cpu_partial with wrapped APIs

There are slub_cpu_partial() and slub_set_cpu_partial() APIs to wrap
kmem_cache->cpu_partial.  This patch will use the two APIs to replace
kmem_cache->cpu_partial in slub code.

Link: http://lkml.kernel.org/r/1582079562-17980-1-git-send-email-qiwuchen55@gmail.com
Signed-off-by: chenqiwu <chenqiwu@xiaomi.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/slub.c~mm-slubc-replace-kmem_cache-cpu_partial-with-wrapped-apis
+++ a/mm/slub.c
@@ -2282,7 +2282,7 @@ static void put_cpu_partial(struct kmem_
 		if (oldpage) {
 			pobjects = oldpage->pobjects;
 			pages = oldpage->pages;
-			if (drain && pobjects > s->cpu_partial) {
+			if (drain && pobjects > slub_cpu_partial(s)) {
 				unsigned long flags;
 				/*
 				 * partial array is full. Move the existing
@@ -2307,7 +2307,7 @@ static void put_cpu_partial(struct kmem_
 
 	} while (this_cpu_cmpxchg(s->cpu_slab->partial, oldpage, page)
 								!= oldpage);
-	if (unlikely(!s->cpu_partial)) {
+	if (unlikely(!slub_cpu_partial(s))) {
 		unsigned long flags;
 
 		local_irq_save(flags);
@@ -3512,15 +3512,15 @@ static void set_cpu_partial(struct kmem_
 	 *    50% to keep some capacity around for frees.
 	 */
 	if (!kmem_cache_has_cpu_partial(s))
-		s->cpu_partial = 0;
+		slub_set_cpu_partial(s, 0);
 	else if (s->size >= PAGE_SIZE)
-		s->cpu_partial = 2;
+		slub_set_cpu_partial(s, 2);
 	else if (s->size >= 1024)
-		s->cpu_partial = 6;
+		slub_set_cpu_partial(s, 6);
 	else if (s->size >= 256)
-		s->cpu_partial = 13;
+		slub_set_cpu_partial(s, 13);
 	else
-		s->cpu_partial = 30;
+		slub_set_cpu_partial(s, 30);
 #endif
 }
 
_
