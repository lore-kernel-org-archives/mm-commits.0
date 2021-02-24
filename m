Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6247CC433E9
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:05:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20F2564E6C
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:05:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235223AbhBXUFh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:05:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:56868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235480AbhBXUDy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:03:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF54964F0D;
        Wed, 24 Feb 2021 20:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614196989;
        bh=gRejEKoFluiBxWJ6U1UkCg86trl6uLiF3N4Bv/ikOiY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=0c+NRm+GaXwfSjlN2hmXJJrElBvtZWLoF9Bm8Ee461wybC6QV+vaKIgFtABNLJGrZ
         zC67pA5D0zXH76j+QJ4z7+f23H7sj5Pjl0g8Aeda/oRFAHqSy7Jb1QPAROvvXHG/HH
         fE3nWPhNHlzqspJalSAnFXLHTdYGtyg0na31bsJI=
Date:   Wed, 24 Feb 2021 12:03:08 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hannes@cmpxchg.org,
        iamjoonsoo.kim@lge.com, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz, yuzhao@google.com
Subject:  [patch 054/173] mm/swap: don't SetPageWorkingset
 unconditionally during swapin
Message-ID: <20210224200308.c29_ITugV%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yu Zhao <yuzhao@google.com>
Subject: mm/swap: don't SetPageWorkingset unconditionally during swapin

We are capable of SetPageWorkingset based on refault distances after
commit aae466b0052e ("mm/swap: implement workingset detection for
anonymous LRU").  This is done by workingset_refault(), which is right
above the unconditional SetPageWorkingset deleted by this patch.

The unconditional SetPageWorkingset miscategorizes pages that are read
ahead or never belonged to the working set (e.g., tmpfs pages accessed
only once by fd).  When those pages are swapped in (after they were
swapped out) for the first time, they skew PSI (when using async swap). 
When this happens again, depending on their refault distances, they might
skew workingset_restore_anon counter in addition to PSI because their
shadows indicate they were part of the working set.

Historically, SetPageWorkingset was added as part of the PSI series, and
Johannes said:
 "It was meant to mark incoming pages under IO with SetPageWorkingset
  when waiting for them constituted a memory stall.

  On the page cache side, because we HAVE workingset detection, this was
  specific to recently evicted pages that had been active in their
  previous life. On the anon side, the aging algorithm had no
  distinction between workingset and sporadically used pages. Given the
  choice between a) no swapin stalls are pressure and b) all swapin
  stalls are pressure, I went with the latter in order to detect swap
  storms. The false positive case - high rate of swapin without severe
  memory pressure - was relatively unlikely, because we tried to avoid
  swapping until everything was completely on fire in the first place."

Link: https://lkml.kernel.org/r/20201209012400.1771150-1-yuzhao@google.com
Link: https://lkml.kernel.org/r/20201214231253.62313-1-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/swap_state.c~mm-swap-dont-setpageworkingset-unconditionally-during-swapin
+++ a/mm/swap_state.c
@@ -537,7 +537,6 @@ struct page *__read_swap_cache_async(swp
 		workingset_refault(page, shadow);
 
 	/* Caller will initiate read into locked page */
-	SetPageWorkingset(page);
 	lru_cache_add(page);
 	*new_page_allocated = true;
 	return page;
_
