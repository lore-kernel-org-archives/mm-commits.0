Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8219136EA98
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027565; cv=none; b=kZCBxl0aUmY7Ctj95RaCYZnwF6HUPWY+00QJCuka4bgDlA72fjRtydPmVSEsrxuG4IYPG3/qH5sVEp/OE22hjAx8URuaJholc+R77fapXwtgljpyrFfijZj65+UaFKV2JCZJ0RbtBeGNvUjiri+ZVpSCZLHLwvnRRwbVbeEAUBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027565; c=relaxed/simple;
	bh=DW04jsINuZrcQuXST006AepbMeF2AYMiqoVdGiJmUBc=;
	h=Date:To:From:Subject:Message-Id; b=NMj0o4qVSyomn7UAT87+98MpF4s8fZed4d6VLWbWDJnkNPnvfRsvnEOMunw50FHWsNwkck1Rkeso4/EKtaiFwJuehRGthcIONoRIeeNqID9mEYqYIQdJ8nDxfywyRPGoCaklDCtPn2APsKCtJBLtukKdnOozuO/WcBuN6OgsQjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fVvkImF/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fVvkImF/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C35281F00893;
	Fri, 29 May 2026 04:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027562;
	bh=2eE7QdscWF8FqVEq6dhq9TY33/glc6pIyrqVWApj11U=;
	h=Date:To:From:Subject;
	b=fVvkImF/pIEv6nEmTIRqT6l8VkUzqSszkqCjaWAiz5xkhTi2vpkjSaFAw2zP+1aYO
	 BzKYvsEe36pq9Dy37kg4wqkV2Re/pBS00sVKWTRSG80LexaVyg4sHnNgLBHuI6bbS4
	 4+Hlbewp0AzSiP1AbwN3w+o3xtXKtXp6Te5MgtWE=
Date: Thu, 28 May 2026 21:06:02 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,rppt@kernel.org,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,chengkaitao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-vmemmap_pd_populate-to-static-functions.patch removed from -mm tree
Message-Id: <20260529040602.C35281F00893@smtp.kernel.org>
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
Date: Thu, 23 Apr 2026 18:14:41 +0800

Since the vmemmap_p?d_populate functions are unused outside the mm
subsystem, we can remove their external declarations and convert them to
static functions.

Link: https://lore.kernel.org/20260423101441.7089-1-kaitao.cheng@linux.dev
Signed-off-by: Chengkaitao <chengkaitao@kylinos.cn>
Acked-by: David Hildenbrand (arm) <david@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h  |    7 -------
 mm/sparse-vmemmap.c |   10 +++++-----
 2 files changed, 5 insertions(+), 12 deletions(-)

--- a/include/linux/mm.h~mm-convert-vmemmap_pd_populate-to-static-functions
+++ a/include/linux/mm.h
@@ -4860,13 +4860,6 @@ unsigned long section_map_size(void);
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

mm-cma_sysfs-skip-inactive-cma-areas-in-sysfs.patch
mm-memory-failure-use-zone_pcp_disable-for-poison-handling.patch

