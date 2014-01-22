From: akpm@linux-foundation.org
Subject: [merged] mm-hwpoison-add-to-hwpoison_inject.patch removed from
 -mm tree
Date: Wed, 22 Jan 2014 12:14:34 -0800
Message-ID: <52e026aa.rKluSSZbYEgNiv1I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54962 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804AbaAVUOe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:14:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, murzin.v@gmail.com, liwanp@linux.vnet.ibm.com

Subject: [merged] mm-hwpoison-add-to-hwpoison_inject.patch removed from -mm tree
To: liwanp@linux.vnet.ibm.com,murzin.v@gmail.com,n-horiguchi@ah.jp.nec.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:14:34 -0800


The patch titled
     Subject: mm/hwpoison: add '#' to hwpoison_inject
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-add-to-hwpoison_inject.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/hwpoison: add '#' to hwpoison_inject

Add '#' to hwpoison_inject just as done in madvise_hwpoison.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Vladimir Murzin <murzin.v@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hwpoison-inject.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/hwpoison-inject.c~mm-hwpoison-add-to-hwpoison_inject mm/hwpoison-inject.c
--- a/mm/hwpoison-inject.c~mm-hwpoison-add-to-hwpoison_inject
+++ a/mm/hwpoison-inject.c
@@ -55,7 +55,7 @@ static int hwpoison_inject(void *data, u
 		return 0;
 
 inject:
-	printk(KERN_INFO "Injecting memory failure at pfn %lx\n", pfn);
+	pr_info("Injecting memory failure at pfn %#lx\n", pfn);
 	return memory_failure(pfn, 18, MF_COUNT_INCREASED);
 }
 
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

origin.patch
mm-remove-bug_on-from-mlock_vma_page.patch
mm-documentation-remove-hopelessly-out-of-date-locking-doc.patch
mm-memory-failurec-shift-page-lock-from-head-page-to-tail-page-after-thp-split.patch
mm-new_vma_page-cannot-see-null-vma-for-hugetlb-pages.patch
linux-next.patch
mm-migratec-fix-setting-of-cpupid-on-page-migration-twice-against-normal-page.patch

