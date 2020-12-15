Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DE0DC3526A
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:08:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A84B22D05
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:08:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbgLPAAW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 19:00:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:34630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727172AbgLOX1p (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:27:45 -0500
Date:   Tue, 15 Dec 2020 15:16:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074210;
        bh=kgCbWoIylvzxdXDPVWby+gp9fTED/kMVcqczGh7SWg0=;
        h=From:To:Subject:From;
        b=sVXDemeayc2IcN5O/YEp0A/iIunMpfw7RxNRrjlBwBD07sNTteZbzQTb19ji9ZJnS
         GxYPbQYWmiKwFZUZYq6+9nzjR4tLMRSTjriFMoQjBjERgZEKjun1ZqZy6H7QXkPeID
         4oQW/xdSLS99+MXYHjjlRloEjneieyMdIGNUOfSk=
From:   akpm@linux-foundation.org
To:     cl@linux.com, iamjoonsoo.kim@lge.com, liu.xiang6@zte.com.cn,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz, wuyun.wu@huawei.com
Subject:  [merged]
 mm-slub-use-kmem_cache_debug_flags-in-deactivate_slab.patch removed from
 -mm tree
Message-ID: <20201215231649.t6uZm3q4L%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: use kmem_cache_debug_flags() in deactivate_slab()
has been removed from the -mm tree.  Its filename was
     mm-slub-use-kmem_cache_debug_flags-in-deactivate_slab.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from vbabka@suse.cz are


