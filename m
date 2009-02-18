From: akpm@linux-foundation.org
Subject: + inotify-fix-gfp_kernel-related-deadlock.patch added to -mm tree
Date: Wed, 18 Feb 2009 14:26:56 -0800
Message-ID: <200902182226.n1IMQuov014846@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58367 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755603AbZBRW1T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Feb 2009 17:27:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, minchan.kim@gmail.com, nickpiggin@yahoo.com.au


The patch titled
     inotify: fix GFP_KERNEL related deadlock
has been added to the -mm tree.  Its filename is
     inotify-fix-gfp_kernel-related-deadlock.patch

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
Subject: inotify: fix GFP_KERNEL related deadlock
From: Ingo Molnar <mingo@elte.hu>

Enhanced lockdep coverage of __GFP_NOFS turned up this new lockdep
assert:

[ 1093.677775]
[ 1093.677781] =================================
[ 1093.680031] [ INFO: inconsistent lock state ]
[ 1093.680031] 2.6.29-rc5-tip-01504-gb49eca1-dirty #1
[ 1093.680031] ---------------------------------
[ 1093.680031] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
[ 1093.680031] kswapd0/308 [HC0[0]:SC0[0]:HE1:SE1] takes:
[ 1093.680031]  (&inode->inotify_mutex){+.+.?.}, at: [<c0205942>] inotify_inode_is_dead+0x20/0x80
[ 1093.680031] {RECLAIM_FS-ON-W} state was registered at:
[ 1093.680031]   [<c01696b9>] mark_held_locks+0x43/0x5b
[ 1093.680031]   [<c016baa4>] lockdep_trace_alloc+0x6c/0x6e
[ 1093.680031]   [<c01cf8b0>] kmem_cache_alloc+0x20/0x150
[ 1093.680031]   [<c040d0ec>] idr_pre_get+0x27/0x6c
[ 1093.680031]   [<c02056e3>] inotify_handle_get_wd+0x25/0xad
[ 1093.680031]   [<c0205f43>] inotify_add_watch+0x7a/0x129
[ 1093.680031]   [<c020679e>] sys_inotify_add_watch+0x20f/0x250
[ 1093.680031]   [<c010389e>] sysenter_do_call+0x12/0x35
[ 1093.680031]   [<ffffffff>] 0xffffffff
[ 1093.680031] irq event stamp: 60417
[ 1093.680031] hardirqs last  enabled at (60417): [<c018d5f5>] call_rcu+0x53/0x59
[ 1093.680031] hardirqs last disabled at (60416): [<c018d5b9>] call_rcu+0x17/0x59
[ 1093.680031] softirqs last  enabled at (59656): [<c0146229>] __do_softirq+0x157/0x16b
[ 1093.680031] softirqs last disabled at (59651): [<c0106293>] do_softirq+0x74/0x15d
[ 1093.680031]
[ 1093.680031] other info that might help us debug this:
[ 1093.680031] 2 locks held by kswapd0/308:
[ 1093.680031]  #0:  (shrinker_rwsem){++++..}, at: [<c01b0502>] shrink_slab+0x36/0x189
[ 1093.680031]  #1:  (&type->s_umount_key#4){+++++.}, at: [<c01e6d77>] shrink_dcache_memory+0x110/0x1fb
[ 1093.680031]
[ 1093.680031] stack backtrace:
[ 1093.680031] Pid: 308, comm: kswapd0 Not tainted 2.6.29-rc5-tip-01504-gb49eca1-dirty #1
[ 1093.680031] Call Trace:
[ 1093.680031]  [<c016947a>] valid_state+0x12a/0x13d
[ 1093.680031]  [<c016954e>] mark_lock+0xc1/0x1e9
[ 1093.680031]  [<c016a5b4>] ? check_usage_forwards+0x0/0x3f
[ 1093.680031]  [<c016ab74>] __lock_acquire+0x2c6/0xac8
[ 1093.680031]  [<c01688d9>] ? register_lock_class+0x17/0x228
[ 1093.680031]  [<c016b3d3>] lock_acquire+0x5d/0x7a
[ 1093.680031]  [<c0205942>] ? inotify_inode_is_dead+0x20/0x80
[ 1093.680031]  [<c08824c4>] __mutex_lock_common+0x3a/0x4cb
[ 1093.680031]  [<c0205942>] ? inotify_inode_is_dead+0x20/0x80
[ 1093.680031]  [<c08829ed>] mutex_lock_nested+0x2e/0x36
[ 1093.680031]  [<c0205942>] ? inotify_inode_is_dead+0x20/0x80
[ 1093.680031]  [<c0205942>] inotify_inode_is_dead+0x20/0x80
[ 1093.680031]  [<c01e6672>] dentry_iput+0x90/0xc2
[ 1093.680031]  [<c01e67a3>] d_kill+0x21/0x45
[ 1093.680031]  [<c01e6a46>] __shrink_dcache_sb+0x27f/0x355
[ 1093.680031]  [<c01e6dc5>] shrink_dcache_memory+0x15e/0x1fb
[ 1093.680031]  [<c01b05ed>] shrink_slab+0x121/0x189
[ 1093.680031]  [<c01b0d12>] kswapd+0x39f/0x561
[ 1093.680031]  [<c01ae499>] ? isolate_pages_global+0x0/0x233
[ 1093.680031]  [<c0157eae>] ? autoremove_wake_function+0x0/0x43
[ 1093.680031]  [<c01b0973>] ? kswapd+0x0/0x561
[ 1093.680031]  [<c0157daf>] kthread+0x41/0x82
[ 1093.680031]  [<c0157d6e>] ? kthread+0x0/0x82
[ 1093.680031]  [<c01043ab>] kernel_thread_helper+0x7/0x10

