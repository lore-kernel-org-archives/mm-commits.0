Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0151DDA09
	for <mm-commits@vger.kernel.org>; Tue, 23 Sep 2025 03:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758597130; cv=none; b=aeI99LAdRs2W7tCvFRtg4gMhNsla7En5DcTXLPUDMuzBd2PtQj1h6yuyQuOtQogYkp0rhn3DKWvcFhqIjHQ+3aFm9EfMy1uhY3QJsBxV/tnIQkhGQ4irfvT5wAapUfeI8cQ7KasJBjp6qeuIIOk8z5Lv3CyggE2S3Ma82i8KknU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758597130; c=relaxed/simple;
	bh=dfDjumudUb78FLaNQUfYWBC+d3JUtatxF3Tib8HvE2w=;
	h=Date:To:From:Subject:Message-Id; b=Xa0qehh1/BC/c3DbBbzGKF/x16/EDGHG1x85r9VLAMvQD9b4p9erWPlS4kuSTQ0IHjOxzIhC6pTs/LjBnzzp+8PbmJNSvYKg+IG/XokokA1QvNg8SGPnGh8mkRY2GAnzVZde+N4Q26xQTxbCOCbpt06bdkZu4+/EYKixlQeZJrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Vru5tPGZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vru5tPGZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0CBCC4CEF0;
	Tue, 23 Sep 2025 03:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758597130;
	bh=dfDjumudUb78FLaNQUfYWBC+d3JUtatxF3Tib8HvE2w=;
	h=Date:To:From:Subject:From;
	b=Vru5tPGZujCAZIQBUks89eNVnGhAJqX2lXDD4efky3Squg6A/xyTf/HQpcfNzh+Wr
	 zTQarF9pGpC2PKuq9bbbXPEt4sqsXROdTa0axjNxT/Jh6G31x5/3p/xHNqd3pyWTMD
	 MYOuduWuF/4Prj/ACOZ/V/axq/Z2L1bBl2VXWFTc=
Date: Mon, 22 Sep 2025 20:12:10 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,jgg@nvidia.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-add-remap_pfn_range_prepare-remap_pfn_range_complete-fix.patch removed from -mm tree
Message-Id: <20250923031210.A0CBCC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-add-remap_pfn_range_prepare-remap_pfn_range_complete-fix
has been removed from the -mm tree.  Its filename was
     mm-add-remap_pfn_range_prepare-remap_pfn_range_complete-fix.patch

This patch was dropped because it was folded into mm-add-remap_pfn_range_prepare-remap_pfn_range_complete.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-remap_pfn_range_prepare-remap_pfn_range_complete-fix
Date: Thu Sep 18 02:38:36 PM PDT 2025

restore inadvertently-removed newline

Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memory.c~mm-add-remap_pfn_range_prepare-remap_pfn_range_complete-fix
+++ a/mm/memory.c
@@ -2955,6 +2955,7 @@ static int remap_pfn_range_notrack(struc
 		unsigned long pfn, unsigned long size, pgprot_t prot)
 {
 	int error = remap_pfn_range_internal(vma, addr, pfn, size, prot);
+
 	if (!error)
 		return 0;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-fix-warnings-caused-by-use-of-arch_enter_lazy_mmu_mode-fix.patch
mm-add-remap_pfn_range_prepare-remap_pfn_range_complete.patch
mm-vmalloc-move-resched-point-into-alloc_vmap_area-fix.patch
mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch

