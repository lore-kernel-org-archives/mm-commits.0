Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CBBCC433EF
	for <mm-commits@archiver.kernel.org>; Sat, 11 Jun 2022 20:04:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbiFKUEf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 11 Jun 2022 16:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbiFKUEe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 11 Jun 2022 16:04:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC2056433
        for <mm-commits@vger.kernel.org>; Sat, 11 Jun 2022 13:04:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DC5D61278
        for <mm-commits@vger.kernel.org>; Sat, 11 Jun 2022 20:04:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F23C34116;
        Sat, 11 Jun 2022 20:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654977872;
        bh=Qvs0kZcDGkXvZKsXO+qLeM92FkcNIOQoZ6ntVGuqMRg=;
        h=Date:To:From:Subject:From;
        b=qqVLtnc6wnGEpxnqPoXcgHFdZLZ/pBzX9IyBVAkad/IsMTW3HTwv169iVYvluvERJ
         DZEx9jLp/BZAhyaXxJABDt4tMVM9sE8m8+5qLQAajKufLJo8ZsPN8H6v8oQ5s6fUjF
         QBjBUlcNuhhsPf0V3LvQ/rPRqry9ixrXVUCTndEY=
Date:   Sat, 11 Jun 2022 13:04:31 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de, longman@redhat.com,
        keescook@chromium.org, hch@lst.de, wuchi.zero@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-debugobjects-fix-stat-count-and-optimize-debug_objects_mem_init.patch added to mm-nonmm-unstable branch
Message-Id: <20220611200432.A1F23C34116@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/debugobjects: fix stat count and optimize debug_objects_mem_init.
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-debugobjects-fix-stat-count-and-optimize-debug_objects_mem_init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-debugobjects-fix-stat-count-and-optimize-debug_objects_mem_init.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: wuchi <wuchi.zero@gmail.com>
Subject: lib/debugobjects: fix stat count and optimize debug_objects_mem_init.
Date: Sat, 11 Jun 2022 21:06:34 +0800

1.  Var debug_objects_allocated tracks valid kmem_cache_alloc calls, so
   track it in debug_objects_replace_static_objects.  Do similar things in
   object_cpu_offline.

2.  In debug_objects_mem_init, there is no need to call function
   cpuhp_setup_state_nocalls when debug_objects_enabled = 0 (out of
   memory).

Link: https://lkml.kernel.org/r/20220611130634.99741-1-wuchi.zero@gmail.com
Signed-off-by: wuchi <wuchi.zero@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Kees Cook <keescook@chromium.org>
Cc: Waiman Long <longman@redhat.com>
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

lib-flex_proportionsc-remove-local_irq_ops-in-fprop_new_period.patch
lib-btree-simplify-btree_lookupupdate.patch
lib-debugobjects-fix-stat-count-and-optimize-debug_objects_mem_init.patch

