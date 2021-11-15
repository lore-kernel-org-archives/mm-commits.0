Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E096AC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 21:33:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0D2E6321F
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 21:33:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240267AbhKOVgG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Nov 2021 16:36:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:55862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349374AbhKOVJh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Nov 2021 16:09:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E032961B1E;
        Mon, 15 Nov 2021 21:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637010402;
        bh=QunjhX2JtO8VIPeoM/ngcrn7oLqh64R99oAF1g78uJI=;
        h=Date:From:To:Subject:From;
        b=M5RzmxQFkS1XfeTxaGZ+8hRPCL1z8b/aetw7ykN2Ffekr7Pf84eqpIboNUkxo4YGW
         uBSLfd27S58dkIziKK+uKnMUJMvowfy3gry4nDGKKbk4CqvmIyR8t8fCCKfDIIc/7g
         zSL0iIy/va+1nZLqEz2mt3Wwe22ftAxa7VhcRBSk=
Date:   Mon, 15 Nov 2021 13:06:41 -0800
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, minchan@kernel.org,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        senozhatsky@chromium.org, tglx@linutronix.de,
        umgwanakikbuti@gmail.com
Subject:  + zsmalloc-rename-zs_stat_type-to-class_stat_type.patch
 added to -mm tree
Message-ID: <20211115210641.c5daIIFfm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: rename zs_stat_type to class_stat_type
has been added to the -mm tree.  Its filename is
     zsmalloc-rename-zs_stat_type-to-class_stat_type.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-rename-zs_stat_type-to-class_stat_type.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-rename-zs_stat_type-to-class_stat_type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zsmalloc: rename zs_stat_type to class_stat_type

The stat aims for class stat, not zspage so rename it.

Link: https://lkml.kernel.org/r/20211115185909.3949505-3-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-rename-zs_stat_type-to-class_stat_type
+++ a/mm/zsmalloc.c
@@ -158,7 +158,7 @@ enum fullness_group {
 	NR_ZS_FULLNESS,
 };
 
-enum zs_stat_type {
+enum class_stat_type {
 	CLASS_EMPTY,
 	CLASS_ALMOST_EMPTY,
 	CLASS_ALMOST_FULL,
@@ -549,21 +549,21 @@ static int get_size_class_index(int size
 	return min_t(int, ZS_SIZE_CLASSES - 1, idx);
 }
 
-/* type can be of enum type zs_stat_type or fullness_group */
-static inline void zs_stat_inc(struct size_class *class,
+/* type can be of enum type class_stat_type or fullness_group */
+static inline void class_stat_inc(struct size_class *class,
 				int type, unsigned long cnt)
 {
 	class->stats.objs[type] += cnt;
 }
 
-/* type can be of enum type zs_stat_type or fullness_group */
-static inline void zs_stat_dec(struct size_class *class,
+/* type can be of enum type class_stat_type or fullness_group */
+static inline void class_stat_dec(struct size_class *class,
 				int type, unsigned long cnt)
 {
 	class->stats.objs[type] -= cnt;
 }
 
-/* type can be of enum type zs_stat_type or fullness_group */
+/* type can be of enum type class_stat_type or fullness_group */
 static inline unsigned long zs_stat_get(struct size_class *class,
 				int type)
 {
@@ -725,7 +725,7 @@ static void insert_zspage(struct size_cl
 {
 	struct zspage *head;
 
-	zs_stat_inc(class, fullness, 1);
+	class_stat_inc(class, fullness, 1);
 	head = list_first_entry_or_null(&class->fullness_list[fullness],
 					struct zspage, list);
 	/*
@@ -750,7 +750,7 @@ static void remove_zspage(struct size_cl
 	VM_BUG_ON(is_zspage_isolated(zspage));
 
 	list_del_init(&zspage->list);
-	zs_stat_dec(class, fullness, 1);
+	class_stat_dec(class, fullness, 1);
 }
 
 /*
@@ -964,7 +964,7 @@ static void __free_zspage(struct zs_pool
 
 	cache_free_zspage(pool, zspage);
 
-	zs_stat_dec(class, OBJ_ALLOCATED, class->objs_per_zspage);
+	class_stat_dec(class, OBJ_ALLOCATED, class->objs_per_zspage);
 	atomic_long_sub(class->pages_per_zspage,
 					&pool->pages_allocated);
 }
@@ -1394,7 +1394,7 @@ static unsigned long obj_malloc(struct s
 
 	kunmap_atomic(vaddr);
 	mod_zspage_inuse(zspage, 1);
-	zs_stat_inc(class, OBJ_USED, 1);
+	class_stat_inc(class, OBJ_USED, 1);
 
 	obj = location_to_obj(m_page, obj);
 
@@ -1458,7 +1458,7 @@ unsigned long zs_malloc(struct zs_pool *
 	record_obj(handle, obj);
 	atomic_long_add(class->pages_per_zspage,
 				&pool->pages_allocated);
-	zs_stat_inc(class, OBJ_ALLOCATED, class->objs_per_zspage);
+	class_stat_inc(class, OBJ_ALLOCATED, class->objs_per_zspage);
 
 	/* We completely set up zspage so mark them as movable */
 	SetZsPageMovable(pool, zspage);
@@ -1489,7 +1489,7 @@ static void obj_free(struct size_class *
 	kunmap_atomic(vaddr);
 	set_freeobj(zspage, f_objidx);
 	mod_zspage_inuse(zspage, -1);
-	zs_stat_dec(class, OBJ_USED, 1);
+	class_stat_dec(class, OBJ_USED, 1);
 }
 
 void zs_free(struct zs_pool *pool, unsigned long handle)
_

Patches currently in -mm which might be from minchan@kernel.org are

zsmalloc-introduce-some-helper-functions.patch
zsmalloc-rename-zs_stat_type-to-class_stat_type.patch
zsmalloc-decouple-class-actions-from-zspage-works.patch
zsmalloc-introduce-obj_allocated.patch
zsmalloc-move-huge-compressed-obj-from-page-to-zspage.patch
zsmalloc-remove-zspage-isolation-for-migration.patch
locking-rwlocks-introduce-write_lock_nested.patch
zsmalloc-replace-per-zpage-lock-with-pool-migrate_lock.patch

