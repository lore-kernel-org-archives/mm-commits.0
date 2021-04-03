Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D5C2C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  3 Apr 2021 00:27:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF3AE611AB
	for <mm-commits@archiver.kernel.org>; Sat,  3 Apr 2021 00:27:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235776AbhDCA1y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Apr 2021 20:27:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:37800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235689AbhDCA1x (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 2 Apr 2021 20:27:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04B4E61185;
        Sat,  3 Apr 2021 00:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617409671;
        bh=HuizY0q+A8qYixy7tWAvFAW43Bd3+gZ6QjLEbAWDuaI=;
        h=Date:From:To:Subject:From;
        b=Ed84E7kOHcqO+anYe+lGiq9kTuPrOxPzYBcHaa/ff+vZ0lzqdJFCo1iMigYfpJJfB
         Hq5+Hpj6VJGEPy2agT15+iv7OLbySIIB1NlAYtPofMOSzxpFWLvD6ckVhGKGEXHQma
         73Jel9oOOl8h2eJvy1L90aduGNINrP/MiWTOYtqs=
Date:   Fri, 02 Apr 2021 17:27:50 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, bristot@redhat.com, bsegall@google.com,
        dietmar.eggemann@arm.com, juri.lelli@redhat.com, mgorman@suse.de,
        mingo@redhat.com, mm-commits@vger.kernel.org, peterz@infradead.org,
        rostedt@goodmis.org, slyfox@gentoo.org, vincent.guittot@linaro.org
Subject:  +
 mm-page_owner-detect-page_owner-recursion-via-task_struct.patch added to
 -mm tree
Message-ID: <20210403002750.JjGDsRbX8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_owner: detect page_owner recursion via task_struct
has been added to the -mm tree.  Its filename is
     mm-page_owner-detect-page_owner-recursion-via-task_struct.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_owner-detect-page_owner-recursion-via-task_struct.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_owner-detect-page_owner-recursion-via-task_struct.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergei Trofimovich <slyfox@gentoo.org>
Subject: mm: page_owner: detect page_owner recursion via task_struct

Before the change page_owner recursion was detected via fetching
backtrace and inspecting it for current instruction pointer.
It has a few problems:
- it is slightly slow as it requires extra backtrace and a linear
  stack scan of the result
- it is too late to check if backtrace fetching required memory
  allocation itself (ia64's unwinder requires it).

To simplify recursion tracking let's use page_owner recursion flag
in 'struct task_struct'.

The change make page_owner=on work on ia64 by avoiding infinite
recursion in:
  kmalloc()
  -> __set_page_owner()
  -> save_stack()
  -> unwind() [ia64-specific]
  -> build_script()
  -> kmalloc()
  -> __set_page_owner() [we short-circuit here]
  -> save_stack()
  -> unwind() [recursion]

Link: https://lkml.kernel.org/r/20210402115342.1463781-1-slyfox@gentoo.org
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ben Segall <bsegall@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Daniel Bristot de Oliveira <bristot@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    4 ++++
 mm/page_owner.c       |   32 ++++++++++----------------------
 2 files changed, 14 insertions(+), 22 deletions(-)

--- a/include/linux/sched.h~mm-page_owner-detect-page_owner-recursion-via-task_struct
+++ a/include/linux/sched.h
@@ -841,6 +841,10 @@ struct task_struct {
 	/* Stalled due to lack of memory */
 	unsigned			in_memstall:1;
 #endif
+#ifdef CONFIG_PAGE_OWNER
+	/* Used by page_owner=on to detect recursion in page tracking. */
+	unsigned			in_page_owner:1;
+#endif
 
 	unsigned long			atomic_flags; /* Flags requiring atomic access. */
 
--- a/mm/page_owner.c~mm-page_owner-detect-page_owner-recursion-via-task_struct
+++ a/mm/page_owner.c
@@ -98,42 +98,30 @@ static inline struct page_owner *get_pag
 	return (void *)page_ext + page_owner_ops.offset;
 }
 
-static inline bool check_recursive_alloc(unsigned long *entries,
-					 unsigned int nr_entries,
-					 unsigned long ip)
-{
-	unsigned int i;
-
-	for (i = 0; i < nr_entries; i++) {
-		if (entries[i] == ip)
-			return true;
-	}
-	return false;
-}
-
 static noinline depot_stack_handle_t save_stack(gfp_t flags)
 {
 	unsigned long entries[PAGE_OWNER_STACK_DEPTH];
 	depot_stack_handle_t handle;
 	unsigned int nr_entries;
 
-	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 2);
-
 	/*
-	 * We need to check recursion here because our request to
-	 * stackdepot could trigger memory allocation to save new
-	 * entry. New memory allocation would reach here and call
-	 * stack_depot_save_entries() again if we don't catch it. There is
-	 * still not enough memory in stackdepot so it would try to
-	 * allocate memory again and loop forever.
+	 * Avoid recursion.
+	 *
+	 * Sometimes page metadata allocation tracking requires more
+	 * memory to be allocated:
+	 * - when new stack trace is saved to stack depot
+	 * - when backtrace itself is calculated (ia64)
 	 */
-	if (check_recursive_alloc(entries, nr_entries, _RET_IP_))
+	if (current->in_page_owner)
 		return dummy_handle;
+	current->in_page_owner = 1;
 
+	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 2);
 	handle = stack_depot_save(entries, nr_entries, flags);
 	if (!handle)
 		handle = failure_handle;
 
+	current->in_page_owner = 0;
 	return handle;
 }
 
_

Patches currently in -mm which might be from slyfox@gentoo.org are

ia64-fix-user_stack_pointer-for-ptrace.patch
ia64-drop-unused-ia64_fw_emu-ifdef.patch
ia64-simplify-code-flow-around-swiotlb-init.patch
ia64-fix-efi_debug-build.patch
ia64-mca-always-make-ia64_mca_debug-an-expression.patch
mm-page_owner-fetch-backtrace-only-for-tracked-pages.patch
mm-page_owner-use-kstrtobool-to-parse-bool-option.patch
mm-page_owner-detect-page_owner-recursion-via-task_struct.patch
mm-page_alloc-ignore-init_on_free=1-for-debug_pagealloc=1.patch

