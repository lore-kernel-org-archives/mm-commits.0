Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 589AEC77B7A
	for <mm-commits@archiver.kernel.org>; Fri, 19 May 2023 21:40:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbjESVkN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 May 2023 17:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjESVkE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 19 May 2023 17:40:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917BB101
        for <mm-commits@vger.kernel.org>; Fri, 19 May 2023 14:40:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C79C6444A
        for <mm-commits@vger.kernel.org>; Fri, 19 May 2023 21:40:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75894C433D2;
        Fri, 19 May 2023 21:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684532402;
        bh=8CiCi2Pz3gL52HVaRfUqFwNhrPRAaI/HYEbWPtRWFnU=;
        h=Date:To:From:Subject:From;
        b=ojnjG4TAJDwv+FgbNNdZ6E17F/RxDZWGV95Nf71VVlALakxna+41R8XTQSrVqZBUz
         ptpWhuJ8mVJFk1m/cSVtyWbJedDs7qZ/VuNvozx//bAoZoqyIFxzyRXm3hFXSzA7fJ
         XQyFo5hEOEZQFQKa3vqru1mFIqmyUWbceQSpUcF4=
Date:   Fri, 19 May 2023 14:40:02 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, mhocko@suse.com,
        mgorman@techsingularity.net, hannes@cmpxchg.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-drop-redundant-watermark-check-in-compaction_zonelist_suitable.patch added to mm-unstable branch
Message-Id: <20230519214002.75894C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: drop redundant watermark check in compaction_zonelist_suitable()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-drop-redundant-watermark-check-in-compaction_zonelist_suitable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-drop-redundant-watermark-check-in-compaction_zonelist_suitable.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: compaction: drop redundant watermark check in compaction_zonelist_suitable()
Date: Fri, 19 May 2023 14:39:59 +0200

The watermark check in compaction_zonelist_suitable(), called from
should_compact_retry(), is sandwiched between two watermark checks
already: before, there are freelist attempts as part of direct reclaim and
direct compaction; after, there is a last-minute freelist attempt in
__alloc_pages_may_oom().

The check in compaction_zonelist_suitable() isn't necessary. Kill it.

Link: https://lkml.kernel.org/r/20230519123959.77335-6-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/mm/compaction.c~mm-compaction-drop-redundant-watermark-check-in-compaction_zonelist_suitable
+++ a/mm/compaction.c
@@ -2301,13 +2301,6 @@ bool compaction_zonelist_suitable(struct
 	for_each_zone_zonelist_nodemask(zone, z, ac->zonelist,
 				ac->highest_zoneidx, ac->nodemask) {
 		unsigned long available;
-		unsigned long watermark;
-
-		/* Allocation can already succeed, nothing to do */
-		watermark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK);
-		if (zone_watermark_ok(zone, order, watermark,
-				      ac->highest_zoneidx, alloc_flags))
-			continue;
 
 		/*
 		 * Do not consider all the reclaimable memory because we do not
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-compaction-remove-compaction-result-helpers.patch
mm-compaction-simplify-should_compact_retry.patch
mm-compaction-refactor-__compaction_suitable.patch
mm-compaction-remove-unnecessary-is_via_compact_memory-checks.patch
mm-compaction-drop-redundant-watermark-check-in-compaction_zonelist_suitable.patch

