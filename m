Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C03D285C93
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126346; cv=none; b=ieIoVl4LvVLvtaDakBeIz0QJq/N/ocR8RQ+JZbvSnyPz96QScM2wDJz8sEgy+DBdLxnk7Eb5bcdRDz0l0LJOm29l+oB7aYpkM3d81zisk/inZALI2jJuNuFbK0QfOY+b6sN44GRqHtu3afmsCzxh4NirCpCufK5x4VRN7JFbtk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126346; c=relaxed/simple;
	bh=pa2kEI1WfBR8fzB6LnCgz8H6Hr/rJ33G77S5rw0gzH0=;
	h=Date:To:From:Subject:Message-Id; b=loNqObauvZK2Y/3Wzm0+SH1C08hgm63WKVA98Rn+hAnLkzds5UmA06G1GwfoZtavs3yrZJ1KxJjSBcRt470xVUkcZehOqpCxlJCCl/X4GD+8BBeiXQuZenGYroDm7HhgM/SL9p7FxV7/t6b/MZ3UUQtWZnXW9+uaoDFGeNo39dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HLP6Dxia; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HLP6Dxia"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F035C4CEF4;
	Thu, 10 Jul 2025 05:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126346;
	bh=pa2kEI1WfBR8fzB6LnCgz8H6Hr/rJ33G77S5rw0gzH0=;
	h=Date:To:From:Subject:From;
	b=HLP6DxiapWU7HABl8JmqGKPNmvffeSKz9IjiNzuWcWQbElOBkXXgByoC8K4lTSRZT
	 cwOy7G33pP71BmpE/SQYfoN2M0CKpQ8UrRgaxmcbf6EjV6cJva3OygB0Zk4Fct4b1m
	 E/9koKhiXTDUJcnk3Mzc+zFEUXG1U1wwVO6gq3yA=
Date: Wed, 09 Jul 2025 22:45:45 -0700
To: mm-commits@vger.kernel.org,zhang.lyra@gmail.com,willy@infradead.org,will@kernel.org,m.szyprowski@samsung.com,lorenzo.stoakes@oracle.com,john@groves.net,jhubbard@nvidia.com,jgg@nvidia.com,hch@lst.de,gerald.schaefer@linux.ibm.com,debug@rivosinc.com,david@redhat.com,dan.j.williams@intel.com,bjorn@rivosinc.com,bjorn@kernel.org,balbirs@nvidia.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-remove-redundant-pmd_devmap-check.patch removed from -mm tree
Message-Id: <20250710054546.6F035C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: remove redundant pmd_devmap() check
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-remove-redundant-pmd_devmap-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: mm/khugepaged: remove redundant pmd_devmap() check
Date: Thu, 19 Jun 2025 18:58:00 +1000

The pmd_devmap() check in check_pmd_state() is redundant because the only
user of pmd_devmap were device dax and fs dax.  However all callers of
check_pmd_state() first call thp_vma_allowable_order() to check if the vma
should be scanned.  Except when called from a page fault this always
returns 0 for dax vma's, hence we would never expect to see a pmd_devmap
entry.

Link: https://lkml.kernel.org/r/a68175fd3a37e9b72cc82c1d63fd8b69691a85b5.1750323463.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
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

 mm/khugepaged.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-remove-redundant-pmd_devmap-check
+++ a/mm/khugepaged.c
@@ -945,8 +945,6 @@ static inline int check_pmd_state(pmd_t
 		return SCAN_PMD_NULL;
 	if (pmd_trans_huge(pmde))
 		return SCAN_PMD_MAPPED;
-	if (pmd_devmap(pmde))
-		return SCAN_PMD_NULL;
 	if (pmd_bad(pmde))
 		return SCAN_PMD_NULL;
 	return SCAN_SUCCEED;
_

Patches currently in -mm which might be from apopple@nvidia.com are


