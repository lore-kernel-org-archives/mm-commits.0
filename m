From: akpm@linux-foundation.org
Subject: [folded-merged]
 dax-fix-lifetime-of-in-kernel-dax-mappings-with-dax_map_atomic-v3.patch
 removed from -mm tree
Date: Fri, 15 Jan 2016 16:30:45 -0800
Message-ID: <56998f35.E0ZKnVHWw/DBtEI2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37784 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757043AbcAPAap (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 19:30:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, axboe@fb.com, david@fromorbit.com, jack@suse.com, jmoyer@redhat.com, ross.zwisler@linux.intel.com, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax-fix-lifetime-of-in-kernel-dax-mappings-with-dax_map_atomic-v3
has been removed from the -mm tree.  Its filename was
     dax-fix-lifetime-of-in-kernel-dax-mappings-with-dax_map_atomic-v3.patch

This patch was dropped because it was folded into dax-fix-lifetime-of-in-kernel-dax-mappings-with-dax_map_atomic.patch

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: dax-fix-lifetime-of-in-kernel-dax-mappings-with-dax_map_atomic-v3

Rebase on latest -next to pick up new definition of blk_queue_enter.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Jan Kara <jack@suse.com>
Cc: Jens Axboe <axboe@fb.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/dax.c~dax-fix-lifetime-of-in-kernel-dax-mappings-with-dax_map_atomic-v3 fs/dax.c
--- a/fs/dax.c~dax-fix-lifetime-of-in-kernel-dax-mappings-with-dax_map_atomic-v3
+++ a/fs/dax.c
@@ -36,7 +36,7 @@ static long dax_map_atomic(struct block_
 	long rc = -EIO;
 
 	dax->addr = (void __pmem *) ERR_PTR(-EIO);
-	if (blk_queue_enter(q, GFP_NOWAIT) != 0)
+	if (blk_queue_enter(q, true) != 0)
 		return rc;
 
 	rc = bdev_direct_access(bdev, dax);
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

pmem-dax-clean-up-clear_pmem.patch
dax-increase-granularity-of-dax_clear_blocks-operations.patch
dax-guarantee-page-aligned-results-from-bdev_direct_access.patch
dax-fix-lifetime-of-in-kernel-dax-mappings-with-dax_map_atomic.patch
um-kill-pfn_t.patch
kvm-rename-pfn_t-to-kvm_pfn_t.patch
mm-dax-pmem-introduce-pfn_t.patch
mm-skip-memory-block-registration-for-zone_device.patch
mm-introduce-find_dev_pagemap.patch
x86-mm-introduce-vmem_altmap-to-augment-vmemmap_populate.patch
libnvdimm-pfn-pmem-allocate-memmap-array-in-persistent-memory.patch
avr32-convert-to-asm-generic-memory_modelh.patch
hugetlb-fix-compile-error-on-tile.patch
frv-fix-compiler-warning-from-definition-of-__pmd.patch
x86-mm-introduce-_page_devmap.patch
mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t.patch
mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t.patch
libnvdimm-pmem-move-request_queue-allocation-earlier-in-probe.patch
mm-dax-pmem-introduce-getput_dev_pagemap-for-dax-gup.patch
mm-dax-pmem-introduce-getput_dev_pagemap-for-dax-gup-fix.patch
mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd.patch
mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd-v5.patch
mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd-v5-fix.patch
mm-x86-get_user_pages-for-dax-mappings.patch
mm-x86-get_user_pages-for-dax-mappings-v5.patch
dax-provide-diagnostics-for-pmd-mapping-failures.patch
dax-re-enable-dax-pmd-mappings.patch

