Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68C84C678D5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Mar 2023 20:56:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbjCHUzq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Mar 2023 15:55:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjCHUzp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Mar 2023 15:55:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA7DC78D5
        for <mm-commits@vger.kernel.org>; Wed,  8 Mar 2023 12:55:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50F71B81DFC
        for <mm-commits@vger.kernel.org>; Wed,  8 Mar 2023 20:55:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFB57C4339B;
        Wed,  8 Mar 2023 20:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678308940;
        bh=TNQPsVETH9WbJt5w+0tRYKgbFDFD0HmdBuwA1ghGCJI=;
        h=Date:To:From:Subject:From;
        b=amp/YfbgIyHNPoEeKXIiqZA1y4476L+RcDqXR3Fit3/2QkDPDjUDyL1B8oYu6Tye4
         OLU0B9VhNZQWXQbdg2i1eGwBQ6BG5UjhYTxfg61A/ga7o26JtocYeWmb7/bAEFhkeT
         Nx7DVE0gGpAIwEPxc4cMp/0bNftNFHy8ail3lwUw=
Date:   Wed, 08 Mar 2023 12:55:40 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-paddr-fix-missing-folio_sz-update-in-damon_pa_young.patch added to mm-unstable branch
Message-Id: <20230308205540.BFB57C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/paddr: fix missing folio_sz update in damon_pa_young()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-paddr-fix-missing-folio_sz-update-in-damon_pa_young.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-paddr-fix-missing-folio_sz-update-in-damon_pa_young.patch

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
Subject: mm/damon/paddr: fix missing folio_sz update in damon_pa_young()
Date: Wed, 8 Mar 2023 16:33:11 +0800

The *folio_sz in damon_pa_young() will be used(as last_folio_sz) by
__damon_pa_check_access(), so it's need to be updated, fix missing branch.

Link: https://lkml.kernel.org/r/20230308083311.120951-4-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/damon/paddr.c~mm-damon-paddr-fix-missing-folio_sz-update-in-damon_pa_young
+++ a/mm/damon/paddr.c
@@ -134,10 +134,8 @@ static bool damon_pa_young(unsigned long
 	}
 
 	need_lock = !folio_test_anon(folio) || folio_test_ksm(folio);
-	if (need_lock && !folio_trylock(folio)) {
-		folio_put(folio);
-		return false;
-	}
+	if (need_lock && !folio_trylock(folio))
+		goto out;
 
 	rmap_walk(folio, &rwc);
 
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

