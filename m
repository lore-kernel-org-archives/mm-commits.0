Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B00EC77B7E
	for <mm-commits@archiver.kernel.org>; Thu, 25 May 2023 19:54:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242039AbjEYTyC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 May 2023 15:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242073AbjEYTx6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2023 15:53:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38A5187
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 12:53:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86A7F64AC2
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 19:53:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE168C433D2;
        Thu, 25 May 2023 19:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685044414;
        bh=6UaAZ7bgbcAhx7ZU1HoU0wi4amxX6E/aQlSZqY/3EI4=;
        h=Date:To:From:Subject:From;
        b=WIuCIaQfrLJAoyYgZA55HMuE0H40SPPvpBe+97AculmPqLXP+MeESLJfKNfTzSwXB
         78LPXt3roaPCLdDbbxCandM/lX0S85uBRsAdvqCeQh6ISogVWwbjwX3u8kumqmHzB8
         Br4lozeEuSs39w2OcG4ELatH2XzjBlW/Ez5J690w=
Date:   Thu, 25 May 2023 12:53:33 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        mgorman@techsingularity.net, baolin.wang@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-change-fast_isolate_freepages-to-void-type.patch added to mm-unstable branch
Message-Id: <20230525195333.DE168C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: change fast_isolate_freepages() to void type
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-change-fast_isolate_freepages-to-void-type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-change-fast_isolate_freepages-to-void-type.patch

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
Subject: mm: compaction: change fast_isolate_freepages() to void type
Date: Thu, 25 May 2023 20:53:57 +0800

No caller cares about the return value of fast_isolate_freepages(), void
it.

Link: https://lkml.kernel.org/r/759fca20b22ebf4c81afa30496837b9e0fb2e53b.1685018752.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/mm/compaction.c~mm-compaction-change-fast_isolate_freepages-to-void-type
+++ a/mm/compaction.c
@@ -1443,8 +1443,7 @@ static int next_search_order(struct comp
 	return order;
 }
 
-static unsigned long
-fast_isolate_freepages(struct compact_control *cc)
+static void fast_isolate_freepages(struct compact_control *cc)
 {
 	unsigned int limit = max(1U, freelist_scan_limit(cc) >> 1);
 	unsigned int nr_scanned = 0;
@@ -1457,7 +1456,7 @@ fast_isolate_freepages(struct compact_co
 
 	/* Full compaction passes in a negative order */
 	if (cc->order <= 0)
-		return cc->free_pfn;
+		return;
 
 	/*
 	 * If starting the scan, use a deeper search and use the highest
@@ -1596,11 +1595,10 @@ fast_isolate_freepages(struct compact_co
 
 	cc->total_free_scanned += nr_scanned;
 	if (!page)
-		return cc->free_pfn;
+		return;
 
 	low_pfn = page_to_pfn(page);
 	fast_isolate_around(cc, low_pfn);
-	return low_pfn;
 }
 
 /*
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-page_alloc-drop-the-unnecessary-pfn_valid-for-start-pfn.patch
mm-compaction-drop-the-redundant-page-validation-in-update_pageblock_skip.patch
mm-compaction-change-fast_isolate_freepages-to-void-type.patch
mm-compaction-skip-more-fully-scanned-pageblock.patch
mm-compaction-only-set-skip-flag-if-cc-no_set_skip_hint-is-false.patch
mm-compaction-add-trace-event-for-fast-freepages-isolation.patch
mm-compaction-skip-fast-freepages-isolation-if-enough-freepages-are-isolated.patch

