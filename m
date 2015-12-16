From: akpm@linux-foundation.org
Subject: + dax-increase-granularity-of-dax_clear_blocks-operations.patch
 added to -mm tree
Date: Tue, 15 Dec 2015 16:16:33 -0800
Message-ID: <5670ad61.uEsmfarkq2b4jovb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47200 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507AbbLPAQe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Dec 2015 19:16:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, jack@suse.com, jmoyer@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: increase granularity of dax_clear_blocks() operations
has been added to the -mm tree.  Its filename is
     dax-increase-granularity-of-dax_clear_blocks-operations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-increase-granularity-of-dax_clear_blocks-operations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-increase-granularity-of-dax_clear_blocks-operations.patch

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
Subject: dax: increase granularity of dax_clear_blocks() operations

dax_clear_blocks is currently performing a cond_resched() after every
PAGE_SIZE memset.  We need not check so frequently, for example md-raid
only calls cond_resched() at stripe granularity.  Also, in preparation for
introducing a dax_map_atomic() operation that temporarily pins a dax
mapping move the call to cond_resched() to the outer loop.

The worst case latency between calls to cond_resched() after this change
is 500us the average latency is 133us.  This is up from a 10us max and 4us
average.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Jan Kara <jack@suse.com>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |   22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff -puN fs/dax.c~dax-increase-granularity-of-dax_clear_blocks-operations fs/dax.c
--- a/fs/dax.c~dax-increase-granularity-of-dax_clear_blocks-operations
+++ a/fs/dax.c
@@ -28,6 +28,7 @@
 #include <linux/sched.h>
 #include <linux/uio.h>
 #include <linux/vmstat.h>
+#include <linux/sizes.h>
 
 /*
  * dax_clear_blocks() is called from within transaction context from XFS,
@@ -43,24 +44,17 @@ int dax_clear_blocks(struct inode *inode
 	do {
 		void __pmem *addr;
 		unsigned long pfn;
-		long count;
+		long count, sz;
 
 		count = bdev_direct_access(bdev, sector, &addr, &pfn, size);
 		if (count < 0)
 			return count;
-		BUG_ON(size < count);
-		while (count > 0) {
-			unsigned pgsz = PAGE_SIZE - offset_in_page(addr);
-			if (pgsz > count)
-				pgsz = count;
-			clear_pmem(addr, pgsz);
-			addr += pgsz;
-			size -= pgsz;
-			count -= pgsz;
-			BUG_ON(pgsz & 511);
-			sector += pgsz / 512;
-			cond_resched();
-		}
+		sz = min_t(long, count, SZ_128K);
+		clear_pmem(addr, sz);
+		size -= sz;
+		BUG_ON(sz & 511);
+		sector += sz / 512;
+		cond_resched();
 	} while (size);
 
 	wmb_pmem();
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

