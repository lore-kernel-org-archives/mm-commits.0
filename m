Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B16CDC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 22:35:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbiEMWfo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 18:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbiEMWfn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 18:35:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8FA813F28
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 15:35:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C3A661201
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 22:35:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2A0DC34100;
        Fri, 13 May 2022 22:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652481341;
        bh=zry6QV87PFKj399O2lrWV8a0vaZtAOkXAybfgxNdMJU=;
        h=Date:To:From:Subject:From;
        b=ZhaZUqatMiBtBBgjOTR60N6Gu3auQR1KBFpS8ajNGQbLh4u7ZTC1qehuO7wCqajPb
         quTTrbo2gJjrZsLX+QTZCyyMhdlKJmMQ/CZTV2kTou89ougbNTOIEBomJj5Uy3ha0k
         F2QqlttMbofMFeC8nTOyOntcgtU8I70lbxKPp5Ro=
Date:   Fri, 13 May 2022 15:35:40 -0700
To:     mm-commits@vger.kernel.org, paulmck@kernel.org,
        jhubbard@nvidia.com, david@redhat.com, minchan@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-fix-is_pinnable_page-against-on-cma-page-v5.patch removed from -mm tree
Message-Id: <20220513223540.E2A0DC34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-fix-is_pinnable_page-against-on-cma-page-v5
has been removed from the -mm tree.  Its filename was
     mm-fix-is_pinnable_page-against-on-cma-page-v5.patch

This patch was dropped because it was folded into mm-fix-is_pinnable_page-against-on-cma-page.patch

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm-fix-is_pinnable_page-against-on-cma-page-v5

  * clarification why we need READ_ONCE - Paul
  * Add a comment about READ_ONCE - John

Link: https://lkml.kernel.org/r/20220512204143.3961150-1-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/include/linux/mm.h~mm-fix-is_pinnable_page-against-on-cma-page-v5
+++ a/include/linux/mm.h
@@ -1627,13 +1627,14 @@ static inline bool is_pinnable_page(stru
 {
 #ifdef CONFIG_CMA
 	/*
-	 * use volatile to use local variable mt instead of
-	 * refetching mt value.
+	 * Defend against future compiler LTO features, or code refactoring
+	 * that inlines the above function, by forcing a single read. Because,
+	 * this routine races with set_pageblock_migratetype(), and we want to
+	 * avoid reading zero, when actually one or the other flags was set.
 	 */
-	int __mt = get_pageblock_migratetype(page);
 	int mt = __READ_ONCE(__mt);
 
-	if (mt == MIGRATE_CMA || mt == MIGRATE_ISOLATE)
+	if (mt & (MIGRATE_CMA | MIGRATE_ISOLATE))
 		return false;
 #endif
 
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-fix-is_pinnable_page-against-on-cma-page.patch
mm-fix-is_pinnable_page-against-on-cma-page-v5-fix.patch
mm-dont-be-stuck-to-rmap-lock-on-reclaim-path.patch

