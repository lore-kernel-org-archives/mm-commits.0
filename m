Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0B0FC43219
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:34:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357458AbiCYBgI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357431AbiCYBfb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55DCF21277
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:33:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D863460B42
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:33:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35AB6C340EC;
        Fri, 25 Mar 2022 01:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171992;
        bh=CEWmjTvPMD3WC6bGsR5g8IoqexooUEVyWaSfbXmsxps=;
        h=Date:To:From:Subject:From;
        b=gDMdOHFtipLUQV0e037pR9JCi4wO/Pyxq4iYo66iDasT2U8aIzo4FE2vk2cQQFTW4
         FoOSLYzW7HQm6rj/on67MBCJYSN4Du6KtSjQm1P2ZG0SN7nSIWmNkHYrwfiBs8HsVL
         Kn8P7epTPhNNM61w71KWnGlugPW0JaF53UjIC+sQ=
Date:   Thu, 24 Mar 2022 18:33:11 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, rientjes@google.com,
        linmiaohe@huawei.com, jrdr.linux@gmail.com,
        dan.carpenter@oracle.com, baolin.wang@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-damon-remove-redundant-page-validation.patch removed from -mm tree
Message-Id: <20220325013312.35AB6C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: remove redundant page validation
has been removed from the -mm tree.  Its filename was
     mm-damon-remove-redundant-page-validation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm/damon: remove redundant page validation

It will never get a NULL page by pte_page() as discussed in thread [1],
thus remove the redundant page validation to fix below Smatch static
checker warning.

    mm/damon/vaddr.c:405 damon_hugetlb_mkold()
    warn: 'page' can't be NULL.

[1] https://lore.kernel.org/linux-mm/20220106091200.GA14564@kili/

Link: https://lkml.kernel.org/r/6d32f7d201b8970d53f51b6c5717d472aed2987c.1642386715.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Souptick Joarder <jrdr.linux@gmail.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/mm/damon/vaddr.c~mm-damon-remove-redundant-page-validation
+++ a/mm/damon/vaddr.c
@@ -402,9 +402,6 @@ static void damon_hugetlb_mkold(pte_t *p
 	pte_t entry = huge_ptep_get(pte);
 	struct page *page = pte_page(entry);
 
-	if (!page)
-		return;
-
 	get_page(page);
 
 	if (pte_young(entry)) {
@@ -564,9 +561,6 @@ static int damon_young_hugetlb_entry(pte
 		goto out;
 
 	page = pte_page(entry);
-	if (!page)
-		goto out;
-
 	get_page(page);
 
 	if (pte_young(entry) || !page_is_idle(page) ||
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


