From: akpm@linux-foundation.org
Subject: + cgroups-fix-declaration-of-cgroup_mm_owner_callbacks.patch added to -mm tree
Date: Wed, 17 Sep 2008 14:26:07 -0700
Message-ID: <200809172126.m8HLQ7Zq031213@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39829 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753911AbYIQV0R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Sep 2008 17:26:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: menage@google.com, penberg@cs.helsinki.fi


The patch titled
     cgroups: fix declaration of cgroup_mm_owner_callbacks
has been added to the -mm tree.  Its filename is
     cgroups-fix-declaration-of-cgroup_mm_owner_callbacks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

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

cpuset-avoid-changing-cpusets-cpus-when-errno-returned.patch
cpuset-hotplug-documentation-fix.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
mm-owner-fix-race-between-swap-and-exit-fix-fix.patch
container-freezer-document-the-cgroup-freezer-subsystem.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-cgroups-eliminate-race-in-css_set-refcounting.patch
cgroups-convert-tasks-file-to-use-a-seq_file-with-shared-pid-array.patch
cgroups-fix-declaration-of-cgroup_mm_owner_callbacks.patch
devcgroup-use-kmemdup.patch
devcgroup-remove-unused-variable.patch
devcgroup-remove-spin_lock.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-enhance-mm_owner_changed-callback-to-deal-with-exited-owner.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-fix-crash-on-fork.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
add-a-refcount-check-in-dput.patch

