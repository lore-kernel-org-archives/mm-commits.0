Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645DF25B0A6
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067093; cv=none; b=g+bpfK8WXNAp02T+KyL6spJMgRkWWs0MYsvVKH2ATTVds9cQ1xCRi+NNLNFDO52kL0nvO9N81/I5YzO9wrH3jZ3R0pnLNwbBBR2Aa9YlQ+4bkcR4yffOBvqUFoR1fsYeHMTdfRRJ9Uw2iPSlxYyI2IpGKaPlmwDMSA2wgiwuuxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067093; c=relaxed/simple;
	bh=JtirUKKUVrwbV8J3JT+BkKaNVekuq+O+CwlIAlL9fw4=;
	h=Date:To:From:Subject:Message-Id; b=TeM7DSe40FfkHYNS32Ofj8rFp7oxfLcAzxAF9t07RmblmRLKMP4D2s8iKqmgq8VOsnV/Q9m6evtqEDkxgjt9/sXHrHa5RZTI09dTcfT72NlslcHlNxSLJxWfv+FOEvj+P1xoZfNYOw3rGSWdgAFYdKDNEJFhBBJ0n1e8vrE7qLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ka5zis6k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ka5zis6k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 280341F000E9;
	Sun, 21 Jun 2026 18:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067092;
	bh=+UgkcG6/TfZIK91+0aMv+5t6H0AIsA92gleC6X2ANNw=;
	h=Date:To:From:Subject;
	b=ka5zis6kpEPwv8pCke5JtWWBLX9u2ixmM86ZvcXVDZIOlSZ8YH8/D4IlAwHjEo+ak
	 XhP8pSzWyl8Zy8ipzqZYY8TgedkQILO9KhMcL4gNQhPxtSgOHlu8S6J0Kpgr8sLSqX
	 HV0SwW0EkjfCoP15VSlxoRtlTFc+ZiXnkBmWJM9Q=
Date: Sun, 21 Jun 2026 11:38:11 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,ljs@kernel.org,liam@infradead.org,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-fix-pmd-collapse-swap-pte-accounting.patch removed from -mm tree
Message-Id: <20260621183812.280341F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: fix PMD collapse swap PTE accounting
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-fix-pmd-collapse-swap-pte-accounting.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lance Yang <lance.yang@linux.dev>
Subject: mm/khugepaged: fix PMD collapse swap PTE accounting
Date: Tue, 9 Jun 2026 20:04:43 +0800

mthp_collapse() uses mthp_present_ptes to decide whether a range has
enough occupied PTEs to try collapse.  Swap PTEs accepted by
collapse_scan_pmd() are counted in unmapped, but are not represented in
mthp_present_ptes.

When lower orders are enabled, collapse_scan_pmd() relaxes max_ptes_none
so the scan can cover the whole PMD and build the bitmap.  mthp_collapse()
then checks the PMD-order candidate using the bitmap.

With max_ptes_none set to 0, a range with 511 present PTEs and one swap
PTE no longer reaches collapse_huge_page(), even though PMD collapse can
handle swap PTEs up to max_ptes_swap.

Account unmapped PTEs only for PMD order.  PMD collapse supports swap PTEs
through max_ptes_swap, while lower-order mTHP collapse does not currently
support non-present PTEs.  Keep non-present PTEs out of the lower-order
eligibility check.

Link: https://lore.kernel.org/20260609120443.71864-1-lance.yang@linux.dev
Fixes: 90ed32d00054 ("mm/khugepaged: introduce mTHP collapse support")
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: Nico Pache <npache@redhat.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/khugepaged.c~mm-khugepaged-fix-pmd-collapse-swap-pte-accounting
+++ a/mm/khugepaged.c
@@ -1502,6 +1502,14 @@ static enum scan_result mthp_collapse(st
 		nr_occupied_ptes = bitmap_weight_from(cc->mthp_present_ptes, offset,
 						      offset + nr_ptes);
 
+		/*
+		 * Swap PTEs accepted during the scan are counted in @unmapped,
+		 * not in the present-PTE bitmap. Account them for the PMD-order
+		 * candidate.
+		 */
+		if (is_pmd_order(order))
+			nr_occupied_ptes += unmapped;
+
 		if (nr_occupied_ptes >= nr_ptes - max_ptes_none) {
 			enum scan_result ret;
 
_

Patches currently in -mm which might be from lance.yang@linux.dev are


