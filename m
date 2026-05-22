Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618CB26B742;
	Fri, 22 May 2026 00:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779410155; cv=none; b=tlQByydeCD2dwdBUpE8YTPI8S1XDsLB0UFjrcTjOHYp5cIYxKjVatDhFQUeGfXSSHh2D8DDs0O+wyFHB3CACZfqpG+wYNN3I5b6vPPcnKJrb/LoAmkFUTc9+DOoWlYG8ka82tVPElGc3j4xZSiRYbjjfC10Uh6e4x3aEhDCp29w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779410155; c=relaxed/simple;
	bh=KerMBDD7WYfWU1HwOOsGCdqCx8q7BMU7cgFhf7f72Wk=;
	h=Date:To:From:Subject:Message-Id; b=BVXGUV2XuEZlmyZArTLRYPqpGSUjtIzT3wRVkIg4D+ltzYbnbkgT0YSkjGXn1juZqD/QorrgP5CH4h1XSo1lDSlK+P8xWrndgDPpeayu9JFvtpJSzNB5Nn3T/DB5my8VEKwtsvEnStHjUBqQyRZ+28o1Q0OgKXrIODgz8IYN7r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DEH1rL0w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DEH1rL0w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D56D1F000E9;
	Fri, 22 May 2026 00:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779410154;
	bh=YZQCqjgDTSxlUlXkrXyZVmPyvun4eFc92QLq+IKpN4s=;
	h=Date:To:From:Subject;
	b=DEH1rL0wzSobvx/1up/h5GfQ1liGRzj6Y1XR2YGUOAGBFxZkIzdC/EQzC+8+yY6vf
	 TnA66E9u52EJu8LjFAmcK+19Sx2ukLPWKXwu1cztab3uFSlecBSA1Xu9LpoCeLtkPx
	 FYfWP+WRCc8aTexr5Y6h5eErrd84AjfQajjONSNI=
Date: Thu, 21 May 2026 17:35:53 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rppt@kernel.org,peterz@infradead.org,mingo@redhat.com,luto@kernel.org,lance.yang@linux.dev,jgg@ziepe.ca,hpa@zytor.com,dave.hansen@linux.intel.com,bp@alien8.de,baolu.lu@linux.intel.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-mm-fix-freeing-of-pmd-sized-vmemmap-pages.patch added to mm-hotfixes-unstable branch
Message-Id: <20260522003554.1D56D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/mm: fix freeing of PMD-sized vmemmap pages
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     x86-mm-fix-freeing-of-pmd-sized-vmemmap-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-mm-fix-freeing-of-pmd-sized-vmemmap-pages.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: x86/mm: fix freeing of PMD-sized vmemmap pages
Date: Wed, 29 Apr 2026 12:49:14 +0200

In commit bf9e4e30f353 ("x86/mm: use pagetable_free()"), we switched from
freeing non-boot page tables through __free_pages() to pagetable_free().

However, the function is also called to free vmemmap pages.

Given that vmemmap pages are not page tables, already the
page_ptdesc(page) is wrong.  But worse, pagetable_free() calls

	__free_pages(page, compound_order(page));

As vmemmap pages are not compound pages (see vmemmap_alloc_block()) --
except for HVO, which doesn't apply here -- we will only free the first
page when freeing a PMD-sized vmemmap page, leaking the other ones.

Fix it by properly decoupling pagetable and vmemmap freeing. 
free_pagetable() no longer has to mess with SECTION_INFO, as only the
vmemmap is marked like that in register_page_bootmem_memmap().

The indentation in remove_pmd_table() is messed up, let's fix that while
touching it.

Note that we'll try to get rid of that bootmem info handling soon.  For
now, we'll handle it similar to free_pagetable(), just avoiding the ifdef.

Link: https://lore.kernel.org/20260429-vmemmap-v2-1-8dfcacffd877@kernel.org
Fixes: bf9e4e30f353 ("x86/mm: use pagetable_free()")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Baolu Lu <baolu.lu@linux.intel.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |   40 ++++++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 14 deletions(-)

