Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0E51C433B4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:37:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D32CC61421
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:37:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232045AbhEEBiS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:38:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:41292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231459AbhEEBiS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:38:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9419E611AB;
        Wed,  5 May 2021 01:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178642;
        bh=UhWL/BNjTXzv2BFiYhQXngYTbqz7R/OSE5mmB4y36hI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=0b3sI8sc8oMci/S5K3gaX20JjwEawygpA34ZnENBshdDcb7iqbJuAzy7d5HaIRVif
         gH/JoEegVZXfWlxrGf+92Sxm78S1mRmfMH/hf0NiDSW9bMFhFRf6VzxuF+1xyp/oJD
         cEDowJRv+N3PXL0XiNeLMbWEmW/+F2M+Z/MPiLKA=
Date:   Tue, 04 May 2021 18:37:22 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, baolin.wang@linux.alibaba.com,
        david@redhat.com, linux-mm@kvack.org, minchan@kernel.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 086/143] mm: cma: use pr_err_ratelimited for CMA
 warning
Message-ID: <20210505013722.24q2DkOu3%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
