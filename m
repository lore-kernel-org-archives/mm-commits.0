Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFC6DC77B7D
	for <mm-commits@archiver.kernel.org>; Mon, 15 May 2023 19:35:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245193AbjEOTfp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 May 2023 15:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244201AbjEOTfo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 15 May 2023 15:35:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C76626AC
        for <mm-commits@vger.kernel.org>; Mon, 15 May 2023 12:35:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5D1D631D9
        for <mm-commits@vger.kernel.org>; Mon, 15 May 2023 19:35:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C71BC4339C;
        Mon, 15 May 2023 19:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684179342;
        bh=hMx7bhgTPwUZd5pbK2adgbanEL/AbDA9CjekmSCg9Hw=;
        h=Date:To:From:Subject:From;
        b=MqsXBtHsNBz2a9goP9aggxuJBM/IGNFg+kJeNrcHfJ2OVfHZ86Sb/D8WopUDKdfKk
         ijQ6brx7M1xRFhebRCgzVgZR3+HAdAczRj9a2dOktOtjKBLhz+H9jGyewi3QvydTw0
         R5zvxaeVeKFOZQuOH6Ob4oqNcI2FHl33yf+3/g0k=
Date:   Mon, 15 May 2023 12:35:41 -0700
To:     mm-commits@vger.kernel.org, zhouchuyi@bytedance.com,
        vbabka@suse.cz, pedro.falcato@gmail.com, pbonzini@redhat.com,
        mlevitsk@redhat.com, mhocko@kernel.org, jirislaby@kernel.org,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-ensure-rescanning-only-happens-on-partially-scanned-pageblocks.patch added to mm-unstable branch
Message-Id: <20230515193542.1C71BC4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: ensure rescanning only happens on partially scanned pageblocks
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-ensure-rescanning-only-happens-on-partially-scanned-pageblocks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-ensure-rescanning-only-happens-on-partially-scanned-pageblocks.patch

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
Subject: mm: compaction: ensure rescanning only happens on partially scanned pageblocks
Date: Mon, 15 May 2023 12:33:41 +0100

Patch series "Follow-up "Fix excessive CPU usage during compaction"".

The series "Fix excessive CPU usage during compaction" [1] attempted to
fix a bug [2] but Vlastimil noted that the fix was incomplete [3]. While
the series was merged, fast_find_migrateblock was still disabled. This
series should fix the corner cases and allow 95e7a450b819 ("Revert
"mm/compaction: fix set skip in fast_find_migrateblock"") to be safely
reverted. Details on how many pageblocks are rescanned are in the
changelog of the last patch.

[1] https://lore.kernel.org/r/20230125134434.18017-1-mgorman@techsingularity.net
[2] https://bugzilla.suse.com/show_bug.cgi?id=1206848
[3] https://lore.kernel.org/r/a55cf026-a2f9-ef01-9a4c-398693e048ea@suse.cz


This patch (of 4):
compact_zone() intends to rescan pageblocks if there is a failure to
migrate "within the current order-aligned block".  However, the pageblock
scan may already be complete and moved to the next block causing the next
pageblock to be "rescanned".  Ensure only the most recent pageblock is
rescanned.

Link: https://lkml.kernel.org/r/20230515113344.6869-1-mgorman@techsingularity.net
Link: https://lkml.kernel.org/r/20230515113344.6869-2-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reported-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Chuyi Zhou <zhouchuyi@bytedance.com>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Pedro Falcato <pedro.falcato@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/compaction.c~mm-compaction-ensure-rescanning-only-happens-on-partially-scanned-pageblocks
+++ a/mm/compaction.c
@@ -2493,8 +2493,9 @@ rescan:
 			 * fast_find_migrateblock revisiting blocks that were
 			 * recently partially scanned.
 			 */
-			if (cc->direct_compaction && !cc->finish_pageblock &&
-						(cc->mode < MIGRATE_SYNC)) {
+			if (!pageblock_aligned(cc->migrate_pfn) &&
+			    cc->direct_compaction && !cc->finish_pageblock &&
+			    (cc->mode < MIGRATE_SYNC)) {
 				cc->finish_pageblock = true;
 
 				/*
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-compaction-ensure-rescanning-only-happens-on-partially-scanned-pageblocks.patch
mm-compaction-only-force-pageblock-scan-completion-when-skip-hints-are-obeyed.patch
mm-compaction-update-pageblock-skip-when-first-migration-candidate-is-not-at-the-start.patch
revert-revert-mm-compaction-fix-set-skip-in-fast_find_migrateblock.patch

