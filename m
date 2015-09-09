From: akpm@linux-foundation.org
Subject: [merged] zsmalloc-use-class-pages_per_zspage.patch removed from
 -mm tree
Date: Wed, 09 Sep 2015 12:54:11 -0700
Message-ID: <55f08e63.b8FKky3lX7CVJZQ6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41470 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755307AbbIITyL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:54:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: use class->pages_per_zspage
has been removed from the -mm tree.  Its filename was
     zsmalloc-use-class-pages_per_zspage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zsmalloc: use class->pages_per_zspage

There is no need to recalcurate pages_per_zspage in runtime.  Just use
class->pages_per_zspage to avoid unnecessary runtime overhead.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-use-class-pages_per_zspage mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-use-class-pages_per_zspage
+++ a/mm/zsmalloc.c
@@ -1723,7 +1723,7 @@ static unsigned long zs_can_compact(stru
 	obj_wasted /= get_maxobj_per_zspage(class->size,
 			class->pages_per_zspage);
 
-	return obj_wasted * get_pages_per_zspage(class->size);
+	return obj_wasted * class->pages_per_zspage;
 }
 
 static void __zs_compact(struct zs_pool *pool, struct size_class *class)
@@ -1761,8 +1761,7 @@ static void __zs_compact(struct zs_pool
 
 		putback_zspage(pool, class, dst_page);
 		if (putback_zspage(pool, class, src_page) == ZS_EMPTY)
-			pool->stats.pages_compacted +=
-				get_pages_per_zspage(class->size);
+			pool->stats.pages_compacted += class->pages_per_zspage;
 		spin_unlock(&class->lock);
 		cond_resched();
 		spin_lock(&class->lock);
_

Patches currently in -mm which might be from minchan@kernel.org are

x86-add-pmd_-for-thp.patch
sparc-add-pmd_-for-thp.patch
powerpc-add-pmd_-for-thp.patch
arm-add-pmd_mkclean-for-thp.patch
arm64-add-pmd_-for-thp.patch
mm-support-madvisemadv_free.patch
mm-support-madvisemadv_free-fix.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch
mm-free-swp_entry-in-madvise_free.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch

