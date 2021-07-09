Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF20FC07E99
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:32:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9780F613C9
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:32:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbhGIVfK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 17:35:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:45670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229506AbhGIVfJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 17:35:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0A85613C3;
        Fri,  9 Jul 2021 21:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625866345;
        bh=x8j0Vdg1HZ7px2H4Us59O/SST1dCm+lhVKJVHDCcqPY=;
        h=Date:From:To:Subject:From;
        b=G/L1KOvYr8Ti0RB9xHzz7+GYeImNnxWaVlPrWzAjX9fN6WXcUu8JIVvS/qxePt8tr
         SkcwJu7OTBDEtunRJxORT7u9kFaT3ivJYFb4eP36QQMT95SouJvTMK9j/EC5RcAxN5
         3PuA7D9dpaKMvTQLZHxPfixtGvPeMIV+nx0E4fKg=
Date:   Fri, 09 Jul 2021 14:32:25 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, glittao@gmail.com, iamjoonsoo.kim@lge.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rdunlap@infradead.org, rientjes@google.com, vbabka@suse.cz
Subject:  [merged]
 mm-slub-use-stackdepot-to-save-stack-trace-in-objects.patch removed from
 -mm tree
Message-ID: <20210709213225.SVmgVELwC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub: use stackdepot to save stack trace in objects
has been removed from the -mm tree.  Its filename was
     mm-slub-use-stackdepot-to-save-stack-trace-in-objects.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oliver Glitta <glittao@gmail.com>
Subject: mm/slub: use stackdepot to save stack trace in objects

Many stack traces are similar so there are many similar arrays. 
Stackdepot saves each unique stack only once.

Replace field addrs in struct track with depot_stack_handle_t handle.  Use
stackdepot to save stack trace.

The benefits are smaller memory overhead and possibility to aggregate
per-cache statistics in the future using the stackdepot handle instead of
matching stacks manually.

[rdunlap@infradead.org: rename save_stack_trace()]
  Link: https://lkml.kernel.org/r/20210513051920.29320-1-rdunlap@infradead.org
[vbabka@suse.cz: fix lockdep splat]
  Link: https://lkml.kernel.org/r/20210516195150.26740-1-vbabka@suse.czLink: https://lkml.kernel.org/r/20210414163434.4376-1-glittao@gmail.com
Signed-off-by: Oliver Glitta <glittao@gmail.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    1 
 mm/slub.c    |   79 ++++++++++++++++++++++++++++++-------------------
 2 files changed, 50 insertions(+), 30 deletions(-)

--- a/init/Kconfig~mm-slub-use-stackdepot-to-save-stack-trace-in-objects
+++ a/init/Kconfig
@@ -1847,6 +1847,7 @@ config SLUB_DEBUG
 	default y
 	bool "Enable SLUB debugging support" if EXPERT
 	depends on SLUB && SYSFS
+	select STACKDEPOT if STACKTRACE_SUPPORT
 	help
 	  SLUB has extensive debug support features. Disabling these can
 	  result in significant savings in code size. This also disables
--- a/mm/slub.c~mm-slub-use-stackdepot-to-save-stack-trace-in-objects
+++ a/mm/slub.c
@@ -26,6 +26,7 @@
 #include <linux/cpuset.h>
 #include <linux/mempolicy.h>
 #include <linux/ctype.h>
+#include <linux/stackdepot.h>
 #include <linux/debugobjects.h>
 #include <linux/kallsyms.h>
 #include <linux/kfence.h>
