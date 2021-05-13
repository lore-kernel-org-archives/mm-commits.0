Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D05EC433ED
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 00:11:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D7CE611F0
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 00:11:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233243AbhEMAL4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 May 2021 20:11:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:35468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232979AbhEMAHK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 May 2021 20:07:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9D96613CA;
        Thu, 13 May 2021 00:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620864362;
        bh=orOpNaAyXPTivu1LgvsQjAnkPtSzSbbEkZypebmWLwg=;
        h=Date:From:To:Subject:From;
        b=PjxitZ70lrDEmwAzqCQPxWrX7AgJCXgnQ7z83XH8RpPk0YDDQo3TXKKEV81rl8dnM
         uydSpcYT1EmU2q01FkcFBTlmDppYCqAUyual4gKOT1zYl/xtwiVDa5Xsme2g0jHKAO
         LaMvxH44+0RQififHXPdgeAhwX6YuYUEvMFAaRwI=
Date:   Wed, 12 May 2021 17:06:01 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, glittao@gmail.com, iamjoonsoo.kim@lge.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz
Subject:  +
 mm-slub-use-stackdepot-to-save-stack-trace-in-objects.patch added to -mm
 tree
Message-ID: <20210513000601.psnQqE1XM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub: use stackdepot to save stack trace in objects
has been added to the -mm tree.  Its filename is
     mm-slub-use-stackdepot-to-save-stack-trace-in-objects.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-use-stackdepot-to-save-stack-trace-in-objects.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-use-stackdepot-to-save-stack-trace-in-objects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Link: https://lkml.kernel.org/r/20210414163434.4376-1-glittao@gmail.com
Signed-off-by: Oliver Glitta <glittao@gmail.com>
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
@@ -1853,6 +1853,7 @@ config SLUB_DEBUG
 	default y
 	bool "Enable SLUB debugging support" if EXPERT
 	depends on SLUB && SYSFS
+	select STACKDEPOT if STACKTRACE_SUPPORT
 	help
 	  SLUB has extensive debug support features. Disabling these can
 	  result in significant savings in code size. This also disables
--- a/mm/slub.c~mm-slub-use-stackdepot-to-save-stack-trace-in-objects
+++ a/mm/slub.c
@@ -25,6 +25,7 @@
 #include <linux/cpuset.h>
 #include <linux/mempolicy.h>
 #include <linux/ctype.h>
+#include <linux/stackdepot.h>
 #include <linux/debugobjects.h>
 #include <linux/kallsyms.h>
 #include <linux/kfence.h>
@@ -204,8 +205,8 @@ static inline bool kmem_cache_has_cpu_pa
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
@@ -602,22 +603,27 @@ static struct track *get_track(struct km
 	return kasan_reset_tag(p + alloc);
 }
 
+#ifdef CONFIG_STACKDEPOT
+static depot_stack_handle_t save_stack_trace(gfp_t flags)
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
+		p->handle = save_stack_trace(GFP_KERNEL);
 #endif
 		p->addr = addr;
 		p->cpu = smp_processor_id();
@@ -644,14 +650,19 @@ static void print_track(const char *s, s
 
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
@@ -4027,18 +4038,26 @@ void kmem_obj_info(struct kmem_obj_info
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

mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality.patch
mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix.patch
slub-remove-resiliency_test-function.patch
mm-slub-use-stackdepot-to-save-stack-trace-in-objects.patch

