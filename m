From: akpm@linux-foundation.org
Subject: +
 mm-slubc-replace-kmem_cache-cpu_partial-with-wrapped-apis.patch added to -mm
 tree
Date: Wed, 19 Feb 2020 11:53:03 -0800
Message-ID: <20200219195303.Qs2B6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726651AbgBSTxE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Feb 2020 14:53:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, penberg@kernel.org, iamjoonsoo.kim@lge.com, cl@linux.com, akpm@linux-foundation.org, chenqiwu@xiaomi.com


The patch titled
     Subject: mm/slub.c: replace kmem_cache->cpu_partial with wrapped APIs
has been added to the -mm tree.  Its filename is
     mm-slubc-replace-kmem_cache-cpu_partial-with-wrapped-apis.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slubc-replace-kmem_cache-cpu_partial-with-wrapped-apis.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slubc-replace-kmem_cache-cpu_partial-with-wrapped-apis.patch

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
@@ -2284,7 +2284,7 @@ static void put_cpu_partial(struct kmem_
 		if (oldpage) {
 			pobjects = oldpage->pobjects;
 			pages = oldpage->pages;
-			if (drain && pobjects > s->cpu_partial) {
+			if (drain && pobjects > slub_cpu_partial(s)) {
 				unsigned long flags;
 				/*
 				 * partial array is full. Move the existing
@@ -2309,7 +2309,7 @@ static void put_cpu_partial(struct kmem_
 
 	} while (this_cpu_cmpxchg(s->cpu_slab->partial, oldpage, page)
 								!= oldpage);
-	if (unlikely(!s->cpu_partial)) {
+	if (unlikely(!slub_cpu_partial(s))) {
 		unsigned long flags;
 
 		local_irq_save(flags);
@@ -3493,15 +3493,15 @@ static void set_cpu_partial(struct kmem_
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

Patches currently in -mm which might be from chenqiwu@xiaomi.com are

mm-slubc-replace-cpu_slab-partial-with-wrapped-apis.patch
mm-slubc-replace-kmem_cache-cpu_partial-with-wrapped-apis.patch
