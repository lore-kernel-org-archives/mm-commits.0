Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BB5D1922D4
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274480; cv=none; b=Rh6d8RTxMaEbClpMf8F9NnA5FhYXNvmLI0z/cui4eRJyd1MBkpmvZhD1rKSgQuk9E0EzHI/agAHslOuXpTdS3LzTQcFKoB2JnfljqPVlxcD4u3OacGEZMI+kAJ/FcfslY9bugDKQmtqep8k6zVYQ7les28rzpUoQ4j0Z7NyPNBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274480; c=relaxed/simple;
	bh=LU5TgHECb+/U/f81lMGP32auxLAXucnAfPr5JUTJ0iY=;
	h=Date:To:From:Subject:Message-Id; b=i44/rZlb3jzCmPJ8k+3FZNJZQvOV3IrGwKYOrAKEVcWfGyu6wE7bfc/bsItCYudCGLc2zpuqDenfLaKFI7v95yEjHr2m+wfmw1P0VrbhtT6XgmNA72TPWz70NSY4nB4Lb7kS1LfAcSSS9A2vi/MBY5Dh/lxoR9ur63M14SPap+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zP4KnInR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zP4KnInR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EAAEC4CEDD;
	Tue, 18 Mar 2025 05:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274479;
	bh=LU5TgHECb+/U/f81lMGP32auxLAXucnAfPr5JUTJ0iY=;
	h=Date:To:From:Subject:From;
	b=zP4KnInRWAqov1qtdPsKB9s5BsL4N3+OsIdAcS6fRYnj/SqE2CKrsg67P6ix2JRuo
	 Yyf271bFe5/F29/IsLwfGB2QdrPGfRP91OQaLC4A0wyEzE6gqVafwKiNAZgUYRsHZA
	 OSLzvR/Rq51CvbRCkb8yWuHEm2mj9S5GyuAF0yBs=
Date: Mon, 17 Mar 2025 22:07:58 -0700
To: mm-commits@vger.kernel.org,zhang.lyra@gmail.com,willy@infradead.org,will@kernel.org,vishal.l.verma@intel.com,vgoyal@redhat.com,tytso@mit.edu,svens@linux.ibm.com,peterx@redhat.com,npiggin@gmail.com,mpe@ellerman.id.au,logang@deltatee.com,linmiaohe@huawei.com,lina@asahilina.net,kernel@xen0n.name,jhubbard@nvidia.com,jgg@ziepe.ca,jgg@nvidia.com,jack@suse.cz,ira.weiny@intel.com,hch@lst.de,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,djwong@kernel.org,david@redhat.com,david@fromorbit.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,chenhuacai@kernel.org,catalin.marinas@arm.com,borntraeger@linux.ibm.com,bhelgaas@google.com,balbirs@nvidia.com,alison.schofield@intel.com,agordeev@linux.ibm.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-dax-return-unmapped-busy-pages-from-dax_layout_busy_page_range.patch removed from -mm tree
Message-Id: <20250318050759.6EAAEC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/dax: return unmapped busy pages from dax_layout_busy_page_range()
has been removed from the -mm tree.  Its filename was
     fs-dax-return-unmapped-busy-pages-from-dax_layout_busy_page_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: fs/dax: return unmapped busy pages from dax_layout_busy_page_range()
Date: Fri, 28 Feb 2025 14:30:57 +1100

dax_layout_busy_page_range() is used by file systems to scan the DAX
page-cache to unmap mapping pages from user-space and to determine if any
pages in the given range are busy, either due to ongoing DMA or other
get_user_pages() usage.

Currently it checks to see the file mapping is mapped into user-space with
mapping_mapped() and returns early if not, skipping the check for DMA busy
pages.  This is wrong as pages may still be undergoing DMA access even if
they have subsequently been unmapped from user-space.  Fix this by
dropping the check for mapping_mapped().

Link: https://lkml.kernel.org/r/d85ce6c2d1400ff111ed7302d9eef223d0243c57.1740713401.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Tested-by: Alison Schofield <alison.schofield@intel.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Asahi Lina <lina@asahilina.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chunyan Zhang <zhang.lyra@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jason Gunthorpe <jgg@nvidia.com>
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

 fs/dax.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/dax.c~fs-dax-return-unmapped-busy-pages-from-dax_layout_busy_page_range
+++ a/fs/dax.c
@@ -691,7 +691,7 @@ struct page *dax_layout_busy_page_range(
 	if (IS_ENABLED(CONFIG_FS_DAX_LIMITED))
 		return NULL;
 
-	if (!dax_mapping(mapping) || !mapping_mapped(mapping))
+	if (!dax_mapping(mapping))
 		return NULL;
 
 	/* If end == LLONG_MAX, all pages from start to till end of file */
_

Patches currently in -mm which might be from apopple@nvidia.com are


