Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CBE9C6FD19
	for <mm-commits@archiver.kernel.org>; Wed,  8 Mar 2023 20:50:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbjCHUuD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Mar 2023 15:50:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbjCHUuB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Mar 2023 15:50:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20DA084F5D
        for <mm-commits@vger.kernel.org>; Wed,  8 Mar 2023 12:50:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B00F461957
        for <mm-commits@vger.kernel.org>; Wed,  8 Mar 2023 20:49:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 140B4C4339B;
        Wed,  8 Mar 2023 20:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678308599;
        bh=NV2pQacB9VYlvuhlc42SMaZGxW2Dg2b00dCUR9pXQgA=;
        h=Date:To:From:Subject:From;
        b=rR3AWFcaphZ5Q4jkBvtylgBpb/bdZ/LMRPhFe+mGKSA/AaizSsDy5E2uQnkicaO3b
         zw+5XdNbSJORbejThPa7uvuCMcVMo0QA9r1A+GZlYhFoxOmcE8E4h/M7vuJqYLfzIn
         cEOUwWiSK3GfAiJ5Y0k5qxD4KO62YGO4mSFIBSuk=
Date:   Wed, 08 Mar 2023 12:49:58 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-paddr-minor-refactor-of-damon_pa_mark_accessed_or_deactivate.patch added to mm-unstable branch
Message-Id: <20230308204959.140B4C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/paddr: minor refactor of damon_pa_mark_accessed_or_deactivate()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-paddr-minor-refactor-of-damon_pa_mark_accessed_or_deactivate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-paddr-minor-refactor-of-damon_pa_mark_accessed_or_deactivate.patch

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
Subject: mm/damon/paddr: minor refactor of damon_pa_mark_accessed_or_deactivate()
Date: Wed, 8 Mar 2023 16:33:10 +0800

Omit one line by unified folio_put(), and make code more clear.

Link: https://lkml.kernel.org/r/20230308083311.120951-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/damon/paddr.c~mm-damon-paddr-minor-refactor-of-damon_pa_mark_accessed_or_deactivate
+++ a/mm/damon/paddr.c
@@ -268,16 +268,15 @@ static inline unsigned long damon_pa_mar
 		if (!folio)
 			continue;
 
-		if (damos_pa_filter_out(s, folio)) {
-			folio_put(folio);
-			continue;
-		}
+		if (damos_pa_filter_out(s, folio))
+			goto put_folio;
 
 		if (mark_accessed)
 			folio_mark_accessed(folio);
 		else
 			folio_deactivate(folio);
 		applied += folio_nr_pages(folio);
+put_folio:
 		folio_put(folio);
 	}
 	return applied * PAGE_SIZE;
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

