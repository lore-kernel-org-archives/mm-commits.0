Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF33EC61DA4
	for <mm-commits@archiver.kernel.org>; Thu, 16 Feb 2023 22:43:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbjBPWns (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Feb 2023 17:43:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjBPWnr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Feb 2023 17:43:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3658246164
        for <mm-commits@vger.kernel.org>; Thu, 16 Feb 2023 14:43:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D82F7B829D6
        for <mm-commits@vger.kernel.org>; Thu, 16 Feb 2023 22:43:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE33C433EF;
        Thu, 16 Feb 2023 22:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676587423;
        bh=AemsdlfTKGgWXOnDRt8XEfCLjn21ieoWbsVUZ3wBTk4=;
        h=Date:To:From:Subject:From;
        b=L/Vv46WpcFK8GUcpYUKGr68UcYQ+OWkwNo6gKq/hFEU2VQYwaB1cS2iFgJRtNAfAq
         HwrY+g0iy+XFS1iIC8KIFgAuAkdakl4b1b3aawoRCI1CyZWKPIaV3pGySYsn/TVGO2
         47kDItdSzD3GgEWaHPf8iO6/2ToArPVq6oStG04s=
Date:   Thu, 16 Feb 2023 14:43:42 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        torvalds@linux-foundation.org, sj@kernel.org, david@redhat.com,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-change-to-return-bool-for-isolate_movable_page-fix.patch added to mm-unstable branch
Message-Id: <20230216224343.6BE33C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-change-to-return-bool-for-isolate_movable_page-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-change-to-return-bool-for-isolate_movable_page-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-change-to-return-bool-for-isolate_movable_page-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-change-to-return-bool-for-isolate_movable_page-fix
Date: Thu Feb 16 02:41:42 PM PST 2023

remove unneeded comment, per Matthew

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/memory_hotplug.c~mm-change-to-return-bool-for-isolate_movable_page-fix
+++ a/mm/memory_hotplug.c
@@ -1672,7 +1672,7 @@ do_migrate_range(unsigned long start_pfn
 			isolated = isolate_lru_page(page);
 		else
 			isolated = isolate_movable_page(page, ISOLATE_UNEVICTABLE);
-		if (isolated) { /* Success */
+		if (isolated) {
 			list_add_tail(&page->lru, &source);
 			if (!__PageMovable(page))
 				inc_node_page_state(page, NR_ISOLATED_ANON +
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

lib-stackdepot-mm-rename-stack_depot_want_early_init-fix.patch
lib-stackdepot-move-documentation-comments-to-stackdepoth-fix.patch
mm-hugetlb-change-to-return-bool-for-isolate_hugetlb-fix.patch
mm-change-to-return-bool-for-isolate_movable_page-fix.patch

