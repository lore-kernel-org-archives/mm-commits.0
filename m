Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73E18C433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:39:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 486DD20723
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027151;
	bh=ZtKd/IbPWal0aPdWNbTl0SxD9qsO8vpK28ZOgMOdgHE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=X+EvM7v9qPMdy56xK9RGSu8BNowVGwuC6CMj2x0eX/4BQ27l+cOFBToTrH9Bhgppq
	 k1ABSpNSCvmBBb/oKh9OLhJWa1IiWCuw0Dwen49RUloS3E6m9VoqXUfHgPtvk9ZjVN
	 wF7Pdg8VoP7AotJ7TL20XSIQR5jVgOanzj7aitCs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgHJCjL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:39:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:42386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCjK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:39:10 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B9E32065D;
        Mon, 10 Aug 2020 02:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027149;
        bh=ZtKd/IbPWal0aPdWNbTl0SxD9qsO8vpK28ZOgMOdgHE=;
        h=Date:From:To:Subject:From;
        b=eLOws91xDEcjfbHVRJ2B2p6LEhA/MfOsLfTniuW2Zz9T5RmX4AbZa8q0GGy76vYf8
         gy4imSWMR7T6kv8Tz7doI1wsAnRP5OtNZaL1H6OH+CYNuZ++jalfbRVGfhznxBu4d8
         a5eRc6jHuqqF9m9Yonx4D5c3fmoa4hQSC0dtrAYI=
Date:   Sun, 09 Aug 2020 19:39:09 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com, corbet@lwn.net,
        dvyukov@google.com, glider@google.com, jiangshanlai@gmail.com,
        joel@joelfernandes.org, josh@joshtriplett.org,
        mathieu.desnoyers@efficios.com, matthias.bgg@gmail.com,
        mm-commits@vger.kernel.org, paulmck@kernel.org,
        walter-zh.wu@mediatek.com
Subject:  [merged]
 rcu-kasan-record-and-print-call_rcu-call-stack.patch removed from -mm tree
Message-ID: <20200810023909.gkZG1uZO8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: rcu: kasan: record and print call_rcu() call stack
has been removed from the -mm tree.  Its filename was
     rcu-kasan-record-and-print-call_rcu-call-stack.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Walter Wu <walter-zh.wu@mediatek.com>
Subject: rcu: kasan: record and print call_rcu() call stack

Patch series "kasan: memorize and print call_rcu stack", v8.

This patchset improves KASAN reports by making them to have call_rcu()
call stack information.  It is useful for programmers to solve
use-after-free or double-free memory issue.

The KASAN report was as follows(cleaned up slightly):

BUG: KASAN: use-after-free in kasan_rcu_reclaim+0x58/0x60

Freed by task 0:
 kasan_save_stack+0x24/0x50
 kasan_set_track+0x24/0x38
 kasan_set_free_info+0x18/0x20
 __kasan_slab_free+0x10c/0x170
 kasan_slab_free+0x10/0x18
 kfree+0x98/0x270
 kasan_rcu_reclaim+0x1c/0x60

Last call_rcu():
 kasan_save_stack+0x24/0x50
 kasan_record_aux_stack+0xbc/0xd0
 call_rcu+0x8c/0x580
 kasan_rcu_uaf+0xf4/0xf8

Generic KASAN will record the last two call_rcu() call stacks and print up
to 2 call_rcu() call stacks in KASAN report.  it is only suitable for
generic KASAN.

This feature considers the size of struct kasan_alloc_meta and
kasan_free_meta, we try to optimize the structure layout and size, lets it
get better memory consumption.

[1]https://bugzilla.kernel.org/show_bug.cgi?id=198437
[2]https://groups.google.com/forum/#!searchin/kasan-dev/better$20stack$20traces$20for$20rcu%7Csort:date/kasan-dev/KQsjT_88hDE/7rNUZprRBgAJ


This patch (of 4):

This feature will record the last two call_rcu() call stacks and prints up
to 2 call_rcu() call stacks in KASAN report.

