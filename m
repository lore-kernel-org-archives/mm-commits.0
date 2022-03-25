Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3449CC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:32:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357408AbiCYBeS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357545AbiCYBdQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EBC9BF00E
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:31:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B65BEB8272A
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:31:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5468AC340ED;
        Fri, 25 Mar 2022 01:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171900;
        bh=Z6vCi8ySzp1+ZpiMrYKHRXfpbGjTyYInJHauROivxYQ=;
        h=Date:To:From:Subject:From;
        b=rBtgCbGSd2xaoVHb3bI2Jz+UIRWuKfrOA4SxpMCiyFayDA0GsZbMxkspxzE4ycW7q
         xfPHDEB5nj1ZRHDsmSZoL47pnfTVAWNVzxxZdBSbANaSPW+9RHljgEpWpXJNP/9kyA
         +mMSy7oI5hFjLzy0ld2UFTLR89uIBQbB+UREylKM=
Date:   Thu, 24 Mar 2022 18:31:39 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-memory-failurec-catch-unexpected-efault-from-vma_address.patch removed from -mm tree
Message-Id: <20220325013140.5468AC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure.c: catch unexpected -EFAULT from vma_address()
has been removed from the -mm tree.  Its filename was
     mm-memory-failurec-catch-unexpected-efault-from-vma_address.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure.c: catch unexpected -EFAULT from vma_address()

It's unexpected to walk the page table when vma_address() return -EFAULT. 
But dev_pagemap_mapping_shift() is called only when vma associated to the
error page is found already in collect_procs_{file,anon}, so vma_address()
should not return -EFAULT except with some bug, as Naoya pointed out.  We
can use VM_BUG_ON_VMA() to catch this bug here.

Link: https://lkml.kernel.org/r/20220218090118.1105-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memory-failure.c~mm-memory-failurec-catch-unexpected-efault-from-vma_address
+++ a/mm/memory-failure.c
@@ -315,6 +315,7 @@ static unsigned long dev_pagemap_mapping
 	pmd_t *pmd;
 	pte_t *pte;
 
+	VM_BUG_ON_VMA(address == -EFAULT, vma);
 	pgd = pgd_offset(vma->vm_mm, address);
 	if (!pgd_present(*pgd))
 		return 0;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-huge_memory-make-is_transparent_hugepage-static.patch

