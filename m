From: akpm@linux-foundation.org
Subject: [merged] dax-re-enable-dax-pmd-mappings.patch removed from -mm
 tree
Date: Tue, 19 Jan 2016 12:13:53 -0800
Message-ID: <569e9901.ah5odsUoz1sdmJry%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44387 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933143AbcASUNy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:13:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: re-enable dax pmd mappings
has been removed from the -mm tree.  Its filename was
     dax-re-enable-dax-pmd-mappings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -592,7 +592,7 @@ int __dax_pmd_fault(struct vm_area_struc
 	sector_t block;
 	int result = 0;
 
-	/* dax pmd mappings are broken wrt gup and fork */
+	/* dax pmd mappings require pfn_t_devmap() */
 	if (!IS_ENABLED(CONFIG_FS_DAX_PMD))
 		return VM_FAULT_FALLBACK;
 
@@ -717,11 +717,7 @@ int __dax_pmd_fault(struct vm_area_struc
 			goto fallback;
 		}
 
-		/*
-		 * TODO: teach vmf_insert_pfn_pmd() to support
-		 * 'pte_special' for pmds
-		 */
-		if (pfn_t_has_page(dax.pfn)) {
+		if (!pfn_t_devmap(dax.pfn)) {
 			dax_unmap_atomic(bdev, &dax);
 			dax_pmd_dbg(&bh, address, "pfn not in memmap");
 			goto fallback;
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

dax-add-support-for-fsync-sync-v6-fix.patch

