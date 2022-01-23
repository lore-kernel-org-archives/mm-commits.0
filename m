Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 281FDC433EF
	for <mm-commits@archiver.kernel.org>; Sun, 23 Jan 2022 23:58:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbiAWX6M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 23 Jan 2022 18:58:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46578 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240514AbiAWX6M (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 23 Jan 2022 18:58:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2EAE3B80E46
        for <mm-commits@vger.kernel.org>; Sun, 23 Jan 2022 23:58:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A93ADC340E3;
        Sun, 23 Jan 2022 23:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642982289;
        bh=XnKIy18XfK8LEmOUDOHOwdyd6MxPV91ekq/ammilyx4=;
        h=Date:From:To:Subject:From;
        b=xkOeI8VfOe9yQzoHp4z/FudtYegmAmvqM3qzpTSWuqqjGuSedUPEWxvHFSnPl0j11
         3He1nZqzYrTQeH7jOwA+TE2qPCHIImewBiu0oTDn7CODdO7782aFOCWnvnA1hQqVTW
         S/GPua2TaOT/3AUi0+cTdWKJbGGNi1KVlGiYTSR8=
Date:   Sun, 23 Jan 2022 15:58:09 -0800
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, minchan@kernel.org,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        senozhatsky@chromium.org, tglx@linutronix.de,
        umgwanakikbuti@gmail.com
Subject:  [merged]
 zsmalloc-replace-get_cpu_var-with-local_lock.patch removed from -mm tree
Message-ID: <20220123235809.jWJOiVim8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: replace get_cpu_var with local_lock
has been removed from the -mm tree.  Its filename was
     zsmalloc-replace-get_cpu_var-with-local_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Galbraith <umgwanakikbuti@gmail.com>
Subject: zsmalloc: replace get_cpu_var with local_lock

The usage of get_cpu_var() in zs_map_object() is problematic because it
disables preemption and makes it impossible to acquire any sleeping lock
on PREEMPT_RT such as a spinlock_t.

Replace the get_cpu_var() usage with a local_lock_t which is embedded
struct mapping_area.  It ensures that the access the struct is
synchronized against all users on the same CPU.

[minchan: remove the bit_spin_lock part and change the title]
Link: https://lkml.kernel.org/r/20211115185909.3949505-10-minchan@kernel.org
Signed-off-by: Mike Galbraith <umgwanakikbuti@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Tested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-replace-get_cpu_var-with-local_lock
+++ a/mm/zsmalloc.c
@@ -65,6 +65,7 @@
 #include <linux/wait.h>
 #include <linux/pagemap.h>
 #include <linux/fs.h>
+#include <linux/local_lock.h>
 
 #define ZSPAGE_MAGIC	0x58
 
@@ -276,6 +277,7 @@ struct zspage {
 };
 
 struct mapping_area {
+	local_lock_t lock;
 	char *vm_buf; /* copy buffer for objects that span pages */
 	char *vm_addr; /* address of kmap_atomic()'ed pages */
 	enum zs_mapmode vm_mm; /* mapping mode */
@@ -451,7 +453,9 @@ MODULE_ALIAS("zpool-zsmalloc");
 #endif /* CONFIG_ZPOOL */
 
 /* per-cpu VM mapping areas for zspage accesses that cross page boundaries */
-static DEFINE_PER_CPU(struct mapping_area, zs_map_area);
+static DEFINE_PER_CPU(struct mapping_area, zs_map_area) = {
+	.lock	= INIT_LOCAL_LOCK(lock),
+};
 
 static __maybe_unused int is_first_page(struct page *page)
 {
@@ -1269,7 +1273,8 @@ void *zs_map_object(struct zs_pool *pool
 	class = zspage_class(pool, zspage);
 	off = (class->size * obj_idx) & ~PAGE_MASK;
 
-	area = &get_cpu_var(zs_map_area);
+	local_lock(&zs_map_area.lock);
+	area = this_cpu_ptr(&zs_map_area);
 	area->vm_mm = mm;
 	if (off + class->size <= PAGE_SIZE) {
 		/* this object is contained entirely within a page */
@@ -1320,7 +1325,7 @@ void zs_unmap_object(struct zs_pool *poo
 
 		__zs_unmap_object(area, pages, off, class->size);
 	}
-	put_cpu_var(zs_map_area);
+	local_unlock(&zs_map_area.lock);
 
 	migrate_read_unlock(zspage);
 }
_

Patches currently in -mm which might be from umgwanakikbuti@gmail.com are


