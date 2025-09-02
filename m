Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3062749FE
	for <mm-commits@vger.kernel.org>; Tue,  2 Sep 2025 23:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756856776; cv=none; b=iOLLijk1SAPJUvL9z9VATCk4HxurlDt2l+DtksviMOggd/kSii8Q2yz4O6tNU0L67+uf21V3NJT+ZKyYs8mVx5W1iVt0rjAQHhBxuZ/kRjBCwh9z0ohGF9e9Iw7CVNmj1yvSGrqsuL9s4HgwoCwgTGCTG2dzzP1iEQlhbA4N3Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756856776; c=relaxed/simple;
	bh=SBcYqsNJtEDUlXkDT3nyPoRetlSO2x+EzddUW8LOLeQ=;
	h=Date:To:From:Subject:Message-Id; b=gXpq29cy6/nonMlhnwRav1X6UxEVWJPOFk6PHO6neOenoaCrOf7v1JI2/EciscFJO7AaOl+o7R569ZaTHf9yTbU1HErhf++7FkG+cBJQ9u8+8JKvMMk/Z06E9qUNnzxZk39CXVUPqxxvzF8xV5p3bhDOVDj/AAREcjnO9ip2oyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HCE8ZLiZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HCE8ZLiZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D2AC4CEED;
	Tue,  2 Sep 2025 23:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756856776;
	bh=SBcYqsNJtEDUlXkDT3nyPoRetlSO2x+EzddUW8LOLeQ=;
	h=Date:To:From:Subject:From;
	b=HCE8ZLiZLx90bhkv/Xf3k90XutuS9IiaRoT31uQhX5z82R4Y/a26uJVK0L7+CehK8
	 To8mX34cvuGUANFYRKYYryTJ0E7Z9mWjX4+LcwExfYhRT4fvcHNLcS0mBtU5+WkyGv
	 MuekzvHrA8WYrxIC4XgwzcnrOYrfNjRRX24mEqqE=
Date: Tue, 02 Sep 2025 16:46:15 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,thomas.hellstrom@linux.intel.com,mpenttil@redhat.com,matthew.brost@intel.com,leonro@nvidia.com,jgg@nvidia.com,christian.koenig@amd.com,balbirs@nvidia.com,apopple@nvidia.com,airlied@gmail.com,francois.dugast@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hmm-populate-pfns-from-pmd-swap-entry.patch added to mm-new branch
Message-Id: <20250902234616.16D2AC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hmm: populate PFNs from PMD swap entry
has been added to the -mm mm-new branch.  Its filename is
     mm-hmm-populate-pfns-from-pmd-swap-entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hmm-populate-pfns-from-pmd-swap-entry.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Francois Dugast <francois.dugast@intel.com>
Subject: mm/hmm: populate PFNs from PMD swap entry
Date: Tue, 2 Sep 2025 15:07:13 +0200

Once support for THP migration of zone device pages is enabled, device
private swap entries will be found during the walk not only for PTEs but
also for PMDs.

Therefore, it is necessary to extend to PMDs the special handling which is
already in place for PTEs when device private pages are owned by the
caller: instead of faulting or skipping the range, the correct behavior is
to use the swap entry to populate HMM PFNs.

This change is a prerequisite to make use of device-private THP in drivers
using drivers/gpu/drm/drm_pagemap, such as xe.

Even though subsequent PFNs can be inferred when handling large order
PFNs, the PFN list is still fully populated because this is currently
expected by HMM users.  In case this changes in the future, that is all
HMM users support a sparsely populated PFN list, the for() loop can be
made to skip remaining PFNs for the current order.  A quick test shows the
loop takes about 10 ns, roughly 20 times faster than without this
optimization.

Link: https://lkml.kernel.org/r/20250829080505.1020155-1-francois.dugast@intel.com
Link: https://lkml.kernel.org/r/20250902130713.1644661-1-francois.dugast@intel.com
Signed-off-by: Francois Dugast <francois.dugast@intel.com>
Acked-by: Balbir Singh <balbirs@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: David Airlie <airlied@gmail.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: Thomas Hellstrom <thomas.hellstrom@linux.intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hmm.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

--- a/mm/hmm.c~mm-hmm-populate-pfns-from-pmd-swap-entry
+++ a/mm/hmm.c
@@ -355,6 +355,35 @@ again:
 	}
 
 	if (!pmd_present(pmd)) {
+#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+		swp_entry_t entry = pmd_to_swp_entry(pmd);
+
+		if (is_device_private_entry(entry) &&
+		    pfn_swap_entry_folio(entry)->pgmap->owner ==
+		    range->dev_private_owner) {
+			unsigned long cpu_flags = HMM_PFN_VALID |
+				hmm_pfn_flags_order(PMD_SHIFT - PAGE_SHIFT);
+			unsigned long pfn = swp_offset_pfn(entry);
+			unsigned long i;
+
+			if (is_writable_device_private_entry(entry))
+				cpu_flags |= HMM_PFN_WRITE;
+
+			/*
+			 * Fully populate the PFN list though subsequent
+			 * PFNs could be inferred, because drivers which
+			 * are not yet aware of large folios probably do
+			 * not support sparsely populated PFN lists.
+			 */
+			for (i = 0; addr < end; addr += PAGE_SIZE, i++, pfn++) {
+				hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
+				hmm_pfns[i] |= pfn | cpu_flags;
+			}
+
+			return 0;
+		}
+#endif  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
+
 		if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0))
 			return -EFAULT;
 		return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
_

Patches currently in -mm which might be from francois.dugast@intel.com are

mm-hmm-populate-pfns-from-pmd-swap-entry.patch

