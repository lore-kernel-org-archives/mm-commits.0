Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F93BA45
	for <mm-commits@vger.kernel.org>; Fri, 17 Jul 2026 00:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784246586; cv=none; b=HSK1gzX8UPVog2DlebBn7yRjBobPSLacAexFL8oMVJJeTrSMm01HIevRzOsWSbZt82tDQuWXgqZ/AXWrNE8EDzESLjDkFxcV1b359UnF+D+2EFfF8tl2zyUtTrugCSQWG2lLps/pYCT19a5t4a9rzSuF/rFyAsc6aaw1scfoGsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784246586; c=relaxed/simple;
	bh=u9ZQqauPltR8VEQVajqkSFURj1OJAgmgzQp6EWeFCyg=;
	h=Date:To:From:Subject:Message-Id; b=aMTn0liO16trhaauBEjEhgHQmX6EhZGIXAdjUiPaWXlYhllC3jaVmH2QFvJ42Pe68cIML1toKMvErAJQ1CY3RUZjXK/vp/bBOZZP0DLZ2k4uf/sgpp7P7fqwQ20UCgrTtvZwS70D6EaPPiUQ43zvt2YBaraJJec2iC/HDDd3kiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HuPEfyZr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HuPEfyZr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4964E1F000E9;
	Fri, 17 Jul 2026 00:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784246584;
	bh=XQ5i91G9NTlNIltbzoz9dE0vPaqc0CpzEAoF9Z4dsX4=;
	h=Date:To:From:Subject;
	b=HuPEfyZrrtQ5CpsMydpWOQqtGIk+oCdM4hVVM01gdRNodfMxGcx+MGuhwtmYS6/48
	 jHJYZXqy56dN1bUvlPv2tB7P7a4FsobJTmVDayBW+PC1tjK794H+mPRBzVCCsJ/vsP
	 W+QKTZNveGB3rqB5c+Ofj9ki7jt+etqW0Ho8bcvU=
Date: Thu, 16 Jul 2026 17:03:03 -0700
To: mm-commits@vger.kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-mm-stop-marking-vmemmap-as-section_info.patch added to mm-unstable branch
Message-Id: <20260717000304.4964E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/mm: stop marking vmemmap as SECTION_INFO
has been added to the -mm mm-unstable branch.  Its filename is
     x86-mm-stop-marking-vmemmap-as-section_info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-mm-stop-marking-vmemmap-as-section_info.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: x86/mm: stop marking vmemmap as SECTION_INFO
Date: Thu, 16 Jul 2026 16:51:04 +0200

We added the whole bootmem registration machinery in commit 04753278769f
("memory hotplug: register section/node id to free").

The main use case was to remember to which memory section memmap pages
belonged, so the memmap could be handled accordingly when freeing memory.

However, all that machinery is not required anymore: a memory section can
only get offlined if *all* pages can get offlined; and it can only get
unplugged once offline.  If some of these pages are unmovable memmap
pages: bad luck, doesn't work.  Offlining will fail.

Further, a lot of this machinery was required for pre-vmemmap support. 
Now we only support the vmemmap with memory hotplug.

So the whole machinery is useless today.  Let's start by removing the last
pieces by first stopping to mark vmemmap pages as SECTION_INFO.  In
free_vmemmap_pages(), we can now always just free the reserved pages
directly.

Link: https://lore.kernel.org/20260716-bootmem_info_part2-v2-5-4afc76c73d61@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
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

 arch/x86/mm/init_64.c |   30 ++++--------------------------
 1 file changed, 4 insertions(+), 26 deletions(-)

--- a/arch/x86/mm/init_64.c~x86-mm-stop-marking-vmemmap-as-section_info
+++ a/arch/x86/mm/init_64.c
@@ -1024,19 +1024,12 @@ static void __meminit free_vmemmap_pages
 {
 	unsigned long nr_pages = 1u << order;
 
-	if (altmap) {
+	if (altmap)
 		vmem_altmap_free(altmap, nr_pages);
-	} else if (PageReserved(page)) {
-		if (IS_ENABLED(CONFIG_HAVE_BOOTMEM_INFO_NODE) &&
-		    bootmem_type(page) == SECTION_INFO) {
-			while (nr_pages--)
-				put_page_bootmem(page++);
-		} else {
-			free_reserved_pages(page, order);
-		}
-	} else {
+	else if (PageReserved(page))
+		free_reserved_pages(page, order);
+	else
 		__free_pages(page, order);
-	}
 }
 
 static void __meminit free_pte_table(pte_t *pte_start, pmd_t *pmd)
@@ -1593,12 +1586,8 @@ void register_page_bootmem_memmap(unsign
 	p4d_t *p4d;
 	pud_t *pud;
 	pmd_t *pmd;
-	unsigned int nr_pmd_pages;
-	struct page *page;
 
 	for (; addr < end; addr = next) {
-		pte_t *pte = NULL;
-
 		pgd = pgd_offset_k(addr);
 		if (pgd_none(*pgd)) {
 			next = (addr + PAGE_SIZE) & PAGE_MASK;
@@ -1630,19 +1619,8 @@ void register_page_bootmem_memmap(unsign
 			next = (addr + PAGE_SIZE) & PAGE_MASK;
 			get_page_bootmem(section_nr, pmd_page(*pmd),
 					 MIX_SECTION_INFO);
-
-			pte = pte_offset_kernel(pmd, addr);
-			if (pte_none(*pte))
-				continue;
-			get_page_bootmem(section_nr, pte_page(*pte),
-					 SECTION_INFO);
 		} else {
 			next = pmd_addr_end(addr, end);
-			nr_pmd_pages = (next - addr) >> PAGE_SHIFT;
-			page = pmd_page(*pmd);
-			while (nr_pmd_pages--)
-				get_page_bootmem(section_nr, page++,
-						 SECTION_INFO);
 		}
 	}
 }
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
mm-standardize-printing-for-pgtable-entries.patch

