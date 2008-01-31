From: akpm@linux-foundation.org
Subject: + hrtimer-fix-hrtimer_init_sleeper-users.patch added to -mm tree
Date: Thu, 31 Jan 2008 13:29:10 -0800
Message-ID: <200801312129.m0VLTADl012262@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57016 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756136AbYAaV3k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Jan 2008 16:29:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, tglx@linutronix.de


The patch titled
     hrtimer: fix hrtimer_init_sleeper() users
has been added to the -mm tree.  Its filename is
     hrtimer-fix-hrtimer_init_sleeper-users.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hrtimer: fix hrtimer_init_sleeper() users
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit 37bb6cb4097e29ffee970065b74499cbf10603a3
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Fri Jan 25 21:08:32 2008 +0100

    hrtimer: unlock hrtimer_wakeup

Broke hrtimer_init_sleeper() users.  It forgot to fix up the futex caller
of this function to detect the failed queueing and messed up the
do_nanosleep() caller in that it could leak a TASK_INTERRUPTIBLE state.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/futex.c   |    2 ++
 kernel/hrtimer.c |    2 ++
 2 files changed, 4 insertions(+)

diff -puN kernel/futex.c~hrtimer-fix-hrtimer_init_sleeper-users kernel/futex.c
--- a/kernel/futex.c~hrtimer-fix-hrtimer_init_sleeper-users
+++ a/kernel/futex.c
@@ -1252,6 +1252,8 @@ static int futex_wait(u32 __user *uaddr,
 			t.timer.expires = *abs_time;
 
 			hrtimer_start(&t.timer, t.timer.expires, HRTIMER_MODE_ABS);
+			if (!hrtimer_active(&t.timer))
+				t.task = NULL;
 
 			/*
 			 * the timer could have already expired, in which
diff -puN kernel/hrtimer.c~hrtimer-fix-hrtimer_init_sleeper-users kernel/hrtimer.c
--- a/kernel/hrtimer.c~hrtimer-fix-hrtimer_init_sleeper-users
+++ a/kernel/hrtimer.c
@@ -1314,6 +1314,8 @@ static int __sched do_nanosleep(struct h
 
 	} while (t->task && !signal_pending(current));
 
+	__set_current_state(TASK_RUNNING);
+
 	return t->task == NULL;
 }
 
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
lockdep-annotate-epoll.patch
slub-move-kmem_cache_node-determination-into-add_full-and-add_partial-slub-workaround-for-lockdep-confusion.patch
swapin-needs-gfp_mask-for-loop-on-tmpfs.patch
mm-page-writeback-highmem_is_dirtyable-option.patch
mm-page-writeback-highmem_is_dirtyable-option-fix.patch
skip-writing-data-pages-when-inode-is-under-i_sync.patch
fix-dirty-page-accounting-leak-with-ext3-data=journal.patch
kernel-add-mutex_lock_killable.patch
vfs-use-mutex_lock_killable-in-vfs_readdir.patch
hrtimer-fix-hrtimer_init_sleeper-users.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
memcgroup-reinstate-swapoff-mod.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages-fix.patch
memcgroup-fix-zone-isolation-oom.patch
memcgroup-revert-swap_state-mods.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-force_empty-interface-for-dropping-all-account-in-empty-cgroup.patch
memory-cgroup-enhancements-remember-a-page-is-charged-as-page-cache.patch
memory-cgroup-enhancements-remember-a-page-is-on-active-list-of-cgroup-or-not.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-memorystat-file.patch
memory-cgroup-enhancements-add-pre_destroy-handler.patch
memory-cgroup-enhancements-implicit-force_empty-at-rmdir.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-add-scan_global_lru-macro.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-nid-zid-helper-function-for-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-active-inactive-counter.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-mapper_ratio-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-active-inactive-imbalance-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-the-number-of-pages-to-be-scanned-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lock-for-cgroup.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse.patch
mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit.patch
