Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E362D9EF5
	for <mm-commits@vger.kernel.org>; Tue,  2 Sep 2025 13:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756818446; cv=none; b=ePDf7tOZzIBiJgo23Gpktn1qABg9zERgKCtDs56jMzx4Oo5Tu4Z/Gv9jtAcciU+dK4QZIcEIwzUJpsQV3rVgC7VJj/jeSPwlCgqeyVafqoBDQJFXYt2/dKANTcONGhG9M3BRXApGfJs3lFX1VnmpCPgzWAwXmih8unt35xSStEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756818446; c=relaxed/simple;
	bh=fBoRDJ18yzcgbk5Pbf1cdynf22Z7Cqrf7KdZ9q7j6rI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QIk+GuFtLINB3LEU0CZfEVJFi/IDP/La1b1Fjz+MGABZiTajvU89iWiF1ViOk2+LEHClucrHseixdDfNGSe4iYXykWyGbz00rO53sX1Z88vS0Oi6J+d9mzRtyO41dxlAyZbQKuJW8dj/92BYdJpJmKgiOFMhRV11YIOu2oG+ucc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=km7nOcAw; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="km7nOcAw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756818445; x=1788354445;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fBoRDJ18yzcgbk5Pbf1cdynf22Z7Cqrf7KdZ9q7j6rI=;
  b=km7nOcAwlTbH/w9LmIh2fl65F5EK5y1eHumf5VgW9+4Jg+zvdymaFIs+
   rJRVPMfw1isBogGhFop1UzXZwhGpQ9y9d76kcPtpIlsJ6IZB1DoV4xNLe
   C05o/CzcyX08Ropddg65e6be3AbqWxZaBR+4oc9O7NG07pIN+AvpkBpnX
   1grgj7j0Pcslj9PdhYtyWGsY0o0xBtSZTCD8c//emu7MN1RglRuVI47Q4
   rhKn6c4akKMKrWcZ+Hc4j9i+1XGqUF+SE2PH5CAreI5369WPwYRDhuaPV
   sw9ZYkKWVqLT2REeuiXHuEqEliNstWOGIenhQ52Sn3JxtM54s4NslXaxl
   A==;
X-CSE-ConnectionGUID: +KOua89iTW2wA3fa9AovWQ==
X-CSE-MsgGUID: X8l3pYxdSriPwaIT97c2Jg==
X-IronPort-AV: E=McAfee;i="6800,10657,11541"; a="58296556"
X-IronPort-AV: E=Sophos;i="6.18,230,1751266800"; 
   d="scan'208";a="58296556"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 06:07:25 -0700
X-CSE-ConnectionGUID: PVzXo9WCQrenyF5rX+fYdw==
X-CSE-MsgGUID: 2Dw/WULTSdiXc/4g+ead7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,230,1751266800"; 
   d="scan'208";a="175650936"
Received: from mwiniars-desk2.ger.corp.intel.com (HELO fdugast-desk.home) ([10.245.246.199])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 06:07:21 -0700
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
Date: Tue,  2 Sep 2025 15:07:13 +0200
Message-ID: <20250902130713.1644661-1-francois.dugast@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <aLbotHsTPaqk50fK@fdugast-desk>
References: <aLbotHsTPaqk50fK@fdugast-desk>
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
 mm/hmm.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/mm/hmm.c b/mm/hmm.c
index d545e2494994..a8ac8d830e39 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -355,6 +355,35 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
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
-- 
2.43.0

