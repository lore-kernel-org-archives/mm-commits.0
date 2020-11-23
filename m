Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DD7AC64E7A
	for <mm-commits@archiver.kernel.org>; Mon, 23 Nov 2020 20:09:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 056EE20724
	for <mm-commits@archiver.kernel.org>; Mon, 23 Nov 2020 20:09:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YUF/eq8a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729245AbgKWUIb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 23 Nov 2020 15:08:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:34598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729407AbgKWUIb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 23 Nov 2020 15:08:31 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10B3B20717;
        Mon, 23 Nov 2020 20:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606162109;
        bh=m1vCiNpLrtN5XmnnGsy8Yjj46Chzk+kvjpB+RNCZa+c=;
        h=Date:From:To:Subject:From;
        b=YUF/eq8aKh92OV4Id8n2bXSkKRl/pMSTKPijmo++02dR+DYW32l5OXnpBkHHTvQIA
         LwzxQOWN4HM4bN+eoM/ZoDIyJLPMjPGRoHYbIgn1a2j0UAu9Yhlsb+kuowAsrJAF8b
         8QrEvbNRnKBRirgIoTifry21ntmDemJC/oCK06o8=
Date:   Mon, 23 Nov 2020 12:08:28 -0800
From:   akpm@linux-foundation.org
To:     linf@wangsu.com, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org
Subject:  +
 init-main-fix-broken-buffer_init-when-deferred_struct_page_init-set.patch
 added to -mm tree
Message-ID: <20201123200828.0JrQh64G6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: [RFC] init/main: fix broken buffer_init when DEFERRED_STRUCT_PAGE_INIT set
has been added to the -mm tree.  Its filename is
     init-main-fix-broken-buffer_init-when-deferred_struct_page_init-set.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/init-main-fix-broken-buffer_init-when-deferred_struct_page_init-set.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/init-main-fix-broken-buffer_init-when-deferred_struct_page_init-set.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lin Feng <linf@wangsu.com>
Subject: [RFC] init/main: fix broken buffer_init when DEFERRED_STRUCT_PAGE_INIT set

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
@@ -70,6 +70,7 @@
 #include <linux/psi.h>
 #include <linux/padata.h>
 #include <linux/khugepaged.h>
+#include <linux/buffer_head.h>
 
 #include <asm/sections.h>
 #include <asm/tlbflush.h>
@@ -2112,6 +2113,8 @@ void __init page_alloc_init_late(void)
 	files_maxfiles_init();
 #endif
 
+	buffer_init();
+
 	/* Discard memblock private memory */
 	memblock_discard();
 
_

Patches currently in -mm which might be from linf@wangsu.com are

init-main-fix-broken-buffer_init-when-deferred_struct_page_init-set.patch

