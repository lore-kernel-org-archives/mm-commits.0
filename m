Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7BC25A65D
	for <mm-commits@vger.kernel.org>; Wed,  5 Feb 2025 02:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738721767; cv=none; b=JuEzXldfHCudWykhz9czi8z3JcFLmqGfowRUw77UwkEKH/RyXdU+p1ns7vptLLng7Mmmz5X/UleXhYBK1ZP2mxVhTV+ZqcTX+RK6ZyGmeum3Wg1Zsvjc2FlFL/q1uXH2G2wuMGiQXz73OrkyhM+EtDqZEq0CBn6KktpcgLR8Nnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738721767; c=relaxed/simple;
	bh=z352ci23HUZwXoKPzPuWnZX9BdT9L/a3lpg1Q0R6znM=;
	h=Date:To:From:Subject:Message-Id; b=t5Yf2HJ/XYkioidrPBRPCNtazRC7ytX9Z65O+6RXNAAT6uZVmtbpFXiOv7JfSEwEc216I/D6yo6rW1vMWmx+OSaNpXWW8tuSpQf46EWbboEXkhVoAIZuh3BSL6uSRnGBD1kqphL/B+m7jsWvFfAqarDfKYSx0CoIHBxU5kZESIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bc7uRxrD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bc7uRxrD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEC88C4CEDF;
	Wed,  5 Feb 2025 02:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738721767;
	bh=z352ci23HUZwXoKPzPuWnZX9BdT9L/a3lpg1Q0R6znM=;
	h=Date:To:From:Subject:From;
	b=bc7uRxrDVf/H3sU69fg7d8tebRewYDu80bGEkJ4rPfAu+lPfpSJHQYt9epl2oZiMO
	 4U9NxR+IqqGcJfdh7ueiu7A4y4fjxz+CmPSsORoNKJ/2rYbggz+UyZwGFDQZCnjVuT
	 oYa+H16T/AkQxe73+X8PRsNZWwq5RgF6fLj+T0Sw=
Date: Tue, 04 Feb 2025 18:16:06 -0800
To: mm-commits@vger.kernel.org,zhang.lyra@gmail.com,willy@infradead.org,will@kernel.org,vishal.l.verma@intel.com,vgoyal@redhat.com,tytso@mit.edu,svens@linux.ibm.com,peterx@redhat.com,npiggin@gmail.com,mpe@ellerman.id.au,logang@deltatee.com,linmiaohe@huawei.com,lina@asahilina.net,kernel@xen0n.name,jhubbard@nvidia.com,jgg@ziepe.ca,jgg@nvidia.com,jack@suse.cz,ira.weiny@intel.com,hch@lst.de,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,djwong@kernel.org,david@redhat.com,david@fromorbit.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,chenhuacai@kernel.org,catalin.marinas@arm.com,borntraeger@linux.ibm.com,bhelgaas@google.com,alison.schofield@intel.com,agordeev@linux.ibm.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-dax-always-remove-dax-page-cache-entries-when-breaking-layouts.patch added to mm-unstable branch
Message-Id: <20250205021606.EEC88C4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/dax: always remove DAX page-cache entries when breaking layouts
has been added to the -mm mm-unstable branch.  Its filename is
     fs-dax-always-remove-dax-page-cache-entries-when-breaking-layouts.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-dax-always-remove-dax-page-cache-entries-when-breaking-layouts.patch

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
Subject: fs/dax: always remove DAX page-cache entries when breaking layouts
Date: Wed, 5 Feb 2025 09:48:03 +1100

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

Link: https://lkml.kernel.org/r/e493188d4668b45b87e8bf284fcb59a65e45b6e3.1738709036.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
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

 fs/dax.c            |   40 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.c  |    5 ++---
 include/linux/dax.h |    2 ++
 mm/truncate.c       |   16 +++++++++++++++-
 4 files changed, 59 insertions(+), 4 deletions(-)

--- a/fs/dax.c~fs-dax-always-remove-dax-page-cache-entries-when-breaking-layouts
+++ a/fs/dax.c
@@ -845,6 +845,36 @@ int dax_delete_mapping_entry(struct addr
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
@@ -856,6 +886,9 @@ static int wait_page_idle(struct page *p
 /*
  * Unmaps the inode and waits for any DMA to complete prior to deleting the
  * DAX mapping entries for the range.
+ *
+ * For NOWAIT behavior, pass @cb as NULL to early-exit on first found
+ * busy page
  */
 int dax_break_layout(struct inode *inode, loff_t start, loff_t end,
 		void (cb)(struct inode *))
@@ -870,10 +903,17 @@ int dax_break_layout(struct inode *inode
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
@@ -2732,7 +2732,6 @@ xfs_mmaplock_two_inodes_and_break_dax_la
 	struct xfs_inode	*ip2)
 {
 	int			error;
-	struct page		*page;
 
 	if (ip1->i_ino > ip2->i_ino)
 		swap(ip1, ip2);
@@ -2756,8 +2755,8 @@ again:
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

