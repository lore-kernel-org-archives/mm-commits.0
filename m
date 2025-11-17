Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A7B1FBEA2
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343095; cv=none; b=ENkC2kfCnCi93mBi7Z8Fxv3bdB1dCgP1OY0ylp1L3fMcr8A6Dhi2TdpWHjdIm4GZzOGI699WtRHfSDnvh9G40R7tKYBfRTLN/iVuO7XezExLzOBip+CrTtR8+CAA1o3smdibv3gTKTOA0xMpN7ZNguwgsCdm/V4fkDaL1K/w2KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343095; c=relaxed/simple;
	bh=ICbgfAvAo/QesoAJ9ECz/1isv2i1Wnjpj5/Ecn4NIjA=;
	h=Date:To:From:Subject:Message-Id; b=TsEjavu4rt3skDP5pLxN2CBGb8pDtm65Tq1AtdSnpCYT9Gy8VyLriqVkwx227uh/4rZ/zWoERUx9yvlt8tDmmpjjTrXpOTdt6wFB8O2AGTLwmC0ZZHUAaGOzziAmJRfQznvAlw2UeaMTR/6HctMqInjyGBOcZxPhpaC990SUzRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qbeVPwt+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qbeVPwt+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B101C4CEF1;
	Mon, 17 Nov 2025 01:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343094;
	bh=ICbgfAvAo/QesoAJ9ECz/1isv2i1Wnjpj5/Ecn4NIjA=;
	h=Date:To:From:Subject:From;
	b=qbeVPwt+v6d61vxdX0kMY2kbooRc4Pkk8yT5q/KutI/kKic6bexYL6Pds4+mUq8Q2
	 1jkzeFVbWYSc17kvdR8Z+sE5t3AbY99GMZ/1I1wb4orjDqZjydivxUp6bvDzwPdKp8
	 aK2CZyi2hd+saUpS0oSDY3pcXn7STR4rejO8hy14=
Date: Sun, 16 Nov 2025 17:31:33 -0800
To: mm-commits@vger.kernel.org,richard.weiyang@gmail.com,lance.yang@linux.dev,dev.jain@arm.com,david@redhat.com,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-replace-read_once-with-standard-page-table-accessors.patch removed from -mm tree
Message-Id: <20251117013134.7B101C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: replace READ_ONCE() with standard page table accessors
has been removed from the -mm tree.  Its filename was
     mm-replace-read_once-with-standard-page-table-accessors.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm: replace READ_ONCE() with standard page table accessors
Date: Tue, 7 Oct 2025 07:31:00 +0100

Replace all READ_ONCE() with a standard page table accessors i.e
pxdp_get() that defaults into READ_ONCE() in cases where platform does not
override.

Link: https://lkml.kernel.org/r/20251007063100.2396936-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c            |   10 +++++-----
 mm/hmm.c            |    2 +-
 mm/memory.c         |    4 ++--
 mm/mprotect.c       |    2 +-
 mm/sparse-vmemmap.c |    2 +-
 mm/vmscan.c         |    2 +-
 6 files changed, 11 insertions(+), 11 deletions(-)

