From: akpm@linux-foundation.org
Subject: [folded-merged]
 oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2-fix.patch
 removed from -mm tree
Date: Fri, 12 Dec 2014 16:42:18 -0800
Message-ID: <548b8b6a.LzVVrrsm2JeWzo05%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38397 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbaLMAmT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 12 Dec 2014 19:42:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.cz, oleg@redhat.com, rientjes@google.com, rjw@rjwysocki.net, tj@kernel.org, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2-fix
has been removed from the -mm tree.  Its filename was
     oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2-fix.patch

This patch was dropped because it was folded into oom-dont-assume-that-a-coredumping-thread-will-exit-soon.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2-fix

add comment

Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/oom.h |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN include/linux/oom.h~oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2-fix include/linux/oom.h
--- a/include/linux/oom.h~oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2-fix
+++ a/include/linux/oom.h
@@ -89,6 +89,11 @@ extern struct task_struct *find_lock_tas
 
 static inline bool task_will_free_mem(struct task_struct *task)
 {
+	/*
+	 * A coredumping process may sleep for an extended period in exit_mm(),
+	 * so the oom killer cannot assume that the process will promptly exit
+	 * and release memory.
+	 */
 	return (task->flags & PF_EXITING) &&
 		!(task->signal->flags & SIGNAL_GROUP_COREDUMP);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-mincore-add-hwpoison-page-handle.patch
include-linux-kmemleakh-needs-slabh.patch
mm-page_owner-keep-track-of-page-owners.patch
fs-seq_file-fallback-to-vmalloc-instead-of-oom-kill-processes.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon.patch
mm-memcontrol-fix-defined-but-not-used-compiler-warning-fix.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix-2.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix.patch
mm-zsmalloc-support-allocating-obj-with-size-of-zs_max_alloc_size-fix.patch
mm-zsmalloc-avoid-duplicate-assignment-of-prev_class-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix-fix.patch
ipc-msg-increase-msgmni-remove-scaling-checkpatch-fixes.patch
mm-cma-make-kmemleak-ignore-cma-regions.patch

