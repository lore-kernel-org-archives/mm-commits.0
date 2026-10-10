Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D127D352C5B
	for <mm-commits@vger.kernel.org>; Sat, 10 Oct 2026 20:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791664490; cv=none; b=FezrA/cu/jJoDF+YghSJxHEzgKKzlPmf0NyIPkG0EVkcYu6V5NZrIW1KxOo/g09ttR5cy4AOWeC07uNQEqGN1rI1iVIADj9/Q+j/XnFLxQR4s0bP/S+J6ikNV/i3AJewQFbqNxFtp7hlHYucJtwaA/2PA8s6ID+HxBd5LzkZtYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791664490; c=relaxed/simple;
	bh=XhqoQJc4sdKTtE6W/a8bs6a0Nu7+sSbQ7VFYX3A7rLM=;
	h=Date:To:From:Subject:Message-Id; b=HbBUfDMj5TmZD6qRmcEcUXblNm4CKMWemokUWum8skwB2jg+w1bMrcSUYlvuYAdDp9uQ0d+8tjGpAFk73tzSPIMdsuEFYsVlU7LF7a31RJhP7cX9nlj2/cgE+kEhEYS3s53pvWeFGCFEXW4AcJCbOIIqumPfUaFcZ2ec8/CuKYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dUUXJqAJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dUUXJqAJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 695C81F00893;
	Sat, 10 Oct 2026 20:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791664489;
	bh=OkWKs4bxZ4TE6RBgt/PMUis0/rhjfgaR9h4MFZq0GOs=;
	h=Date:To:From:Subject;
	b=dUUXJqAJOyVQMinhbIzPlBd5LiGl5BJBH5/xNR8XGOcncK1sgMjPLPHXcbmk2/KVx
	 uLgJbYBp/Dezlu/gWwAx0oi+8/T32hduHBhIvYsrlb7Jbk6JrKezTP2onRqifQ/hNt
	 InNi0gAOtYxQV6LfsBx19KtDQBZd6nayKc9sL0oc=
Date: Sat, 10 Oct 2026 13:34:49 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-sparse-vmemmap-remove-the-unused-ptpfn-argument.patch removed from -mm tree
Message-Id: <20261010203449.695C81F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse-vmemmap: remove the unused ptpfn argument
has been removed from the -mm tree.  Its filename was
     mm-sparse-vmemmap-remove-the-unused-ptpfn-argument.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Muchun Song <muchun.song@linux.dev>
Subject: mm/sparse-vmemmap: remove the unused ptpfn argument
Date: Tue, 29 Sep 2026 13:32:29 +0800

vmemmap_pte_populate() no longer uses ptpfn as an input.  Drop the
argument to simplify the code.

Link: https://lore.kernel.org/20260929053231.66085-5-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
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

mm-sparse-vmemmap-open-code-vmemmap_populate_address.patch
mm-mm_init-add-zone-mismatch-warning-during-page-init.patch
mm-fix-missing-page-table-destructor-in-pagetable_free.patch
riscv-mm-fix-hotplug-page-table-destructor-handling.patch
riscv-mm-fix-missing-destructor-for-hotplug-pud-tables.patch
arm64-mm-fix-destructor-for-unconstructed-hotplug-page-tables.patch

