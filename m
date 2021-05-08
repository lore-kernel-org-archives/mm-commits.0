Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A39C1C43460
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:49:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 878A961424
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:49:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbhEHWuZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:50:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:35460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229662AbhEHWuY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:50:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86688613EA;
        Sat,  8 May 2021 22:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514162;
        bh=mZrmXBovMZHJ+fnJhzYn6tFauS9o9j2ekZLNmIQbpgU=;
        h=Date:From:To:Subject:From;
        b=Api94v0EljQdvAQ61+lhUy2de2tmQFOph3IcjGmLnBLANo5Le+KQbu1awSndJb5+J
         PLiIvioH8YGSeE6zkiOyb8En7C81ouQ57aMJY8YVl7QaA5Qvit57qzwtbvoocrEW6o
         dmbahTJZhszJiqUZssFZ6j5or+f5CQY17I5uuYKk=
Date:   Sat, 08 May 2021 15:49:22 -0700
From:   akpm@linux-foundation.org
To:     baolin.wang@linux.alibaba.com, david@redhat.com,
        minchan@kernel.org, mm-commits@vger.kernel.org
Subject:  [merged]
 mm-cma-use-pr_err_ratelimited-for-cma-warning.patch removed from -mm tree
Message-ID: <20210508224922.mKlZiEypu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: use pr_err_ratelimited for CMA warning
has been removed from the -mm tree.  Its filename was
     mm-cma-use-pr_err_ratelimited-for-cma-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: cma: use pr_err_ratelimited for CMA warning

If we did not reserve extra CMA memory, the log buffer can be easily
filled up by CMA failure warning when the devices calling
dmam_alloc_coherent() to alloc DMA memory.  Thus we can use
pr_err_ratelimited() instead to reduce the duplicate CMA warning.

Link: https://lkml.kernel.org/r/ce2251ef49e1727a9a40531d1996660b05462bd2.1615279825.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/cma.c~mm-cma-use-pr_err_ratelimited-for-cma-warning
+++ a/mm/cma.c
@@ -500,8 +500,8 @@ struct page *cma_alloc(struct cma *cma,
 	}
 
 	if (ret && !no_warn) {
-		pr_err("%s: %s: alloc failed, req-size: %zu pages, ret: %d\n",
-		       __func__, cma->name, count, ret);
+		pr_err_ratelimited("%s: %s: alloc failed, req-size: %zu pages, ret: %d\n",
+				   __func__, cma->name, count, ret);
 		cma_debug_show_areas(cma);
 	}
 
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


