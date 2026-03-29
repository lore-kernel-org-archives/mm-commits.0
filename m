Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D010A21B905
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744810; cv=none; b=N9Mqr5X4ChIDf7578B8Ou4i2u23UfNn54JhL4Lrjx25sB46MTjCS2zsvtRUEEg5DtRLn3eN9n3hgDS8n1/ALWvOs/le+GcQyCKpxhua4E4U6RKxFHvoCW4v5lDAtN1FEVUcSiGG0gPu7D+HT8u3NeqQhyFjPA2BpyKp954q98ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744810; c=relaxed/simple;
	bh=Kh6jdRsy4rwPgmcRLX8O9OKATm2JkEZpyh4tCDPadfY=;
	h=Date:To:From:Subject:Message-Id; b=txX7+gZwHqiwjHuFljwIB3DAu840oAHGu8J7wYlznrYVz3nDQakcO3Uts+cm2ViUEDCo5C3p90RDY3saPUK0IqMnEO9Xep7GinuEKfNob6KORcEsYbA2std8bbNTzJaa7r+jlMgBjYIw4mGy7wLJqIfvbvwaNuQ1VA5srceVnfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZNfbulCJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZNfbulCJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A94FDC4CEF7;
	Sun, 29 Mar 2026 00:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744810;
	bh=Kh6jdRsy4rwPgmcRLX8O9OKATm2JkEZpyh4tCDPadfY=;
	h=Date:To:From:Subject:From;
	b=ZNfbulCJM/wX0Iabv9DhM/G2+PpGdZfqO2iiMyKCpC8Q7G/5GT7Y2A0DTNn8CpInA
	 XYVkNn2mV1cMmrDeVSoUPx3PAbsza7g2r5c0f6WIJ/nBj+dM/dQE5j1aHa/iKtLV4z
	 oSmoLZC3cw2zRTNM172T61CX4lWJQOVwmjBG4uKw=
Date: Sat, 28 Mar 2026 17:40:10 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,willy@infradead.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,kevin.brodsky@arm.com,david@kernel.org,davem@davemloft.net,andreas@gaisler.com,chengkaitao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sparc-use-vmemmap_populate_hugepages-for-vmemmap_populate.patch removed from -mm tree
Message-Id: <20260329004010.A94FDC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sparc: use vmemmap_populate_hugepages for vmemmap_populate
has been removed from the -mm tree.  Its filename was
     sparc-use-vmemmap_populate_hugepages-for-vmemmap_populate.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chengkaitao <chengkaitao@kylinos.cn>
Subject: sparc: use vmemmap_populate_hugepages for vmemmap_populate
Date: Sun, 1 Feb 2026 14:35:31 +0800

Change sparc's implementation of vmemmap_populate() using
vmemmap_populate_hugepages() to streamline the code.  Another benefit is
that it allows us to eliminate the external declarations of
vmemmap_p?d_populate functions and convert them to static functions.

Since vmemmap_populate_hugepages may fallback to vmemmap_populate-
_basepages, which differs from sparc's original implementation.  During
the v1 discussion with Mike Rapoport, sparc uses base pages in the kernel
page tables, so it should be able to use them in vmemmap as well. 
Consequently, no additional special handling is required.

1. In the SPARC architecture, reimplement vmemmap_populate using
   vmemmap_populate_hugepages.

2. Allow the SPARC arch to fallback to vmemmap_populate_basepages(),
   when vmemmap_alloc_block returns NULL.

Link: https://lkml.kernel.org/r/20260201063532.44807-2-pilgrimtao@gmail.com
Signed-off-by: Chengkaitao <chengkaitao@kylinos.cn>
Tested-by: Andreas Larsson <andreas@gaisler.com>
Acked-by: Andreas Larsson <andreas@gaisler.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/mm/init_64.c |   53 +++++++++++++-------------------------
 1 file changed, 19 insertions(+), 34 deletions(-)

--- a/arch/sparc/mm/init_64.c~sparc-use-vmemmap_populate_hugepages-for-vmemmap_populate
+++ a/arch/sparc/mm/init_64.c
@@ -2562,8 +2562,8 @@ unsigned long _PAGE_CACHE __read_mostly;
 EXPORT_SYMBOL(_PAGE_CACHE);
 
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
-int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
-			       int node, struct vmem_altmap *altmap)
+void __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
+			       unsigned long addr, unsigned long next)
 {
 	unsigned long pte_base;
 
@@ -2576,39 +2576,24 @@ int __meminit vmemmap_populate(unsigned
 
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
+	return vmemmap_populate_hugepages(vstart, vend, node, NULL);
 }
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
_

Patches currently in -mm which might be from chengkaitao@kylinos.cn are


