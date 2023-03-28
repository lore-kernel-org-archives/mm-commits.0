Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2728AC77B6C
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:21:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbjC1XVL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjC1XVJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:21:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66EFB2698
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:21:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F01FF618FE
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:21:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52C77C4339C;
        Tue, 28 Mar 2023 23:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045665;
        bh=oSO/tE/3IGlhzEoZELd5KngXJFHI/UhAUmS8Vn6sO+Q=;
        h=Date:To:From:Subject:From;
        b=0gIWEs0alLpZdM9YEwTvzQLFqhFVkWRyx8HUw2hFE/zOdOLu/exmSKZ937C5TuHSB
         jhvR1ElmfKz52E9+hwTvGQj0Ox0xbq5xqTSw5LvGDYjCFSW+hl/71OCP0FJT85vdID
         T+iSNyKp+Hkj9m0o6k6TnFRJQMXfTkNbij2dNc5s=
Date:   Tue, 28 Mar 2023 16:21:04 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        torvalds@linux-foundation.org, riel@redhat.com,
        peterz@infradead.org, nadav.amit@gmail.com, mpe@ellerman.id.au,
        luto@kernel.org, dave.hansen@linux.intel.com,
        christophe.leroy@csgroup.eu, catalin.marinas@arm.com,
        npiggin@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kthread-simplify-kthread_use_mm-refcounting.patch removed from -mm tree
Message-Id: <20230328232105.52C77C4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kthread: simplify kthread_use_mm refcounting
has been removed from the -mm tree.  Its filename was
     kthread-simplify-kthread_use_mm-refcounting.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nicholas Piggin <npiggin@gmail.com>
Subject: kthread: simplify kthread_use_mm refcounting
Date: Fri, 3 Feb 2023 17:18:33 +1000

Patch series "shoot lazy tlbs (lazy tlb refcount scalability
improvement)", v7.

This series improves scalability of context switching between user and
kernel threads on large systems with a threaded process spread across a
lot of CPUs.

Discussion of v6 here:
https://lore.kernel.org/linux-mm/20230118080011.2258375-1-npiggin@gmail.com/


This patch (of 5):

Remove the special case avoiding refcounting when the mm to be used is the
same as the kernel thread's active (lazy tlb) mm.  kthread_use_mm() should
not be such a performance critical path that this matters much.  This
simplifies a later change to lazy tlb mm refcounting.

Link: https://lkml.kernel.org/r/20230203071837.1136453-1-npiggin@gmail.com
Link: https://lkml.kernel.org/r/20230203071837.1136453-2-npiggin@gmail.com
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

--- a/kernel/kthread.c~kthread-simplify-kthread_use_mm-refcounting
+++ a/kernel/kthread.c
@@ -1415,14 +1415,13 @@ void kthread_use_mm(struct mm_struct *mm
 	WARN_ON_ONCE(!(tsk->flags & PF_KTHREAD));
 	WARN_ON_ONCE(tsk->mm);
 
+	mmgrab(mm);
+
 	task_lock(tsk);
 	/* Hold off tlb flush IPIs while switching mm's */
 	local_irq_disable();
 	active_mm = tsk->active_mm;
-	if (active_mm != mm) {
-		mmgrab(mm);
-		tsk->active_mm = mm;
-	}
+	tsk->active_mm = mm;
 	tsk->mm = mm;
 	membarrier_update_current_mm(mm);
 	switch_mm_irqs_off(active_mm, mm, tsk);
@@ -1439,12 +1438,9 @@ void kthread_use_mm(struct mm_struct *mm
 	 * memory barrier after storing to tsk->mm, before accessing
 	 * user-space memory. A full memory barrier for membarrier
 	 * {PRIVATE,GLOBAL}_EXPEDITED is implicitly provided by
-	 * mmdrop(), or explicitly with smp_mb().
+	 * mmdrop().
 	 */
-	if (active_mm != mm)
-		mmdrop(active_mm);
-	else
-		smp_mb();
+	mmdrop(active_mm);
 }
 EXPORT_SYMBOL_GPL(kthread_use_mm);
 
_

Patches currently in -mm which might be from npiggin@gmail.com are


