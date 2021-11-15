Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E3D0C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 21:33:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DF2961BF8
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 21:33:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbhKOVgE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Nov 2021 16:36:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:55832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348991AbhKOVJf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Nov 2021 16:09:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 186AF61B3A;
        Mon, 15 Nov 2021 21:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637010399;
        bh=wjnxAjF6uN3ufJEYnwrsKW7KgOR+DOlmrQlB63RAkTw=;
        h=Date:From:To:Subject:From;
        b=G87aFjBzxRK4KzqNGZOJHEHs+sumLCyK4dS79HmXE85q9DBzOSrxn59fcFZgHQ6tN
         Bu3X7N/imrwxz2YRXgKG4tOsxHwg8amB6BVNB9qiwJsgg80ohqQZDhPkLW/7he6fsU
         McFGSX4ZiaFFHiyCVOP3TyF7fQ20FNsa2T2kvAaM=
Date:   Mon, 15 Nov 2021 13:06:38 -0800
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, minchan@kernel.org,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        senozhatsky@chromium.org, tglx@linutronix.de,
        umgwanakikbuti@gmail.com
Subject:  + zsmalloc-introduce-some-helper-functions.patch added to
 -mm tree
Message-ID: <20211115210638.wJN0ep782%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: introduce some helper functions
has been added to the -mm tree.  Its filename is
     zsmalloc-introduce-some-helper-functions.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-introduce-some-helper-functions.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-introduce-some-helper-functions.patch

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
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
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

zsmalloc-introduce-some-helper-functions.patch
zsmalloc-rename-zs_stat_type-to-class_stat_type.patch
zsmalloc-decouple-class-actions-from-zspage-works.patch
zsmalloc-introduce-obj_allocated.patch
zsmalloc-move-huge-compressed-obj-from-page-to-zspage.patch
zsmalloc-remove-zspage-isolation-for-migration.patch
locking-rwlocks-introduce-write_lock_nested.patch
zsmalloc-replace-per-zpage-lock-with-pool-migrate_lock.patch

