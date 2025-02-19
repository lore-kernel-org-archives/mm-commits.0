Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3A238B
	for <mm-commits@vger.kernel.org>; Wed, 19 Feb 2025 00:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739923457; cv=none; b=CVeTkTixux9DDXVyvsLPSKEFZ1uvyzH5icSUWDzyh0hUf10RaM+DWtqT/EGrcamoyUs3JbBQ90ZIl+70SEcLsdaC6lgWejoWAXnwkFOGsz+xy2Dznb+pYfwcBZ1V6ePWchqWaz54JzTn0C/DCjkTxwIXhDVLeXeGQjijYtU4dFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739923457; c=relaxed/simple;
	bh=fB7rsUHIeZhMrvfB3xmT2SGeFw85HDF9TJmg0penUgg=;
	h=Date:To:From:Subject:Message-Id; b=NIJakxDe95NAawJN8We3qb1v+SLK1qcRqF9rtjSjR5cacxaGwT+ViVSXbzdFRIBVSkD25oiHQ8vnd0FU23Jsssrb8fEbJBO0E0Bc1Dt0JuOCGXYiQjpTkjiKbbSslIY1/pxE6LCqgdE3YJ73NxWvpPM0F5IkyHSVKKn2ug2+R9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jFwnU35v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jFwnU35v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F2F8C4CEE2;
	Wed, 19 Feb 2025 00:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739923457;
	bh=fB7rsUHIeZhMrvfB3xmT2SGeFw85HDF9TJmg0penUgg=;
	h=Date:To:From:Subject:From;
	b=jFwnU35vT5e9EnaD0EbRHh+l0xXl6ceJR7aI84lOc/XGlqFUG4/dO4NzSFjDCG4Lx
	 fZKnyAShQrKBcx9XA1mIrFhjuw5tcRr8m8LqmxVaPR7fyN8nrXw5HEwXe84S1d9AMm
	 EbT3KtGkern/0ECSxW2yGzGhpBDoc21ged5OpRr8=
Date: Tue, 18 Feb 2025 16:04:16 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,usamaarif642@gmail.com,roman.gushchin@linux.dev,peterz@infradead.org,osalvador@suse.de,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,gor@linux.ibm.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-bootmem_info-export-register_page_bootmem_memmap.patch added to mm-unstable branch
Message-Id: <20250219000417.3F2F8C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/bootmem_info: export register_page_bootmem_memmap
has been added to the -mm mm-unstable branch.  Its filename is
     mm-bootmem_info-export-register_page_bootmem_memmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-bootmem_info-export-register_page_bootmem_memmap.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Frank van der Linden <fvdl@google.com>
Subject: mm/bootmem_info: export register_page_bootmem_memmap
Date: Tue, 18 Feb 2025 18:16:37 +0000

If other mm code wants to use this function for early memmap inialization
(on the platforms that have it), it should be made available properly, not
just unconditionally in mm.h

Make this function available for such cases.

Link: https://lkml.kernel.org/r/20250218181656.207178-10-fvdl@google.com
Signed-off-by: Frank van der Linden <fvdl@google.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/init_64.c    |    4 ++++
 include/linux/bootmem_info.h |    7 +++++++
 include/linux/mm.h           |    3 ---
 3 files changed, 11 insertions(+), 3 deletions(-)

--- a/arch/powerpc/mm/init_64.c~mm-bootmem_info-export-register_page_bootmem_memmap
+++ a/arch/powerpc/mm/init_64.c
@@ -41,6 +41,7 @@
 #include <linux/libfdt.h>
 #include <linux/memremap.h>
 #include <linux/memory.h>
+#include <linux/bootmem_info.h>
 
 #include <asm/pgalloc.h>
 #include <asm/page.h>
@@ -386,10 +387,13 @@ void __ref vmemmap_free(unsigned long st
 }
 
 #endif
+
+#ifdef CONFIG_HAVE_BOOTMEM_INFO_NODE
 void register_page_bootmem_memmap(unsigned long section_nr,
 				  struct page *start_page, unsigned long size)
 {
 }
+#endif /* CONFIG_HAVE_BOOTMEM_INFO_NODE */
 
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
--- a/include/linux/bootmem_info.h~mm-bootmem_info-export-register_page_bootmem_memmap
+++ a/include/linux/bootmem_info.h
@@ -18,6 +18,8 @@ enum bootmem_type {
 
 #ifdef CONFIG_HAVE_BOOTMEM_INFO_NODE
 void __init register_page_bootmem_info_node(struct pglist_data *pgdat);
+void register_page_bootmem_memmap(unsigned long section_nr, struct page *map,
+				  unsigned long nr_pages);
 
 void get_page_bootmem(unsigned long info, struct page *page,
 		enum bootmem_type type);
@@ -58,6 +60,11 @@ static inline void register_page_bootmem
 {
 }
 
+static inline void register_page_bootmem_memmap(unsigned long section_nr,
+		struct page *map, unsigned long nr_pages)
+{
+}
+
 static inline void put_page_bootmem(struct page *page)
 {
 }
--- a/include/linux/mm.h~mm-bootmem_info-export-register_page_bootmem_memmap
+++ a/include/linux/mm.h
@@ -3998,9 +3998,6 @@ static inline bool vmemmap_can_optimize(
 }
 #endif
 
-void register_page_bootmem_memmap(unsigned long section_nr, struct page *map,
-				  unsigned long nr_pages);
-
 enum mf_flags {
 	MF_COUNT_INCREASED = 1 << 0,
 	MF_ACTION_REQUIRED = 1 << 1,
_

Patches currently in -mm which might be from fvdl@google.com are

mm-cma-export-total-and-free-number-of-pages-for-cma-areas.patch
mm-cma-support-multiple-contiguous-ranges-if-requested.patch
mm-cma-introduce-cma_intersects-function.patch
mm-hugetlb-use-cma_declare_contiguous_multi.patch
mm-hugetlb-remove-redundant-__clearpagereserved.patch
mm-hugetlb-use-online-nodes-for-bootmem-allocation.patch
mm-hugetlb-convert-cmdline-parameters-from-setup-to-early.patch
x86-mm-make-register_page_bootmem_memmap-handle-pte-mappings.patch
mm-bootmem_info-export-register_page_bootmem_memmap.patch
mm-sparse-allow-for-alternate-vmemmap-section-init-at-boot.patch
mm-hugetlb-set-migratetype-for-bootmem-folios.patch
mm-define-__init_reserved_page_zone-function.patch
mm-hugetlb-check-bootmem-pages-for-zone-intersections.patch
mm-sparse-add-vmemmap__hvo-functions.patch
mm-hugetlb-deal-with-multiple-calls-to-hugetlb_bootmem_alloc.patch
mm-hugetlb-move-huge_boot_pages-list-init-to-hugetlb_bootmem_alloc.patch
mm-hugetlb-add-pre-hvo-framework.patch
mm-hugetlb_vmemmap-fix-hugetlb_vmemmap_restore_folios-definition.patch
mm-hugetlb-do-pre-hvo-for-bootmem-allocated-pages.patch
x86-setup-call-hugetlb_bootmem_alloc-early.patch
x86-mm-set-arch_want_sparsemem_vmemmap_preinit.patch
mm-cma-simplify-zone-intersection-check.patch
mm-cma-introduce-a-cma-validate-function.patch
mm-cma-introduce-interface-for-early-reservations.patch
mm-hugetlb-add-hugetlb_cma_only-cmdline-option.patch
mm-hugetlb-enable-bootmem-allocation-from-cma-areas.patch
mm-hugetlb-move-hugetlb-cma-code-in-to-its-own-file.patch

