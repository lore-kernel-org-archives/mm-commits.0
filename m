Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 998F7C7EE25
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:28:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbjFIX2M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbjFIX1p (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:27:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC7E13AB1
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:27:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A2EC65CD4
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:27:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB530C433D2;
        Fri,  9 Jun 2023 23:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353250;
        bh=3nxu4tck0kPXbCk3Oohywcv435YzHoTbOCI72ackQWs=;
        h=Date:To:From:Subject:From;
        b=cZBypee8hDt7DasmV4sd02/NMbaDcN125s3aoN1WXfUrkxKb4c5flUFCWQZpbpcYT
         6f0RhSiXI0310En5ReND0bQ0mRbtD++zo20PsFMEtayNmyu+anoOlsRdTOA62bYpwx
         vJ08oQadNFMLvvZc0CazV1G1HJ7NjmX0FqZ6OIl4=
Date:   Fri, 09 Jun 2023 16:27:29 -0700
To:     mm-commits@vger.kernel.org, zhouchuyi@bytedance.com,
        vbabka@suse.cz, raghavendra.kt@amd.com, pedro.falcato@gmail.com,
        pbonzini@redhat.com, mlevitsk@redhat.com, mhocko@kernel.org,
        jirislaby@kernel.org, mgorman@techsingularity.net,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-only-force-pageblock-scan-completion-when-skip-hints-are-obeyed.patch removed from -mm tree
Message-Id: <20230609232729.DB530C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: compaction: only force pageblock scan completion when skip hints are obeyed
has been removed from the -mm tree.  Its filename was
     mm-compaction-only-force-pageblock-scan-completion-when-skip-hints-are-obeyed.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm: compaction: only force pageblock scan completion when skip hints are obeyed
Date: Mon, 15 May 2023 12:33:42 +0100

fast_find_migrateblock relies on skip hints to avoid rescanning a recently
selected pageblock but compact_zone() only forces the pageblock scan
completion to set the skip hint if in direct compaction.  While this
prevents direct compaction repeatedly scanning a subset of blocks due to
fast_find_migrateblock(), it does not prevent proactive compaction, node
compaction and kcompactd encountering the same problem described in commit
cfccd2e63e7e ("mm, compaction: finish pageblocks on complete migration
failure").

Force the scan completion of a pageblock to set the skip hint if skip
hints are obeyed to prevent fast_find_migrateblock() repeatedly selecting
a subset of pageblocks.

Link: https://lkml.kernel.org/r/20230515113344.6869-3-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Raghavendra K T <raghavendra.kt@amd.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Chuyi Zhou <zhouchuyi@bytedance.com>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Pedro Falcato <pedro.falcato@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/compaction.c~mm-compaction-only-force-pageblock-scan-completion-when-skip-hints-are-obeyed
+++ a/mm/compaction.c
@@ -2457,7 +2457,8 @@ rescan:
 			}
 			/*
 			 * If an ASYNC or SYNC_LIGHT fails to migrate a page
-			 * within the current order-aligned block, scan the
+			 * within the current order-aligned block and
+			 * fast_find_migrateblock may be used then scan the
 			 * remainder of the pageblock. This will mark the
 			 * pageblock "skip" to avoid rescanning in the near
 			 * future. This will isolate more pages than necessary
@@ -2466,7 +2467,7 @@ rescan:
 			 * recently partially scanned.
 			 */
 			if (!pageblock_aligned(cc->migrate_pfn) &&
-			    cc->direct_compaction && !cc->finish_pageblock &&
+			    !cc->ignore_skip_hint && !cc->finish_pageblock &&
 			    (cc->mode < MIGRATE_SYNC)) {
 				cc->finish_pageblock = true;
 
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


