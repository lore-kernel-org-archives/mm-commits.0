From: akpm@linux-foundation.org
Subject: + dax-re-enable-dax-pmd-mappings.patch added to -mm tree
Date: Tue, 15 Dec 2015 16:17:24 -0800
Message-ID: <5670ad94.kVn3puezz9yTUBmT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47346 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932727AbbLPARZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Dec 2015 19:17:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: re-enable dax pmd mappings
has been added to the -mm tree.  Its filename is
     dax-re-enable-dax-pmd-mappings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-re-enable-dax-pmd-mappings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-re-enable-dax-pmd-mappings.patch

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
Subject: dax: re-enable dax pmd mappings

Now that the get_user_pages() path knows how to handle dax-pmd mappings,
remove the protections that disabled dax-pmd support.

Tests available from github.com/pmem/ndctl:

    make TESTS="lib/test-dax.sh lib/test-mmap.sh" check

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig |    3 ++-
 fs/dax.c   |    8 ++------
 2 files changed, 4 insertions(+), 7 deletions(-)

diff -puN fs/Kconfig~dax-re-enable-dax-pmd-mappings fs/Kconfig
--- a/fs/Kconfig~dax-re-enable-dax-pmd-mappings
+++ a/fs/Kconfig
@@ -50,7 +50,8 @@ config FS_DAX_PMD
 	bool
 	default FS_DAX
 	depends on FS_DAX
-	depends on BROKEN
+	depends on ZONE_DEVICE
+	depends on TRANSPARENT_HUGEPAGE
 
 endif # BLOCK
 
diff -puN fs/dax.c~dax-re-enable-dax-pmd-mappings fs/dax.c
--- a/fs/dax.c~dax-re-enable-dax-pmd-mappings
+++ a/fs/dax.c
@@ -581,7 +581,7 @@ int __dax_pmd_fault(struct vm_area_struc
 	sector_t block;
 	int result = 0;
 
-	/* dax pmd mappings are broken wrt gup and fork */
+	/* dax pmd mappings require pfn_t_devmap() */
 	if (!IS_ENABLED(CONFIG_FS_DAX_PMD))
 		return VM_FAULT_FALLBACK;
 
@@ -706,11 +706,7 @@ int __dax_pmd_fault(struct vm_area_struc
 			goto fallback;
 		}
 
-		/*
-		 * TODO: teach vmf_insert_pfn_pmd() to support
-		 * 'pte_special' for pmds
-		 */
-		if (pfn_t_has_page(dax.pfn)) {
+		if (!pfn_t_devmap(dax.pfn)) {
 			dax_unmap_atomic(bdev, &dax);
 			dax_pmd_dbg(bdev, address, "pfn not in memmap");
 			goto fallback;
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

