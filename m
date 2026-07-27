Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BFE63CFF4C
	for <mm-commits@vger.kernel.org>; Mon, 27 Jul 2026 21:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785186420; cv=none; b=Zhp2XdAfOmavDeK7ASM9TFhUgPeK35DEgQkuv/OLmVfp0hoDkQvVkZYfIvM3pDpN6b5piTrLvdvl5WYAacPc3QL/xCZKTIp+b/0J/bCQqBaocf6Uzlz/eM3zyxo9QsMLcABeGbfUrwSVpXRQiXsAGZm7uJVO/S5cgLsWBHgIQ3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785186420; c=relaxed/simple;
	bh=5mry01hzSseX6IvjZxVctpU9hpDbRcY1KcLsHYDWcu4=;
	h=Date:To:From:Subject:Message-Id; b=D8cWhZz7m7wLNyaH65QzL2pIcjOoTtDc22pLU4b03D+G3ggFDaJrYxKKwb8fWv1Ta9DW3fqLD4FB1ObcF4NCsaMljizb5YeOR4CnzxPlZR0YcSq1+WC6ve4AqESxVRr6bJMaqh1Qac4kf0DZmg4nyLeosIuMVgx8kcBlyOYGOd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JHtWObJi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JHtWObJi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E815E1F000E9;
	Mon, 27 Jul 2026 21:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785186419;
	bh=Xh4H6Xz8cQQC1tTPYSTJdtFHj+2vkZmBtA42cL/UvfA=;
	h=Date:To:From:Subject;
	b=JHtWObJib7JruR1g7DQ+2Z2x+piJhdjph8jSNY1GlTYRfpyUaMkwL/gAujK7Talba
	 oewdH0AzhImMsYyFKCLJaswcho1/V1pPePYxhEJYHZyBXP/kQI9ezyHVskrD8bmcqR
	 eMOHX6n5jB0XHYoll+5NgaxI1NpOtsWFuBtyw7VI=
Date: Mon, 27 Jul 2026 14:06:58 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,sj@kernel.org,seanjc@google.com,rppt@kernel.org,peterx@redhat.com,pbonzini@redhat.com,lkp@intel.com,ljs@kernel.org,liam.howlett@oracle.com,jthoughton@google.com,david@kernel.org,corbet@lwn.net,aarcange@redhat.com,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fold-userfaultfd_rwp-to-false-without-config_arch_has_pte_protnone.patch added to mm-new branch
Message-Id: <20260727210658.E815E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fold userfaultfd_rwp() to false without CONFIG_ARCH_HAS_PTE_PROTNONE
has been added to the -mm mm-new branch.  Its filename is
     mm-fold-userfaultfd_rwp-to-false-without-config_arch_has_pte_protnone.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fold-userfaultfd_rwp-to-false-without-config_arch_has_pte_protnone.patch

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
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: mm: fold userfaultfd_rwp() to false without CONFIG_ARCH_HAS_PTE_PROTNONE
Date: Mon, 27 Jul 2026 10:16:11 +0100

RWP tracks accesses by installing PAGE_NONE (protnone) PTEs, so its code
paths are gated on userfaultfd_rwp().  Without
CONFIG_ARCH_HAS_PTE_PROTNONE there is no PAGE_NONE -- <linux/pgtable.h>
defines it to a BUILD_BUG() stub, relying on callers folding such paths to
dead code via IS_ENABLED(CONFIG_ARCH_HAS_PTE_PROTNONE).

userfaultfd_rwp() was not a compile-time constant, so the compiler could
not fold those paths.  With an older compiler (gcc 8.5.0, sparc64) the
PAGE_NONE reference in move_pages_huge_pmd() survived to codegen:

  mm/huge_memory.c:2874: _dst_pmd = pmd_modify(_dst_pmd, PAGE_NONE);
  compiler_types.h:702: error: call to '__compiletime_assert_501'
    declared with attribute error: BUILD_BUG failed

RWP cannot exist without protnone, so return a compile-time false when
CONFIG_ARCH_HAS_PTE_PROTNONE is unset; every RWP path then folds away.

Link: https://lore.kernel.org/amcitKvUvFYr8W38@thinkstation
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202607250853.VaJWGLeA-lkp@intel.com/
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: James Houghton <jthoughton@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/userfaultfd_k.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/include/linux/userfaultfd_k.h~mm-fold-userfaultfd_rwp-to-false-without-config_arch_has_pte_protnone
+++ a/include/linux/userfaultfd_k.h
@@ -221,6 +221,12 @@ static inline bool userfaultfd_minor(str
 
 static inline bool userfaultfd_rwp(struct vm_area_struct *vma)
 {
+	/*
+	 * Callers gate PAGE_NONE usage on this; PAGE_NONE is a BUILD_BUG()
+	 * without CONFIG_ARCH_HAS_PTE_PROTNONE, so fold to false.
+	 */
+	if (!IS_ENABLED(CONFIG_ARCH_HAS_PTE_PROTNONE))
+		return false;
 	return vma_test_single_mask(vma, VMA_UFFD_RWP);
 }
 
_

Patches currently in -mm which might be from kas@kernel.org are

mm-huge_memory-unlock-i_mmap_rwsem-before-releasing-after-split-folios.patch
mm-decouple-protnone-helpers-from-config_numa_balancing.patch
mm-rename-uffd-wp-pte-bit-macros-to-uffd.patch
mm-rename-uffd-wp-pte-accessors-to-uffd.patch
userfaultfd-test-uffd-vma-flags-through-the-vma_flags_t-api.patch
mm-add-vm_uffd_rwp-vma-flag.patch
mm-add-mm_cp_uffd_rwp-change_protection-flag.patch
mm-preserve-rwp-marker-across-pte-rewrites.patch
mm-handle-vm_uffd_rwp-in-khugepaged-rmap-and-gup.patch
userfaultfd-add-uffdio_register_mode_rwp-and-uffdio_rwprotect-plumbing.patch
mm-userfaultfd-add-rwp-fault-delivery-and-expose-uffdio_register_mode_rwp.patch
mm-pagemap-add-page_is_accessed-for-rwp-tracking.patch
userfaultfd-add-uffd_feature_rwp_async-for-async-fault-resolution.patch
userfaultfd-add-uffdio_set_mode-for-runtime-sync-async-toggle.patch
selftests-mm-add-userfaultfd-rwp-tests.patch
documentation-userfaultfd-document-rwp-working-set-tracking.patch
selftests-mm-add-pagemap_scan-test-for-thp-pmd-holes.patch
mm-huge_memory-remove-unused-can_split_folio.patch
mm-huge_memory-fold-split_folio_to_list_to_order-into-split_folio_to_order.patch
mm-fold-userfaultfd_rwp-to-false-without-config_arch_has_pte_protnone.patch

