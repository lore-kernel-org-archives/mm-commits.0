Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3623C433E9
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:19:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E55664F13
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:19:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbhBZBTs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:19:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:51348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229863AbhBZBTX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:19:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8303864F13;
        Fri, 26 Feb 2021 01:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302322;
        bh=Wjzf7Wy1XNiCjLfKFdrmbrxjXNl//kp0itjsuMsup+U=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=MB8hCmsUMUvRh5OYbgxRlSueDoyRajrA+7OkrIyp4yZ/y0AoZZE+OwZj3jJA5IXmy
         dif3Va9XPDL8/vb77kq3aXiGTODu3o0LGVvJiPGaMeY903pPd+JmioKbbu0pecAHMf
         JPdkrwH8kx1C/qh61su8KIHo27BR932AYfbHFEoM=
Date:   Thu, 25 Feb 2021 17:18:41 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, daniel.vetter@ffwll.ch,
        daniel.vetter@intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 053/118] mm/dmapool: use might_alloc()
Message-ID: <20210226011841.FKty5IXOj%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
