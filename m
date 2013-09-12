From: akpm@linux-foundation.org
Subject: [merged]
 mm-hwpoison-replace-atomic_long_sub-with-atomic_long_dec.patch removed from -mm tree
Date: Thu, 12 Sep 2013 12:45:27 -0700
Message-ID: <523219d7.Lq8xLBgN6IuO8Y6B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58586 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756196Ab3ILTp2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:45:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tony.luck@intel.com, n-horiguchi@ah.jp.nec.com, andi@firstfloor.org, liwanp@linux.vnet.ibm.com

Subject: [merged] mm-hwpoison-replace-atomic_long_sub-with-atomic_long_dec.patch removed from -mm tree
To: liwanp@linux.vnet.ibm.com,andi@firstfloor.org,n-horiguchi@ah.jp.nec.com,tony.luck@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:45:27 -0700


The patch titled
     Subject: mm/hwpoison: replace atomic_long_sub() with atomic_long_dec()
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-replace-atomic_long_sub-with-atomic_long_dec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/hwpoison: replace atomic_long_sub() with atomic_long_dec()

Replace atomic_long_sub() with atomic_long_dec() since the page is normal
page instead of hugetlbfs page or thp.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory-failure.c~mm-hwpoison-replace-atomic_long_sub-with-atomic_long_dec mm/memory-failure.c
--- a/mm/memory-failure.c~mm-hwpoison-replace-atomic_long_sub-with-atomic_long_dec
+++ a/mm/memory-failure.c
@@ -1366,7 +1366,7 @@ int unpoison_memory(unsigned long pfn)
 			return 0;
 		}
 		if (TestClearPageHWPoison(p))
-			atomic_long_sub(nr_pages, &num_poisoned_pages);
+			atomic_long_dec(&num_poisoned_pages);
 		pr_info("MCE: Software-unpoisoned free page %#lx\n", pfn);
 		return 0;
 	}
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

origin.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

