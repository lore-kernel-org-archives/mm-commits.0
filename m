From: akpm@linux-foundation.org
Subject: + ioprio-grab-rcu_read_lock-in-sys_ioprio_setget.patch added to -mm tree
Date: Fri, 12 Nov 2010 11:21:28 -0800
Message-ID: <201011121921.oACJLSQZ027060@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42753 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751964Ab0KLTWf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Nov 2010 14:22:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gthelen@google.com, axboe@kernel.dk, oleg@redhat.com, paulmck@linux.vnet.ibm.com, viro@zeniv.linux.org.uk


The patch titled
     ioprio: grab rcu_read_lock in sys_ioprio_{set,get}()
has been added to the -mm tree.  Its filename is
     ioprio-grab-rcu_read_lock-in-sys_ioprio_setget.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ioprio: grab rcu_read_lock in sys_ioprio_{set,get}()
From: Greg Thelen <gthelen@google.com>

Using:
- CONFIG_LOCKUP_DETECTOR=y
- CONFIG_PREEMPT=y
- CONFIG_LOCKDEP=y
- CONFIG_PROVE_LOCKING=y
- CONFIG_PROVE_RCU=y
found a missing rcu lock during boot on a 512 MiB x86_64 ubuntu vm:
  ===================================================
  [ INFO: suspicious rcu_dereference_check() usage. ]
  ---------------------------------------------------
  kernel/pid.c:419 invoked rcu_dereference_check() without protection!

  other info that might help us debug this:

  rcu_scheduler_active = 1, debug_locks = 0
  1 lock held by ureadahead/1355:
   #0:  (tasklist_lock){.+.+..}, at: [<ffffffff8115bc09>] sys_ioprio_set+0x7f/0x29e

  stack backtrace:
  Pid: 1355, comm: ureadahead Not tainted 2.6.37-dbg-DEV #1
  Call Trace:
   [<ffffffff8109c10c>] lockdep_rcu_dereference+0xaa/0xb3
   [<ffffffff81088cbf>] find_task_by_pid_ns+0x44/0x5d
   [<ffffffff81088cfa>] find_task_by_vpid+0x22/0x24
   [<ffffffff8115bc3e>] sys_ioprio_set+0xb4/0x29e
   [<ffffffff8147cf21>] ? trace_hardirqs_off_thunk+0x3a/0x3c
   [<ffffffff8105c409>] sysenter_dispatch+0x7/0x2c
   [<ffffffff8147cee2>] ? trace_hardirqs_on_thunk+0x3a/0x3f

The fix is to:
a) grab rcu lock in sys_ioprio_{set,get}() and
b) avoid grabbing tasklist_lock.
Discussion in: http://marc.info/?l=linux-kernel&m=128951324702889

Signed-off-by: Greg Thelen <gthelen@google.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ioprio.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff -puN fs/ioprio.c~ioprio-grab-rcu_read_lock-in-sys_ioprio_setget fs/ioprio.c
--- a/fs/ioprio.c~ioprio-grab-rcu_read_lock-in-sys_ioprio_setget
+++ a/fs/ioprio.c
@@ -103,12 +103,7 @@ SYSCALL_DEFINE3(ioprio_set, int, which, 
 	}
 
 	ret = -ESRCH;
-	/*
-	 * We want IOPRIO_WHO_PGRP/IOPRIO_WHO_USER to be "atomic",
-	 * so we can't use rcu_read_lock(). See re-copy of ->ioprio
-	 * in copy_process().
-	 */
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 	switch (which) {
 		case IOPRIO_WHO_PROCESS:
 			if (!who)
@@ -153,7 +148,7 @@ free_uid:
 			ret = -EINVAL;
 	}
 
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 	return ret;
 }
 
@@ -197,7 +192,7 @@ SYSCALL_DEFINE2(ioprio_get, int, which, 
 	int ret = -ESRCH;
 	int tmpio;
 
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 	switch (which) {
 		case IOPRIO_WHO_PROCESS:
 			if (!who)
@@ -250,6 +245,6 @@ SYSCALL_DEFINE2(ioprio_get, int, which, 
 			ret = -EINVAL;
 	}
 
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 	return ret;
 }
_

Patches currently in -mm which might be from gthelen@google.com are

ioprio-grab-rcu_read_lock-in-sys_ioprio_setget.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
memcg-create-extensible-page-stat-update-routines.patch
memcg-add-lock-to-synchronize-page-accounting-and-migration.patch
writeback-create-dirty_info-structure.patch
memcg-add-dirty-page-accounting-infrastructure.patch
memcg-add-kernel-calls-for-memcg-dirty-page-stats.patch
memcg-add-dirty-limits-to-mem_cgroup.patch
memcg-add-dirty-limits-to-mem_cgroup-use-native-word-to-represent-dirtyable-pages.patch
memcg-add-dirty-limits-to-mem_cgroup-catch-negative-per-cpu-sums-in-dirty-info.patch
memcg-add-dirty-limits-to-mem_cgroup-avoid-overflow-in-memcg_hierarchical_free_pages.patch
memcg-add-dirty-limits-to-mem_cgroup-correct-memcg_hierarchical_free_pages-return-type.patch
memcg-add-dirty-limits-to-mem_cgroup-avoid-free-overflow-in-memcg_hierarchical_free_pages.patch
memcg-cpu-hotplug-lockdep-warning-fix.patch
memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch
memcg-break-out-event-counters-from-other-stats.patch
memcg-check-memcg-dirty-limits-in-page-writeback.patch
memcg-use-native-word-page-statistics-counters.patch
memcg-use-native-word-page-statistics-counters-fix.patch
memcg-add-mem_cgroup-parameter-to-mem_cgroup_page_stat.patch
memcg-pass-mem_cgroup-to-mem_cgroup_dirty_info.patch
memcg-make-throttle_vm_writeout-memcg-aware.patch
memcg-make-throttle_vm_writeout-memcg-aware-fix.patch
memcg-simplify-mem_cgroup_page_stat.patch
memcg-simplify-mem_cgroup_dirty_info.patch
memcg-make-mem_cgroup_page_stat-return-value-unsigned.patch

