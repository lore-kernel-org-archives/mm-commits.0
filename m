From: akpm@linux-foundation.org
Subject: [merged]
 mm-swapfilec-fix-comments-for-swapcache_prepare.patch removed from -mm tree
Date: Fri, 03 Apr 2020 13:37:03 -0700
Message-ID: <20200403203703.ncfyVMRzq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgDCUhE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:37:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chenwandun@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swapfile.c: fix comments for swapcache_prepare
has been removed from the -mm tree.  Its filename was
     mm-swapfilec-fix-comments-for-swapcache_prepare.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chen Wandun <chenwandun@huawei.com>
Subject: mm/swapfile.c: fix comments for swapcache_prepare

The -EEXIST returned by __swap_duplicate means there is a swap cache
instead -EBUSY

Link: http://lkml.kernel.org/r/20200212145754.27123-1-chenwandun@huawei.com
Signed-off-by: Chen Wandun <chenwandun@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-swapfilec-fix-comments-for-swapcache_prepare
+++ a/mm/swapfile.c
@@ -3475,7 +3475,7 @@ int swap_duplicate(swp_entry_t entry)
  *
  * Called when allocating swap cache for existing swap entry,
  * This can return error codes. Returns 0 at success.
- * -EBUSY means there is a swap cache.
+ * -EEXIST means there is a swap cache.
  * Note: return code is different from swap_duplicate().
  */
 int swapcache_prepare(swp_entry_t entry)
_

Patches currently in -mm which might be from chenwandun@huawei.com are
