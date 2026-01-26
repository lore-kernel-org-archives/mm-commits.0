Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FDA2737F9
	for <mm-commits@vger.kernel.org>; Mon, 26 Jan 2026 19:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769454632; cv=none; b=ThuyQeJKg8LWmzyfpYoxnsFsYgJ6/mSQJTAHnlYmgKLiHqlrCU0j1BvbKmp/PvUa/TeeCiZIoIjWnpkrh8/rrBdEh8WTB2+PafYLGX0hTRJn8UiuKfViO33GTJowiXQ4lH0m+qrqwWqg1Crr8bCYfEaH59TZdNAf3ugjSWJNff8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769454632; c=relaxed/simple;
	bh=EF+ye5Wmxz+j0X3/uvnUno6RWPVbNi9TP0e5Z+d+ILk=;
	h=Date:To:From:Subject:Message-Id; b=QvrQLVeDPzpDA/PFYzmpVX6LdVUlqE37/1yX20p0EbzXfrbFTleCdDK6+Ml/1XBeTTjFG0A+vFL70l6nB9Dy4AQoEEK4JKTqyO/ZCYrlPr+0j4MapvseABSN5zPMKp7REAeCeuXvaS+5sr/4x6di6FxwJ7+hRFcS1Qid4YI5fIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YCACj3qI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YCACj3qI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 000EFC116C6;
	Mon, 26 Jan 2026 19:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769454632;
	bh=EF+ye5Wmxz+j0X3/uvnUno6RWPVbNi9TP0e5Z+d+ILk=;
	h=Date:To:From:Subject:From;
	b=YCACj3qIolq41K7+ZNrk0l2vLffNOK3UZX2Iw1tciGGhvbk5V3eErRWfcK3hu075W
	 AxTsBd6qDZuX+yMyFXlFVwRz1TH6wKbOfjY5QcjhZQo3K/kUA171oDOmC6pGNaWZMD
	 +Hzt7iemfvi8hjXORiACGll+ZgjyLZ/Xej0t1jGs=
Date: Mon, 26 Jan 2026 11:10:31 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,willy@infradead.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kevin.brodsky@arm.com,david@kernel.org,davem@davemloft.net,andreas@gaisler.com,agordeev@linux.ibm.com,chengkaitao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-convert-vmemmap_pd_populate-to-static-functions.patch removed from -mm tree
Message-Id: <20260126191032.000EFC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: convert vmemmap_p?d_populate() to static functions
has been removed from the -mm tree.  Its filename was
     mm-convert-vmemmap_pd_populate-to-static-functions.patch

This patch was dropped because an updated version will be issued

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
@@ -4294,13 +4294,6 @@ unsigned long section_map_size(void);
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