--- a/arch/x86/mm/init_64.c~x86-mm-fix-freeing-of-pmd-sized-vmemmap-pages
+++ a/arch/x86/mm/init_64.c
@@ -1014,7 +1014,7 @@ static void __meminit free_pagetable(str
 #ifdef CONFIG_HAVE_BOOTMEM_INFO_NODE
 		enum bootmem_type type = bootmem_type(page);
 
-		if (type == SECTION_INFO || type == MIX_SECTION_INFO) {
+		if (type == MIX_SECTION_INFO) {
 			while (nr_pages--)
 				put_page_bootmem(page++);
 		} else {
@@ -1028,13 +1028,24 @@ static void __meminit free_pagetable(str
 	}
 }
 
-static void __meminit free_hugepage_table(struct page *page,
+static void __meminit free_vmemmap_pages(struct page *page, unsigned int order,
 		struct vmem_altmap *altmap)
 {
-	if (altmap)
-		vmem_altmap_free(altmap, PMD_SIZE / PAGE_SIZE);
-	else
-		free_pagetable(page, get_order(PMD_SIZE));
+	unsigned long nr_pages = 1u << order;
+
+	if (altmap) {
+		vmem_altmap_free(altmap, nr_pages);
+	} else if (PageReserved(page)) {
+		if (IS_ENABLED(CONFIG_HAVE_BOOTMEM_INFO_NODE) &&
+		    bootmem_type(page) == SECTION_INFO) {
+			while (nr_pages--)
+				put_page_bootmem(page++);
+		} else {
+			free_reserved_pages(page, nr_pages);
+		}
+	} else {
+		__free_pages(page, order);
+	}
 }
 
 static void __meminit free_pte_table(pte_t *pte_start, pmd_t *pmd)
@@ -1118,7 +1129,8 @@ remove_pte_table(pte_t *pte_start, unsig
 			return;
 
 		if (!direct)
-			free_pagetable(pte_page(*pte), 0);
+			/* We never populate base pages from the altmap. */
+			free_vmemmap_pages(pte_page(*pte), 0, NULL);
 
 		spin_lock(&init_mm.page_table_lock);
 		pte_clear(&init_mm, addr, pte);
@@ -1153,19 +1165,19 @@ remove_pmd_table(pmd_t *pmd_start, unsig
 			if (IS_ALIGNED(addr, PMD_SIZE) &&
 			    IS_ALIGNED(next, PMD_SIZE)) {
 				if (!direct)
-					free_hugepage_table(pmd_page(*pmd),
-							    altmap);
+					free_vmemmap_pages(pmd_page(*pmd),
+							   PMD_ORDER, altmap);
 
 				spin_lock(&init_mm.page_table_lock);
 				pmd_clear(pmd);
 				spin_unlock(&init_mm.page_table_lock);
 				pages++;
 			} else if (vmemmap_pmd_is_unused(addr, next)) {
-					free_hugepage_table(pmd_page(*pmd),
-							    altmap);
-					spin_lock(&init_mm.page_table_lock);
-					pmd_clear(pmd);
-					spin_unlock(&init_mm.page_table_lock);
+				free_vmemmap_pages(pmd_page(*pmd), PMD_ORDER,
+						   altmap);
+				spin_lock(&init_mm.page_table_lock);
+				pmd_clear(pmd);
+				spin_unlock(&init_mm.page_table_lock);
 			}
 			continue;
 		}
_

Patches currently in -mm which might be from david@kernel.org are

x86-mm-fix-freeing-of-pmd-sized-vmemmap-pages.patch
sh-use-folio_mapped-instead-of-page_mapped-in-sh4_flush_cache_page.patch
bpf-arena-use-page_ref_count-instead-of-page_mapped-in-arena_free_pages.patch
mm-remove-page_mapped.patch
sparc-mm-remove-register_page_bootmem_info.patch
mm-bootmem_info-drop-initialization-of-page-lru.patch
mm-bootmem_info-stop-using-pg_private.patch
mm-bootmem_info-remove-call-to-kmemleak_free_part_phys.patch
mm-bootmem_info-stop-marking-the-pgdat-as-node_info.patch
mm-bootmem_info-stop-marking-mem_section_usage-as-mix_section_info.patch
s390-mm-use-free_reserved_page-in-vmem_free_pages.patch
powerpc-mm-remove-config_have_bootmem_info_node.patch

