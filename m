Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2E48C43334
	for <mm-commits@archiver.kernel.org>; Wed,  1 Jun 2022 21:37:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbiFAVhy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Jun 2022 17:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231578AbiFAVhx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jun 2022 17:37:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 036CF6397
        for <mm-commits@vger.kernel.org>; Wed,  1 Jun 2022 14:37:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D5E76136C
        for <mm-commits@vger.kernel.org>; Wed,  1 Jun 2022 21:37:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF1DC385A5;
        Wed,  1 Jun 2022 21:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654119469;
        bh=z1xgqRaI3O8rWLwzXUphQM9PUhXfd2W8bmrZ7F2lPlk=;
        h=Date:To:From:Subject:From;
        b=iE6k16P+QC0ufnGQudHRcETW2/aLaFaLtnsE4ke9vLj7TTwPtbVqsAlCfGE97JJPW
         eu0ietuhJBZncZ13vpajItvYCIIvNqUdMCSqZAV4Nh4/qP6l1rFya7IBNtdicC/tqZ
         hxo4VzbIY1GEL1S/Ak8OU0YtpF1grfYu4r4sznjw=
Date:   Wed, 01 Jun 2022 14:37:48 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, shuah@kernel.org,
        shakeelb@google.com, rientjes@google.com, peterx@redhat.com,
        oleg@redhat.com, minchan@kernel.org, mhocko@suse.com,
        liam.howlett@oracle.com, kirill@shutemov.name, jhubbard@nvidia.com,
        jannh@google.com, hch@infradead.org, hannes@cmpxchg.org,
        guro@fb.com, david@redhat.com, brauner@kernel.org,
        aarcange@redhat.com, surenb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-drop-oom-code-from-exit_mmap.patch added to mm-unstable branch
Message-Id: <20220601213748.DAF1DC385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: drop oom code from exit_mmap
has been added to the -mm mm-unstable branch.  Its filename is
     mm-drop-oom-code-from-exit_mmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-drop-oom-code-from-exit_mmap.patch

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
 mm/mmap.c           |   24 +++++++-----------------
 mm/oom_kill.c       |    2 +-
 3 files changed, 8 insertions(+), 20 deletions(-)

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
@@ -3171,23 +3171,6 @@ void exit_mmap(struct mm_struct *mm)
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
 	mmap_write_lock(mm);
 	arch_exit_mmap(mm);
 
@@ -3204,6 +3187,13 @@ void exit_mmap(struct mm_struct *mm)
 	/* update_hiwater_rss(mm) here? but nobody should be looking */
 	/* Use ULONG_MAX here to ensure all VMAs in the mm are unmapped */
 	unmap_vmas(&tlb, &mm->mm_mt, vma, 0, ULONG_MAX);
+
+	/*
+	 * Set MMF_OOM_SKIP to hide this task from the oom killer/reaper
+	 * because the memory has been already freed. Do not bother checking
+	 * mm_is_oom_victim because setting a bit unconditionally is cheaper.
+	 */
+	set_bit(MMF_OOM_SKIP, &mm->flags);
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

mm-drop-oom-code-from-exit_mmap.patch
mm-delete-unused-mmf_oom_victim-flag.patch

