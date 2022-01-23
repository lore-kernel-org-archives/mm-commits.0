Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3EE0C433F5
	for <mm-commits@archiver.kernel.org>; Sun, 23 Jan 2022 23:57:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235153AbiAWX5x (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 23 Jan 2022 18:57:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234999AbiAWX5x (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 23 Jan 2022 18:57:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9EF3C06173B
        for <mm-commits@vger.kernel.org>; Sun, 23 Jan 2022 15:57:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 798E8611E0
        for <mm-commits@vger.kernel.org>; Sun, 23 Jan 2022 23:57:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB882C340E3;
        Sun, 23 Jan 2022 23:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642982271;
        bh=AiFLzd0duer5A5IMr1uDQVidpOH0BFIRYPgENRIZ/T8=;
        h=Date:From:To:Subject:From;
        b=Tvs+GE6nVT4SgFO99CG7DgPlS0YPFHBWKWKR4mWmyNgrv7e9Uigq31Vt8bQ+uxVyZ
         dDHFizeQxu/Jyb0kYWZyBtaTRHCqNZ9tRl+o7qOKvQTRe5HbFOhsIHvhpYj//Yvtqo
         op6hMTTnQFUaENemWuMEoV3LZBEwZkS54aldD7yU=
Date:   Sun, 23 Jan 2022 15:57:51 -0800
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, minchan@kernel.org,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        senozhatsky@chromium.org, tglx@linutronix.de,
        umgwanakikbuti@gmail.com
Subject:  [merged]
 zsmalloc-decouple-class-actions-from-zspage-works.patch removed from -mm
 tree
Message-ID: <20220123235751.xH0lEUPVT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: decouple class actions from zspage works
has been removed from the -mm tree.  Its filename was
     zsmalloc-decouple-class-actions-from-zspage-works.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zsmalloc: decouple class actions from zspage works

This patch moves class stat update out of obj_malloc since it's not
related to zspage operation.  This is a preparation to introduce new lock
scheme in next patch.

Link: https://lkml.kernel.org/r/20211115185909.3949505-4-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Tested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-decouple-class-actions-from-zspage-works
+++ a/mm/zsmalloc.c
@@ -1360,17 +1360,19 @@ size_t zs_huge_class_size(struct zs_pool
 }
 EXPORT_SYMBOL_GPL(zs_huge_class_size);
 
-static unsigned long obj_malloc(struct size_class *class,
+static unsigned long obj_malloc(struct zs_pool *pool,
 				struct zspage *zspage, unsigned long handle)
 {
 	int i, nr_page, offset;
 	unsigned long obj;
 	struct link_free *link;
+	struct size_class *class;
 
 	struct page *m_page;
 	unsigned long m_offset;
 	void *vaddr;
 
+	class = pool->size_class[zspage->class];
 	handle |= OBJ_ALLOCATED_TAG;
 	obj = get_freeobj(zspage);
 
@@ -1394,7 +1396,6 @@ static unsigned long obj_malloc(struct s
 
 	kunmap_atomic(vaddr);
 	mod_zspage_inuse(zspage, 1);
-	class_stat_inc(class, OBJ_USED, 1);
 
 	obj = location_to_obj(m_page, obj);
 
@@ -1433,10 +1434,11 @@ unsigned long zs_malloc(struct zs_pool *
 	spin_lock(&class->lock);
 	zspage = find_get_zspage(class);
 	if (likely(zspage)) {
-		obj = obj_malloc(class, zspage, handle);
+		obj = obj_malloc(pool, zspage, handle);
 		/* Now move the zspage to another fullness group, if required */
 		fix_fullness_group(class, zspage);
 		record_obj(handle, obj);
+		class_stat_inc(class, OBJ_USED, 1);
 		spin_unlock(&class->lock);
 
 		return handle;
@@ -1451,7 +1453,7 @@ unsigned long zs_malloc(struct zs_pool *
 	}
 
 	spin_lock(&class->lock);
-	obj = obj_malloc(class, zspage, handle);
+	obj = obj_malloc(pool, zspage, handle);
 	newfg = get_fullness_group(class, zspage);
 	insert_zspage(class, zspage, newfg);
 	set_zspage_mapping(zspage, class->index, newfg);
@@ -1459,6 +1461,7 @@ unsigned long zs_malloc(struct zs_pool *
 	atomic_long_add(class->pages_per_zspage,
 				&pool->pages_allocated);
 	class_stat_inc(class, OBJ_ALLOCATED, class->objs_per_zspage);
+	class_stat_inc(class, OBJ_USED, 1);
 
 	/* We completely set up zspage so mark them as movable */
 	SetZsPageMovable(pool, zspage);
@@ -1468,7 +1471,7 @@ unsigned long zs_malloc(struct zs_pool *
 }
 EXPORT_SYMBOL_GPL(zs_malloc);
 
-static void obj_free(struct size_class *class, unsigned long obj)
+static void obj_free(int class_size, unsigned long obj)
 {
 	struct link_free *link;
 	struct zspage *zspage;
@@ -1478,7 +1481,7 @@ static void obj_free(struct size_class *
 	void *vaddr;
 
 	obj_to_location(obj, &f_page, &f_objidx);
-	f_offset = (class->size * f_objidx) & ~PAGE_MASK;
+	f_offset = (class_size * f_objidx) & ~PAGE_MASK;
 	zspage = get_zspage(f_page);
 
 	vaddr = kmap_atomic(f_page);
@@ -1489,7 +1492,6 @@ static void obj_free(struct size_class *
 	kunmap_atomic(vaddr);
 	set_freeobj(zspage, f_objidx);
 	mod_zspage_inuse(zspage, -1);
-	class_stat_dec(class, OBJ_USED, 1);
 }
 
 void zs_free(struct zs_pool *pool, unsigned long handle)
@@ -1513,7 +1515,8 @@ void zs_free(struct zs_pool *pool, unsig
 	class = zspage_class(pool, zspage);
 
 	spin_lock(&class->lock);
-	obj_free(class, obj);
+	obj_free(class->size, obj);
+	class_stat_dec(class, OBJ_USED, 1);
 	fullness = fix_fullness_group(class, zspage);
 	if (fullness != ZS_EMPTY) {
 		migrate_read_unlock(zspage);
@@ -1671,7 +1674,7 @@ static int migrate_zspage(struct zs_pool
 		}
 
 		used_obj = handle_to_obj(handle);
-		free_obj = obj_malloc(class, get_zspage(d_page), handle);
+		free_obj = obj_malloc(pool, get_zspage(d_page), handle);
 		zs_object_copy(class, free_obj, used_obj);
 		obj_idx++;
 		/*
@@ -1683,7 +1686,7 @@ static int migrate_zspage(struct zs_pool
 		free_obj |= BIT(HANDLE_PIN_BIT);
 		record_obj(handle, free_obj);
 		unpin_tag(handle);
-		obj_free(class, used_obj);
+		obj_free(class->size, used_obj);
 	}
 
 	/* Remember last position in this iteration */
_

Patches currently in -mm which might be from minchan@kernel.org are


