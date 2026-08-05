Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170523BED27
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896657; cv=none; b=KePqiNfvnZn6vuJg2gHIrVe4FjYD/3joCJxJHtNFvsLgCm6npD2vcRK5AOzWw+coix/VGqTAU2ZuEPhQZqURhGg7tZq0cgQip7OCKtpyeCijPkGLuY3/tXrjOFlJDc6lIbKKBMYVi6wl5m096fcXzFeHh33evo1uFaftdENHwBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896657; c=relaxed/simple;
	bh=sLbENbiTAwQSXMck0GlggTXQSit7+tWKxtUVC6lV048=;
	h=Date:To:From:Subject:Message-Id; b=EdbQ1W5vURrELJeO9fhJMAfDPSGMotmjQ75ATw4EV3BN+q9hLfkIxyNgK8JSs7amqhXuvBeaCPNHc5sxPP1etdvYDAUcvOtAL4lIclO2h491umY91uVWo8RAVDVjouPb8+DO306V+db9/2msS7/ZWgNjL9bZGeIgQAecumXjKQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tG4uizPq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tG4uizPq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D10B71F000E9;
	Wed,  5 Aug 2026 02:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896656;
	bh=QuDSBBohmYvtlMu+Bqb6dkW0OMywo2OfUapXiwkYJ2s=;
	h=Date:To:From:Subject;
	b=tG4uizPqouACHmG8Des3nsc9ZY+H6qCuibhRsleIszD/b6LLmm35K9zekUQlPsnui
	 iuubtJwewfEXXHOgkFI7WGYnP3ZXOwWyeNgBX89MxwEJPVKv5f3am6khuZ49TiN5az
	 y9foGNf572/PHyiZVHBHKnUAdQAnqbh3j2rTgi6A=
Date: Tue, 04 Aug 2026 19:24:15 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,svens@linux.ibm.com,surenb@google.com,rppt@kernel.org,peterz@infradead.org,osalvador@suse.de,muchun.song@linux.dev,mingo@redhat.com,mhocko@suse.com,luto@kernel.org,ljs@kernel.org,liam@infradead.org,jackmanb@google.com,hpa@zytor.com,hca@linux.ibm.com,hannes@cmpxchg.org,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,dave.hansen@linux.intel.com,brendan.jackman@linux.dev,bp@alien8.de,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-mm-stop-marking-page-tables-as-mix_section_info.patch removed from -mm tree
Message-Id: <20260805022415.D10B71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/mm: stop marking page tables as MIX_SECTION_INFO
has been removed from the -mm tree.  Its filename was
     x86-mm-stop-marking-page-tables-as-mix_section_info.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: x86/mm: stop marking page tables as MIX_SECTION_INFO
Date: Thu, 16 Jul 2026 16:51:05 +0200

There is no good reason to mark boot page tables as MIX_SECTION_INFO: we
only free boot page tables when they are completely empty, and memory
offlining/hotunplug doesn't benefit from it in any way.

So just stop marking page tables as MIX_SECTION_INFO.  In
free_pagetable(), we can now simply free reserved pages directly.

Link: https://lore.kernel.org/20260716-bootmem_info_part2-v2-6-4afc76c73d61@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |   59 +---------------------------------------
 1 file changed, 2 insertions(+), 57 deletions(-)

--- a/arch/x86/mm/init_64.c~x86-mm-stop-marking-page-tables-as-mix_section_info
+++ a/arch/x86/mm/init_64.c
@@ -1002,21 +1002,10 @@ int arch_add_memory(int nid, u64 start,
 
 static void __meminit free_pagetable(struct page *page)
 {
-	/* bootmem page has reserved flag */
-	if (PageReserved(page)) {
-#ifdef CONFIG_HAVE_BOOTMEM_INFO_NODE
-		enum bootmem_type type = bootmem_type(page);
-
-		if (type == MIX_SECTION_INFO)
-			put_page_bootmem(page);
-		else
-			free_reserved_page(page);
-#else
+	if (PageReserved(page))
 		free_reserved_page(page);
-#endif
-	} else {
+	else
 		pagetable_free(page_ptdesc(page));
-	}
 }
 
 static void __meminit free_vmemmap_pages(struct page *page, unsigned int order,
@@ -1579,50 +1568,6 @@ int __meminit vmemmap_populate(unsigned
 void register_page_bootmem_memmap(unsigned long section_nr,
 				  struct page *start_page, unsigned long nr_pages)
 {
-	unsigned long addr = (unsigned long)start_page;
-	unsigned long end = (unsigned long)(start_page + nr_pages);
-	unsigned long next;
-	pgd_t *pgd;
-	p4d_t *p4d;
-	pud_t *pud;
-	pmd_t *pmd;
-
-	for (; addr < end; addr = next) {
-		pgd = pgd_offset_k(addr);
-		if (pgd_none(*pgd)) {
-			next = (addr + PAGE_SIZE) & PAGE_MASK;
-			continue;
-		}
-		get_page_bootmem(section_nr, pgd_page(*pgd), MIX_SECTION_INFO);
-
-		p4d = p4d_offset(pgd, addr);
-		if (p4d_none(*p4d)) {
-			next = (addr + PAGE_SIZE) & PAGE_MASK;
-			continue;
-		}
-		get_page_bootmem(section_nr, p4d_page(*p4d), MIX_SECTION_INFO);
-
-		pud = pud_offset(p4d, addr);
-		if (pud_none(*pud)) {
-			next = (addr + PAGE_SIZE) & PAGE_MASK;
-			continue;
-		}
-		get_page_bootmem(section_nr, pud_page(*pud), MIX_SECTION_INFO);
-
-		pmd = pmd_offset(pud, addr);
-		if (pmd_none(*pmd)) {
-			next = (addr + PAGE_SIZE) & PAGE_MASK;
-			continue;
-		}
-
-		if (!boot_cpu_has(X86_FEATURE_PSE) || !pmd_leaf(*pmd)) {
-			next = (addr + PAGE_SIZE) & PAGE_MASK;
-			get_page_bootmem(section_nr, pmd_page(*pmd),
-					 MIX_SECTION_INFO);
-		} else {
-			next = pmd_addr_end(addr, end);
-		}
-	}
 }
 #endif
 
_

Patches currently in -mm which might be from david@kernel.org are

mm-standardize-printing-for-pgtable-entries.patch
mm-gup-fix-always-draining-lru-caches-in-collect_longterm_unpinnable_folios.patch

