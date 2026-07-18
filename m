Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E061862
	for <mm-commits@vger.kernel.org>; Sat, 18 Jul 2026 01:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784337046; cv=none; b=qTknrJYN7zA/8BEAgwdJ7vz9B/gZP18FbryIaBvuvAuDV+9kb0PYo8pjIfWLW7c6NPch46kNlnoIslyLVG3UtxrkV1g4FnDfxiiL2gNtIjX1CQ5GOTpGmk/Ks3HnxvCCC+wsSWa9Gi2auPa0npZrFlDAcyRPC5UWIC0mVXCpdmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784337046; c=relaxed/simple;
	bh=CHAaReYp+Wz7BCYT7OECQbuyR/7wGJx4TSv6xM7nyyA=;
	h=Date:To:From:Subject:Message-Id; b=rsSv5X48vgk4G1rW/oOxwAA4fJ4dJCfrBp4xDT8n1k0+Oq8eQtlD1uFRYEcWAQze8664797WgmFNR+F4a8A5Dz2Wwrg9c8R/xwYBMdhBVGyL22jxHXHz7WUkhTKtgC9Nz3fgzigcbfA32eqjfJeQ+hbl1rmKpJKPAoPoU1vD5Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hfVvejGU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hfVvejGU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B07B01F00A3A;
	Sat, 18 Jul 2026 01:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784337044;
	bh=Re3BK1LQ+NCJB3jY4ae0MiWhIA5RGpwXQfaBMf1aJCs=;
	h=Date:To:From:Subject;
	b=hfVvejGUgHxsqZlO98ZWI4c0dm2iQ+cfgmsg2go8FaFZLJ8yQ1tgBm/HIHDXBbUWw
	 /iKD9JC/FQKSvMcPQ2Ho8JDgmrcSLKCivWX/C66rqai3wK7Z2wLINXfi5Xiiyu0HFT
	 I8nr6dfjOnv4IdPUv0J4Vydvg8Fqk5CAr3PKluUc=
Date: Fri, 17 Jul 2026 18:10:44 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,pfalcato@suse.de,ljs@kernel.org,liam@infradead.org,jannh@google.com,david@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mincore-remove-special-handling-for-vm_pfnmap.patch added to mm-new branch
Message-Id: <20260718011044.B07B01F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: mincore: remove special handling for VM_PFNMAP
has been added to the -mm mm-new branch.  Its filename is
     mm-mincore-remove-special-handling-for-vm_pfnmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mincore-remove-special-handling-for-vm_pfnmap.patch

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
Subject: mm: mincore: remove special handling for VM_PFNMAP
Date: Fri, 17 Jul 2026 17:13:43 +0800

As David pointed out, "it's hard to believe that someone depends on pages
in VM_PFNMAP to *not* be present", so remove the historical behavior that
always reports VM_PFNMAP pages as non-resident.

Adding mincore_pud_range() allows the page table walker to traverse the
full page table hierarchy without splitting a huge PUD, enabling much more
precise identification of resident pages in PFNMAP VMAs.

Link: https://lore.kernel.org/linux-mm/0e619d71-1c3d-4534-8376-2982c7348c31@kernel.org/
Link: https://lore.kernel.org/20260717091347.1144789-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

--- a/mm/mincore.c~mm-mincore-remove-special-handling-for-vm_pfnmap
+++ a/mm/mincore.c
@@ -160,6 +160,21 @@ static int mincore_unmapped_range(unsign
 	return 0;
 }
 
+static int mincore_pud_range(pud_t *pudp, unsigned long addr, unsigned long end,
+		struct mm_walk *walk)
+{
+	if (pud_is_huge(pudp_get(pudp))) {
+		int nr = (end - addr) >> PAGE_SHIFT;
+		unsigned char *vec = walk->private;
+
+		memset(vec, 1, nr);
+		walk->action = ACTION_CONTINUE;
+		walk->private += nr;
+	}
+
+	return 0;
+}
+
 static int mincore_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			struct mm_walk *walk)
 {
@@ -232,6 +247,7 @@ static inline bool can_do_mincore(struct
 }
 
 static const struct mm_walk_ops mincore_walk_ops = {
+	.pud_entry		= mincore_pud_range,
 	.pmd_entry		= mincore_pte_range,
 	.pte_hole		= mincore_unmapped_range,
 	.hugetlb_entry		= mincore_hugetlb,
@@ -259,14 +275,6 @@ static long do_mincore(unsigned long add
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

