Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA96D1BE224
	for <mm-commits@vger.kernel.org>; Tue,  2 Jul 2024 17:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941166; cv=none; b=eTCqkKU7fYoC/Hhaus35JeV7WHL3/HEVo51ucbQX9O+3LMHsvxd0ITe/8pdzNdf1YWezzS7uiiRpx11sXVy0MQxGNQAhyD/zRfJYsSmw7pQ+T7STlyPQ6nBQTFtwmjnCGA067OGp2lN7uTzGwrbbubIJxyJmzs/n7Qwbz2aH+kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941166; c=relaxed/simple;
	bh=dcCzFehCFIF1SF8kRnas8j/A26T58TL+VET3fjsM98Q=;
	h=Date:To:From:Subject:Message-Id; b=FUTIlYM61SYiAgDYtob3O7nDYufDPMt9OxixDrZFwvIe1cS54VRMgp8t5GR6BX/2PVe4HjkJknB1b1QY0SRHSNZNw9olfHW1Y3868YMSVST8bdWXctawjRkhCEeBUJ0TpYyKB9WXnsPLDM3gZlZN/1OuNHpc6U4mXZTLBIzwuQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KAqZ/b5h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KAqZ/b5h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A47E3C4AF0A;
	Tue,  2 Jul 2024 17:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719941166;
	bh=dcCzFehCFIF1SF8kRnas8j/A26T58TL+VET3fjsM98Q=;
	h=Date:To:From:Subject:From;
	b=KAqZ/b5hwYk98F938vZKJln276Y5y+jQavEKnuffjjAS4mfbKSw3QlD2K1xHs7n9o
	 RkUwlSRzMphsyGY8oili0Lgyg35co6W72IT4a2ZW9aJtUn0d1xNmHRfdSIdWWvAsyq
	 tfjLPX5vKP9wgKk6cMzo0UhsCkPKQN+7/V5K2GB8=
Date: Tue, 02 Jul 2024 10:26:06 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,jgg@nvidia.com,christophe.leroy@csgroup.eu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-define-__pte_leaf_size-to-also-take-a-pmd-entry.patch added to mm-unstable branch
Message-Id: <20240702172606.A47E3C4AF0A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: define __pte_leaf_size() to also take a PMD entry
has been added to the -mm mm-unstable branch.  Its filename is
     mm-define-__pte_leaf_size-to-also-take-a-pmd-entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-define-__pte_leaf_size-to-also-take-a-pmd-entry.patch

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
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: mm: define __pte_leaf_size() to also take a PMD entry
Date: Tue, 2 Jul 2024 15:51:19 +0200

On powerpc 8xx, when a page is 8M size, the information is in the PMD
entry.  So allow architectures to provide __pte_leaf_size() instead of
pte_leaf_size() and provide the PMD entry to that function.

When __pte_leaf_size() is not defined, define it as a pte_leaf_size() so
that architectures not interested in the PMD arguments are not impacted.

Only define a default pte_leaf_size() when __pte_leaf_size() is not
defined to make sure nobody adds new calls to pte_leaf_size() in the core.

Link: https://lkml.kernel.org/r/c7c008f0a314bf8029ad7288fdc908db1ec7e449.1719928057.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |    3 +++
 kernel/events/core.c    |    2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/include/linux/pgtable.h~mm-define-__pte_leaf_size-to-also-take-a-pmd-entry
+++ a/include/linux/pgtable.h
@@ -1907,9 +1907,12 @@ typedef unsigned int pgtbl_mod_mask;
 #ifndef pmd_leaf_size
 #define pmd_leaf_size(x) PMD_SIZE
 #endif
+#ifndef __pte_leaf_size
 #ifndef pte_leaf_size
 #define pte_leaf_size(x) PAGE_SIZE
 #endif
+#define __pte_leaf_size(x,y) pte_leaf_size(y)
+#endif
 
 /*
  * We always define pmd_pfn for all archs as it's used in lots of generic
--- a/kernel/events/core.c~mm-define-__pte_leaf_size-to-also-take-a-pmd-entry
+++ a/kernel/events/core.c
@@ -7609,7 +7609,7 @@ again:
 
 	pte = ptep_get_lockless(ptep);
 	if (pte_present(pte))
-		size = pte_leaf_size(pte);
+		size = __pte_leaf_size(pmd, pte);
 	pte_unmap(ptep);
 #endif /* CONFIG_HAVE_GUP_FAST */
 
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are

mm-define-__pte_leaf_size-to-also-take-a-pmd-entry.patch
mm-provide-mm_struct-and-address-to-huge_ptep_get.patch
powerpc-mm-remove-_page_psize.patch
powerpc-mm-fix-__find_linux_pte-on-32-bits-with-pmd-leaf-entries.patch
powerpc-mm-allow-hugepages-without-hugepd.patch
powerpc-8xx-fix-size-given-to-set_huge_pte_at.patch
powerpc-8xx-rework-support-for-8m-pages-using-contiguous-pte-entries.patch
powerpc-8xx-simplify-struct-mmu_psize_def.patch
powerpc-e500-remove-enc-and-ind-fields-from-struct-mmu_psize_def.patch
powerpc-e500-switch-to-64-bits-pgd-on-85xx-32-bits.patch
powerpc-e500-encode-hugepage-size-in-pte-bits.patch
powerpc-e500-dont-pre-check-write-access-on-data-tlb-error.patch
powerpc-e500-free-r10-for-find_pte.patch
powerpc-e500-use-contiguous-pmd-instead-of-hugepd.patch
powerpc-64s-use-contiguous-pmd-pud-instead-of-hugepd.patch
powerpc-mm-remove-hugepd-leftovers.patch
mm-remove-config_arch_has_hugepd.patch

