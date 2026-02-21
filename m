Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0D38834
	for <mm-commits@vger.kernel.org>; Sat, 21 Feb 2026 00:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771633981; cv=none; b=IKwIXYXdkBkyTzEPHgEJyoRw+mEQ0bIJ4ct96eN0l5HMHKiIvX3q2undLlgiI4aGYCW3lOncA6OQvte7hytFpla5Yz78WXPj46p6NFkbIn4JOZsjfelWjADC3+Yo3xx+joYaLh/fWNbOW57CBGvHolz4UFchVYRnB5C5ODOvl4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771633981; c=relaxed/simple;
	bh=3yldN8DyAqAELyRgay2udaPd3JosrtBKFeGGsT/8gNw=;
	h=Date:To:From:Subject:Message-Id; b=smaQeDj61Bsby++Pd55k83OE2Iu0oouPfnHbGj/jyEmpgFovpDU9ZIvprh2MgRUxB8/kvFezzExPit077Y4QYf2lLIQG9dpb886b+a91sUi0P4U94T1K2dxKsLBdGtwezaOT+iKHb5zPuJ++u4M7aE1Q/CBuV+WBg+8oWG2TJWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uvsq9E2k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uvsq9E2k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E26C116C6;
	Sat, 21 Feb 2026 00:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771633981;
	bh=3yldN8DyAqAELyRgay2udaPd3JosrtBKFeGGsT/8gNw=;
	h=Date:To:From:Subject:From;
	b=uvsq9E2kk6GUNw/LUZm3Mt0VQxig0QrZTBX9cZDpPK4YglWgk19C5fR8pDiNkWXNU
	 5UPuhTw2lGrCpleI2hUothD1qaXAaurL7qw7E5fZ1VLE/Z3QOrCe/3ZKmPR7RsK1U6
	 065FPv09CNlZ8UyBP8ITyWlZsz5DwNYxSNxZk3Bo=
Date: Fri, 20 Feb 2026 16:33:00 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,willy@infradead.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kevin.brodsky@arm.com,david@kernel.org,davem@davemloft.net,andreas@gaisler.com,chengkaitao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sparc-use-vmemmap_populate_hugepages-for-vmemmap_populate.patch added to mm-new branch
Message-Id: <20260221003301.30E26C116C6@smtp.kernel.org>
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

sparc-use-vmemmap_populate_hugepages-for-vmemmap_populate.patch
mm-convert-vmemmap_pd_populate-to-static-functions.patch

