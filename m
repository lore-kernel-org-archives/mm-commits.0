Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74C63C7EE25
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:32:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232734AbjFIXcg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232849AbjFIXbh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:31:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 060CA468C
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:29:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DAF3665CD2
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:29:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40DC3C433D2;
        Fri,  9 Jun 2023 23:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353362;
        bh=1fsXsI7c1uzDEKQhGP+NLCuKBb2tUVwwpMyChSSyZsA=;
        h=Date:To:From:Subject:From;
        b=HFHO7+Aa1+iuts5c4xhXl0baJ4ZJxCUDJeGzp3UwabbZQSsequhUTYUAhXduPxNMg
         AvQXylsAWVEeWquzZ4qlQvQ07RMbXaoY90LljeoRVv5BJG1Zl00CKdbmFL1jqDTDIK
         /6CvD80Q24rzwLGaVaVF4/QYMcxwt0bpDa1giEvo=
Date:   Fri, 09 Jun 2023 16:29:21 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        mgorman@techsingularity.net, baolin.wang@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-only-set-skip-flag-if-cc-no_set_skip_hint-is-false.patch removed from -mm tree
Message-Id: <20230609232922.40DC3C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: compaction: only set skip flag if cc->no_set_skip_hint is false
has been removed from the -mm tree.  Its filename was
     mm-compaction-only-set-skip-flag-if-cc-no_set_skip_hint-is-false.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: compaction: only set skip flag if cc->no_set_skip_hint is false
Date: Thu, 25 May 2023 20:53:59 +0800

To keep the same logic as test_and_set_skip(), only set the skip flag if
cc->no_set_skip_hint is false, which makes code more reasonable.

Link: https://lkml.kernel.org/r/0eb2cd2407ffb259ae6e3071e10f70f2d41d0f3e.1685018752.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/compaction.c~mm-compaction-only-set-skip-flag-if-cc-no_set_skip_hint-is-false
+++ a/mm/compaction.c
@@ -1201,7 +1201,7 @@ isolate_abort:
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


