Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E0970830
	for <mm-commits@vger.kernel.org>; Tue,  9 Sep 2025 01:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757382698; cv=none; b=Nl+A7UDGUaxoMTwK0bbA0k1pm+5FvNHTr8ju1+R8kcwSj71ow1UjxF+EPap2XFpmr/XBUzR7C80xbH+Hw+lpXitMg+ZWM2ug0RtpPwqmcafY/1Fcu3zqXC6w4z7TSE5BRmD4Frkv23UA8s+/7HJhHQqyrqn5iRYttEaTZh5xrbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757382698; c=relaxed/simple;
	bh=wq3OHDJ5EdTf2cgRm0Zjfz9QZpJ+O2X6bCHht/tKp4o=;
	h=Date:To:From:Subject:Message-Id; b=VI+Qo22ZZr5GCC5S+9BgHxALu8CR9xx9AAhCpt0BAtua0zun3EmdZDd1Sr3ODDcKyj/zZbluFAmSvfYHyytj9avgctmfDBFZ1W5mWVGWkPPeh6p4LlwdJnVauVpEGoa8STB+hPiaVDvlpc0B49r9yRrCXTwFmIUTJuRxr8DXKDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JI8SVPn2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JI8SVPn2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B72F8C4CEF1;
	Tue,  9 Sep 2025 01:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757382697;
	bh=wq3OHDJ5EdTf2cgRm0Zjfz9QZpJ+O2X6bCHht/tKp4o=;
	h=Date:To:From:Subject:From;
	b=JI8SVPn2IPU+6V7zGP0Yu1714/jp3ln2ewXQ/ARO+L0NdnZM/WJWm7HYj9gx1k2XM
	 VvkSB6JZbRwE+Ky6uLUEXAyhu6tnf0CLiXuCYQGoeVzI+rCLQXCC1cBO9Y744jTJdt
	 +kxF0SKvoljkD3YrhdXyLk4dz1Iyho0CvcBBRrc8=
Date: Mon, 08 Sep 2025 18:51:37 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,thomas.hellstrom@linux.intel.com,mpenttil@redhat.com,matthew.brost@intel.com,leonro@nvidia.com,jgg@nvidia.com,christian.koenig@amd.com,balbirs@nvidia.com,apopple@nvidia.com,airlied@gmail.com,francois.dugast@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hmm-populate-pfns-from-pmd-swap-entry.patch added to mm-new branch
Message-Id: <20250909015137.B72F8C4CEF1@smtp.kernel.org>
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
Date: Mon, 8 Sep 2025 11:10:52 +0200

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

Link: https://lkml.kernel.org/r/20250908091052.612303-1-francois.dugast@intel.com
Signed-off-by: Francois Dugast <francois.dugast@intel.com>
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

 mm/hmm.c |   70 +++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 65 insertions(+), 5 deletions(-)

--- a/mm/hmm.c~mm-hmm-populate-pfns-from-pmd-swap-entry
+++ a/mm/hmm.c
@@ -326,6 +326,68 @@ fault:
 	return hmm_vma_fault(addr, end, required_fault, walk);
 }
 
+#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
+				     unsigned long end, unsigned long *hmm_pfns,
+				     pmd_t pmd)
+{
+	struct hmm_vma_walk *hmm_vma_walk = walk->private;
+	struct hmm_range *range = hmm_vma_walk->range;
+	unsigned long npages = (end - start) >> PAGE_SHIFT;
+	unsigned long addr = start;
+	swp_entry_t entry = pmd_to_swp_entry(pmd);
+	unsigned int required_fault;
+
+	if (is_device_private_entry(entry) &&
+	    pfn_swap_entry_folio(entry)->pgmap->owner ==
+	    range->dev_private_owner) {
+		unsigned long cpu_flags = HMM_PFN_VALID |
+			hmm_pfn_flags_order(PMD_SHIFT - PAGE_SHIFT);
+		unsigned long pfn = swp_offset_pfn(entry);
+		unsigned long i;
+
+		if (is_writable_device_private_entry(entry))
+			cpu_flags |= HMM_PFN_WRITE;
+
+		/*
+		 * Fully populate the PFN list though subsequent PFNs could be
+		 * inferred, because drivers which are not yet aware of large
+		 * folios probably do not support sparsely populated PFN lists.
+		 */
+		for (i = 0; addr < end; addr += PAGE_SIZE, i++, pfn++) {
+			hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
+			hmm_pfns[i] |= pfn | cpu_flags;
+		}
+
+		return 0;
+	}
+
+	required_fault = hmm_range_need_fault(hmm_vma_walk, hmm_pfns,
+					      npages, 0);
+	if (required_fault) {
+		if (is_device_private_entry(entry))
+			return hmm_vma_fault(addr, end, required_fault, walk);
+		else
+			return -EFAULT;
+	}
+
+	return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
+}
+#else
+static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
+				     unsigned long end, unsigned long *hmm_pfns,
+				     pmd_t pmd)
+{
+	struct hmm_vma_walk *hmm_vma_walk = walk->private;
+	struct hmm_range *range = hmm_vma_walk->range;
+	unsigned long npages = (end - start) >> PAGE_SHIFT;
+
+	if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0))
+		return -EFAULT;
+	return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
+}
+#endif  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
+
 static int hmm_vma_walk_pmd(pmd_t *pmdp,
 			    unsigned long start,
 			    unsigned long end,
@@ -354,11 +416,9 @@ again:
 		return hmm_pfns_fill(start, end, range, 0);
 	}
 
-	if (!pmd_present(pmd)) {
-		if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0))
-			return -EFAULT;
-		return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
-	}
+	if (!pmd_present(pmd))
+		return hmm_vma_handle_absent_pmd(walk, start, end, hmm_pfns,
+						 pmd);
 
 	if (pmd_trans_huge(pmd)) {
 		/*
_

Patches currently in -mm which might be from francois.dugast@intel.com are

mm-hmm-populate-pfns-from-pmd-swap-entry.patch

