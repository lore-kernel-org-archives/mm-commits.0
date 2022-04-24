Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA5E7C433F5
	for <mm-commits@archiver.kernel.org>; Sun, 24 Apr 2022 21:39:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236859AbiDXVmo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 24 Apr 2022 17:42:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234435AbiDXVmn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 24 Apr 2022 17:42:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F0315248B
        for <mm-commits@vger.kernel.org>; Sun, 24 Apr 2022 14:39:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED64961326
        for <mm-commits@vger.kernel.org>; Sun, 24 Apr 2022 21:39:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB8CC385A7;
        Sun, 24 Apr 2022 21:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650836380;
        bh=M/vWz+XPkHUol5dRm8fNgjeWaBNzsYGeg3ZYLJX1GgA=;
        h=Date:To:From:Subject:From;
        b=G6pOSBlJ4CTdOgv7xRYXU3qSztpcjRY1kKRnR/92xNQUR3J/fB0l8bV8YEmACgM03
         +A26D861DZit283jfkDyZf9ttLDUIjldulz3FnpSVZwBRIkifOhnzZKaJG4umFanPD
         HYRMVJSaJ79aOojIsJXWhtL0PawPQ7ylOfCCVgJA=
Date:   Sun, 24 Apr 2022 14:39:39 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        qiang1.zhang@intel.com, glider@google.com, dvyukov@google.com,
        bigeasy@linutronix.de, andreyknvl@gmail.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kasan-fix-sleeping-function-called-from-invalid-context-on-rt-kernel-fix.patch removed from -mm tree
Message-Id: <20220424213940.4EB8CC385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan-fix-sleeping-function-called-from-invalid-context-on-rt-kernel-fix
has been removed from the -mm tree.  Its filename was
     kasan-fix-sleeping-function-called-from-invalid-context-on-rt-kernel-fix.patch

This patch was dropped because it was folded into kasan-fix-sleeping-function-called-from-invalid-context-on-rt-kernel.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kasan-fix-sleeping-function-called-from-invalid-context-on-rt-kernel-fix

reduce ifdeffery

Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Zqiang <qiang1.zhang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/quarantine.c |   52 +++++++++++++++++++++++-----------------
 1 file changed, 31 insertions(+), 21 deletions(-)

--- a/mm/kasan/quarantine.c~kasan-fix-sleeping-function-called-from-invalid-context-on-rt-kernel-fix
+++ a/mm/kasan/quarantine.c
@@ -319,28 +319,37 @@ static void qlist_move_cache(struct qlis
 	}
 }
 
-static void per_cpu_remove_cache(void *arg)
+#ifndef CONFIG_PREEMPT_RT
+static void __per_cpu_remove_cache(struct qlist_head *q, void *arg)
 {
 	struct kmem_cache *cache = arg;
-	struct qlist_head *q;
-#ifndef CONFIG_PREEMPT_RT
 	struct qlist_head to_free = QLIST_INIT;
-#else
-	unsigned long flags;
-	struct cpu_shrink_qlist *sq;
-#endif
-	q = this_cpu_ptr(&cpu_quarantine);
-#ifndef CONFIG_PREEMPT_RT
-	if (READ_ONCE(q->offline))
-		return;
+
 	qlist_move_cache(q, &to_free, cache);
 	qlist_free_all(&to_free, cache);
+}
 #else
+static void __per_cpu_remove_cache(struct qlist_head *q, void *arg)
+{
+	struct kmem_cache *cache = arg;
+	unsigned long flags;
+	struct cpu_shrink_qlist *sq;
+
 	sq = this_cpu_ptr(&shrink_qlist);
 	raw_spin_lock_irqsave(&sq->lock, flags);
 	qlist_move_cache(q, &sq->qlist, cache);
 	raw_spin_unlock_irqrestore(&sq->lock, flags);
+}
 #endif
+
+static void per_cpu_remove_cache(void *arg)
+{
+	struct qlist_head *q;
+
+	q = this_cpu_ptr(&cpu_quarantine);
+	if (READ_ONCE(q->offline))
+		return;
+	__per_cpu_remove_cache(q, arg);
 }
 
 /* Free all quarantined objects belonging to cache. */
@@ -348,10 +357,6 @@ void kasan_quarantine_remove_cache(struc
 {
 	unsigned long flags, i;
 	struct qlist_head to_free = QLIST_INIT;
-#ifdef CONFIG_PREEMPT_RT
-	int cpu;
-	struct cpu_shrink_qlist *sq;
-#endif
 
 	/*
 	 * Must be careful to not miss any objects that are being moved from
@@ -363,13 +368,18 @@ void kasan_quarantine_remove_cache(struc
 	on_each_cpu(per_cpu_remove_cache, cache, 1);
 
 #ifdef CONFIG_PREEMPT_RT
-	for_each_online_cpu(cpu) {
-		sq = per_cpu_ptr(&shrink_qlist, cpu);
-		raw_spin_lock_irqsave(&sq->lock, flags);
-		qlist_move_cache(&sq->qlist, &to_free, cache);
-		raw_spin_unlock_irqrestore(&sq->lock, flags);
+	{
+		int cpu;
+		struct cpu_shrink_qlist *sq;
+
+		for_each_online_cpu(cpu) {
+			sq = per_cpu_ptr(&shrink_qlist, cpu);
+			raw_spin_lock_irqsave(&sq->lock, flags);
+			qlist_move_cache(&sq->qlist, &to_free, cache);
+			raw_spin_unlock_irqrestore(&sq->lock, flags);
+		}
+		qlist_free_all(&to_free, cache);
 	}
-	qlist_free_all(&to_free, cache);
 #endif
 
 	raw_spin_lock_irqsave(&quarantine_lock, flags);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
kasan-fix-sleeping-function-called-from-invalid-context-on-rt-kernel.patch
mm-create-new-mm-swaph-header-file-fix.patch
mm-shmem-make-shmem_init-return-void-fix.patch
mm-check-against-orig_pte-for-finish_fault-fix-checkpatch-fixes.patch
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix-fix.patch
mm-vmscan-fix-comment-for-current_may_throttle-fix.patch
ksm-count-ksm-merging-pages-for-each-process-fix.patch
mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body-fix.patch
add-fat-messages-to-printk-index-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