@@ -220,8 +221,8 @@ static inline bool kmem_cache_has_cpu_pa
 #define TRACK_ADDRS_COUNT 16
 struct track {
 	unsigned long addr;	/* Called from address */
-#ifdef CONFIG_STACKTRACE
-	unsigned long addrs[TRACK_ADDRS_COUNT];	/* Called from address */
+#ifdef CONFIG_STACKDEPOT
+	depot_stack_handle_t handle;
 #endif
 	int cpu;		/* Was running on cpu */
 	int pid;		/* Pid context */
@@ -625,22 +626,27 @@ static struct track *get_track(struct km
 	return kasan_reset_tag(p + alloc);
 }
 
+#ifdef CONFIG_STACKDEPOT
+static depot_stack_handle_t save_stack_depot_trace(gfp_t flags)
+{
+	unsigned long entries[TRACK_ADDRS_COUNT];
+	depot_stack_handle_t handle;
+	unsigned int nr_entries;
+
+	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 4);
+	handle = stack_depot_save(entries, nr_entries, flags);
+	return handle;
+}
+#endif
+
 static void set_track(struct kmem_cache *s, void *object,
 			enum track_item alloc, unsigned long addr)
 {
 	struct track *p = get_track(s, object, alloc);
 
 	if (addr) {
-#ifdef CONFIG_STACKTRACE
-		unsigned int nr_entries;
-
-		metadata_access_enable();
-		nr_entries = stack_trace_save(kasan_reset_tag(p->addrs),
-					      TRACK_ADDRS_COUNT, 3);
-		metadata_access_disable();
-
-		if (nr_entries < TRACK_ADDRS_COUNT)
-			p->addrs[nr_entries] = 0;
+#ifdef CONFIG_STACKDEPOT
+		p->handle = save_stack_depot_trace(GFP_NOWAIT);
 #endif
 		p->addr = addr;
 		p->cpu = smp_processor_id();
@@ -667,14 +673,19 @@ static void print_track(const char *s, s
 
 	pr_err("%s in %pS age=%lu cpu=%u pid=%d\n",
 	       s, (void *)t->addr, pr_time - t->when, t->cpu, t->pid);
-#ifdef CONFIG_STACKTRACE
+#ifdef CONFIG_STACKDEPOT
 	{
-		int i;
-		for (i = 0; i < TRACK_ADDRS_COUNT; i++)
-			if (t->addrs[i])
-				pr_err("\t%pS\n", (void *)t->addrs[i]);
-			else
-				break;
+		depot_stack_handle_t handle;
+		unsigned long *entries;
+		unsigned int nr_entries;
+
+		handle = READ_ONCE(t->handle);
+		if (!handle) {
+			pr_err("object allocation/free stack trace missing\n");
+		} else {
+			nr_entries = stack_depot_fetch(handle, &entries);
+			stack_trace_print(entries, nr_entries, 0);
+		}
 	}
 #endif
 }
@@ -4048,18 +4059,26 @@ void kmem_obj_info(struct kmem_obj_info
 	objp = fixup_red_left(s, objp);
 	trackp = get_track(s, objp, TRACK_ALLOC);
 	kpp->kp_ret = (void *)trackp->addr;
-#ifdef CONFIG_STACKTRACE
-	for (i = 0; i < KS_ADDRS_COUNT && i < TRACK_ADDRS_COUNT; i++) {
-		kpp->kp_stack[i] = (void *)trackp->addrs[i];
-		if (!kpp->kp_stack[i])
-			break;
-	}
+#ifdef CONFIG_STACKDEPOT
+	{
+		depot_stack_handle_t handle;
+		unsigned long *entries;
+		unsigned int nr_entries;
 
-	trackp = get_track(s, objp, TRACK_FREE);
-	for (i = 0; i < KS_ADDRS_COUNT && i < TRACK_ADDRS_COUNT; i++) {
-		kpp->kp_free_stack[i] = (void *)trackp->addrs[i];
-		if (!kpp->kp_free_stack[i])
-			break;
+		handle = READ_ONCE(trackp->handle);
+		if (handle) {
+			nr_entries = stack_depot_fetch(handle, &entries);
+			for (i = 0; i < KS_ADDRS_COUNT && i < nr_entries; i++)
+				kpp->kp_stack[i] = (void *)entries[i];
+		}
+
+		trackp = get_track(s, objp, TRACK_FREE);
+		handle = READ_ONCE(trackp->handle);
+		if (handle) {
+			nr_entries = stack_depot_fetch(handle, &entries);
+			for (i = 0; i < KS_ADDRS_COUNT && i < nr_entries; i++)
+				kpp->kp_free_stack[i] = (void *)entries[i];
+		}
 	}
 #endif
 #endif
_

Patches currently in -mm which might be from glittao@gmail.com are


