Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78EF27816C
	for <mm-commits@vger.kernel.org>; Mon, 26 Jan 2026 19:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769454631; cv=none; b=mpSEPblPXZIOFonKVcALxC10xj7D9xPcyNe6njRgPG8vybE/k5GtVZCmpDbtuK2UXq0GJI0dmb5UFc8W1qPo5z2ADniNabyAW/y1u2Q12ZHepXVFdT//ue3eQuYAx+sfqxkn1/INbMDTIwi/o8kKdAHmYnd5QTaj0qzSGUmyt3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769454631; c=relaxed/simple;
	bh=PD6vt9/GXaOt9aZBqkDFHevWg3Itpd7Pkr+de6jGC0I=;
	h=Date:To:From:Subject:Message-Id; b=cXk5PQyWT9s57V3GhJnbvt9PYmNLMnk85tiM4RwaTJqC3o24zhyWLqnxvV/jfxolQ8jyaDC20oYm4ePIHTh3XgoVSVVvbNZJ+GY//N1WtuNeUldhNgA++ganYrjB/wLtsnypU6MfWyiMgoub1ZjbebJTEcVPOhPtcRVj/X6LFiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VgEWb08z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VgEWb08z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7882FC19422;
	Mon, 26 Jan 2026 19:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769454630;
	bh=PD6vt9/GXaOt9aZBqkDFHevWg3Itpd7Pkr+de6jGC0I=;
	h=Date:To:From:Subject:From;
	b=VgEWb08zYXaTow04UCNdQGEzJI2iCRkZvAfphfTxAB3ROzBKiQRt6b83Cx1M4ACWv
	 NpRQ2sqOgWAz3hdE6k4lNQAS1qaBXJB18qm1SNJn8G0X/jVXPKOyFnZrG8UdDIthw2
	 nDtVwpNiofglbHPht8JnY4SgeuCiGUD12UZwT318=
Date: Mon, 26 Jan 2026 11:10:29 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,willy@infradead.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kevin.brodsky@arm.com,david@kernel.org,davem@davemloft.net,andreas@gaisler.com,agordeev@linux.ibm.com,chengkaitao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] sparc-use-vmemmap_populate_hugepages-for-vmemmap_populate.patch removed from -mm tree
Message-Id: <20260126191030.7882FC19422@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sparc: use vmemmap_populate_hugepages for vmemmap_populate
has been removed from the -mm tree.  Its filename was
     sparc-use-vmemmap_populate_hugepages-for-vmemmap_populate.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Chengkaitao <chengkaitao@kylinos.cn>
Subject: sparc: use vmemmap_populate_hugepages for vmemmap_populate
Date: Sun, 11 Jan 2026 15:44:52 +0800

Patch series "Generalize vmemmap_populate_hugepages to sparc", v5.

Change sparc's implementation of vmemmap_populate() using
vmemmap_populate_hugepages() to streamline the code.  Another benefit is
that it allows us to eliminate the external declarations of
vmemmap_p?d_populate functions and convert them to static functions.

Since vmemmap_populate_hugepages may fallback to vmemmap_populate-
_basepages, which differs from sparc's original implementation.  During
the v1 discussion with Mike Rapoport, sparc uses base pages in the kernel
page tables, so it should be able to use them in vmemmap as well. 
Consequently, no additional special handling is required.

Remove unnecessary whitespace from sparc.


This patch (of 2):

1. In the SPARC architecture, reimplemented vmemmap_populate using
   vmemmap_populate_hugepages.

2. Allow the SPARC arch to fallback to vmemmap_populate_basepages(),
   when vmemmap_alloc_block returns NULL.

Link: https://lkml.kernel.org/r/20260111074453.66728-1-pilgrimtao@gmail.com
Link: https://lkml.kernel.org/r/20260111074453.66728-2-pilgrimtao@gmail.com
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
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/mm/init_64.c |   53 +++++++++++++-------------------------
 1 file changed, 19 insertions(+), 34 deletions(-)

--- a/arch/sparc/mm/init_64.c~sparc-use-vmemmap_populate_hugepages-for-vmemmap_populate
+++ a/arch/sparc/mm/init_64.c
@@ -2574,8 +2574,8 @@ unsigned long _PAGE_CACHE __read_mostly;
 EXPORT_SYMBOL(_PAGE_CACHE);
 
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
-int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
-			       int node, struct vmem_altmap *altmap)
+void __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
+			       unsigned long addr, unsigned long next)
 {
 	unsigned long pte_base;
 
@@ -2588,39 +2588,24 @@ int __meminit vmemmap_populate(unsigned
 
 	pte_base |= _PAGE_PMD_HUGE;
 
-	vstart = vstart & PMD_MASK;
-	vend = ALIGN(vend, PMD_SIZE);
-	for (; vstart < vend; vstart += PMD_SIZE) {
-		pgd_t *pgd = vmemmap_pgd_populate(vstart, node);
-		unsigned long pte;
-		p4d_t *p4d;
-		pud_t *pud;
-		pmd_t *pmd;
-
-		if (!pgd)
-			return -ENOMEM;
-
-		p4d = vmemmap_p4d_populate(pgd, vstart, node);
-		if (!p4d)
-			return -ENOMEM;
-
-		pud = vmemmap_pud_populate(p4d, vstart, node);
-		if (!pud)
-			return -ENOMEM;
-
-		pmd = pmd_offset(pud, vstart);
-		pte = pmd_val(*pmd);
-		if (!(pte & _PAGE_VALID)) {
-			void *block = vmemmap_alloc_block(PMD_SIZE, node);
-
-			if (!block)
-				return -ENOMEM;
-
-			pmd_val(*pmd) = pte_base | __pa(block);
-		}
-	}
+	pmd_val(*pmd) = pte_base | __pa(p);
+}
+
+int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
+				unsigned long addr, unsigned long next)
+{
+	int large = pmd_leaf(*pmdp);
+
+	if (large)
+		vmemmap_verify((pte_t *)pmdp, node, addr, next);
 
-	return 0;
+	return large;
+}
+
+int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
+			       int node, struct vmem_altmap *altmap)
+{
+	return vmemmap_populate_hugepages(vstart, vend, node, altmap);
 }
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
_

Patches currently in -mm which might be from chengkaitao@kylinos.cn are

mm-convert-vmemmap_pd_populate-to-static-functions.patch

