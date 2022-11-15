Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 780EBC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:31:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiKOWbd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:31:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbiKOWbd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:31:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13CC4D8A
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:31:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BEE20B81B87
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 22:31:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 571A6C433D7;
        Tue, 15 Nov 2022 22:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668551489;
        bh=cSsKgIOzZf6VwFOwInMAug9N2CTq8+8gJTGWWT89q1U=;
        h=Date:To:From:Subject:From;
        b=T1g1b3ro+z2ZrCCOV9l6vDecpyjNTmZLa3dP79sY7r7kilvwLI3T7tiBMc3F57Jvj
         szNoC6KxJYHkTugV6J6nMlNE2yWT4iFmJWNgvKcYwUENY2a6Px3Z6xqyqnlYaTk4OR
         pnSUmuoWxQihsbkCgeTiL56PvzVWNleIiq8H56/g=
Date:   Tue, 15 Nov 2022 14:31:28 -0800
To:     mm-commits@vger.kernel.org, tglx@linutronix.de, longman@redhat.com,
        keescook@chromium.org, hch@lst.de, wuchi.zero@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-debugobjects-fix-stat-count-and-optimize-debug_objects_mem_init.patch removed from -mm tree
Message-Id: <20221115223129.571A6C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/debugobjects: fix stat count and optimize debug_objects_mem_init
has been removed from the -mm tree.  Its filename was
     lib-debugobjects-fix-stat-count-and-optimize-debug_objects_mem_init.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: wuchi <wuchi.zero@gmail.com>
Subject: lib/debugobjects: fix stat count and optimize debug_objects_mem_init
Date: Sat, 11 Jun 2022 21:06:34 +0800

1. Var debug_objects_allocated tracks valid kmem_cache_alloc calls, so
   track it in debug_objects_replace_static_objects.  Do similar things in
   object_cpu_offline.

2. In debug_objects_mem_init, there is no need to call function
   cpuhp_setup_state_nocalls when debug_objects_enabled = 0 (out of
   memory).

Link: https://lkml.kernel.org/r/20220611130634.99741-1-wuchi.zero@gmail.com
Fixes: 634d61f45d6f ("debugobjects: Percpu pool lookahead freeing/allocation")
Fixes: c4b73aabd098 ("debugobjects: Track number of kmem_cache_alloc/kmem_cache_free done")
Signed-off-by: wuchi <wuchi.zero@gmail.com>
Reviewed-by: Waiman Long <longman@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/debugobjects.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/lib/debugobjects.c~lib-debugobjects-fix-stat-count-and-optimize-debug_objects_mem_init
+++ a/lib/debugobjects.c
@@ -437,6 +437,7 @@ static int object_cpu_offline(unsigned i
 	struct debug_percpu_free *percpu_pool;
 	struct hlist_node *tmp;
 	struct debug_obj *obj;
+	unsigned long flags;
 
 	/* Remote access is safe as the CPU is dead already */
 	percpu_pool = per_cpu_ptr(&percpu_obj_pool, cpu);
@@ -444,6 +445,12 @@ static int object_cpu_offline(unsigned i
 		hlist_del(&obj->node);
 		kmem_cache_free(obj_cache, obj);
 	}
+
+	raw_spin_lock_irqsave(&pool_lock, flags);
+	obj_pool_used -= percpu_pool->obj_free;
+	debug_objects_freed += percpu_pool->obj_free;
+	raw_spin_unlock_irqrestore(&pool_lock, flags);
+
 	percpu_pool->obj_free = 0;
 
 	return 0;
@@ -1318,6 +1325,8 @@ static int __init debug_objects_replace_
 		hlist_add_head(&obj->node, &objects);
 	}
 
+	debug_objects_allocated += i;
+
 	/*
 	 * debug_objects_mem_init() is now called early that only one CPU is up
 	 * and interrupts have been disabled, so it is safe to replace the
@@ -1386,6 +1395,7 @@ void __init debug_objects_mem_init(void)
 		debug_objects_enabled = 0;
 		kmem_cache_destroy(obj_cache);
 		pr_warn("out of memory.\n");
+		return;
 	} else
 		debug_objects_selftest();
 
_

Patches currently in -mm which might be from wuchi.zero@gmail.com are


