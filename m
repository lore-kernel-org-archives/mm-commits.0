From: akpm@linux-foundation.org
Subject: [merged] zsmalloc-drop-unused-variable-nr_to_migrate.patch
 removed from -mm tree
Date: Wed, 09 Sep 2015 12:53:53 -0700
Message-ID: <55f08e51.0mC7vBmkLdlHx7tS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41366 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687AbbIITxy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:53:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: drop unused variable `nr_to_migrate'
has been removed from the -mm tree.  Its filename was
     zsmalloc-drop-unused-variable-nr_to_migrate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zsmalloc: drop unused variable `nr_to_migrate'

This patchset tweaks compaction and makes it possible to trigger pool
compaction automatically when system is getting low on memory.

zsmalloc in some cases can suffer from a notable fragmentation and
compaction can release some considerable amount of memory.  The problem
here is that currently we fully rely on user space to perform compaction
when needed.  However, performing zsmalloc compaction is not always an
obvious thing to do.  For example, suppose we have a `idle' fragmented
(compaction was never performed) zram device and system is getting low on
memory due to some 3rd party user processes (gcc LTO, or firefox, etc.). 
It's quite unlikely that user space will issue zpool compaction in this
case.  Besides, user space cannot tell for sure how badly pool is
fragmented; however, this info is known to zsmalloc and, hence, to a
shrinker.


This patch (of 7):

__zs_compact() does not use `nr_to_migrate', drop it.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-drop-unused-variable-nr_to_migrate mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-drop-unused-variable-nr_to_migrate
+++ a/mm/zsmalloc.c
@@ -1703,7 +1703,6 @@ static struct page *isolate_source_page(
 static unsigned long __zs_compact(struct zs_pool *pool,
 				struct size_class *class)
 {
-	int nr_to_migrate;
 	struct zs_compact_control cc;
 	struct page *src_page;
 	struct page *dst_page = NULL;
@@ -1714,8 +1713,6 @@ static unsigned long __zs_compact(struct
 
 		BUG_ON(!is_first_page(src_page));
 
-		/* The goal is to migrate all live objects in source page */
-		nr_to_migrate = src_page->inuse;
 		cc.index = 0;
 		cc.s_page = src_page;
 
@@ -1730,7 +1727,6 @@ static unsigned long __zs_compact(struct
 
 			putback_zspage(pool, class, dst_page);
 			nr_total_migrated += cc.nr_migrated;
-			nr_to_migrate -= cc.nr_migrated;
 		}
 
 		/* Stop if we couldn't find slot */
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are


