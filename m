Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F218EC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:44:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236335AbiCVVpv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236308AbiCVVpq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:45:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D6C5F8C6
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:44:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A6C5B81DB7
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:44:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EF77C340F2;
        Tue, 22 Mar 2022 21:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985456;
        bh=1o+/vlScURsqqtKv20aatWbXrGRQh7hTcKq2D/GnsUo=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=myQxlKVGAU2YOqcufqolY6980r6D+v6HSqx3qIPQmqNigZw3fM34RwCUyPFxyQh+M
         y/YsJ3g0n/e5i7qGdJxAQ9GzVrb5fTG9VyRcjJd3dOxEPWLNgRvZwx07x7oLMx4dvM
         6jgkFV0kY338zGbVzORw1C8IIkWL8caL1kr5rIeo=
Date:   Tue, 22 Mar 2022 14:44:15 -0700
To:     naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 113/227] mm/memory-failure.c: catch unexpected -EFAULT from vma_address()
Message-Id: <20220322214416.2EF77C340F2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
