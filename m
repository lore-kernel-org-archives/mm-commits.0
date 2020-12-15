Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0088C2BB9A
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:14:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C86B224B2
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:14:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbgLODOU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:14:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:36826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728046AbgLODMl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:12:41 -0500
Date:   Mon, 14 Dec 2020 19:11:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001879;
        bh=2V0aWHd+HpvbqUbigniTNnRjaO/TilulSY1cerdprDg=;
        h=From:To:Subject:In-Reply-To:From;
        b=EbNsu40OczZTiXu5332A1Wmyg5q5fADzYvLPf25cXmAfVNjoHA/9T4FCu84zHDHG7
         CCAeVw3iyPWuz9FKJPR6Jz9GiR6k3iMtRL0tf+GzYtjKEvnmwrcVkpbbDnCP0j4bN1
         +8kESd8qJtM4amGNBNQO/wyP2uDkadhSIWh6L0Eo=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linf@wangsu.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 135/200] init/main: fix broken buffer_init when
 DEFERRED_STRUCT_PAGE_INIT set
Message-ID: <20201215031119.60LGvc0BJ%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Lin Feng <linf@wangsu.com>
Subject: init/main: fix broken buffer_init when DEFERRED_STRUCT_PAGE_INIT set

In the booting phase if CONFIG_DEFERRED_STRUCT_PAGE_INIT is set,
we have following callchain:

start_kernel
...
  mm_init
    mem_init
     memblock_free_all
       reset_all_zones_managed_pages
       free_low_memory_core_early
...
  buffer_init
    nr_free_buffer_pages
      zone->managed_pages
...
  rest_init
    kernel_init
      kernel_init_freeable
        page_alloc_init_late
          kthread_run(deferred_init_memmap, NODE_DATA(nid), "pgdatinit%d", nid);
          wait_for_completion(&pgdat_init_all_done_comp);
          ...
          files_maxfiles_init

It's clear that buffer_init depends on zone->managed_pages, but it's reset
in reset_all_zones_managed_pages after that pages are readded into
zone->managed_pages, but when buffer_init runs this process is half done
and most of them will finally be added till deferred_init_memmap done.  In
large memory couting of nr_free_buffer_pages drifts too much, also
drifting from kernels to kernels on same hardware.

Fix is simple, it delays buffer_init run till deferred_init_memmap all
done.

But as corrected by this patch, max_buffer_heads becomes very large, the
value is roughly as many as 4 times of totalram_pages, formula:
max_buffer_heads = nrpages * (10%) * (PAGE_SIZE / sizeof(struct
buffer_head));

Say in a 64GB memory box we have 16777216 pages, then max_buffer_heads
turns out to be roughly 67,108,864.  In common cases, should a buffer_head
be mapped to one page/block(4KB)?  So max_buffer_heads never exceeds
totalram_pages.  IMO it's likely to make buffer_heads_over_limit bool
value alwasy false, then make codes 'if (buffer_heads_over_limit)' test in
vmscan unnecessary.

So this patch will change the original behavior related to
buffer_heads_over_limit in vmscan since we used a half done value of
zone->managed_pages before, or should we use a smaller factor(<10%) in
previous formula.

akpm: I think this is OK - the max_buffer_heads code is only needed on
highmem machines, to prevent ZONE_NORMAL from being consumed by large
amounts of buffer_heads attached to highmem pagecache.  This problem will
not occur on 64-bit machines, so this feature's non-functionality on such
machines is a feature, not a bug.

Link: https://lkml.kernel.org/r/20201123110500.103523-1-linf@wangsu.com
Signed-off-by: Lin Feng <linf@wangsu.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c     |    2 --
 mm/page_alloc.c |    3 +++
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/init/main.c~init-main-fix-broken-buffer_init-when-deferred_struct_page_init-set
+++ a/init/main.c
@@ -58,7 +58,6 @@
 #include <linux/rmap.h>
 #include <linux/mempolicy.h>
 #include <linux/key.h>
-#include <linux/buffer_head.h>
 #include <linux/page_ext.h>
 #include <linux/debug_locks.h>
 #include <linux/debugobjects.h>
@@ -1036,7 +1035,6 @@ asmlinkage __visible void __init __no_sa
 	fork_init();
 	proc_caches_init();
 	uts_ns_init();
-	buffer_init();
 	key_init();
 	security_init();
 	dbg_late_init();
--- a/mm/page_alloc.c~init-main-fix-broken-buffer_init-when-deferred_struct_page_init-set
+++ a/mm/page_alloc.c
@@ -71,6 +71,7 @@
 #include <linux/psi.h>
 #include <linux/padata.h>
 #include <linux/khugepaged.h>
+#include <linux/buffer_head.h>
 
 #include <asm/sections.h>
 #include <asm/tlbflush.h>
@@ -2113,6 +2114,8 @@ void __init page_alloc_init_late(void)
 	files_maxfiles_init();
 #endif
 
+	buffer_init();
+
 	/* Discard memblock private memory */
 	memblock_discard();
 
_
