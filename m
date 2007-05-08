From: akpm@linux-foundation.org
Subject: - get_unmapped_area-handles-map_fixed-on-ia64.patch removed from -mm tree
Date: Mon, 07 May 2007 17:04:04 -0700
Message-ID: <200705080004.l480448h008985@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60271 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967349AbXEHAEr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:04:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, bill.irwin@oracle.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     get_unmapped_area handles MAP_FIXED on ia64
has been removed from the -mm tree.  Its filename was
     get_unmapped_area-handles-map_fixed-on-ia64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: get_unmapped_area handles MAP_FIXED on ia64
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Handle MAP_FIXED in ia64 arch_get_unmapped_area and
hugetlb_get_unmapped_area(), just call prepare_hugepage_range in the later and
is_hugepage_only_range() in the former.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: William Irwin <bill.irwin@oracle.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/sys_ia64.c |    7 +++++++
 arch/ia64/mm/hugetlbpage.c  |    8 ++++++++
 2 files changed, 15 insertions(+)

diff -puN arch/ia64/kernel/sys_ia64.c~get_unmapped_area-handles-map_fixed-on-ia64 arch/ia64/kernel/sys_ia64.c
--- a/arch/ia64/kernel/sys_ia64.c~get_unmapped_area-handles-map_fixed-on-ia64
+++ a/arch/ia64/kernel/sys_ia64.c
@@ -33,6 +33,13 @@ arch_get_unmapped_area (struct file *fil
 	if (len > RGN_MAP_LIMIT)
 		return -ENOMEM;
 
+	/* handle fixed mapping: prevent overlap with huge pages */
+	if (flags & MAP_FIXED) {
+		if (is_hugepage_only_range(mm, addr, len))
+			return -EINVAL;
+		return addr;
+	}
+
 #ifdef CONFIG_HUGETLB_PAGE
 	if (REGION_NUMBER(addr) == RGN_HPAGE)
 		addr = 0;
diff -puN arch/ia64/mm/hugetlbpage.c~get_unmapped_area-handles-map_fixed-on-ia64 arch/ia64/mm/hugetlbpage.c
--- a/arch/ia64/mm/hugetlbpage.c~get_unmapped_area-handles-map_fixed-on-ia64
+++ a/arch/ia64/mm/hugetlbpage.c
@@ -148,6 +148,14 @@ unsigned long hugetlb_get_unmapped_area(
 		return -ENOMEM;
 	if (len & ~HPAGE_MASK)
 		return -EINVAL;
+
+	/* Handle MAP_FIXED */
+	if (flags & MAP_FIXED) {
+		if (prepare_hugepage_range(addr, len, pgoff))
+			return -EINVAL;
+		return addr;
+	}
+
 	/* This code assumes that RGN_HPAGE != 0. */
 	if ((REGION_NUMBER(addr) != RGN_HPAGE) || (addr & (HPAGE_SIZE - 1)))
 		addr = HPAGE_REGION_BASE;
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

origin.patch
git-powerpc.patch
gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed-powerpc-fixes.patch
use-slab_panic-flag-cleanup.patch
the-scheduled-removal-of-obsolete_oss-options.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
parport-dev-driver-model-support.patch
introduce-freezer-flags-rev-2.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
linux-kernel-markers-powerpc-optimization.patch
aty128fb-fix-blanking.patch
radeonfb-add-support-for-radeon-xpress-200m.patch
