From: akpm@linux-foundation.org
Subject: - adapt-page_lock_anon_vma-to-preempt_rcu.patch removed from -mm tree
Date: Thu, 01 Mar 2007 21:07:20 -0800
Message-ID: <200703020507.l2257KO3000868@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42404 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422767AbXCBFHj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 00:07:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, clameter@engr.sgi.com, hugh@veritas.com, nickpiggin@yahoo.com.au, paulmck@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     adapt page_lock_anon_vma() to PREEMPT_RCU
has been removed from the -mm tree.  Its filename was
     adapt-page_lock_anon_vma-to-preempt_rcu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: adapt page_lock_anon_vma() to PREEMPT_RCU
From: Oleg Nesterov <oleg@tv-sign.ru>

page_lock_anon_vma() uses spin_lock() to block RCU.  This doesn't work with
PREEMPT_RCU, we have to do rcu_read_lock() explicitely.  Otherwise, it is
theoretically possible that slab returns anon_vma's memory to the system
before we do spin_unlock(&anon_vma->lock).

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Acked-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff -puN mm/rmap.c~adapt-page_lock_anon_vma-to-preempt_rcu mm/rmap.c
--- a/mm/rmap.c~adapt-page_lock_anon_vma-to-preempt_rcu
+++ a/mm/rmap.c
@@ -183,7 +183,7 @@ void __init anon_vma_init(void)
  */
 static struct anon_vma *page_lock_anon_vma(struct page *page)
 {
-	struct anon_vma *anon_vma = NULL;
+	struct anon_vma *anon_vma;
 	unsigned long anon_mapping;
 
 	rcu_read_lock();
@@ -195,9 +195,16 @@ static struct anon_vma *page_lock_anon_v
 
 	anon_vma = (struct anon_vma *) (anon_mapping - PAGE_MAPPING_ANON);
 	spin_lock(&anon_vma->lock);
+	return anon_vma;
 out:
 	rcu_read_unlock();
-	return anon_vma;
+	return NULL;
+}
+
+static void page_unlock_anon_vma(struct anon_vma *anon_vma)
+{
+	spin_unlock(&anon_vma->lock);
+	rcu_read_unlock();
 }
 
 /*
@@ -333,7 +340,8 @@ static int page_referenced_anon(struct p
 		if (!mapcount)
 			break;
 	}
-	spin_unlock(&anon_vma->lock);
+
+	page_unlock_anon_vma(anon_vma);
 	return referenced;
 }
 
@@ -802,7 +810,8 @@ static int try_to_unmap_anon(struct page
 		if (ret == SWAP_FAIL || !page_mapped(page))
 			break;
 	}
-	spin_unlock(&anon_vma->lock);
+
+	page_unlock_anon_vma(anon_vma);
 	return ret;
 }
 
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
drivers-media-video-cpia_ppc-dont-use-_work_nar.patch
bonding-replace-system-timer-with-work-queue.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
git-block.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
fix-refrigerator-vs-thaw_process-race.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
fix-rmmod-read-write-races-in-proc-entries.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
allow-access-to-proc-pid-fd-after-setuid.patch
allow-access-to-proc-pid-fd-after-setuid-fix.patch
allow-access-to-proc-pid-fd-after-setuid-update.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
softlockup-trivial-s-99-max_rt_prio.patch
reimplement-flush_workqueue.patch
implement-flush_work.patch
implement-flush_work-sanity.patch
implement-flush_work_keventd.patch
flush_workqueue-use-preempt_disable-to-hold-off-cpu-hotplug.patch
flush_cpu_workqueue-dont-flush-an-empty-worklist.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed.patch
slab-use-cpu_lock_.patch
workqueue-fix-freezeable-workqueues-implementation.patch
workqueue-fix-flush_workqueue-vs-cpu_dead-race.patch
workqueue-dont-clear-cwq-thread-until-it-exits.patch
workqueue-dont-migrate-pending-works-from-the-dead-cpu.patch
workqueue-kill-run_scheduled_work.patch
workqueue-dont-save-interrupts-in-run_workqueue.patch
workqueue-dont-save-interrupts-in-run_workqueue-update-2.patch
workqueue-make-cancel_rearming_delayed_workqueue-work-on-idle-dwork.patch
workqueue-introduce-cpu_singlethread_map.patch
workqueue-introduce-workqueue_struct-singlethread.patch
workqueue-make-init_workqueues-__init.patch
make-queue_delayed_work-friendly-to-flush_fork.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
unify-queue_delayed_work-and-queue_delayed_work_on-fix.patch
workqueue-introduce-wq_per_cpu-helper.patch
make-cancel_rearming_delayed_work-work-on-any-workqueue-not-just-keventd_wq.patch
ipvs-flush-defense_work-before-module-unload.patch
workqueue-kill-noautorel-works.patch
worker_thread-dont-play-with-signals.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync.patch
____call_usermodehelper-dont-flush_signals.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
rework-compat_sys_io_submit.patch
fix-aioh-includes.patch
fix-access_ok-checks.patch
make-good_sigevent-non-static.patch
make-good_sigevent-non-static-fix.patch
make-__sigqueue_free-and.patch
aio-completion-signal-notification.patch
aio-completion-signal-notification-fix.patch
aio-completion-signal-notification-fixes-and-cleanups.patch
aio-completion-signal-notification-small-cleanup.patch
add-listio-syscall-support.patch
