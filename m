Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898E62853F7
	for <mm-commits@vger.kernel.org>; Mon, 12 Jan 2026 22:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768257153; cv=none; b=TN0KiMH0Py1iwQAE/36r+V3FxCmC7jYv4VvWymRRcIyfKvv8ei6KCq44RQT/2gdh6287aKPhMhhIqYpBF4RSm321RaOwL37s91p8w9v6tB93E4j2V2uFRRLzLdgxs4pZ9Ch1fZxggKIcEf58HwaEYkGXPc3w13egi1Sbmd5wLAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768257153; c=relaxed/simple;
	bh=VOEWetcT7nIfecRw8eGgyEPR0xsC5c7uQR6Y+6KzJss=;
	h=Date:To:From:Subject:Message-Id; b=dgYJ5XMiyhuab3pXsnqTldc6XcbNGfa2a6dRreTtQkMBNPRNPNorTJh1Ll9yhHbFJh84DVwQbryj5lDxm39rKqN1kXgrB8z3Bq9t7JikKZaV1a0vVKldBHzmYVasIaoKxdKiwp9DdX3MJEPU17qEVpejjjDlmFanI5ael7HWJaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o8LTspCk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o8LTspCk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D86BC116D0;
	Mon, 12 Jan 2026 22:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768257153;
	bh=VOEWetcT7nIfecRw8eGgyEPR0xsC5c7uQR6Y+6KzJss=;
	h=Date:To:From:Subject:From;
	b=o8LTspCk2ptknIZ+oYnSJOCbqpdIjK8oJTFiZeHOgpqacJuaSJp7XsMkmL5p46u9Z
	 SLMOT4cg60IjfzV4sLz1aEwXzbn2pX2a7eYPvFV5XlT9inqI8hqW1+JtG1P7OtLzQK
	 lU5DqBpBPUOgGLfKdKnt2tATndZMJplctbagG57I=
Date: Mon, 12 Jan 2026 14:32:32 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,willy@infradead.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kevin.brodsky@arm.com,david@kernel.org,davem@davemloft.net,andreas@gaisler.com,agordeev@linux.ibm.com,chengkaitao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-vmemmap_pd_populate-to-static-functions.patch added to mm-new branch
Message-Id: <20260112223233.2D86BC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: convert vmemmap_p?d_populate() to static functions
has been added to the -mm mm-new branch.  Its filename is
     mm-convert-vmemmap_pd_populate-to-static-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-vmemmap_pd_populate-to-static-functions.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Chengkaitao <chengkaitao@kylinos.cn>
Subject: mm: convert vmemmap_p?d_populate() to static functions
Date: Sun, 11 Jan 2026 15:44:53 +0800

Since the vmemmap_p?d_populate functions are unused outside the mm
subsystem, we can remove their external declarations and convert them to
static functions.

Link: https://lkml.kernel.org/r/20260111074453.66728-3-pilgrimtao@gmail.com
Signed-off-by: Chengkaitao <chengkaitao@kylinos.cn>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h  |    7 -------
 mm/sparse-vmemmap.c |   10 +++++-----
 2 files changed, 5 insertions(+), 12 deletions(-)

--- a/include/linux/mm.h~mm-convert-vmemmap_pd_populate-to-static-functions
+++ a/include/linux/mm.h
@@ -4323,13 +4323,6 @@ unsigned long section_map_size(void);
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
mm-convert-vmemmap_pd_populate-to-static-functions.patch

