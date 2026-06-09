Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3703D2D0602
	for <mm-commits@vger.kernel.org>; Tue,  9 Jun 2026 01:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780968171; cv=none; b=S44x4Abo9rXCbS2AhpbuCGoRvLOWvMPDWcJrmTS+SU1c6+6k7Tu2S4tH2BCtPZ5zWqopVUzPGC3YPAu+0TDIkF3sZpUJJ1SqRSZVSPdK9mMphI2u9Fa2kK+D+up11b3lY3jRVhHEgaQpS03Br45oSM6oyyT5tfmaAWTypXUgyfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780968171; c=relaxed/simple;
	bh=4wRHITNsvGD953tzor6Q+/16cdIo7+o2KIU6FojiFWE=;
	h=Date:To:From:Subject:Message-Id; b=W33twQ82aviYMKDaAJ46S90C445yiMpSCUyJC1Mm7nF6iupBlem02YykPOTCo0hcO441trkgxOI866jePJljXnLftF2jygAypEwWncFIg7ystRDohIH6XZS4x8zZ4ISNUCD3F1ikRT/RHY2MjHwtTf4D+9n+/JXmu7UUbIQRDKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=alQVm9u4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="alQVm9u4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90D401F00893;
	Tue,  9 Jun 2026 01:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780968169;
	bh=iDT30x+kKxlqFtIC98h5A+K0b3ujEWWMIzpdzboMVFw=;
	h=Date:To:From:Subject;
	b=alQVm9u4+j5I1I5avhqw15OF0yqqaPoFhBYBeseFOBncfHDZIYFYTypU+MHZFXQDR
	 0+HVc7ynYEr9Zv+IMVMOjhh9kIeruZ6PcY/YPBZlSJqIIl9op3pX8CwiJ2ASD4nS9P
	 cJxKbfP+Gpq0gFVrandSM01nSULnBo7kqNmOopjY=
Date: Mon, 08 Jun 2026 18:22:49 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,palmer@dabbelt.com,osalvador@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kernel@xen0n.name,david@kernel.org,davem@davemloft.net,chenhuacai@kernel.org,catalin.marinas@arm.com,aou@eecs.berkeley.edu,andreas@gaisler.com,alex@ghiti.fr,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sparc-mm-drop-vmemmap_check_pmd-helper-and-use-generic-code.patch removed from -mm tree
Message-Id: <20260609012249.90D401F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sparc/mm: drop vmemmap_check_pmd helper and use generic code
has been removed from the -mm tree.  Its filename was
     sparc-mm-drop-vmemmap_check_pmd-helper-and-use-generic-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: sparc/mm: drop vmemmap_check_pmd helper and use generic code
Date: Mon, 1 Jun 2026 16:48:44 +0800

The generic implementations now suffice; remove the sparc copy.

Link: https://lore.kernel.org/20260601084845.3792171-6-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
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
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/mm/init_64.c |   11 -----------
 1 file changed, 11 deletions(-)

--- a/arch/sparc/mm/init_64.c~sparc-mm-drop-vmemmap_check_pmd-helper-and-use-generic-code
+++ a/arch/sparc/mm/init_64.c
@@ -2559,17 +2559,6 @@ void __meminit vmemmap_set_pmd(pmd_t *pm
 	pmd_val(*pmd) = pte_base | __pa(p);
 }
 
-int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
-				unsigned long addr, unsigned long next)
-{
-	int large = pmd_leaf(*pmdp);
-
-	if (large)
-		vmemmap_verify((pte_t *)pmdp, node, addr, next);
-
-	return large;
-}
-
 int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
 			       int node, struct vmem_altmap *altmap)
 {
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


