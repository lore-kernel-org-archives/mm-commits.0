Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832518;
	b=DmJDwJ7t1JhILdH3d0xLH4MD4P96QZhl3/1+qpgL2rqRKFY6/EA0hBrzC7bpMnvpLPFn
	 17Mg+gkZFkBpdfILQwgIkFr1zZBNUO9wCAFSYt97ZuNBE0b9pSXf2c/67NmxcTkq5yW0P
	 cELXj6e8ivAQi7e2Af0X5CGMDloVe4ydszrclP+qUxFcnWWXSct0hwy8NVKlzi/+jn+Ni
	 HnRfD2bdu8hadq5uQgvGOFfwhP4IQmy22uHjwcPHPI9MI28H1lXpXZ2QRDu5Rsgfs58Qq
	 CXGg4tqlVzg69GUFd5QIO36v2SM5ffQnBzt6vJ+ZboeybxQFusCwrQF0nuQjqLTj4yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832518;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=87OhphG2UA0/Abnk5L1ucwtX/f56N29q5gKruW3QA+w=;
	b=4I3eT1wcrA1aBVABfFkmPNKuEwRQdy57kpon0blNcTIPmi48YAYzl96+5q7HvVJQ8qur
	 MvHP06+IqG107viNEyT8THsdeYVHjLp1LABL+VEq1nieyMPHwy3JM6KR+fPZpXFFCD2HA
	 r047Em0LHm/66eDUNd+UC+jQbqZ7rin+kh6sD9yqXBNZTgoPITwGhPu2NoZrBvPKCMbVs
	 IN7TebWGumLECLMSIPq2TrygvrDHzoS/EyOxKoaxw/UYNGjwf+WAoF6ITv4UJdAsdwlbv
	 5g6INjeXCC5ZRyMe49A0ZQUls0ktZhRJgFEdO5RJs4Rl8MiUNCkMQzT45/xSCqJGXcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=VMaeDH0Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D39C606A321
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 09:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=VMaeDH0Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE56D1F01825;
	Sat, 24 Oct 2026 09:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832518;
	bh=87OhphG2UA0/Abnk5L1ucwtX/f56N29q5gKruW3QA+w=;
	h=Date:To:From:Subject;
	b=VMaeDH0ZQoixHTGCyloZJ3Q6bA3Sryo50vcToDTYO3lPabzHftua58VI3GsSXKRjJ
	 zBAafawErGRzydigA/GegLLWFVKdtlHztVkPKIb5ffux/OiOdF2i4WDp0OGwaGvel5
	 JnC2dqUj5/Jwl3cvVhNABthrV1eA+6HOFPESq1/Q=
Date: Sat, 24 Oct 2026 02:01:57 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sshegde@linux.ibm.com,rppt@kernel.org,ritesh.list@gmail.com,qi.zheng@linux.dev,npiggin@gmail.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,david@kernel.org,chleroy@kernel.org,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-vmemmap-support-device-dax-in-common-vmemmap-path.patch removed from -mm tree
Message-Id: <20261024090157.EE56D1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/sparse-vmemmap: support device DAX in common vmemmap path
has been removed from the -mm tree.  Its filename was
     mm-sparse-vmemmap-support-device-dax-in-common-vmemmap-path.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <muchun.song@linux.dev>
Subject: mm/sparse-vmemmap: support device DAX in common vmemmap path
Date: Sat, 10 Oct 2026 15:57:51 +0800

The common vmemmap population path cannot yet handle optimized Device DAX
mappings on its own.  It uses pfn_to_zone() to find the shared tail page,
but Device DAX populates its vmemmap at runtime before the ZONE_DEVICE
span is initialized.

Teach the common path to use device_zone() for runtime optimized vmemmap
population while retaining pfn_to_zone() for early boot.  This allows the
same path to support both early boot mappings and Device DAX.

The backing PFN supplied by the Device DAX-specific population path is no
longer used, allowing the redundant lookup and population code to be
removed later.

Link: https://lore.kernel.org/20261010075755.83339-3-songmuchun@bytedance.com
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

 mm/sparse-vmemmap.c |   62 +++++++++++++++++++++++-------------------
 1 file changed, 34 insertions(+), 28 deletions(-)

