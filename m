From: akpm@linux-foundation.org
Subject: +
 mm-huge_memoryc-fix-stale-comments-of-transparent_hugepage_flags.patch
 added to -mm tree
Date: Wed, 18 Sep 2013 15:53:58 -0700
Message-ID: <523a2f06.Zvdww5BvCP2/TAmd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47740 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab3IRWx7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Sep 2013 18:53:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, liwanp@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, wujianguo@huawei.com

Subject: + mm-huge_memoryc-fix-stale-comments-of-transparent_hugepage_flags.patch added to -mm tree
To: wujianguo@huawei.com,kirill.shutemov@linux.intel.com,liwanp@linux.vnet.ibm.com
From: akpm@linux-foundation.org
Date: Wed, 18 Sep 2013 15:53:58 -0700


The patch titled
     Subject: mm/huge_memory.c: fix stale comments of transparent_hugepage_flags
has been added to the -mm tree.  Its filename is
     mm-huge_memoryc-fix-stale-comments-of-transparent_hugepage_flags.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-huge_memoryc-fix-stale-comments-of-transparent_hugepage_flags.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-huge_memoryc-fix-stale-comments-of-transparent_hugepage_flags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-acpi-use-numa_no_node.patch
x86-srat-use-numa_no_node.patch
mm-vmalloc-use-numa_no_node.patch
mm-huge_memoryc-fix-stale-comments-of-transparent_hugepage_flags.patch

