Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C271AC433FE
	for <mm-commits@archiver.kernel.org>; Thu, 10 Dec 2020 00:05:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DEF323B51
	for <mm-commits@archiver.kernel.org>; Thu, 10 Dec 2020 00:05:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgLJAFv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Dec 2020 19:05:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:39602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726358AbgLJAFv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 9 Dec 2020 19:05:51 -0500
Date:   Wed, 09 Dec 2020 16:05:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607558710;
        bh=0cY2+9TcQ8v5b2Ffkwb+E6rJCnrTenDtk9PsMiwYA7E=;
        h=From:To:Subject:From;
        b=tm52d9Dfg6m5ltETYiCZpK9kRucDNmlK4jBUtMxLQlKnLRCfV7Gz68Nbdqos0eKvd
         K7cB6T/pkd76N2lScZuPgE86mhIqRLLDi+nLwEtFc2Waus73fjBUCnvSSdEKgp9M9g
         0zXejm/YuU7YMunb2SInahoXf9NlXuWNea+ghl7E=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, iamjoonsoo.kim@lge.com,
        hannes@cmpxchg.org, yuzhao@google.com
Subject:  +
 mm-dont-setpageworkingset-unconditionally-during-swapin.patch added to -mm
 tree
Message-ID: <20201210000509.srHsd%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/wap: don't SetPageWorkingset unconditionally during swapin
has been added to the -mm tree.  Its filename is
     mm-dont-setpageworkingset-unconditionally-during-swapin.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-dont-setpageworkingset-unconditionally-during-swapin.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-dont-setpageworkingset-unconditionally-during-swapin.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm/wap: don't SetPageWorkingset unconditionally during swapin

We are capable of SetPageWorkingset based on refault distances after
commit aae466b0052e ("mm/swap: implement workingset detection for
anonymous LRU") This is done by workingset_refault(), which is right above
the unconditional SetPageWorkingset deleted by this patch.

The unconditional SetPageWorkingset miscategorizes pages that are read
ahead or never belonged to the working set (e.g., tmpfs pages accessed by
fd).  When those pages are swapped in (after they were swapped out) for
the first time, they skew PSI (when using async swap).  When this happens
again, depending on their refault distances, they might skew
workingset_restore_anon counter in addition to PSI because their shadows
say they were part of the working set.

Link: https://lkml.kernel.org/r/20201209012400.1771150-1-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/swap_state.c~mm-dont-setpageworkingset-unconditionally-during-swapin
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

mm-dont-setpageworkingset-unconditionally-during-swapin.patch

