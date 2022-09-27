Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0F64C32771
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:51:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbiI0CvC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbiI0CtB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:49:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA4C2ABD5A
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:48:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D03CB81914
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:48:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B5C1C433D6;
        Tue, 27 Sep 2022 02:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246912;
        bh=OZOg+R6VrnZFx3wqZaC0FqtzuUGYfAsCVL10og+5M0A=;
        h=Date:To:From:Subject:From;
        b=XY+a3cuDaALqhUgJkjmTBsi8+fyxNRSfxgqqrxTsQCmgfD4a0OAMZRYntOvDmeHEB
         gL2sY5F2BewG4tJiO79gmBa215A40rOZwgYd9/T50EEpVAwdESWnzqYuG9Kkobyplm
         RhRoc2wPFtm9aeOodhRW7YvZbB+7lqW4To9vU414=
Date:   Mon, 26 Sep 2022 19:48:31 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        will@kernel.org, vbabka@suse.cz, svens@linux.ibm.com,
        sj@kernel.org, dhowells@redhat.com, david@redhat.com,
        dave@stgolabs.net, catalin.marinas@arm.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] radix-tree-test-suite-add-kmem_cache_set_non_kernel.patch removed from -mm tree
Message-Id: <20220927024832.1B5C1C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: radix tree test suite: add kmem_cache_set_non_kernel()
has been removed from the -mm tree.  Its filename was
     radix-tree-test-suite-add-kmem_cache_set_non_kernel.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: radix tree test suite: add kmem_cache_set_non_kernel()
Date: Tue, 6 Sep 2022 19:48:40 +0000

kmem_cache_set_non_kernel() is a mechanism to allow a certain number of
kmem_cache_alloc requests to succeed even when GFP_KERNEL is not set in
the flags.  This functionality allows for testing different paths though
the code.

Link: https://lkml.kernel.org/r/20220906194824.2110408-4-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Tested-by: Yu Zhao <yuzhao@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/linux.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/tools/testing/radix-tree/linux.c~radix-tree-test-suite-add-kmem_cache_set_non_kernel
+++ a/tools/testing/radix-tree/linux.c
@@ -23,15 +23,26 @@ struct kmem_cache {
 	int nr_objs;
 	void *objs;
 	void (*ctor)(void *);
+	unsigned int non_kernel;
 };
 
+void kmem_cache_set_non_kernel(struct kmem_cache *cachep, unsigned int val)
+{
+	cachep->non_kernel = val;
+}
+
 void *kmem_cache_alloc_lru(struct kmem_cache *cachep, struct list_lru *lru,
 		int gfp)
+
 {
 	void *p;
 
-	if (!(gfp & __GFP_DIRECT_RECLAIM))
-		return NULL;
+	if (!(gfp & __GFP_DIRECT_RECLAIM)) {
+		if (!cachep->non_kernel)
+			return NULL;
+
+		cachep->non_kernel--;
+	}
 
 	pthread_mutex_lock(&cachep->lock);
 	if (cachep->nr_objs) {
@@ -90,5 +101,6 @@ kmem_cache_create(const char *name, unsi
 	ret->nr_objs = 0;
 	ret->objs = NULL;
 	ret->ctor = ctor;
+	ret->non_kernel = 0;
 	return ret;
 }
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


