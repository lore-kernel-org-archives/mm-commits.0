Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A55EDC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:34:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355736AbiCYBgN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357428AbiCYBfZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16BAE13E3A
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:33:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC47DB81DEA
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:33:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E3C3C340EC;
        Fri, 25 Mar 2022 01:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171987;
        bh=+VJA7x46YIi0lqEq71VIbK1L+cqZmSXzGg/M/OKU/PI=;
        h=Date:To:From:Subject:From;
        b=yM6D5OJ6MRWEPa8FQACpHXcAPCfIJh3CnTV+X/m40sGjOO9mIDKm5K6gYDtZlGelZ
         BpSWIwvvE9hUSqu6nnZndzZs+CVQW9xjq2RwzBudLINMELtPHQG4MWnlfTU0oBPzRu
         yFjIiiO+ykGC4M+NSr+CCmrYdtpbTrrcFdev4hqI=
Date:   Thu, 24 Mar 2022 18:33:06 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-hmmc-remove-unneeded-local-variable-ret.patch removed from -mm tree
Message-Id: <20220325013307.4E3C3C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hmm.c: remove unneeded local variable ret
has been removed from the -mm tree.  Its filename was
     mm-hmmc-remove-unneeded-local-variable-ret.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hmm.c: remove unneeded local variable ret

The local variable ret is always 0. Remove it to make code more tight.

Link: https://lkml.kernel.org/r/20220125124833.39718-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hmm.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/hmm.c~mm-hmmc-remove-unneeded-local-variable-ret
+++ a/mm/hmm.c
@@ -417,7 +417,6 @@ static int hmm_vma_walk_pud(pud_t *pudp,
 	struct hmm_range *range = hmm_vma_walk->range;
 	unsigned long addr = start;
 	pud_t pud;
-	int ret = 0;
 	spinlock_t *ptl = pud_trans_huge_lock(pudp, walk->vma);
 
 	if (!ptl)
@@ -466,7 +465,7 @@ static int hmm_vma_walk_pud(pud_t *pudp,
 
 out_unlock:
 	spin_unlock(ptl);
-	return ret;
+	return 0;
 }
 #else
 #define hmm_vma_walk_pud	NULL
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-huge_memory-make-is_transparent_hugepage-static.patch

