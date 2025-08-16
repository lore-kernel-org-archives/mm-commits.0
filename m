Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2F92264B2
	for <mm-commits@vger.kernel.org>; Sat, 16 Aug 2025 07:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755329278; cv=none; b=VZ/fnsM1NKCY6Zyuno2/cen/I3rbDoHwxrdVkMgNb9TKGpSZFbJHhbt3K+KsQH3dfQA/xbfJDmFMI5xMPLaYl0NWjWtWjLWkTFghAduT0PmQz+fWVcN6v02mI7Wg3Apxmy96oreiUhePQxc3agjErnjt8D/PmcQybrxIHXSr7kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755329278; c=relaxed/simple;
	bh=CZXFlc9/k7/JumHn7Il5ku8K+gCmdf+DaLPeyyHW/q4=;
	h=Date:To:From:Subject:Message-Id; b=gvcPLWe2CVUN8g4BVk7VMUJbkBv6zzOpIG0ypHNkrqNoAYkjZahSWIjYATe92fBIt028DxakIs6CSFiKlF6Z4BdwWDyIBmP6lDH2K102vS5Aj5dDigtBlQ1N3Dd+j1fs+dZcQZmT7GUNkIdMXLiopj+tFVj1kbixU06mKI5/RhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NpuW4ibe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NpuW4ibe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A7E7C4CEEF;
	Sat, 16 Aug 2025 07:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755329278;
	bh=CZXFlc9/k7/JumHn7Il5ku8K+gCmdf+DaLPeyyHW/q4=;
	h=Date:To:From:Subject:From;
	b=NpuW4ibeBbNWI/UTilpBXrgHIAOp9Ve0/UjhZvzw37I1ieU2UfVzY2/YyLT7ffkXr
	 UjKFWjpdm3ziYr7YlTvLd++q/fHTvzbIafMWSK5ONgaz7gE1HweT84mvRlvhctGbX9
	 qNwwDxtMTnAxnyd42d4Mj3WnHErSvaLTEnfKXAN4=
Date: Sat, 16 Aug 2025 00:27:57 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-simplify-lowmem_reserve-max-calculation-v3.patch added to mm-new branch
Message-Id: <20250816072758.4A7E7C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-page_alloc-simplify-lowmem_reserve-max-calculation-v3
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-simplify-lowmem_reserve-max-calculation-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-simplify-lowmem_reserve-max-calculation-v3.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
mm-page_alloc-simplify-lowmem_reserve-max-calculation-v3.patch
mm-fix-typos-in-vma-comments.patch
mm-page_alloc-remove-redundant-pcp-free_count-initialization-in-per_cpu_pages_init.patch

