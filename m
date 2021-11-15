Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DCAAC433FE
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 21:33:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0742663220
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 21:33:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350751AbhKOVgd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Nov 2021 16:36:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:56212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352993AbhKOVKn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Nov 2021 16:10:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E15006321B;
        Mon, 15 Nov 2021 21:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637010418;
        bh=7WNFkdnUCCNj+TsIINzouF4q9jXC05QY+3Y7K3/swgM=;
        h=Date:From:To:Subject:From;
        b=h1QrdQUx+z94B588TuictlWj9vYRAW0M6hQrpWhXCF8qRK8Ggqueq6WPFiFF7PEN2
         E8cQXx5qVhYnwK1q1D1TyJFQI1N9gtYQh1Hp3JRvbz0nf41naZkZsd0Lw1TAf5aIze
         vH50aJybRng/cMrQg2NS6RL3tnr2kLeiELKYW3P4=
Date:   Mon, 15 Nov 2021 13:06:57 -0800
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, minchan@kernel.org,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        senozhatsky@chromium.org, tglx@linutronix.de,
        umgwanakikbuti@gmail.com
Subject:  + zsmalloc-replace-get_cpu_var-with-local_lock.patch
 added to -mm tree
Message-ID: <20211115210657.I6OunrGVa%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: replace get_cpu_var with local_lock
has been added to the -mm tree.  Its filename is
     zsmalloc-replace-get_cpu_var-with-local_lock.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-replace-get_cpu_var-with-local_lock.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-replace-get_cpu_var-with-local_lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

zsmalloc-replace-get_cpu_var-with-local_lock.patch

