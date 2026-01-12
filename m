Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A2E2853F7
	for <mm-commits@vger.kernel.org>; Mon, 12 Jan 2026 22:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768257151; cv=none; b=pAODh0Fv9Oxfyz328EPFbZUGhn3AFGRJapwHSifD+hJxXgMfbPNMKE4UF2uxOhkYKCrVTXkX1sj1jcnuV5qYIZYLjrsRkH9fbyXreXaDXjZ1hYLyIB7cELEod6dChNen2jSZEP3Q+RX/+KYnMZfcpP4ozrszyXBZa/Cbf9gm4jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768257151; c=relaxed/simple;
	bh=mT/duBTlQ3XgR+otK3Ettg5o5Re+RamcIo70nlJPg9I=;
	h=Date:To:From:Subject:Message-Id; b=m0G/7+hlgwfcdvPGGRsaC38oLeiT5UiyRuvsuyNmNnDIoeir4bsd52PB1iVJadcms0tnb7nCapQGNI9/YxzLuEdV9SC56iwvprHm6jgNnC9OFxVDhBbPpSUr1OnPy8fOaEP33fZ6t1VHlnwxtSSN5SWH5HfYVXHt6qQpLc6TVeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Abw+xGcZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Abw+xGcZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E44B3C19423;
	Mon, 12 Jan 2026 22:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768257151;
	bh=mT/duBTlQ3XgR+otK3Ettg5o5Re+RamcIo70nlJPg9I=;
	h=Date:To:From:Subject:From;
	b=Abw+xGcZxevOGCPaXhXfQp7m53o+uvjpsJsyf3fuW9jmXbT85/g0vedWKTZDYGK30
	 SC5yXUjTUBYHu3O56rfF4GcRG/jeCFG1EFx5pWejP0Y4fOAEQaiiJRa8pGuOEYJNcc
	 mIkkww5qjA2o09aeRK+adSDv5WwVO30qCP6zfsss=
Date: Mon, 12 Jan 2026 14:32:30 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,willy@infradead.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kevin.brodsky@arm.com,david@kernel.org,davem@davemloft.net,andreas@gaisler.com,agordeev@linux.ibm.com,chengkaitao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sparc-use-vmemmap_populate_hugepages-for-vmemmap_populate.patch added to mm-new branch
Message-Id: <20260112223230.E44B3C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sparc: use vmemmap_populate_hugepages for vmemmap_populate
has been added to the -mm mm-new branch.  Its filename is
     sparc-use-vmemmap_populate_hugepages-for-vmemmap_populate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sparc-use-vmemmap_populate_hugepages-for-vmemmap_populate.patch

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

sparc-use-vmemmap_populate_hugepages-for-vmemmap_populate.patch
mm-convert-vmemmap_pd_populate-to-static-functions.patch

