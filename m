Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5528E552
	for <mm-commits@vger.kernel.org>; Sun,  1 Dec 2024 06:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733035575; cv=none; b=ajCk+OU/P2W88hRL0VnVi5XXJXzjMFojQzxuLWu0S/XLn2bm/daZCj+UkHaq7PlLcNprsb5Hqv7vV2SR8IBYTJkAuhB7u2A8j2HqMSfz2jYxL5gsTqk+SjuQO4oqVhGaoneAZNkPfJEdhpuR/KvrgosaidhsW+Zm1msp+DgltME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733035575; c=relaxed/simple;
	bh=gcDwi2VSDGWXGSgLt3Z2nnFnBD1yXXVMIGpSD+NXlEI=;
	h=Date:To:From:Subject:Message-Id; b=nCV4/LyonyiyfuB1UMCx3M2u9kG8u3vOKZgmFDVILamhHaXuwxzBJ18/OF9yFV/tTVi4JLz1VUMGon9tPTZkhUxCFisipuQaelbzsYijO99qXaQDPEQk5y3iXiZX5hliZwZ7I4SIjzrsp/8wJPC1x5nEzTVoca8yT057TcretYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bvER6K5w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bvER6K5w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43401C4CECF;
	Sun,  1 Dec 2024 06:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733035575;
	bh=gcDwi2VSDGWXGSgLt3Z2nnFnBD1yXXVMIGpSD+NXlEI=;
	h=Date:To:From:Subject:From;
	b=bvER6K5wVa78I+Sbf4UDO6lR2C2TQXCaRgx5JjRzSRV8EWC6SfLmhcGAOMQPrHbKY
	 HB07v2sfXyn9uRBZoNpn+PZ80PGiuVr4zBxtwE23v9rmCtNUvqU1TBEfC41sSJjaOL
	 boB1hiirBzCdhJC87ZjVOSRls2507DHziEtFESpA=
Date: Sat, 30 Nov 2024 22:46:14 -0800
To: mm-commits@vger.kernel.org,mgorman@techsingularity.net,labbott@redhat.com,liuq131@chinatelecom.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-compaction-fix-the-total_isolated-in-strict-mode.patch removed from -mm tree
Message-Id: <20241201064615.43401C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/compaction: fix the total_isolated in strict mode
has been removed from the -mm tree.  Its filename was
     mm-compaction-fix-the-total_isolated-in-strict-mode.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Qiang Liu <liuq131@chinatelecom.cn>
Subject: mm/compaction: fix the total_isolated in strict mode
Date: Sat, 2 Nov 2024 20:16:21 +0000

If the last cycle reads bogus compound_order() and blockpfn > end_pfn
occurs, it is possible that total_isolated will be less than nr_scanned. 
In this case, strict mode should return 0, but the "if (strict &&
blockpfn < end_pfn)" statement cannot recognize this situation.

We assume that the block we are currently processing is distributed as
follows:
0   1   2                                                            511
--------------------------------------------------
|   |   |                                                             |
--------------------------------------------------
Index 0 and 1 are both pages with an order of 0.
Index 2 has a bogus order (let's assume the order is 9).
When the for loop reaches index 2, it will enter the following code:

/*
 * For compound pages such as THP and hugetlbfs, we can save
 * potentially a lot of iterations if we skip them at once.
 * The check is racy, but we can consider only valid values
 * and the only danger is skipping too much.
 */
if (PageCompound(page)) {
    const unsigned int order = compound_order(page);
    if (blockpfn + (1UL << order) <= end_pfn) {
        blockpfn += (1UL << order) - 1;
        page += (1UL << order) - 1;
        nr_scanned += (1UL << order) - 1;
    }
    goto isolate_fail;

}

After exiting the for loop:
blockpfn =basepfn+ 2+2^9 = basepfn+514;
endpfn  = basepfn +512;
total_isolated = 2;
nr_scanned = 514;

/*
 * Be careful to not go outside of the pageblock.
 */
if (unlikely(blockpfn > end_pfn))
        blockpfn = end_pfn;
So this can happen

/*
 * If strict isolation is requested by CMA then check that all the
 * pages requested were isolated. If there were any failures, 0 is
 * returned and CMA will fail.
 */
if (strict && blockpfn < end_pfn)
        total_isolated = 0;

If processed according to the old code, it will not enter the if statement
to reset total_isolated, but the correct handling is to reset
total_isolated to 0.

Link: https://lkml.kernel.org/r/20241102201621.95291-1-liuq131@chinatelecom.cn
Signed-off-by: Qiang Liu <liuq131@chinatelecom.cn>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/compaction.c~mm-compaction-fix-the-total_isolated-in-strict-mode
+++ a/mm/compaction.c
@@ -700,7 +700,7 @@ isolate_fail:
 	 * pages requested were isolated. If there were any failures, 0 is
 	 * returned and CMA will fail.
 	 */
-	if (strict && blockpfn < end_pfn)
+	if (strict && (blockpfn < end_pfn || total_isolated != nr_scanned))
 		total_isolated = 0;
 
 	cc->total_free_scanned += nr_scanned;
_

Patches currently in -mm which might be from liuq131@chinatelecom.cn are


