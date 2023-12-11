Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6721323A1
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H4zjWgJW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F126C433CA;
	Mon, 11 Dec 2023 00:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256040;
	bh=nXwbJJAwvrvMxEsSVv5l+ud7oWL/FG6c/fLFhP98iFo=;
	h=Date:To:From:Subject:From;
	b=H4zjWgJWZJjqKxS8lS3FuX16NWPQcNo4tmYAxqOUn+r34zba4v+d477t6NbxESXoG
	 55LLjGPUiM30r/j5fHQ2AFDCStafbch1AozPMSv7S2n/svA6xGwj277gIXTFFTuiuo
	 X/5EO1dB9OWBYquQlKwq7LYzgOXvGSF96My7iTgo=
Date: Sun, 10 Dec 2023 16:53:59 -0800
To: mm-commits@vger.kernel.org,ying.huang@intel.com,shy828301@gmail.com,apopple@nvidia.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-batch-tlb-flush-when-splitting-a-pte-mapped-thp.patch removed from -mm tree
Message-Id: <20231211005400.2F126C433CA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: huge_memory: batch tlb flush when splitting a pte-mapped THP
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-batch-tlb-flush-when-splitting-a-pte-mapped-thp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


