Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C287262B
	for <mm-commits@vger.kernel.org>; Sat, 30 Aug 2025 03:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756526173; cv=none; b=OvpqSQjEP0S71aYDJ+zjO0zqfBpoXhOeTAbH+4sI8Dqk+Nc3R1YtqaZt0isdu84CuJlqWxsf4n98n4i0iyriYsqH/3A+PR590ypY54nVoOUTy2H+5cdzuSA0CMrL+1QInjufuNxPJCpuZvgywveIFNZpdzyxf1tySkyEqGSByrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756526173; c=relaxed/simple;
	bh=51CbwRLTYhpdHvlJoIdQqeknUKrbuk4VxkN7n4o7Lzg=;
	h=Date:To:From:Subject:Message-Id; b=qsZGG+vbfYodLR6QT4HJZeKZ6rFeU2HyqGL55TD5Ky/6IaermqVmNtbA+RNFUZgMFltcadlcmnE1DvBkaogVt3fWeICMboX55i0icJ0IWMIDfcWsXluGQGKdu0ZH2x5YVq7OVXqY4IwpeNoBGojEijd6g7xCkWz6rhuv2JAEWpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pPnRKcrD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pPnRKcrD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DE67C4CEEB;
	Sat, 30 Aug 2025 03:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756526172;
	bh=51CbwRLTYhpdHvlJoIdQqeknUKrbuk4VxkN7n4o7Lzg=;
	h=Date:To:From:Subject:From;
	b=pPnRKcrDG9hRo56thzOwfOySAeXrMFPz87uFMHa4BTll+hfEqV+K1f96epzG+fNT1
	 KP7QAr19rJHHST1llb9e/kX56mrZ3r3FWcfbZrrvlpPpys0JZFTq/UAzqxXHKXfNqr
	 1G57qoxMjW7eSB4kHtVtA1fvXIusrUUgr24AU1sM=
Date: Fri, 29 Aug 2025 20:56:11 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,thomas.hellstrom@linux.intel.com,mpenttil@redhat.com,matthew.brost@intel.com,leonro@nvidia.com,jgg@nvidia.com,christian.koenig@amd.com,balbirs@nvidia.com,apopple@nvidia.com,airlied@gmail.com,francois.dugast@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hmm-populate-pfns-from-pmd-swap-entry.patch added to mm-new branch
Message-Id: <20250830035612.0DE67C4CEEB@smtp.kernel.org>
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
Date: Fri, 29 Aug 2025 10:05:05 +0200

Once support for THP migration of zone device pages is enabled, device
private swap entries will be found during the walk not only for PTEs but
also for PMDs.

Therefore, it is necessary to extend to PMDs the special handling which is
already in place for PTEs when device private pages are owned by the
caller: instead of faulting or skipping the range, the correct behavior is
to use the swap entry to populate HMM PFNs.

Even though subsequent PFNs can be inferred when handling large order
PFNs, the PFN list is still fully populated because this is currently
expected by HMM users.

Link: https://lkml.kernel.org/r/20250829080505.1020155-1-francois.dugast@intel.com
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

 mm/hmm.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/mm/hmm.c~mm-hmm-populate-pfns-from-pmd-swap-entry
+++ a/mm/hmm.c
@@ -355,6 +355,29 @@ again:
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

