Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2680C433F5
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 06:13:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233442AbiAVGN5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 Jan 2022 01:13:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbiAVGN4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 22 Jan 2022 01:13:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C23C06173B
        for <mm-commits@vger.kernel.org>; Fri, 21 Jan 2022 22:13:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12E0B60ED1
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 06:13:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26B04C004E1;
        Sat, 22 Jan 2022 06:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642832035;
        bh=Vcnyy0Agd7ncTnizZLM3m621nLb+BOkBNapnBOL0Erk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=AoxqZl0iXERO3g8H7Oi5LURc+cw/xYGBwQKPOy3jeOUtd21sq6K0M+iHOvobK13Jr
         9RfOAyIx/BuAk7KJ/t4WBdtL0Ri29wqoh6haaJqPMYNR2YIygxObfEVORhoRzFdrX6
         4EbtXNjmCsmp+NrGukMdSmk8th1fYvqy7Bf5hQs8=
Date:   Fri, 21 Jan 2022 22:13:54 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        linux-mm@kvack.org, minchan@kernel.org, mm-commits@vger.kernel.org,
        peterz@infradead.org, senozhatsky@chromium.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, umgwanakikbuti@gmail.com
Subject:  [patch 45/69] zsmalloc: rename zs_stat_type to
 class_stat_type
Message-ID: <20220122061354.xQ5VyvMGb%akpm@linux-foundation.org>
In-Reply-To: <20220121221021.60533b009c357d660791476e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Minchan Kim <minchan@kernel.org>
Subject: zsmalloc: rename zs_stat_type to class_stat_type

The stat aims for class stat, not zspage so rename it.

Link: https://lkml.kernel.org/r/20211115185909.3949505-3-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Tested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
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
