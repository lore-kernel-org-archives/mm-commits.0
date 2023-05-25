Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C111C7EE29
	for <mm-commits@archiver.kernel.org>; Thu, 25 May 2023 19:54:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241497AbjEYTyP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 May 2023 15:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241599AbjEYTyM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2023 15:54:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B2D2E62
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 12:53:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BBF660B21
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 19:53:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4112C433EF;
        Thu, 25 May 2023 19:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685044415;
        bh=GuGcQwdLC3MMxjXU7mEvxm5vnn9+5JhZTlAAXldTG3o=;
        h=Date:To:From:Subject:From;
        b=pRLwaUvgJ7KY+ztsC1KTIgMkCWs8eYOb7C3fKQ6Ju3qDp6Utzw5YzK48C3vZfrkma
         W5mZshFJf0HcSV7i2qzZiUl8XCM8gphGKLwQmsjWx687BQUAi4yfYPCjxTAiPGHqpb
         s7LSGjNi10ORB41y9VjLQXUmspEvE1FDOcHB0Gw4=
Date:   Thu, 25 May 2023 12:53:35 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        mgorman@techsingularity.net, baolin.wang@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-skip-more-fully-scanned-pageblock.patch added to mm-unstable branch
Message-Id: <20230525195335.B4112C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: skip more fully scanned pageblock
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-skip-more-fully-scanned-pageblock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-skip-more-fully-scanned-pageblock.patch

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
Subject: mm: compaction: skip more fully scanned pageblock
Date: Thu, 25 May 2023 20:53:58 +0800

In fast_isolate_around(), it assumes the pageblock is fully scanned if
cc->nr_freepages < cc->nr_migratepages after trying to isolate some free
pages, and will set skip flag to avoid scanning in future.  However this
can miss setting the skip flag for a fully scanned pageblock (returned
'start_pfn' is equal to 'end_pfn') in the case where cc->nr_freepages is
larger than cc->nr_migratepages.

So using the returned 'start_pfn' from isolate_freepages_block() and
'end_pfn' to decide if a pageblock is fully scanned makes more sense.  It
can also cover the case where cc->nr_freepages < cc->nr_migratepages,
which means the 'start_pfn' is usually equal to 'end_pfn' except some
uncommon fatal error occurs after non-strict mode isolation.

Link: https://lkml.kernel.org/r/f4efd2fa08735794a6d809da3249b6715ba6ad38.1685018752.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/compaction.c~mm-compaction-skip-more-fully-scanned-pageblock
+++ a/mm/compaction.c
@@ -1419,7 +1419,7 @@ fast_isolate_around(struct compact_contr
 	isolate_freepages_block(cc, &start_pfn, end_pfn, &cc->freepages, 1, false);
 
 	/* Skip this pageblock in the future as it's full or nearly full */
-	if (cc->nr_freepages < cc->nr_migratepages)
+	if (start_pfn == end_pfn)
 		set_pageblock_skip(page);
 
 	return;
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-page_alloc-drop-the-unnecessary-pfn_valid-for-start-pfn.patch
mm-compaction-drop-the-redundant-page-validation-in-update_pageblock_skip.patch
mm-compaction-change-fast_isolate_freepages-to-void-type.patch
mm-compaction-skip-more-fully-scanned-pageblock.patch
mm-compaction-only-set-skip-flag-if-cc-no_set_skip_hint-is-false.patch
mm-compaction-add-trace-event-for-fast-freepages-isolation.patch
mm-compaction-skip-fast-freepages-isolation-if-enough-freepages-are-isolated.patch

