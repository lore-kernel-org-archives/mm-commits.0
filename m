From: akpm@linux-foundation.org
Subject: +
 dax-guarantee-page-aligned-results-from-bdev_direct_access.patch added to
 -mm tree
Date: Tue, 15 Dec 2015 16:16:35 -0800
Message-ID: <5670ad63.BLxTcDwn+YRwJy7o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47204 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431AbbLPAQg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Dec 2015 19:16:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: guarantee page aligned results from bdev_direct_access()
has been added to the -mm tree.  Its filename is
     dax-guarantee-page-aligned-results-from-bdev_direct_access.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-guarantee-page-aligned-results-from-bdev_direct_access.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-guarantee-page-aligned-results-from-bdev_direct_access.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: dax: guarantee page aligned results from bdev_direct_access()

If a ->direct_access() implementation ever returns a map count less than
PAGE_SIZE, catch the error in bdev_direct_access().  This simplifies error
checking in upper layers.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c |    2 ++
 fs/dax.c       |    1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/block_dev.c~dax-guarantee-page-aligned-results-from-bdev_direct_access fs/block_dev.c
--- a/fs/block_dev.c~dax-guarantee-page-aligned-results-from-bdev_direct_access
+++ a/fs/block_dev.c
@@ -489,6 +489,8 @@ long bdev_direct_access(struct block_dev
 	avail = ops->direct_access(bdev, sector, addr, pfn);
 	if (!avail)
 		return -ERANGE;
+	if (avail > 0 && avail & ~PAGE_MASK)
+		return -ENXIO;
 	return min(avail, size);
 }
 EXPORT_SYMBOL_GPL(bdev_direct_access);
diff -puN fs/dax.c~dax-guarantee-page-aligned-results-from-bdev_direct_access fs/dax.c
--- a/fs/dax.c~dax-guarantee-page-aligned-results-from-bdev_direct_access
+++ a/fs/dax.c
@@ -52,7 +52,6 @@ int dax_clear_blocks(struct inode *inode
 		sz = min_t(long, count, SZ_128K);
 		clear_pmem(addr, sz);
 		size -= sz;
-		BUG_ON(sz & 511);
 		sector += sz / 512;
 		cond_resched();
 	} while (size);
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

scatterlist-fix-sg_phys-masking.patch
pmem-dax-clean-up-clear_pmem.patch
dax-increase-granularity-of-dax_clear_blocks-operations.patch
dax-guarantee-page-aligned-results-from-bdev_direct_access.patch
dax-fix-lifetime-of-in-kernel-dax-mappings-with-dax_map_atomic.patch
dax-fix-lifetime-of-in-kernel-dax-mappings-with-dax_map_atomic-v3.patch
um-kill-pfn_t.patch
kvm-rename-pfn_t-to-kvm_pfn_t.patch
mm-dax-pmem-introduce-pfn_t.patch
mm-dax-pmem-introduce-pfn_t-v3.patch
mm-introduce-find_dev_pagemap.patch
x86-mm-introduce-vmem_altmap-to-augment-vmemmap_populate.patch
libnvdimm-pfn-pmem-allocate-memmap-array-in-persistent-memory.patch
avr32-convert-to-asm-generic-memory_modelh.patch
hugetlb-fix-compile-error-on-tile.patch
frv-fix-compiler-warning-from-definition-of-__pmd.patch
x86-mm-introduce-_page_devmap.patch
mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t.patch
mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t.patch
list-introduce-list_del_poison.patch
libnvdimm-pmem-move-request_queue-allocation-earlier-in-probe.patch
mm-dax-pmem-introduce-getput_dev_pagemap-for-dax-gup.patch
mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd.patch
mm-x86-get_user_pages-for-dax-mappings.patch
dax-provide-diagnostics-for-pmd-mapping-failures.patch
dax-re-enable-dax-pmd-mappings.patch

