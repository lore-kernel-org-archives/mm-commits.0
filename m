Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3CE2C433F5
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 06:14:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233443AbiAVGOB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 Jan 2022 01:14:01 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54954 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbiAVGOA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 22 Jan 2022 01:14:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4E4EB820FD
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 06:13:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA3AC004E1;
        Sat, 22 Jan 2022 06:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642832038;
        bh=uG8ua7iHJ7HyS+E5tMzKOZ70L2JAHlMXISpG6BD+lZo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=RjE9hM8Pu9hDF++suON2qhrddctTaUzzrUYjyI0ttLjW7+tZ/5pAYZhjqFWIi/Uy1
         8wKaIKgE7j/TQrGjYsXuCKpCjDg8zG/2F/zHCR0yKEFobnyn/OER5VniqHjooEUEXC
         onuj+SyEG5B0+8CKh4aqA5d2wrX/IP8RGMqSR3oA=
Date:   Fri, 21 Jan 2022 22:13:57 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        linux-mm@kvack.org, minchan@kernel.org, mm-commits@vger.kernel.org,
        peterz@infradead.org, senozhatsky@chromium.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, umgwanakikbuti@gmail.com
Subject:  [patch 46/69] zsmalloc: decouple class actions from
 zspage works
Message-ID: <20220122061357.f21E1CTQU%akpm@linux-foundation.org>
In-Reply-To: <20220121221021.60533b009c357d660791476e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
