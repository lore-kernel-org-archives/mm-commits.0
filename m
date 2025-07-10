Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94BD022154B
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126342; cv=none; b=MZDDIZUdJhl5QFS1Dm8CVT/5PVT++JfLvgIGjLuPwalk9tMMsZEibzVAHAndqNhIAv7AIBM9BLQH5oXixZzpxUZ8FWXunj5alzHdo6Sv1KcJChBgSq00vreutc3LdTZNNd8ZOCbk5a0m1WDS/UaU8BCDjkH99hSkuTlxgSy6nTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126342; c=relaxed/simple;
	bh=SR5SA7kMD8wsBt5INsq6ALgYpHoYDkJNjBNe3AQXIZA=;
	h=Date:To:From:Subject:Message-Id; b=u/wNxi3/EH/iP2d+Bjs0XXmufV+M2jVYZjWZYKppBqli1TWxlxhKSmkaLoWpJmqOVS0Bslwm7ntbbkqXlX0Pq6ls8Apc0shZWz/KUAJu6TAn1CRamKhqXVDX0Rrymh/sLaJzugZPNJNscURmk2mwaX0vBm2fIEvJ2cj7+Sl1Wj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nQS44j1W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nQS44j1W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5FDC4CEE3;
	Thu, 10 Jul 2025 05:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126342;
	bh=SR5SA7kMD8wsBt5INsq6ALgYpHoYDkJNjBNe3AQXIZA=;
	h=Date:To:From:Subject:From;
	b=nQS44j1WiHsDaqMqYYqNhjOdRyZynJXHWIBFpCpMvLwR7I9duTe+e0pZ/ZxO3vydR
	 J/NuGssR7mTJu6m1vsN0z5HWXg0x4nTl1VP4U9k0Fw3JHApwKB5x+H/ov5BErR2HZX
	 Hd0WrZ/XTpMfo006NTfUENYdax2sbWsFHbKOkVgE=
Date: Wed, 09 Jul 2025 22:45:41 -0700
To: mm-commits@vger.kernel.org,zhang.lyra@gmail.com,willy@infradead.org,will@kernel.org,m.szyprowski@samsung.com,lorenzo.stoakes@oracle.com,john@groves.net,jhubbard@nvidia.com,jgg@nvidia.com,hch@lst.de,gerald.schaefer@linux.ibm.com,debug@rivosinc.com,david@redhat.com,dan.j.williams@intel.com,bjorn@rivosinc.com,bjorn@kernel.org,balbirs@nvidia.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-remove-pxd_devmap-usage-from-insert_pxd_pfn.patch removed from -mm tree
Message-Id: <20250710054542.6C5FDC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: remove pXd_devmap usage from insert_pXd_pfn()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-remove-pxd_devmap-usage-from-insert_pxd_pfn.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: mm/huge_memory: remove pXd_devmap usage from insert_pXd_pfn()
Date: Thu, 19 Jun 2025 18:57:58 +1000

Nothing uses PFN_DEV anymore so no need to create devmap pXd's when
mapping a PFN.  Instead special mappings will be created which ensures
vm_normal_page_pXd() will not return pages which don't have an associated
page.  This could change behaviour slightly on architectures where
pXd_devmap() does not imply pXd_special() as the normal page checks would
have fallen through to checking VM_PFNMAP/MIXEDMAP instead, which in
theory at least could have returned a page.

However vm_normal_page_pXd() should never have been returning pages for
pXd_devmap() entries anyway, so anything relying on that would have been a
bug.

Link: https://lkml.kernel.org/r/cd8658f9ff10afcfffd8b145a39d98bf1c595ffa.1750323463.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Björn Töpel <bjorn@kernel.org>
Cc: Björn Töpel <bjorn@rivosinc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chunyan Zhang <zhang.lyra@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Deepak Gupta <debug@rivosinc.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Inki Dae <m.szyprowski@samsung.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Groves <john@groves.net>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-remove-pxd_devmap-usage-from-insert_pxd_pfn
+++ a/mm/huge_memory.c
@@ -1415,11 +1415,7 @@ static int insert_pmd(struct vm_area_str
 		add_mm_counter(mm, mm_counter_file(fop.folio), HPAGE_PMD_NR);
 	} else {
 		entry = pmd_mkhuge(pfn_t_pmd(fop.pfn, prot));
-
-		if (pfn_t_devmap(fop.pfn))
-			entry = pmd_mkdevmap(entry);
-		else
-			entry = pmd_mkspecial(entry);
+		entry = pmd_mkspecial(entry);
 	}
 	if (write) {
 		entry = pmd_mkyoung(pmd_mkdirty(entry));
@@ -1565,11 +1561,7 @@ static void insert_pud(struct vm_area_st
 		add_mm_counter(mm, mm_counter_file(fop.folio), HPAGE_PUD_NR);
 	} else {
 		entry = pud_mkhuge(pfn_t_pud(fop.pfn, prot));
-
-		if (pfn_t_devmap(fop.pfn))
-			entry = pud_mkdevmap(entry);
-		else
-			entry = pud_mkspecial(entry);
+		entry = pud_mkspecial(entry);
 	}
 	if (write) {
 		entry = pud_mkyoung(pud_mkdirty(entry));
_

Patches currently in -mm which might be from apopple@nvidia.com are


