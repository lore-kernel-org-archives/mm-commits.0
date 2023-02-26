Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4854EC7EE2D
	for <mm-commits@archiver.kernel.org>; Sun, 26 Feb 2023 22:13:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjBZWNa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Feb 2023 17:13:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjBZWN3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Feb 2023 17:13:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F34CA09
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 14:13:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6277760C55
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 22:13:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B83F8C433EF;
        Sun, 26 Feb 2023 22:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677449607;
        bh=zxOUJmb/zMSWxPXQ53NUcQLpQd03vMN2yVbbG3iLIug=;
        h=Date:To:From:Subject:From;
        b=yg5uhY2/6GSAyPz0xJ6RTsR3SgbinTUxl4CCYjC4UTJeA6ygdye8qqapSNULDYoRK
         kIR2sc4aLyOKDDpDwKQXG5Oepkj5A0/f5CzFw7g814G4ZQp+LzZEgGslFys/ykTZK/
         LXsKweYNf+BGS9x4tRmCu3D/DKSf1yu+2HVIfQzw=
Date:   Sun, 26 Feb 2023 14:13:27 -0800
To:     mm-commits@vger.kernel.org, will@kernel.org,
        torvalds@linux-foundation.org, riel@redhat.com,
        peterz@infradead.org, nadav.amit@gmail.com, mpe@ellerman.id.au,
        luto@kernel.org, dave.hansen@linux.intel.com,
        christophe.leroy@csgroup.eu, catalin.marinas@arm.com,
        npiggin@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kthread-simplify-kthread_use_mm-refcounting.patch added to mm-unstable branch
Message-Id: <20230226221327.B83F8C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kthread: simplify kthread_use_mm refcounting
has been added to the -mm mm-unstable branch.  Its filename is
     kthread-simplify-kthread_use_mm-refcounting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kthread-simplify-kthread_use_mm-refcounting.patch

This patch will later appear in the mm-unstable branch at
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


diff --git a/kernel/kthread.c~kthread-simplify-kthread_use_mm-refcounting b/kernel/kthread.c
--- a/kernel/kthread.c~kthread-simplify-kthread_use_mm-refcounting
+++ b/kernel/kthread.c
@@ -1415,14 +1415,13 @@ void kthread_use_mm(struct mm_struct *mm)
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
@@ -1439,12 +1438,9 @@ void kthread_use_mm(struct mm_struct *mm)
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

kthread-simplify-kthread_use_mm-refcounting.patch
lazy-tlb-introduce-lazy-tlb-mm-refcount-helper-functions.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable.patch
lazy-tlb-shoot-lazies-non-refcounting-lazy-tlb-mm-reference-handling-scheme.patch
powerpc-64s-enable-mmu_lazy_tlb_shootdown.patch

