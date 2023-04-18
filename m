Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77056C6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 19:45:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232607AbjDRTpy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 15:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbjDRTpx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 15:45:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9FA259D8
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 12:45:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 510DC62C9C
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 19:45:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1950C433EF;
        Tue, 18 Apr 2023 19:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681847151;
        bh=ZAb1btrOBxjErwBp/xMPDg8M422L8dYMOdmecDClfzI=;
        h=Date:To:From:Subject:From;
        b=JmvKnk5IYiNM1FWT08udKMJxt9leig9AC36qXyYhfir8ohjVY8TYlsRGMTtpluDxk
         yTn6r/BWzegpeoYdb9/HwwN/dLVi677WKy08qW1dOES0qof0RbXLDvemF6Zyr70VHt
         lnUptf8uZdc7qb6zmFjU+4Vi1+cm/rjheZ46G8+0=
Date:   Tue, 18 Apr 2023 12:45:45 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        minchan@kernel.org, senozhatsky@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-allow-only-one-active-pool-compaction-context.patch added to mm-unstable branch
Message-Id: <20230418194551.A1950C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: allow only one active pool compaction context
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-allow-only-one-active-pool-compaction-context.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-allow-only-one-active-pool-compaction-context.patch

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
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zsmalloc: allow only one active pool compaction context
Date: Tue, 18 Apr 2023 16:46:39 +0900

zsmalloc pool can be compacted concurrently by many contexts,
e.g.

 cc1 handle_mm_fault()
      do_anonymous_page()
       __alloc_pages_slowpath()
        try_to_free_pages()
         do_try_to_free_pages(
          lru_gen_shrink_node()
           shrink_slab()
            do_shrink_slab()
             zs_shrinker_scan()
              zs_compact()

Pool compaction is currently (basically) single-threaded as
it is performed under pool->lock. Having multiple compaction
threads results in unnecessary contention, as each thread
competes for pool->lock. This, in turn, affects all zsmalloc
operations such as zs_malloc(), zs_map_object(), zs_free(), etc.

Introduce the pool->compaction_in_progress atomic variable,
which ensures that only one compaction context can run at a
time. This reduces overall pool->lock contention in (corner)
cases when many contexts attempt to shrink zspool simultaneously.

Link: https://lkml.kernel.org/r/20230418074639.1903197-1-senozhatsky@chromium.org
Fixes: c0547d0b6a4b ("zsmalloc: consolidate zs_pool's migrate_lock and size_class's locks")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/mm/zsmalloc.c~zsmalloc-allow-only-one-active-pool-compaction-context
+++ a/mm/zsmalloc.c
@@ -264,6 +264,7 @@ struct zs_pool {
 	struct work_struct free_work;
 #endif
 	spinlock_t lock;
+	atomic_t compaction_in_progress;
 };
 
 struct zspage {
@@ -2274,6 +2275,15 @@ unsigned long zs_compact(struct zs_pool
 	struct size_class *class;
 	unsigned long pages_freed = 0;
 
+	/*
+	 * Pool compaction is performed under pool->lock so it is basically
+	 * single-threaded. Having more than one thread in __zs_compact()
+	 * will increase pool->lock contention, which will impact other
+	 * zsmalloc operations that need pool->lock.
+	 */
+	if (atomic_xchg(&pool->compaction_in_progress, 1))
+		return 0;
+
 	for (i = ZS_SIZE_CLASSES - 1; i >= 0; i--) {
 		class = pool->size_class[i];
 		if (class->index != i)
@@ -2281,6 +2291,7 @@ unsigned long zs_compact(struct zs_pool
 		pages_freed += __zs_compact(pool, class);
 	}
 	atomic_long_add(pages_freed, &pool->stats.pages_compacted);
+	atomic_set(&pool->compaction_in_progress, 0);
 
 	return pages_freed;
 }
@@ -2388,6 +2399,7 @@ struct zs_pool *zs_create_pool(const cha
 
 	init_deferred_free(pool);
 	spin_lock_init(&pool->lock);
+	atomic_set(&pool->compaction_in_progress, 0);
 
 	pool->name = kstrdup(name, GFP_KERNEL);
 	if (!pool->name)
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zsmalloc-reset-compaction-source-zspage-pointer-after-putback_zspage.patch
zsmalloc-allow-only-one-active-pool-compaction-context.patch

