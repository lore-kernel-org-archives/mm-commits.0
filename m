From: akpm@linux-foundation.org
Subject: [merged]
 mm-huge_memoryc-fix-stale-comments-of-transparent_hugepage_flags.patch
 removed from -mm tree
Date: Wed, 13 Nov 2013 12:37:53 -0800
Message-ID: <5283e321.hjUuJqBukjx5ALLC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42503 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab3KMUhx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:37:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, liwanp@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, wujianguo@huawei.com

Subject: [merged] mm-huge_memoryc-fix-stale-comments-of-transparent_hugepage_flags.patch removed from -mm tree
To: wujianguo@huawei.com,kirill.shutemov@linux.intel.com,liwanp@linux.vnet.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:37:53 -0800


The patch titled
     Subject: mm/huge_memory.c: fix stale comments of transparent_hugepage_flags
has been removed from the -mm tree.  Its filename was
     mm-huge_memoryc-fix-stale-comments-of-transparent_hugepage_flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jianguo Wu <wujianguo@huawei.com>
Subject: mm/huge_memory.c: fix stale comments of transparent_hugepage_flags

Since commit 13ece886d9 ("thp: transparent hugepage config choice"),
transparent hugepage support is disabled by default, and
TRANSPARENT_HUGEPAGE_ALWAYS is configured when TRANSPARENT_HUGEPAGE=y.

And since commit d39d33c332 ("thp: enable direct defrag"), defrag is
enable for all transparent hugepage page faults by default, not only in
MADV_HUGEPAGE regions.

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN mm/huge_memory.c~mm-huge_memoryc-fix-stale-comments-of-transparent_hugepage_flags mm/huge_memory.c
--- a/mm/huge_memory.c~mm-huge_memoryc-fix-stale-comments-of-transparent_hugepage_flags
+++ a/mm/huge_memory.c
@@ -27,11 +27,12 @@
 #include "internal.h"
 
 /*
- * By default transparent hugepage support is enabled for all mappings
- * and khugepaged scans all mappings. Defrag is only invoked by
- * khugepaged hugepage allocations and by page faults inside
- * MADV_HUGEPAGE regions to avoid the risk of slowing down short lived
- * allocations.
+ * By default transparent hugepage support is disabled in order that avoid
+ * to risk increase the memory footprint of applications without a guaranteed
+ * benefit. When transparent hugepage support is enabled, is for all mappings,
+ * and khugepaged scans all mappings.
+ * Defrag is invoked by khugepaged hugepage allocations and by page faults
+ * for all hugepage allocations.
  */
 unsigned long transparent_hugepage_flags __read_mostly =
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS
_

Patches currently in -mm which might be from wujianguo@huawei.com are

origin.patch
x86-srat-use-numa_no_node.patch
linux-next.patch

