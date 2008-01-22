From: akpm@linux-foundation.org
Subject: + lockdep-annotate-epoll.patch added to -mm tree
Date: Tue, 22 Jan 2008 15:03:23 -0800
Message-ID: <200801222303.m0MN3CAk012167@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58334 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757823AbYAVXEY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jan 2008 18:04:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, davidel@xmailserver.org, stable@kernel.org, stefanr@s5r6.in-berlin.de


The patch titled
     lockdep: annotate epoll
has been added to the -mm tree.  Its filename is
     lockdep-annotate-epoll.patch

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
Subject: lockdep: annotate epoll
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

On Sat, 2008-01-05 at 13:35 -0800, Davide Libenzi wrote:

> I remember I talked with Arjan about this time ago. Basically, since 1)
> you can drop an epoll fd inside another epoll fd 2) callback-based wakeups
> are used, you can see a wake_up() from inside another wake_up(), but they
> will never refer to the same lock instance.
> Think about:
>
> 	dfd = socket(...);
> 	efd1 = epoll_create();
> 	efd2 = epoll_create();
> 	epoll_ctl(efd1, EPOLL_CTL_ADD, dfd, ...);
> 	epoll_ctl(efd2, EPOLL_CTL_ADD, efd1, ...);
>
> When a packet arrives to the device underneath "dfd", the net code will
> issue a wake_up() on its poll wake list. Epoll (efd1) has installed a
> callback wakeup entry on that queue, and the wake_up() performed by the
> "dfd" net code will end up in ep_poll_callback(). At this point epoll
> (efd1) notices that it may have some event ready, so it needs to wake up
> the waiters on its poll wait list (efd2). So it calls ep_poll_safewake()
> that ends up in another wake_up(), after having checked about the
> recursion constraints. That are, no more than EP_MAX_POLLWAKE_NESTS, to
> avoid stack blasting. Never hit the same queue, to avoid loops like:
>
> 	epoll_ctl(efd2, EPOLL_CTL_ADD, efd1, ...);
> 	epoll_ctl(efd3, EPOLL_CTL_ADD, efd2, ...);
> 	epoll_ctl(efd4, EPOLL_CTL_ADD, efd3, ...);
> 	epoll_ctl(efd1, EPOLL_CTL_ADD, efd4, ...);
>
> The code "if (tncur->wq == wq || ..." prevents re-entering the same
> queue/lock.

Since the epoll code is very careful to not nest same instance locks
allow the recursion.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Acked-by: Davide Libenzi <davidel@xmailserver.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c       |    2 +-
 include/linux/wait.h |   16 ++++++++++++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff -puN fs/eventpoll.c~lockdep-annotate-epoll fs/eventpoll.c
--- a/fs/eventpoll.c~lockdep-annotate-epoll
+++ a/fs/eventpoll.c
@@ -353,7 +353,7 @@ static void ep_poll_safewake(struct poll
 	spin_unlock_irqrestore(&psw->lock, flags);
 
 	/* Do really wake up now */
-	wake_up(wq);
+	wake_up_nested(wq, 1 + wake_nests);
 
 	/* Remove the current task from the list */
 	spin_lock_irqsave(&psw->lock, flags);
diff -puN include/linux/wait.h~lockdep-annotate-epoll include/linux/wait.h
--- a/include/linux/wait.h~lockdep-annotate-epoll
+++ a/include/linux/wait.h
@@ -161,6 +161,22 @@ wait_queue_head_t *FASTCALL(bit_waitqueu
 #define	wake_up_locked(x)		__wake_up_locked((x), TASK_UNINTERRUPTIBLE | TASK_INTERRUPTIBLE)
 #define wake_up_interruptible_sync(x)   __wake_up_sync((x),TASK_INTERRUPTIBLE, 1)
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+/*
+ * macro to avoid include hell
+ */
+#define wake_up_nested(x, s)						\
+do {									\
+	unsigned long flags;						\
+									\
+	spin_lock_irqsave_nested(&(x)->lock, flags, (s));		\
+	wake_up_locked(x); 						\
+	spin_unlock_irqrestore(&(x)->lock, flags);			\
+} while (0)
+#else
+#define wake_up_nested(x, s)		wake_up(x)
+#endif
+
 #define __wait_event(wq, condition) 					\
 do {									\
 	DEFINE_WAIT(__wait);						\
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
lockdep-annotate-epoll.patch
git-sched.patch
slub-move-kmem_cache_node-determination-into-add_full-and-add_partial-slub-workaround-for-lockdep-confusion.patch
swapin-needs-gfp_mask-for-loop-on-tmpfs.patch
mm-page-writeback-highmem_is_dirtyable-option.patch
mm-page-writeback-highmem_is_dirtyable-option-fix.patch
skip-writing-data-pages-when-inode-is-under-i_sync.patch
fix-dirty-page-accounting-leak-with-ext3-data=journal.patch
kernel-add-mutex_lock_killable.patch
vfs-use-mutex_lock_killable-in-vfs_readdir.patch
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
