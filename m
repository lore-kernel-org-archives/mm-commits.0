From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-dax-pmem-introduce-getput_dev_pagemap-for-dax-gup-fix.patch removed from -mm tree
Date: Fri, 15 Jan 2016 16:31:39 -0800
Message-ID: <56998f6b.3x3iKoRObUFXUhuR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37835 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756755AbcAPAbk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 19:31:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: list, perf: fix list_force_poison() build regression
has been removed from the -mm tree.  Its filename was
     mm-dax-pmem-introduce-getput_dev_pagemap-for-dax-gup-fix.patch

This patch was dropped because it was folded into mm-dax-pmem-introduce-getput_dev_pagemap-for-dax-gup.patch

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: list, perf: fix list_force_poison() build regression

    In file included from
    /home/sfr/next/next/tools/include/linux/list.h:5:0,
                     from arch/../util/map.h:6,
                     from arch/../util/event.h:8,
                     from arch/../util/debug.h:7,
                     from arch/common.c:4:
    include/linux/list.h: In function 'list_force_poison':
    include/linux/list.h:123:56: error: unused parameter 'entry' [-Werror=unused-parameter]
     static inline void list_force_poison(struct list_head *entry)

perf does not like the empty definition of list_force_poison.  For
simplicity just switch to list_del in the non-debug case.

Fixes "mm, dax, pmem: introduce {get|put}_dev_pagemap() for dax-gup" in
-next.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN include/linux/list.h~mm-dax-pmem-introduce-getput_dev_pagemap-for-dax-gup-fix include/linux/list.h
--- a/include/linux/list.h~mm-dax-pmem-introduce-getput_dev_pagemap-for-dax-gup-fix
+++ a/include/linux/list.h
@@ -120,9 +120,8 @@ extern void list_del(struct list_head *e
  */
 extern void list_force_poison(struct list_head *entry);
 #else
-static inline void list_force_poison(struct list_head *entry)
-{
-}
+/* fallback to the less strict LIST_POISON* definitions */
+#define list_force_poison list_del
 #endif
 
 /**
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
mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd.patch
mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd-v5.patch
mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd-v5-fix.patch
mm-x86-get_user_pages-for-dax-mappings.patch
mm-x86-get_user_pages-for-dax-mappings-v5.patch
dax-provide-diagnostics-for-pmd-mapping-failures.patch
dax-re-enable-dax-pmd-mappings.patch

