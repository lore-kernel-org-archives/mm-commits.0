Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE327C43334
	for <mm-commits@archiver.kernel.org>; Wed, 13 Jul 2022 18:17:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbiGMSRl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Jul 2022 14:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbiGMSRk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jul 2022 14:17:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 941092E6B0
        for <mm-commits@vger.kernel.org>; Wed, 13 Jul 2022 11:17:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DA2761D69
        for <mm-commits@vger.kernel.org>; Wed, 13 Jul 2022 18:17:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A1E1C34114;
        Wed, 13 Jul 2022 18:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657736258;
        bh=8ppyH89PtdXTN1s1xecYisZ1Mr3uwr7KaszrICgrIhM=;
        h=Date:To:From:Subject:From;
        b=BxtnWQ+hRd9ScGswP4TNnsYVsiqkmjptMy91SGKFqu6/fyQb2WX1GqT2q9Iuw/vmd
         LCyo0n/klYKzZ+p90FR4rtC5edL86DcnbrperVxiiuB1Gr93FikNNXfo0Uczf/yZ22
         i3WneOVvPIe6A4/+8WtwyWgWj2LukPYhCW/YaSVE=
Date:   Wed, 13 Jul 2022 11:17:37 -0700
To:     mm-commits@vger.kernel.org, mgorman@techsingularity.net,
        william.lam@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-include-compound-page-count-for-scanning-in-pageblock-isolation.patch added to mm-unstable branch
Message-Id: <20220713181738.7A1E1C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: include compound page count for scanning in pageblock isolation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-include-compound-page-count-for-scanning-in-pageblock-isolation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-include-compound-page-count-for-scanning-in-pageblock-isolation.patch

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
From: William Lam <william.lam@bytedance.com>
Subject: mm: compaction: include compound page count for scanning in pageblock isolation
Date: Mon, 11 Jul 2022 21:28:06 +0100

The number of scanned pages can be lower than the number of isolated pages
when isolating mirgratable or free pageblock.  The metric is being
reported in trace event and also used in vmstat.

This behaviour is confusing since currently the count for isolated pages
takes account of compound page but not for the case of scanned pages.  And
given that the number of isolated pages(nr_taken) reported in
mm_compaction_isolate_template trace event is on a single-page basis, the
ambiguity when reporting the number of scanned pages can be removed by
also including compound page count.

Link: https://lkml.kernel.org/r/20220711202806.22296-1-william.lam@bytedance.com
Signed-off-by: William Lam <william.lam@bytedance.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/compaction.c~mm-compaction-include-compound-page-count-for-scanning-in-pageblock-isolation
+++ a/mm/compaction.c
@@ -616,6 +616,7 @@ static unsigned long isolate_freepages_b
 			break;
 		set_page_private(page, order);
 
+		nr_scanned += isolated - 1;
 		total_isolated += isolated;
 		cc->nr_freepages += isolated;
 		list_add_tail(&page->lru, freelist);
@@ -1101,6 +1102,7 @@ isolate_success:
 isolate_success_no_list:
 		cc->nr_migratepages += compound_nr(page);
 		nr_isolated += compound_nr(page);
+		nr_scanned += compound_nr(page) - 1;
 
 		/*
 		 * Avoid isolating too much unless this block is being
@@ -1504,6 +1506,7 @@ fast_isolate_freepages(struct compact_co
 			if (__isolate_free_page(page, order)) {
 				set_page_private(page, order);
 				nr_isolated = 1 << order;
+				nr_scanned += nr_isolated - 1;
 				cc->nr_freepages += nr_isolated;
 				list_add_tail(&page->lru, &cc->freepages);
 				count_compact_events(COMPACTISOLATED, nr_isolated);
_

Patches currently in -mm which might be from william.lam@bytedance.com are

mm-compaction-include-compound-page-count-for-scanning-in-pageblock-isolation.patch

