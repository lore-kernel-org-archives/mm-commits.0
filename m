Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7254A2D0602
	for <mm-commits@vger.kernel.org>; Tue,  9 Jun 2026 01:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780968169; cv=none; b=nNJYUyClQOVZaJRQI693peaccbKzPr9uHl7BxDsAA3prCT/ttP+f4Zs17KNkEHNeago7DLJoVHKg0LseuiEfUAdFa6OzNIzPaAOyRVicT18WC2WdCHot1i2+sWvAUOK6Sk01bD409+psCUIfg4XixZdG92Ojv5qcfucCSA5/U20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780968169; c=relaxed/simple;
	bh=dbAz2JO3QWxDkTb+LU+KCIFOUwYYoXjnQRN5kuMpFyo=;
	h=Date:To:From:Subject:Message-Id; b=gL9I0mbFjXD8cwy2sMtkUyVfuYJevrQMb2qLhmpnEmRvwWiA+eBjHs9cYkQgJ5DSAqSdgQTZ15quClNaZGee/LjB6lXvpZM34JpTCLCRGHpcNJLGraZZbyl+6uTOnTJB8xaVdUqJOJ7fUCuHtnUbxyusqtaMO8FPD6lrslqFEbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mgrXfGgz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mgrXfGgz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AF831F00893;
	Tue,  9 Jun 2026 01:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780968167;
	bh=poRMF+ESOAJ7haa3Upc/7gCkQuqpWmPcN7S7kOZNvFc=;
	h=Date:To:From:Subject;
	b=mgrXfGgz+vIuM64qi6OkbkgiTnzO3rDQqAgvVpUsLSYhs229hNDB1ASQV4zgXBWht
	 HHlaGjCoBurUSjY/hbxFrtd6cGGs+Q0M+gAr0lGirkfxNSYoQxDHHzTqlTTlvAwRci
	 Pi9VjCOoQJBCbl+9aA0J+LgB6fzsKwg9mN7gVRko=
Date: Mon, 08 Jun 2026 18:22:46 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,palmer@dabbelt.com,osalvador@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kernel@xen0n.name,david@kernel.org,davem@davemloft.net,chenhuacai@kernel.org,catalin.marinas@arm.com,aou@eecs.berkeley.edu,andreas@gaisler.com,alex@ghiti.fr,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] riscv-mm-drop-vmemmap_pmd-helpers-and-use-generic-code.patch removed from -mm tree
Message-Id: <20260609012247.1AF831F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: riscv/mm: drop vmemmap_pmd helpers and use generic code
has been removed from the -mm tree.  Its filename was
     riscv-mm-drop-vmemmap_pmd-helpers-and-use-generic-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: riscv/mm: drop vmemmap_pmd helpers and use generic code
Date: Mon, 1 Jun 2026 16:48:42 +0800

The generic implementations now suffice; remove the riscv copies.

Link: https://lore.kernel.org/20260601084845.3792171-4-songmuchun@bytedance.com
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

 arch/riscv/mm/init.c |   13 -------------
 1 file changed, 13 deletions(-)

--- a/arch/riscv/mm/init.c~riscv-mm-drop-vmemmap_pmd-helpers-and-use-generic-code
+++ a/arch/riscv/mm/init.c
@@ -1359,19 +1359,6 @@ void __init misc_mem_init(void)
 }
 
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
-void __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
-			       unsigned long addr, unsigned long next)
-{
-	pmd_set_huge(pmd, virt_to_phys(p), PAGE_KERNEL);
-}
-
-int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
-				unsigned long addr, unsigned long next)
-{
-	vmemmap_verify((pte_t *)pmdp, node, addr, next);
-	return 1;
-}
-
 int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
 			       struct vmem_altmap *altmap)
 {
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


