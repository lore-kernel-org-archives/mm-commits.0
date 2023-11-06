Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F776C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  6 Nov 2023 18:15:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbjKFSP3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Nov 2023 13:15:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232152AbjKFSP3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Nov 2023 13:15:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E0F4D47
        for <mm-commits@vger.kernel.org>; Mon,  6 Nov 2023 10:15:26 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8C6BC433C8;
        Mon,  6 Nov 2023 18:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699294525;
        bh=kO+j5hFZ/rXWJYcKEf5E1KG9hVKyQX8IhnGN7gtct/I=;
        h=Date:To:From:Subject:From;
        b=pSig6aQdatZn2QJxbXYA8ztcgzpcn5w2gAO7Gsg795ud9UzZdTUVeuUvX5G10Njt8
         WasJdvE6zOk+olUu0zWM37sjbYlC+sjXa/PauaGbC0pBAANOsx/gMLGMY17MsjUAs0
         9seHxclTvcsZxIM4+ft2N/w8312ZuZofneOzYiyI=
Date:   Mon, 06 Nov 2023 10:15:25 -0800
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        shy828301@gmail.com, apopple@nvidia.com,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-batch-tlb-flush-when-splitting-a-pte-mapped-thp.patch added to mm-unstable branch
Message-Id: <20231106181525.A8C6BC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: huge_memory: batch tlb flush when splitting a pte-mapped THP
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-batch-tlb-flush-when-splitting-a-pte-mapped-thp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-batch-tlb-flush-when-splitting-a-pte-mapped-thp.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: huge_memory: batch tlb flush when splitting a pte-mapped THP
Date: Mon, 30 Oct 2023 09:11:47 +0800

I can observe an obvious tlb flush hotspot when splitting a pte-mapped THP
on my ARM64 server, and the distribution of this hotspot is as follows:

   - 16.85% split_huge_page_to_list
      + 7.80% down_write
      - 7.49% try_to_migrate
         - 7.48% rmap_walk_anon
              7.23% ptep_clear_flush
      + 1.52% __split_huge_page

The reason is that the split_huge_page_to_list() will build migration
entries for each subpage of a pte-mapped Anon THP by try_to_migrate(), or
unmap for file THP, and it will clear and tlb flush for each subpage's
pte.  Moreover, the split_huge_page_to_list() will set TTU_SPLIT_HUGE_PMD
flag to ensure the THP is already a pte-mapped THP before splitting it to
some normal pages.

Actually, there is no need to flush tlb for each subpage immediately,
instead we can batch tlb flush for the pte-mapped THP to improve the
performance.

After this patch, we can see the batch tlb flush can improve the latency
obviously when running thpscale.

                             k6.5-base                   patched
Amean     fault-both-1      1071.17 (   0.00%)      901.83 *  15.81%*
Amean     fault-both-3      2386.08 (   0.00%)     1865.32 *  21.82%*
Amean     fault-both-5      2851.10 (   0.00%)     2273.84 *  20.25%*
Amean     fault-both-7      3679.91 (   0.00%)     2881.66 *  21.69%*
Amean     fault-both-12     5916.66 (   0.00%)     4369.55 *  26.15%*
Amean     fault-both-18     7981.36 (   0.00%)     6303.57 *  21.02%*
Amean     fault-both-24    10950.79 (   0.00%)     8752.56 *  20.07%*
Amean     fault-both-30    14077.35 (   0.00%)    10170.01 *  27.76%*
Amean     fault-both-32    13061.57 (   0.00%)    11630.08 *  10.96%*

Link: https://lkml.kernel.org/r/431d9fb6823036369dcb1d3b2f63732f01df21a7.1698488264.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-huge_memory-batch-tlb-flush-when-splitting-a-pte-mapped-thp
+++ a/mm/huge_memory.c
@@ -2379,7 +2379,7 @@ void vma_adjust_trans_huge(struct vm_are
 static void unmap_folio(struct folio *folio)
 {
 	enum ttu_flags ttu_flags = TTU_RMAP_LOCKED | TTU_SPLIT_HUGE_PMD |
-		TTU_SYNC;
+		TTU_SYNC | TTU_BATCH_FLUSH;
 
 	VM_BUG_ON_FOLIO(!folio_test_large(folio), folio);
 
@@ -2392,6 +2392,8 @@ static void unmap_folio(struct folio *fo
 		try_to_migrate(folio, ttu_flags);
 	else
 		try_to_unmap(folio, ttu_flags | TTU_IGNORE_MLOCK);
+
+	try_to_unmap_flush();
 }
 
 static void remap_page(struct folio *folio, unsigned long nr)
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-huge_memory-batch-tlb-flush-when-splitting-a-pte-mapped-thp.patch

