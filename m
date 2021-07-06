Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A877DC07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:08:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 928DE61C81
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:08:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231727AbhGFTLf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:11:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:46262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231700AbhGFTLe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:11:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97B3E61C85;
        Tue,  6 Jul 2021 19:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598535;
        bh=Yl4sjQ2hmkXPDI46LsFGVBUqaVpPq2R4JqiCeEruhT0=;
        h=Date:From:To:Subject:From;
        b=S2V8f9svTsZUReZaJz1I86N4yIn99kAsIFV9c+m3NvUO3Qo9vugiezRYe+GB1WaT7
         OpMbbmGu3Vb12gX1bYhSVBKLC58bZhY6hi667IzSN3ehes7pSJ5pzmoU54rS4FsH+J
         skZM4V3hrzeNJsbDPKmNFK1ASgIciqSUL8pldGLw=
Date:   Tue, 06 Jul 2021 12:08:55 -0700
From:   akpm@linux-foundation.org
To:     brendanhiggins@google.com, cl@linux.com, dlatypov@google.com,
        elver@google.com, glittao@gmail.com, iamjoonsoo.kim@lge.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz
Subject:  [merged] kunit-make-test-lock-irq-safe.patch removed from
 -mm tree
Message-ID: <20210706190855.t9u8ugDAv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kunit: make test->lock irq safe
has been removed from the -mm tree.  Its filename was
     kunit-make-test-lock-irq-safe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: kunit: make test->lock irq safe

The upcoming SLUB kunit test will be calling kunit_find_named_resource()
from a context with disabled interrupts.  That means kunit's test->lock
needs to be IRQ safe to avoid potential deadlocks and lockdep splats.

This patch therefore changes the test->lock usage to spin_lock_irqsave()
and spin_unlock_irqrestore().

Link: https://lkml.kernel.org/r/20210511150734.3492-1-glittao@gmail.com
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Oliver Glitta <glittao@gmail.com>
Reviewed-by: Brendan Higgins <brendanhiggins@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Daniel Latypov <dlatypov@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Marco Elver <elver@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/kunit/test.h |    5 +++--
 lib/kunit/test.c     |   18 +++++++++++-------
 2 files changed, 14 insertions(+), 9 deletions(-)

--- a/include/kunit/test.h~kunit-make-test-lock-irq-safe
+++ a/include/kunit/test.h
@@ -515,8 +515,9 @@ kunit_find_resource(struct kunit *test,
 		    void *match_data)
 {
 	struct kunit_resource *res, *found = NULL;
+	unsigned long flags;
 
-	spin_lock(&test->lock);
+	spin_lock_irqsave(&test->lock, flags);
 
 	list_for_each_entry_reverse(res, &test->resources, node) {
 		if (match(test, res, (void *)match_data)) {
@@ -526,7 +527,7 @@ kunit_find_resource(struct kunit *test,
 		}
 	}
 
-	spin_unlock(&test->lock);
+	spin_unlock_irqrestore(&test->lock, flags);
 
 	return found;
 }
--- a/lib/kunit/test.c~kunit-make-test-lock-irq-safe
+++ a/lib/kunit/test.c
@@ -475,6 +475,7 @@ int kunit_add_resource(struct kunit *tes
 		       void *data)
 {
 	int ret = 0;
+	unsigned long flags;
 
 	res->free = free;
 	kref_init(&res->refcount);
@@ -487,10 +488,10 @@ int kunit_add_resource(struct kunit *tes
 		res->data = data;
 	}
 
-	spin_lock(&test->lock);
+	spin_lock_irqsave(&test->lock, flags);
 	list_add_tail(&res->node, &test->resources);
 	/* refcount for list is established by kref_init() */
-	spin_unlock(&test->lock);
+	spin_unlock_irqrestore(&test->lock, flags);
 
 	return ret;
 }
@@ -548,9 +549,11 @@ EXPORT_SYMBOL_GPL(kunit_alloc_and_get_re
 
 void kunit_remove_resource(struct kunit *test, struct kunit_resource *res)
 {
-	spin_lock(&test->lock);
+	unsigned long flags;
+
+	spin_lock_irqsave(&test->lock, flags);
 	list_del(&res->node);
-	spin_unlock(&test->lock);
+	spin_unlock_irqrestore(&test->lock, flags);
 	kunit_put_resource(res);
 }
 EXPORT_SYMBOL_GPL(kunit_remove_resource);
@@ -630,6 +633,7 @@ EXPORT_SYMBOL_GPL(kunit_kfree);
 void kunit_cleanup(struct kunit *test)
 {
 	struct kunit_resource *res;
+	unsigned long flags;
 
 	/*
 	 * test->resources is a stack - each allocation must be freed in the
@@ -641,9 +645,9 @@ void kunit_cleanup(struct kunit *test)
 	 * protect against the current node being deleted, not the next.
 	 */
 	while (true) {
-		spin_lock(&test->lock);
+		spin_lock_irqsave(&test->lock, flags);
 		if (list_empty(&test->resources)) {
-			spin_unlock(&test->lock);
+			spin_unlock_irqrestore(&test->lock, flags);
 			break;
 		}
 		res = list_last_entry(&test->resources,
@@ -654,7 +658,7 @@ void kunit_cleanup(struct kunit *test)
 		 * resource, and this can't happen if the test->lock
 		 * is held.
 		 */
-		spin_unlock(&test->lock);
+		spin_unlock_irqrestore(&test->lock, flags);
 		kunit_remove_resource(test, res);
 	}
 	current->kunit_test = NULL;
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-slub-use-stackdepot-to-save-stack-trace-in-objects-fix-2.patch

