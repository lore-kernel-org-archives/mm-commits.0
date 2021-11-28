Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FA9CC433F5
	for <mm-commits@archiver.kernel.org>; Sun, 28 Nov 2021 00:58:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbhK1BBo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 27 Nov 2021 20:01:44 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59668 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231200AbhK1A7o (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 27 Nov 2021 19:59:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E590B80916
        for <mm-commits@vger.kernel.org>; Sun, 28 Nov 2021 00:56:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4433BC53FAD;
        Sun, 28 Nov 2021 00:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638060987;
        bh=0f+5LeohkE1sXiKVycDCCJ/tsNOBkkvATuPk0RrLkn8=;
        h=Date:From:To:Subject:From;
        b=KGo5lidGVn4PXv7lFrJ1K0eTdUeIj59lUnYwrpHox/heG3r1ieLpI4J39xBHsSAoL
         ThCzGy1A5Tah8s3Ixxhb6HgdyTMrMqg80LwbuA0e9LkZeqgIZKusU2sFnJpm8GKVV1
         +9cw2BxH6ZpIfpEa4vptzc9SHWJiTyEkjH8b18mw=
Date:   Sat, 27 Nov 2021 16:56:25 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, christian.brauner@ubuntu.com,
        christian@brauner.io, david@redhat.com, fweimer@redhat.com,
        guro@fb.com, hannes@cmpxchg.org, hch@infradead.org,
        jannh@google.com, jengelh@inai.de, kirill@shutemov.name,
        luto@kernel.org, mhocko@suse.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, oleg@redhat.com, riel@surriel.com,
        rientjes@google.com, shakeelb@google.com, surenb@google.com,
        timmurray@google.com, willy@infradead.org
Subject:  +
 mm-protect-free_pgtables-with-mmap_lock-write-lock-in-exit_mmap.patch added
 to -mm tree
Message-ID: <20211128005625.WH9_z8Vw0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: protect free_pgtables with mmap_lock write lock in exit_mmap
has been added to the -mm tree.  Its filename is
     mm-protect-free_pgtables-with-mmap_lock-write-lock-in-exit_mmap.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-protect-free_pgtables-with-mmap_lock-write-lock-in-exit_mmap.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-protect-free_pgtables-with-mmap_lock-write-lock-in-exit_mmap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: protect free_pgtables with mmap_lock write lock in exit_mmap

oom-reaper and process_mrelease system call should protect against races
with exit_mmap which can destroy page tables while they walk the VMA tree.
oom-reaper protects from that race by setting MMF_OOM_VICTIM and by
relying on exit_mmap to set MMF_OOM_SKIP before taking and releasing
mmap_write_lock.  process_mrelease has to elevate mm->mm_users to prevent
such race.  Both oom-reaper and process_mrelease hold mmap_read_lock when
walking the VMA tree.  The locking rules and mechanisms could be simpler
if exit_mmap takes mmap_write_lock while executing destructive operations
such as free_pgtables.

Change exit_mmap to hold the mmap_write_lock when calling free_pgtables. 
Operations like unmap_vmas() and unlock_range() are not destructive and
could run under mmap_read_lock but for simplicity we take one
mmap_write_lock during almost the entire operation.  Note also that
because oom-reaper checks VM_LOCKED flag, unlock_range() should not be
allowed to race with it.

In most cases this lock should be uncontended.  Previously, Kirill
reported ~4% regression caused by a similar change [1].  We reran the same
test and although the individual results are quite noisy, the percentiles
show lower regression with 1.6% being the worst case [2].  The change
allows oom-reaper and process_mrelease to execute safely under
mmap_read_lock without worries that exit_mmap might destroy page tables
from under them.

[1] https://lore.kernel.org/all/20170725141723.ivukwhddk2voyhuc@node.shutemov.name/
[2] https://lore.kernel.org/all/CAJuCfpGC9-c9P40x7oy=jy5SphMcd0o0G_6U1-+JAziGKG6dGA@mail.gmail.com/

Link: https://lkml.kernel.org/r/20211124235906.14437-1-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Christian Brauner <christian@brauner.io>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: Jan Engelhardt <jengelh@inai.de>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill Shutemov <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tim Murray <timmurray@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/mmap.c~mm-protect-free_pgtables-with-mmap_lock-write-lock-in-exit_mmap
+++ a/mm/mmap.c
@@ -3148,25 +3148,27 @@ void exit_mmap(struct mm_struct *mm)
 		 * to mmu_notifier_release(mm) ensures mmu notifier callbacks in
 		 * __oom_reap_task_mm() will not block.
 		 *
-		 * This needs to be done before calling munlock_vma_pages_all(),
+		 * This needs to be done before calling unlock_range(),
 		 * which clears VM_LOCKED, otherwise the oom reaper cannot
 		 * reliably test it.
 		 */
 		(void)__oom_reap_task_mm(mm);
 
 		set_bit(MMF_OOM_SKIP, &mm->flags);
-		mmap_write_lock(mm);
-		mmap_write_unlock(mm);
 	}
 
+	mmap_write_lock(mm);
 	if (mm->locked_vm)
 		unlock_range(mm->mmap, ULONG_MAX);
 
 	arch_exit_mmap(mm);
 
 	vma = mm->mmap;
-	if (!vma)	/* Can happen if dup_mmap() received an OOM */
+	if (!vma) {
+		/* Can happen if dup_mmap() received an OOM */
+		mmap_write_unlock(mm);
 		return;
+	}
 
 	lru_add_drain();
 	flush_cache_mm(mm);
@@ -3177,16 +3179,14 @@ void exit_mmap(struct mm_struct *mm)
 	free_pgtables(&tlb, vma, FIRST_USER_ADDRESS, USER_PGTABLES_CEILING);
 	tlb_finish_mmu(&tlb);
 
-	/*
-	 * Walk the list again, actually closing and freeing it,
-	 * with preemption enabled, without holding any MM locks.
-	 */
+	/* Walk the list again, actually closing and freeing it. */
 	while (vma) {
 		if (vma->vm_flags & VM_ACCOUNT)
 			nr_accounted += vma_pages(vma);
 		vma = remove_vma(vma);
 		cond_resched();
 	}
+	mmap_write_unlock(mm);
 	vm_unacct_memory(nr_accounted);
 }
 
_

Patches currently in -mm which might be from surenb@google.com are

mm-add-a-field-to-store-names-for-private-anonymous-memory-fix.patch
mm-add-anonymous-vma-name-refcounting.patch
mm-protect-free_pgtables-with-mmap_lock-write-lock-in-exit_mmap.patch
mm-oom_kill-allow-process_mrelease-to-run-under-mmap_lock-protection.patch
sysctl-change-watermark_scale_factor-max-limit-to-30%.patch

