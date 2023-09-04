Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 739B7C83F2C
	for <mm-commits@archiver.kernel.org>; Mon,  4 Sep 2023 00:03:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348800AbjIDADZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Sep 2023 20:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231361AbjIDADY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Sep 2023 20:03:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 425C9C4
        for <mm-commits@vger.kernel.org>; Sun,  3 Sep 2023 17:03:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8597B80D6E
        for <mm-commits@vger.kernel.org>; Mon,  4 Sep 2023 00:03:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7814DC433C7;
        Mon,  4 Sep 2023 00:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693785798;
        bh=fCuYpMF2QKyAtarwmVVx0dpCGg5R16RZK3lotMVmmLg=;
        h=Date:To:From:Subject:From;
        b=PKw8sDMkRYgbaCDzcsYXLyE129a+76q7+804KniJYgWxm8Vu5acpEzNd+dMg1/0O9
         vpzHjXc+wBqgNWTVNuAtO5kkm6Sj+qFYXwUK+2bosB6LmXlL9L8x6Gp81pSYXzNdlh
         iotOnK6eMlPEaBRwror6YyZ2WPgyeaYIddlwOQ/M=
Date:   Sun, 03 Sep 2023 17:03:16 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com, mjguzik@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-remnants-of-split_rss_counting.patch added to mm-unstable branch
Message-Id: <20230904000318.7814DC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove remnants of SPLIT_RSS_COUNTING
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-remnants-of-split_rss_counting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-remnants-of-split_rss_counting.patch

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
From: Mateusz Guzik <mjguzik@gmail.com>
Subject: mm: remove remnants of SPLIT_RSS_COUNTING
Date: Wed, 23 Aug 2023 19:05:56 +0200

The feature got retired in f1a7941243c1 ("mm: convert mm's rss stats into
percpu_counter"), but the patch failed to fully clean it up.

Link: https://lkml.kernel.org/r/20230823170556.2281747-1-mjguzik@gmail.com
Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c          |    2 --
 include/linux/mm.h |    8 --------
 kernel/exit.c      |    4 ----
 kernel/fork.c      |    4 ----
 kernel/kthread.c   |    1 -
 mm/madvise.c       |    5 +----
 mm/memory.c        |    2 --
 7 files changed, 1 insertion(+), 25 deletions(-)

--- a/fs/exec.c~mm-remove-remnants-of-split_rss_counting
+++ a/fs/exec.c
@@ -986,8 +986,6 @@ static int exec_mmap(struct mm_struct *m
 	tsk = current;
 	old_mm = current->mm;
 	exec_mm_release(tsk, old_mm);
-	if (old_mm)
-		sync_mm_rss(old_mm);
 
 	ret = down_write_killable(&tsk->signal->exec_update_lock);
 	if (ret)
--- a/include/linux/mm.h~mm-remove-remnants-of-split_rss_counting
+++ a/include/linux/mm.h
@@ -2609,14 +2609,6 @@ static inline void setmax_mm_hiwater_rss
 		*maxrss = hiwater_rss;
 }
 
-#if defined(SPLIT_RSS_COUNTING)
-void sync_mm_rss(struct mm_struct *mm);
-#else
-static inline void sync_mm_rss(struct mm_struct *mm)
-{
-}
-#endif
-
 #ifndef CONFIG_ARCH_HAS_PTE_SPECIAL
 static inline int pte_special(pte_t pte)
 {
--- a/kernel/exit.c~mm-remove-remnants-of-split_rss_counting
+++ a/kernel/exit.c
@@ -539,7 +539,6 @@ static void exit_mm(void)
 	exit_mm_release(current, mm);
 	if (!mm)
 		return;
-	sync_mm_rss(mm);
 	mmap_read_lock(mm);
 	mmgrab_lazy_tlb(mm);
 	BUG_ON(mm != current->active_mm);
@@ -829,9 +828,6 @@ void __noreturn do_exit(long code)
 	io_uring_files_cancel();
 	exit_signals(tsk);  /* sets PF_EXITING */
 
-	/* sync mm's RSS info before statistics gathering */
-	if (tsk->mm)
-		sync_mm_rss(tsk->mm);
 	acct_update_integrals(tsk);
 	group_dead = atomic_dec_and_test(&tsk->signal->live);
 	if (group_dead) {
--- a/kernel/fork.c~mm-remove-remnants-of-split_rss_counting
+++ a/kernel/fork.c
@@ -2409,10 +2409,6 @@ __latent_entropy struct task_struct *cop
 	p->io_uring = NULL;
 #endif
 
-#if defined(SPLIT_RSS_COUNTING)
-	memset(&p->rss_stat, 0, sizeof(p->rss_stat));
-#endif
-
 	p->default_timer_slack_ns = current->timer_slack_ns;
 
 #ifdef CONFIG_PSI
--- a/kernel/kthread.c~mm-remove-remnants-of-split_rss_counting
+++ a/kernel/kthread.c
@@ -1470,7 +1470,6 @@ void kthread_unuse_mm(struct mm_struct *
 	 * clearing tsk->mm.
 	 */
 	smp_mb__after_spinlock();
-	sync_mm_rss(mm);
 	local_irq_disable();
 	tsk->mm = NULL;
 	membarrier_update_current_mm(NULL);
--- a/mm/madvise.c~mm-remove-remnants-of-split_rss_counting
+++ a/mm/madvise.c
@@ -746,11 +746,8 @@ static int madvise_free_pte_range(pmd_t
 		folio_mark_lazyfree(folio);
 	}
 
-	if (nr_swap) {
-		if (current->mm == mm)
-			sync_mm_rss(mm);
+	if (nr_swap)
 		add_mm_counter(mm, MM_SWAPENTS, nr_swap);
-	}
 	if (start_pte) {
 		arch_leave_lazy_mmu_mode();
 		pte_unmap_unlock(start_pte, ptl);
--- a/mm/memory.c~mm-remove-remnants-of-split_rss_counting
+++ a/mm/memory.c
@@ -471,8 +471,6 @@ static inline void add_mm_rss_vec(struct
 {
 	int i;
 
-	if (current->mm == mm)
-		sync_mm_rss(mm);
 	for (i = 0; i < NR_MM_COUNTERS; i++)
 		if (rss[i])
 			add_mm_counter(mm, i, rss[i]);
_

Patches currently in -mm which might be from mjguzik@gmail.com are

mm-remove-remnants-of-split_rss_counting.patch

