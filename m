Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B69FC433F5
	for <mm-commits@archiver.kernel.org>; Sun, 23 Jan 2022 23:57:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235068AbiAWX5r (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 23 Jan 2022 18:57:47 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52666 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234999AbiAWX5q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 23 Jan 2022 18:57:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80A4360C34
        for <mm-commits@vger.kernel.org>; Sun, 23 Jan 2022 23:57:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFECBC340E3;
        Sun, 23 Jan 2022 23:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642982265;
        bh=Aa9ZTyciTXjLhSPBaoW2e0f3F0QuIfj0xNRGAic65N8=;
        h=Date:From:To:Subject:From;
        b=TI+LkLn3Z0OTT0HX6pyJlyDXA7aqAC/3RezFiEGP6h5oP0FtCTDjhA8TXArOeiLzu
         gOeXE8erxUsHyGb0f/ziyxZuvU0gQlMOAWwiw9ZYT9xlOmqK3mYMpYmE0sjQwDwfk7
         dzzVUf+NQYU+mkMtHcPoniTUiRTF1oSoBulPPuEk=
Date:   Sun, 23 Jan 2022 15:57:45 -0800
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, minchan@kernel.org,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        tglx@linutronix.de, umgwanakikbuti@gmail.com
Subject:  [merged] zsmalloc-introduce-some-helper-functions.patch
 removed from -mm tree
Message-ID: <20220123235745.fw5BY73mh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: introduce some helper functions
has been removed from the -mm tree.  Its filename was
     zsmalloc-introduce-some-helper-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zsmalloc: introduce some helper functions

Patch series "zsmalloc: remove bit_spin_lock", v2.

zsmalloc uses bit_spin_lock to minimize space overhead since it's zpage
granularity lock.  However, it causes zsmalloc non-working under
PREEMPT_RT as well as adding too much complication.

This patchset tries to replace the bit_spin_lock with per-pool rwlock.  It
also removes unnecessary zspage isolation logic from class, which was the
other part too much complication added into zsmalloc.

Last patch changes the get_cpu_var to local_lock to make it work in
PREEMPT_RT.


This patch (of 9):

get_zspage_mapping returns fullness as well as class_idx.  However, the
fullness is usually not used since it could be stale in some contexts.  It
causes misleading as well as unnecessary instructions so this patch
introduces zspage_class.

obj_to_location also produces page and index but we don't need always the
index, either so this patch introduces obj_to_page.

Link: https://lkml.kernel.org/r/20211115185909.3949505-1-minchan@kernel.org
Link: https://lkml.kernel.org/r/20211115185909.3949505-2-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Tested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   54 ++++++++++++++++++++----------------------------
 1 file changed, 23 insertions(+), 31 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-introduce-some-helper-functions
+++ a/mm/zsmalloc.c
@@ -517,6 +517,12 @@ static void get_zspage_mapping(struct zs
 	*class_idx = zspage->class;
 }
 
+static struct size_class *zspage_class(struct zs_pool *pool,
+					     struct zspage *zspage)
+{
+	return pool->size_class[zspage->class];
+}
+
 static void set_zspage_mapping(struct zspage *zspage,
 				unsigned int class_idx,
 				enum fullness_group fullness)
@@ -844,6 +850,12 @@ static void obj_to_location(unsigned lon
 	*obj_idx = (obj & OBJ_INDEX_MASK);
 }
 
+static void obj_to_page(unsigned long obj, struct page **page)
+{
+	obj >>= OBJ_TAG_BITS;
+	*page = pfn_to_page(obj >> OBJ_INDEX_BITS);
+}
+
 /**
  * location_to_obj - get obj value encoded from (<page>, <obj_idx>)
  * @page: page object resides in zspage
@@ -1246,8 +1258,6 @@ void *zs_map_object(struct zs_pool *pool
 	unsigned long obj, off;
 	unsigned int obj_idx;
 
-	unsigned int class_idx;
-	enum fullness_group fg;
 	struct size_class *class;
 	struct mapping_area *area;
 	struct page *pages[2];
@@ -1270,8 +1280,7 @@ void *zs_map_object(struct zs_pool *pool
 	/* migration cannot move any subpage in this zspage */
 	migrate_read_lock(zspage);
 
-	get_zspage_mapping(zspage, &class_idx, &fg);
-	class = pool->size_class[class_idx];
+	class = zspage_class(pool, zspage);
 	off = (class->size * obj_idx) & ~PAGE_MASK;
 
 	area = &get_cpu_var(zs_map_area);
@@ -1304,16 +1313,13 @@ void zs_unmap_object(struct zs_pool *poo
 	unsigned long obj, off;
 	unsigned int obj_idx;
 
-	unsigned int class_idx;
-	enum fullness_group fg;
 	struct size_class *class;
 	struct mapping_area *area;
 
 	obj = handle_to_obj(handle);
 	obj_to_location(obj, &page, &obj_idx);
 	zspage = get_zspage(page);
-	get_zspage_mapping(zspage, &class_idx, &fg);
-	class = pool->size_class[class_idx];
+	class = zspage_class(pool, zspage);
 	off = (class->size * obj_idx) & ~PAGE_MASK;
 
 	area = this_cpu_ptr(&zs_map_area);
@@ -1491,8 +1497,6 @@ void zs_free(struct zs_pool *pool, unsig
 	struct zspage *zspage;
 	struct page *f_page;
 	unsigned long obj;
-	unsigned int f_objidx;
-	int class_idx;
 	struct size_class *class;
 	enum fullness_group fullness;
 	bool isolated;
@@ -1502,13 +1506,11 @@ void zs_free(struct zs_pool *pool, unsig
 
 	pin_tag(handle);
 	obj = handle_to_obj(handle);
-	obj_to_location(obj, &f_page, &f_objidx);
+	obj_to_page(obj, &f_page);
 	zspage = get_zspage(f_page);
 
 	migrate_read_lock(zspage);
-
-	get_zspage_mapping(zspage, &class_idx, &fullness);
-	class = pool->size_class[class_idx];
+	class = zspage_class(pool, zspage);
 
 	spin_lock(&class->lock);
 	obj_free(class, obj);
@@ -1866,8 +1868,6 @@ static bool zs_page_isolate(struct page
 {
 	struct zs_pool *pool;
 	struct size_class *class;
-	int class_idx;
-	enum fullness_group fullness;
 	struct zspage *zspage;
 	struct address_space *mapping;
 
@@ -1880,15 +1880,10 @@ static bool zs_page_isolate(struct page
 
 	zspage = get_zspage(page);
 
-	/*
-	 * Without class lock, fullness could be stale while class_idx is okay
-	 * because class_idx is constant unless page is freed so we should get
-	 * fullness again under class lock.
-	 */
-	get_zspage_mapping(zspage, &class_idx, &fullness);
 	mapping = page_mapping(page);
 	pool = mapping->private_data;
-	class = pool->size_class[class_idx];
+
+	class = zspage_class(pool, zspage);
 
 	spin_lock(&class->lock);
 	if (get_zspage_inuse(zspage) == 0) {
@@ -1907,6 +1902,9 @@ static bool zs_page_isolate(struct page
 	 * size_class to prevent further object allocation from the zspage.
 	 */
 	if (!list_empty(&zspage->list) && !is_zspage_isolated(zspage)) {
+		enum fullness_group fullness;
+		unsigned int class_idx;
+
 		get_zspage_mapping(zspage, &class_idx, &fullness);
 		atomic_long_inc(&pool->isolated_pages);
 		remove_zspage(class, zspage, fullness);
@@ -1923,8 +1921,6 @@ static int zs_page_migrate(struct addres
 {
 	struct zs_pool *pool;
 	struct size_class *class;
-	int class_idx;
-	enum fullness_group fullness;
 	struct zspage *zspage;
 	struct page *dummy;
 	void *s_addr, *d_addr, *addr;
@@ -1949,9 +1945,8 @@ static int zs_page_migrate(struct addres
 
 	/* Concurrent compactor cannot migrate any subpage in zspage */
 	migrate_write_lock(zspage);
-	get_zspage_mapping(zspage, &class_idx, &fullness);
 	pool = mapping->private_data;
-	class = pool->size_class[class_idx];
+	class = zspage_class(pool, zspage);
 	offset = get_first_obj_offset(page);
 
 	spin_lock(&class->lock);
@@ -2049,8 +2044,6 @@ static void zs_page_putback(struct page
 {
 	struct zs_pool *pool;
 	struct size_class *class;
-	int class_idx;
-	enum fullness_group fg;
 	struct address_space *mapping;
 	struct zspage *zspage;
 
@@ -2058,10 +2051,9 @@ static void zs_page_putback(struct page
 	VM_BUG_ON_PAGE(!PageIsolated(page), page);
 
 	zspage = get_zspage(page);
-	get_zspage_mapping(zspage, &class_idx, &fg);
 	mapping = page_mapping(page);
 	pool = mapping->private_data;
-	class = pool->size_class[class_idx];
+	class = zspage_class(pool, zspage);
 
 	spin_lock(&class->lock);
 	dec_zspage_isolation(zspage);
_

Patches currently in -mm which might be from minchan@kernel.org are


