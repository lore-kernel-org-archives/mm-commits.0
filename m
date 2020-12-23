Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 863E0C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 22:21:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B8062247F
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 22:21:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgLWWV4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Dec 2020 17:21:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:57348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726047AbgLWWVz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 23 Dec 2020 17:21:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B728F22283;
        Wed, 23 Dec 2020 22:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608762074;
        bh=Cicxw/duyA2qeOL05tWQ2pin3i5FzUPi28b1PCRJprw=;
        h=Date:From:To:Subject:From;
        b=ICoARz4br+Y5+Z3irZ3q03a0bNfMFynJCxP6SS0wmF356aHxyba4CIYKjjWaphYID
         7WJkyIsoPIYj3lG8TwZXxNpPkh/D89UESR3FOhkiqIzckc+ciO9YcabW47nUe8iRZd
         gm314K43gqgInbekiSqOljhk9VIQRf1/8Wv02YSE=
Date:   Wed, 23 Dec 2020 14:21:14 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, mhocko@suse.com,
        iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, yuzhao@google.com
Subject:  [to-be-updated]
 mm-dont-setpageworkingset-unconditionally-during-swapin.patch removed from
 -mm tree
Message-ID: <20201223222114.yqxP5%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap: don't SetPageWorkingset unconditionally during swapin
has been removed from the -mm tree.  Its filename was
     mm-dont-setpageworkingset-unconditionally-during-swapin.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm/swap: don't SetPageWorkingset unconditionally during swapin

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
Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
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

mm-swap-dont-setpageworkingset-unconditionally-during-swapin.patch

