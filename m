From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 053/155] mm/swapfile.c: fix comments for
 swapcache_prepare
Date: Wed, 01 Apr 2020 21:06:07 -0700
Message-ID: <20200402040607.Mj8nOg6I7%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbgDBEGI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:06:08 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chenwandun@huawei.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
