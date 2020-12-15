Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10B57C2BB48
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 02:12:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D37F2206D6
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 02:12:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgLOCMg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 21:12:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:39948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726313AbgLOCM1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 21:12:27 -0500
Date:   Mon, 14 Dec 2020 18:11:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607998306;
        bh=5MzPm7rhlEqiB4FJFM1VD1gyvYU+CJkrfI/8FPDblTE=;
        h=From:To:Subject:From;
        b=vEIGb6xQGkvLdIcu6O1OS/FmKGkCZVrROEJIrrbTEtj+ptVkrBww7Jg0vB3dnrDpP
         uAYWqD7irma5OT0vpJYhCGCuA7sfPvzKMLIzp5SwPLTYf/Vb643aALqq0KKmT7iHhx
         MqlZn7hpeAHs1kMsTZ6TJFDY26DJR2tc1KTjsYVY=
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        pmladek@suse.com, Qiang.Zhang@windriver.com, tglx@linutronix.de,
        tj@kernel.org
Subject:  [folded-merged]
 kthread_worker-document-cpu-hotplug-handling-fix.patch removed from -mm
 tree
Message-ID: <20201215021145.ZDQFDjQbJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kthread_worker-document-cpu-hotplug-handling-fix
has been removed from the -mm tree.  Its filename was
     kthread_worker-document-cpu-hotplug-handling-fix.patch

This patch was dropped because it was folded into kthread_worker-document-cpu-hotplug-handling.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kthread_worker-document-cpu-hotplug-handling-fix

grammar tweaks

Cc: Petr Mladek <pmladek@suse.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Zhang Qiang <Qiang.Zhang@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/kthread.c~kthread_worker-document-cpu-hotplug-handling-fix
+++ a/kernel/kthread.c
@@ -795,11 +795,11 @@ EXPORT_SYMBOL(kthread_create_worker);
  *
  * CPU hotplug:
  * The kthread worker API is simple and generic. It just provides a way
- * how to create, use, and destroy workers.
+ * to create, use, and destroy workers.
  *
  * It is up to the API user how to handle CPU hotplug. They have to decide
  * how to handle pending work items, prevent queuing new ones, and
- * restore the functionality when the CPU goes off and on. There are
+ * restore the functionality when the CPU goes off and on. There are a
  * few catches:
  *
  *    - CPU affinity gets lost when it is scheduled on an offline CPU.
@@ -807,8 +807,8 @@ EXPORT_SYMBOL(kthread_create_worker);
  *    - The worker might not exist when the CPU was off when the user
  *      created the workers.
  *
- * A good practice is to implement two CPU hotplug callbacks and
- * destroy/create the worker when CPU goes down/up.
+ * Good practice is to implement two CPU hotplug callbacks and to
+ * destroy/create the worker when the CPU goes down/up.
  *
  * Return:
  * The pointer to the allocated worker on success, ERR_PTR(-ENOMEM)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kthread_worker-document-cpu-hotplug-handling.patch
mm-remove-the-unuseful-else-after-a-return-checkpatch-fixes.patch
mm-prevent-gup_fast-from-racing-with-cow-during-fork-checkpatch-fixes.patch
mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
mm-memcontrol-account-pagetables-per-node-fix.patch
mm-vmallocc-__vmalloc_area_node-avoid-32-bit-overflow.patch
mm-cma-improve-pr_debug-log-in-cma_release-fix.patch
mm.patch
mm-fix-initialization-of-struct-page-for-holes-in-memory-layout-checkpatch-fixes.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix.patch
ilog2-improve-ilog2-for-constant-arguments-checkpatch-fixes.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
checkpatch-fix-typo_spelling-check-for-words-with-apostrophe-fix.patch
resource-fix-kernel-doc-markups-checkpatch-fixes.patch
lib-ubsanc-mark-type_check_kinds-with-static-keyword-fix.patch
linux-next-rejects.patch
kmap-stupid-hacks-to-make-it-compile.patch
epoll-wire-up-syscall-epoll_pwait2-fix.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

