From: akpm@linux-foundation.org
Subject: - cgroups-fix-declaration-of-cgroup_mm_owner_callbacks.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:36:19 -0700
Message-ID: <200810202036.m9KKaJ0E011345@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51714 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754162AbYJTUqo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:46:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: menage@google.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     cgroups: fix declaration of cgroup_mm_owner_callbacks
has been removed from the -mm tree.  Its filename was
     cgroups-fix-declaration-of-cgroup_mm_owner_callbacks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: fix declaration of cgroup_mm_owner_callbacks
From: Paul Menage <menage@google.com>

The choice of real/dummy declaration for cgroup_mm_owner_callbacks()
shouldn't be based on CONFIG_MM_OWNER, but on CONFIG_CGROUPS.  Otherwise
kernel/exit.c fails to compile when something other than a cgroups
controller selects CONFIG_MM_OWNER

Signed-off-by: Paul Menage <menage@google.com>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff -puN include/linux/cgroup.h~cgroups-fix-declaration-of-cgroup_mm_owner_callbacks include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroups-fix-declaration-of-cgroup_mm_owner_callbacks
+++ a/include/linux/cgroup.h
@@ -403,6 +403,9 @@ void cgroup_iter_end(struct cgroup *cgrp
 int cgroup_scan_tasks(struct cgroup_scanner *scan);
 int cgroup_attach_task(struct cgroup *, struct task_struct *);
 
+void cgroup_mm_owner_callbacks(struct task_struct *old,
+			       struct task_struct *new);
+
 #else /* !CONFIG_CGROUPS */
 
 static inline int cgroup_init_early(void) { return 0; }
@@ -421,15 +424,9 @@ static inline int cgroupstats_build(stru
 	return -EINVAL;
 }
 
+static inline void cgroup_mm_owner_callbacks(struct task_struct *old,
+					     struct task_struct *new) {}
+
 #endif /* !CONFIG_CGROUPS */
 
-#ifdef CONFIG_MM_OWNER
-extern void
-cgroup_mm_owner_callbacks(struct task_struct *old, struct task_struct *new);
-#else /* !CONFIG_MM_OWNER */
-static inline void
-cgroup_mm_owner_callbacks(struct task_struct *old, struct task_struct *new)
-{
-}
-#endif /* CONFIG_MM_OWNER */
 #endif /* _LINUX_CGROUP_H */
_

Patches currently in -mm which might be from menage@google.com are

origin.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-enhance-mm_owner_changed-callback-to-deal-with-exited-owner.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-fix-crash-on-fork.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
add-a-refcount-check-in-dput.patch

