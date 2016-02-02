From: akpm@linux-foundation.org
Subject: + dax-factor-dax_insert_pud_mapping-out-of-dax_pud_fault.patch
 added to -mm tree
Date: Tue, 02 Feb 2016 14:57:47 -0800
Message-ID: <56b1346b.+9AHLpWSFrAQ1zxv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34106 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519AbcBBW5s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Feb 2016 17:57:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew.r.wilcox@intel.com, dan.j.williams@intel.com, kirill@shutemov.name, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: factor dax_insert_pud_mapping out of dax_pud_fault
has been added to the -mm tree.  Its filename is
     dax-factor-dax_insert_pud_mapping-out-of-dax_pud_fault.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-factor-dax_insert_pud_mapping-out-of-dax_pud_fault.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-factor-dax_insert_pud_mapping-out-of-dax_pud_fault.patch

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
Subject: dax: factor dax_insert_pud_mapping out of dax_pud_fault

Follow the factoring done for dax_pmd_fault.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |  100 ++++++++++++++++++++++++++++-------------------------
 1 file changed, 53 insertions(+), 47 deletions(-)

diff -puN fs/dax.c~dax-factor-dax_insert_pud_mapping-out-of-dax_pud_fault fs/dax.c
--- a/fs/dax.c~dax-factor-dax_insert_pud_mapping-out-of-dax_pud_fault
+++ a/fs/dax.c
@@ -935,6 +935,57 @@ static int dax_pmd_fault(struct vm_area_
 
 #define dax_pud_dbg(bh, address, reason)	__dax_dbg(bh, address, reason, "dax_pud")
 
+static int dax_insert_pud_mapping(struct inode *inode, struct buffer_head *bh,
+			struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	int major = 0;
+	struct blk_dax_ctl dax = {
+		.sector = to_sector(bh, inode),
+		.size = PUD_SIZE,
+	};
+	struct block_device *bdev = bh->b_bdev;
+	bool write = vmf->flags & FAULT_FLAG_WRITE;
+	unsigned long address = (unsigned long)vmf->virtual_address;
+	long length = dax_map_atomic(bdev, &dax);
+
+	if (length < 0)
+		return VM_FAULT_SIGBUS;
+	if (length < PUD_SIZE) {
+		dax_pud_dbg(bh, address, "dax-length too small");
+		goto unmap;
+	}
+	if (pfn_t_to_pfn(dax.pfn) & PG_PUD_COLOUR) {
+		dax_pud_dbg(bh, address, "pfn unaligned");
+		goto unmap;
+	}
+
+	if (!pfn_t_devmap(dax.pfn)) {
+		dax_pud_dbg(bh, address, "pfn not in memmap");
+		goto unmap;
+	}
+
+	if (buffer_unwritten(bh) || buffer_new(bh)) {
+		clear_pmem(dax.addr, PUD_SIZE);
+		wmb_pmem();
+		count_vm_event(PGMAJFAULT);
+		mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
+		major = VM_FAULT_MAJOR;
+	}
+	dax_unmap_atomic(bdev, &dax);
+
+	dev_dbg(part_to_dev(bdev->bd_part),
+			"%s: %s addr: %lx pfn: %lx sect: %llx\n",
+			__func__, current->comm, address,
+			pfn_t_to_pfn(dax.pfn),
+			(unsigned long long) dax.sector);
+	return major | vmf_insert_pfn_pud(vma, address, vmf->pud,
+						dax.pfn, write);
+ unmap:
+	dax_unmap_atomic(bdev, &dax);
+	count_vm_event(THP_FAULT_FALLBACK);
+	return VM_FAULT_FALLBACK;
+}
+
 static int dax_pud_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 		get_block_t get_block, dax_iodone_t complete_unwritten)
 {
@@ -946,10 +997,9 @@ static int dax_pud_fault(struct vm_area_
 	unsigned long address = (unsigned long)vmf->virtual_address;
 	unsigned long pud_addr = address & PUD_MASK;
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
-	struct block_device *bdev;
 	pgoff_t size;
 	sector_t block;
-	int result = 0;
+	int result;
 	bool alloc = false;
 
 	/* dax pud mappings require pfn_t_devmap() */
@@ -997,8 +1047,6 @@ static int dax_pud_fault(struct vm_area_
 		alloc = true;
 	}
 
-	bdev = bh.b_bdev;
-
 	/*
 	 * If the filesystem isn't willing to tell us the length of a hole,
 	 * just fall back to PMDs.  Calling get_block 512 times in a loop
@@ -1024,49 +1072,7 @@ static int dax_pud_fault(struct vm_area_
 		dax_pud_dbg(&bh, address, "no zero page");
 		goto fallback;
 	} else {
-		struct blk_dax_ctl dax = {
-			.sector = to_sector(&bh, inode),
-			.size = PUD_SIZE,
-		};
-		long length = dax_map_atomic(bdev, &dax);
-
-		if (length < 0) {
-			result = VM_FAULT_SIGBUS;
-			goto out;
-		}
-		if (length < PUD_SIZE) {
-			dax_pud_dbg(&bh, address, "dax-length too small");
-			dax_unmap_atomic(bdev, &dax);
-			goto fallback;
-		}
-		if (pfn_t_to_pfn(dax.pfn) & PG_PUD_COLOUR) {
-			dax_pud_dbg(&bh, address, "pfn unaligned");
-			dax_unmap_atomic(bdev, &dax);
-			goto fallback;
-		}
-
-		if (!pfn_t_devmap(dax.pfn)) {
-			dax_unmap_atomic(bdev, &dax);
-			dax_pud_dbg(&bh, address, "pfn not in memmap");
-			goto fallback;
-		}
-
-		if (buffer_unwritten(&bh) || buffer_new(&bh)) {
-			clear_pmem(dax.addr, PUD_SIZE);
-			wmb_pmem();
-			count_vm_event(PGMAJFAULT);
-			mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
-			result |= VM_FAULT_MAJOR;
-		}
-		dax_unmap_atomic(bdev, &dax);