When call_rcu() is called, we store the call_rcu() call stack into slub
alloc meta-data, so that the KASAN report can print rcu stack.

[1]https://bugzilla.kernel.org/show_bug.cgi?id=198437
[2]https://groups.google.com/forum/#!searchin/kasan-dev/better$20stack$20traces$20for$20rcu%7Csort:date/kasan-dev/KQsjT_88hDE/7rNUZprRBgAJ

[walter-zh.wu@mediatek.com: build fix]
  Link: http://lkml.kernel.org/r/20200710162401.23816-1-walter-zh.wu@mediatek.com
Link: http://lkml.kernel.org/r/20200710162123.23713-1-walter-zh.wu@mediatek.com
Link: http://lkml.kernel.org/r/20200601050847.1096-1-walter-zh.wu@mediatek.com
Link: http://lkml.kernel.org/r/20200601050927.1153-1-walter-zh.wu@mediatek.com
Signed-off-by: Walter Wu <walter-zh.wu@mediatek.com>
Suggested-by: Dmitry Vyukov <dvyukov@google.com>
Acked-by: Paul E. McKenney <paulmck@kernel.org>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Tested-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |    2 ++
 kernel/rcu/tree.c     |    2 ++
 mm/kasan/common.c     |    4 ++--
 mm/kasan/generic.c    |   21 +++++++++++++++++++++
 mm/kasan/kasan.h      |    9 +++++++++
 mm/kasan/report.c     |   28 +++++++++++++++++++++++-----
 6 files changed, 59 insertions(+), 7 deletions(-)

--- a/include/linux/kasan.h~rcu-kasan-record-and-print-call_rcu-call-stack
+++ a/include/linux/kasan.h
@@ -174,11 +174,13 @@ static inline size_t kasan_metadata_size
 
 void kasan_cache_shrink(struct kmem_cache *cache);
 void kasan_cache_shutdown(struct kmem_cache *cache);
+void kasan_record_aux_stack(void *ptr);
 
 #else /* CONFIG_KASAN_GENERIC */
 
 static inline void kasan_cache_shrink(struct kmem_cache *cache) {}
 static inline void kasan_cache_shutdown(struct kmem_cache *cache) {}
+static inline void kasan_record_aux_stack(void *ptr) {}
 
 #endif /* CONFIG_KASAN_GENERIC */
 
--- a/kernel/rcu/tree.c~rcu-kasan-record-and-print-call_rcu-call-stack
+++ a/kernel/rcu/tree.c
@@ -59,6 +59,7 @@
 #include <linux/sched/clock.h>
 #include <linux/vmalloc.h>
 #include <linux/mm.h>
+#include <linux/kasan.h>
 #include "../time/tick-internal.h"
 
 #include "tree.h"
