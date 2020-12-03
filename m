Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BDEAC6369E
	for <mm-commits@archiver.kernel.org>; Thu,  3 Dec 2020 00:49:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A497221FB
	for <mm-commits@archiver.kernel.org>; Thu,  3 Dec 2020 00:49:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbgLCAsu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Dec 2020 19:48:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:56996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726851AbgLCAsu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 2 Dec 2020 19:48:50 -0500
Date:   Wed, 02 Dec 2020 16:48:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606956489;
        bh=KgJoLXORv+n+6XbvEsH643yZ3Vf/9KTKwgpqdWNAEXw=;
        h=From:To:Subject:From;
        b=inDjtDDzhEeuGQOm2NlvaeX3z2pdx0D+F7xzmadbGHu5iIir1GjP5ffGDtRnSSfOV
         le60dbipQsNfiCJEszD7BlOqACsOal423SSWaxpN0ESGa48z9Jtc5yYHdyiKAjb1Iz
         QJ88Lqq9u1kuFbiH/Xa4fY5OpmFhIiIEcBQmPC88=
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        tglx@linutronix.de
Subject:  + kmap-stupid-hacks-to-make-it-compile.patch added to -mm
 tree
Message-ID: <20201203004808.O8EY61bjU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kmap: stupid hacks to make it compile
has been added to the -mm tree.  Its filename is
     kmap-stupid-hacks-to-make-it-compile.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kmap-stupid-hacks-to-make-it-compile.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kmap-stupid-hacks-to-make-it-compile.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -930,7 +931,7 @@ static struct task_struct *dup_task_stru
 	account_kernel_stack(tsk, 1);
 
 	kcov_task_init(tsk);
-	kmap_local_fork(tsk);
+//	kmap_local_fork(tsk);
 
 #ifdef CONFIG_FAULT_INJECTION
 	tsk->fail_nth = 0;
--- a/kernel/sched/core.c~kmap-stupid-hacks-to-make-it-compile
+++ a/kernel/sched/core.c
@@ -4093,16 +4093,16 @@ static inline void finish_lock_switch(st
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

kthread_worker-document-cpu-hotplug-handling-fix.patch
mm.patch
mm-remove-the-unuseful-else-after-a-return-checkpatch-fixes.patch
mm-prevent-gup_fast-from-racing-with-cow-during-fork-checkpatch-fixes.patch
mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
mm-vmallocc-__vmalloc_area_node-avoid-32-bit-overflow.patch
mm-truncateshmem-handle-truncates-that-split-thps-fix-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix.patch
ilog2-improve-ilog2-for-constant-arguments-checkpatch-fixes.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
checkpatch-fix-typo_spelling-check-for-words-with-apostrophe-fix.patch
resource-fix-kernel-doc-markups-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kmap-stupid-hacks-to-make-it-compile.patch
init-kconfig-dont-assume-scripts-lld-versionsh-is-executable.patch
kernel-forkc-export-kernel_thread-to-modules.patch

