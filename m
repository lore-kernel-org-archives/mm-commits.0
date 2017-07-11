From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-prevent-reuse-of-hwpoisoned-free-hugepages.patch removed from
 -mm tree
Date: Tue, 11 Jul 2017 12:22:58 -0700
Message-ID: <20170711192258.aW7L8K5el%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47530 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933570AbdGKTW7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:22:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, khandual@linux.vnet.ibm.com, mhocko@kernel.org, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com


The patch titled
     Subject: mm: hugetlb: prevent reuse of hwpoisoned free hugepages
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-prevent-reuse-of-hwpoisoned-free-hugepages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: hugetlb: prevent reuse of hwpoisoned free hugepages

Patch series "mm: hwpoison: fixlet for hugetlb migration".

This patchset updates the hwpoison/hugetlb code to address 2 reported
issues.

One is madvise(MADV_HWPOISON) failure reported by Intel's lkp robot (see
http://lkml.kernel.org/r/20170417055948.GM31394@yexl-desktop.) First half
was already fixed in mainline, and another half about hugetlb cases are
solved in this series.

Another issue is "narrow-down error affected region into a single 4kB page
instead of a whole hugetlb page" issue, which was tried by Anshuman
(http://lkml.kernel.org/r/20170420110627.12307-1-khandual@linux.vnet.ibm.com)
and I updated it to apply it more widely.


This patch (of 9):

We no longer use MIGRATE_ISOLATE to prevent reuse of hwpoison hugepages as
we did before.  So current dequeue_huge_page_node() doesn't work as
intended because it still uses is_migrate_isolate_page() for this check. 
This patch fixes it with PageHWPoison flag.

Link: http://lkml.kernel.org/r/1496305019-5493-2-git-send-email-n-horiguchi@ah.jp.nec.com
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c        |    3 +--
 mm/memory-failure.c |    1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-prevent-reuse-of-hwpoisoned-free-hugepages mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-prevent-reuse-of-hwpoisoned-free-hugepages
+++ a/mm/hugetlb.c
@@ -22,7 +22,6 @@
 #include <linux/rmap.h>
 #include <linux/swap.h>
 #include <linux/swapops.h>
-#include <linux/page-isolation.h>
 #include <linux/jhash.h>
 
 #include <asm/page.h>
@@ -872,7 +871,7 @@ static struct page *dequeue_huge_page_no
 	struct page *page;
 
 	list_for_each_entry(page, &h->hugepage_freelists[nid], lru)
-		if (!is_migrate_isolate_page(page))
+		if (!PageHWPoison(page))
 			break;
 	/*
 	 * if 'non-isolated free hugepage' not found on the list,
diff -puN mm/memory-failure.c~mm-hugetlb-prevent-reuse-of-hwpoisoned-free-hugepages mm/memory-failure.c
--- a/mm/memory-failure.c~mm-hugetlb-prevent-reuse-of-hwpoisoned-free-hugepages
+++ a/mm/memory-failure.c
@@ -49,7 +49,6 @@
 #include <linux/swap.h>
 #include <linux/backing-dev.h>
 #include <linux/migrate.h>
-#include <linux/page-isolation.h>
 #include <linux/suspend.h>
 #include <linux/slab.h>
 #include <linux/swapops.h>
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are


