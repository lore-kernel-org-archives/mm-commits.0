From: akpm@linux-foundation.org
Subject: - get_unmapped_area-handles-map_fixed-on-sparc64.patch removed from -mm tree
Date: Mon, 07 May 2007 17:04:08 -0700
Message-ID: <200705080004.l48048lT008991@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50760 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967345AbXEHAEd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:04:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, bill.irwin@oracle.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     get_unmapped_area handles MAP_FIXED on sparc64
has been removed from the -mm tree.  Its filename was
     get_unmapped_area-handles-map_fixed-on-sparc64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: get_unmapped_area handles MAP_FIXED on sparc64
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Handle MAP_FIXED in hugetlb_get_unmapped_area on sparc64 by just using
prepare_hugepage_range()

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: William Irwin <bill.irwin@oracle.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc64/mm/hugetlbpage.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN arch/sparc64/mm/hugetlbpage.c~get_unmapped_area-handles-map_fixed-on-sparc64 arch/sparc64/mm/hugetlbpage.c
--- a/arch/sparc64/mm/hugetlbpage.c~get_unmapped_area-handles-map_fixed-on-sparc64
+++ a/arch/sparc64/mm/hugetlbpage.c
@@ -175,6 +175,12 @@ hugetlb_get_unmapped_area(struct file *f
 	if (len > task_size)
 		return -ENOMEM;
 
+	if (flags & MAP_FIXED) {
+		if (prepare_hugepage_range(addr, len, pgoff))
+			return -EINVAL;
+		return addr;
+	}
+
 	if (addr) {
 		addr = ALIGN(addr, HPAGE_SIZE);
 		vma = find_vma(mm, addr);
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
