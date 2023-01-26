Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 927ACC54E94
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 01:17:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbjAZBRt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Jan 2023 20:17:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235536AbjAZBRr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2023 20:17:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC773A9B
        for <mm-commits@vger.kernel.org>; Wed, 25 Jan 2023 17:17:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03A2FB81C6F
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 01:17:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 747CFC4339B;
        Thu, 26 Jan 2023 01:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674695862;
        bh=wqavTumsN5CWyqM3WSoxhoStZ3NBgChXETigw0Xb67I=;
        h=Date:To:From:Subject:From;
        b=baFqj2Tr/8i5nfRtR8X38xmqiRQS7awOtoYRNQ+RbNTt3DeGtSEUAh1MKK6sINHFX
         f8V5sNz7Tpc2QDRUeISUwkb0tFpa0uzAmgYqr1OW/6EWgasDwRB7CSwAz6fSIEabgS
         LcCYipYCJFvdMKQjoT61qJAhWxaOnPBgQwLkLeO8=
Date:   Wed, 25 Jan 2023 17:17:41 -0800
To:     mm-commits@vger.kernel.org, zhouchuyi@bytedance.com,
        vbabka@suse.cz, pedro.falcato@gmail.com, pbonzini@redhat.com,
        mlevitsk@redhat.com, mhocko@kernel.org, jirislaby@kernel.org,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-finish-scanning-the-current-pageblock-if-requested.patch added to mm-unstable branch
Message-Id: <20230126011742.747CFC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: finish scanning the current pageblock if requested
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-finish-scanning-the-current-pageblock-if-requested.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-finish-scanning-the-current-pageblock-if-requested.patch

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
Subject: mm, compaction: finish scanning the current pageblock if requested
Date: Wed, 25 Jan 2023 13:44:33 +0000

cc->finish_pageblock is set when the current pageblock should be rescanned
but fast_find_migrateblock can select an alternative block.  Disable
fast_find_migrateblock when the current pageblock scan should be
completed.

Link: https://lkml.kernel.org/r/20230125134434.18017-4-mgorman@techsingularity.net
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


--- a/mm/compaction.c~mm-compaction-finish-scanning-the-current-pageblock-if-requested
+++ a/mm/compaction.c
@@ -1762,6 +1762,13 @@ static unsigned long fast_find_migratebl
 		return pfn;
 
 	/*
+	 * If the pageblock should be finished then do not select a different
+	 * pageblock.
+	 */
+	if (cc->finish_pageblock)
+		return pfn;
+
+	/*
 	 * If the migrate_pfn is not at the start of a zone or the start
 	 * of a pageblock then assume this is a continuation of a previous
 	 * scan restarted due to COMPACT_CLUSTER_MAX.
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

