Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8730728640F
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126357; cv=none; b=PNNNkDY0ho0ftpVv+/L+EOfXvY9xjwKItRLgQcKdyVUsIix//rGsPM6CCnUXcCpm+LOwkjl4Z0cuNm0TyQMsm31hoxQ7eCFmDkXk/G5Kg3MBgqp66HYX6LmYwE2Tj6pBlka89/PzyuHZQ8k/rwHMwUwUWh0OWLub1wj8Y2nNhDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126357; c=relaxed/simple;
	bh=E17AxVshHZiz0l7YyhFfJRc6yqDeebZ+5mrMKFVFnC8=;
	h=Date:To:From:Subject:Message-Id; b=neEFGrozYaJKPGqY3xCt0SDps3NsuewrgdjwO4mThfvgRSg2QQI6e5ZzeYpCN4S/InxzKdpJVq/JWiTDeRVFnMBk4bnexSsyoAMFaouuP+HlYPFUTXCr/FmdtzXy4wD7zTMnwvmQCOP/GLFeu2HuIy8T1RUO4clFZ2GtMlb5GwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ANByvFFZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ANByvFFZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E0C3C4CEE3;
	Thu, 10 Jul 2025 05:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126357;
	bh=E17AxVshHZiz0l7YyhFfJRc6yqDeebZ+5mrMKFVFnC8=;
	h=Date:To:From:Subject:From;
	b=ANByvFFZ8xdJVRzo5SeQTl+yMXU+1TXBxqTmVhNz6iqvCc0nLIxENLL2JvTBcF8kK
	 YtA1bJTRKuehhwVfDVV7XkxLNZQedSP5wAxksId9/sgJKizmNzUOcpEV5nkLh3uLna
	 LZvtXUXhtQXv+v3pZXV/z69EQHkn8VBOIZL05sys=
Date: Wed, 09 Jul 2025 22:45:56 -0700
To: mm-commits@vger.kernel.org,zhang.lyra@gmail.com,willy@infradead.org,will@kernel.org,m.szyprowski@samsung.com,lorenzo.stoakes@oracle.com,john@groves.net,jhubbard@nvidia.com,jgg@nvidia.com,hch@lst.de,gerald.schaefer@linux.ibm.com,debug@rivosinc.com,david@redhat.com,dan.j.williams@intel.com,bjorn@rivosinc.com,bjorn@kernel.org,balbirs@nvidia.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memremap-remove-unused-devmap_managed_key.patch removed from -mm tree
Message-Id: <20250710054557.5E0C3C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memremap: remove unused devmap_managed_key
has been removed from the -mm tree.  Its filename was
     mm-memremap-remove-unused-devmap_managed_key.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: mm/memremap: remove unused devmap_managed_key
Date: Thu, 19 Jun 2025 18:58:06 +1000

It's no longer used so remove it.

Link: https://lkml.kernel.org/r/11516e39f33f809292ffccab1d46062f9bc248b3.1750323463.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Björn Töpel <bjorn@kernel.org>
Cc: Björn Töpel <bjorn@rivosinc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chunyan Zhang <zhang.lyra@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Deepak Gupta <debug@rivosinc.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Inki Dae <m.szyprowski@samsung.com>
Cc: John Groves <john@groves.net>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memremap.c |   27 ---------------------------
 1 file changed, 27 deletions(-)

--- a/mm/memremap.c~mm-memremap-remove-unused-devmap_managed_key
+++ a/mm/memremap.c
@@ -38,30 +38,6 @@ unsigned long memremap_compat_align(void
 EXPORT_SYMBOL_GPL(memremap_compat_align);
 #endif
 
-#ifdef CONFIG_FS_DAX
-DEFINE_STATIC_KEY_FALSE(devmap_managed_key);
-EXPORT_SYMBOL(devmap_managed_key);
-
-static void devmap_managed_enable_put(struct dev_pagemap *pgmap)
-{
-	if (pgmap->type == MEMORY_DEVICE_FS_DAX)
-		static_branch_dec(&devmap_managed_key);
-}
-
-static void devmap_managed_enable_get(struct dev_pagemap *pgmap)
-{
-	if (pgmap->type == MEMORY_DEVICE_FS_DAX)
-		static_branch_inc(&devmap_managed_key);
-}
-#else
-static void devmap_managed_enable_get(struct dev_pagemap *pgmap)
-{
-}
-static void devmap_managed_enable_put(struct dev_pagemap *pgmap)
-{
-}
-#endif /* CONFIG_FS_DAX */
-
 static void pgmap_array_delete(struct range *range)
 {
 	xa_store_range(&pgmap_array, PHYS_PFN(range->start), PHYS_PFN(range->end),
@@ -150,7 +126,6 @@ void memunmap_pages(struct dev_pagemap *
 	percpu_ref_exit(&pgmap->ref);
 
 	WARN_ONCE(pgmap->altmap.alloc, "failed to free all reserved pages\n");
-	devmap_managed_enable_put(pgmap);
 }
 EXPORT_SYMBOL_GPL(memunmap_pages);
 
@@ -349,8 +324,6 @@ void *memremap_pages(struct dev_pagemap
 	if (error)
 		return ERR_PTR(error);
 
-	devmap_managed_enable_get(pgmap);
-
 	/*
 	 * Clear the pgmap nr_range as it will be incremented for each
 	 * successfully processed range. This communicates how many
_

Patches currently in -mm which might be from apopple@nvidia.com are


