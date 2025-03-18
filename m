Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F7D1A2658
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274493; cv=none; b=PDkq8xi0lS7PhvWhVpCyETEeDUXpH632oEe4MOWKfAomacAbb68OTH6KVB/yCwWUKsPRJq/b/uxj0DYegKeOuuewUQLd5wfRkYUOU0YuMGcKapjB/PB1pAU5F+ULIehVw4RRMQO+0LnmSKV/PnulnS+qfi5gSSZjXRa0Uz/ydt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274493; c=relaxed/simple;
	bh=S0V5rZJAiuQE4pqO208c2iZhLrb9/UIYBTUDCcn8Uyk=;
	h=Date:To:From:Subject:Message-Id; b=maw0UYIzMRxjaXKFhPrtLYYFof4qqkSMSTaCG19/1wReY3XRGTVCIznbCtFnMDhmAkaRaNlPtRlr8u28cP5oHxIJgFqnAUpM83sVdtl2Dqnu4YylEeGWcm79hBtfm+okq3eGvofuChXXVC8h9uz2duOrd0YmOGsGL3aCacgFFzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ScUt+cal; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ScUt+cal"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50D4CC4CEDD;
	Tue, 18 Mar 2025 05:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274493;
	bh=S0V5rZJAiuQE4pqO208c2iZhLrb9/UIYBTUDCcn8Uyk=;
	h=Date:To:From:Subject:From;
	b=ScUt+cal1kXohICn+7pBXuVpG7hV64Bj41iT1yz8bEvNGYbLuuTHhp8/YbxJmqCn9
	 WOgDPpAOU5ClG+hcGTmC4h8WLG9ybB0cwYrN7Dpq2LAgT7+iNdxlvnQFfwqTDd04cg
	 36PBbsg3V+hc6nUxxzhPyGoM0YsJsNlyrCmUMVrk=
Date: Mon, 17 Mar 2025 22:08:12 -0700
To: mm-commits@vger.kernel.org,zhang.lyra@gmail.com,willy@infradead.org,will@kernel.org,vishal.l.verma@intel.com,vgoyal@redhat.com,tytso@mit.edu,svens@linux.ibm.com,peterx@redhat.com,npiggin@gmail.com,mpe@ellerman.id.au,logang@deltatee.com,linmiaohe@huawei.com,lina@asahilina.net,kernel@xen0n.name,jhubbard@nvidia.com,jgg@ziepe.ca,jgg@nvidia.com,jack@suse.cz,ira.weiny@intel.com,hch@lst.de,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,djwong@kernel.org,david@redhat.com,david@fromorbit.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,chenhuacai@kernel.org,catalin.marinas@arm.com,borntraeger@linux.ibm.com,bhelgaas@google.com,balbirs@nvidia.com,alison.schofield@intel.com,agordeev@linux.ibm.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-remove-redundant-check-for-pci-p2pdma-page.patch removed from -mm tree
Message-Id: <20250318050813.50D4CC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/gup: remove redundant check for PCI P2PDMA page
has been removed from the -mm tree.  Its filename was
     mm-gup-remove-redundant-check-for-pci-p2pdma-page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: mm/gup: remove redundant check for PCI P2PDMA page
Date: Fri, 28 Feb 2025 14:31:04 +1100

PCI P2PDMA pages are not mapped with pXX_devmap PTEs therefore the check
in __gup_device_huge() is redundant.  Remove it

Link: https://lkml.kernel.org/r/260e3dcfaf05ff1c734a49698ed4332b5dae04c2.1740713401.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Dan Wiliams <dan.j.williams@intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Tested-by: Alison Schofield <alison.schofield@intel.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Asahi Lina <lina@asahilina.net>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chunyan Zhang <zhang.lyra@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: linmiaohe <linmiaohe@huawei.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Michael "Camp Drill Sergeant" Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Ted Ts'o <tytso@mit.edu>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/mm/gup.c~mm-gup-remove-redundant-check-for-pci-p2pdma-page
+++ a/mm/gup.c
@@ -3013,11 +3013,6 @@ static int gup_fast_devmap_leaf(unsigned
 			break;
 		}
 
-		if (!(flags & FOLL_PCI_P2PDMA) && is_pci_p2pdma_page(page)) {
-			gup_fast_undo_dev_pagemap(nr, nr_start, flags, pages);
-			break;
-		}
-
 		folio = try_grab_folio_fast(page, 1, flags);
 		if (!folio) {
 			gup_fast_undo_dev_pagemap(nr, nr_start, flags, pages);
_

Patches currently in -mm which might be from apopple@nvidia.com are


