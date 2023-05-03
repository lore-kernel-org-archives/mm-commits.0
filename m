Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4944C77B78
	for <mm-commits@archiver.kernel.org>; Wed,  3 May 2023 00:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbjECAWM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 May 2023 20:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjECAWL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 2 May 2023 20:22:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A2B1997
        for <mm-commits@vger.kernel.org>; Tue,  2 May 2023 17:22:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3101E629B3
        for <mm-commits@vger.kernel.org>; Wed,  3 May 2023 00:22:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76FCAC433D2;
        Wed,  3 May 2023 00:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683073329;
        bh=RhPRBxlTxTPB1pqHv09dvjd8YbAk22/VSEzk5iQjaM0=;
        h=Date:To:From:Subject:From;
        b=YW26tsTCyE/hplnGmF/kRy74nV+5CzZXsq/DJgIkpPpRvwmxE98sYSE3WfxIOdXwU
         GU/4QAdGSaqURgwPVjwkEg5OR4hP36o//leSvglP/vvYQXq9e+Xm5t5vOxXlJZJi/H
         8jnGqKntMUUih2O5MMmX4axyIM2t9YWaSOeY/8cc=
Date:   Tue, 02 May 2023 17:22:08 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-paddr-minor-refactor-of-damon_pa_pageout.patch removed from -mm tree
Message-Id: <20230503002209.76FCAC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/paddr: minor refactor of damon_pa_pageout()
has been removed from the -mm tree.  Its filename was
     mm-damon-paddr-minor-refactor-of-damon_pa_pageout.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm/damon/paddr: minor refactor of damon_pa_pageout()
Date: Wed, 8 Mar 2023 16:33:09 +0800

Patch series "mm/damon/paddr: minor code improvement", v3.

Unify folio_put() to make code more clear, and also fix minor issue in
damon_pa_young().


This patch (of 3):

Omit three lines by unified folio_put(), and make code more clear.

Link: https://lkml.kernel.org/r/20230308083311.120951-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20230308083311.120951-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-minor-refactor-of-damon_pa_pageout
+++ a/mm/damon/paddr.c
@@ -238,21 +238,18 @@ static unsigned long damon_pa_pageout(st
 		if (!folio)
 			continue;
 
-		if (damos_pa_filter_out(s, folio)) {
-			folio_put(folio);
-			continue;
-		}
+		if (damos_pa_filter_out(s, folio))
+			goto put_folio;
 
 		folio_clear_referenced(folio);
 		folio_test_clear_young(folio);
-		if (!folio_isolate_lru(folio)) {
-			folio_put(folio);
-			continue;
-		}
+		if (!folio_isolate_lru(folio))
+			goto put_folio;
 		if (folio_test_unevictable(folio))
 			folio_putback_lru(folio);
 		else
 			list_add(&folio->lru, &folio_list);
+put_folio:
 		folio_put(folio);
 	}
 	applied = reclaim_pages(&folio_list);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


