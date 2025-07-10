Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73BD922154B
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126335; cv=none; b=m46/IvrHZmezWTabL3mq5AFlw3WBZP4NTyE7/G9k/IsBbNXLrWTpfdXCpk3O/mViPUVnPl0lgfPnEXTL2YRAEdKPTg2eQ4N0F5j+yr15ybAWegUg3C6VQYCpPsWyrnkTK2dka8R5DfjGmy0efD8lLkt2DSkdjDH0UVILuB9NnT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126335; c=relaxed/simple;
	bh=wFneRw1WwoAUAGtt57sd9lX5lHNFecmJpYC5vslLKfw=;
	h=Date:To:From:Subject:Message-Id; b=ZkvrFGt2u1ibkpHOva9ZaAFBkLC0Zd5mSABopIn5Vxc3NTom0UR4V9ASCoIVhNmg7gnSdvCI8vUlQb0NRZY7MRLRm9DauJnHVhrNoGbLV7edHFGOmUr1daMpMzCWkrRg82KS7gVVujxjMII7awUM8ShZc8Zxt4fXlmTxcQ7AixE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V1bAS4v6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V1bAS4v6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F0DC4CEE3;
	Thu, 10 Jul 2025 05:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126335;
	bh=wFneRw1WwoAUAGtt57sd9lX5lHNFecmJpYC5vslLKfw=;
	h=Date:To:From:Subject:From;
	b=V1bAS4v65wqjKu/nGnW/oz0tJReldR4eBwcotzO2Upfoac60Z9sM2yCOGPNXF7+q+
	 bOhUeYlDQCrKHZOjhH9jie1ZVCQhoHzwmFH6IBszNz+ARalCa8nB3Tpe73ncEgO8ji
	 SDXn71OqGHCT7FCUY7i95BFRh6K5XwJwmQfEwVcc=
Date: Wed, 09 Jul 2025 22:45:34 -0700
To: mm-commits@vger.kernel.org,zhang.lyra@gmail.com,willy@infradead.org,will@kernel.org,m.szyprowski@samsung.com,lorenzo.stoakes@oracle.com,john@groves.net,jhubbard@nvidia.com,jgg@nvidia.com,hch@lst.de,gerald.schaefer@linux.ibm.com,debug@rivosinc.com,david@redhat.com,dan.j.williams@intel.com,bjorn@rivosinc.com,bjorn@kernel.org,balbirs@nvidia.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-filter-zone-device-pages-returned-from-folio_walk_start.patch removed from -mm tree
Message-Id: <20250710054535.48F0DC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: filter zone device pages returned from folio_walk_start()
has been removed from the -mm tree.  Its filename was
     mm-filter-zone-device-pages-returned-from-folio_walk_start.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: mm: filter zone device pages returned from folio_walk_start()
Date: Thu, 19 Jun 2025 18:57:54 +1000

Previously dax pages were skipped by the pagewalk code as pud_special() or
vm_normal_page{_pmd}() would be false for DAX pages.  Now that dax pages
are refcounted normally that is no longer the case, so the pagewalk code
will start returning them.

Most callers already explicitly filter for DAX or zone device pages so
don't need updating.  However some don't, so add checks to those callers.

Link: https://lkml.kernel.org/r/4ecb7b357fc5b435588024770b88bbb695c30090.1750323463.git-series.apopple@nvidia.com
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

 kernel/events/uprobes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/events/uprobes.c~mm-filter-zone-device-pages-returned-from-folio_walk_start
+++ a/kernel/events/uprobes.c
@@ -539,7 +539,7 @@ retry:
 	}
 
 	ret = 0;
-	if (unlikely(!folio_test_anon(folio))) {
+	if (unlikely(!folio_test_anon(folio) || folio_is_zone_device(folio))) {
 		VM_WARN_ON_ONCE(is_register);
 		folio_put(folio);
 		goto out;
_

Patches currently in -mm which might be from apopple@nvidia.com are


