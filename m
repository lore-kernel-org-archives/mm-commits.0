Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB99A27EFEF
	for <mm-commits@vger.kernel.org>; Tue,  2 Sep 2025 11:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756811881; cv=none; b=Ft2/rD8IlPG39gCdjnar7HgRaljnGFNfht/U6FC2K4tN+Vq+vlTD+YZ0FbBuW+MUKSbDXD/sK+24aL6bGNb+kUNiGyw/MSUvoqgj3s3e3evIDtN+b5LVpm0JsJ5JLtryC7PSzW5/xq8DsWqam8DZqKm/IRlhmEJqVJr7SSTlbNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756811881; c=relaxed/simple;
	bh=xS9WOdz+36eujqAaZNRI5/1QCFN7GfgWfSHKhGwv1XE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s/B8VnFSlSCSalaJ6nlxQqFUkGF3rhu+tQY9tHB+LGelcwHHxHEABib2AnR4uLAkpMLzNJpBrskn6/L5evgbw9qaTR11UbuFtMQ96P3sB1GN+fOie3QEsi+NwNTmysKx1GhnvTfUw4mGwIm0LJwGtP1GGynZYzHScC9RbMuF/wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AVuoCHrg; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AVuoCHrg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756811880; x=1788347880;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xS9WOdz+36eujqAaZNRI5/1QCFN7GfgWfSHKhGwv1XE=;
  b=AVuoCHrggqrgQpxEVNsMuc0Jw02NBQXvaFLBYHDSfam0ITBLmgDh+lSc
   8lzYwRKj0ZyvMayeu8qCVhjc46AIOO+aKdF0rUFvO3JxuUTn6Z+CHarBV
   UgOQFNUkA5wrXJ51qKms0XYYgJXdlbmRgLPMEmWd5QvqJOt6+ztjZ0LPj
   EKmwVlObCTA5WP80NhFrGgiiC/ZX/KxgeKuFsYm7Pl27MH9QJFLbkILOL
   2xpQf5jWOQfmPtGGL4RxqTQYPMY8TGFlzAW+Y6GLrU3iQMcu0gAmjcTKJ
   1pH34gyZe3Ng0ijXt84ek2ozrGhS8m0LxgCsesa4iHW8DyRtaOBPafCi5
   A==;
X-CSE-ConnectionGUID: BVgCB27hSQu40TQqpBz10Q==
X-CSE-MsgGUID: H9nOvcmTQXqneHoyl2cMdA==
X-IronPort-AV: E=McAfee;i="6800,10657,11540"; a="59017227"
X-IronPort-AV: E=Sophos;i="6.18,230,1751266800"; 
   d="scan'208";a="59017227"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 04:17:59 -0700
X-CSE-ConnectionGUID: PYJ80Lo9TzOfudPVXACSmA==
X-CSE-MsgGUID: njaLXQnOSdmGOBtUC/2yuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,230,1751266800"; 
   d="scan'208";a="171411132"
Received: from mwiniars-desk2.ger.corp.intel.com (HELO fdugast-desk.home) ([10.245.246.199])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 04:17:56 -0700
From: Francois Dugast <francois.dugast@intel.com>
To: akpm@linux-foundation.org
Cc: airlied@gmail.com,
	apopple@nvidia.com,
	balbirs@nvidia.com,
	christian.koenig@amd.com,
	francois.dugast@intel.com,
	jgg@nvidia.com,
	leonro@nvidia.com,
	matthew.brost@intel.com,
	mm-commits@vger.kernel.org,
	mpenttil@redhat.com,
	thomas.hellstrom@linux.intel.com,
	ziy@nvidia.com
Subject: [PATCH] mm/hmm: populate PFNs from PMD swap entry
Date: Tue,  2 Sep 2025 13:17:43 +0200
Message-ID: <20250902111743.1633972-1-francois.dugast@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250830035612.0DE67C4CEEB@smtp.kernel.org>
References: <20250830035612.0DE67C4CEEB@smtp.kernel.org>
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
 mm/hmm.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/mm/hmm.c b/mm/hmm.c
index d545e2494994..d449fc4647d7 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -355,6 +355,29 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
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
-- 
2.43.0

