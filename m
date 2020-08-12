Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E995FC433E1
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:07:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBEE420838
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266437;
	bh=ImCSg3DRz9houYMczKSJsSxrQFj0s5+F3Xu4HNEI7Hs=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=R+/P6oQ/qIdpb5cSTtUU+JPR7Vnl+RjbzIb7Gp2KoVcFqyLFjsxZrt8fe13kk9t5e
	 q0C0BFEB8cDxNCXDrSlqL5V4S9UQPk7DXX7wE+uxZHLXImXRq5Kn6ku1ewMdPdgke7
	 jytbFn32sHUytREe6wvhdrClio73wW4nTn8SVf/c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbgHLVHR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:07:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:35294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbgHLVHR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:07:17 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A26820774;
        Wed, 12 Aug 2020 21:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266436;
        bh=ImCSg3DRz9houYMczKSJsSxrQFj0s5+F3Xu4HNEI7Hs=;
        h=Date:From:To:Subject:From;
        b=yG8k53dwdwKqYHBx9wwF0El7xMK81AwsptLEhEcdyy0oU0fxChstQ91SEfZLnCBr1
         KkvOB+1On0WcxPLYNP9540WiCY1j3rXn/oeSOlwOJk+jrA+7Sh+mOLiHK+6U7bNniw
         FuT9RY89LEpFR1kcTw6VceJ2zJTbr1nTRpShRbJc=
Date:   Wed, 12 Aug 2020 14:07:16 -0700
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com,
        mgorman@techsingularity.net, mhocko@kernel.org, minchan@kernel.org,
        mm-commits@vger.kernel.org, vbabka@suse.cz, willy@infradead.org
Subject:  [merged]
 mm-vmscan-restore-active-inactive-ratio-for-anonymous-lru.patch removed
 from -mm tree
Message-ID: <20200812210716.W6149q14t%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: restore active/inactive ratio for anonymous LRU
has been removed from the -mm tree.  Its filename was
     mm-vmscan-restore-active-inactive-ratio-for-anonymous-lru.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-memory-failure-remove-a-wrapper-for-alloc_migration_target.patch
mm-memory_hotplug-remove-a-wrapper-for-alloc_migration_target.patch

