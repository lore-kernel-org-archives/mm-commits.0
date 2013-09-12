From: akpm@linux-foundation.org
Subject: [merged]
 hwpoison-always-unset-migrate_isolate-before-returning-from-soft_offline_page.patch removed from -mm tree
Date: Thu, 12 Sep 2013 12:45:19 -0700
Message-ID: <523219cf.lvGvRqz3lkLUR4b6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58566 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756118Ab3ILTpU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:45:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tony.luck@intel.com, liwanp@linux.vnet.ibm.com, fengguang.wu@intel.com, andi@firstfloor.org, n-horiguchi@ah.jp.nec.com

Subject: [merged] hwpoison-always-unset-migrate_isolate-before-returning-from-soft_offline_page.patch removed from -mm tree
To: n-horiguchi@ah.jp.nec.com,andi@firstfloor.org,fengguang.wu@intel.com,liwanp@linux.vnet.ibm.com,tony.luck@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:45:19 -0700


The patch titled
     Subject: hwpoison: always unset MIGRATE_ISOLATE before returning from soft_offline_page()
has been removed from the -mm tree.  Its filename was
     hwpoison-always-unset-migrate_isolate-before-returning-from-soft_offline_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: hwpoison: always unset MIGRATE_ISOLATE before returning from soft_offline_page()

Soft offline code expects that MIGRATE_ISOLATE is set on the target page
only during soft offlining work.  But currenly it doesn't work as expected
when get_any_page() fails and returns negative value.  In the result, end
users can have unexpectedly isolated pages.  This patch just fixes it.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/memory-failure.c~hwpoison-always-unset-migrate_isolate-before-returning-from-soft_offline_page mm/memory-failure.c
--- a/mm/memory-failure.c~hwpoison-always-unset-migrate_isolate-before-returning-from-soft_offline_page
+++ a/mm/memory-failure.c
@@ -1553,7 +1553,7 @@ int soft_offline_page(struct page *page,
 
 	ret = get_any_page(page, pfn, flags);
 	if (ret < 0)
-		return ret;
+		goto unset;
 	if (ret) { /* for in-use pages */
 		if (PageHuge(page))
 			ret = soft_offline_huge_page(page, flags);
@@ -1570,6 +1570,7 @@ int soft_offline_page(struct page *page,
 			atomic_long_inc(&num_poisoned_pages);
 		}
 	}
+unset:
 	unset_migratetype_isolate(page, MIGRATE_MOVABLE);
 	return ret;
 }
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch

