Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A513A1A238C
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 06:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736317590; cv=none; b=s/NcsOKNjZvaIH9oP3YI6rBxH+UygnptM8k7IgoEzMRMOWYMahqJ1Kb607JNDVkfr05oOYvlDEIiUa1Prs2e8LrgQctDhBkxFOu63o4GYPBzxzbezz8UKODDsH+2d58MiIfyi3aLR3+IkRBC7IyNhbTNO6Tnn9H7wPkJ9GVLgIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736317590; c=relaxed/simple;
	bh=uFR7t3YMzxjokL8pSpyGsfu/ePeeWibQAjq+Gna3NkU=;
	h=Date:To:From:Subject:Message-Id; b=dhsZ68j1SECMC5iq1uZ7fNWPaIhZqsLYVgZ8mJnbHEwNnNGSIe4Y0BFyM6H1gqcpqtE1+kPX3CYLr8G5y7G5vMsGVzMUNhg+7XtoBOnb+9f5Ib/k2bQGoBtudDgQFoKg7lBlmKnb0N01Cy8AxZ6jq+m8pLAY4jkTIHplfEPaPu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V1pq+2dv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V1pq+2dv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A3A5C4CED0;
	Wed,  8 Jan 2025 06:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736317590;
	bh=uFR7t3YMzxjokL8pSpyGsfu/ePeeWibQAjq+Gna3NkU=;
	h=Date:To:From:Subject:From;
	b=V1pq+2dvyQP/Kjab+cdYQKoxvYylMEm9RRrdDlIRbS39uaF3DtWfhBQyG0yfPPqQm
	 BIiz5xVXDNb9ynPgnP7tFIjknxpRakYUuiLZEVpD3ocndB4n7rURniDop1Nq5VeAGh
	 D/sjTWHg2eLUvum1vKhIR7jU6NX00uHBwajiTAAg=
Date: Tue, 07 Jan 2025 22:26:29 -0800
To: mm-commits@vger.kernel.org,tytso@mit.edu,jack@suse.cz,hch@lst.de,dan.j.williams@intel.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-dax-refactor-wait-for-dax-idle-page.patch added to mm-unstable branch
Message-Id: <20250108062630.5A3A5C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/dax: refactor wait for dax idle page
has been added to the -mm mm-unstable branch.  Its filename is
     fs-dax-refactor-wait-for-dax-idle-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-dax-refactor-wait-for-dax-idle-page.patch

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
Subject: fs/dax: refactor wait for dax idle page
Date: Tue, 7 Jan 2025 14:42:20 +1100

A FS DAX page is considered idle when its refcount drops to one.  This is
currently open-coded in all file systems supporting FS DAX.  Move the idle
detection to a common function to make future changes easier.

Link: https://lkml.kernel.org/r/62a85767a21fb76b548801a002a85c7831e8e25c.1736221254.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/inode.c     |    5 +----
 fs/fuse/dax.c       |    4 +---
 fs/xfs/xfs_inode.c  |    4 +---
 include/linux/dax.h |    8 ++++++++
 4 files changed, 11 insertions(+), 10 deletions(-)

--- a/fs/ext4/inode.c~fs-dax-refactor-wait-for-dax-idle-page
+++ a/fs/ext4/inode.c
@@ -3922,10 +3922,7 @@ int ext4_break_layouts(struct inode *ino
 		if (!page)
 			return 0;
 
-		error = ___wait_var_event(&page->_refcount,
-				atomic_read(&page->_refcount) == 1,
-				TASK_INTERRUPTIBLE, 0, 0,
-				ext4_wait_dax_page(inode));
+		error = dax_wait_page_idle(page, ext4_wait_dax_page, inode);
 	} while (error == 0);
 
 	return error;
--- a/fs/fuse/dax.c~fs-dax-refactor-wait-for-dax-idle-page
+++ a/fs/fuse/dax.c
@@ -676,9 +676,7 @@ static int __fuse_dax_break_layouts(stru
 		return 0;
 
 	*retry = true;
-	return ___wait_var_event(&page->_refcount,
-			atomic_read(&page->_refcount) == 1, TASK_INTERRUPTIBLE,
-			0, 0, fuse_wait_dax_page(inode));
+	return dax_wait_page_idle(page, fuse_wait_dax_page, inode);
 }
 
 /* dmap_end == 0 leads to unmapping of whole file */
--- a/fs/xfs/xfs_inode.c~fs-dax-refactor-wait-for-dax-idle-page
+++ a/fs/xfs/xfs_inode.c
@@ -3000,9 +3000,7 @@ xfs_break_dax_layouts(
 		return 0;
 
 	*retry = true;
-	return ___wait_var_event(&page->_refcount,
-			atomic_read(&page->_refcount) == 1, TASK_INTERRUPTIBLE,
-			0, 0, xfs_wait_dax_page(inode));
+	return dax_wait_page_idle(page, xfs_wait_dax_page, inode);
 }
 
 int
--- a/include/linux/dax.h~fs-dax-refactor-wait-for-dax-idle-page
+++ a/include/linux/dax.h
@@ -207,6 +207,14 @@ int dax_zero_range(struct inode *inode,
 int dax_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,
 		const struct iomap_ops *ops);
 
+static inline int dax_wait_page_idle(struct page *page,
+				void (cb)(struct inode *),
+				struct inode *inode)
+{
+	return ___wait_var_event(page, page_ref_count(page) == 1,
+				TASK_INTERRUPTIBLE, 0, 0, cb(inode));
+}
+
 #if IS_ENABLED(CONFIG_DAX)
 int dax_read_lock(void);
 void dax_read_unlock(int id);
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

