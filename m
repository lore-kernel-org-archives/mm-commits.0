Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17D13C7619A
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:57:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjDFC5H (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235135AbjDFC4v (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:56:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B56FA
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:56:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7ECEA64126
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:56:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2430C433EF;
        Thu,  6 Apr 2023 02:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749807;
        bh=LffhJbyr7QbxjHlK2TtLTLXOBl2lyAsxdDMUMdIdXTY=;
        h=Date:To:From:Subject:From;
        b=1xD7d6BMoP6HBvO1cm/xlB9Ogxs98hxYouwqYHRxj+f+gV/QlTKUDLwOH4GVnl6Or
         hwhGDRbpJdOGRg5EEXYqyT6hpUoJlDIsEMwxD0L4xxBtpQ0Bad1votk5bAw9YMg18J
         OeVSJzdHZQpdfZe+XeBWTeS193Q9ooHf7vwTRzfg=
Date:   Wed, 05 Apr 2023 19:56:47 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        syzbot+8955a9646d1a48b8be92@syzkaller.appspotmail.com,
        songliubraving@fb.com, shakeelb@google.com, rppt@kernel.org,
        punit.agrawal@bytedance.com, posk@google.com, peterx@redhat.com,
        michel@lespinasse.org, mhocko@suse.com,
        mgorman@techsingularity.net, lstoakes@gmail.com,
        Liam.Howlett@oracle.com, jannh@google.com, hughd@google.com,
        hannes@cmpxchg.org, gthelen@google.com, dhowells@redhat.com,
        david@redhat.com, dave@stgolabs.net, bigeasy@linutronix.de,
        arjunroy@google.com, surenb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-khugepaged-write-lock-vma-while-collapsing-a-huge-page-fix.patch removed from -mm tree
Message-Id: <20230406025647.C2430C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/khugepaged: fix vm_lock/i_mmap_rwsem inversion in retract_page_tables
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-write-lock-vma-while-collapsing-a-huge-page-fix.patch

This patch was dropped because it was folded into mm-khugepaged-write-lock-vma-while-collapsing-a-huge-page.patch

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm/khugepaged: fix vm_lock/i_mmap_rwsem inversion in retract_page_tables
Date: Fri, 3 Mar 2023 13:32:50 -0800

Internal syscaller on linux-next reported a lock inversion cause by
vm_lock being taken after i_mmap_rwsem:

======================================================
WARNING: possible circular locking dependency detected
6.2.0-next-20230301-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor115/5084 is trying to acquire lock:
ffff888078307a90 (&vma->vm_lock->lock){++++}-{3:3}, at: vma_start_write include/linux/mm.h:678 [inline]
ffff888078307a90 (&vma->vm_lock->lock){++++}-{3:3}, at: retract_page_tables mm/khugepaged.c:1826 [inline]
ffff888078307a90 (&vma->vm_lock->lock){++++}-{3:3}, at: collapse_file+0x4fa5/0x5980 mm/khugepaged.c:2204

but task is already holding lock:
ffff88801f93efa8 (&mapping->i_mmap_rwsem){++++}-{3:3}, at: i_mmap_lock_write include/linux/fs.h:468 [inline]
ffff88801f93efa8 (&mapping->i_mmap_rwsem){++++}-{3:3}, at: retract_page_tables mm/khugepaged.c:1745 [inline]
ffff88801f93efa8 (&mapping->i_mmap_rwsem){++++}-{3:3}, at: collapse_file+0x3da6/0x5980 mm/khugepaged.c:2204

retract_page_tables takes i_mmap_rwsem before exclusive mmap_lock, which
is inverse to normal order.  Deadlock is avoided by try-locking mmap_lock
and skipping on failure to obtain it.  Locking the VMA should use the same
locking pattern to avoid this lock inversion.

Link: https://lkml.kernel.org/r/20230303213250.3555716-1-surenb@google.com
Fixes: 44a83f2083bd ("mm/khugepaged: write-lock VMA while collapsing a huge page")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: <syzbot+8955a9646d1a48b8be92@syzkaller.appspotmail.com>
Cc: Arjun Roy <arjunroy@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Greg Thelen <gthelen@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: kernel-team@android.com
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michel Lespinasse <michel@lespinasse.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Oskolkov <posk@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Punit Agrawal <punit.agrawal@bytedance.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   39 ++++++++++++++++++++++++++++-----------
 mm/khugepaged.c    |    5 ++++-
 2 files changed, 32 insertions(+), 12 deletions(-)

--- a/include/linux/mm.h~mm-khugepaged-write-lock-vma-while-collapsing-a-huge-page-fix
+++ a/include/linux/mm.h
@@ -664,18 +664,23 @@ static inline void vma_end_read(struct v
 	rcu_read_unlock();
 }
 
-static inline void vma_start_write(struct vm_area_struct *vma)
+static bool __is_vma_write_locked(struct vm_area_struct *vma, int *mm_lock_seq)
 {
-	int mm_lock_seq;
-
 	mmap_assert_write_locked(vma->vm_mm);
 
 	/*
 	 * current task is holding mmap_write_lock, both vma->vm_lock_seq and
 	 * mm->mm_lock_seq can't be concurrently modified.
 	 */
-	mm_lock_seq = READ_ONCE(vma->vm_mm->mm_lock_seq);
-	if (vma->vm_lock_seq == mm_lock_seq)
+	*mm_lock_seq = READ_ONCE(vma->vm_mm->mm_lock_seq);
+	return (vma->vm_lock_seq == *mm_lock_seq);
+}
+
+static inline void vma_start_write(struct vm_area_struct *vma)
+{
+	int mm_lock_seq;
+
+	if (__is_vma_write_locked(vma, &mm_lock_seq))
 		return;
 
 	down_write(&vma->lock);
@@ -683,14 +688,26 @@ static inline void vma_start_write(struc
 	up_write(&vma->lock);
 }
 
+static inline bool vma_try_start_write(struct vm_area_struct *vma)
+{
+	int mm_lock_seq;
+
+	if (__is_vma_write_locked(vma, &mm_lock_seq))
+		return true;
+
+	if (!down_write_trylock(&vma->vm_lock->lock))
+		return false;
+
+	vma->vm_lock_seq = mm_lock_seq;
+	up_write(&vma->vm_lock->lock);
+	return true;
+}
+
 static inline void vma_assert_write_locked(struct vm_area_struct *vma)
 {
-	mmap_assert_write_locked(vma->vm_mm);
-	/*
-	 * current task is holding mmap_write_lock, both vma->vm_lock_seq and
-	 * mm->mm_lock_seq can't be concurrently modified.
-	 */
-	VM_BUG_ON_VMA(vma->vm_lock_seq != READ_ONCE(vma->vm_mm->mm_lock_seq), vma);
+	int mm_lock_seq;
+
+	VM_BUG_ON_VMA(!__is_vma_write_locked(vma, &mm_lock_seq), vma);
 }
 
 #else /* CONFIG_PER_VMA_LOCK */
--- a/mm/khugepaged.c~mm-khugepaged-write-lock-vma-while-collapsing-a-huge-page-fix
+++ a/mm/khugepaged.c
@@ -1703,6 +1703,10 @@ static int retract_page_tables(struct ad
 		result = SCAN_PTE_MAPPED_HUGEPAGE;
 		if ((cc->is_khugepaged || is_target) &&
 		    mmap_write_trylock(mm)) {
+			/* trylock for the same lock inversion as above */
+			if (!vma_try_start_write(vma))
+				goto unlock_next;
+
 			/*
 			 * Re-check whether we have an ->anon_vma, because
 			 * collapse_and_free_pmd() requires that either no
@@ -1731,7 +1735,6 @@ static int retract_page_tables(struct ad
 				result = SCAN_PTE_UFFD_WP;
 				goto unlock_next;
 			}
-			vma_start_write(vma);
 			collapse_and_free_pmd(mm, vma, addr, pmd);
 			if (!cc->is_khugepaged && is_target)
 				result = set_huge_pmd(vma, addr, pmd, hpage);
_

Patches currently in -mm which might be from surenb@google.com are

mm-introduce-config_per_vma_lock.patch
mm-move-mmap_lock-assert-function-definitions.patch
mm-add-per-vma-lock-and-helper-functions-to-control-it.patch
mm-mark-vma-as-being-written-when-changing-vm_flags.patch
mm-mmap-move-vma_prepare-before-vma_adjust_trans_huge.patch
mm-khugepaged-write-lock-vma-while-collapsing-a-huge-page.patch
mm-khugepaged-write-lock-vma-while-collapsing-a-huge-page-fix-fix.patch
mm-mmap-write-lock-vmas-in-vma_prepare-before-modifying-them.patch
mm-mmap-write-lock-vmas-in-vma_prepare-before-modifying-them-fix.patch
mm-mremap-write-lock-vma-while-remapping-it-to-a-new-address-range.patch
mm-write-lock-vmas-before-removing-them-from-vma-tree.patch
mm-write-lock-vmas-before-removing-them-from-vma-tree-fix.patch
mm-conditionally-write-lock-vma-in-free_pgtables.patch
kernel-fork-assert-no-vma-readers-during-its-destruction.patch
mm-mmap-prevent-pagefault-handler-from-racing-with-mmu_notifier-registration.patch
mm-introduce-vma-detached-flag.patch
mm-introduce-lock_vma_under_rcu-to-be-used-from-arch-specific-code.patch
mm-fall-back-to-mmap_lock-if-vma-anon_vma-is-not-yet-set.patch
mm-add-fault_flag_vma_lock-flag.patch
mm-add-fault_flag_vma_lock-flag-fix.patch
mm-prevent-do_swap_page-from-handling-page-faults-under-vma-lock.patch
mm-prevent-userfaults-to-be-handled-under-per-vma-lock.patch
mm-introduce-per-vma-lock-statistics.patch
x86-mm-try-vma-lock-based-page-fault-handling-first.patch
arm64-mm-try-vma-lock-based-page-fault-handling-first.patch
mm-mmap-free-vm_area_struct-without-call_rcu-in-exit_mmap.patch
mm-separate-vma-lock-from-vm_area_struct.patch

