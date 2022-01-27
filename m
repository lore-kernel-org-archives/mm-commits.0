Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A21EC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jan 2022 01:56:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234724AbiA0B4N (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 26 Jan 2022 20:56:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbiA0B4N (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jan 2022 20:56:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3F7C06161C
        for <mm-commits@vger.kernel.org>; Wed, 26 Jan 2022 17:56:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B80061B3B
        for <mm-commits@vger.kernel.org>; Thu, 27 Jan 2022 01:56:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0535C340E7;
        Thu, 27 Jan 2022 01:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643248572;
        bh=LIR7rVa1THBg2gylzWGbq1KrO/z1UvmcBhfpti/9FS8=;
        h=Date:From:To:Subject:From;
        b=Mu54ek13f/ybAaXSfUP0UrQiO+O27fhRgnWdeTGV/fzhCH8s9q6vTw5zffQsKjG1f
         wygt4xqoHoAEOqTa9BtA/Gobzu6+o4eYGxggOS4zPUOgR4x/YOtsOc0TYvJspnwmLG
         /JOkuzha1SL1zVSYl2WiCrPtImry0I4hMBwo2ODI=
Date:   Wed, 26 Jan 2022 17:56:11 -0800
From:   akpm@linux-foundation.org
To:     baolin.wang@linux.alibaba.com, dan.carpenter@oracle.com,
        jrdr.linux@gmail.com, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, rientjes@google.com, sj@kernel.org
Subject:  + mm-damon-remove-redundant-page-validation.patch added
 to -mm tree
Message-ID: <20220127015611.erMHMIRqR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: remove redundant page validation
has been added to the -mm tree.  Its filename is
     mm-damon-remove-redundant-page-validation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-remove-redundant-page-validation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-remove-redundant-page-validation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-damon-remove-redundant-page-validation.patch

