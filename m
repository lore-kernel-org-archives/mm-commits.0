From: akpm@linux-foundation.org
Subject: [alternative-merged]
 mm-oom-allow-oom-reaper-to-race-with-exit_mmap.patch removed from -mm tree
Date: Tue, 15 Aug 2017 14:27:26 -0700
Message-ID: <5993673e.LlN3rJSHD8BbIbZI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43186 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752298AbdHOV12 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Aug 2017 17:27:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, andrea@kernel.org, hughd@google.com, kirill@shutemov.name, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: allow oom reaper to race with exit_mmap
has been removed from the -mm tree.  Its filename was
     mm-oom-allow-oom-reaper-to-race-with-exit_mmap.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, oom: allow oom reaper to race with exit_mmap

David has noticed that the oom killer might kill additional tasks while
the exiting oom victim hasn't terminated yet because the oom_reaper marks
the curent victim MMF_OOM_SKIP too early when mm->mm_users dropped down to
0.  The race is as follows

oom_reap_task				do_exit
					  exit_mm
  __oom_reap_task_mm
					    mmput
					      __mmput
    mmget_not_zero # fails
    						exit_mmap # frees memory
  set_bit(MMF_OOM_SKIP)

The victim is still visible to the OOM killer until it is unhashed.

Currently we try to reduce a risk of this race by taking oom_lock and wait
for out_of_memory sleep while holding the lock to give the victim some
time to exit.  This is quite suboptimal approach because there is no
guarantee the victim (especially a large one) will manage to unmap its
address space and free enough memory to the particular oom domain which
needs a memory (e.g.  a specific NUMA node).

Fix this problem by allowing __oom_reap_task_mm and __mmput path to race. 
__oom_reap_task_mm is basically MADV_DONTNEED and that is allowed to run
in parallel with other unmappers (hence the mmap_sem for read).

The only tricky part is to exclude page tables tear down and all
operations which modify the address space in the __mmput path.  exit_mmap
doesn't expect any other users so it doesn't use any locking.  Nothing
really forbids us to use mmap_sem for write, though.  In fact we are
already relying on this lock earlier in the __mmput path to synchronize
with ksm and khugepaged.

Take the exclusive mmap_sem when calling free_pgtables and destroying vmas
to sync with __oom_reap_task_mm which take the lock for read.  All other
operations can safely race with the parallel unmap.

The previous version of the patch has been posted here [1].  The original
patch has taken mmap_sem in exit_mmap unconditionally but Kirill was
worried this could have a performance impact (we should exercise the fast
path most of the time because nobody should be holding lock at that
stage).  An artificial testcase [2] has shown ~3% difference but numbers
are quite noisy [3] so it is effect is not all that clear.  Anyway I have
made the lock conditional for oom victims.

Andrea has proposed and alternative solution [4] which should be
equivalent functionally similar to {ksm,khugepaged}_exit.  I have to
confess I really don't like that approach but I can live with it if that
is a preferred way (to be honest I would like to drop the empty
down_write();up_write() from the other two callers as well).  In fact I
have asked Andrea to post his patch [5] but that hasn't happened.  I do
not think we should wait much longer and finally merge some fix.

[1] http://lkml.kernel.org/r/20170724072332.31903-1-mhocko@kernel.org
[2] http://lkml.kernel.org/r/20170725142626.GJ26723@dhcp22.suse.cz
[3] http://lkml.kernel.org/r/20170725160359.GO26723@dhcp22.suse.cz
[4] http://lkml.kernel.org/r/20170726162912.GA29716@redhat.com
[5] http://lkml.kernel.org/r/20170728062345.GA2274@dhcp22.suse.cz

Link: http://lkml.kernel.org/r/20170810081632.31265-1-mhocko@kernel.org
Fixes: 26db62f179d1 ("oom: keep mm of the killed task available")
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: David Rientjes <rientjes@google.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrea Argangeli <andrea@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c     |   16 ++++++++++++++++
 mm/oom_kill.c |   47 ++++++++---------------------------------------
 2 files changed, 24 insertions(+), 39 deletions(-)

diff -puN mm/mmap.c~mm-oom-allow-oom-reaper-to-race-with-exit_mmap mm/mmap.c
--- a/mm/mmap.c~mm-oom-allow-oom-reaper-to-race-with-exit_mmap
+++ a/mm/mmap.c
@@ -44,6 +44,7 @@
 #include <linux/userfaultfd_k.h>
 #include <linux/moduleparam.h>
 #include <linux/pkeys.h>
+#include <linux/oom.h>
 
 #include <linux/uaccess.h>
 #include <asm/cacheflush.h>
@@ -2975,6 +2976,7 @@ void exit_mmap(struct mm_struct *mm)
 	struct mmu_gather tlb;
 	struct vm_area_struct *vma;
 	unsigned long nr_accounted = 0;
+	bool locked = false;
 
 	/* mm's last user has gone, and its about to be pulled down */
 	mmu_notifier_release(mm);
@@ -3001,6 +3003,17 @@ void exit_mmap(struct mm_struct *mm)
 	/* Use -1 here to ensure all VMAs in the mm are unmapped */
 	unmap_vmas(&tlb, vma, 0, -1);
 
