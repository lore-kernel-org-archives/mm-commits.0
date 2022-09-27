Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9110C32771
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:55:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbiI0Czv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbiI0CzJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:55:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE9A1CFDF
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:50:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9959B6153F
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:50:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFEF8C433D6;
        Tue, 27 Sep 2022 02:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664247007;
        bh=44E1tl0oVOp/wWADEya628feaRhDc6ASKD/zFwbPNFc=;
        h=Date:To:From:Subject:From;
        b=LlHxqGICbEUBXtYe3GgT8sQAPBfTJi3nuVqvaMxxP5cFvvdvXev+b1UtBTKDelbhY
         lpVNi3zHfIm5LztilEKnE7COSfS2vrqhjECFCdglwv1ycZwMz0mukX1cK4OEAaWx4e
         C+g3Ax+HR27pFYpnIid4qTC7gsSpBMC4D3f7Rtu0=
Date:   Mon, 26 Sep 2022 19:50:06 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, shuah@kernel.org,
        shakeelb@google.com, rientjes@google.com, peterx@redhat.com,
        oleg@redhat.com, minchan@kernel.org, mhocko@suse.com,
        liam.howlett@oracle.com, kirill@shutemov.name, jhubbard@nvidia.com,
        jannh@google.com, hch@infradead.org, hannes@cmpxchg.org,
        guro@fb.com, david@redhat.com, brauner@kernel.org,
        aarcange@redhat.com, surenb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-drop-oom-code-from-exit_mmap.patch removed from -mm tree
Message-Id: <20220927025006.EFEF8C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: drop oom code from exit_mmap
has been removed from the -mm tree.  Its filename was
     mm-drop-oom-code-from-exit_mmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: drop oom code from exit_mmap
Date: Tue, 31 May 2022 15:30:59 -0700

The primary reason to invoke the oom reaper from the exit_mmap path used
to be a prevention of an excessive oom killing if the oom victim exit
races with the oom reaper (see [1] for more details).  The invocation has
moved around since then because of the interaction with the munlock logic
but the underlying reason has remained the same (see [2]).

Munlock code is no longer a problem since [3] and there shouldn't be any
blocking operation before the memory is unmapped by exit_mmap so the oom
reaper invocation can be dropped.  The unmapping part can be done with the
non-exclusive mmap_sem and the exclusive one is only required when page
tables are freed.

Remove the oom_reaper from exit_mmap which will make the code easier to
read.  This is really unlikely to make any observable difference although
some microbenchmarks could benefit from one less branch that needs to be
evaluated even though it almost never is true.

[1] 212925802454 ("mm: oom: let oom_reap_task and exit_mmap run concurrently")
[2] 27ae357fa82b ("mm, oom: fix concurrent munlock and oom reaper unmap, v3")
[3] a213e5cf71cb ("mm/munlock: delete munlock_vma_pages_all(), allow oomreap")

[akpm@linux-foundation.org: restore Suren's mmap_read_lock() optimization]
Link: https://lkml.kernel.org/r/20220531223100.510392-1-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christian Brauner (Microsoft) <brauner@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/oom.h |    2 --
 mm/mmap.c           |   30 +++++++++++-------------------
 mm/oom_kill.c       |    2 +-
 3 files changed, 12 insertions(+), 22 deletions(-)

--- a/include/linux/oom.h~mm-drop-oom-code-from-exit_mmap
+++ a/include/linux/oom.h
@@ -106,8 +106,6 @@ static inline vm_fault_t check_stable_ad
 	return 0;
 }
 
-bool __oom_reap_task_mm(struct mm_struct *mm);
-
 long oom_badness(struct task_struct *p,
 		unsigned long totalpages);
 
--- a/mm/mmap.c~mm-drop-oom-code-from-exit_mmap
+++ a/mm/mmap.c
@@ -3085,30 +3085,13 @@ void exit_mmap(struct mm_struct *mm)
 	/* mm's last user has gone, and its about to be pulled down */
 	mmu_notifier_release(mm);
 
-	if (unlikely(mm_is_oom_victim(mm))) {
-		/*
-		 * Manually reap the mm to free as much memory as possible.
-		 * Then, as the oom reaper does, set MMF_OOM_SKIP to disregard
-		 * this mm from further consideration.  Taking mm->mmap_lock for
-		 * write after setting MMF_OOM_SKIP will guarantee that the oom
-		 * reaper will not run on this mm again after mmap_lock is
-		 * dropped.
-		 *
-		 * Nothing can be holding mm->mmap_lock here and the above call
-		 * to mmu_notifier_release(mm) ensures mmu notifier callbacks in
-		 * __oom_reap_task_mm() will not block.
-		 */
-		(void)__oom_reap_task_mm(mm);
-		set_bit(MMF_OOM_SKIP, &mm->flags);
-	}
-
-	mmap_write_lock(mm);
+	mmap_read_lock(mm);
 	arch_exit_mmap(mm);
 
 	vma = mas_find(&mas, ULONG_MAX);
 	if (!vma) {
 		/* Can happen if dup_mmap() received an OOM */
-		mmap_write_unlock(mm);
+		mmap_read_unlock(mm);
 		return;
 	}
 
@@ -3118,6 +3101,15 @@ void exit_mmap(struct mm_struct *mm)
 	/* update_hiwater_rss(mm) here? but nobody should be looking */
 	/* Use ULONG_MAX here to ensure all VMAs in the mm are unmapped */
 	unmap_vmas(&tlb, &mm->mm_mt, vma, 0, ULONG_MAX);
+	mmap_read_unlock(mm);
+
+	/*
+	 * Set MMF_OOM_SKIP to hide this task from the oom killer/reaper
+	 * because the memory has been already freed. Do not bother checking
+	 * mm_is_oom_victim because setting a bit unconditionally is cheaper.
+	 */
+	set_bit(MMF_OOM_SKIP, &mm->flags);
+	mmap_write_lock(mm);
 	free_pgtables(&tlb, &mm->mm_mt, vma, FIRST_USER_ADDRESS,
 		      USER_PGTABLES_CEILING);
 	tlb_finish_mmu(&tlb);
--- a/mm/oom_kill.c~mm-drop-oom-code-from-exit_mmap
+++ a/mm/oom_kill.c
@@ -509,7 +509,7 @@ static DECLARE_WAIT_QUEUE_HEAD(oom_reape
 static struct task_struct *oom_reaper_list;
 static DEFINE_SPINLOCK(oom_reaper_lock);
 
-bool __oom_reap_task_mm(struct mm_struct *mm)
+static bool __oom_reap_task_mm(struct mm_struct *mm)
 {
 	struct vm_area_struct *vma;
 	bool ret = true;
_

Patches currently in -mm which might be from surenb@google.com are


