Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6DF1CEEB2
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 16:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747846623; cv=none; b=KPIjDjiaQq0mbcMuZjiF6RdbOdiMpy6uB+FIJ/S+3UWDGIk2XIfsjAQxdCdkp2I8XTRKPVNVkxVD77FnBdZkeI6bpumAZN0bI+0Dp501Ey9w1BqKdv+W9UTg0Vi0GjwslWH3x/8RqUE97GjbKWoIKt2DwA5A5vfdc+jNdbIrDno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747846623; c=relaxed/simple;
	bh=0dkJlI7j/EzWOd4UCPb3iMCPjbFCUdL/yilAVehun+c=;
	h=Date:To:From:Subject:Message-Id; b=Sy8g/n38oDv9TMwzXxejYET83Dv6hELp5k7lG2poYXW4PUfFK6z6/Wd94yL4HCjY8BzLbe0jgnJ88yfoSLAzWYIAFei3lQeuBh/8or+Dg6kSnTPAvFiLmh05R9izXYwGEOXFxwAjS0mTj281i3d8UUCEAeRO+el7WnSv4IcFmmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gTrId4lR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gTrId4lR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D3ECC4CEE4;
	Wed, 21 May 2025 16:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747846622;
	bh=0dkJlI7j/EzWOd4UCPb3iMCPjbFCUdL/yilAVehun+c=;
	h=Date:To:From:Subject:From;
	b=gTrId4lR9ADNi3e+cp28j1SrRP2g0U9tVqB+kwfnlHAOROT9pks1KYf6k2N9B7IhT
	 Fw3TTH0S/NRHoUOmgfHtl9VofINSZy/JJjfDIr5tqDnzGuleJHiJqf8ooUFLU6g6Xi
	 Itff3NvWlN7bDzku7Gk5YFJkGr1jPXiPSelWzwk8=
Date: Wed, 21 May 2025 09:57:02 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,dev.jain@arm.com,david@redhat.com,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mincore-use-pte_batch_bint-to-batch-process-large-folios.patch removed from -mm tree
Message-Id: <20250521165702.9D3ECC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: mincore: use pte_batch_hint() to batch process large folios
has been removed from the -mm tree.  Its filename was
     mm-mincore-use-pte_batch_bint-to-batch-process-large-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: mincore: use pte_batch_hint() to batch process large folios
Date: Fri, 9 May 2025 08:45:21 +0800

When I tested the mincore() syscall, I observed that it takes longer with
64K mTHP enabled on my Arm64 server.  The reason is the
mincore_pte_range() still checks each PTE individually, even when the PTEs
are contiguous, which is not efficient.

Thus we can use pte_batch_hint() to get the batch number of the present
contiguous PTEs, which can improve the performance.  I tested the
mincore() syscall with 1G anonymous memory populated with 64K mTHP, and
observed an obvious performance improvement:

w/o patch		w/ patch		changes
6022us			549us			+91%

Moreover, I also tested mincore() with disabling mTHP/THP, and did not see
any obvious regression for base pages.

Link: https://lkml.kernel.org/r/99cb00ee626ceb6e788102ca36821815cd832237.1746697240.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

--- a/mm/mincore.c~mm-mincore-use-pte_batch_bint-to-batch-process-large-folios
+++ a/mm/mincore.c
@@ -21,6 +21,7 @@
 
 #include <linux/uaccess.h>
 #include "swap.h"
+#include "internal.h"
 
 static int mincore_hugetlb(pte_t *pte, unsigned long hmask, unsigned long addr,
 			unsigned long end, struct mm_walk *walk)
@@ -105,6 +106,7 @@ static int mincore_pte_range(pmd_t *pmd,
 	pte_t *ptep;
 	unsigned char *vec = walk->private;
 	int nr = (end - addr) >> PAGE_SHIFT;
+	int step, i;
 
 	ptl = pmd_trans_huge_lock(pmd, vma);
 	if (ptl) {
@@ -118,16 +120,26 @@ static int mincore_pte_range(pmd_t *pmd,
 		walk->action = ACTION_AGAIN;
 		return 0;
 	}
-	for (; addr != end; ptep++, addr += PAGE_SIZE) {
+	for (; addr != end; ptep += step, addr += step * PAGE_SIZE) {
 		pte_t pte = ptep_get(ptep);
 
+		step = 1;
 		/* We need to do cache lookup too for pte markers */
 		if (pte_none_mostly(pte))
 			__mincore_unmapped_range(addr, addr + PAGE_SIZE,
 						 vma, vec);
-		else if (pte_present(pte))
-			*vec = 1;
-		else { /* pte is a swap entry */
+		else if (pte_present(pte)) {
+			unsigned int batch = pte_batch_hint(ptep, pte);
+
+			if (batch > 1) {
+				unsigned int max_nr = (end - addr) >> PAGE_SHIFT;
+
+				step = min_t(unsigned int, batch, max_nr);
+			}
+
+			for (i = 0; i < step; i++)
+				vec[i] = 1;
+		} else { /* pte is a swap entry */
 			swp_entry_t entry = pte_to_swp_entry(pte);
 
 			if (non_swap_entry(entry)) {
@@ -146,7 +158,7 @@ static int mincore_pte_range(pmd_t *pmd,
 #endif
 			}
 		}
-		vec++;
+		vec += step;
 	}
 	pte_unmap_unlock(ptep - 1, ptl);
 out:
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


