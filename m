Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D092ED17B
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388581; cv=none; b=RXTNO+PEN+bFt5sg8C/SaTcwAIs7Y12bMo4lNELmuMC4MUFeGtY5Rc/ncM7MB+ONA/AQm6RiwcZfM62wIBmvWd+1zQrUxMSs8U6CE9zYgsIRSI+r8SQu4aUo3FWJ+7+id2vzkQvL9SxNU4w1kffyR8Ic85wVuae6KQGtO/BIWn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388581; c=relaxed/simple;
	bh=yVguUK3DRIDqtSca8zM6MJ5fZoUIehmDI7WGIs7tlw0=;
	h=Date:To:From:Subject:Message-Id; b=csOA79IS+/t2LzMxmH+InHGu2vUDPEZZUmaZwYCYAmPU05WXp0AzRY/y7IuoxImKj60BbLVYDkqDkKk9pQzbcZxW4FzB6yoMuriyf08epTg3FqxPtbbM/AAcUZ1qtYd4cIpAsyjAfBQ9TQVMSb+r2RcLy9BdSXOMry1pnzsfuis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fJtxjMzR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fJtxjMzR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFBF3C19424;
	Tue, 24 Mar 2026 21:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388580;
	bh=yVguUK3DRIDqtSca8zM6MJ5fZoUIehmDI7WGIs7tlw0=;
	h=Date:To:From:Subject:From;
	b=fJtxjMzRWi7o2MERukId5sEUflmWnKRYdhPumaY08DRJl9Vv8FDK8zBNIJ+dJNhK+
	 dYgaBrknVbHH2veB1O+qnMVhuug4GIEhl0xuUiVbLzUqV96MYfSw1d9a7EZfo3Clk9
	 AO8Gb5t5XEyB3+uQQwjPOJ52dKyQPHZ2G1iuHhT4=
Date: Tue, 24 Mar 2026 14:43:00 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,willy@infradead.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kevin.brodsky@arm.com,david@kernel.org,davem@davemloft.net,andreas@gaisler.com,akpm@linux-foundation.org,chengkaitao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-vmemmap_pd_populate-to-static-functions.patch removed from -mm tree
Message-Id: <20260324214300.AFBF3C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: convert vmemmap_p?d_populate() to static functions
has been removed from the -mm tree.  Its filename was
     mm-convert-vmemmap_pd_populate-to-static-functions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chengkaitao <chengkaitao@kylinos.cn>
Subject: mm: convert vmemmap_p?d_populate() to static functions
Date: Sun, 1 Feb 2026 14:35:32 +0800

Since the vmemmap_p?d_populate functions are unused outside the mm
subsystem, we can remove their external declarations and convert them to
static functions.

Link: https://lkml.kernel.org/r/20260201063532.44807-3-pilgrimtao@gmail.com
Signed-off-by: Chengkaitao <chengkaitao@kylinos.cn>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h  |    7 -------
 mm/sparse-vmemmap.c |   10 +++++-----
 2 files changed, 5 insertions(+), 12 deletions(-)

--- a/include/linux/mm.h~mm-convert-vmemmap_pd_populate-to-static-functions
+++ a/include/linux/mm.h
@@ -4486,13 +4486,6 @@ unsigned long section_map_size(void);
 struct page * __populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap);
-pgd_t *vmemmap_pgd_populate(unsigned long addr, int node);
-p4d_t *vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node);
-pud_t *vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node);
-pmd_t *vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node);
-pte_t *vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
-			    struct vmem_altmap *altmap, unsigned long ptpfn,
-			    unsigned long flags);
 void *vmemmap_alloc_block(unsigned long size, int node);
 struct vmem_altmap;
 void *vmemmap_alloc_block_buf(unsigned long size, int node,
--- a/mm/sparse-vmemmap.c~mm-convert-vmemmap_pd_populate-to-static-functions
+++ a/mm/sparse-vmemmap.c
@@ -151,7 +151,7 @@ void __meminit vmemmap_verify(pte_t *pte
 			start, end - 1);
 }
 
-pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
+static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
 				       struct vmem_altmap *altmap,
 				       unsigned long ptpfn, unsigned long flags)
 {
@@ -195,7 +195,7 @@ static void * __meminit vmemmap_alloc_bl
 	return p;
 }
 
-pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node)
+static pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node)
 {
 	pmd_t *pmd = pmd_offset(pud, addr);
 	if (pmd_none(*pmd)) {
@@ -208,7 +208,7 @@ pmd_t * __meminit vmemmap_pmd_populate(p
 	return pmd;
 }
 
-pud_t * __meminit vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node)
+static pud_t * __meminit vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node)
 {
 	pud_t *pud = pud_offset(p4d, addr);
 	if (pud_none(*pud)) {
@@ -221,7 +221,7 @@ pud_t * __meminit vmemmap_pud_populate(p
 	return pud;
 }
 
-p4d_t * __meminit vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node)
+static p4d_t * __meminit vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node)
 {
 	p4d_t *p4d = p4d_offset(pgd, addr);
 	if (p4d_none(*p4d)) {
@@ -234,7 +234,7 @@ p4d_t * __meminit vmemmap_p4d_populate(p
 	return p4d;
 }
 
-pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
+static pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
 {
 	pgd_t *pgd = pgd_offset_k(addr);
 	if (pgd_none(*pgd)) {
_

Patches currently in -mm which might be from chengkaitao@kylinos.cn are

sparc-use-vmemmap_populate_hugepages-for-vmemmap_populate.patch
mm-mark-early-init-static-variables-with-__meminitdata.patch

