Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DDBDC32771
	for <mm-commits@archiver.kernel.org>; Thu, 15 Sep 2022 22:25:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbiIOWZK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Sep 2022 18:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiIOWZI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Sep 2022 18:25:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF9913F9A
        for <mm-commits@vger.kernel.org>; Thu, 15 Sep 2022 15:25:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1942A62703
        for <mm-commits@vger.kernel.org>; Thu, 15 Sep 2022 22:25:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E7DCC433D6;
        Thu, 15 Sep 2022 22:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663280705;
        bh=3DlmKdJaY49Ix+WYFVXb4Mkh2k9KlkNOZykl7zjrgRY=;
        h=Date:To:From:Subject:From;
        b=Vl8RTQNy2nkx8mDNLRFMCF1kA2cx/ORoAThnLaG2SSVAJSOHmWvL13SkhJHZeM2Ug
         sGREkCzdEXrGVJABsi3hkC/7cxEaMCz0IyICa3dgKfuFFl9/gwI43EKIZPI6YApQug
         j1Vcc5ymsRGe0mvC05vcoBlmK1BkJKTgqes1cb3o=
Date:   Thu, 15 Sep 2022 15:25:04 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, xhao@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] mm-damon-core-remove-duplicate-check-about-thp.patch removed from -mm tree
Message-Id: <20220915222505.5E7DCC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/core: remove duplicate check about THP
has been removed from the -mm tree.  Its filename was
     mm-damon-core-remove-duplicate-check-about-thp.patch

This patch was dropped because it had testing failures

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
mm-damon-simplify-scheme-create-in-lru_sortc.patch

