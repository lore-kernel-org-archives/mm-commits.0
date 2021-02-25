Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C60C5C433DB
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:24:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7485164E21
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:24:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233452AbhBYTYy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:24:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:34000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234222AbhBYTWy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:22:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98EE064F5C;
        Thu, 25 Feb 2021 19:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280426;
        bh=4OW/wVdbuykVmM0Waf7BvqQMtVsPIQ7k6y5Kvv5/Gk0=;
        h=Date:From:To:Subject:From;
        b=WHndeip+TkeP0rWnoIxF/bI5CrOA1AJ7+tgITN7IHiYx1ICyP8NP+IdfU0UpyNFQE
         EAfpaM3A8UMkJot4/O1fPxLLQb7vp0q7H+7VrpYGqulpovMJVeazDgg0LkIVrsq0Yo
         nERqWdzLSUJTYQapjeOo8yviLrnX3BJFNPoLeZzE=
Date:   Thu, 25 Feb 2021 11:13:46 -0800
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, vbabka@suse.cz, yuzhao@google.com
Subject:  [merged]
 mm-swap-dont-setpageworkingset-unconditionally-during-swapin.patch removed
 from -mm tree
Message-ID: <20210225191346.pDF3-nG7X%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap: don't SetPageWorkingset unconditionally during swapin
has been removed from the -mm tree.  Its filename was
     mm-swap-dont-setpageworkingset-unconditionally-during-swapin.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from yuzhao@google.com are


