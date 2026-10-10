Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A34837A49D
	for <mm-commits@vger.kernel.org>; Sat, 10 Oct 2026 20:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791664997; cv=none; b=ifYFKryNXsEzVjhqQOAUiDSFNnMwj5BTUGjzmowgBrx692m6WsoeiaXQGEHijDMlxTy9xiiiZ9+kSYJoJ0Il3SeviCNCN10ohCenmHsZt1VwyR/bGr334Bmqkg7eA9qJxX8CA1VVx26EJn1VjzdH+61eL/qKsVRaCzq6YudAsVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791664997; c=relaxed/simple;
	bh=Dfq/ttQhCPy3SOugS4HKCDzhQyTJyI5Ob8BE+sAtm7M=;
	h=Date:To:From:Subject:Message-Id; b=r89ra9Lyf4Gcvby2e59dvW6JN8NvSJwEAc2bhS9I4Q1D9wz0IZtGi2vfJ2IW3jTps+ieyPENEIUGEnVYTxF+xOBHAjwOBBYnffLtBMJx7z6f1J+tn7sS1LDgXRgOOzxHBpbRodZuVInSIANz9hhqIVXVrf5D0go3z+YkwC6jzkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Es/ySiv0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Es/ySiv0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AAE61F000FF;
	Sat, 10 Oct 2026 20:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791664996;
	bh=59x3ummQdTrdu9sJpGwhxI4wZFti5LvIAlJStUuqGZ4=;
	h=Date:To:From:Subject;
	b=Es/ySiv0O93qndIFIy48hRSoCSf82GYil2zmb4rAzwFG7dDPG7aVjUb+m41ouqRjf
	 mX+s78LJtlgQOhjuXFzEzsUMIFYI6iJcuyw5vwDnvD6X8fW/0/23uXy/3smDiwKl29
	 XZ+ySWXzqryXwvRSoWNa5IyOkreVHyHv+y6UrFyU=
Date: Sat, 10 Oct 2026 13:43:15 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-vmemmap-remove-the-unused-ptpfn-argument.patch added to mm-unstable branch
Message-Id: <20261010204316.2AAE61F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/sparse-vmemmap: remove the unused ptpfn argument
has been added to the -mm mm-unstable branch.  Its filename is
     mm-sparse-vmemmap-remove-the-unused-ptpfn-argument.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-vmemmap-remove-the-unused-ptpfn-argument.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Muchun Song <muchun.song@linux.dev>
Subject: mm/sparse-vmemmap: remove the unused ptpfn argument
Date: Sat, 10 Oct 2026 15:57:53 +0800

vmemmap_pte_populate() no longer uses ptpfn as an input.  Drop the
argument to simplify the code.

Link: https://lore.kernel.org/20261010075755.83339-5-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <chleroy@kernel.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Shrikanth Hegde <sshegde@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
---

 mm/sparse-vmemmap.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/mm/sparse-vmemmap.c~mm-sparse-vmemmap-remove-the-unused-ptpfn-argument
+++ a/mm/sparse-vmemmap.c
@@ -282,7 +282,7 @@ static __meminit void *vmemmap_alloc_pte
 }
 
 static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
-		struct vmem_altmap *altmap, unsigned long ptpfn)
+		struct vmem_altmap *altmap)
 {
 	pte_t *pte = pte_offset_kernel(pmd, addr);
 	unsigned long pfn = page_to_pfn((struct page *)addr);
@@ -353,8 +353,7 @@ static pgd_t * __meminit vmemmap_pgd_pop
 }
 
 static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
-					      struct vmem_altmap *altmap,
-					      unsigned long ptpfn)
+						  struct vmem_altmap *altmap)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -374,7 +373,7 @@ static pte_t * __meminit vmemmap_populat
 	pmd = vmemmap_pmd_populate(pud, addr, node);
 	if (!pmd)
 		return NULL;
-	pte = vmemmap_pte_populate(pmd, addr, node, altmap, ptpfn);
+	pte = vmemmap_pte_populate(pmd, addr, node, altmap);
 	if (!pte)
 		return NULL;
 	vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
@@ -384,15 +383,13 @@ static pte_t * __meminit vmemmap_populat
 
 static int __meminit vmemmap_populate_range(unsigned long start,
 					    unsigned long end, int node,
-					    struct vmem_altmap *altmap,
-					    unsigned long ptpfn)
+					    struct vmem_altmap *altmap)
 {
 	unsigned long addr = start;
 	pte_t *pte;
 
 	for (; addr < end; addr += PAGE_SIZE) {
-		pte = vmemmap_populate_address(addr, node, altmap,
-					       ptpfn);
+		pte = vmemmap_populate_address(addr, node, altmap);
 		if (!pte)
 			return -ENOMEM;
 	}
@@ -403,7 +400,7 @@ static int __meminit vmemmap_populate_ra
 int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
 					 int node, struct vmem_altmap *altmap)
 {
-	return vmemmap_populate_range(start, end, node, altmap, -1);
+	return vmemmap_populate_range(start, end, node, altmap);
 }
 
 /*
_

Patches currently in -mm which might be from muchun.song@linux.dev are

mm-sparse-vmemmap-drop-vmemmap_populate_dax.patch
mm-sparse-vmemmap-support-device-dax-in-common-vmemmap-path.patch
mm-sparse-vmemmap-drop-device-dax-specific-population-path.patch
mm-sparse-vmemmap-remove-the-unused-ptpfn-argument.patch
mm-sparse-vmemmap-open-code-vmemmap_populate_address.patch
mm-mm_init-add-zone-mismatch-warning-during-page-init.patch
mm-mm_init-add-zone-mismatch-warning-during-page-init-fix.patch
mm-fix-missing-page-table-destructor-in-pagetable_free.patch
riscv-mm-fix-hotplug-page-table-destructor-handling.patch
riscv-mm-fix-missing-destructor-for-hotplug-pud-tables.patch
arm64-mm-fix-destructor-for-unconstructed-hotplug-page-tables.patch

