Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B123C2EC543
	for <mm-commits@vger.kernel.org>; Mon,  8 Sep 2025 09:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757322665; cv=none; b=DRxWKcj7gX2szxI2B6m/eSkMiUCqVVx0pUsKqduMV45Cfpz3geZoykf7ZKSmfIyRknUFHLNnURT1u2Epzsv0vGA0nAca/e3Yq9bGuPMEsgcYBJBj8UuKIIT+m7LK40lTadtwo/cW3m6MzErv+gykOuqfZsZOxwcedhp1/Io5ado=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757322665; c=relaxed/simple;
	bh=fcyNWASx/Y3v9NtbhYRzcR2ryt/OVwE1xi32XSQ/5C4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=le75MqE+U2d5EeC19FsxidmkWk6K94dJGs0zGy0C+GDXEJ5hmN8MtUe2sxFaeOuhwbwUwtiqsH6DC1tvmF7BhVbtej7TtqtC59LXtqePNeRf2qlBPjS5u40LvV/+ZdgEJbDriQhzwkM1cVkZtgd7aqudzJUKHU2b+Uy/bSL/hZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HZ/FqlXB; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HZ/FqlXB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757322664; x=1788858664;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fcyNWASx/Y3v9NtbhYRzcR2ryt/OVwE1xi32XSQ/5C4=;
  b=HZ/FqlXB+u3RtxWCFDZRth6jjwre/fgV53PoSN1In2DxxvO39ptrid8J
   +EAbrTpXaCAto4q0AUzjY8QMghUHEFAwrc9ANl2CAl0u1yJBCjgf9ZnXQ
   ws6ve73daB6q9cvCKVVU+tPSrrVHJ9FIL3q7taKExjNxM7CxyYCYfugE7
   p7AxCQE44y9l+iGSP+a5GndeyHiV/yPDeSHMQbi1vgeb7l/bcnZgoeDJL
   gj9KLgObvTERLiVDjS1/wR+XjJ7krEESmSdnnERbec8YzKgfZi3rsO0h5
   TQ6K1IAvxA74EAgkSQdLqb/tL994yoZZ69WMPiU+22KPSNNUAvnJZnUT4
   A==;
X-CSE-ConnectionGUID: fKogg8MLQH27kkW8wlXRCw==
X-CSE-MsgGUID: 6sbgWpHAQFW7yUeUP3E3eg==
X-IronPort-AV: E=McAfee;i="6800,10657,11546"; a="69828556"
X-IronPort-AV: E=Sophos;i="6.18,248,1751266800"; 
   d="scan'208";a="69828556"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2025 02:11:04 -0700
X-CSE-ConnectionGUID: dz6gZFx6TMGJusuFCY3eUw==
X-CSE-MsgGUID: Q1EPl7bzTZ6IT9gNcy3gug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,248,1751266800"; 
   d="scan'208";a="177946267"
Received: from dhhellew-desk2.ger.corp.intel.com (HELO fdugast-desk.home) ([10.245.246.193])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2025 02:10:59 -0700
From: Francois Dugast <francois.dugast@intel.com>
To: francois.dugast@intel.com
Cc: airlied@gmail.com,
	akpm@linux-foundation.org,
	apopple@nvidia.com,
	balbirs@nvidia.com,
	christian.koenig@amd.com,
	jgg@nvidia.com,
	leonro@nvidia.com,
	matthew.brost@intel.com,
	mm-commits@vger.kernel.org,
	mpenttil@redhat.com,
	thomas.hellstrom@linux.intel.com,
	ziy@nvidia.com
Subject: [PATCH] mm/hmm: populate PFNs from PMD swap entry
Date: Mon,  8 Sep 2025 11:10:52 +0200
Message-ID: <20250908091052.612303-1-francois.dugast@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <aLmTWhL36_ciqajA@fdugast-desk>
References: <aLmTWhL36_ciqajA@fdugast-desk>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
expected by HMM users. In case this changes in the future, that is all HMM
users support a sparsely populated PFN list, the for() loop can be made to
skip remaining PFNs for the current order. A quick test shows the loop
takes about 10 ns, roughly 20 times faster than without this optimization.

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
Signed-off-by: Francois Dugast <francois.dugast@intel.com>
---
 mm/hmm.c | 70 ++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 65 insertions(+), 5 deletions(-)

diff --git a/mm/hmm.c b/mm/hmm.c
index d545e2494994..3e00f08722d5 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -326,6 +326,68 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
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
@@ -354,11 +416,9 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
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
-- 
2.43.0

