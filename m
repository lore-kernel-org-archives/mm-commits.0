Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6540EC43332
	for <mm-commits@archiver.kernel.org>; Thu, 14 Jan 2021 01:56:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14FA22343B
	for <mm-commits@archiver.kernel.org>; Thu, 14 Jan 2021 01:56:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbhANB4M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Jan 2021 20:56:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:54594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729603AbhAMXqe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 13 Jan 2021 18:46:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E1252222B;
        Wed, 13 Jan 2021 23:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610581551;
        bh=IZA7PnZ1xj+Jh8KGqq3h9Q4gsZfPGTHd1I7eUVmZ300=;
        h=Date:From:To:Subject:From;
        b=u7j3H3xV6nqULDBwfjMU3X2GhRa2iu8oS83WVStPGu6gGQv7TWC0mvKEcWL6wPUHu
         u1cqhWFmxiwLtk3PI92GHnqkFMHtcRTbcX/TYFSfZ2odtippfwQaW0yPWp5QXPWWWM
         DjZ4y1pAoD87QLH1Pd/p9DB6r1jilB8HERtI023E=
Date:   Wed, 13 Jan 2021 15:45:50 -0800
From:   akpm@linux-foundation.org
To:     daniel.vetter@ffwll.ch, daniel.vetter@intel.com,
        mm-commits@vger.kernel.org
Subject:  + mm-dmapool-use-might_alloc.patch added to -mm tree
Message-ID: <20210113234550.dw1YDU-5i%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/dmapool: use might_alloc()
has been added to the -mm tree.  Its filename is
     mm-dmapool-use-might_alloc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-dmapool-use-might_alloc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-dmapool-use-might_alloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-dmapool-use-might_alloc.patch
bdi-use-might_alloc.patch

