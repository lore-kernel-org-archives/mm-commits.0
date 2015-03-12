From: akpm@linux-foundation.org
Subject: + mm-refactor-zone_movable_is_highmem.patch added to -mm tree
Date: Thu, 12 Mar 2015 15:58:43 -0700
Message-ID: <55021a23.+ojIdMLqs5JrhUun%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45364 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755865AbbCLW6o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Mar 2015 18:58:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhenzhang.zhang@huawei.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: refactor zone_movable_is_highmem()
has been added to the -mm tree.  Its filename is
     mm-refactor-zone_movable_is_highmem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-refactor-zone_movable_is_highmem.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-refactor-zone_movable_is_highmem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhang Zhen <zhenzhang.zhang@huawei.com>
Subject: mm: refactor zone_movable_is_highmem()

All callers of zone_movable_is_highmem are under #ifdef CONFIG_HIGHMEM,
so the else branch return 0 is not needed.

Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/mmzone.h~mm-refactor-zone_movable_is_highmem include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-refactor-zone_movable_is_highmem
+++ a/include/linux/mmzone.h
@@ -843,16 +843,16 @@ static inline int populated_zone(struct
 
 extern int movable_zone;
 
+#ifdef CONFIG_HIGHMEM
 static inline int zone_movable_is_highmem(void)
 {
-#if defined(CONFIG_HIGHMEM) && defined(CONFIG_HAVE_MEMBLOCK_NODE_MAP)
+#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 	return movable_zone == ZONE_HIGHMEM;
-#elif defined(CONFIG_HIGHMEM)
-	return (ZONE_MOVABLE - 1) == ZONE_HIGHMEM;
 #else
-	return 0;
+	return (ZONE_MOVABLE - 1) == ZONE_HIGHMEM;
 #endif
 }
+#endif
 
 static inline int is_highmem_idx(enum zone_type idx)
 {
_

Patches currently in -mm which might be from zhenzhang.zhang@huawei.com are

vfs-delete-vfs_readdir-function-declaration.patch
mm-hotplug-fix-concurrent-memory-hot-add-deadlock.patch
mm-refactor-zone_movable_is_highmem.patch
linux-next.patch

