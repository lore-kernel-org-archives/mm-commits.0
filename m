Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039803B1035
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068109; cv=none; b=C3hUEfUAfcQ3Q57FzpR1vwDW/gVfpz7Ew17iRE17yWAbh1YyJKujIuJtveJseC+pEjuuVgJWl9utn5Kro+C7wV1RinOB5n5xg9GaP3amMTw04XDt8sLkqlA5matNKVwWVn7Oa3+l9iEYO05vhXI3xpWbtzUhotwcaEdyJ8vwMzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068109; c=relaxed/simple;
	bh=MDANHYIjIj52J2LTY0NDm1RSM5cVmz+VcjPHoIVq1is=;
	h=Date:To:From:Subject:Message-Id; b=VYOdx4B8MwIyDuI1n0HMeDbRV5bOa2xhtrFws295gtCYUPkIwBla9z/ozvod9frRnX62yAjT4VxUq5Y8k+5hcsUGdJy29OjTfIlBgdk0mLy9a6COWmJ69BvFre3n6BWtc2SC8wGwD2+hv/A1xn1dFN5/COZJC4WD4Fede0C5WFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vqZsfTZs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vqZsfTZs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC61B1F00A3A;
	Fri,  7 Aug 2026 02:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068107;
	bh=d3B7z4/iH2OB/s/tuMuRtZ9ZUwcJztpu67Bg6t0n/NI=;
	h=Date:To:From:Subject;
	b=vqZsfTZs1m534k7pM7SmpZ4QtpsPLabmRRrlhJH1tHPDB7Sx8prJ5gI5dA09tTrid
	 /eAoN1NQPT3x7dfx2oWx69po/zDa0cZyggZRxORkktmZpGG8lwuzBAcM3tKoihOTpx
	 Tnanav8P/N/xHI9ZJNFa9Z0LCnPpep5rxxnUHi9o=
Date: Thu, 06 Aug 2026 19:01:47 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,pfalcato@suse.de,ljs@kernel.org,liam@infradead.org,jannh@google.com,david@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mincore-remove-special-handling-for-vm_pfnmap.patch removed from -mm tree
Message-Id: <20260807020147.CC61B1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: mincore: remove special handling for VM_PFNMAP
has been removed from the -mm tree.  Its filename was
     mm-mincore-remove-special-handling-for-vm_pfnmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: mincore: remove special handling for VM_PFNMAP
Date: Fri, 17 Jul 2026 17:13:43 +0800

As David pointed out, "it's hard to believe that someone depends on pages
in VM_PFNMAP to *not* be present", so remove the historical behavior that
always reports VM_PFNMAP pages as non-resident.

Adding mincore_pud_range() allows the page table walker to traverse the
full page table hierarchy without splitting a huge PUD, enabling much more
precise identification of resident pages in PFNMAP VMAs.

[wangkefeng.wang@huawei.com: address David's comments]
  Link: https://lore.kernel.org/20260720124151.1483820-1-wangkefeng.wang@huawei.com
Link: https://lore.kernel.org/linux-mm/0e619d71-1c3d-4534-8376-2982c7348c31@kernel.org/
Link: https://lore.kernel.org/20260717091347.1144789-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

--- a/mm/mincore.c~mm-mincore-remove-special-handling-for-vm_pfnmap
+++ a/mm/mincore.c
@@ -160,6 +160,20 @@ static int mincore_unmapped_range(unsign
 	return 0;
 }
 
+static int mincore_pud_entry(pud_t *pudp, unsigned long addr, unsigned long end,
+		struct mm_walk *walk)
+{
+	if (pud_is_huge(pudp_get(pudp))) {
+		const unsigned long nr = (end - addr) >> PAGE_SHIFT;
+
+		memset(walk->private, 1, nr);
+		walk->private += nr;
+		walk->action = ACTION_CONTINUE;
+	}
+
+	return 0;
+}
+
 static int mincore_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			struct mm_walk *walk)
 {
@@ -232,6 +246,7 @@ static inline bool can_do_mincore(struct
 }
 
 static const struct mm_walk_ops mincore_walk_ops = {
+	.pud_entry		= mincore_pud_entry,
 	.pmd_entry		= mincore_pte_range,
 	.pte_hole		= mincore_unmapped_range,
 	.hugetlb_entry		= mincore_hugetlb,
@@ -259,14 +274,6 @@ static long do_mincore(unsigned long add
 		return pages;
 	}
 
-	/*
-	 * mincore historically reports PFNMAP mappings as non-resident.
-	 */
-	if (vma->vm_flags & VM_PFNMAP) {
-		__mincore_unmapped_range(addr, end, vma, vec);
-		return (end - addr) >> PAGE_SHIFT;
-	}
-
 	err = walk_page_range_vma(vma, addr, end, &mincore_walk_ops, vec);
 	if (err < 0)
 		return err;
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


