From: akpm@linux-foundation.org
Subject: + dax-factor-dax_insert_pmd_mapping-out-of-dax_pmd_fault.patch
 added to -mm tree
Date: Tue, 02 Feb 2016 14:57:45 -0800
Message-ID: <56b13469.f31rAsXqVE5HEK21%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34102 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519AbcBBW5q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Feb 2016 17:57:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew.r.wilcox@intel.com, dan.j.williams@intel.com, kirill@shutemov.name, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: factor dax_insert_pmd_mapping out of dax_pmd_fault
has been added to the -mm tree.  Its filename is
     dax-factor-dax_insert_pmd_mapping-out-of-dax_pmd_fault.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-factor-dax_insert_pmd_mapping-out-of-dax_pmd_fault.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-factor-dax_insert_pmd_mapping-out-of-dax_pmd_fault.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: dax: factor dax_insert_pmd_mapping out of dax_pmd_fault

These two functios are still large, but they're no longer quite so
ludicrously large

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |  153 +++++++++++++++++++++++++++--------------------------
 1 file changed, 80 insertions(+), 73 deletions(-)

diff -puN fs/dax.c~dax-factor-dax_insert_pmd_mapping-out-of-dax_pmd_fault fs/dax.c
--- a/fs/dax.c~dax-factor-dax_insert_pmd_mapping-out-of-dax_pmd_fault
+++ a/fs/dax.c
@@ -717,6 +717,83 @@ static void __dax_dbg(struct buffer_head
 
 #define dax_pmd_dbg(bh, address, reason)	__dax_dbg(bh, address, reason, "dax_pmd")
 
+static int dax_insert_pmd_mapping(struct inode *inode, struct buffer_head *bh,
+			struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	int major = 0;
+	struct blk_dax_ctl dax = {
+		.sector = to_sector(bh, inode),
+		.size = PMD_SIZE,
+	};
+	struct block_device *bdev = bh->b_bdev;
+	bool write = vmf->flags & FAULT_FLAG_WRITE;
+	unsigned long address = (unsigned long)vmf->virtual_address;
+	long length = dax_map_atomic(bdev, &dax);
+
+	if (length < 0)
+		return VM_FAULT_SIGBUS;
+	if (length < PMD_SIZE) {
+		dax_pmd_dbg(bh, address, "dax-length too small");
+		goto unmap;
+	}
+
+	if (pfn_t_to_pfn(dax.pfn) & PG_PMD_COLOUR) {
+		dax_pmd_dbg(bh, address, "pfn unaligned");
+		goto unmap;
+	}
+
+	if (!pfn_t_devmap(dax.pfn)) {
+		dax_pmd_dbg(bh, address, "pfn not in memmap");
+		goto unmap;
+	}
+
+	if (buffer_unwritten(bh) || buffer_new(bh)) {
+		clear_pmem(dax.addr, PMD_SIZE);
+		wmb_pmem();
+		count_vm_event(PGMAJFAULT);
+		mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
+		major = VM_FAULT_MAJOR;
+	}
+	dax_unmap_atomic(bdev, &dax);
+
+	/*
+	 * For PTE faults we insert a radix tree entry for reads, and leave
+	 * it clean.  Then on the first write we dirty the radix tree entry
+	 * via the dax_pfn_mkwrite() path.  This sequence allows the
+	 * dax_pfn_mkwrite() call to be simpler and avoid a call into
+	 * get_block() to translate the pgoff to a sector in order to be able
+	 * to create a new radix tree entry.
+	 *
+	 * The PMD path doesn't have an equivalent to dax_pfn_mkwrite(),
+	 * though, so for a read followed by a write we traverse all the way
+	 * through dax_pmd_fault() twice.  This means we can just skip
+	 * inserting a radix tree entry completely on the initial read and
+	 * just wait until the write to insert a dirty entry.
+	 */
+	if (write) {
+		int error = dax_radix_entry(vma->vm_file->f_mapping, vmf->pgoff,
+						dax.sector, true, true);
+		if (error) {
+			dax_pmd_dbg(bh, address,
+					"PMD radix insertion failed");
+			goto fallback;
+		}
+	}
+
+	dev_dbg(part_to_dev(bdev->bd_part),
+			"%s: %s addr: %lx pfn: %lx sect: %llx\n",
+			__func__, current->comm, address,
+			pfn_t_to_pfn(dax.pfn),
+			(unsigned long long) dax.sector);
+	return major | vmf_insert_pfn_pmd(vma, address, vmf->pmd,
+						dax.pfn, write);
+ unmap:
+	dax_unmap_atomic(bdev, &dax);
+ fallback:
+	count_vm_event(THP_FAULT_FALLBACK);
+	return VM_FAULT_FALLBACK;
+}
+
 static int dax_pmd_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 		get_block_t get_block, dax_iodone_t complete_unwritten)
 {
@@ -728,10 +805,9 @@ static int dax_pmd_fault(struct vm_area_
 	unsigned long address = (unsigned long)vmf->virtual_address;
 	unsigned long pmd_addr = address & PMD_MASK;
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
-	struct block_device *bdev;
 	pgoff_t size;
 	sector_t block;
-	int error, result = 0;
+	int result;
 	bool alloc = false;
 
 	/* dax pmd mappings require pfn_t_devmap() */
@@ -779,8 +855,6 @@ static int dax_pmd_fault(struct vm_area_
 		alloc = true;
 	}
 
-	bdev = bh.b_bdev;
-
 	/*
 	 * If the filesystem isn't willing to tell us the length of a hole,
 	 * just fall back to PTEs.  Calling get_block 512 times in a loop
@@ -819,7 +893,7 @@ static int dax_pmd_fault(struct vm_area_
 			goto fallback;
 		}
 
-		dev_dbg(part_to_dev(bdev->bd_part),
+		dev_dbg(part_to_dev(bh.b_bdev->bd_part),
 				"%s: %s addr: %lx pfn: <zero> sect: %llx\n",
 				__func__, current->comm, address,
 				(unsigned long long) to_sector(&bh, inode));
@@ -830,74 +904,7 @@ static int dax_pmd_fault(struct vm_area_
 		result = VM_FAULT_NOPAGE;
 		spin_unlock(ptl);
 	} else {
-		struct blk_dax_ctl dax = {
-			.sector = to_sector(&bh, inode),
-			.size = PMD_SIZE,
-		};
-		long length = dax_map_atomic(bdev, &dax);
-
-		if (length < 0) {
-			result = VM_FAULT_SIGBUS;
-			goto out;
-		}
-		if (length < PMD_SIZE) {
-			dax_pmd_dbg(&bh, address, "dax-length too small");
-			dax_unmap_atomic(bdev, &dax);
-			goto fallback;
-		}
-		if (pfn_t_to_pfn(dax.pfn) & PG_PMD_COLOUR) {
-			dax_pmd_dbg(&bh, address, "pfn unaligned");
-			dax_unmap_atomic(bdev, &dax);
-			goto fallback;
-		}
-
-		if (!pfn_t_devmap(dax.pfn)) {
-			dax_unmap_atomic(bdev, &dax);
-			dax_pmd_dbg(&bh, address, "pfn not in memmap");
-			goto fallback;
-		}
-
-		if (buffer_unwritten(&bh) || buffer_new(&bh)) {
-			clear_pmem(dax.addr, PMD_SIZE);
-			wmb_pmem();
-			count_vm_event(PGMAJFAULT);
-			mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
-			result |= VM_FAULT_MAJOR;
-		}
-		dax_unmap_atomic(bdev, &dax);
-
-		/*
-		 * For PTE faults we insert a radix tree entry for reads, and
-		 * leave it clean.  Then on the first write we dirty the radix
-		 * tree entry via the dax_pfn_mkwrite() path.  This sequence
-		 * allows the dax_pfn_mkwrite() call to be simpler and avoid a
-		 * call into get_block() to translate the pgoff to a sector in
-		 * order to be able to create a new radix tree entry.
-		 *
-		 * The PMD path doesn't have an equivalent to
-		 * dax_pfn_mkwrite(), though, so for a read followed by a
-		 * write we traverse all the way through dax_pmd_fault()
-		 * twice.  This means we can just skip inserting a radix tree
-		 * entry completely on the initial read and just wait until
-		 * the write to insert a dirty entry.
-		 */
-		if (write) {
-			error = dax_radix_entry(mapping, vmf->pgoff,
-						dax.sector, true, true);
-			if (error) {
-				dax_pmd_dbg(&bh, address,
-						"PMD radix insertion failed");
-				goto fallback;
-			}
-		}
