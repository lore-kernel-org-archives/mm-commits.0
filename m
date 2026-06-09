Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120E02F7EEE
	for <mm-commits@vger.kernel.org>; Tue,  9 Jun 2026 01:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780968166; cv=none; b=UmlCg0EfXYz0KngMFOumdPCUsITusX2lW6NEsVMli4HljQwFIxme1NLSOdeoywdDSQHMI2Gi9qh5l41U0vNpG0ZAizTmwVIUrcXK0F0hYiDzFPFiftmoH4hxH1xaNzX6Qy9xyqQpqPXxY3r0zf+aGYIlU9kdoSGcUi4DQ8oXPY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780968166; c=relaxed/simple;
	bh=ct4XZpgbE6CSdTcj+ftZVPymM7MtizPIjYktWAjfGjE=;
	h=Date:To:From:Subject:Message-Id; b=iFaGGPREeQtY9hOlWWhhSii667X26eRgMQ/j7gSi/PwCgBZrsyLz0QVuJ/PQW4TCsnf4rTbvlUeJG43e19ASF21gZtSPw29Jbz7MPaNv56KUmDTD+npyN4eO0fsM+lxTe/iDg3C4XzC2SiE9XJzLPosvQ0xCUwZdKxx5qWygpvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x9/lHsNh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x9/lHsNh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C45231F00893;
	Tue,  9 Jun 2026 01:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780968164;
	bh=fVsW6w4BSv0nVUCmWJ91HvBbaWMnwUSRGuz3IDqI22Q=;
	h=Date:To:From:Subject;
	b=x9/lHsNh1jmrksWF+nkci3i4hNoPsldsOGKjijTdpI5jjypVDL2t80Q7IjRgrBF5F
	 ZIR3wQ5bhs8ui3ssPefBnhjYXz+rm4zJLOpCr4JCPruscZGxVHpJsb7bx7RfKPdqnJ
	 DtyVmxTs4yh63oEVGJBuF9H1VHW+yU2I/im7TqTM=
Date: Mon, 08 Jun 2026 18:22:44 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,palmer@dabbelt.com,osalvador@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kernel@xen0n.name,david@kernel.org,davem@davemloft.net,chenhuacai@kernel.org,catalin.marinas@arm.com,aou@eecs.berkeley.edu,andreas@gaisler.com,alex@ghiti.fr,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-mm-drop-vmemmap_pmd-helpers-and-use-generic-code.patch removed from -mm tree
Message-Id: <20260609012244.C45231F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64/mm: drop vmemmap_pmd helpers and use generic code
has been removed from the -mm tree.  Its filename was
     arm64-mm-drop-vmemmap_pmd-helpers-and-use-generic-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: arm64/mm: drop vmemmap_pmd helpers and use generic code
Date: Mon, 1 Jun 2026 16:48:41 +0800

The generic implementations now suffice; remove the arm64 copies.

Link: https://lore.kernel.org/20260601084845.3792171-3-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Will Deacon <will@kernel.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/mmu.c |   14 --------------
 1 file changed, 14 deletions(-)

--- a/arch/arm64/mm/mmu.c~arm64-mm-drop-vmemmap_pmd-helpers-and-use-generic-code
+++ a/arch/arm64/mm/mmu.c
@@ -1775,20 +1775,6 @@ static void free_empty_tables(unsigned l
 }
 #endif
 
-void __meminit vmemmap_set_pmd(pmd_t *pmdp, void *p, int node,
-			       unsigned long addr, unsigned long next)
-{
-	pmd_set_huge(pmdp, __pa(p), __pgprot(PROT_SECT_NORMAL));
-}
-
-int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
-				unsigned long addr, unsigned long next)
-{
-	vmemmap_verify((pte_t *)pmdp, node, addr, next);
-
-	return pmd_leaf(READ_ONCE(*pmdp));
-}
-
 int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
 		struct vmem_altmap *altmap)
 {
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


