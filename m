Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91CE6C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 16 Mar 2022 21:11:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355030AbiCPVMo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Mar 2022 17:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350454AbiCPVMn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2022 17:12:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1BBBDEA3
        for <mm-commits@vger.kernel.org>; Wed, 16 Mar 2022 14:11:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6528EB81D67
        for <mm-commits@vger.kernel.org>; Wed, 16 Mar 2022 21:11:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09A72C340E9;
        Wed, 16 Mar 2022 21:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647465086;
        bh=s7UOZO2wV6azCO2oyYkb9W+gq29Gc5xZqH3bqrxMs6g=;
        h=Date:To:From:Subject:From;
        b=AE5xM20ylIP+deCSY+S2h6y0s2gboyoggfwVdjwsHOq8K29cJchr6lFbd5g3mn1mQ
         Qo5PLREJUk7QIh+4DMpfpVum5WNa1HCnuVTN1PM9fsMMUxjjVk+A/bSA1lt+jsWVzF
         1YLxOB7fx4CpMql3qv55/iNl4vIwbDhTY7Yxa3jg=
Date:   Wed, 16 Mar 2022 14:11:25 -0700
To:     mm-commits@vger.kernel.org, shy828301@gmail.com, sashal@kernel.org,
        linmiaohe@huawei.com, kch@nvidia.com, adobriyan@gmail.com,
        xianting.tian@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-proc-remove-redundant-page-validation-of-pte_page.patch added to -mm tree
Message-Id: <20220316211126.09A72C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/task_mmu.c: remove redundant page validation of pte_page
has been added to the -mm tree.  Its filename is
     mm-proc-remove-redundant-page-validation-of-pte_page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-proc-remove-redundant-page-validation-of-pte_page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-proc-remove-redundant-page-validation-of-pte_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xianting Tian <xianting.tian@linux.alibaba.com>
Subject: fs/proc/task_mmu.c: remove redundant page validation of pte_page

pte_page() always returns a valid page, so remove the redundant page
validation, as we did in many other places.

Link: https://lkml.kernel.org/r/20220316025947.328276-1-xianting.tian@linux.alibaba.com
Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/proc/task_mmu.c~mm-proc-remove-redundant-page-validation-of-pte_page
+++ a/fs/proc/task_mmu.c
@@ -1873,8 +1873,6 @@ static int gather_hugetlb_stats(pte_t *p
 		return 0;
 
 	page = pte_page(huge_pte);
-	if (!page)
-		return 0;
 
 	md = walk->private;
 	gather_stats(page, md, pte_dirty(huge_pte), 1);
_

Patches currently in -mm which might be from xianting.tian@linux.alibaba.com are

mm-proc-remove-redundant-page-validation-of-pte_page.patch

