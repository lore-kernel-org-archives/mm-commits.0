Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D5CE2417E2
	for <mm-commits@vger.kernel.org>; Thu,  6 Feb 2025 23:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738884011; cv=none; b=dhKzK8uhh4V1Hhb0gIXq4VTH5PoI/KtmLMKL9ehFq4ujQuxmBatDAkfh4B5A9EdylVElVVZY5CLMj2MV5LP5r9lsy/IPEAfey0MyeG2hq29wVNmSGOjd5jZ+qwekiepqo/bfe/J4GKCwjAFdfN1rYK8x3fU3qx8loqFSOAkTirs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738884011; c=relaxed/simple;
	bh=0e2SRCqE9CheJIQgkRMGALhtb61tvxwzBhLuQuC/yqE=;
	h=Date:To:From:Subject:Message-Id; b=pYLJQGA0lKHa+n3J4mNX5Zbq9YsugKZ1hgJvfySj+W21pSwrPhKySvBXsVh5m7oILP916fPyW4TFrPzzm77oxnrmyO/GyLBrK8HwN4wo7urmgiQmvfU21LHJfXd+Vyt2OzNMxW/9a7vJsk84iJoghnNQs0+qagjNHnFDeb6/OZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Mvp6sqIm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Mvp6sqIm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F41B3C4CEDD;
	Thu,  6 Feb 2025 23:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738884011;
	bh=0e2SRCqE9CheJIQgkRMGALhtb61tvxwzBhLuQuC/yqE=;
	h=Date:To:From:Subject:From;
	b=Mvp6sqImqzyvlrTdIWLANGLb0IG0gIbomBaFrO8cdSptSP8J5c97gPUcOpsvc62ni
	 kEGqFpnryY3oXO5sM5u8OUlqx0AoQNlKaM5Aaikzgad0tTyCD5Kxs1EbIdU5AvC6gv
	 LPw2jARs/M4+vnxt4613yI5ZjZw8VggeYgQpeARs=
Date: Thu, 06 Feb 2025 15:20:10 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yaozhenguo1@gmail.com,usamaarif642@gmail.com,roman.gushchin@linux.dev,peterz@infradead.org,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,gor@linux.ibm.com,dave.hansen@linux.intel.com,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-fix-hugetlb_vmemmap_restore_folios-definition.patch added to mm-unstable branch
Message-Id: <20250206232010.F41B3C4CEDD@smtp.kernel.org>
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
Date: Thu, 6 Feb 2025 18:50:59 +0000

Make the hugetlb_vmemmap_restore_folios definition inline for the
!CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP case, so that including this file in
files other than hugetlb_vmemmap.c will work.

Link: https://lkml.kernel.org/r/20250206185109.1210657-20-fvdl@google.com
Fixes: cfb8c75099db ("hugetlb: perform vmemmap restoration on a list of pages")
Signed-off-by: Frank van der Linden <fvdl@google.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zhenguo Yao <yaozhenguo1@gmail.com>
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
mm-hugetlb-fix-round-robin-bootmem-allocation.patch
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

