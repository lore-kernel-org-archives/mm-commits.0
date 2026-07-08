Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5C83F4DC3
	for <mm-commits@vger.kernel.org>; Wed,  8 Jul 2026 21:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783545935; cv=none; b=Lkba7sP6M4zS6rQU5Zhhcd1zQA3k+5yw4n6uTkWuSb5xjcAFypWBGdArnwRsi9hOfTQP7ov1CGWKUjyQH10cvBVzPMJsVpAUsEItMxT9VLnJEmoUQcnrJysssjaS8vpBORrH4cfB2DGI4ywWoh8Ky9QADhJ4OnelhnP+/AJxRpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783545935; c=relaxed/simple;
	bh=W1qC5s0d9IEzcKicn2+m9b0wp5Ot057aup/+s8x0UJU=;
	h=Date:To:From:Subject:Message-Id; b=imc1rVCe1u1OAQE6AwXBulpZWXTnQh+IwXPL4I3EcVSWU31ikxIb0yg5vTxqcIQqm/gbJHHc0O8ztQmlbvwc/jJoJluuXP8KEJ9WoCyZ+x5k/4QmS2iO07qHW91YtRj+dCkzNsdiE/hk3lo8dBGQVds8/u4Imf72jZPfqCfdUjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A/Gl/c2R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A/Gl/c2R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B36E1F00A3A;
	Wed,  8 Jul 2026 21:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783545934;
	bh=QHuIg42blFZMz7qppg+2VrNGYc6UJSB+HCJNCznq6rg=;
	h=Date:To:From:Subject;
	b=A/Gl/c2RgL6uO7Rd0xT+noPEPPcvks0l5tdEPVqJQowld6Jew1IPAHpGF8Br08xF1
	 QtjUlIeEQWrewS9bFlj5GPDjv6OgF9FU3HgZivCZJ3EjH8jVlwpGRD8h40mGTbSEYk
	 MtZh++UuC73QEd1GfPliNkhXERtUr2Pl5mUV/0g4=
Date: Wed, 08 Jul 2026 14:25:33 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,svens@linux.ibm.com,surenb@google.com,rppt@kernel.org,peterz@infradead.org,osalvador@suse.de,muchun.song@linux.dev,mingo@redhat.com,mhocko@suse.com,luto@kernel.org,ljs@kernel.org,liam@infradead.org,jackmanb@google.com,hpa@zytor.com,hca@linux.ibm.com,hannes@cmpxchg.org,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,bp@alien8.de,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-mm-stop-marking-page-tables-as-mix_section_info.patch added to mm-new branch
Message-Id: <20260708212534.5B36E1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/mm: stop marking page tables as MIX_SECTION_INFO
has been added to the -mm mm-new branch.  Its filename is
     x86-mm-stop-marking-page-tables-as-mix_section_info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-mm-stop-marking-page-tables-as-mix_section_info.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Cc: Mike Rapoport <rppt@kernel.org>
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
x86-mm-drop-order-parameter-from-free_pagetable.patch
mm-provide-free_reserved_pages-removing-x86-variant.patch
s390-mm-use-free_reserved_pages-in-vmem_free_pages.patch
mm-bootmem_info-allow-calling-free_bootmem_page-on-pages-without-a-bootmem_type.patch
x86-mm-stop-marking-vmemmap-as-section_info.patch
x86-mm-stop-marking-page-tables-as-mix_section_info.patch
x86-mm-remove-config_have_bootmem_info_node.patch
mm-hugetlb_vmemmap-remove-bootmem_info-leftovers.patch
mm-sparse-remove-bootmem_infoh-include.patch
mm-bootmem_info-remove-config_have_bootmem_info_node.patch

