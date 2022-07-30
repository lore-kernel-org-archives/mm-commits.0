Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA21BC19F2B
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:08:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239615AbiG3BI0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239572AbiG3BIX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:08:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C4178221
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:08:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 901E7B82929
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:08:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DFCFC433C1;
        Sat, 30 Jul 2022 01:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143299;
        bh=to6fLHkkbGS698gk2KwkK0XefsYNsgleXd9GBt+n85g=;
        h=Date:To:From:Subject:From;
        b=mlZgJoURKt655CgiEdBQmsOPh1upGN8BHYSzrjVFucY/R5BIy5nBlVcgbZcwwnI/U
         P5fOMK6xCrMDDOQrd29gxQ9nF93RuyhKuKYB9+XlAntp6ZGmu5teygAbZe4E/qldo7
         22HzFcyzDZMrrGbOHGvReBm3yvFpKZIwcnDEuB2k=
Date:   Fri, 29 Jul 2022 18:08:18 -0700
To:     mm-commits@vger.kernel.org, punit.agrawal@bytedance.com,
        mgorman@techsingularity.net, william.lam@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-include-compound-page-count-for-scanning-in-pageblock-isolation.patch removed from -mm tree
Message-Id: <20220730010819.1DFCFC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: compaction: include compound page count for scanning in pageblock isolation
has been removed from the -mm tree.  Its filename was
     mm-compaction-include-compound-page-count-for-scanning-in-pageblock-isolation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: William Lam <william.lam@bytedance.com>
Subject: mm: compaction: include compound page count for scanning in pageblock isolation
Date: Mon, 11 Jul 2022 21:28:06 +0100

The number of scanned pages can be lower than the number of isolated pages
when isolating mirgratable or free pageblock.  The metric is being
reported in trace event and also used in vmstat.

some example output from trace where it shows nr_taken can be greater
than nr_scanned:

Produced by kernel v5.19-rc6
kcompactd0-42      [001] .....  1210.268022: mm_compaction_isolate_migratepages: range=(0x107ae4 ~ 0x107c00) nr_scanned=265 nr_taken=255
[...]
kcompactd0-42      [001] .....  1210.268382: mm_compaction_isolate_freepages: range=(0x215800 ~ 0x215a00) nr_scanned=13 nr_taken=128
kcompactd0-42      [001] .....  1210.268383: mm_compaction_isolate_freepages: range=(0x215600 ~ 0x215680) nr_scanned=1 nr_taken=128

mm_compaction_isolate_migratepages does not seem to have this
behaviour, but for the reason of consistency, nr_scanned should also be
taken care of in that side.

This behaviour is confusing since currently the count for isolated pages
takes account of compound page but not for the case of scanned pages.  And
given that the number of isolated pages(nr_taken) reported in
mm_compaction_isolate_template trace event is on a single-page basis, the
ambiguity when reporting the number of scanned pages can be removed by
also including compound page count.

Link: https://lkml.kernel.org/r/20220711202806.22296-1-william.lam@bytedance.com
Signed-off-by: William Lam <william.lam@bytedance.com>
Reviewed-by: Punit Agrawal <punit.agrawal@bytedance.com>
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


