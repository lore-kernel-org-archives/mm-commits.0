Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF5B8C2BB40
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:14:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EEC8224F4
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:14:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728114AbgLODN7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:13:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:36830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728090AbgLODNL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:13:11 -0500
Date:   Mon, 14 Dec 2020 19:12:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001963;
        bh=Z8zi46IhhG3F6PFez7Iq7xeKZyxd6JAs2P1/ISzigvU=;
        h=From:To:Subject:In-Reply-To:From;
        b=0YyP1mnglUWVRJTalwj0+vXiqz6ASCvlS7jquKy9zQswYjBSiLsTjS9U+vK6TtTvM
         pF3nq5W9981a8IlNGew1GlTzuryAkFOAVOmqme1uhhDdSRxddOXrcZE1Ep2UClfp6B
         RJFkbNV+VfukO9glZT8e2t14Fpi+dpKB4tdb5+CI=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sh_def@163.com,
        torvalds@linux-foundation.org
Subject:  [patch 160/200] mm/compaction: move compaction_suitable's
 comment to right place
Message-ID: <20201215031242.1XgiZ_qo1%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Hui Su <sh_def@163.com>
Subject: mm/compaction: move compaction_suitable's comment to right place

Since commit 837d026d560c ("mm/compaction: more trace to understand
when/why compaction start/finish"), the comment place is not suitable.

So move compaction_suitable's comment to right place.

Link: https://lkml.kernel.org/r/20201116144121.GA385717@rlk
Signed-off-by: Hui Su <sh_def@163.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/compaction.c~mm-compaction-move-compaction_suitables-comment-to-right-place
+++ a/mm/compaction.c
@@ -2070,13 +2070,6 @@ static enum compact_result compact_finis
 	return ret;
 }
 
-/*
- * compaction_suitable: Is this suitable to run compaction on this zone now?
- * Returns
- *   COMPACT_SKIPPED  - If there are too few free pages for compaction
- *   COMPACT_SUCCESS  - If the allocation would succeed without compaction
- *   COMPACT_CONTINUE - If compaction should run now
- */
 static enum compact_result __compaction_suitable(struct zone *zone, int order,
 					unsigned int alloc_flags,
 					int highest_zoneidx,
@@ -2120,6 +2113,13 @@ static enum compact_result __compaction_
 	return COMPACT_CONTINUE;
 }
 
+/*
+ * compaction_suitable: Is this suitable to run compaction on this zone now?
+ * Returns
+ *   COMPACT_SKIPPED  - If there are too few free pages for compaction
+ *   COMPACT_SUCCESS  - If the allocation would succeed without compaction
+ *   COMPACT_CONTINUE - If compaction should run now
+ */
 enum compact_result compaction_suitable(struct zone *zone, int order,
 					unsigned int alloc_flags,
 					int highest_zoneidx)
_
