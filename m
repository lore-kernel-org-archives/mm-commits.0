Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF761D54D8
	for <mm-commits@vger.kernel.org>; Fri, 19 Sep 2025 21:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758315892; cv=none; b=JwqpLx5IZxDtNdGKzqWsAhj9nzB6WpAsH0BEeGJwLCr6ZKFPt8If68EfO50jbkQtTNlX6vrOuiW6T2QpGJMWy4Js5vSsHpYKoZ7CbzMyZWiK697poWgKVAkPr1jKZNv6u/8hI+meLQPT96NhxFZY8AotrHd16B42idU4obL4/Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758315892; c=relaxed/simple;
	bh=j7p+WJHzu4u350lkWectcxCc8Om8hmTvlVVwLz/FebQ=;
	h=Date:To:From:Subject:Message-Id; b=WsGO6y3tJVd9G4ddpfctpcCvlTAlMEEJPF70ZDvyyg51rnqVG7lSwKcbqHFwMHG3bGP4SgHltKqP02V0Z4e3VZw3VVCUHZ7M07YWidZUtpI80/8gejUyqTQgKd18tjxuzRH4rBJnNw14yb4O6BXjYskQKaxMSxS5+zucCC7E0ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LpDPbK9M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LpDPbK9M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD13C4CEF0;
	Fri, 19 Sep 2025 21:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758315890;
	bh=j7p+WJHzu4u350lkWectcxCc8Om8hmTvlVVwLz/FebQ=;
	h=Date:To:From:Subject:From;
	b=LpDPbK9MWLu55+Ebprwy9yUSzSs07rnRVf6QtwqlmOk74xH4QUVjF/DgeBETyhk8r
	 POS1KC4l7zwptv/HdB/PXnTq2e9sX1KUUbDmMz1hG44JZk7urLPU6mL16J2XyDD1VL
	 DKK7OoP6dbSEwg72638JFS193/dbNFe4Tm8In2mc=
Date: Fri, 19 Sep 2025 14:04:50 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,lkp@intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-add-support-for-preserving-vmalloc-allocations-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20250919210450.9BD13C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho-add-support-for-preserving-vmalloc-allocations-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-add-support-for-preserving-vmalloc-allocations-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-add-support-for-preserving-vmalloc-allocations-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kho-add-support-for-preserving-vmalloc-allocations-fix
Date: Fri Sep 19 01:57:21 PM PDT 2025

fix build

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202509191034.SM82Oaij-lkp@intel.com/
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_handover.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/kexec_handover.c~kho-add-support-for-preserving-vmalloc-allocations-fix
+++ a/kernel/kexec_handover.c
@@ -967,7 +967,7 @@ void *kho_restore_vmalloc(const struct k
 
 			for (int j = 0; j < (1 << order); j++) {
 				page = phys_to_page(phys);
-				kho_restore_page(page, 0);
+				kho_restore_page(phys);
 				pages[idx++] = page;
 				phys += PAGE_SIZE;
 			}
@@ -975,7 +975,7 @@ void *kho_restore_vmalloc(const struct k
 
 		page = virt_to_page(chunk);
 		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
-		kho_restore_page(page, 0);
+		kho_restore_page(page_to_phys(page));
 		__free_page(page);
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-fix-warnings-caused-by-use-of-arch_enter_lazy_mmu_mode-fix.patch
memfd-move-mfd_all_flags-definition-to-memfdh.patch
mm-constify-highmem-related-functions-for-improved-const-correctness-fix.patch
mm-filemap-align-last_index-to-folio-size-fix-fix.patch
mm-re-enable-kswapd-when-memory-pressure-subsides-or-demotion-is-toggled-fix.patch
include-linux-pgtableh-convert-arch_enter_lazy_mmu_mode-and-friends-to-static-inlines.patch
alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix-fix.patch
alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix-fix-fix.patch
mm-add-remap_pfn_range_prepare-remap_pfn_range_complete-fix.patch
mm-vmalloc-move-resched-point-into-alloc_vmap_area-fix.patch
mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch
kho-add-support-for-preserving-vmalloc-allocations-fix.patch

