Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4539C5479D
	for <mm-commits@archiver.kernel.org>; Mon,  9 Jan 2023 23:45:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238093AbjAIXpu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Jan 2023 18:45:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238107AbjAIXoq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jan 2023 18:44:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 280A23FA06
        for <mm-commits@vger.kernel.org>; Mon,  9 Jan 2023 15:44:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B012961497
        for <mm-commits@vger.kernel.org>; Mon,  9 Jan 2023 23:44:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C51D3C433F0;
        Mon,  9 Jan 2023 23:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673307884;
        bh=z5J/3ioweAbOh+I62V5zZNxtHw0Za5EKRYu/85HVItU=;
        h=Date:To:From:Subject:From;
        b=O/g/DgUNTK2AptunlhZlW36kRMRY/EISuyWbQHIwFJE3KP8WEbRcbBF/1+3YBUd+A
         hn6U8Jbq8UZ+SC/WhUiFEs7VwYbcgrg2X+ZLMUSjfMACQyXsPI6qgnpJhd/0dx0wtH
         fxnw6V9niSt2WeOc8kEaPHkfq/RX77hnbpEfDOoo=
Date:   Mon, 09 Jan 2023 15:44:44 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        thierry.reding@gmail.com, neilb@suse.de, mhocko@suse.com,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_allocc-allow-__gfp_nofail-requests-deeper-access-to-reserves.patch added to mm-unstable branch
Message-Id: <20230109234444.C51D3C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: allow __GFP_NOFAIL requests deeper access to reserves
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_allocc-allow-__gfp_nofail-requests-deeper-access-to-reserves.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_allocc-allow-__gfp_nofail-requests-deeper-access-to-reserves.patch

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
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc.c: allow __GFP_NOFAIL requests deeper access to reserves
Date: Mon, 9 Jan 2023 15:16:29 +0000

Currently __GFP_NOFAIL allocations without any other flags can access 25%
of the reserves but these requests imply that the system cannot make
forward progress until the allocation succeeds.  Allow __GFP_NOFAIL access
to 75% of the min reserve.

Link: https://lkml.kernel.org/r/20230109151631.24923-6-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_allocc-allow-__gfp_nofail-requests-deeper-access-to-reserves
+++ a/mm/page_alloc.c
@@ -5323,7 +5323,7 @@ nopage:
 		 * could deplete whole memory reserves which would just make
 		 * the situation worse
 		 */
-		page = __alloc_pages_cpuset_fallback(gfp_mask, order, ALLOC_HARDER, ac);
+		page = __alloc_pages_cpuset_fallback(gfp_mask, order, ALLOC_MIN_RESERVE|ALLOC_HARDER, ac);
 		if (page)
 			goto got_pg;
 
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-rename-alloc_high-to-alloc_min_reserve.patch
mm-page_alloc-treat-rt-tasks-similar-to-__gfp_high.patch
mm-page_alloc-explicitly-record-high-order-atomic-allocations-in-alloc_flags.patch
mm-page_alloc-explicitly-define-what-alloc-flags-deplete-min-reserves.patch
mm-page_allocc-allow-__gfp_nofail-requests-deeper-access-to-reserves.patch
mm-page_alloc-give-gfp_atomic-and-non-blocking-allocations-access-to-reserves.patch

