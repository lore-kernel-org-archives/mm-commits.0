From: akpm@linux-foundation.org
Subject: + zsmalloc-introduce-zs_can_compact-function.patch added to -mm
 tree
Date: Wed, 08 Jul 2015 15:37:54 -0700
Message-ID: <559da642.qedJBKsdSAMmVEjP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46000 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755890AbbGHWhz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jul 2015 18:37:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: introduce zs_can_compact() function
has been added to the -mm tree.  Its filename is
     zsmalloc-introduce-zs_can_compact-function.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-introduce-zs_can_compact-function.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-introduce-zs_can_compact-function.patch

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
Subject: zsmalloc: introduce zs_can_compact() function

This function checks if class compaction will free any pages.  Rephrasing
-- do we have enough unused objects to form at least one ZS_EMPTY page and
free it.  It aborts compaction if class compaction will not result in any
(further) savings.

EXAMPLE (this debug output is not part of this patch set):

-- class size
-- number of allocated objects
-- number of used objects
-- max objects per zspage
-- pages per zspage
-- estimated number of pages that will be freed

[..]
class-512 objs:544 inuse:540 maxobj-per-zspage:8  pages-per-zspage:1 zspages-to-free:0
 ... class-512 compaction is useless. break
class-496 objs:660 inuse:570 maxobj-per-zspage:33 pages-per-zspage:4 zspages-to-free:2
class-496 objs:627 inuse:570 maxobj-per-zspage:33 pages-per-zspage:4 zspages-to-free:1
class-496 objs:594 inuse:570 maxobj-per-zspage:33 pages-per-zspage:4 zspages-to-free:0
 ... class-496 compaction is useless. break
class-448 objs:657 inuse:617 maxobj-per-zspage:9  pages-per-zspage:1 zspages-to-free:4
class-448 objs:648 inuse:617 maxobj-per-zspage:9  pages-per-zspage:1 zspages-to-free:3
class-448 objs:639 inuse:617 maxobj-per-zspage:9  pages-per-zspage:1 zspages-to-free:2
class-448 objs:630 inuse:617 maxobj-per-zspage:9  pages-per-zspage:1 zspages-to-free:1
class-448 objs:621 inuse:617 maxobj-per-zspage:9  pages-per-zspage:1 zspages-to-free:0
 ... class-448 compaction is useless. break
class-432 objs:728 inuse:685 maxobj-per-zspage:28 pages-per-zspage:3 zspages-to-free:1
class-432 objs:700 inuse:685 maxobj-per-zspage:28 pages-per-zspage:3 zspages-to-free:0
 ... class-432 compaction is useless. break
class-416 objs:819 inuse:705 maxobj-per-zspage:39 pages-per-zspage:4 zspages-to-free:2
class-416 objs:780 inuse:705 maxobj-per-zspage:39 pages-per-zspage:4 zspages-to-free:1
class-416 objs:741 inuse:705 maxobj-per-zspage:39 pages-per-zspage:4 zspages-to-free:0
 ... class-416 compaction is useless. break
class-400 objs:690 inuse:674 maxobj-per-zspage:10 pages-per-zspage:1 zspages-to-free:1
class-400 objs:680 inuse:674 maxobj-per-zspage:10 pages-per-zspage:1 zspages-to-free:0
 ... class-400 compaction is useless. break
class-384 objs:736 inuse:709 maxobj-per-zspage:32 pages-per-zspage:3 zspages-to-free:0
 ... class-384 compaction is useless. break
[..]

Every "compaction is useless" indicates that we saved CPU cycles.

class-512 has
	544	object allocated
	540	objects used
	8	objects per-page

Even if we have a ALMOST_EMPTY zspage, we still don't have enough room to
migrate all of its objects and free this zspage; so compaction will not
make a lot of sense, it's better to just leave it as is.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff -puN mm/zsmalloc.c~zsmalloc-introduce-zs_can_compact-function mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-introduce-zs_can_compact-function
+++ a/mm/zsmalloc.c
@@ -1676,6 +1676,29 @@ static struct page *isolate_source_page(
 	return page;
 }
 
+/*
+ *
+ * Based on the number of unused allocated objects calculate
+ * and return the number of pages that we can free.
+ *
+ * Should be called under class->lock.
+ */
+static unsigned long zs_can_compact(struct size_class *class)
+{
+	unsigned long obj_wasted;
+
+	if (!zs_stat_get(class, CLASS_ALMOST_EMPTY))
+		return 0;
+
+	obj_wasted = zs_stat_get(class, OBJ_ALLOCATED) -
+		zs_stat_get(class, OBJ_USED);
+
+	obj_wasted /= get_maxobj_per_zspage(class->size,
+			class->pages_per_zspage);
+
+	return obj_wasted * get_pages_per_zspage(class->size);
+}
+
 static unsigned long __zs_compact(struct zs_pool *pool,
 				struct size_class *class)
 {
@@ -1689,6 +1712,9 @@ static unsigned long __zs_compact(struct
 
 		BUG_ON(!is_first_page(src_page));
 
+		if (!zs_can_compact(class))
+			break;
+
 		cc.index = 0;
 		cc.s_page = src_page;
 
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zsmalloc-drop-unused-variable-nr_to_migrate.patch
zsmalloc-always-keep-per-class-stats.patch
zsmalloc-introduce-zs_can_compact-function.patch
zsmalloc-cosmetic-compaction-code-adjustments.patch
zsmalloc-zram-introduce-zs_pool_stats-api.patch
zsmalloc-account-the-number-of-compacted-pages.patch
zsmalloc-use-shrinker-to-trigger-auto-compaction.patch

