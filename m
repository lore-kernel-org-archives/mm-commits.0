Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77D2AC4167B
	for <mm-commits@archiver.kernel.org>; Mon,  6 Nov 2023 17:28:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbjKFR2I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Nov 2023 12:28:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232924AbjKFR2H (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Nov 2023 12:28:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A48E2D49
        for <mm-commits@vger.kernel.org>; Mon,  6 Nov 2023 09:28:04 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E9E6C433C8;
        Mon,  6 Nov 2023 17:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699291684;
        bh=6gegyPzLa/5kOVxkUeQjmcuL1lEHHxCgiJNjMKJW6rA=;
        h=Date:To:From:Subject:From;
        b=sE9mmre11xU6qlbaxZjunHXtxs89QRgS+TiB9hkr0fR0g1S57Gh+IvVDdJMWUzzxi
         09sOLSI4SYmQnG8XO22Aqv/HFAhG9iBWi1DR9Ekl0OSgjfRV/ickwsgfBcq/1VF/1V
         XX1NarDFxoynmvpfHSYZIqGc1NbERzjv4BNj75mQ=
Date:   Mon, 06 Nov 2023 09:28:03 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, surenb@google.com,
        peterz@infradead.org, npiggin@gmail.com, mst@redhat.com,
        mjguzik@gmail.com, michael.christie@oracle.com,
        mathieu.desnoyers@efficios.com, Liam.Howlett@oracle.com,
        corbet@lwn.net, brauner@kernel.org, zhangpeng.00@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + radix-tree-test-suite-align-kmem_cache_alloc_bulk-with-kernel-behavior.patch added to mm-unstable branch
Message-Id: <20231106172804.3E9E6C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: radix tree test suite: align kmem_cache_alloc_bulk() with kernel behavior.
has been added to the -mm mm-unstable branch.  Its filename is
     radix-tree-test-suite-align-kmem_cache_alloc_bulk-with-kernel-behavior.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/radix-tree-test-suite-align-kmem_cache_alloc_bulk-with-kernel-behavior.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Peng Zhang <zhangpeng.00@bytedance.com>
Subject: radix tree test suite: align kmem_cache_alloc_bulk() with kernel behavior.
Date: Fri, 27 Oct 2023 11:38:39 +0800

When kmem_cache_alloc_bulk() fails to allocate, leave the freed pointers
in the array.  This enables a more accurate simulation of the kernel's
behavior and allows for testing potential double-free scenarios.

Link: https://lkml.kernel.org/r/20231027033845.90608-5-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/linux.c |   45 +++++++++++++++++++++--------
 1 file changed, 33 insertions(+), 12 deletions(-)

--- a/tools/testing/radix-tree/linux.c~radix-tree-test-suite-align-kmem_cache_alloc_bulk-with-kernel-behavior
+++ a/tools/testing/radix-tree/linux.c
@@ -93,13 +93,9 @@ void *kmem_cache_alloc_lru(struct kmem_c
 	return p;
 }
 
-void kmem_cache_free_locked(struct kmem_cache *cachep, void *objp)
+void __kmem_cache_free_locked(struct kmem_cache *cachep, void *objp)
 {
 	assert(objp);
-	uatomic_dec(&nr_allocated);
-	uatomic_dec(&cachep->nr_allocated);
-	if (kmalloc_verbose)
-		printf("Freeing %p to slab\n", objp);
 	if (cachep->nr_objs > 10 || cachep->align) {
 		memset(objp, POISON_FREE, cachep->size);
 		free(objp);
@@ -111,6 +107,15 @@ void kmem_cache_free_locked(struct kmem_
 	}
 }
 
+void kmem_cache_free_locked(struct kmem_cache *cachep, void *objp)
+{
+	uatomic_dec(&nr_allocated);
+	uatomic_dec(&cachep->nr_allocated);
+	if (kmalloc_verbose)
+		printf("Freeing %p to slab\n", objp);
+	__kmem_cache_free_locked(cachep, objp);
+}
+
 void kmem_cache_free(struct kmem_cache *cachep, void *objp)
 {
 	pthread_mutex_lock(&cachep->lock);
@@ -141,18 +146,17 @@ int kmem_cache_alloc_bulk(struct kmem_ca
 	if (kmalloc_verbose)
 		pr_debug("Bulk alloc %lu\n", size);
 
-	if (!(gfp & __GFP_DIRECT_RECLAIM)) {
-		if (cachep->non_kernel < size)
-			return 0;
-
-		cachep->non_kernel -= size;
-	}
-
 	pthread_mutex_lock(&cachep->lock);
 	if (cachep->nr_objs >= size) {
 		struct radix_tree_node *node;
 
 		for (i = 0; i < size; i++) {
+			if (!(gfp & __GFP_DIRECT_RECLAIM)) {
+				if (!cachep->non_kernel)
+					break;
+				cachep->non_kernel--;
+			}
+
 			node = cachep->objs;
 			cachep->nr_objs--;
 			cachep->objs = node->parent;
@@ -163,11 +167,19 @@ int kmem_cache_alloc_bulk(struct kmem_ca
 	} else {
 		pthread_mutex_unlock(&cachep->lock);
 		for (i = 0; i < size; i++) {
+			if (!(gfp & __GFP_DIRECT_RECLAIM)) {
+				if (!cachep->non_kernel)
+					break;
+				cachep->non_kernel--;
+			}
+
 			if (cachep->align) {
 				posix_memalign(&p[i], cachep->align,
 					       cachep->size);
 			} else {
 				p[i] = malloc(cachep->size);
+				if (!p[i])
+					break;
 			}
 			if (cachep->ctor)
 				cachep->ctor(p[i]);
@@ -176,6 +188,15 @@ int kmem_cache_alloc_bulk(struct kmem_ca
 		}
 	}
 
+	if (i < size) {
+		size = i;
+		pthread_mutex_lock(&cachep->lock);
+		for (i = 0; i < size; i++)
+			__kmem_cache_free_locked(cachep, p[i]);
+		pthread_mutex_unlock(&cachep->lock);
+		return 0;
+	}
+
 	for (i = 0; i < size; i++) {
 		uatomic_inc(&nr_allocated);
 		uatomic_inc(&cachep->nr_allocated);
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are

maple_tree-add-mt_free_one-and-mt_attr-helpers.patch
maple_tree-introduce-mtreemas_lock_nested.patch
maple_tree-introduce-interfaces-__mt_dup-and-mtree_dup.patch
radix-tree-test-suite-align-kmem_cache_alloc_bulk-with-kernel-behavior.patch
maple_tree-add-test-for-mtree_dup.patch
maple_tree-update-the-documentation-of-maple-tree.patch
maple_tree-skip-other-tests-when-bench-is-enabled.patch
maple_tree-update-check_forking-and-bench_forking.patch
maple_tree-preserve-the-tree-attributes-when-destroying-maple-tree.patch
fork-use-__mt_dup-to-duplicate-maple-tree-in-dup_mmap.patch

