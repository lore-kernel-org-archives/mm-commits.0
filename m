From: akpm@linux-foundation.org
Subject: + dax-support-for-transparent-pud-pages.patch added to -mm tree
Date: Tue, 02 Feb 2016 14:53:54 -0800
Message-ID: <56b13382.BdNJvsKxod7cdBKR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33951 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbcBBWxz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Feb 2016 17:53:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, dan.j.williams@intel.com, jack@suse.cz, kirill.shutemov@linux.intel.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: support for transparent PUD pages
has been added to the -mm tree.  Its filename is
     dax-support-for-transparent-pud-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-support-for-transparent-pud-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-support-for-transparent-pud-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: dax: support for transparent PUD pages

The DAX support for transparent huge PUD pages

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |  185 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 185 insertions(+)

diff -puN fs/dax.c~dax-support-for-transparent-pud-pages fs/dax.c
--- a/fs/dax.c~dax-support-for-transparent-pud-pages
+++ a/fs/dax.c
@@ -978,6 +978,189 @@ static int dax_pmd_fault(struct vm_area_
 }
 #endif /* !CONFIG_TRANSPARENT_HUGEPAGE */
 
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+/*
+ * The 'colour' (ie low bits) within a PUD of a page offset.  This comes up
+ * more often than one might expect in the below function.
+ */
+#define PG_PUD_COLOUR	((PUD_SIZE >> PAGE_SHIFT) - 1)
+
+#define dax_pud_dbg(bh, address, reason)	__dax_dbg(bh, address, reason, "dax_pud")
+
+static int dax_pud_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
+		get_block_t get_block, dax_iodone_t complete_unwritten)
+{
+	struct file *file = vma->vm_file;
+	struct address_space *mapping = file->f_mapping;
+	struct inode *inode = mapping->host;
+	struct buffer_head bh;
+	unsigned blkbits = inode->i_blkbits;
+	unsigned long address = (unsigned long)vmf->virtual_address;
+	unsigned long pud_addr = address & PUD_MASK;
+	bool write = vmf->flags & FAULT_FLAG_WRITE;
+	struct block_device *bdev;
+	pgoff_t size, pgoff;
+	sector_t block;
+	int result = 0;
+	bool alloc = false;
+
+	/* dax pud mappings require pfn_t_devmap() */
+	if (!IS_ENABLED(CONFIG_FS_DAX_PMD))
+		return VM_FAULT_FALLBACK;
+
+	/* Fall back to PTEs if we're going to COW */
+	if (write && !(vma->vm_flags & VM_SHARED)) {
+		split_huge_pud(vma, vmf->pud, address);
+		dax_pud_dbg(NULL, address, "cow write");
+		return VM_FAULT_FALLBACK;
+	}
+	/* If the PUD would extend outside the VMA */
+	if (pud_addr < vma->vm_start) {
+		dax_pud_dbg(NULL, address, "vma start unaligned");
+		return VM_FAULT_FALLBACK;
+	}
+	if ((pud_addr + PUD_SIZE) > vma->vm_end) {
+		dax_pud_dbg(NULL, address, "vma end unaligned");
+		return VM_FAULT_FALLBACK;
+	}
+
+	pgoff = linear_page_index(vma, pud_addr);
+	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	if (pgoff >= size)
+		return VM_FAULT_SIGBUS;
+	/* If the PUD would cover blocks out of the file */
+	if ((pgoff | PG_PUD_COLOUR) >= size) {
+		dax_pud_dbg(NULL, address,
+				"offset + huge page size > file size");
+		return VM_FAULT_FALLBACK;
+	}
+
+	memset(&bh, 0, sizeof(bh));
+	bh.b_bdev = inode->i_sb->s_bdev;
+	block = (sector_t)pgoff << (PAGE_SHIFT - blkbits);
+
+	bh.b_size = PUD_SIZE;
+
+	if (get_block(inode, block, &bh, 0) != 0)
+		return VM_FAULT_SIGBUS;
+
+	if (!buffer_mapped(&bh) && write) {
+		if (get_block(inode, block, &bh, 1) != 0)
+			return VM_FAULT_SIGBUS;
+		alloc = true;
+	}
+
+	bdev = bh.b_bdev;
+
+	/*
+	 * If the filesystem isn't willing to tell us the length of a hole,
+	 * just fall back to PMDs.  Calling get_block 512 times in a loop
+	 * would be silly.
+	 */
+	if (!buffer_size_valid(&bh) || bh.b_size < PUD_SIZE) {
+		dax_pud_dbg(&bh, address, "allocated block too small");
+		return VM_FAULT_FALLBACK;
+	}
+
+	/*
+	 * If we allocated new storage, make sure no process has any
+	 * zero pages covering this hole
+	 */
+	if (alloc) {
+		loff_t lstart = pgoff << PAGE_SHIFT;
+		loff_t lend = lstart + PUD_SIZE - 1; /* inclusive */
+
+		truncate_pagecache_range(inode, lstart, lend);
+	}
+
+	i_mmap_lock_read(mapping);
+
+	/*
+	 * If a truncate happened while we were allocating blocks, we may
+	 * leave blocks allocated to the file that are beyond EOF.  We can't
+	 * take i_mutex here, so just leave them hanging; they'll be freed
+	 * when the file is deleted.
+	 */
+	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	if (pgoff >= size) {
+		result = VM_FAULT_SIGBUS;
+		goto out;
+	}
+	if ((pgoff | PG_PUD_COLOUR) >= size) {
+		dax_pud_dbg(&bh, address, "page extends outside VMA");
+		goto fallback;
+	}
+
+	if (!write && !buffer_mapped(&bh) && buffer_uptodate(&bh)) {
+		dax_pud_dbg(&bh, address, "no zero page");
+		goto fallback;
+	} else {
+		struct blk_dax_ctl dax = {
+			.sector = to_sector(&bh, inode),
+			.size = PUD_SIZE,
+		};
+		long length = dax_map_atomic(bdev, &dax);
+
+		if (length < 0) {
+			result = VM_FAULT_SIGBUS;
+			goto out;
+		}
+		if (length < PUD_SIZE) {
+			dax_pud_dbg(&bh, address, "dax-length too small");
+			dax_unmap_atomic(bdev, &dax);
+			goto fallback;
+		}
+		if (pfn_t_to_pfn(dax.pfn) & PG_PUD_COLOUR) {
+			dax_pud_dbg(&bh, address, "pfn unaligned");
+			dax_unmap_atomic(bdev, &dax);
+			goto fallback;
+		}
+
+		if (!pfn_t_devmap(dax.pfn)) {
+			dax_unmap_atomic(bdev, &dax);
+			dax_pud_dbg(&bh, address, "pfn not in memmap");
+			goto fallback;
+		}
+
+		if (buffer_unwritten(&bh) || buffer_new(&bh)) {
+			clear_pmem(dax.addr, PUD_SIZE);
+			wmb_pmem();
+			count_vm_event(PGMAJFAULT);
+			mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
+			result |= VM_FAULT_MAJOR;
+		}
+		dax_unmap_atomic(bdev, &dax);
+
+		dev_dbg(part_to_dev(bdev->bd_part),
+				"%s: %s addr: %lx pfn: %lx sect: %llx\n",
+				__func__, current->comm, address,
+				pfn_t_to_pfn(dax.pfn),
+				(unsigned long long) dax.sector);
+		result |= vmf_insert_pfn_pud(vma, address, vmf->pud,
+				dax.pfn, write);
+	}
+
+ out:
+	i_mmap_unlock_read(mapping);
+
+	if (buffer_unwritten(&bh))
+		complete_unwritten(&bh, !(result & VM_FAULT_ERROR));
+
+	return result;
+
+ fallback:
+	count_vm_event(THP_FAULT_FALLBACK);
+	result = VM_FAULT_FALLBACK;
+	goto out;
+}
+#else /* !CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
+static int dax_pud_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
+		get_block_t get_block, dax_iodone_t complete_unwritten)
+{
+	return VM_FAULT_FALLBACK;
+}
+#endif /* !CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
+
 /**
  * dax_fault - handle a page fault on a DAX file
  * @vma: The virtual memory area where the fault occurred
@@ -1002,6 +1185,8 @@ int dax_fault(struct vm_area_struct *vma
 		return dax_pte_fault(vma, vmf, get_block, iodone);
 	case FAULT_FLAG_SIZE_PMD:
 		return dax_pmd_fault(vma, vmf, get_block, iodone);
+	case FAULT_FLAG_SIZE_PUD:
+		return dax_pud_fault(vma, vmf, get_block, iodone);
 	default:
 		return VM_FAULT_FALLBACK;
 	}
_

Patches currently in -mm which might be from willy@linux.intel.com are

radix-tree-fix-race-in-gang-lookup.patch
hwspinlock-fix-race-between-radix-tree-insertion-and-lookup.patch
mm-convert-an-open-coded-vm_bug_on_vma.patch
mmfsdax-change-pmd_fault-to-huge_fault.patch
mm-add-support-for-pud-sized-transparent-hugepages.patch
procfs-add-support-for-puds-to-smaps-clear_refs-and-pagemap.patch
x86-add-support-for-pud-sized-transparent-hugepages.patch
dax-support-for-transparent-pud-pages.patch
ext4-support-for-pud-sized-transparent-huge-pages.patch
radix-tree-add-an-explicit-include-of-bitopsh.patch
radix-tree-test-harness.patch
radix_tree-tag-all-internal-tree-nodes-as-indirect-pointers.patch
radix_tree-loop-based-on-shift-count-not-height.patch
radix_tree-add-support-for-multi-order-entries.patch
radix_tree-add-radix_tree_dump.patch
btrfs-use-radix_tree_iter_retry.patch
mm-use-radix_tree_iter_retry.patch
radix-treeshmem-introduce-radix_tree_iter_next.patch

