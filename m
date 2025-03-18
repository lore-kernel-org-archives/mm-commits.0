Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4764D1922D4
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274478; cv=none; b=ZrpZy8Tsc6SAqWYci6sLmMTzcs6dMKCu+r4oENenlx/pQvCvxgeQ3x3/VQ9/cAbuVrKVnghF5aWXiV+iMuK6IuWYVXgKcTTk9D9sY9n5T757ffjh35kq0IUOcvlLd+NbX79YvUxOcllTO91osrugDTDw52fuBPJPIu08ceVW+ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274478; c=relaxed/simple;
	bh=9B4n0j1KcGM527AC7g9eK5maDyAwuFhGlmJsyBtTb9Q=;
	h=Date:To:From:Subject:Message-Id; b=CN/Ip7Yv+wXMc8oo5jKHDr5Zro2oFfJRBznCcC/X8vMQnCedcM2LIidC8/7yw6MV+oxIrpVONy7QujS8mu5r/3RDoOQJ00Qyoy8fGxmUoGXX7k683x4pe2ZqUro9xGwN+w8fXhKlkTXgBYX1mHm1fvn3QFkK7Mz8qshMhO14maA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p/nfPsiU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p/nfPsiU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F2DFC4CEDD;
	Tue, 18 Mar 2025 05:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274477;
	bh=9B4n0j1KcGM527AC7g9eK5maDyAwuFhGlmJsyBtTb9Q=;
	h=Date:To:From:Subject:From;
	b=p/nfPsiUTi/J3O92Rm4z++FYHLWB7qFDx3O9RHmq9uLQ58hj20EYIRpvhETOuZavC
	 V+ta1wJPCJ+4AZWH/lAPu2qk2uiqo3/O3nIg8x8nb27GOD6oMpr0xMKfXmt/Crnl57
	 s00iWPKxyrdE6y4JDUYLEoHRZhZaiPf4pDQ45N+I=
Date: Mon, 17 Mar 2025 22:07:57 -0700
To: mm-commits@vger.kernel.org,zhang.lyra@gmail.com,willy@infradead.org,will@kernel.org,vishal.l.verma@intel.com,vgoyal@redhat.com,tytso@mit.edu,svens@linux.ibm.com,peterx@redhat.com,npiggin@gmail.com,mpe@ellerman.id.au,logang@deltatee.com,linmiaohe@huawei.com,lina@asahilina.net,kernel@xen0n.name,jhubbard@nvidia.com,jgg@ziepe.ca,jgg@nvidia.com,jack@suse.cz,ira.weiny@intel.com,hch@lst.de,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,djwong@kernel.org,david@redhat.com,david@fromorbit.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,chenhuacai@kernel.org,catalin.marinas@arm.com,borntraeger@linux.ibm.com,bhelgaas@google.com,balbirs@nvidia.com,alison.schofield@intel.com,agordeev@linux.ibm.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fuse-fix-dax-truncate-punch_hole-fault-path.patch removed from -mm tree
Message-Id: <20250318050757.9F2DFC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fuse: fix dax truncate/punch_hole fault path
has been removed from the -mm tree.  Its filename was
     fuse-fix-dax-truncate-punch_hole-fault-path.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: fuse: fix dax truncate/punch_hole fault path
Date: Fri, 28 Feb 2025 14:30:56 +1100

Patch series "fs/dax: Fix ZONE_DEVICE page reference counts", v9.

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


This patch (of 20):

FS DAX requires file systems to call into the DAX layout prior to
unlinking inodes to ensure there is no ongoing DMA or other remote access
to the direct mapped page.  The fuse file system implements
fuse_dax_break_layouts() to do this which includes a comment indicating
that passing dmap_end == 0 leads to unmapping of the whole file.

However this is not true - passing dmap_end == 0 will not unmap anything
before dmap_start, and further more dax_layout_busy_page_range() will not
scan any of the range to see if there maybe ongoing DMA access to the
range.  Fix this by passing -1 for dmap_end to fuse_dax_break_layouts()
which will invalidate the entire file range to
dax_layout_busy_page_range().

Link: https://lkml.kernel.org/r/cover.8068ad144a7eea4a813670301f4d2a86a8e68ec4.1740713401.git-series.apopple@nvidia.com
Link: https://lkml.kernel.org/r/f09a34b6c40032022e4ddee6fadb7cc676f08867.1740713401.git-series.apopple@nvidia.com
Fixes: 6ae330cad6ef ("virtiofs: serialize truncate/punch_hole and dax fault path")
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Co-developed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Tested-by: Alison Schofield <alison.schofield@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
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
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/dax.c  |    1 -
 fs/fuse/dir.c  |    2 +-
 fs/fuse/file.c |    4 ++--
 3 files changed, 3 insertions(+), 4 deletions(-)

--- a/fs/fuse/dax.c~fuse-fix-dax-truncate-punch_hole-fault-path
+++ a/fs/fuse/dax.c
@@ -682,7 +682,6 @@ static int __fuse_dax_break_layouts(stru
 			0, 0, fuse_wait_dax_page(inode));
 }
 
-/* dmap_end == 0 leads to unmapping of whole file */
 int fuse_dax_break_layouts(struct inode *inode, u64 dmap_start,
 				  u64 dmap_end)
 {
--- a/fs/fuse/dir.c~fuse-fix-dax-truncate-punch_hole-fault-path
+++ a/fs/fuse/dir.c
@@ -1940,7 +1940,7 @@ int fuse_do_setattr(struct mnt_idmap *id
 	if (FUSE_IS_DAX(inode) && is_truncate) {
 		filemap_invalidate_lock(mapping);
 		fault_blocked = true;
-		err = fuse_dax_break_layouts(inode, 0, 0);
+		err = fuse_dax_break_layouts(inode, 0, -1);
 		if (err) {
 			filemap_invalidate_unlock(mapping);
 			return err;
--- a/fs/fuse/file.c~fuse-fix-dax-truncate-punch_hole-fault-path
+++ a/fs/fuse/file.c
@@ -253,7 +253,7 @@ static int fuse_open(struct inode *inode
 
 	if (dax_truncate) {
 		filemap_invalidate_lock(inode->i_mapping);
-		err = fuse_dax_break_layouts(inode, 0, 0);
+		err = fuse_dax_break_layouts(inode, 0, -1);
 		if (err)
 			goto out_inode_unlock;
 	}
@@ -3205,7 +3205,7 @@ static long fuse_file_fallocate(struct f
 	inode_lock(inode);
 	if (block_faults) {
 		filemap_invalidate_lock(inode->i_mapping);
-		err = fuse_dax_break_layouts(inode, 0, 0);
+		err = fuse_dax_break_layouts(inode, 0, -1);
 		if (err)
 			goto out;
 	}
_

Patches currently in -mm which might be from apopple@nvidia.com are


