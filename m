Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00C5BC77B7E
	for <mm-commits@archiver.kernel.org>; Thu, 25 May 2023 19:54:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242080AbjEYTy0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 May 2023 15:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242150AbjEYTyS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2023 15:54:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA5E2B6
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 12:53:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49B0C64AC5
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 19:53:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A068CC433EF;
        Thu, 25 May 2023 19:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685044421;
        bh=wWL2GrD/ax2xXXWjjj91uPdIpXVxNbTtdw1zPZUu4Cw=;
        h=Date:To:From:Subject:From;
        b=Hgn7ZhwZKJ+GFjO6GMEMRIheMWhhzXWtZntlVYtf6TkPk5AznHSifs16YCak6/0bq
         akTrW5/9VP4/uLvYQ2aGtvn8sCDoi/9pGbH7AeIRpZSc8h5cAmgscW2JqNtoRJGlzo
         I2vA9zVf/Z+PSweSNmY9Sw/+JDWLCiuzCTYke7qk=
Date:   Thu, 25 May 2023 12:53:40 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        mgorman@techsingularity.net, baolin.wang@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-skip-fast-freepages-isolation-if-enough-freepages-are-isolated.patch added to mm-unstable branch
Message-Id: <20230525195341.A068CC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: skip fast freepages isolation if enough freepages are isolated
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-skip-fast-freepages-isolation-if-enough-freepages-are-isolated.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-skip-fast-freepages-isolation-if-enough-freepages-are-isolated.patch

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
Subject: mm: compaction: skip fast freepages isolation if enough freepages are isolated
Date: Thu, 25 May 2023 20:54:01 +0800

I've observed that fast isolation often isolates more pages than
cc->migratepages, and the excess freepages will be released back to the
buddy system.  So skip fast freepages isolation if enough freepages are
isolated to save some CPU cycles.

Link: https://lkml.kernel.org/r/f39c2c07f2dba2732fd9c0843572e5bef96f7f67.1685018752.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/compaction.c~mm-compaction-skip-fast-freepages-isolation-if-enough-freepages-are-isolated
+++ a/mm/compaction.c
@@ -1558,6 +1558,10 @@ static void fast_isolate_freepages(struc
 
 		spin_unlock_irqrestore(&cc->zone->lock, flags);
 
+		/* Skip fast search if enough freepages isolated */
+		if (cc->nr_freepages >= cc->nr_migratepages)
+			break;
+
 		/*
 		 * Smaller scan on next order so the total scan is related
 		 * to freelist_scan_limit.
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-page_alloc-drop-the-unnecessary-pfn_valid-for-start-pfn.patch
mm-compaction-drop-the-redundant-page-validation-in-update_pageblock_skip.patch
mm-compaction-change-fast_isolate_freepages-to-void-type.patch
mm-compaction-skip-more-fully-scanned-pageblock.patch
mm-compaction-only-set-skip-flag-if-cc-no_set_skip_hint-is-false.patch
mm-compaction-add-trace-event-for-fast-freepages-isolation.patch
mm-compaction-skip-fast-freepages-isolation-if-enough-freepages-are-isolated.patch

