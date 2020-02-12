From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swapfilec-fix-comments-for-swapcache_prepare.patch
 added to -mm tree
Date: Wed, 12 Feb 2020 13:18:58 -0800
Message-ID: <20200212211858.uGZP4Gsgm%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727548AbgBLVTA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Feb 2020 16:19:00 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chenwandun@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swapfile.c: fix comments for swapcache_prepare
has been added to the -mm tree.  Its filename is
     mm-swapfilec-fix-comments-for-swapcache_prepare.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swapfilec-fix-comments-for-swapcache_prepare.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swapfilec-fix-comments-for-swapcache_prepare.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -3480,7 +3480,7 @@ int swap_duplicate(swp_entry_t entry)
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

mm-swapfilec-fix-comments-for-swapcache_prepare.patch
