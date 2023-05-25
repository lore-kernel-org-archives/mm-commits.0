Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29E9EC77B7E
	for <mm-commits@archiver.kernel.org>; Thu, 25 May 2023 19:54:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242133AbjEYTyQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 May 2023 15:54:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242073AbjEYTyO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2023 15:54:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7019E43
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 12:53:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CD5464AC9
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 19:53:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3AD1C433D2;
        Thu, 25 May 2023 19:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685044417;
        bh=Jcu7Bs1ffjTnTRHXsE6IvwIGeyXB5V6Di9ZyAI+vyn4=;
        h=Date:To:From:Subject:From;
        b=AnsdPcPLqR9naYmcWfAfumtmh0ptf5BA05mCVo5dL6KPre4qWkGzc95SBj3sAIiIN
         6T1/NsD6ye59QPH4hC2CCN9LDDdrzsFDiuYLR5Bwnxc43aFERpkxbDjOgpicukH9yH
         n2+lnqtTacCwzSD0WM1f9AU5Gyjjs5/ozAPTrNNY=
Date:   Thu, 25 May 2023 12:53:36 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        mgorman@techsingularity.net, baolin.wang@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-only-set-skip-flag-if-cc-no_set_skip_hint-is-false.patch added to mm-unstable branch
Message-Id: <20230525195337.A3AD1C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: only set skip flag if cc->no_set_skip_hint is false
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-only-set-skip-flag-if-cc-no_set_skip_hint-is-false.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-only-set-skip-flag-if-cc-no_set_skip_hint-is-false.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: compaction: only set skip flag if cc->no_set_skip_hint is false
Date: Thu, 25 May 2023 20:53:59 +0800

To keep the same logic as test_and_set_skip(), only set the skip flag if
cc->no_set_skip_hint is false, which makes code more reasonable.

Link: https://lkml.kernel.org/r/0eb2cd2407ffb259ae6e3071e10f70f2d41d0f3e.1685018752.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/compaction.c~mm-compaction-only-set-skip-flag-if-cc-no_set_skip_hint-is-false
+++ a/mm/compaction.c
@@ -1231,7 +1231,7 @@ isolate_abort:
 	 * rescanned twice in a row.
 	 */
 	if (low_pfn == end_pfn && (!nr_isolated || cc->finish_pageblock)) {
-		if (valid_page && !skip_updated)
+		if (!cc->no_set_skip_hint && valid_page && !skip_updated)
 			set_pageblock_skip(valid_page);
 		update_cached_migrate(cc, low_pfn);
 	}
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-page_alloc-drop-the-unnecessary-pfn_valid-for-start-pfn.patch
mm-compaction-drop-the-redundant-page-validation-in-update_pageblock_skip.patch
mm-compaction-change-fast_isolate_freepages-to-void-type.patch
mm-compaction-skip-more-fully-scanned-pageblock.patch
mm-compaction-only-set-skip-flag-if-cc-no_set_skip_hint-is-false.patch
mm-compaction-add-trace-event-for-fast-freepages-isolation.patch
mm-compaction-skip-fast-freepages-isolation-if-enough-freepages-are-isolated.patch

