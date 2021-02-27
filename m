Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06231C433E9
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:31:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE00064F2A
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:31:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbhB0CbQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:31:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:51074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230169AbhB0Cap (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:30:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C45A64F34;
        Sat, 27 Feb 2021 02:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614393021;
        bh=QeBmrN67rPJlFHrGDztJZxBKlYhfvcVXC25bfUhEJEI=;
        h=Date:From:To:Subject:From;
        b=eIOPj8E9RowAXJUrMbyAyUDvgUqeOfTH13K+vUjGAkj+Bd59QF7pAqqOsDsmXqQkx
         QoSWuKrI2FoLCYZEKBSYtdgqauUbyNllZcRdj1S4LWerygzvpWpP6/YtViJKimIQKC
         TKLkHBU7+aSUum7+VEka7l6xmkwV+otAqQG08gGY=
Date:   Fri, 26 Feb 2021 18:30:21 -0800
From:   akpm@linux-foundation.org
To:     daniel.vetter@ffwll.ch, daniel.vetter@intel.com,
        mm-commits@vger.kernel.org
Subject:  [merged] mm-dmapool-use-might_alloc.patch removed from
 -mm tree
Message-ID: <20210227023021.7RXDmq3av%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/dmapool: use might_alloc()
has been removed from the -mm tree.  Its filename was
     mm-dmapool-use-might_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: mm/dmapool: use might_alloc()

Now that my little helper has landed, use it more.  On top of the existing
check this also uses lockdep through the fs_reclaim annotations.

Link: https://lkml.kernel.org/r/20210113135009.3606813-1-daniel.vetter@ffwll.ch
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/dmapool.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/dmapool.c~mm-dmapool-use-might_alloc
+++ a/mm/dmapool.c
@@ -28,6 +28,7 @@
 #include <linux/mutex.h>
 #include <linux/poison.h>
 #include <linux/sched.h>
+#include <linux/sched/mm.h>
 #include <linux/slab.h>
 #include <linux/stat.h>
 #include <linux/spinlock.h>
@@ -319,7 +320,7 @@ void *dma_pool_alloc(struct dma_pool *po
 	size_t offset;
 	void *retval;
 
-	might_sleep_if(gfpflags_allow_blocking(mem_flags));
+	might_alloc(mem_flags);
 
 	spin_lock_irqsave(&pool->lock, flags);
 	list_for_each_entry(page, &pool->page_list, page_list) {
_

Patches currently in -mm which might be from daniel.vetter@ffwll.ch are