--- a/mm/sparse-vmemmap.c~mm-sparse-vmemmap-support-device-dax-in-common-vmemmap-path
+++ a/mm/sparse-vmemmap.c
@@ -241,18 +241,43 @@ static __meminit void *vmemmap_alloc_pte
 	struct page *page;
 	const unsigned int order = pfn_to_section_compound_order(pfn);
 
-	/*
-	 * Device DAX still relies on vmemmap_populate_compound_pages() for
-	 * head/first-tail allocation and tail-page reuse.
-	 */
 	if (!vmemmap_optimizable_pfn(pfn))
 		return vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
 
-	zone = pfn_to_zone(pfn, node);
+	/*
+	 * Before slab is available, vmemmap optimization is used for early
+	 * system RAM, whose zone can be determined from the PFN.
+	 *
+	 * Once slab is available, only ZONE_DEVICE memory reaches this
+	 * optimized population path. Its zone span has not been initialized
+	 * while its vmemmap is being populated, so pfn_to_zone() cannot be
+	 * used. Obtain ZONE_DEVICE directly from the node instead.
+	 */
+	zone = slab_is_available() ? device_zone(node) : pfn_to_zone(pfn, node);
 	page = vmemmap_shared_tail_page(order, zone);
 	if (!page)
 		return NULL;
 
+	/*
+	 * During early vmemmap population, the shared tail vmemmap backing
+	 * page is allocated from memblock before its struct page can safely
+	 * participate in page refcounting. Therefore, no reference can be
+	 * held for each shared PTE mapping, and the mappings must be unshared
+	 * before the vmemmap is depopulated.
+	 *
+	 * Once slab is available, the shared backing page is allocated from
+	 * the buddy allocator and can be refcounted. Hold one reference for
+	 * each shared PTE mapping. The architecture vmemmap teardown drops
+	 * the reference through __free_pages() when removing the mapping,
+	 * preventing the backing page from being freed while it is shared.
+	 *
+	 * The backing page may be shared by enough PTE mappings to exhaust
+	 * the positive range of its reference count. Stop populating the
+	 * vmemmap if another reference cannot be acquired.
+	 */
+	if (slab_is_available() && !try_get_page(page))
+		return NULL;
+
 	return page_address(page);
 }
 
@@ -264,31 +289,12 @@ static pte_t * __meminit vmemmap_pte_pop
 
 	if (pte_none(ptep_get(pte))) {
 		pte_t entry;
+		void *p = vmemmap_alloc_pte(pfn, node, altmap);
 
-		if (ptpfn == (unsigned long)-1) {
-			void *p = vmemmap_alloc_pte(pfn, node, altmap);
+		if (!p)
+			return NULL;
 
-			if (!p)
-				return NULL;
-			ptpfn = PHYS_PFN(__pa(p));
-		} else {
-			/*
-			 * When a PTE/PMD entry is freed from the init_mm
-			 * there's a free_pages() call to this page allocated
-			 * above. Thus this try_get_page() is paired with the
-			 * put_page_testzero() on the freeing path.
-			 * This can only called by certain ZONE_DEVICE path,
-			 * and through vmemmap_populate_compound_pages() when
-			 * slab is available.
-			 *
-			 * Use try_get_page() to prevent the shared page refcount
-			 * from overflowing.
-			 */
-			if (slab_is_available() &&
-			    !try_get_page(pfn_to_page(ptpfn)))
-				return NULL;
-		}
-		entry = pfn_pte(ptpfn, PAGE_KERNEL);
+		entry = pfn_pte(PHYS_PFN(__pa(p)), PAGE_KERNEL);
 		set_pte_at(&init_mm, addr, pte, entry);
 	} else if (WARN_ON_ONCE(vmemmap_optimizable_pfn(pfn)))
 		return NULL;
_

Patches currently in -mm which might be from muchun.song@linux.dev are

mm-fix-missing-page-table-destructor-in-pagetable_free.patch
arm64-mm-fix-destructor-for-unconstructed-hotplug-page-tables.patch

