Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38F28C678D5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Mar 2023 20:50:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbjCHUuC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Mar 2023 15:50:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbjCHUuB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Mar 2023 15:50:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19114838A9
        for <mm-commits@vger.kernel.org>; Wed,  8 Mar 2023 12:50:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D50FDB81CE2
        for <mm-commits@vger.kernel.org>; Wed,  8 Mar 2023 20:49:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DCDAC433EF;
        Wed,  8 Mar 2023 20:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678308597;
        bh=CtiiAJRPcKXBQSHMyU2LM4u8G1fLPBw7CWOlCaYbctk=;
        h=Date:To:From:Subject:From;
        b=sldKC55d5U0OpaCk2AP25NMzLkZAwsivTjzOAatsE7HpnbzrDpe0OU9mJ1G92y574
         +3JgCFe9tDEHqallqZH/BwvoLH/Rx28BxioMc7bV/K1/D16eaqlUXbfLiO9IGbIs/t
         DEB1uoywNar+klcRvjbtJ3idE8/McNYAb7HCZWXA=
Date:   Wed, 08 Mar 2023 12:49:56 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-paddr-minor-refactor-of-damon_pa_pageout.patch added to mm-unstable branch
Message-Id: <20230308204957.6DCDAC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/paddr: minor refactor of damon_pa_pageout()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-paddr-minor-refactor-of-damon_pa_pageout.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-paddr-minor-refactor-of-damon_pa_pageout.patch

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

mm-huge_memory-convert-__do_huge_pmd_anonymous_page-to-use-a-folio.patch
mm-memory-use-folio_throttle_swaprate-in-do_swap_page.patch
mm-memory-use-folio_throttle_swaprate-in-page_copy_prealloc.patch
mm-memory-use-folio_throttle_swaprate-in-wp_page_copy.patch
mm-memory-use-folio_throttle_swaprate-in-do_anonymous_page.patch
mm-memory-use-folio_throttle_swaprate-in-do_cow_fault.patch
mm-swap-remove-unneeded-cgroup_throttle_swaprate.patch
mm-damon-paddr-minor-refactor-of-damon_pa_pageout.patch
mm-damon-paddr-minor-refactor-of-damon_pa_mark_accessed_or_deactivate.patch
mm-damon-paddr-fix-missing-folio_sz-update-in-damon_pa_young.patch

