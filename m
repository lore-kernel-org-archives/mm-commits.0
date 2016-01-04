From: akpm@linux-foundation.org
Subject: + dax-add-support-for-fsync-sync-v6-fix.patch added to -mm tree
Date: Mon, 04 Jan 2016 12:47:38 -0800
Message-ID: <568ada6a.5Esd4BBsjlVtIZ9k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48899 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbcADUrj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jan 2016 15:47:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     From: Dan Williams <dan.j.williams@intel.com>
has been added to the -mm tree.  Its filename is
     dax-add-support-for-fsync-sync-v6-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-add-support-for-fsync-sync-v6-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-add-support-for-fsync-sync-v6-fix.patch

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
Subject: dax: fix dax_pmd_dbg build warning

Fixes below warning from commit 3cb108f941deb
"dax-add-support-for-fsync-sync-v6" in -next.

    fs/dax.c: In function `__dax_pmd_fault':
    fs/dax.c:916:15: warning: passing argument 1 of `__dax_dbg' from incompatible pointer type
         dax_pmd_dbg(bdev, address,
                   ^
    fs/dax.c:738:13: note: expected `struct buffer_head *' but argument is of type `struct block_device *'
     static void __dax_dbg(struct buffer_head *bh, unsigned long address,

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/dax.c~dax-add-support-for-fsync-sync-v6-fix fs/dax.c
--- a/fs/dax.c~dax-add-support-for-fsync-sync-v6-fix
+++ a/fs/dax.c
@@ -913,7 +913,7 @@ int __dax_pmd_fault(struct vm_area_struc
 			error = dax_radix_entry(mapping, pgoff, dax.sector,
 					true, true);
 			if (error) {
-				dax_pmd_dbg(bdev, address,
+				dax_pmd_dbg(&bh, address,
 						"PMD radix insertion failed");
 				goto fallback;
 			}
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

pmem-dax-clean-up-clear_pmem.patch
dax-increase-granularity-of-dax_clear_blocks-operations.patch
dax-guarantee-page-aligned-results-from-bdev_direct_access.patch
dax-fix-lifetime-of-in-kernel-dax-mappings-with-dax_map_atomic.patch
dax-fix-lifetime-of-in-kernel-dax-mappings-with-dax_map_atomic-v3.patch
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
dax-add-support-for-fsync-sync-v6-fix.patch