+	/*
+	 * oom reaper might race with exit_mmap so make sure we won't free
+	 * page tables or unmap VMAs under its feet
+	 * Please note that mark_oom_victim is always called under task_lock
+	 * with tsk->mm != NULL checked on !current tasks which synchronizes
+	 * with exit_mm and so we cannot race here.
+	 */
+	if (tsk_is_oom_victim(current)) {
+		down_write(&mm->mmap_sem);
+		locked = true;
+	}
 	free_pgtables(&tlb, vma, FIRST_USER_ADDRESS, USER_PGTABLES_CEILING);
 	tlb_finish_mmu(&tlb, 0, -1);
 
@@ -3013,7 +3026,10 @@ void exit_mmap(struct mm_struct *mm)
 			nr_accounted += vma_pages(vma);
 		vma = remove_vma(vma);
 	}
+	mm->mmap = NULL;
 	vm_unacct_memory(nr_accounted);
+	if (locked)
+		up_write(&mm->mmap_sem);
 }
 
 /* Insert vm structure into process list sorted by address
diff -puN mm/oom_kill.c~mm-oom-allow-oom-reaper-to-race-with-exit_mmap mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-allow-oom-reaper-to-race-with-exit_mmap
+++ a/mm/oom_kill.c
@@ -470,40 +470,15 @@ static bool __oom_reap_task_mm(struct ta
 {
 	struct mmu_gather tlb;
 	struct vm_area_struct *vma;
-	bool ret = true;
-
-	/*
-	 * We have to make sure to not race with the victim exit path
-	 * and cause premature new oom victim selection:
-	 * __oom_reap_task_mm		exit_mm
-	 *   mmget_not_zero
-	 *				  mmput
-	 *				    atomic_dec_and_test
-	 *				  exit_oom_victim
-	 *				[...]
-	 *				out_of_memory
-	 *				  select_bad_process
-	 *				    # no TIF_MEMDIE task selects new victim
-	 *  unmap_page_range # frees some memory
-	 */
-	mutex_lock(&oom_lock);
 
 	if (!down_read_trylock(&mm->mmap_sem)) {
-		ret = false;
 		trace_skip_task_reaping(tsk->pid);
-		goto unlock_oom;
+		return false;
 	}
 
-	/*
-	 * increase mm_users only after we know we will reap something so
-	 * that the mmput_async is called only when we have reaped something
-	 * and delayed __mmput doesn't matter that much
-	 */
-	if (!mmget_not_zero(mm)) {
-		up_read(&mm->mmap_sem);
-		trace_skip_task_reaping(tsk->pid);
-		goto unlock_oom;
-	}
+	/* There is nothing to reap so bail out without signs in the log */
+	if (!mm->mmap)
+		goto unlock;
 
 	trace_start_task_reaping(tsk->pid);
 
@@ -540,18 +515,12 @@ static bool __oom_reap_task_mm(struct ta
 			K(get_mm_counter(mm, MM_ANONPAGES)),
 			K(get_mm_counter(mm, MM_FILEPAGES)),
 			K(get_mm_counter(mm, MM_SHMEMPAGES)));
-	up_read(&mm->mmap_sem);
 
-	/*
-	 * Drop our reference but make sure the mmput slow path is called from a
-	 * different context because we shouldn't risk we get stuck there and
-	 * put the oom_reaper out of the way.
-	 */
-	mmput_async(mm);
 	trace_finish_task_reaping(tsk->pid);
-unlock_oom:
-	mutex_unlock(&oom_lock);
-	return ret;
+unlock:
+	up_read(&mm->mmap_sem);
+
+	return true;
 }
 
 #define MAX_OOM_REAP_RETRIES 10
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-memory_hotplug-display-allowed-zones-in-the-preferred-ordering.patch
mm-memory_hotplug-remove-zone-restrictions.patch
mm-page_alloc-rip-out-zonelist_order_zone.patch
mm-page_alloc-remove-boot-pageset-initialization-from-memory-hotplug.patch
mm-page_alloc-do-not-set_cpu_numa_mem-on-empty-nodes-initialization.patch
mm-memory_hotplug-drop-zone-from-build_all_zonelists.patch
mm-memory_hotplug-remove-explicit-build_all_zonelists-from-try_online_node.patch
mm-page_alloc-simplify-zonelist-initialization.patch
mm-page_alloc-remove-stop_machine-from-build_all_zonelists.patch
mm-memory_hotplug-get-rid-of-zonelists_mutex.patch
mm-sparse-page_ext-drop-ugly-n_high_memory-branches-for-allocations.patch
mm-vmscan-do-not-loop-on-too_many_isolated-for-ever.patch
mm-vmscan-do-not-loop-on-too_many_isolated-for-ever-fix.patch
treewide-remove-gfp_temporary-allocation-flag.patch
mm-rename-global_page_state-to-global_zone_page_state.patch
mm-hugetlb-do-not-allocate-non-migrateable-gigantic-pages-from-movable-zones.patch
mm-oom-do-not-rely-on-tif_memdie-for-memory-reserves-access.patch
mm-replace-tif_memdie-checks-by-tsk_is_oom_victim.patch
fs-proc-remove-priv-argument-from-is_stack.patch

