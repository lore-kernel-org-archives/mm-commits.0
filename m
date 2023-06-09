Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1490EC7EE43
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:28:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232563AbjFIX2P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjFIX1s (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:27:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 242A13AB2
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:27:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE94E60D2C
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:27:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 121CAC433D2;
        Fri,  9 Jun 2023 23:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353251;
        bh=5Y7hsHoMD4AlOeFnedcknMxqGPI8ySUMYDTWDxRYuMk=;
        h=Date:To:From:Subject:From;
        b=EcVVzzuS9JGHrOXjVDpAaQqRTAHg5IrSPg+lQBnIloCkTJQrL0oxTKumXh/JpRZCk
         LTqxYvDujHYja8FX4lU+a/J+DcH26FyzGn4OAFWMpD7LHKxy7g2ewgt34lq+kJC7cV
         r2u+ltCDIJ8oO+W1o1e/tqyBQNFUKubqHEoP5aN8=
Date:   Fri, 09 Jun 2023 16:27:30 -0700
To:     mm-commits@vger.kernel.org, zhouchuyi@bytedance.com,
        vbabka@suse.cz, raghavendra.kt@amd.com, pedro.falcato@gmail.com,
        pbonzini@redhat.com, mlevitsk@redhat.com, mhocko@kernel.org,
        jirislaby@kernel.org, mgorman@techsingularity.net,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-update-pageblock-skip-when-first-migration-candidate-is-not-at-the-start.patch removed from -mm tree
Message-Id: <20230609232731.121CAC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: compaction: update pageblock skip when first migration candidate is not at the start
has been removed from the -mm tree.  Its filename was
     mm-compaction-update-pageblock-skip-when-first-migration-candidate-is-not-at-the-start.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm: compaction: update pageblock skip when first migration candidate is not at the start
Date: Mon, 15 May 2023 12:33:43 +0100

isolate_migratepages_block should mark a pageblock as skip if scanning
started on an aligned pageblock boundary but it only updates the skip flag
if the first migration candidate is also aligned.  Tracing during a
compaction stress load (mmtests: workload-usemem-stress-numa-compact) that
many pageblocks are not marked skip causing excessive scanning of blocks
that had been recently checked.  Update pageblock skip based on
"valid_page" which is set if scanning started on a pageblock boundary.

[mgorman@techsingularity.net: fix handling of skip bit]
  Link: https://lkml.kernel.org/r/20230602111622.swtxhn6lu2qwgrwq@techsingularity.net
Link: https://lkml.kernel.org/r/20230515113344.6869-4-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
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

 mm/compaction.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/mm/compaction.c~mm-compaction-update-pageblock-skip-when-first-migration-candidate-is-not-at-the-start
+++ a/mm/compaction.c
@@ -392,18 +392,14 @@ void reset_isolation_suitable(pg_data_t
  * Sets the pageblock skip bit if it was clear. Note that this is a hint as
  * locks are not required for read/writers. Returns true if it was already set.
  */
-static bool test_and_set_skip(struct compact_control *cc, struct page *page,
-							unsigned long pfn)
+static bool test_and_set_skip(struct compact_control *cc, struct page *page)
 {
 	bool skip;
 
-	/* Do no update if skip hint is being ignored */
+	/* Do not update if skip hint is being ignored */
 	if (cc->ignore_skip_hint)
 		return false;
 
-	if (!pageblock_aligned(pfn))
-		return false;
-
 	skip = get_pageblock_skip(page);
 	if (!skip && !cc->no_set_skip_hint)
 		set_pageblock_skip(page);
@@ -470,8 +466,7 @@ static void update_cached_migrate(struct
 {
 }
 
-static bool test_and_set_skip(struct compact_control *cc, struct page *page,
-							unsigned long pfn)
+static bool test_and_set_skip(struct compact_control *cc, struct page *page)
 {
 	return false;
 }
@@ -1074,11 +1069,17 @@ isolate_migratepages_block(struct compac
 
 			lruvec_memcg_debug(lruvec, page_folio(page));
 
-			/* Try get exclusive access under lock */
-			if (!skip_updated) {
+			/*
+			 * Try get exclusive access under lock. If marked for
+			 * skip, the scan is aborted unless the current context
+			 * is a rescan to reach the end of the pageblock.
+			 */
+			if (!skip_updated && valid_page) {
 				skip_updated = true;
-				if (test_and_set_skip(cc, page, low_pfn))
+				if (test_and_set_skip(cc, valid_page) &&
+				    !cc->finish_pageblock) {
 					goto isolate_abort;
+				}
 			}
 
 			/*
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


