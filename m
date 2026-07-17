Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7523BB4A
	for <mm-commits@vger.kernel.org>; Fri, 17 Jul 2026 00:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784246593; cv=none; b=CbrrzgT4qBMewZIjhjE70oFHFcpCPVGB+84HOYQ/2LkDwN8oKRJOlGrzCjwtMWI19YiNtoC+XpLtiNZHrarVhAduXiAMLqI9wyp6Bzig21aMMwVkzam8pt8aJJaJlSC8ah/G7IVJUgasAfPgq85E2wBtSCWioAJPh717RHgtUlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784246593; c=relaxed/simple;
	bh=RMfXC+mh9JxD3oMM/YGhDqypa25KaG+OlL95Y0O32+M=;
	h=Date:To:From:Subject:Message-Id; b=JGT1Wfi8aadBxqvfC/Eq6FSW1psf+PTfMaUf9BNSKBOTUm/fReLFw0lXftdfxzJfJHvDiUzLvOJJTT20bFRJxfrXI9EhWESGXrbLbRj9TZx44dar14O50Fq/geUh/R9RXp0/aZi1+B3Qi6KRiABAK/QwXG9NIknjYaHEw3mCTlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=urNJCGim; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="urNJCGim"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 427DE1F000E9;
	Fri, 17 Jul 2026 00:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784246591;
	bh=pcrQJfHiJYMt53ABc5gwvJN+RCUJYRXi7YqrRoBXl/Y=;
	h=Date:To:From:Subject;
	b=urNJCGimtdWjkSUphTnu6icElhd6nq6dIVVo+JEfUukN11BVIfpsy8SptE/qxZQ6j
	 EGfCKEoJUOPqpBn8GcHnEiHUWBzciV0TNw6g9mZCjSIg1gEEkpD8UR1j5Q+ps+FcGW
	 VZ5ps4gzDsi564xeHIdmTvg7AqWLe7o4g53JcSJQ=
Date: Thu, 16 Jul 2026 17:03:10 -0700
To: mm-commits@vger.kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-remove-bootmem_info-leftovers.patch added to mm-unstable branch
Message-Id: <20260717000311.427DE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb_vmemmap: remove bootmem_info leftovers
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_vmemmap-remove-bootmem_info-leftovers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-remove-bootmem_info-leftovers.patch

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
Subject: mm/hugetlb_vmemmap: remove bootmem_info leftovers
Date: Thu, 16 Jul 2026 16:51:07 +0200

We never set CONFIG_HAVE_BOOTMEM_INFO_NODE, so we can just switch to
free_reserved_page() and drop the register_page_bootmem_memmap() call.

Link: https://lore.kernel.org/20260716-bootmem_info_part2-v2-8-4afc76c73d61@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
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
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-remove-bootmem_info-leftovers
+++ a/mm/hugetlb_vmemmap.c
@@ -12,7 +12,6 @@
 
 #include <linux/pgtable.h>
 #include <linux/moduleparam.h>
-#include <linux/bootmem_info.h>
 #include <linux/mmdebug.h>
 #include <linux/pagewalk.h>
 #include <linux/pgalloc.h>
@@ -177,13 +176,13 @@ static int vmemmap_remap_range(unsigned
  * Free a vmemmap page. A vmemmap page can be allocated from the memblock
  * allocator or buddy allocator. If the PG_reserved flag is set, it means
  * that it allocated from the memblock allocator, just free it via the
- * free_bootmem_page(). Otherwise, use __free_page().
+ * free_reserved_page(). Otherwise, use __free_page().
  */
 static inline void free_vmemmap_page(struct page *page)
 {
 	if (PageReserved(page)) {
 		memmap_boot_pages_add(-1);
-		free_bootmem_page(page);
+		free_reserved_page(page);
 	} else {
 		memmap_pages_add(-1);
 		__free_page(page);
@@ -641,9 +640,6 @@ static void __hugetlb_vmemmap_optimize_f
 			epfn = spfn + hugetlb_vmemmap_size(h);
 			vmemmap_wrprotect_hvo(spfn, epfn, folio_nid(folio),
 					HUGETLB_VMEMMAP_RESERVE_SIZE);
-			register_page_bootmem_memmap(pfn_to_section_nr(folio_pfn(folio)),
-					&folio->page,
-					HUGETLB_VMEMMAP_RESERVE_PAGES);
 			continue;
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

