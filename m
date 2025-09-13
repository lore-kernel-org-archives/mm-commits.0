Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D955254855
	for <mm-commits@vger.kernel.org>; Sat, 13 Sep 2025 22:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757801944; cv=none; b=DmSojPD5ivHH7rS1scaJ1Z0Pic/TtIIYjXCX0sWgJHUZn+TGoTm/sLBzB84hOuSIesb7wxDo+4uVLp8DtX2agBJJ7x1u7MhXqtMtHFE7A9bVOmR67cXMZejz5HggqgwZOyt9R90NgSVtsYFSj311hs5xgOs+tNE/DkZ4HUH4i0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757801944; c=relaxed/simple;
	bh=vrG7HWDcm4GjKO3p45D9d/kETqsr4NsvA6XmecAhIYk=;
	h=Date:To:From:Subject:Message-Id; b=PMBQ5ot4r1QBoT8xuWGQ3fJX44q7n4vwQiHYmljgPVkw/MiJM6E+bXTPFuX2UOlmSk/KPNuY4Vk7fk4UFWrdGkxN3+NtKNVB2SG5xCkdL4G649XJr014kJS+an+/QCJ9WCm8ZDMr+xet89BL9sr2lK+tSa8tlVPmilKGs4x/rqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t2o29j8+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t2o29j8+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF66C4CEEB;
	Sat, 13 Sep 2025 22:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757801944;
	bh=vrG7HWDcm4GjKO3p45D9d/kETqsr4NsvA6XmecAhIYk=;
	h=Date:To:From:Subject:From;
	b=t2o29j8+1AsSO9nnF+252d7Os/37GnGUJJ0Tqj+ATbmf9qCnsmhLAuNy63hAVzqyc
	 fnvNTwHE6fsSstLqzxDVhlTZ08kGkBuSE6BNuvZVWk3WXz12WKS5E300dFfPCOMKxE
	 qyby1nTWypXM+Fvfi3F6AdfyL1SdWCMbDrYa/MOE=
Date: Sat, 13 Sep 2025 15:19:03 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-page_alloc-simplify-lowmem_reserve-max-calculation-v3.patch removed from -mm tree
Message-Id: <20250913221903.EFF66C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-page_alloc-simplify-lowmem_reserve-max-calculation-v3
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-simplify-lowmem_reserve-max-calculation-v3.patch

This patch was dropped because it was folded into mm-page_alloc-simplify-lowmem_reserve-max-calculation.patch

------------------------------------------------------
From: Ye Liu <liuye@kylinos.cn>
Subject: mm-page_alloc-simplify-lowmem_reserve-max-calculation-v3
Date: Fri, 15 Aug 2025 10:45:09 +0800

fix layout, use min_t

Link: https://lkml.kernel.org/r/20250815024509.37900-1-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-simplify-lowmem_reserve-max-calculation-v3
+++ a/mm/page_alloc.c
@@ -6236,15 +6236,13 @@ static void calculate_totalreserve_pages
 			unsigned long managed_pages = zone_managed_pages(zone);
 
 			/* Find valid and maximum lowmem_reserve in the zone */
-			for (j = i; j < MAX_NR_ZONES; j++) {
+			for (j = i; j < MAX_NR_ZONES; j++)
 				max = max(max, zone->lowmem_reserve[j]);
-			}
 
 			/* we treat the high watermark as reserved pages. */
 			max += high_wmark_pages(zone);
 
-			if (max > managed_pages)
-				max = managed_pages;
+			max = min_t(unsigned long, max, managed_pages);
 
 			pgdat->totalreserve_pages += max;
 
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion.patch
mm-page_alloc-simplify-lowmem_reserve-max-calculation.patch
mm-fix-typos-in-vma-comments.patch
mm-page_alloc-remove-redundant-pcp-free_count-initialization-in-per_cpu_pages_init.patch

