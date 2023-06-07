Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6784CC7EE2F
	for <mm-commits@archiver.kernel.org>; Wed,  7 Jun 2023 01:00:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240396AbjFGA77 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jun 2023 20:59:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234076AbjFGA7q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jun 2023 20:59:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C222F1726
        for <mm-commits@vger.kernel.org>; Tue,  6 Jun 2023 17:59:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5904163957
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 00:59:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97B0CC433D2;
        Wed,  7 Jun 2023 00:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686099584;
        bh=sxxXk5Jm67z2KmqKrddqd+wLL1oFxhQvduoRRTn8ZL8=;
        h=Date:To:From:Subject:From;
        b=iqZz1u4R56DbZjToJA4zVDYnfedipXIMe2QyaWmpvGtnPTs4Xy+7bT2L8MeG9XIvJ
         /gUdKkPtteH6p91jBNj99Yes4Ejs+pE2nCOR1g0VFr7MX+3ItWO1F978FK7XJ30+Oz
         5voDIBvddg1mefbmCn/04QB+by/5a0iHRBc219hU=
Date:   Tue, 06 Jun 2023 17:59:43 -0700
To:     mm-commits@vger.kernel.org, zhouchuyi@bytedance.com,
        vbabka@suse.cz, raghavendra.kt@amd.com, pedro.falcato@gmail.com,
        pbonzini@redhat.com, mlevitsk@redhat.com, mhocko@kernel.org,
        jirislaby@kernel.org, mgorman@techsingularity.net,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-update-pageblock-skip-when-first-migration-candidate-is-not-at-the-start-fix.patch added to mm-unstable branch
Message-Id: <20230607005944.97B0CC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-update-pageblock-skip-when-first-migration-candidate-is-not-at-the-start-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-update-pageblock-skip-when-first-migration-candidate-is-not-at-the-start-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-update-pageblock-skip-when-first-migration-candidate-is-not-at-the-start-fix.patch

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
Subject: mm-compaction-update-pageblock-skip-when-first-migration-candidate-is-not-at-the-start-fix
Date: Fri, 2 Jun 2023 12:16:22 +0100

Vlastimil Babka pointed out the following problem with
mm-compaction-update-pageblock-skip-when-first-migration-candidate-is-not-at-the-start.patch

	I wonder if this has an unintended side-effect that if we resume
	isolate_migratepages_block() of a partially compacted pageblock
	to finish it, test_and_set_skip() will now tell us to abort,
	because we already set the skip bit in the previous call. This
	would include the cc->finish_pageblock rescan cases.

He is correct and a partial rescan as implemented in "mm, compaction:
finish pageblocks on complete migration failure" would abort prematurely.

Test and set the skip bit when acquiring "exclusive access" to a pageblock
for migration but only abort if the calling context is not rescanning to
finish a pageblock.

This is a fix for the mmotm patch
mm-compaction-update-pageblock-skip-when-first-migration-candidate-is-not-at-the-start.patch

Link: https://lkml.kernel.org/r/20230602111622.swtxhn6lu2qwgrwq@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Chuyi Zhou <zhouchuyi@bytedance.com>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Pedro Falcato <pedro.falcato@gmail.com>
Cc: Raghavendra K T <raghavendra.kt@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/compaction.c~mm-compaction-update-pageblock-skip-when-first-migration-candidate-is-not-at-the-start-fix
+++ a/mm/compaction.c
@@ -1069,11 +1069,17 @@ isolate_migratepages_block(struct compac
 
 			lruvec_memcg_debug(lruvec, page_folio(page));
 
-			/* Try get exclusive access under lock */
+			/*
+			 * Try get exclusive access under lock. If marked for
+			 * skip, the scan is aborted unless the current context
+			 * is a rescan to reach the end of the pageblock.
+			 */
 			if (!skip_updated && valid_page) {
 				skip_updated = true;
-				if (test_and_set_skip(cc, valid_page))
+				if (test_and_set_skip(cc, valid_page) &&
+				    !cc->finish_pageblock) {
 					goto isolate_abort;
+				}
 			}
 
 			/*
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-compaction-ensure-rescanning-only-happens-on-partially-scanned-pageblocks.patch
mm-compaction-only-force-pageblock-scan-completion-when-skip-hints-are-obeyed.patch
mm-compaction-update-pageblock-skip-when-first-migration-candidate-is-not-at-the-start.patch
mm-compaction-update-pageblock-skip-when-first-migration-candidate-is-not-at-the-start-fix.patch
revert-revert-mm-compaction-fix-set-skip-in-fast_find_migrateblock.patch

