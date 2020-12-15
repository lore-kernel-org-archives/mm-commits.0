Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08108C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C81EE22DA9
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbgLOX70 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:32826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728372AbgLOXXd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:23:33 -0500
Date:   Tue, 15 Dec 2020 15:22:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074523;
        bh=rgm3afQcxJ928o0tiBKM8ukYm5gSpvdJSX+ztwpWN4k=;
        h=From:To:Subject:From;
        b=06yJ7Z7GLnKQLtjJ9ZxC4ijM8bubHmx0t4eWnaNFBWMuFzESo2qzBMTKLRyax5AEC
         KZ7BWGiqAb1Hxhp/8p8gG51Djhu5Ur1lidQ6C6BAprrVEI2KzssR9zQt0oWkCMjyJV
         XNHWXQHYqIj+W8kuODClITI3y5jaufYNxfTC3rmE=
From:   akpm@linux-foundation.org
To:     linf@wangsu.com, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, vbabka@suse.cz
Subject:  [merged]
 init-main-fix-broken-buffer_init-when-deferred_struct_page_init-set.patch
 removed from -mm tree
Message-ID: <20201215232203.ACEdjJc7K%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: init/main: fix broken buffer_init when DEFERRED_STRUCT_PAGE_INIT set
has been removed from the -mm tree.  Its filename was
     init-main-fix-broken-buffer_init-when-deferred_struct_page_init-set.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from linf@wangsu.com are


