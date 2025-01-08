Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05AB11A238C
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 06:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736317585; cv=none; b=Xp3oF7Pj+WZJ17Sw8iGxoh0fyru4MPx9CNCf96yDBgTRpOJHVYg5WcTfwK9kvXQ1wL1MQIKeY0/gNXMqG+rWiBOFwTdiUIyP222FBsutevJ7Fe2cIeQjTu4kRYhkzZIeBBIbp2f+TpmxaapohyMPl3f8ushWa/c5zQlLcNILtjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736317585; c=relaxed/simple;
	bh=XyoU2Dj3oZhaVMly5lEbCsOGoGujyTh8HU77VSjfsCg=;
	h=Date:To:From:Subject:Message-Id; b=pg7BDTFUPEEi07xnmpPQwgNn23nrItwKgrpDXnE42spOZGxIM+vV1UpII7wzdBUHcN6qxf7zasU4HhrFga2DdOCKaNd2DYxZ4Phuk4cqc6u9m++RE8QEkKzWSDqwfolA4dnEr3e/yvDEhlxUEFrHiJq5v7QiJ9kXO0OpDEiPyqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f9CAaXib; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f9CAaXib"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B29BC4CED0;
	Wed,  8 Jan 2025 06:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736317584;
	bh=XyoU2Dj3oZhaVMly5lEbCsOGoGujyTh8HU77VSjfsCg=;
	h=Date:To:From:Subject:From;
	b=f9CAaXibBplIL1o7qrmXKpPhWOFCu/AfZ9HTq+amwmjsEuGQpskon2ZJvzibOAuGj
	 MWsPy/v2pIZ58LatRIkyersoFIw5kEZbxoEjX+xVga1H0uxl6ygXDI/B9v6LJPQpGq
	 gFo6bJfENTvuCefQvRHerntLjqRdc10vVu2fiUCQ=
Date: Tue, 07 Jan 2025 22:26:23 -0800
To: mm-commits@vger.kernel.org,zhang.lyra@gmail.com,willy@infradead.org,will@kernel.org,vishal.l.verma@intel.com,vgoyal@redhat.com,tytso@mit.edu,peterx@redhat.com,npiggin@gmail.com,mpe@ellerman.id.au,logang@deltatee.com,linmiaohe@huawei.com,lina@asahilina.net,jhubbard@nvidia.com,jgg@ziepe.ca,jack@suse.cz,ira.weiny@intel.com,hch@lst.de,gerald.schaefer@linux.ibm.com,djwong@kernel.org,david@redhat.com,david@fromorbit.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,catalin.marinas@arm.com,bhelgaas@google.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fuse-fix-dax-truncate-punch_hole-fault-path.patch added to mm-unstable branch
Message-Id: <20250108062624.4B29BC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fuse: fix dax truncate/punch_hole fault path
has been added to the -mm mm-unstable branch.  Its filename is
     fuse-fix-dax-truncate-punch_hole-fault-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fuse-fix-dax-truncate-punch_hole-fault-path.patch

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
Subject: fuse: fix dax truncate/punch_hole fault path
Date: Tue, 7 Jan 2025 14:42:17 +1100

Patch series "fs/dax: Fix ZONE_DEVICE page reference counts", v5.

Device and FS DAX pages have always maintained their own page reference
counts without following the normal rules for page reference counting.  In
particular pages are considered free when the refcount hits one rather
than zero and refcounts are not added when mapping the page.

Tracking this requires special PTE bits (PTE_DEVMAP) and a secondary
mechanism for allowing GUP to hold references on the page (see
get_dev_pagemap).  However there doesn't seem to be any reason why FS DAX
pages need their own reference counting scheme.

By treating the refcounts on these pages the same way as normal pages we
can remove a lot of special checks.  In particular pXd_trans_huge()
becomes the same as pXd_leaf(), although I haven't made that change here. 
It also frees up a valuable SW define PTE bit on architectures that have
devmap PTE bits defined.

It also almost certainly allows further clean-up of the devmap managed
functions, but I have left that as a future improvment.  It also enables
support for compound ZONE_DEVICE pages which is one of my primary
motivators for doing this work.


This patch (of 25):

FS DAX requires file systems to call into the DAX layout prior to
unlinking inodes to ensure there is no ongoing DMA or other remote access
to the direct mapped page.  The fuse file system implements
fuse_dax_break_layouts() to do this which includes a comment indicating
that passing dmap_end == 0 leads to unmapping of the whole file.

However this is not true - passing dmap_end == 0 will not unmap anything
before dmap_start, and further more dax_layout_busy_page_range() will not
scan any of the range to see if there maybe ongoing DMA access to the
range.  Fix this by checking for dmap_end == 0 in fuse_dax_break_layouts()
and pass the entire file range to dax_layout_busy_page_range().

Link: https://lkml.kernel.org/r/cover.425da7c4e76c2749d0ad1734f972b06114e02d52.1736221254.git-series.apopple@nvidia.com
Link: https://lkml.kernel.org/r/f20cc2603bd33ee05ec4bc4cc7327cec61119796.1736221254.git-series.apopple@nvidia.com
Fixes: 6ae330cad6ef ("virtiofs: serialize truncate/punch_hole and dax fault path")
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Asahi Lina <lina@asahilina.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chunyan Zhang <zhang.lyra@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/dax.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/fuse/dax.c~fuse-fix-dax-truncate-punch_hole-fault-path
+++ a/fs/fuse/dax.c
@@ -693,6 +693,10 @@ int fuse_dax_break_layouts(struct inode
 		ret = __fuse_dax_break_layouts(inode, &retry, dmap_start,
 					       dmap_end);
 	} while (ret == 0 && retry);
+	if (!dmap_end) {
+		dmap_start = 0;
+		dmap_end = LLONG_MAX;
+	}
 
 	return ret;
 }
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
memremap-add-is_devdax_page-and-is_fsdax_page-helpers.patch
mm-gup-dont-allow-foll_longterm-pinning-of-fs-dax-pages.patch
proc-task_mmu-mark-devdax-and-fsdax-pages-as-always-unpinned.patch
mm-mlock-skip-zone_device-pmds-during-mlock.patch
fs-dax-properly-refcount-fs-dax-pages.patch
device-dax-properly-refcount-device-dax-pages-when-mapping.patch
mm-remove-pxx_devmap-callers.patch
mm-remove-devmap-related-functions-and-page-table-bits.patch
revert-riscv-mm-add-support-for-zone_device.patch

