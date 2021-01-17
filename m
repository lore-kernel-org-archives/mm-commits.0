Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49FC4C433E0
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 02:11:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0976B22C7C
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 02:11:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbhAQCLZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 16 Jan 2021 21:11:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:41472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727786AbhAQCLY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 16 Jan 2021 21:11:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0818922C7C;
        Sun, 17 Jan 2021 02:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610849444;
        bh=i/evS1JEcIvpF794FUGV0kzKpmC/p60qAJg5ZGdE3S8=;
        h=Date:From:To:Subject:From;
        b=ZGd0HAr+rDlySClT+c8dLjvY2l5Zz0JgXolCMpypLeuDPuvNRGVRREXzJTzfwkgm0
         vJhrjtjw8sxCPUX2SwtWBiM1K8HR8Tbsk23Mt8tMRYyu1Z9DlzCTovRLhWD9DysX7n
         /58NQF14WwV5FyN5GOqbcfJCBCsRUW44oMrSF1nM=
Date:   Sat, 16 Jan 2021 18:10:43 -0800
From:   akpm@linux-foundation.org
To:     cl@linux.com, iamjoonsoo.kim@lge.com, jannh@google.com,
        mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com
Subject:  [merged]
 mm-slub-consider-rest-of-partial-list-if-acquire_slab-fails.patch removed
 from -mm tree
Message-ID: <20210117021043.C8w7B8YPl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: consider rest of partial list if acquire_slab() fails
has been removed from the -mm tree.  Its filename was
     mm-slub-consider-rest-of-partial-list-if-acquire_slab-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jann Horn <jannh@google.com>
Subject: mm, slub: consider rest of partial list if acquire_slab() fails

acquire_slab() fails if there is contention on the freelist of the page
(probably because some other CPU is concurrently freeing an object from
the page).  In that case, it might make sense to look for a different page
(since there might be more remote frees to the page from other CPUs, and
we don't want contention on struct page).

However, the current code accidentally stops looking at the partial list
completely in that case.  Especially on kernels without CONFIG_NUMA set,
this means that get_partial() fails and new_slab_objects() falls back to
new_slab(), allocating new pages.  This could lead to an unnecessary
increase in memory fragmentation.

Link: https://lkml.kernel.org/r/20201228130853.1871516-1-jannh@google.com
Fixes: 7ced37197196 ("slub: Acquire_slab() avoid loop")
Signed-off-by: Jann Horn <jannh@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slub.c~mm-slub-consider-rest-of-partial-list-if-acquire_slab-fails
+++ a/mm/slub.c
@@ -1973,7 +1973,7 @@ static void *get_partial_node(struct kme
 
 		t = acquire_slab(s, n, page, object == NULL, &objects);
 		if (!t)
-			break;
+			continue; /* cmpxchg raced */
 
 		available += objects;
 		if (!object) {
_

Patches currently in -mm which might be from jannh@google.com are


