Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E6EE1C5D6C
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274487; cv=none; b=pbY3JVopwIJFn7/YEFddrvw3+g1A/a6VgvFM5ehQxY/l7WTL8CAzcMFjtFAYDkPSaoNKMntIBOwwOQAL1gcxi8whwKiTrimd9dNcO/AJ0zU5pl98PA5BAD8ASVhpjkP0OOxyYnMWUoDE5W8ymjOEjS3SNuuFkbT1cWcoCbeqV/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274487; c=relaxed/simple;
	bh=e8BnlzY+FbMHylzW9lA0S74c0YAbO60M64XqJyB3xBk=;
	h=Date:To:From:Subject:Message-Id; b=RB4HD8VJP8jChaZdM3vRJkW0nFKnBKtZ4GBPPtsZ5sEsLzcfLvhS+zW/64mPcgIRWBZH3SPhvgS/+QYjDJWJSzODn4gGQdLETRwZ3IjK+i8T2jDdqRYgOCjAcDU2fV6tVKKTtqgo0T2ARQYVYTHFM1ah8SsmxmBQTqFroV054Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sQzV8E5B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sQzV8E5B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DB7FC4CEDD;
	Tue, 18 Mar 2025 05:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274487;
	bh=e8BnlzY+FbMHylzW9lA0S74c0YAbO60M64XqJyB3xBk=;
	h=Date:To:From:Subject:From;
	b=sQzV8E5B5kmudPH6Ik7OBIUvnf9Bndx0U4KBzuPVykGIAW/nXaba5qxCdZNbCRJLd
	 GwvvCQYSqTNpyRGUM05ChLdH3bCOFIfJmfLhCvrCPMPk0Zk4Zj+I5aJ6CN3rIyMEca
	 5kfooFQ0XGRr5ZkHBYidHzOCBL7K80uYL4/0UDaY=
Date: Mon, 17 Mar 2025 22:08:06 -0700
To: mm-commits@vger.kernel.org,zhang.lyra@gmail.com,willy@infradead.org,will@kernel.org,vishal.l.verma@intel.com,vgoyal@redhat.com,tytso@mit.edu,svens@linux.ibm.com,peterx@redhat.com,npiggin@gmail.com,mpe@ellerman.id.au,logang@deltatee.com,linmiaohe@huawei.com,lina@asahilina.net,kernel@xen0n.name,jhubbard@nvidia.com,jgg@ziepe.ca,jgg@nvidia.com,jack@suse.cz,ira.weiny@intel.com,hch@lst.de,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,djwong@kernel.org,david@redhat.com,david@fromorbit.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,chenhuacai@kernel.org,catalin.marinas@arm.com,borntraeger@linux.ibm.com,bhelgaas@google.com,balbirs@nvidia.com,alison.schofield@intel.com,agordeev@linux.ibm.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-dax-always-remove-dax-page-cache-entries-when-breaking-layouts.patch removed from -mm tree
Message-Id: <20250318050807.0DB7FC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/dax: always remove DAX page-cache entries when breaking layouts
has been removed from the -mm tree.  Its filename was
     fs-dax-always-remove-dax-page-cache-entries-when-breaking-layouts.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: fs/dax: always remove DAX page-cache entries when breaking layouts
Date: Fri, 28 Feb 2025 14:31:01 +1100

Prior to any truncation operations file systems call dax_break_mapping()
to ensure pages in the range are not under going DMA.  Later DAX
page-cache entries will be removed by truncate_folio_batch_exceptionals()
in the generic page-cache code.

However this makes it possible for folios to be removed from the
page-cache even though they are still DMA busy if the file-system hasn't
called dax_break_mapping().  It also means they can never be waited on in
future because FS DAX will lose track of them once the page-cache entry
has been deleted.

Instead it is better to delete the FS DAX entry when the file-system calls
dax_break_mapping() as part of it's truncate operation.  This ensures only
idle pages can be removed from the FS DAX page-cache and makes it easy to
detect if a file-system hasn't called dax_break_mapping() prior to a
truncate operation.

Link: https://lkml.kernel.org/r/3be6115eaaa8d28fee37fcba3287be4f226a7d24.1740713401.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
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

 fs/dax.c            |   40 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.c  |    5 ++---
 include/linux/dax.h |    2 ++
 mm/truncate.c       |   16 +++++++++++++++-
 4 files changed, 59 insertions(+), 4 deletions(-)

--- a/fs/dax.c~fs-dax-always-remove-dax-page-cache-entries-when-breaking-layouts
+++ a/fs/dax.c
@@ -846,6 +846,36 @@ int dax_delete_mapping_entry(struct addr
 	return ret;
 }
 
