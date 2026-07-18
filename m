Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E791862
	for <mm-commits@vger.kernel.org>; Sat, 18 Jul 2026 01:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784337044; cv=none; b=PKhTuMSYTSOHHYZm0dTVFobIxByLJUNzOzQRYAtKT6unE5GQ/A7ZxqTfcKuyvG48ALi09zSPSgJP4Y4YpQC4qGmRUdZqqV23OYKk1V/OZFlzkH0V8gBE1NFdMNgXVe4+REOgn+e9pDWuHhgkBaaqE6iRHs03KKC3oiQXv1wVpCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784337044; c=relaxed/simple;
	bh=UNeLEbDdjNHNzTQOH/VniK1F+3rawLSF3kx0433ZCTQ=;
	h=Date:To:From:Subject:Message-Id; b=kLni8lTSYLBpgAVev7xIohYdKMZlv90Pl0/E5XcG2bNN2OlJO5vfwqC4fj3IOjSJVYeNhYOmPbwg8zJzXUZB1HfjVmLaaHXkAQshmVCYOFXfjFCazyjF3hs+TBC7zjaV8h7gmdntczt85c8uwbvDa5XhJWD8PLoyoio+3U+ZrQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VuG0eRYq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VuG0eRYq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B40851F000E9;
	Sat, 18 Jul 2026 01:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784337042;
	bh=GSyy3ktYQ+InGABKRl/SktW3Qc3T39s+MHrVjmfKc2s=;
	h=Date:To:From:Subject;
	b=VuG0eRYqK1kD0HIsuuR9iwN48DXQRcH0cgNue//cjnYzhTpPWk9w68oLQXphSJT1e
	 1XU8AZBlhr9MFablbrY/Pxkqu0N4w7QVmTXbegsv2IUXaFOOLpOfsOvXhqVfq1JVfX
	 43T7WQzHikOZZuW0xLyHPeCK4bEKobDabo/FSTFY=
Date: Fri, 17 Jul 2026 18:10:42 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,pfalcato@suse.de,ljs@kernel.org,liam@infradead.org,jannh@google.com,david@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-pud_is_huge-helper.patch added to mm-new branch
Message-Id: <20260718011042.B40851F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: introduce pud_is_huge() helper
has been added to the -mm mm-new branch.  Its filename is
     mm-introduce-pud_is_huge-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-pud_is_huge-helper.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: introduce pud_is_huge() helper
Date: Fri, 17 Jul 2026 17:13:42 +0800

Patch series "mm: mincore: misc cleanups", v3.

This series cleans up and simplifies the mincore.  Most importantly, it
removes the historical special behavior that always reports VM_PFNMAP
pages as non-resident.


This patch (of 6):

Introduce the pud_is_huge() helper function to check whether a PUD is a
huge PUD or a software leaf entry.  Note that, unlike PMD, PUD currently
does not support transparent migration entries or device private entries. 
However, the function still includes `!pud_none()` branches to accommodate
potential future implementations.

Link: https://lore.kernel.org/20260717091347.1144789-1-wangkefeng.wang@huawei.com
Link: https://lore.kernel.org/20260717091347.1144789-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/include/linux/huge_mm.h~mm-introduce-pud_is_huge-helper
+++ a/include/linux/huge_mm.h
@@ -472,6 +472,24 @@ void split_huge_pmd_address(struct vm_ar
 void __split_huge_pud(struct vm_area_struct *vma, pud_t *pud,
 		unsigned long address);
 
+/**
+ * pud_is_huge() - Is this PUD either a huge PUD entry or a software leaf entry?
+ * @pud: The PUD to check.
+ *
+ * This is similar to pmd_is_huge(), but it checks at the PUD level.
+ *
+ * Returns: true if this PUD is huge, false otherwise.
+ */
+static inline bool pud_is_huge(pud_t pud)
+{
+	if (pud_present(pud))
+		return pud_trans_huge(pud);
+	else if (!pud_none(pud))
+		return true;
+
+	return false;
+}
+
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
 int change_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		    pud_t *pudp, unsigned long addr, pgprot_t newprot,
@@ -798,6 +816,11 @@ static inline bool pmd_is_huge(pmd_t pmd
 {
 	return false;
 }
+
+static inline bool pud_is_huge(pud_t pud)
+{
+	return false;
+}
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 static inline bool is_pmd_order(unsigned int order)
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-migrate_device-fix-pte_pfn-pte_dirty-called-on-non-present-pte.patch
mm-remove-pagetranscompound.patch
mm-mincore-use-walk_page_range_vma-in-do_mincore.patch
mm-mprotect-use-walk_page_range_vma-in-mprotect_fixup.patch
mm-mlock-use-walk_page_range_vma-in-mlock_vma_pages_range.patch
mm-migrate_device-use-walk_page_range_vma-in-migrate_vma_collect.patch
mm-introduce-pud_is_huge-helper.patch
mm-mincore-remove-special-handling-for-vm_pfnmap.patch
mm-mincore-replace-__get_free_page-with-kmalloc.patch
mm-mincore-remove-xa_is_value-in-mincore_swap.patch
mm-mincore-improve-mincore_hugetlb.patch
mm-mincore-refactor-mincore_page.patch

