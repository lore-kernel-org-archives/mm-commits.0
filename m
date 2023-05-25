Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CA08C7EE29
	for <mm-commits@archiver.kernel.org>; Thu, 25 May 2023 19:54:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242111AbjEYTyB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 May 2023 15:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241599AbjEYTxz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2023 15:53:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49CF8E56
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 12:53:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF13164ABE
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 19:53:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2095FC433EF;
        Thu, 25 May 2023 19:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685044412;
        bh=5U7r2iNYJUQ0XnpIs9ivQnuveJ5TcTUj//KjV5BlfNw=;
        h=Date:To:From:Subject:From;
        b=ftdjlvglq1wzk4iIofhL0fKCJTAIa/LAfGRghqvYpJ80WUdLSeXX4Cu19V7QfIt+R
         yO/X2CCVnSaBldafTHlu+PMxaxtYBKv7jC3laPqvVIKzc7ALWK4KSQk5zv7iGEsnp2
         phNVjggFTjI2c4dD8ot1VNskJRXAfP3x5P7Y1iAQ=
Date:   Thu, 25 May 2023 12:53:31 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        mgorman@techsingularity.net, baolin.wang@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-drop-the-redundant-page-validation-in-update_pageblock_skip.patch added to mm-unstable branch
Message-Id: <20230525195332.2095FC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: drop the redundant page validation in update_pageblock_skip()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-drop-the-redundant-page-validation-in-update_pageblock_skip.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-drop-the-redundant-page-validation-in-update_pageblock_skip.patch

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
Subject: mm: compaction: drop the redundant page validation in update_pageblock_skip()
Date: Thu, 25 May 2023 20:53:56 +0800

Patch series "Misc cleanups and improvements for compaction".

This series cantains some cleanups and improvements for compaction.


This patch (of 6):

The caller has validated the page before calling pdate_pageblock_skip(),
thus drop the redundant page validation in update_pageblock_skip().

Link: https://lkml.kernel.org/r/5142e15b9295fe8c447dbb39b7907a20177a1413.1685018752.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/compaction.c~mm-compaction-drop-the-redundant-page-validation-in-update_pageblock_skip
+++ a/mm/compaction.c
@@ -436,9 +436,6 @@ static void update_pageblock_skip(struct
 	if (cc->no_set_skip_hint)
 		return;
 
-	if (!page)
-		return;
-
 	set_pageblock_skip(page);
 
 	/* Update where async and sync compaction should restart */
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-page_alloc-drop-the-unnecessary-pfn_valid-for-start-pfn.patch
mm-compaction-drop-the-redundant-page-validation-in-update_pageblock_skip.patch
mm-compaction-change-fast_isolate_freepages-to-void-type.patch
mm-compaction-skip-more-fully-scanned-pageblock.patch
mm-compaction-only-set-skip-flag-if-cc-no_set_skip_hint-is-false.patch
mm-compaction-add-trace-event-for-fast-freepages-isolation.patch
mm-compaction-skip-fast-freepages-isolation-if-enough-freepages-are-isolated.patch

