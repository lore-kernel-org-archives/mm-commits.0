Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47690C27C76
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 01:17:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234924AbjAZBRp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Jan 2023 20:17:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjAZBRm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2023 20:17:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCB4D45BC4
        for <mm-commits@vger.kernel.org>; Wed, 25 Jan 2023 17:17:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B9E161715
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 01:17:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6585C433D2;
        Thu, 26 Jan 2023 01:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674695860;
        bh=wUsr0Bq/9ia/7yG5Ryp08QFFxr3y+7mrtvB/BX/iznc=;
        h=Date:To:From:Subject:From;
        b=M1JFrCDbAc4Dj7l6bJjG3fCl5renrbcf/DFzU6pLJuM2JcX9f0S7vvRgjIIroiCbH
         Kjh6QsvbRAoR2JyB/NDrKzb6VHXC66yDT14CHf4ySVosp82FVFDq971RErOqB82OTp
         I9QoAzx2M41nySIPFIczucnoMxb93RZIGkXgKNNw=
Date:   Wed, 25 Jan 2023 17:17:39 -0800
To:     mm-commits@vger.kernel.org, zhouchuyi@bytedance.com,
        vbabka@suse.cz, pedro.falcato@gmail.com, pbonzini@redhat.com,
        mlevitsk@redhat.com, mhocko@kernel.org, jirislaby@kernel.org,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-check-if-a-page-has-been-captured-before-draining-pcp-pages.patch added to mm-unstable branch
Message-Id: <20230126011740.B6585C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: check if a page has been captured before draining PCP pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-check-if-a-page-has-been-captured-before-draining-pcp-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-check-if-a-page-has-been-captured-before-draining-pcp-pages.patch

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
Subject: mm, compaction: check if a page has been captured before draining PCP pages
Date: Wed, 25 Jan 2023 13:44:32 +0000

If a page has been captured then draining is unnecssary so check first for
a captured page.

Link: https://lkml.kernel.org/r/20230125134434.18017-3-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Chuyi Zhou <zhouchuyi@bytedance.com>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Pedro Falcato <pedro.falcato@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/compaction.c~mm-compaction-check-if-a-page-has-been-captured-before-draining-pcp-pages
+++ a/mm/compaction.c
@@ -2440,6 +2440,12 @@ compact_zone(struct compact_control *cc,
 			}
 		}
 
+		/* Stop if a page has been captured */
+		if (capc && capc->page) {
+			ret = COMPACT_SUCCESS;
+			break;
+		}
+
 check_drain:
 		/*
 		 * Has the migration scanner moved away from the previous
@@ -2458,12 +2464,6 @@ check_drain:
 				last_migrated_pfn = 0;
 			}
 		}
-
-		/* Stop if a page has been captured */
-		if (capc && capc->page) {
-			ret = COMPACT_SUCCESS;
-			break;
-		}
 	}
 
 out:
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-rename-alloc_high-to-alloc_min_reserve.patch
mm-page_alloc-treat-rt-tasks-similar-to-__gfp_high.patch
mm-page_alloc-explicitly-record-high-order-atomic-allocations-in-alloc_flags.patch
mm-page_alloc-explicitly-define-what-alloc-flags-deplete-min-reserves.patch
mm-page_alloc-explicitly-define-how-__gfp_high-non-blocking-allocations-accesses-reserves.patch
mm-compaction-rename-compact_control-rescan-to-finish_pageblock.patch
mm-compaction-check-if-a-page-has-been-captured-before-draining-pcp-pages.patch
mm-compaction-finish-scanning-the-current-pageblock-if-requested.patch
mm-compaction-finish-pageblocks-on-complete-migration-failure.patch

