Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BE94C4332F
	for <mm-commits@archiver.kernel.org>; Thu,  9 Dec 2021 20:47:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbhLIUvJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Dec 2021 15:51:09 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:36192 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbhLIUvI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Dec 2021 15:51:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F1C05CE2833
        for <mm-commits@vger.kernel.org>; Thu,  9 Dec 2021 20:47:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F20C004DD;
        Thu,  9 Dec 2021 20:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639082852;
        bh=8mUlOpSfpYNBH9i0NPsk6tH454686QgnXb5P712hiTA=;
        h=Date:From:To:Subject:From;
        b=hDdoVgCMakIRhEhnoCMnSgO1LFLRYkIT9GuQETqIoM3I8IF+QFpeqd95UVw/JbKH5
         U+ofyPyhZwmsPyttEqeDpTpz2oAOnrfgeP+9HRF/jOn/0eiHRBZ5yQD8eZ/C6IIhEk
         08SPtlBwJb+tk/0Wz8hEyu5CIzfNA3fnfU59VhF4=
Date:   Thu, 09 Dec 2021 12:47:31 -0800
From:   akpm@linux-foundation.org
To:     djwong@kernel.org, efault@gmx.de, hughd@google.com,
        mgorman@techsingularity.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, riel@surriel.com, shakeelb@google.com,
        vbabka@suse.cz
Subject:  +
 mm-vmscan-reduce-throttling-due-to-a-failure-to-make-progress-fix.patch
 added to -mm tree
Message-ID: <20211209204731.zdVwc9Gha%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: reduce throttling due to a failure to make progress -fix
has been added to the -mm tree.  Its filename is
     mm-vmscan-reduce-throttling-due-to-a-failure-to-make-progress-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-reduce-throttling-due-to-a-failure-to-make-progress-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-reduce-throttling-due-to-a-failure-to-make-progress-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm: vmscan: reduce throttling due to a failure to make progress -fix

Hugh Dickins reported the following

	My tmpfs swapping load (tweaked to use huge pages more heavily
	than in real life) is far from being a realistic load: but it was
	notably slowed down by your throttling mods in 5.16-rc, and this
	patch makes it well again - thanks.

	But: it very quickly hit NULL pointer until I changed that last
	line to

        if (first_pgdat)
                consider_reclaim_throttle(first_pgdat, sc);

The likely issue is that huge pages are a major component of the test
workload. When this is the case, first_pgdat may never get set if
compaction is ready to continue due to this check

        if (IS_ENABLED(CONFIG_COMPACTION) &&
            sc->order > PAGE_ALLOC_COSTLY_ORDER &&
            compaction_ready(zone, sc)) {
                sc->compaction_ready = true;
                continue;
        }

If this was true for every zone in the zonelist, first_pgdat would never
get set resulting in a NULL pointer exception.

This is a fix to the mmotm patch
mm-vmscan-reduce-throttling-due-to-a-failure-to-make-progress.patch

Link: https://lkml.kernel.org/r/20211209095453.GM3366@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reported-by: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Rik van Riel <riel@surriel.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-reduce-throttling-due-to-a-failure-to-make-progress-fix
+++ a/mm/vmscan.c
@@ -3530,7 +3530,8 @@ static void shrink_zones(struct zonelist
 		shrink_node(zone->zone_pgdat, sc);
 	}
 
-	consider_reclaim_throttle(first_pgdat, sc);
+	if (first_pgdat)
+		consider_reclaim_throttle(first_pgdat, sc);
 
 	/*
 	 * Restore to original mask to avoid the impact on the caller if we
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-vmscan-reduce-throttling-due-to-a-failure-to-make-progress.patch
mm-vmscan-reduce-throttling-due-to-a-failure-to-make-progress-fix.patch

