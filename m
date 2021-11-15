Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03D0AC43217
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 21:33:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBE5363251
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 21:33:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347244AbhKOVgM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Nov 2021 16:36:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:55894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349381AbhKOVJl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Nov 2021 16:09:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E375C61B3B;
        Mon, 15 Nov 2021 21:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637010404;
        bh=XVRhw5bIHlfsnhq/TH0g95emDoctmbq+DLz4r0b1lp8=;
        h=Date:From:To:Subject:From;
        b=KQ17TTOkI+CQJZ5Jf8eDz8C1GmcpLWkymBWe8OUAjdRuKG+mLnuCNYJ1bqamm4ciX
         hYv3E92IdEjoQj9MuN5miFuYWleyzpqMnC0q0cuRIw0XPKxLG/K8+ahERMK8DHb9HT
         HY96zelXxYDH12JVFBuou3ZdVIEW9SDXz9/JZU68=
Date:   Mon, 15 Nov 2021 13:06:43 -0800
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, minchan@kernel.org,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        senozhatsky@chromium.org, tglx@linutronix.de,
        umgwanakikbuti@gmail.com
Subject:  + zsmalloc-decouple-class-actions-from-zspage-works.patch
 added to -mm tree
Message-ID: <20211115210643.Owoez-pzr%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: decouple class actions from zspage works
has been added to the -mm tree.  Its filename is
     zsmalloc-decouple-class-actions-from-zspage-works.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-decouple-class-actions-from-zspage-works.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-decouple-class-actions-from-zspage-works.patch

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
Subject: zsmalloc: decouple class actions from zspage works

This patch moves class stat update out of obj_malloc since it's not
related to zspage operation.  This is a preparation to introduce new lock
scheme in next patch.

Link: https://lkml.kernel.org/r/20211115185909.3949505-4-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
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

zsmalloc-introduce-some-helper-functions.patch
zsmalloc-rename-zs_stat_type-to-class_stat_type.patch
zsmalloc-decouple-class-actions-from-zspage-works.patch
zsmalloc-introduce-obj_allocated.patch
zsmalloc-move-huge-compressed-obj-from-page-to-zspage.patch
zsmalloc-remove-zspage-isolation-for-migration.patch
locking-rwlocks-introduce-write_lock_nested.patch
zsmalloc-replace-per-zpage-lock-with-pool-migrate_lock.patch

