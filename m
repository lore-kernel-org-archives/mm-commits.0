Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F06DC433ED
	for <mm-commits@archiver.kernel.org>; Fri, 14 May 2021 21:03:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7192161440
	for <mm-commits@archiver.kernel.org>; Fri, 14 May 2021 21:03:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbhENVE1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 May 2021 17:04:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:46216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234213AbhENVDW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 14 May 2021 17:03:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A501061155;
        Fri, 14 May 2021 21:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621026130;
        bh=4Wf2gd0T0Ngl5kKELRXxWzgX7k5DLPfQdQAVp5wqFYA=;
        h=Date:From:To:Subject:From;
        b=wMyxd+yKOlvuO/hO3LP6syuzKTIsa2nWz1fHd7c5KkgvpjxHVAOeDAl6gxtveimyh
         Ypo0IkleYJPBY44boA2uuS9ajOQPjvdikD8mWaTmf5IODar+d6lt8xeaICX+MgSjQZ
         BVT5BChzVFb8zo1RPznUNN2ljfxqrF7sTwY8ovNs=
Date:   Fri, 14 May 2021 14:02:10 -0700
From:   akpm@linux-foundation.org
To:     mgorman@techsingularity.net, mm-commits@vger.kernel.org
Subject:  +
 mm-page_alloc-split-per-cpu-page-lists-and-zone-stats-fix.patch added to
 -mm tree
Message-ID: <20210514210210.Od1odHkMO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: split per cpu page lists and zone stats -fix
has been added to the -mm tree.  Its filename is
     mm-page_alloc-split-per-cpu-page-lists-and-zone-stats-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-split-per-cpu-page-lists-and-zone-stats-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-split-per-cpu-page-lists-and-zone-stats-fix.patch

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
Subject: mm/page_alloc: split per cpu page lists and zone stats -fix

mm/ is not W=1 clean for allnoconfig but the patch "mm/page_alloc: Split
per cpu page lists and zone stats" makes it worse with the following
warning

  mm/vmstat.c: In function `zoneinfo_show_print':
  mm/vmstat.c:1698:28: warning: variable `pzstats' set but not used [-Wunused-but-set-variable]
     struct per_cpu_zonestat *pzstats;
                              ^~~~~~~

This is a fix to the mmotm patch
mm-page_alloc-split-per-cpu-page-lists-and-zone-stats.patch.

Link: https://lkml.kernel.org/r/20210514144622.GA3735@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmstat.c~mm-page_alloc-split-per-cpu-page-lists-and-zone-stats-fix
+++ a/mm/vmstat.c
@@ -1695,10 +1695,9 @@ static void zoneinfo_show_print(struct s
 	seq_printf(m, "\n  pagesets");
 	for_each_online_cpu(i) {
 		struct per_cpu_pages *pcp;
-		struct per_cpu_zonestat *pzstats;
+		struct per_cpu_zonestat __maybe_unused *pzstats;
 
 		pcp = per_cpu_ptr(zone->per_cpu_pageset, i);
-		pzstats = per_cpu_ptr(zone->per_cpu_zonestats, i);
 		seq_printf(m,
 			   "\n    cpu: %i"
 			   "\n              count: %i"
@@ -1709,6 +1708,7 @@ static void zoneinfo_show_print(struct s
 			   pcp->high,
 			   pcp->batch);
 #ifdef CONFIG_SMP
+		pzstats = per_cpu_ptr(zone->per_cpu_zonestats, i);
 		seq_printf(m, "\n  vm stats threshold: %d",
 				pzstats->stat_threshold);
 #endif
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-split-per-cpu-page-lists-and-zone-stats.patch
mm-page_alloc-split-per-cpu-page-lists-and-zone-stats-fix.patch
mm-page_alloc-convert-per-cpu-list-protection-to-local_lock.patch
mm-vmstat-convert-numa-statistics-to-basic-numa-counters.patch
mm-vmstat-inline-numa-event-counter-updates.patch
mm-page_alloc-batch-the-accounting-updates-in-the-bulk-allocator.patch
mm-page_alloc-reduce-duration-that-irqs-are-disabled-for-vm-counters.patch
mm-page_alloc-explicitly-acquire-the-zone-lock-in-__free_pages_ok.patch
mm-page_alloc-avoid-conflating-irqs-disabled-with-zone-lock.patch
mm-page_alloc-update-pgfree-outside-the-zone-lock-in-__free_pages_ok.patch

