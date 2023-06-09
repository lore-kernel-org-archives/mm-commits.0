Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D25E3C87FDC
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:28:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbjFIX2K (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232535AbjFIX1f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:27:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF5F3AAF
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:27:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CBBD61782
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:27:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B559EC433EF;
        Fri,  9 Jun 2023 23:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353248;
        bh=WTQ9RTwOit8Hv4DnK9e78GtHR21PQR+Ns0e7IYhAhjs=;
        h=Date:To:From:Subject:From;
        b=r3oo0AOu3bS5O4PWNzmNqcfkE0FILYBB8ZEXul8PeRZgSaQD/UkdzKT6EoKJakfjI
         AsftN1j8Fasvc7dKzr4i6A4FcMUBWMqmPFLI9WVUN/QajwQ96Sr961RObgIl/lopRR
         kXOxrK0xHJIyotUdal3Z4YuZOPgvTChLnSN3zDS8=
Date:   Fri, 09 Jun 2023 16:27:28 -0700
To:     mm-commits@vger.kernel.org, zhouchuyi@bytedance.com,
        vbabka@suse.cz, raghavendra.kt@amd.com, pedro.falcato@gmail.com,
        pbonzini@redhat.com, mlevitsk@redhat.com, mhocko@kernel.org,
        jirislaby@kernel.org, mgorman@techsingularity.net,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-ensure-rescanning-only-happens-on-partially-scanned-pageblocks.patch removed from -mm tree
Message-Id: <20230609232728.B559EC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: compaction: ensure rescanning only happens on partially scanned pageblocks
has been removed from the -mm tree.  Its filename was
     mm-compaction-ensure-rescanning-only-happens-on-partially-scanned-pageblocks.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

"Raghavendra K T" tested this and reported "decent improvement from perf
perspective as well as compaction related data [4]

[1] https://lore.kernel.org/r/20230125134434.18017-1-mgorman@techsingularity.net
[2] https://bugzilla.suse.com/show_bug.cgi?id=1206848
[3] https://lore.kernel.org/r/a55cf026-a2f9-ef01-9a4c-398693e048ea@suse.cz
[4] https://lkml.kernel.org/r/6d62686f-964d-342c-e085-0eae2555cc54@amd.com


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
Tested-by: Raghavendra K T <raghavendra.kt@amd.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
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
@@ -2465,8 +2465,9 @@ rescan:
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


