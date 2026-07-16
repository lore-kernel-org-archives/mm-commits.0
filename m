Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9017F3D953C
	for <mm-commits@vger.kernel.org>; Thu, 16 Jul 2026 23:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784245593; cv=none; b=AU2Juf0Pm0U5z6K6UBftZw+UoO8HOoLeOwTy/IBRmjlqJOMs6swGYDSQ5gQvfgrMqvAvCVve3m6yqvtHGqs2cWf2dDKZW5NARrLV+U0cJXpsY66T617DkMjnQqHZarBin9xUVYipgg4clkhu0RY3+eLIN0ngP4Z1RRvjrlGRXaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784245593; c=relaxed/simple;
	bh=PwHaP5pZLtki73pa4SMHFcz6qa8N20hsX+hYWXZvrSU=;
	h=Date:To:From:Subject:Message-Id; b=nsHHSfU7Yv1GWqcS57HdOwk3+EHi/9ap0iqegO1h7VlZ9Iz3GqnGTrTYUJ/zL/bfZpUyD37sBNKI7PwSa7T8zDunSQOgUh6Qe/o5x4KNR0tPjEPqgWRL8VXkUhkqXD/vj7T5llvu28N9+VZKiVq3sI8XU5bGx69OnIvsrwTlrbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bZtZ0t6x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bZtZ0t6x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA291F00A3A;
	Thu, 16 Jul 2026 23:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784245591;
	bh=a0GkJd9M1v+8sQXZXI9vtp3ZeQYFHT3UZd4cUY5AjPc=;
	h=Date:To:From:Subject;
	b=bZtZ0t6xAHMO5E6zgLjxM2JuTf3iCXB1j1QrBVxX09UKA3hb6gCPw50s/SSjdsoyI
	 oUHzHcTYIh729V2BvEcb0fRJSlTXioC/YP4zDweiCa18Ihin0QqUCTpcoHv859OH7s
	 zqyD7k69b9fE1uKcKmw/jcT7/+MynYywa2rYcafQ=
Date: Thu, 16 Jul 2026 16:46:30 -0700
To: mm-commits@vger.kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] x86-mm-stop-marking-page-tables-as-mix_section_info.patch removed from -mm tree
Message-Id: <20260716234631.3BA291F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/mm: stop marking page tables as MIX_SECTION_INFO
has been removed from the -mm tree.  Its filename was
     x86-mm-stop-marking-page-tables-as-mix_section_info.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: x86/mm: stop marking page tables as MIX_SECTION_INFO
Date: Wed, 08 Jul 2026 16:11:01 +0200

There is no good reason to mark boot page tables as MIX_SECTION_INFO: we
only free boot page tables when they are completely empty, and memory
offlining/hotunplug doesn't benefit from it in any way.

So just stop marking page tables as MIX_SECTION_INFO.  In
free_pagetable(), we can now simply free reserved pages directly.

Link: https://lore.kernel.org/20260708-bootmem_info_part2-v1-6-156ce4986598@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Brendan Jackman <jackmanb@google.com>
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

sparc-mm-drop-custom-pte_clear_not_present_full.patch
mm-drop-pte_clear_not_present_full.patch
mm-cleanup-clear_not_present_full_ptes-and-rename-to-clear_non_present_ptes.patch
x86-mm-remove-config_have_bootmem_info_node.patch
mm-hugetlb_vmemmap-remove-bootmem_info-leftovers.patch
mm-sparse-remove-bootmem_infoh-include.patch
mm-bootmem_info-remove-config_have_bootmem_info_node.patch
mm-standardize-printing-for-pgtable-entries.patch

