Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB604C7EE25
	for <mm-commits@archiver.kernel.org>; Mon, 15 May 2023 19:35:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245197AbjEOTf4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 May 2023 15:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245203AbjEOTft (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 15 May 2023 15:35:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF2EBD863
        for <mm-commits@vger.kernel.org>; Mon, 15 May 2023 12:35:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCBCA631D3
        for <mm-commits@vger.kernel.org>; Mon, 15 May 2023 19:35:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ACC6C433EF;
        Mon, 15 May 2023 19:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684179346;
        bh=3dJ9OxlX9CGAPlgsJPm3Ns6cJPE0js4sUJyT3QJ7N0o=;
        h=Date:To:From:Subject:From;
        b=vyw2ciwaVgLCH/XWVrwuRaHFRKq5QxAPzDfelHpi5ODtKc25olB3b1nk/crJYFECP
         Wu2WHFEpnBGcQ86Z61tQMytJ0Dit26MwY9aG2RVfwa+VDo0885O/c9IScQKoPu2OYe
         2gylqKQxt+aSbTgZPwZQsGwoZcNRFvWDTK1h7CB4=
Date:   Mon, 15 May 2023 12:35:45 -0700
To:     mm-commits@vger.kernel.org, zhouchuyi@bytedance.com,
        vbabka@suse.cz, pedro.falcato@gmail.com, pbonzini@redhat.com,
        mlevitsk@redhat.com, mhocko@kernel.org, jirislaby@kernel.org,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-update-pageblock-skip-when-first-migration-candidate-is-not-at-the-start.patch added to mm-unstable branch
Message-Id: <20230515193546.1ACC6C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: update pageblock skip when first migration candidate is not at the start
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-update-pageblock-skip-when-first-migration-candidate-is-not-at-the-start.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-update-pageblock-skip-when-first-migration-candidate-is-not-at-the-start.patch

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
Subject: mm: compaction: update pageblock skip when first migration candidate is not at the start
Date: Mon, 15 May 2023 12:33:43 +0100

isolate_migratepages_block should mark a pageblock as skip if scanning
started on an aligned pageblock boundary but it only updates the skip flag
if the first migration candidate is also aligned.  Tracing during a
compaction stress load (mmtests: workload-usemem-stress-numa-compact) that
many pageblocks are not marked skip causing excessive scanning of blocks
that had been recently checked.  Update pageblock skip based on
"valid_page" which is set if scanning started on a pageblock boundary.

Link: https://lkml.kernel.org/r/20230515113344.6869-4-mgorman@techsingularity.net
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

 mm/compaction.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

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
@@ -1103,9 +1098,9 @@ isolate_migratepages_block(struct compac
 			lruvec_memcg_debug(lruvec, page_folio(page));
 
 			/* Try get exclusive access under lock */
-			if (!skip_updated) {
+			if (!skip_updated && valid_page) {
 				skip_updated = true;
-				if (test_and_set_skip(cc, page, low_pfn))
+				if (test_and_set_skip(cc, valid_page))
 					goto isolate_abort;
 			}
 
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-compaction-ensure-rescanning-only-happens-on-partially-scanned-pageblocks.patch
mm-compaction-only-force-pageblock-scan-completion-when-skip-hints-are-obeyed.patch
mm-compaction-update-pageblock-skip-when-first-migration-candidate-is-not-at-the-start.patch
revert-revert-mm-compaction-fix-set-skip-in-fast_find_migrateblock.patch

