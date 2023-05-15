Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4819EC77B7D
	for <mm-commits@archiver.kernel.org>; Mon, 15 May 2023 19:35:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245226AbjEOTfz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 May 2023 15:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245197AbjEOTfr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 15 May 2023 15:35:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7909212080
        for <mm-commits@vger.kernel.org>; Mon, 15 May 2023 12:35:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE681631D3
        for <mm-commits@vger.kernel.org>; Mon, 15 May 2023 19:35:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C5A4C4339B;
        Mon, 15 May 2023 19:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684179344;
        bh=aGpL7aQn3UEZNDhD8ABzIjmbz1xUfIcfqwZVgqAvWPU=;
        h=Date:To:From:Subject:From;
        b=pUyQk/xRXIs8FFLhAsLtH7M2bPJottIb4gzt0Uz1GS7FQHyJISCtZYhqSomXQ3CKX
         GMPhUUdcrf/007TdU4i6+A0wz6jNBeHy2vC6iR9sTczYGbX/7sThFrlSEHLhNvN7pp
         PPJ92G6wS8xj0rMviJg+oJ9oINH54ltK9oRy6GFU=
Date:   Mon, 15 May 2023 12:35:43 -0700
To:     mm-commits@vger.kernel.org, zhouchuyi@bytedance.com,
        vbabka@suse.cz, pedro.falcato@gmail.com, pbonzini@redhat.com,
        mlevitsk@redhat.com, mhocko@kernel.org, jirislaby@kernel.org,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-only-force-pageblock-scan-completion-when-skip-hints-are-obeyed.patch added to mm-unstable branch
Message-Id: <20230515193544.1C5A4C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: only force pageblock scan completion when skip hints are obeyed
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-only-force-pageblock-scan-completion-when-skip-hints-are-obeyed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-only-force-pageblock-scan-completion-when-skip-hints-are-obeyed.patch

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
@@ -2485,7 +2485,8 @@ rescan:
 			}
 			/*
 			 * If an ASYNC or SYNC_LIGHT fails to migrate a page
-			 * within the current order-aligned block, scan the
+			 * within the current order-aligned block and
+			 * fast_find_migrateblock may be used then scan the
 			 * remainder of the pageblock. This will mark the
 			 * pageblock "skip" to avoid rescanning in the near
 			 * future. This will isolate more pages than necessary
@@ -2494,7 +2495,7 @@ rescan:
 			 * recently partially scanned.
 			 */
 			if (!pageblock_aligned(cc->migrate_pfn) &&
-			    cc->direct_compaction && !cc->finish_pageblock &&
+			    !cc->ignore_skip_hint && !cc->finish_pageblock &&
 			    (cc->mode < MIGRATE_SYNC)) {
 				cc->finish_pageblock = true;
 
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-compaction-ensure-rescanning-only-happens-on-partially-scanned-pageblocks.patch
mm-compaction-only-force-pageblock-scan-completion-when-skip-hints-are-obeyed.patch
mm-compaction-update-pageblock-skip-when-first-migration-candidate-is-not-at-the-start.patch
revert-revert-mm-compaction-fix-set-skip-in-fast_find_migrateblock.patch

