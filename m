Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76C58C433DB
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 23:18:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36F8A64F93
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 23:18:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbhCKXSR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Mar 2021 18:18:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:53160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230445AbhCKXRu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Mar 2021 18:17:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E194264F9A;
        Thu, 11 Mar 2021 23:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615504670;
        bh=L4g2tHWxj45VAgfEKkO9hteXq5h9SVoaylBXsiIoAME=;
        h=Date:From:To:Subject:From;
        b=kJtUqArQKveDqIjsoDd/brfVplykvOD9Q2WAgKUv+KhQs9MA5T7KDqMuLidKQbzx+
         JDXz71s0gXk86o2d+J7KGDqQG9T63uz87UDQITERr0QRAWnuK73yoDgESPPN467JLg
         R/M1kAdjRYtUEQGav/U34rKwsKSjae8GtHkjH2WQ=
Date:   Thu, 11 Mar 2021 15:17:49 -0800
From:   akpm@linux-foundation.org
To:     baolin.wang@linux.alibaba.com, david@redhat.com,
        minchan@kernel.org, mm-commits@vger.kernel.org
Subject:  + mm-cma-use-pr_err_ratelimited-for-cma-warning.patch
 added to -mm tree
Message-ID: <20210311231749.FdQ2KILk1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: use pr_err_ratelimited for CMA warning
has been added to the -mm tree.  Its filename is
     mm-cma-use-pr_err_ratelimited-for-cma-warning.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-cma-use-pr_err_ratelimited-for-cma-warning.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-use-pr_err_ratelimited-for-cma-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-cma-use-pr_err_ratelimited-for-cma-warning.patch

