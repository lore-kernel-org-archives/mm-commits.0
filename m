Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B03CDC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:11:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236087AbiEJEPs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236083AbiEJEPd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:15:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07562457A4
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:11:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32AF06172E
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:11:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B516C385A6;
        Tue, 10 May 2022 04:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155871;
        bh=12BrnPF5Pvw+9Mt1v0KoY8YKetleQuk5J32vD5vXyOg=;
        h=Date:To:From:Subject:From;
        b=JaSI7T790BvUDw+Kq97LR4RnIVjoMaiH1EKI+ifZWWDbt0I5jHYixanyEFKINd01s
         sitB7DwBJ6BmHX7ACdvijmW7aJyJ9SSBv1Erywx71xZNozZN3ewC6jXomeDwmAosd8
         b8kh/mgH8kwOA6pA/o5fCvEyCW870VrdPth9dusE=
Date:   Mon, 09 May 2022 21:11:10 -0700
To:     mm-commits@vger.kernel.org, shy828301@gmail.com, sashal@kernel.org,
        linmiaohe@huawei.com, kch@nvidia.com, adobriyan@gmail.com,
        xianting.tian@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-proc-remove-redundant-page-validation-of-pte_page.patch removed from -mm tree
Message-Id: <20220510041111.8B516C385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs/proc/task_mmu.c: remove redundant page validation of pte_page
has been removed from the -mm tree.  Its filename was
     mm-proc-remove-redundant-page-validation-of-pte_page.patch

This patch was dropped because it was merged into mm-stable

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


