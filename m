Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832522;
	b=dsDU8CIHu2hqBG/H1Zu/SZ8vPZTpxo/Bh77ygVz5OcSW75w6o2YA2ASupSPAGxQXL0Oe
	 QK0+sYB9R22O0d/M2PVCY/ybnUvjVy8sso1UeY3jCisXk/QHQb7KnU4hjVaoiWf8F3JxS
	 DRKVMKRjQmJXT4Ybb14KyqxXyKPra/iuY6zuSdITsVNjJ8ib7CoJF6gT6Iu11+LOoHpfc
	 jpMr4+T3QsL3uwoQC1S2ChWl2o9c3Ji46w/6KAQr2J5dEtulqFMNlKJH4hMisOOkYP5RP
	 4gumpna5wW3EkLnNYcHSsitM15gvs9CBJuw6rgbO/bWkjMK9fq3UbZ6ueCG8palTXSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832522;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=K3yq2/NdAqqa1JFxH+CAD/VDawzArFWCBhQTtNWfts8=;
	b=pBMAmEwc7GwKnc8qZdODs3QnGH1NH1ehf4UH8sTeQ0mTLQsqHDxWcmrkMcnoXQT4PZaO
	 oPwq7xh05sIdaAD2QdIPo/EZpdpipp/vaLfcN6URcIXnTA/e++Twu2eA1XYF9T5ZGdmff
	 6s/K9HAv3wA3SPLvvmrvV2pt2a/2hGMMWyCAp/aopORiJsAjEnnJ9knu2NLGzrdDFKFR0
	 NEzH5OCRMXS8pbg2n9X7eSK4Wxw2LVstXgUbbTfN7pTGRgYOgNG6HiuFxXUlXSWNRIgRY
	 6iJtatF3PE7tZxxSinqopj9lWqrLGdKdPYfvZ8ApRygaKYtU+PjIyD9om3YpAKEw3ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=l0pfw+UB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791CD606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 09:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=l0pfw+UB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 452C81F01825;
	Sat, 24 Oct 2026 09:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832522;
	bh=K3yq2/NdAqqa1JFxH+CAD/VDawzArFWCBhQTtNWfts8=;
	h=Date:To:From:Subject;
	b=l0pfw+UBRtJd3qlTgbu0zy/W6cj04HL2acg76ii2Z8uZ4vr5SnU53CClt4iOSl74/
	 1/pEz7D9PbfK6k3908dL1C0AE+BpuCwxSDC6dQLOwprEMBmMS3zwQctfpiROr1pcFP
	 IHGvXB1NdJMwo9Y/FDHnJzlSKLwW/Zic/f5UlEo4=
Date: Sat, 24 Oct 2026 02:02:01 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sshegde@linux.ibm.com,rppt@kernel.org,ritesh.list@gmail.com,qi.zheng@linux.dev,npiggin@gmail.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,david@kernel.org,chleroy@kernel.org,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-vmemmap-open-code-vmemmap_populate_address.patch removed from -mm tree
Message-Id: <20261024090202.452C81F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/sparse-vmemmap: open-code vmemmap_populate_address()
has been removed from the -mm tree.  Its filename was
     mm-sparse-vmemmap-open-code-vmemmap_populate_address.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <muchun.song@linux.dev>
Subject: mm/sparse-vmemmap: open-code vmemmap_populate_address()
Date: Sat, 10 Oct 2026 15:57:54 +0800

vmemmap_populate_address() no longer has any callers that need the
returned PTE.  Its only remaining user, vmemmap_populate_range(), only
checks whether population succeeded.

Open-code vmemmap_populate_address() directly in
vmemmap_populate_basepages(), remove the now-redundant range helper, and
return -ENOMEM directly on failure.

Link: https://lore.kernel.org/20261010075755.83339-6-songmuchun@bytedance.com
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

 mm/sparse-vmemmap.c |   54 +++++++++++++-----------------------------
 1 file changed, 17 insertions(+), 37 deletions(-)

--- a/mm/sparse-vmemmap.c~mm-sparse-vmemmap-open-code-vmemmap_populate_address
+++ a/mm/sparse-vmemmap.c
@@ -352,8 +352,8 @@ static pgd_t * __meminit vmemmap_pgd_pop
 	return pgd;
 }
 
-static pte_t * __meminit vmemmap_populate_address(unsigned long addr, int node,
-						  struct vmem_altmap *altmap)
+int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
+					 int node, struct vmem_altmap *altmap)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -361,48 +361,28 @@ static pte_t * __meminit vmemmap_populat
 	pmd_t *pmd;
 	pte_t *pte;
 
-	pgd = vmemmap_pgd_populate(addr, node);
-	if (!pgd)
-		return NULL;
-	p4d = vmemmap_p4d_populate(pgd, addr, node);
-	if (!p4d)
-		return NULL;
-	pud = vmemmap_pud_populate(p4d, addr, node);
-	if (!pud)
-		return NULL;
-	pmd = vmemmap_pmd_populate(pud, addr, node);
-	if (!pmd)
-		return NULL;
-	pte = vmemmap_pte_populate(pmd, addr, node, altmap);
-	if (!pte)
-		return NULL;
-	vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
-
-	return pte;
-}
-
-static int __meminit vmemmap_populate_range(unsigned long start,
-					    unsigned long end, int node,
-					    struct vmem_altmap *altmap)
-{
-	unsigned long addr = start;
-	pte_t *pte;
-
-	for (; addr < end; addr += PAGE_SIZE) {
-		pte = vmemmap_populate_address(addr, node, altmap);
+	for (unsigned long addr = start; addr < end; addr += PAGE_SIZE) {
+		pgd = vmemmap_pgd_populate(addr, node);
+		if (!pgd)
+			return -ENOMEM;
+		p4d = vmemmap_p4d_populate(pgd, addr, node);
+		if (!p4d)
+			return -ENOMEM;
+		pud = vmemmap_pud_populate(p4d, addr, node);
+		if (!pud)
+			return -ENOMEM;
+		pmd = vmemmap_pmd_populate(pud, addr, node);
+		if (!pmd)
+			return -ENOMEM;
+		pte = vmemmap_pte_populate(pmd, addr, node, altmap);
 		if (!pte)
 			return -ENOMEM;
+		vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
 	}
 
 	return 0;
 }
 
-int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
-					 int node, struct vmem_altmap *altmap)
-{
-	return vmemmap_populate_range(start, end, node, altmap);
-}
-
 /*
  * Write protect the mirrored tail page structs for HVO. This will be
  * called from the hugetlb code when gathering and initializing the
_

Patches currently in -mm which might be from muchun.song@linux.dev are

mm-fix-missing-page-table-destructor-in-pagetable_free.patch
arm64-mm-fix-destructor-for-unconstructed-hotplug-page-tables.patch

