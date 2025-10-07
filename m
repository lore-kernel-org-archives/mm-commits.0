Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5E61CEAD6
	for <mm-commits@vger.kernel.org>; Tue,  7 Oct 2025 22:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759874507; cv=none; b=oddECenh29k3zbcDo0mnXsjL61pzZzFR5T/nrS7BOzZEWBdXKOOX8Mdt9XPvuzvo+1dIyW120kLspeXQgPvsZbM733KSkkkT0kF0E9dNbmM/TLFKYERjuXgTtm5HNg4l/nEdYdNA33ZarUfY+ULXOXP0guyp/0PPy2lKJ9hU1PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759874507; c=relaxed/simple;
	bh=7/mjbT904c3yXGpv5zQDIwHLmNvxyBLdBVPnULmAbmc=;
	h=Date:To:From:Subject:Message-Id; b=Nyi0HHiHD3YzP5hweogY8PauuaMoWFEFGNzmDasZRWpHhMOJXaLkcdnynNnX+nC8vlZWAA0jqDhLi7/W1ya+CZgcv/gNg3PMMdnklnLqBuUnRd0WOAuxLVUXyv7ea+/e6PkVoEFKra9kUNHmJvGNdlwIAfBZc8pRoWpVRpO2hgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cQ8kuaeD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cQ8kuaeD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 186FEC4CEF1;
	Tue,  7 Oct 2025 22:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759874507;
	bh=7/mjbT904c3yXGpv5zQDIwHLmNvxyBLdBVPnULmAbmc=;
	h=Date:To:From:Subject:From;
	b=cQ8kuaeDsOgOfizW10wg77CMAThq6uTSIIkaE6jkkeCYC5m2m30aiovnjr3PbWxmI
	 YRsrDWBYuWRcH7YR0PgHeufsBCHjjBtgvj6zVTcw0prc5VZLN1OP0eJavevvIJauMs
	 D3pNEoOrPmBJUqaAk1lqeY9bqIPDFrEhidJVPlLs=
Date: Tue, 07 Oct 2025 15:01:46 -0700
To: mm-commits@vger.kernel.org,dev.jain@arm.com,david@redhat.com,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-replace-read_once-with-standard-page-table-accessors.patch added to mm-new branch
Message-Id: <20251007220147.186FEC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: replace READ_ONCE() with standard page table accessors
has been added to the -mm mm-new branch.  Its filename is
     mm-replace-read_once-with-standard-page-table-accessors.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-replace-read_once-with-standard-page-table-accessors.patch

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
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm: replace READ_ONCE() with standard page table accessors
Date: Tue, 7 Oct 2025 07:31:00 +0100

Replace all READ_ONCE() with a standard page table accessors i.e
pxdp_get() that defaults into READ_ONCE() in cases where platform does not
override.

Link: https://lkml.kernel.org/r/20251007063100.2396936-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
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
@@ -6716,12 +6716,12 @@ retry:
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
@@ -3751,7 +3751,7 @@ static int walk_pud_range(p4d_t *p4d, un
 	pud = pud_offset(p4d, start & P4D_MASK);
 restart:
 	for (i = pud_index(start), addr = start; addr != end; i++, addr = next) {
-		pud_t val = READ_ONCE(pud[i]);
+		pud_t val = pudp_get(pud + i);
 
 		next = pud_addr_end(addr, end);
 
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-thp-drop-follow_devmap_pmd-default-stub.patch
mm-ptdump-replace-read_once-with-standard-page-table-accessors.patch
mm-replace-read_once-with-standard-page-table-accessors.patch

