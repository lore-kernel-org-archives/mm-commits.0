From: akpm@linux-foundation.org
Subject: [merged] tile-expose-number-of-page-table-levels.patch removed
 from -mm tree
Date: Wed, 15 Apr 2015 12:10:15 -0700
Message-ID: <552eb797.23bhtOSlfmEBbWpw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48123 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933343AbbDOTKQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:10:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, cmetcalf@ezchip.com, linux@roeck-us.net, mm-commits@vger.kernel.org


The patch titled
     Subject: tile: expose number of page table levels
has been removed from the -mm tree.  Its filename was
     tile-expose-number-of-page-table-levels.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: tile: expose number of page table levels

We would want to use number of page table level to define mm_struct.
Let's expose it as CONFIG_PGTABLE_LEVELS.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Chris Metcalf <cmetcalf@ezchip.com>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/Kconfig |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN arch/tile/Kconfig~tile-expose-number-of-page-table-levels arch/tile/Kconfig
--- a/arch/tile/Kconfig~tile-expose-number-of-page-table-levels
+++ a/arch/tile/Kconfig
@@ -147,6 +147,11 @@ config ARCH_DEFCONFIG
 	default "arch/tile/configs/tilepro_defconfig" if !TILEGX
 	default "arch/tile/configs/tilegx_defconfig" if TILEGX
 
+config PGTABLE_LEVELS
+	int
+	default 3 if 64BIT
+	default 2
+
 source "init/Kconfig"
 
 source "kernel/Kconfig.freezer"
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
mm-consolidate-all-page-flags-helpers-in-linux-page-flagsh.patch
mm-avoid-tail-page-refcounting-on-non-thp-compound-pages.patch
mm-migrate-check-before-clear-pageswapcache.patch
mm-page-writeback-check-before-clear-pagereclaim.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-sanitize-page-mapping-for-tail-pages-v2.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
thp-handle-errors-in-hugepage_init-properly.patch
thp-do-not-adjust-zone-water-marks-if-khugepaged-is-not-started.patch
mm-mmapc-use-while-instead-of-ifgoto.patch
mm-mmapc-use-while-instead-of-ifgoto-fix.patch
mm-uninline-and-cleanup-page-mapping-related-helpers.patch
mm-uninline-and-cleanup-page-mapping-related-helpers-checkpatch-fixes.patch
thp-cleanup-khugepaged-startup.patch
mmv41-new-pfn_mkwrite-same-as-page_mkwrite-for-vm_pfnmap.patch
dax-use-pfn_mkwrite-to-update-c-mtime-freeze-protection.patch
dax-unify-ext2-4_dax_file_operations.patch
linux-next.patch