--- a/mm/gup.c~mm-replace-read_once-with-standard-page-table-accessors
+++ a/mm/gup.c
@@ -950,7 +950,7 @@ static struct page *follow_pud_mask(stru
 	struct mm_struct *mm = vma->vm_mm;
 
 	pudp = pud_offset(p4dp, address);
-	pud = READ_ONCE(*pudp);
+	pud = pudp_get(pudp);
 	if (!pud_present(pud))
 		return no_page_table(vma, flags, address);
 	if (pud_leaf(pud)) {
@@ -975,7 +975,7 @@ static struct page *follow_p4d_mask(stru
 	p4d_t *p4dp, p4d;
 
 	p4dp = p4d_offset(pgdp, address);
-	p4d = READ_ONCE(*p4dp);
+	p4d = p4dp_get(p4dp);
 	BUILD_BUG_ON(p4d_leaf(p4d));
 
 	if (!p4d_present(p4d) || p4d_bad(p4d))
@@ -3060,7 +3060,7 @@ static int gup_fast_pud_range(p4d_t *p4d
 
 	pudp = pud_offset_lockless(p4dp, p4d, addr);
 	do {
-		pud_t pud = READ_ONCE(*pudp);
+		pud_t pud = pudp_get(pudp);
 
 		next = pud_addr_end(addr, end);
 		if (unlikely(!pud_present(pud)))
@@ -3086,7 +3086,7 @@ static int gup_fast_p4d_range(pgd_t *pgd
 
 	p4dp = p4d_offset_lockless(pgdp, pgd, addr);
 	do {
-		p4d_t p4d = READ_ONCE(*p4dp);
+		p4d_t p4d = p4dp_get(p4dp);
 
 		next = p4d_addr_end(addr, end);
 		if (!p4d_present(p4d))
@@ -3108,7 +3108,7 @@ static void gup_fast_pgd_range(unsigned
 
 	pgdp = pgd_offset(current->mm, addr);
 	do {
-		pgd_t pgd = READ_ONCE(*pgdp);
+		pgd_t pgd = pgdp_get(pgdp);
 
 		next = pgd_addr_end(addr, end);
 		if (pgd_none(pgd))
--- a/mm/hmm.c~mm-replace-read_once-with-standard-page-table-accessors
+++ a/mm/hmm.c
@@ -491,7 +491,7 @@ static int hmm_vma_walk_pud(pud_t *pudp,
 	/* Normally we don't want to split the huge page */
 	walk->action = ACTION_CONTINUE;
 
-	pud = READ_ONCE(*pudp);
+	pud = pudp_get(pudp);
 	if (!pud_present(pud)) {
 		spin_unlock(ptl);
 		return hmm_vma_walk_hole(start, end, -1, walk);
--- a/mm/memory.c~mm-replace-read_once-with-standard-page-table-accessors
+++ a/mm/memory.c
@@ -6690,12 +6690,12 @@ retry:
 		goto out;
 
 	p4dp = p4d_offset(pgdp, address);
-	p4d = READ_ONCE(*p4dp);
+	p4d = p4dp_get(p4dp);
 	if (p4d_none(p4d) || unlikely(p4d_bad(p4d)))
 		goto out;
 
 	pudp = pud_offset(p4dp, address);
-	pud = READ_ONCE(*pudp);
+	pud = pudp_get(pudp);
 	if (pud_none(pud))
 		goto out;
 	if (pud_leaf(pud)) {
--- a/mm/mprotect.c~mm-replace-read_once-with-standard-page-table-accessors
+++ a/mm/mprotect.c
@@ -599,7 +599,7 @@ again:
 			break;
 		}
 
-		pud = READ_ONCE(*pudp);
+		pud = pudp_get(pudp);
 		if (pud_none(pud))
 			continue;
 
--- a/mm/sparse-vmemmap.c~mm-replace-read_once-with-standard-page-table-accessors
+++ a/mm/sparse-vmemmap.c
@@ -439,7 +439,7 @@ int __meminit vmemmap_populate_hugepages
 			return -ENOMEM;
 
 		pmd = pmd_offset(pud, addr);
-		if (pmd_none(READ_ONCE(*pmd))) {
+		if (pmd_none(pmdp_get(pmd))) {
 			void *p;
 
 			p = vmemmap_alloc_block_buf(PMD_SIZE, node, altmap);
--- a/mm/vmscan.c~mm-replace-read_once-with-standard-page-table-accessors
+++ a/mm/vmscan.c
@@ -3773,7 +3773,7 @@ static int walk_pud_range(p4d_t *p4d, un
 	pud = pud_offset(p4d, start & P4D_MASK);
 restart:
 	for (i = pud_index(start), addr = start; addr != end; i++, addr = next) {
-		pud_t val = READ_ONCE(pud[i]);
+		pud_t val = pudp_get(pud + i);
 
 		next = pud_addr_end(addr, end);
 
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are


