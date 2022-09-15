Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 133BFC32771
	for <mm-commits@archiver.kernel.org>; Thu, 15 Sep 2022 21:25:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiIOVZb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Sep 2022 17:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiIOVZ3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Sep 2022 17:25:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D02D24A124
        for <mm-commits@vger.kernel.org>; Thu, 15 Sep 2022 14:25:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 688A1B8226D
        for <mm-commits@vger.kernel.org>; Thu, 15 Sep 2022 21:25:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CADAC433D6;
        Thu, 15 Sep 2022 21:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663277126;
        bh=U0Wlt7CBn2MdJ7iQjpQNTq8tYKHmgqGsvoUIsaoU4JM=;
        h=Date:To:From:Subject:From;
        b=grmyUl1XgAj3eFccMZTY/UMiebGMzW1HPgEGynO/ApNUn2LMY+fma+V+asYa1hiaS
         ExkXentPXqo0dYZdeSeT7c+2mSf4GFmsIbuS80Xr49vqKOjQeLZoIdCnvoFRXqc31k
         lNQedni19Sw1TlFaqlC6uqsE1+DgTiqWlRc1kvyc=
Date:   Thu, 15 Sep 2022 14:25:25 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, xhao@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-remove-duplicate-check-about-thp.patch added to mm-unstable branch
Message-Id: <20220915212526.0CADAC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: remove duplicate check about THP
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-remove-duplicate-check-about-thp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-remove-duplicate-check-about-thp.patch

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
From: Xin Hao <xhao@linux.alibaba.com>
Subject: mm/damon/core: remove duplicate check about THP
Date: Thu, 15 Sep 2022 22:22:37 +0800

In damon_young_pmd_entry(), it calls pmd_trans_huge() to check whether the
OS supports THP, if CONFIG_TRANSPARENT_HUGEPAGE is not included, the
pmd_trans_huge() will return 0.

Link: https://lkml.kernel.org/r/20220915142237.92529-2-xhao@linux.alibaba.com
Signed-off-by: Xin Hao <xhao@linux.alibaba.com>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/damon/vaddr.c~mm-damon-core-remove-duplicate-check-about-thp
+++ a/mm/damon/vaddr.c
@@ -434,7 +434,6 @@ static int damon_young_pmd_entry(pmd_t *
 	struct page *page;
 	struct damon_young_walk_private *priv = walk->private;
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	if (pmd_trans_huge(*pmd)) {
 		ptl = pmd_lock(walk->mm, pmd);
 		if (!pmd_present(*pmd)) {
@@ -462,7 +461,6 @@ huge_out:
 	}
 
 regular_page:
-#endif	/* CONFIG_TRANSPARENT_HUGEPAGE */
 
 	if (pmd_none(*pmd) || unlikely(pmd_bad(*pmd)))
 		return -EINVAL;
_

Patches currently in -mm which might be from xhao@linux.alibaba.com are

mm-damon-simply-damon_ctx-check-in-damon_sysfs_before_terminate.patch
mm-damon-remove-duplicate-get_monitoring_region-definitions.patch
mm-damon-sysfs-change-few-functions-execute-order.patch
mm-damon-simplify-scheme-create-in-damon_lru_sort_apply_parameters.patch
mm-damon-sysfs-avoid-call-damon_target_has_pid-repeatedly.patch
mm-damon-core-remove-duplicate-check-about-thp.patch

