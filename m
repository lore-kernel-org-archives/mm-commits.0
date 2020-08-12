Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17184C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:30:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC37D2076C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597195855;
	bh=aWV7KNfGrVoIY1pb4TGdY8RpaVQXWqzKalJlEPG7RwQ=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=SAC4ancwOiECNoAFsu05sisxh0EdwomhFdQtV3c9rALVtEwBpApbdKyYyoHO0xP7T
	 QWLaL55P9CIKPP3NXpkdqyavpvss3IOMwJCJzrdsZ7Ipa2horuxApk8xG/ruajlWCa
	 U9OUsWl2l+4CpWPW6rW9ytso3czhD+x7utLpqiyY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgHLBaz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:30:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:57950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbgHLBaz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:30:55 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71417206B2;
        Wed, 12 Aug 2020 01:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597195855;
        bh=aWV7KNfGrVoIY1pb4TGdY8RpaVQXWqzKalJlEPG7RwQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=RF85+Utrypd3o03uS7W8WcF6KcxmvqHhKNhuU1iYM4MS5aQXIpJ3rlKPpLJpZEs/p
         oX9/vMpj8rLaMPRR2aryUGtwJRGFQGUypOkrVy/dKD/ohep9gbogqPNQwTyhegA76N
         dGnFlCfFwD7AftlwFGDLlJXZFxPbyLuGmlXyc7Nk=
Date:   Tue, 11 Aug 2020 18:30:54 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hannes@cmpxchg.org, hughd@google.com,
        iamjoonsoo.kim@lge.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mhocko@kernel.org, minchan@kernel.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz, willy@infradead.org
Subject:  [patch 012/165] mm/vmscan: restore active/inactive ratio
 for anonymous LRU
Message-ID: <20200812013054.ZAdF2sKFH%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/vmscan: restore active/inactive ratio for anonymous LRU

Now that workingset detection is implemented for anonymous LRU, we don't
need large inactive list to allow detecting frequently accessed pages
before they are reclaimed, anymore.  This effectively reverts the
temporary measure put in by commit "mm/vmscan: make active/inactive ratio
as 1:1 for anon lru".

Link: http://lkml.kernel.org/r/1595490560-15117-7-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-restore-active-inactive-ratio-for-anonymous-lru
+++ a/mm/vmscan.c
@@ -2207,7 +2207,7 @@ static bool inactive_is_low(struct lruve
 	active = lruvec_page_state(lruvec, NR_LRU_BASE + active_lru);
 
 	gb = (inactive + active) >> (30 - PAGE_SHIFT);
-	if (gb && is_file_lru(inactive_lru))
+	if (gb)
 		inactive_ratio = int_sqrt(10 * gb);
 	else
 		inactive_ratio = 1;
_
