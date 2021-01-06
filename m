Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75BDAC433DB
	for <mm-commits@archiver.kernel.org>; Wed,  6 Jan 2021 23:37:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 273BB23123
	for <mm-commits@archiver.kernel.org>; Wed,  6 Jan 2021 23:37:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbhAFXhF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Jan 2021 18:37:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:50778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727047AbhAFXhF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 6 Jan 2021 18:37:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6F1123123;
        Wed,  6 Jan 2021 23:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609976184;
        bh=yeA/QvInKiwWxJzNAcZTHeX5fBBfCiyeLl69S5k8KKs=;
        h=Date:From:To:Subject:From;
        b=Z6tT/ImZ8RnckYzwG60SplumcpMiTULjR768/5Ika1FWtIgxZSCwQMc3vusOetuWk
         F619xLlS9MVkdRjaPHVWQdY0G5f0HqtkWOyY6hiBNrljC1/V9dJJKk4f27JxJZiLLN
         B1pEZ7rMklpvbb3XTe8RjFuYbaUQe2mBXKaM0f/U=
Date:   Wed, 06 Jan 2021 15:36:24 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        tglx@linutronix.de
Subject:  [obsolete] kmap-stupid-hacks-to-make-it-compile.patch
 removed from -mm tree
Message-ID: <20210106233624.0o4sG-hfV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kmap: stupid hacks to make it compile
has been removed from the -mm tree.  Its filename was
     kmap-stupid-hacks-to-make-it-compile.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kmap: stupid hacks to make it compile

Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c       |    3 ++-
 kernel/sched/core.c |    8 ++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

--- a/kernel/fork.c~kmap-stupid-hacks-to-make-it-compile
+++ a/kernel/fork.c
@@ -77,6 +77,7 @@
 #include <linux/random.h>
 #include <linux/tty.h>
 #include <linux/blkdev.h>
+#include <linux/highmem.h>
 #include <linux/fs_struct.h>
 #include <linux/magic.h>
 #include <linux/perf_event.h>
@@ -932,7 +933,7 @@ static struct task_struct *dup_task_stru
 	account_kernel_stack(tsk, 1);
 
 	kcov_task_init(tsk);
-	kmap_local_fork(tsk);
+//	kmap_local_fork(tsk);
 
 #ifdef CONFIG_FAULT_INJECTION
 	tsk->fail_nth = 0;
--- a/kernel/sched/core.c~kmap-stupid-hacks-to-make-it-compile
+++ a/kernel/sched/core.c
@@ -4094,16 +4094,16 @@ static inline void finish_lock_switch(st
 static inline void kmap_local_sched_out(void)
 {
 #ifdef CONFIG_KMAP_LOCAL
-	if (unlikely(current->kmap_ctrl.idx))
-		__kmap_local_sched_out();
+//	if (unlikely(current->kmap_ctrl.idx))
+//		__kmap_local_sched_out();
 #endif
 }
 
 static inline void kmap_local_sched_in(void)
 {
 #ifdef CONFIG_KMAP_LOCAL
-	if (unlikely(current->kmap_ctrl.idx))
-		__kmap_local_sched_in();
+//	if (unlikely(current->kmap_ctrl.idx))
+//		__kmap_local_sched_in();
 #endif
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-add-a-missing-mm_page_alloc_zone_locked-tracepoint-fix.patch
ubsan-disable-unsigned-integer-overflow-sanitizer-with-clang-fix.patch
mm.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-fix.patch
mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage-checkpatch-fixes.patch
mm-cma-allocate-cma-areas-bottom-up-fix-3-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

