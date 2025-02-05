Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE241E505
	for <mm-commits@vger.kernel.org>; Wed,  5 Feb 2025 02:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738721755; cv=none; b=kNHvz2glW2tuI2Ayv7NDtViO4x14BHxRK6B6t1AcGBkNwf0EIOgsrmnpDURVAhb2iqLK3jFk8p/1YqcHMJ/M7/RfZljjJ4XdaDOfrK8SC6PE2sz0XoDexO8SDPTs3ua0Jgcv7+18IhbaaZ1mR88DTDa0W8LG/8HxtAJqp+DsUiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738721755; c=relaxed/simple;
	bh=6BaYYgWH5H+5kBIsuT0NF664mgqz+KTghBv9e3y1txo=;
	h=Date:To:From:Subject:Message-Id; b=HF+w808N1pupOZEdjEn6bgBNI3gFiyKdwD2rZv31hHsfshGnEwZcmt5fQjL0KtqAAyrqyALgsl6tCwPb8AZS1iPoQ6WArzuh6d4DMMds3jgZ/AHKUyOkXIC60Kwb6IoQL9VeflpST4EVP9erF4bzs/vciTm9+DyLS38FHOqmsk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RCOWMKm5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RCOWMKm5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9785C4CEE4;
	Wed,  5 Feb 2025 02:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738721754;
	bh=6BaYYgWH5H+5kBIsuT0NF664mgqz+KTghBv9e3y1txo=;
	h=Date:To:From:Subject:From;
	b=RCOWMKm59ltzW0Cf/WT2nxQIzOjCa3fNEatRtW/kysf091IjGcHiPsMoW/Uis8Rfp
	 u1vlALDcoFtTqdKNuzWa+6LNCzwqzv5c8/QWXc+2mZeTekVxmMOXE2+YinAticTMy+
	 a4nYEuLRWRmP3xi2S0pjS6PawHSNa7ov/hEiBoFk=
Date: Tue, 04 Feb 2025 18:15:53 -0800
To: mm-commits@vger.kernel.org,zhang.lyra@gmail.com,willy@infradead.org,will@kernel.org,vishal.l.verma@intel.com,vgoyal@redhat.com,tytso@mit.edu,svens@linux.ibm.com,peterx@redhat.com,npiggin@gmail.com,mpe@ellerman.id.au,logang@deltatee.com,linmiaohe@huawei.com,lina@asahilina.net,kernel@xen0n.name,jhubbard@nvidia.com,jgg@ziepe.ca,jgg@nvidia.com,jack@suse.cz,ira.weiny@intel.com,hch@lst.de,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,djwong@kernel.org,david@redhat.com,david@fromorbit.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,chenhuacai@kernel.org,catalin.marinas@arm.com,borntraeger@linux.ibm.com,bhelgaas@google.com,alison.schofield@intel.com,agordeev@linux.ibm.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-dax-return-unmapped-busy-pages-from-dax_layout_busy_page_range.patch added to mm-unstable branch
Message-Id: <20250205021553.D9785C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/dax: return unmapped busy pages from dax_layout_busy_page_range()
has been added to the -mm mm-unstable branch.  Its filename is
     fs-dax-return-unmapped-busy-pages-from-dax_layout_busy_page_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-dax-return-unmapped-busy-pages-from-dax_layout_busy_page_range.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: fs/dax: return unmapped busy pages from dax_layout_busy_page_range()
Date: Wed, 5 Feb 2025 09:47:59 +1100

dax_layout_busy_page_range() is used by file systems to scan the DAX
page-cache to unmap mapping pages from user-space and to determine if any
pages in the given range are busy, either due to ongoing DMA or other
get_user_pages() usage.

Currently it checks to see the file mapping is mapped into user-space with
mapping_mapped() and returns early if not, skipping the check for DMA busy
pages.  This is wrong as pages may still be undergoing DMA access even if
they have subsequently been unmapped from user-space.  Fix this by
dropping the check for mapping_mapped().

Link: https://lkml.kernel.org/r/23432568750f099d32b473f64b7e35f0671d429e.1738709036.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
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
Cc: Mattew Wilcox <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
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
@@ -690,7 +690,7 @@ struct page *dax_layout_busy_page_range(
 	if (IS_ENABLED(CONFIG_FS_DAX_LIMITED))
 		return NULL;
 
-	if (!dax_mapping(mapping) || !mapping_mapped(mapping))
+	if (!dax_mapping(mapping))
 		return NULL;
 
 	/* If end == LLONG_MAX, all pages from start to till end of file */
_

Patches currently in -mm which might be from apopple@nvidia.com are

fuse-fix-dax-truncate-punch_hole-fault-path.patch
fs-dax-return-unmapped-busy-pages-from-dax_layout_busy_page_range.patch
fs-dax-dont-skip-locked-entries-when-scanning-entries.patch
fs-dax-refactor-wait-for-dax-idle-page.patch
fs-dax-create-a-common-implementation-to-break-dax-layouts.patch
fs-dax-always-remove-dax-page-cache-entries-when-breaking-layouts.patch
fs-dax-ensure-all-pages-are-idle-prior-to-filesystem-unmount.patch
fs-dax-remove-page_mapping_dax_shared-mapping-flag.patch
mm-gup-remove-redundant-check-for-pci-p2pdma-page.patch
mm-mm_init-move-p2pdma-page-refcount-initialisation-to-p2pdma.patch
mm-allow-compound-zone-device-pages.patch
mm-memory-enhance-insert_page_into_pte_locked-to-create-writable-mappings.patch
mm-memory-add-vmf_insert_page_mkwrite.patch
rmap-add-support-for-pud-sized-mappings-to-rmap.patch
huge_memory-add-vmf_insert_folio_pud.patch
huge_memory-add-vmf_insert_folio_pmd.patch
mm-gup-dont-allow-foll_longterm-pinning-of-fs-dax-pages.patch
fs-dax-properly-refcount-fs-dax-pages.patch
device-dax-properly-refcount-device-dax-pages-when-mapping.patch

