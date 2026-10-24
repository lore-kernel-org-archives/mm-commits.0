Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832521;
	b=b4Zjzv3b5PXUHknWyUICqJr3Vp87Gm/Oj6oDS7fqCsojE8AJsnoL1s9ftoZ+tnSWxuT2
	 qySeDMYNgfdkzNBzm/6fhdLmDMXbCBUcBfuijmjSnsslR9IJEzM+/sIFah8OBS18aBDSU
	 Xj6F1KkZC2lo2qys8pueHux+ifkexw9YtFG23475Ck9a//XR+VGG9w6POL9ylIU4Xryyf
	 iUNDWb63+yHBVM6WZu3LUCDIDtdvzjoZ12gnll/+8sxXfzOdWJx6Fq8s5g0LvubC32NcS
	 DWzbpB4qRdAgAhFW96goMiLWUtxeD+pbuAq2OCAxA5UGlVl7AqkwfioqtYzXT+DcY+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832521;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=TN2uy+A4kAAQYQkyx+8Y2O+WMrbKg/GYy9TQvFAAmD0=;
	b=jjzNGeLmGjaZHQLhgE5WlK8HelE+RwlHBBrTvJ7q2a0xznYb7nkzTO/c3ObecYGmDAVk
	 9ztNzD+CRJvbQdtOtYT1lYDXR4bO9169hOf7drCP+IX3vsBEqwaqN5GpA6tNBfer2fx87
	 cGy0A9+aOp5ufWD1mJ7WkljFtHJRzoib2r7O7/iZTb9f7vaL//JrEhUBsbuo5bvP3RiBj
	 f22zPj6MdKPSHQ/KJmFi3UmsubHm/oKGoEdR1EfLNPtbdC0HA0dC0Oy/K2TZ1m08j5vWO
	 PxeZPQvdnarTj5VZudaTPutEgWENSBgpN6pquXQNuHYFuucXDuLbFZbF0aewpio8l/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=zQPomKlx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0682B606A31B
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 09:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=zQPomKlx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C87F61F01825;
	Sat, 24 Oct 2026 09:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832520;
	bh=TN2uy+A4kAAQYQkyx+8Y2O+WMrbKg/GYy9TQvFAAmD0=;
	h=Date:To:From:Subject;
	b=zQPomKlxqGQmjMeqNEDS3t4gqHfsGTq8Kuk8pXj+G2VN6plefv0PxnRx7vH49pPKu
	 riQyTFbD/zuk2xyPyyB8uURrcENLoUL+h9sX4aQqNoJl/QhfWNoV3suR6QLTaIQF4V
	 0AqArHbZmuHJg5L9PNoU6k+mLO+ycLrScg4rpiPQ=
Date: Sat, 24 Oct 2026 02:02:00 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sshegde@linux.ibm.com,rppt@kernel.org,ritesh.list@gmail.com,qi.zheng@linux.dev,npiggin@gmail.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,david@kernel.org,chleroy@kernel.org,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-vmemmap-remove-the-unused-ptpfn-argument.patch removed from -mm tree
Message-Id: <20261024090200.C87F61F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/sparse-vmemmap: remove the unused ptpfn argument
has been removed from the -mm tree.  Its filename was
     mm-sparse-vmemmap-remove-the-unused-ptpfn-argument.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <muchun.song@linux.dev>
Subject: mm/sparse-vmemmap: remove the unused ptpfn argument
Date: Sat, 10 Oct 2026 15:57:53 +0800

vmemmap_pte_populate() no longer uses ptpfn as an input.  Drop the
argument to simplify the code.

Link: https://lore.kernel.org/20261010075755.83339-5-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <chleroy@kernel.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Shrikanth Hegde <sshegde@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
---

 mm/sparse-vmemmap.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/mm/sparse-vmemmap.c~mm-sparse-vmemmap-remove-the-unused-ptpfn-argument
+++ a/mm/sparse-vmemmap.c
@@ -282,7 +282,7 @@ static __meminit void *vmemmap_alloc_pte
 }
 
 static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
-		struct vmem_altmap *altmap, unsigned long ptpfn)
+		struct vmem_altmap *altmap)
 {
 	pte_t *pte = pte_offset_kernel(pmd, addr);
 	unsigned long pfn = page_to_pfn((struct page *)addr);
@@ -353,8 +353,7 @@ static pgd_t * __meminit vmemmap_pgd_pop
 }
 
 static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
-					      struct vmem_altmap *altmap,
-					      unsigned long ptpfn)
+						  struct vmem_altmap *altmap)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -374,7 +373,7 @@ static pte_t * __meminit vmemmap_populat
 	pmd = vmemmap_pmd_populate(pud, addr, node);
 	if (!pmd)
 		return NULL;
-	pte = vmemmap_pte_populate(pmd, addr, node, altmap, ptpfn);
+	pte = vmemmap_pte_populate(pmd, addr, node, altmap);
 	if (!pte)
 		return NULL;
 	vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
@@ -384,15 +383,13 @@ static pte_t * __meminit vmemmap_populat
 
 static int __meminit vmemmap_populate_range(unsigned long start,
 					    unsigned long end, int node,
-					    struct vmem_altmap *altmap,
-					    unsigned long ptpfn)
+					    struct vmem_altmap *altmap)
 {
 	unsigned long addr = start;
 	pte_t *pte;
 
 	for (; addr < end; addr += PAGE_SIZE) {
-		pte = vmemmap_populate_address(addr, node, altmap,
-					       ptpfn);
+		pte = vmemmap_populate_address(addr, node, altmap);
 		if (!pte)
 			return -ENOMEM;
 	}
@@ -403,7 +400,7 @@ static int __meminit vmemmap_populate_ra
 int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
 					 int node, struct vmem_altmap *altmap)
 {
-	return vmemmap_populate_range(start, end, node, altmap, -1);
+	return vmemmap_populate_range(start, end, node, altmap);
 }
 
 /*
_

Patches currently in -mm which might be from muchun.song@linux.dev are

mm-fix-missing-page-table-destructor-in-pagetable_free.patch
arm64-mm-fix-destructor-for-unconstructed-hotplug-page-tables.patch