+void dax_delete_mapping_range(struct address_space *mapping,
+				loff_t start, loff_t end)
+{
+	void *entry;
+	pgoff_t start_idx = start >> PAGE_SHIFT;
+	pgoff_t end_idx;
+	XA_STATE(xas, &mapping->i_pages, start_idx);
+
+	/* If end == LLONG_MAX, all pages from start to till end of file */
+	if (end == LLONG_MAX)
+		end_idx = ULONG_MAX;
+	else
+		end_idx = end >> PAGE_SHIFT;
+
+	xas_lock_irq(&xas);
+	xas_for_each(&xas, entry, end_idx) {
+		if (!xa_is_value(entry))
+			continue;
+		entry = wait_entry_unlocked_exclusive(&xas, entry);
+		if (!entry)
+			continue;
+		dax_disassociate_entry(entry, mapping, true);
+		xas_store(&xas, NULL);
+		mapping->nrpages -= 1UL << dax_entry_order(entry);
+		put_unlocked_entry(&xas, entry, WAKE_ALL);
+	}
+	xas_unlock_irq(&xas);
+}
+EXPORT_SYMBOL_GPL(dax_delete_mapping_range);
+
 static int wait_page_idle(struct page *page,
 			void (cb)(struct inode *),
 			struct inode *inode)
@@ -857,6 +887,9 @@ static int wait_page_idle(struct page *p
 /*
  * Unmaps the inode and waits for any DMA to complete prior to deleting the
  * DAX mapping entries for the range.
+ *
+ * For NOWAIT behavior, pass @cb as NULL to early-exit on first found
+ * busy page
  */
 int dax_break_layout(struct inode *inode, loff_t start, loff_t end,
 		void (cb)(struct inode *))
@@ -871,10 +904,17 @@ int dax_break_layout(struct inode *inode
 		page = dax_layout_busy_page_range(inode->i_mapping, start, end);
 		if (!page)
 			break;
+		if (!cb) {
+			error = -ERESTARTSYS;
+			break;
+		}
 
 		error = wait_page_idle(page, cb, inode);
 	} while (error == 0);
 
+	if (!page)
+		dax_delete_mapping_range(inode->i_mapping, start, end);
+
 	return error;
 }
 EXPORT_SYMBOL_GPL(dax_break_layout);
--- a/fs/xfs/xfs_inode.c~fs-dax-always-remove-dax-page-cache-entries-when-breaking-layouts
+++ a/fs/xfs/xfs_inode.c
@@ -2735,7 +2735,6 @@ xfs_mmaplock_two_inodes_and_break_dax_la
 	struct xfs_inode	*ip2)
 {
 	int			error;
-	struct page		*page;
 
 	if (ip1->i_ino > ip2->i_ino)
 		swap(ip1, ip2);
@@ -2759,8 +2758,8 @@ again:
 	 * need to unlock & lock the XFS_MMAPLOCK_EXCL which is not suitable
 	 * for this nested lock case.
 	 */
-	page = dax_layout_busy_page(VFS_I(ip2)->i_mapping);
-	if (!dax_page_is_idle(page)) {
+	error = dax_break_layout(VFS_I(ip2), 0, -1, NULL);
+	if (error) {
 		xfs_iunlock(ip2, XFS_MMAPLOCK_EXCL);
 		xfs_iunlock(ip1, XFS_MMAPLOCK_EXCL);
 		goto again;
--- a/include/linux/dax.h~fs-dax-always-remove-dax-page-cache-entries-when-breaking-layouts
+++ a/include/linux/dax.h
@@ -255,6 +255,8 @@ vm_fault_t dax_iomap_fault(struct vm_fau
 vm_fault_t dax_finish_sync_fault(struct vm_fault *vmf,
 		unsigned int order, pfn_t pfn);
 int dax_delete_mapping_entry(struct address_space *mapping, pgoff_t index);
+void dax_delete_mapping_range(struct address_space *mapping,
+				loff_t start, loff_t end);
 int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
 				      pgoff_t index);
 int __must_check dax_break_layout(struct inode *inode, loff_t start,
--- a/mm/truncate.c~fs-dax-always-remove-dax-page-cache-entries-when-breaking-layouts
+++ a/mm/truncate.c
@@ -78,8 +78,22 @@ static void truncate_folio_batch_excepti
 
 	if (dax_mapping(mapping)) {
 		for (i = j; i < nr; i++) {
-			if (xa_is_value(fbatch->folios[i]))
+			if (xa_is_value(fbatch->folios[i])) {
+				/*
+				 * File systems should already have called
+				 * dax_break_layout_entry() to remove all DAX
+				 * entries while holding a lock to prevent
+				 * establishing new entries. Therefore we
+				 * shouldn't find any here.
+				 */
+				WARN_ON_ONCE(1);
+
+				/*
+				 * Delete the mapping so truncate_pagecache()
+				 * doesn't loop forever.
+				 */
 				dax_delete_mapping_entry(mapping, indices[i]);
+			}
 		}
 		goto out;
 	}
_

Patches currently in -mm which might be from apopple@nvidia.com are