inotify_handle_get_wd() does idr_pre_get() which does a
kmem_cache_alloc() without __GFP_FS - and is hence deadlockable under
extreme MM pressure.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: MinChan Kim <minchan.kim@gmail.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/inotify/inotify.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/notify/inotify/inotify.c~inotify-fix-gfp_kernel-related-deadlock fs/notify/inotify/inotify.c
--- a/fs/notify/inotify/inotify.c~inotify-fix-gfp_kernel-related-deadlock
+++ a/fs/notify/inotify/inotify.c
@@ -156,7 +156,7 @@ static int inotify_handle_get_wd(struct 
 	int ret;
 
 	do {
-		if (unlikely(!idr_pre_get(&ih->idr, GFP_KERNEL)))
+		if (unlikely(!idr_pre_get(&ih->idr, GFP_NOFS)))
 			return -ENOSPC;
 		ret = idr_get_new_above(&ih->idr, watch, ih->last_wd+1, &watch->wd);
 	} while (ret == -EAGAIN);
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
pm-fix-build-for-config_pm-unset.patch
eeepc-should-depend-on-input.patch
fbdev-drm-fix-kconfig-submenu-mess-in-graphics-support.patch
x86-dell-laptop-depends-on-power_supply.patch
inotify-fix-gfp_kernel-related-deadlock.patch
linux-next.patch
x86-oqo-depends-on-input_polldev.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code.patch
x86-simplify-highmem-related-kconfig-entries.patch
kernel-auditscc-fix-warning.patch
clocksource-sanity-check-sysfs-clocksource-changes.patch
bluetooth-config_debug_lock_alloc-ifdefs-remove.patch
kmemleak-fix-section-mismatch-in-kmemleakc.patch
irq-free-setup_irq-interrupt-using-free_irq.patch
pci-enable-msi-on-8132.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-export-statistics-for-softirq-to-proc-fix.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
epoll-keyed-wakeups-v2-add-__wake_up_locked_key-and-__wake_up_sync_key.patch
epoll-keyed-wakeups-v2-introduce-new-_poll-wakeup-macros.patch
epoll-keyed-wakeups-v2-make-sockets-use-keyed-wakeups.patch
epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key.patch
epoll-keyed-wakeups-v2-make-eventfd-use-keyed-wakeups.patch
epoll-keyed-wakeups-v2-make-tty-use-keyed-wakeups.patch
workqueue-avoid-recursion-in-run_workqueue.patch
kthreads-move-sched-realeted-initialization-from-kthreadd-context.patch
kthreads-simplify-the-startup-synchronization.patch
kthreads-rework-kthread_stop.patch
kthreads-simplify-migration_thread-exit-path.patch
cpu-hotplug-remove-unused-cpuhotplug_mutex_lock.patch
futex-comment-requeue-key-reference-semantics.patch
sgi-gru-exclude-uv-definitions-on-32-bit-x86.patch
sgi-gru-add-definitions-of-x86_64-gru-mmrs.patch
sgi-gru-add-macros-for-using-the-uv-hub-to-send-interrupts.patch
factor-out-ifdefs-from-kernel-spinlockc-to-lock_contended_flags.patch
allow-rwlocks-to-re-enable-interrupts.patch
ia64-implement-interrupt-enabling-rwlocks.patch
preadv-pwritev-add-preadv-and-pwritev-system-calls.patch
arch-x86-kernel-acpi-cstatec-avoid-using-work_on_cpu.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-using-work_on_cpu.patch
arch-x86-kernel-cpu-mcheck-mce_amd_64c-avoid-using-work_on_cpu.patch
work_on_cpu-rewrite-it-to-create-a-kernel-thread-on-demand.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch

