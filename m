From: akpm@linux-foundation.org
Subject: [merged] mm-mmap-annotate-vm_lock_anon_vma-locking-properly-for-lockdep.patch removed from -mm tree
Date: Mon, 14 Jan 2013 12:38:46 -0800
Message-ID: <20130114203847.7F2D720004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:36959 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758758Ab3ANUiv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Jan 2013 15:38:51 -0500
Received: by mail-lb0-f202.google.com with SMTP id s4so293813lbc.5
        for <mm-commits@vger.kernel.org>; Mon, 14 Jan 2013 12:38:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkosina@suse.cz, a.p.zijlstra@chello.nl, mel@csn.ul.ie, mingo@kernel.org, riel@redhat.com, sedat.dilek@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mmap: annotate vm_lock_anon_vma locking properly for lockdep
has been removed from the -mm tree.  Its filename was
     mm-mmap-annotate-vm_lock_anon_vma-locking-properly-for-lockdep.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiri Kosina <jkosina@suse.cz>
Subject: mm: mmap: annotate vm_lock_anon_vma locking properly for lockdep

Commit 5a505085f04 ("mm/rmap: Convert the struct anon_vma::mutex to an
rwsem") turned anon_vma mutex to rwsem.

However, the properly annotated nested locking in mm_take_all_locks() has
been converted from

	mutex_lock_nest_lock(&anon_vma->root->mutex, &mm->mmap_sem);

to

	down_write(&anon_vma->root->rwsem);

which is incomplete, and causes the false positive report from lockdep below.

Annotate the fact that mmap_sem is used as an outter lock to serialize
taking of all the anon_vma rwsems at once no matter the order, using the
down_write_nest_lock() primitive.

This patch fixes this lockdep report:

 =============================================
 [ INFO: possible recursive locking detected ]
 3.8.0-rc2-00036-g5f73896 #171 Not tainted
 ---------------------------------------------
 qemu-kvm/2315 is trying to acquire lock:
  (&anon_vma->rwsem){+.+...}, at: [<ffffffff8115d549>] mm_take_all_locks+0x149/0x1b0

 but task is already holding lock:
  (&anon_vma->rwsem){+.+...}, at: [<ffffffff8115d549>] mm_take_all_locks+0x149/0x1b0

 other info that might help us debug this:
  Possible unsafe locking scenario:

        CPU0
        ----
   lock(&anon_vma->rwsem);
   lock(&anon_vma->rwsem);

  *** DEADLOCK ***

  May be due to missing lock nesting notation

 4 locks held by qemu-kvm/2315:
  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff81177f1c>] do_mmu_notifier_register+0xfc/0x170
  #1:  (mm_all_locks_mutex){+.+...}, at: [<ffffffff8115d436>] mm_take_all_locks+0x36/0x1b0
  #2:  (&mapping->i_mmap_mutex){+.+...}, at: [<ffffffff8115d4c9>] mm_take_all_locks+0xc9/0x1b0
  #3:  (&anon_vma->rwsem){+.+...}, at: [<ffffffff8115d549>] mm_take_all_locks+0x149/0x1b0

 stack backtrace:
 Pid: 2315, comm: qemu-kvm Not tainted 3.8.0-rc2-00036-g5f73896 #171
 Call Trace:
  [<ffffffff810afea2>] print_deadlock_bug+0xf2/0x100
  [<ffffffff810b1a76>] validate_chain+0x4f6/0x720
  [<ffffffff810b1ff9>] __lock_acquire+0x359/0x580
  [<ffffffff810b0e7d>] ? trace_hardirqs_on_caller+0x12d/0x1b0
  [<ffffffff810b2341>] lock_acquire+0x121/0x190
  [<ffffffff8115d549>] ? mm_take_all_locks+0x149/0x1b0
  [<ffffffff815a12bf>] down_write+0x3f/0x70
  [<ffffffff8115d549>] ? mm_take_all_locks+0x149/0x1b0
  [<ffffffff8115d549>] mm_take_all_locks+0x149/0x1b0
  [<ffffffff81177e88>] do_mmu_notifier_register+0x68/0x170
  [<ffffffff81177fae>] mmu_notifier_register+0xe/0x10
  [<ffffffffa04bd6ab>] kvm_create_vm+0x22b/0x330 [kvm]
  [<ffffffffa04bd8a8>] kvm_dev_ioctl+0xf8/0x1a0 [kvm]
  [<ffffffff811a45bd>] do_vfs_ioctl+0x9d/0x350
  [<ffffffff815ad215>] ? sysret_check+0x22/0x5d
  [<ffffffff811a4901>] sys_ioctl+0x91/0xb0
  [<ffffffff815ad1e9>] system_call_fastpath+0x16/0x1b

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mel Gorman <mel@csn.ul.ie>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mmap.c~mm-mmap-annotate-vm_lock_anon_vma-locking-properly-for-lockdep mm/mmap.c
--- a/mm/mmap.c~mm-mmap-annotate-vm_lock_anon_vma-locking-properly-for-lockdep
+++ a/mm/mmap.c
@@ -2886,7 +2886,7 @@ static void vm_lock_anon_vma(struct mm_s
 		 * The LSB of head.next can't change from under us
 		 * because we hold the mm_all_locks_mutex.
 		 */
-		down_write(&anon_vma->root->rwsem);
+		down_write_nest_lock(&anon_vma->root->rwsem, &mm->mmap_sem);
 		/*
 		 * We can safely modify head.next after taking the
 		 * anon_vma->root->rwsem. If some other vma in this mm shares
_

Patches currently in -mm which might be from jkosina@suse.cz are

origin.patch
linux-next.patch

