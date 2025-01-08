Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5589B1A238C
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 06:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736317598; cv=none; b=P7GgDGzT6F80nv8f/AGrJAPlY6LNbLBN14d6iiVc52GHtSaD97xAnt43dgi4eYN21qvewxibSn2CpcA+b0qAloFJDCTS6jf0iQTZr1VYi8G9QZYqsnD6P+nyDUOQVeELfEp17YotFE5n7/Mya8i7trJX05lY6h0oxa4D6LgSTwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736317598; c=relaxed/simple;
	bh=6A2Fgv2wm4UyK1tTsVmZHDPovl2UE+zodgzKb38iyt0=;
	h=Date:To:From:Subject:Message-Id; b=VcJ7NF18+5HpqGA5tatTHtxGqCbMhsqaqbP+6sYq3dZWRAw5IbdBi+1yfZNbHzylg+atIxz1KFJmeAXBYJlo1M0OKZAvgg+Doj6ZWVHYf3k//E11arC7gsDYwkgkXNU7SuphOiOdv7Fsi+mmX0Z1kYnsaIUPnzxAwQi+ieHY+6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YYmkOMS3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YYmkOMS3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7ED3C4CED0;
	Wed,  8 Jan 2025 06:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736317597;
	bh=6A2Fgv2wm4UyK1tTsVmZHDPovl2UE+zodgzKb38iyt0=;
	h=Date:To:From:Subject:From;
	b=YYmkOMS30RWcYThED3R7T8fjM6aPaZ1fK/doviL4lQHSg9LgMWErvIDKTquJbv75u
	 IKPILTcJtlcXepm5VDHHo8GLj9N9HrGKyYBflU2tWBbZvcW6A3qGdtJvfQ2jufe0U4
	 8/SZtn/JZpUXXJoh3DvMk5dUuUXHdphyDXRVEG6I=
Date: Tue, 07 Jan 2025 22:26:37 -0800
To: mm-commits@vger.kernel.org,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-dax-always-remove-dax-page-cache-entries-when-breaking-layouts.patch added to mm-unstable branch
Message-Id: <20250108062637.C7ED3C4CED0@smtp.kernel.org>
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
Date: Tue, 7 Jan 2025 14:42:22 +1100

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

Link: https://lkml.kernel.org/r/fc4ce7ac0815bc33d00ca6626925a1012473ff7a.1736221254.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c            |   33 +++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.c  |    6 ++++++
 include/linux/dax.h |    2 ++
 mm/truncate.c       |   16 +++++++++++++++-
 4 files changed, 56 insertions(+), 1 deletion(-)

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
@@ -874,6 +904,9 @@ int dax_break_mapping(struct inode *inod
 		error = wait_page_idle(page, cb, inode);
 	} while (error == 0);
 
+	if (!page)
+		dax_delete_mapping_range(inode->i_mapping, start, end);
+
 	return error;
 }
 EXPORT_SYMBOL_GPL(dax_break_mapping);
--- a/fs/xfs/xfs_inode.c~fs-dax-always-remove-dax-page-cache-entries-when-breaking-layouts
+++ a/fs/xfs/xfs_inode.c
@@ -2746,6 +2746,12 @@ again:
 		goto again;
 	}
 
+	/*
+	 * Normally xfs_break_dax_layouts() would delete the mapping entries as well so
+	 * do that here.
+	 */
+	dax_delete_mapping_range(VFS_I(ip2)->i_mapping, 0, LLONG_MAX);
+
 	return 0;
 }
 
--- a/include/linux/dax.h~fs-dax-always-remove-dax-page-cache-entries-when-breaking-layouts
+++ a/include/linux/dax.h
@@ -263,6 +263,8 @@ vm_fault_t dax_iomap_fault(struct vm_fau
 vm_fault_t dax_finish_sync_fault(struct vm_fault *vmf,
 		unsigned int order, pfn_t pfn);
 int dax_delete_mapping_entry(struct address_space *mapping, pgoff_t index);
+void dax_delete_mapping_range(struct address_space *mapping,
+				loff_t start, loff_t end);
 int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
 				      pgoff_t index);
 int __must_check dax_break_mapping(struct inode *inode, loff_t start,
--- a/mm/truncate.c~fs-dax-always-remove-dax-page-cache-entries-when-breaking-layouts
+++ a/mm/truncate.c
@@ -78,8 +78,22 @@ static void truncate_folio_batch_excepti
 
 	if (dax_mapping(mapping)) {
 		for (i = j; i < nr; i++) {
-			if (xa_is_value(fbatch->folios[i]))
+			if (xa_is_value(fbatch->folios[i])) {
+				/*
+				 * File systems should already have called
+				 * dax_break_mapping_entry() to remove all DAX
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
memremap-add-is_devdax_page-and-is_fsdax_page-helpers.patch
mm-gup-dont-allow-foll_longterm-pinning-of-fs-dax-pages.patch
proc-task_mmu-mark-devdax-and-fsdax-pages-as-always-unpinned.patch
mm-mlock-skip-zone_device-pmds-during-mlock.patch
fs-dax-properly-refcount-fs-dax-pages.patch
device-dax-properly-refcount-device-dax-pages-when-mapping.patch
mm-remove-pxx_devmap-callers.patch
mm-remove-devmap-related-functions-and-page-table-bits.patch
revert-riscv-mm-add-support-for-zone_device.patch

