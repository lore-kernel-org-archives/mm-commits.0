Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BF19C04A6A
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 22:59:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236902AbjHKW7g (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 18:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236937AbjHKW7H (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:59:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B3135A1
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:59:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D81C6678D4
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:59:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A18FC433C7;
        Fri, 11 Aug 2023 22:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794743;
        bh=yODK0ZSTco4+qscAElD1gNOfknwXqp22rTrc57DMLmI=;
        h=Date:To:From:Subject:From;
        b=DSh/sSDQGo9qJUi8WygnuW3OdPWjVpM4e3YF3uO1N0QwPRCEpGw2UedkA+vuvVL9p
         4wnnEaXHcVGaVWfcVeYKQf6XfRtxwb/Z5M7OAJmt2KjTXzoqAoasdjx8BrVQ1ElyoN
         u7bEipll3B3P6OOKoZnb1aIZJdncS97AIhD+XB8U=
Date:   Fri, 11 Aug 2023 15:59:02 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de, rppt@kernel.org,
        peterz@infradead.org, mingo@redhat.com, dvhart@infradead.org,
        dave@stgolabs.net, andrealmeid@igalia.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mm_initc-remove-obsolete-macro-hash_small.patch removed from -mm tree
Message-Id: <20230811225903.3A18FC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mm_init.c: remove obsolete macro HASH_SMALL
has been removed from the -mm tree.  Its filename was
     mm-mm_initc-remove-obsolete-macro-hash_small.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/mm_init.c: remove obsolete macro HASH_SMALL
Date: Sun, 25 Jun 2023 10:13:23 +0800

HASH_SMALL only works when parameter numentries is 0. But the sole caller
futex_init() never calls alloc_large_system_hash() with numentries set to
0. So HASH_SMALL is obsolete and remove it.

Link: https://lkml.kernel.org/r/20230625021323.849147-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: André Almeida <andrealmeid@igalia.com>
Cc: Darren Hart <dvhart@infradead.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    4 +---
 kernel/futex/core.c      |    3 +--
 mm/mm_init.c             |   10 +---------
 3 files changed, 3 insertions(+), 14 deletions(-)

--- a/include/linux/memblock.h~mm-mm_initc-remove-obsolete-macro-hash_small
+++ a/include/linux/memblock.h
@@ -581,9 +581,7 @@ extern void *alloc_large_system_hash(con
 				     unsigned long high_limit);
 
 #define HASH_EARLY	0x00000001	/* Allocating during early boot? */
-#define HASH_SMALL	0x00000002	/* sub-page allocation allowed, min
-					 * shift passed via *_hash_shift */
-#define HASH_ZERO	0x00000004	/* Zero allocated hash table */
+#define HASH_ZERO	0x00000002	/* Zero allocated hash table */
 
 /* Only NUMA needs hash distribution. 64bit NUMA architectures have
  * sufficient vmalloc space.
--- a/kernel/futex/core.c~mm-mm_initc-remove-obsolete-macro-hash_small
+++ a/kernel/futex/core.c
@@ -1132,8 +1132,7 @@ static int __init futex_init(void)
 #endif
 
 	futex_queues = alloc_large_system_hash("futex", sizeof(*futex_queues),
-					       futex_hashsize, 0,
-					       futex_hashsize < 256 ? HASH_SMALL : 0,
+					       futex_hashsize, 0, 0,
 					       &futex_shift, NULL,
 					       futex_hashsize, futex_hashsize);
 	futex_hashsize = 1UL << futex_shift;
--- a/mm/mm_init.c~mm-mm_initc-remove-obsolete-macro-hash_small
+++ a/mm/mm_init.c
@@ -2489,15 +2489,7 @@ void *__init alloc_large_system_hash(con
 		else
 			numentries <<= (PAGE_SHIFT - scale);
 
-		/* Make sure we've got at least a 0-order allocation.. */
-		if (unlikely(flags & HASH_SMALL)) {
-			/* Makes no sense without HASH_EARLY */
-			WARN_ON(!(flags & HASH_EARLY));
-			if (!(numentries >> *_hash_shift)) {
-				numentries = 1UL << *_hash_shift;
-				BUG_ON(!numentries);
-			}
-		} else if (unlikely((numentries * bucketsize) < PAGE_SIZE))
+		if (unlikely((numentries * bucketsize) < PAGE_SIZE))
 			numentries = PAGE_SIZE / bucketsize;
 	}
 	numentries = roundup_pow_of_two(numentries);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory-failure-fix-unexpected-return-value-in-soft_offline_page.patch
mm-memory-failure-fix-potential-page-refcnt-leak-in-memory_failure.patch
mm-memcg-fix-obsolete-function-name-in-mem_cgroup_protection.patch
mm-memory-failure-add-pageoffline-check.patch
mm-page_alloc-avoid-unneeded-alike_pages-calculation.patch
mm-memcg-update-obsolete-comment-above-parent_mem_cgroup.patch
mm-page_alloc-remove-unneeded-variable-base.patch
mm-memcg-fix-wrong-function-name-above-obj_cgroup_charge_zswap.patch
mm-memory-failure-use-helper-macro-llist_for_each_entry_safe.patch
mm-mm_init-use-helper-macro-bits_per_long-and-bits_per_byte.patch

