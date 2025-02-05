Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB22625A65D
	for <mm-commits@vger.kernel.org>; Wed,  5 Feb 2025 02:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738721806; cv=none; b=SrKgSzS7fqVX9xGxYe0MxiEEMr8tSubde1LvsJnPONx3xTxq2G/z16QYtK2E1x54bnsIRE3ZJQBmvqdSP5uVMRngYWrd4HhR6qg5YW0DIySqzkn3UaduIL2bTHjAQFOfaok+8HPJnfVXfX6FvnG5/Ox/riglqhS9hD89pgjCLus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738721806; c=relaxed/simple;
	bh=t2IIPQSfAeVXkZ9ESLYend/z4riRmCFUEL2N63eBLeI=;
	h=Date:To:From:Subject:Message-Id; b=J5yuUpfpncExIf2bB8+p0kPA+oNJAv2RkvKRI7e8pePpW5HfTSx14RFdOzs3ZLDYhjBqCpTJ2rA7qRo0aPY3hrVx6ySiBXDxZsD2BGuv5WDvhm/KSxmgZwCTfqjPmfAxFdhw2KE6x1Cbw6wMO3lbsKBaqKmZa8gUEKI46NEGp68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gdKsPRtd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gdKsPRtd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E3DC4CEDF;
	Wed,  5 Feb 2025 02:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738721804;
	bh=t2IIPQSfAeVXkZ9ESLYend/z4riRmCFUEL2N63eBLeI=;
	h=Date:To:From:Subject:From;
	b=gdKsPRtdcOx/gNpOhU/G41mlODZ5W1e9xxkDaR6VVxRQNjjyxqUOVskZaKJby6LYZ
	 5SVoLhXqqGV9X1k/GMZdHYR1PP8TDQEJeEna4PF99dWmXEY6BoO29Ba1QGXU1frWZK
	 YwYvOoPKISvEjDP9eAxBLGRc8N4M6Rb56AuPRCl8=
Date: Tue, 04 Feb 2025 18:16:43 -0800
To: mm-commits@vger.kernel.org,zhang.lyra@gmail.com,willy@infradead.org,will@kernel.org,vishal.l.verma@intel.com,vgoyal@redhat.com,tytso@mit.edu,svens@linux.ibm.com,peterx@redhat.com,npiggin@gmail.com,mpe@ellerman.id.au,logang@deltatee.com,linmiaohe@huawei.com,lina@asahilina.net,kernel@xen0n.name,jhubbard@nvidia.com,jgg@ziepe.ca,jgg@nvidia.com,jack@suse.cz,ira.weiny@intel.com,hch@lst.de,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,djwong@kernel.org,david@redhat.com,david@fromorbit.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,chenhuacai@kernel.org,catalin.marinas@arm.com,borntraeger@linux.ibm.com,bhelgaas@google.com,alison.schofield@intel.com,agordeev@linux.ibm.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-dont-allow-foll_longterm-pinning-of-fs-dax-pages.patch added to mm-unstable branch
Message-Id: <20250205021644.28E3DC4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/gup: don't allow FOLL_LONGTERM pinning of FS DAX pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-dont-allow-foll_longterm-pinning-of-fs-dax-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-dont-allow-foll_longterm-pinning-of-fs-dax-pages.patch

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
Subject: mm/gup: don't allow FOLL_LONGTERM pinning of FS DAX pages
Date: Wed, 5 Feb 2025 09:48:14 +1100

Longterm pinning of FS DAX pages should already be disallowed by various
pXX_devmap checks.  However a future change will cause these checks to be
invalid for FS DAX pages so make folio_is_longterm_pinnable() return false
for FS DAX pages.

Link: https://lkml.kernel.org/r/76dec7814edcc56d29be711b2cd344fc98cc66e4.1738709036.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
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
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
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

 include/linux/memremap.h |   11 +++++++++++
 include/linux/mm.h       |    7 +++++++
 2 files changed, 18 insertions(+)

--- a/include/linux/memremap.h~mm-gup-dont-allow-foll_longterm-pinning-of-fs-dax-pages
+++ a/include/linux/memremap.h
@@ -187,6 +187,17 @@ static inline bool folio_is_device_coher
 	return is_device_coherent_page(&folio->page);
 }
 
+static inline bool is_fsdax_page(const struct page *page)
+{
+	return is_zone_device_page(page) &&
+		page_pgmap(page)->type == MEMORY_DEVICE_FS_DAX;
+}
+
+static inline bool folio_is_fsdax(const struct folio *folio)
+{
+	return is_fsdax_page(&folio->page);
+}
+
 #ifdef CONFIG_ZONE_DEVICE
 void zone_device_page_init(struct page *page);
 void *memremap_pages(struct dev_pagemap *pgmap, int nid);
--- a/include/linux/mm.h~mm-gup-dont-allow-foll_longterm-pinning-of-fs-dax-pages
+++ a/include/linux/mm.h
@@ -2015,6 +2015,13 @@ static inline bool folio_is_longterm_pin
 	if (folio_is_device_coherent(folio))
 		return false;
 
+	/*
+	 * Filesystems can only tolerate transient delays to truncate and
+	 * hole-punch operations
+	 */
+	if (folio_is_fsdax(folio))
+		return false;
+
 	/* Otherwise, non-movable zone folios can be pinned. */
 	return !folio_is_zone_movable(folio);
 
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