@@ -2890,6 +2891,7 @@ __call_rcu(struct rcu_head *head, rcu_ca
 	head->func = func;
 	head->next = NULL;
 	local_irq_save(flags);
+	kasan_record_aux_stack(head);
 	rdp = this_cpu_ptr(&rcu_data);
 
 	/* Add the callback to our list. */
--- a/mm/kasan/common.c~rcu-kasan-record-and-print-call_rcu-call-stack
+++ a/mm/kasan/common.c
@@ -40,7 +40,7 @@
 #include "kasan.h"
 #include "../slab.h"
 
-static inline depot_stack_handle_t save_stack(gfp_t flags)
+depot_stack_handle_t kasan_save_stack(gfp_t flags)
 {
 	unsigned long entries[KASAN_STACK_DEPTH];
 	unsigned int nr_entries;
@@ -53,7 +53,7 @@ static inline depot_stack_handle_t save_
 static inline void set_track(struct kasan_track *track, gfp_t flags)
 {
 	track->pid = current->pid;
-	track->stack = save_stack(flags);
+	track->stack = kasan_save_stack(flags);
 }
 
 void kasan_enable_current(void)
--- a/mm/kasan/generic.c~rcu-kasan-record-and-print-call_rcu-call-stack
+++ a/mm/kasan/generic.c
@@ -324,3 +324,24 @@ DEFINE_ASAN_SET_SHADOW(f2);
 DEFINE_ASAN_SET_SHADOW(f3);
 DEFINE_ASAN_SET_SHADOW(f5);
 DEFINE_ASAN_SET_SHADOW(f8);
+
+void kasan_record_aux_stack(void *addr)
+{
+	struct page *page = kasan_addr_to_page(addr);
+	struct kmem_cache *cache;
+	struct kasan_alloc_meta *alloc_info;
+	void *object;
+
+	if (!(page && PageSlab(page)))
+		return;
+
+	cache = page->slab_cache;
+	object = nearest_obj(cache, page, addr);
+	alloc_info = get_alloc_info(cache, object);
+
+	/*
+	 * record the last two call_rcu() call stacks.
+	 */
+	alloc_info->aux_stack[1] = alloc_info->aux_stack[0];
+	alloc_info->aux_stack[0] = kasan_save_stack(GFP_NOWAIT);
+}
--- a/mm/kasan/kasan.h~rcu-kasan-record-and-print-call_rcu-call-stack
+++ a/mm/kasan/kasan.h
@@ -104,6 +104,13 @@ struct kasan_track {
 
 struct kasan_alloc_meta {
 	struct kasan_track alloc_track;
+#ifdef CONFIG_KASAN_GENERIC
+	/*
+	 * call_rcu() call stack is stored into struct kasan_alloc_meta.
+	 * The free stack is stored into struct kasan_free_meta.
+	 */
+	depot_stack_handle_t aux_stack[2];
+#endif
 	struct kasan_track free_track[KASAN_NR_FREE_STACKS];
 #ifdef CONFIG_KASAN_SW_TAGS_IDENTIFY
 	u8 free_pointer_tag[KASAN_NR_FREE_STACKS];
@@ -159,6 +166,8 @@ void kasan_report_invalid_free(void *obj
 
 struct page *kasan_addr_to_page(const void *addr);
 
+depot_stack_handle_t kasan_save_stack(gfp_t flags);
+
 #if defined(CONFIG_KASAN_GENERIC) && \
 	(defined(CONFIG_SLAB) || defined(CONFIG_SLUB))
 void quarantine_put(struct kasan_free_meta *info, struct kmem_cache *cache);
--- a/mm/kasan/report.c~rcu-kasan-record-and-print-call_rcu-call-stack
+++ a/mm/kasan/report.c
@@ -106,15 +106,20 @@ static void end_report(unsigned long *fl
 	kasan_enable_current();
 }
 
+static void print_stack(depot_stack_handle_t stack)
+{
+	unsigned long *entries;
+	unsigned int nr_entries;
+
+	nr_entries = stack_depot_fetch(stack, &entries);
+	stack_trace_print(entries, nr_entries, 0);
+}
+
 static void print_track(struct kasan_track *track, const char *prefix)
 {
 	pr_err("%s by task %u:\n", prefix, track->pid);
 	if (track->stack) {
-		unsigned long *entries;
-		unsigned int nr_entries;
-
-		nr_entries = stack_depot_fetch(track->stack, &entries);
-		stack_trace_print(entries, nr_entries, 0);
+		print_stack(track->stack);
 	} else {
 		pr_err("(stack is not available)\n");
 	}
@@ -193,6 +198,19 @@ static void describe_object(struct kmem_
 		free_track = kasan_get_free_track(cache, object, tag);
 		print_track(free_track, "Freed");
 		pr_err("\n");
+
+#ifdef CONFIG_KASAN_GENERIC
+		if (alloc_info->aux_stack[0]) {
+			pr_err("Last call_rcu():\n");
+			print_stack(alloc_info->aux_stack[0]);
+			pr_err("\n");
+		}
+		if (alloc_info->aux_stack[1]) {
+			pr_err("Second to last call_rcu():\n");
+			print_stack(alloc_info->aux_stack[1]);
+			pr_err("\n");
+		}
+#endif
 	}
 
 	describe_object_addr(cache, object, addr);
_

Patches currently in -mm which might be from walter-zh.wu@mediatek.com are


