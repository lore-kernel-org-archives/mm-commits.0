Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 989C6C2BB48
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:05:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63A9222475
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:05:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727222AbgLODFY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:05:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:60684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727224AbgLODE7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:04:59 -0500
Date:   Mon, 14 Dec 2020 19:04:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001477;
        bh=0ZjHsJFIGrKTa+U0/h2gTMiYNMublNPqp/fx+jFoxZ8=;
        h=From:To:Subject:In-Reply-To:From;
        b=P6Q99CuMZYFg4LMWZuNJ6wW5xWTAnITY4fC27owQkbDKh2qU3g+dGT0+i7A8EIC5O
         EP9pZM+RXQxXbDxUI+pLrO7ksWlPY3sLn0BWc/7v+qBJQ+/L+7UwcopOr7g+07wgVM
         BM7rHCsOWdLZ7MRV+CIst47TtGM6Cin5pKFnpq2o=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, iamjoonsoo.kim@lge.com,
        linux-mm@kvack.org, liu.xiang6@zte.com.cn,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, torvalds@linux-foundation.org, vbabka@suse.cz,
        wuyun.wu@huawei.com
Subject:  [patch 023/200] mm, slub: use kmem_cache_debug_flags() in
 deactivate_slab()
Message-ID: <20201215030436.jb0n16mkI%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: use kmem_cache_debug_flags() in deactivate_slab()

Commit 9cf7a1118365 ("mm/slub: make add_full() condition more explicit")
replaced an unnecessarily generic kmem_cache_debug(s) check with an
explicit check of SLAB_STORE_USER and #ifdef CONFIG_SLUB_DEBUG.

We can achieve the same specific check with the recently added
kmem_cache_debug_flags() which removes the #ifdef and restores the
no-branch-overhead benefit of static key check when slub debugging is not
enabled.

Link: https://lkml.kernel.org/r/3ef24214-38c7-1238-8296-88caf7f48ab6@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Abel Wu <wuyun.wu@huawei.com>
Cc: Christopher Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Liu Xiang <liu.xiang6@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/slub.c~mm-slub-use-kmem_cache_debug_flags-in-deactivate_slab
+++ a/mm/slub.c
@@ -2245,8 +2245,7 @@ redo:
 		}
 	} else {
 		m = M_FULL;
-#ifdef CONFIG_SLUB_DEBUG
-		if ((s->flags & SLAB_STORE_USER) && !lock) {
+		if (kmem_cache_debug_flags(s, SLAB_STORE_USER) && !lock) {
 			lock = 1;
 			/*
 			 * This also ensures that the scanning of full
@@ -2255,7 +2254,6 @@ redo:
 			 */
 			spin_lock(&n->list_lock);
 		}
-#endif
 	}
 
 	if (l != m) {
_
