Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50D3CC433F5
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 06:14:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233453AbiAVGOU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 Jan 2022 01:14:20 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44452 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233005AbiAVGOT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 22 Jan 2022 01:14:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72AAB60FB0
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 06:14:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87EDCC004E1;
        Sat, 22 Jan 2022 06:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642832057;
        bh=b7lciljBSjqplQsBCzbB8pun/hrpJaHvaroEUoPRPSE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=RYC+gVCgC88z2ql3VkYVEMCZ4s+ZotSPJaUhVFqnWzKa9o/HNUNpD5PERnGMfjlIo
         Mwbm6yr4aJW7R3sQ3oIA6KAySNYq0jYoAviHdZsxvAe4dlESCLFXdy0ZZX8Uh1SmDy
         xi127Yhiw6KBfBi+n3EMPlXmAJwko3lRB2XudYdY=
Date:   Fri, 21 Jan 2022 22:14:17 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        linux-mm@kvack.org, minchan@kernel.org, mm-commits@vger.kernel.org,
        peterz@infradead.org, senozhatsky@chromium.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, umgwanakikbuti@gmail.com
Subject:  [patch 52/69] zsmalloc: replace get_cpu_var with
 local_lock
Message-ID: <20220122061417.ETzeDBxMT%akpm@linux-foundation.org>
In-Reply-To: <20220121221021.60533b009c357d660791476e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
