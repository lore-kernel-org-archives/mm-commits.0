Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2308729B0
	for <mm-commits@vger.kernel.org>; Wed, 19 Feb 2025 00:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739923483; cv=none; b=QHj23IgBD5oSgqRYHtbQBt7k6580Bekvp3wW+BtJS5NOs1g41oo6wVecPLinsKNRRXSnqU/9SOZJV/M4rfFkDUhaEINyFUhhmyb7fev5mr1q6eiCZVohWhXpuORjRa59KghFjvmoPMq6zixskXUGeGRWI5E2a95iBzqUwE+8OG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739923483; c=relaxed/simple;
	bh=OAxgjPK+6gEJkRkpp7eGHrgUOhhRHhoFklWNi6PA8Pc=;
	h=Date:To:From:Subject:Message-Id; b=jdFs/XH888YwbTnfBBiJ7Lyx6gCsz+OnANTm2ZvI1lCjboKbXF1qWPcM/P6DxWjDG3rZbvvohakLFC7Uxmb4WF0AjB4KPzPK52h/4VYf5uNs5uQ1xNjyGwmRbrU3NbWf9kV3Do2GVzbg3Nz3FEa1ZhlDRu0C2bEfNgGB4McU2XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CrT5tXll; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CrT5tXll"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA56BC4CEE2;
	Wed, 19 Feb 2025 00:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739923483;
	bh=OAxgjPK+6gEJkRkpp7eGHrgUOhhRHhoFklWNi6PA8Pc=;
	h=Date:To:From:Subject:From;
	b=CrT5tXllrCZyZ65nPWMH602BeAApWn8oMJPUxnRmh82b40Db4hn1uvR1Lo4FtYsQ1
	 CzL8kRz4pAHzI39zJ35NRV2imtnZvHWnM4KXT4Cgt7QrFhlKOgZcQuvoIBrPboJtXj
	 zvzpNto4rHV0cmU1uzbEUvNdvxaPDAno+mOeCWYQ=
Date: Tue, 18 Feb 2025 16:04:42 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,usamaarif642@gmail.com,roman.gushchin@linux.dev,peterz@infradead.org,osalvador@suse.de,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,gor@linux.ibm.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-fix-hugetlb_vmemmap_restore_folios-definition.patch added to mm-unstable branch
Message-Id: <20250219000442.EA56BC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb_vmemmap: fix hugetlb_vmemmap_restore_folios definition
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_vmemmap-fix-hugetlb_vmemmap_restore_folios-definition.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-fix-hugetlb_vmemmap_restore_folios-definition.patch

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
Subject: mm/hugetlb_vmemmap: fix hugetlb_vmemmap_restore_folios definition
Date: Tue, 18 Feb 2025 18:16:46 +0000

Make the hugetlb_vmemmap_restore_folios definition inline for the
!CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP case, so that including this file in
files other than hugetlb_vmemmap.c will work.

Link: https://lkml.kernel.org/r/20250218181656.207178-19-fvdl@google.com
Fixes: cfb8c75099db ("hugetlb: perform vmemmap restoration on a list of pages")
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

 mm/hugetlb_vmemmap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb_vmemmap.h~mm-hugetlb_vmemmap-fix-hugetlb_vmemmap_restore_folios-definition
+++ a/mm/hugetlb_vmemmap.h
@@ -50,7 +50,7 @@ static inline int hugetlb_vmemmap_restor
 	return 0;
 }
 
-static long hugetlb_vmemmap_restore_folios(const struct hstate *h,
+static inline long hugetlb_vmemmap_restore_folios(const struct hstate *h,
 					struct list_head *folio_list,
 					struct list_head *non_hvo_folios)
 {
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

