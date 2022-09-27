Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41B84C6FA82
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:51:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbiI0CvF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230324AbiI0CtB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:49:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05DF9ABD66
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:48:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B27761574
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:48:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 701BAC433D7;
        Tue, 27 Sep 2022 02:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246913;
        bh=hR/e21OdEDsiNXhMVPVrZX85Gy8gyL36ety2wOXU3IE=;
        h=Date:To:From:Subject:From;
        b=TGGSGtAcz4L+5S4LmBoyDBm4pWK/qiRTndQa8F9aAmc/e7GCHvmlC+EJjulwe7kSL
         CiFKWyQ5oeA/rsawQ9ryZhvfF+4gm8FuPIT8M90PJQBKmfID7LTG01JIaTl//Pco8s
         pRlAIluSISDEflFFBf2viLv+TXsaTVEH41dJKv9k=
Date:   Mon, 26 Sep 2022 19:48:32 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        will@kernel.org, vbabka@suse.cz, svens@linux.ibm.com,
        sj@kernel.org, dhowells@redhat.com, david@redhat.com,
        dave@stgolabs.net, catalin.marinas@arm.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] radix-tree-test-suite-add-allocation-counts-and-size-to-kmem_cache.patch removed from -mm tree
Message-Id: <20220927024833.701BAC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: radix tree test suite: add allocation counts and size to kmem_cache
has been removed from the -mm tree.  Its filename was
     radix-tree-test-suite-add-allocation-counts-and-size-to-kmem_cache.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: radix tree test suite: add allocation counts and size to kmem_cache
Date: Tue, 6 Sep 2022 19:48:40 +0000

Add functions to get the number of allocations, and total allocations from
a kmem_cache.  Also add a function to get the allocated size and a way to
zero the total allocations.

Link: https://lkml.kernel.org/r/20220906194824.2110408-5-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Tested-by: Yu Zhao <yuzhao@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/linux.c |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

--- a/tools/testing/radix-tree/linux.c~radix-tree-test-suite-add-allocation-counts-and-size-to-kmem_cache
+++ a/tools/testing/radix-tree/linux.c
@@ -24,6 +24,8 @@ struct kmem_cache {
 	void *objs;
 	void (*ctor)(void *);
 	unsigned int non_kernel;
+	unsigned long nr_allocated;
+	unsigned long nr_tallocated;
 };
 
 void kmem_cache_set_non_kernel(struct kmem_cache *cachep, unsigned int val)
@@ -31,9 +33,28 @@ void kmem_cache_set_non_kernel(struct km
 	cachep->non_kernel = val;
 }
 
+unsigned long kmem_cache_get_alloc(struct kmem_cache *cachep)
+{
+	return cachep->size * cachep->nr_allocated;
+}
+
+unsigned long kmem_cache_nr_allocated(struct kmem_cache *cachep)
+{
+	return cachep->nr_allocated;
+}
+
+unsigned long kmem_cache_nr_tallocated(struct kmem_cache *cachep)
+{
+	return cachep->nr_tallocated;
+}
+
+void kmem_cache_zero_nr_tallocated(struct kmem_cache *cachep)
+{
+	cachep->nr_tallocated = 0;
+}
+
 void *kmem_cache_alloc_lru(struct kmem_cache *cachep, struct list_lru *lru,
 		int gfp)
-
 {
 	void *p;
 
@@ -64,7 +85,9 @@ void *kmem_cache_alloc_lru(struct kmem_c
 			memset(p, 0, cachep->size);
 	}
 
+	uatomic_inc(&cachep->nr_allocated);
 	uatomic_inc(&nr_allocated);
+	uatomic_inc(&cachep->nr_tallocated);
 	if (kmalloc_verbose)
 		printf("Allocating %p from slab\n", p);
 	return p;
@@ -74,6 +97,7 @@ void kmem_cache_free(struct kmem_cache *
 {
 	assert(objp);
 	uatomic_dec(&nr_allocated);
+	uatomic_dec(&cachep->nr_allocated);
 	if (kmalloc_verbose)
 		printf("Freeing %p to slab\n", objp);
 	pthread_mutex_lock(&cachep->lock);
@@ -99,6 +123,8 @@ kmem_cache_create(const char *name, unsi
 	ret->size = size;
 	ret->align = align;
 	ret->nr_objs = 0;
+	ret->nr_allocated = 0;
+	ret->nr_tallocated = 0;
 	ret->objs = NULL;
 	ret->ctor = ctor;
 	ret->non_kernel = 0;
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


