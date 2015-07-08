From: akpm@linux-foundation.org
Subject: + zsmalloc-drop-unused-variable-nr_to_migrate.patch added to -mm
 tree
Date: Wed, 08 Jul 2015 15:37:50 -0700
Message-ID: <559da63e.mV4/165QZPssJyN2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45992 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755862AbbGHWhv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jul 2015 18:37:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: drop unused variable `nr_to_migrate'
has been added to the -mm tree.  Its filename is
     zsmalloc-drop-unused-variable-nr_to_migrate.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-drop-unused-variable-nr_to_migrate.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-drop-unused-variable-nr_to_migrate.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

zsmalloc-drop-unused-variable-nr_to_migrate.patch
zsmalloc-always-keep-per-class-stats.patch
zsmalloc-introduce-zs_can_compact-function.patch
zsmalloc-cosmetic-compaction-code-adjustments.patch
zsmalloc-zram-introduce-zs_pool_stats-api.patch
zsmalloc-account-the-number-of-compacted-pages.patch
zsmalloc-use-shrinker-to-trigger-auto-compaction.patch

