From: akpm@linux-foundation.org
Subject: + cgroups-fix-api-thinko.patch added to -mm tree
Date: Wed, 25 Aug 2010 14:35:34 -0700
Message-ID: <201008252135.o7PLZZiO017115@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60278 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751997Ab0HYVfy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Aug 2010 17:35:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mst@redhat.com, alex.williamson@redhat.com, bblum@google.com, lizf@cn.fujitsu.com, menage@google.com, sri@us.ibm.com


The patch titled
     cgroups: fix API thinko
has been added to the -mm tree.  Its filename is
     cgroups-fix-api-thinko.patch

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
Subject: cgroups: fix API thinko
From: "Michael S. Tsirkin" <mst@redhat.com>

The cgroup_attach_task_current_cg() API that we have is backwards: we
really need an API to attach to the cgroups from another process A to the
current one.

In our case (vhost), a priveledged user wants to attach it's task to
cgroups from a less priveledged one, the API makes us run it in the other
task's context, and this fails.

So let's make the API generic and just pass in 'from' and 'to' tasks.  Add
an inline wrapper for cgroup_attach_task_current_cg to avoid breaking
bisect.

When qemu uses vhost, inside the ioctl call it creates a thread, and tries
to add this thread to the groups of current, and it fails.  But we control
the thread, so to solve the problem, we really should tell it 'connect to
out cgroups'.

What this patch does is add an API for that.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Tested-by: Alex Williamson <alex.williamson@redhat.com>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ben Blum <bblum@google.com>
Cc: Sridhar Samudrala <sri@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |   11 ++++++++++-
 kernel/cgroup.c        |    9 +++++----
 2 files changed, 15 insertions(+), 5 deletions(-)

diff -puN include/linux/cgroup.h~cgroups-fix-api-thinko include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroups-fix-api-thinko
+++ a/include/linux/cgroup.h
@@ -578,7 +578,11 @@ struct task_struct *cgroup_iter_next(str
 void cgroup_iter_end(struct cgroup *cgrp, struct cgroup_iter *it);
 int cgroup_scan_tasks(struct cgroup_scanner *scan);
 int cgroup_attach_task(struct cgroup *, struct task_struct *);
-int cgroup_attach_task_current_cg(struct task_struct *);
+int cgroup_attach_task_all(struct task_struct *from, struct task_struct *);
+static inline int cgroup_attach_task_current_cg(struct task_struct *tsk)
+{
+	return cgroup_attach_task_all(current, tsk);
+}
 
 /*
  * CSS ID is ID for cgroup_subsys_state structs under subsys. This only works
@@ -636,6 +640,11 @@ static inline int cgroupstats_build(stru
 }
 
 /* No cgroups - nothing to do */
+static inline int cgroup_attach_task_all(struct task_struct *from,
+					 struct task_struct *t)
+{
+	return 0;
+}
 static inline int cgroup_attach_task_current_cg(struct task_struct *t)
 {
 	return 0;
diff -puN kernel/cgroup.c~cgroups-fix-api-thinko kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-fix-api-thinko
+++ a/kernel/cgroup.c
@@ -1791,10 +1791,11 @@ out:
 }
 
 /**
- * cgroup_attach_task_current_cg - attach task 'tsk' to current task's cgroup
+ * cgroup_attach_task_all - attach task 'tsk' to all cgroups of task 'from'
+ * @from: attach to all cgroups of a given task
  * @tsk: the task to be attached
  */
-int cgroup_attach_task_current_cg(struct task_struct *tsk)
+int cgroup_attach_task_all(struct task_struct *from, struct task_struct *tsk)
 {
 	struct cgroupfs_root *root;
 	struct cgroup *cur_cg;
@@ -1802,7 +1803,7 @@ int cgroup_attach_task_current_cg(struct
 
 	cgroup_lock();
 	for_each_active_root(root) {
-		cur_cg = task_cgroup_from_root(current, root);
+		cur_cg = task_cgroup_from_root(from, root);
 		retval = cgroup_attach_task(cur_cg, tsk);
 		if (retval)
 			break;
@@ -1811,7 +1812,7 @@ int cgroup_attach_task_current_cg(struct
 
 	return retval;
 }
-EXPORT_SYMBOL_GPL(cgroup_attach_task_current_cg);
+EXPORT_SYMBOL_GPL(cgroup_attach_task_all);
 
 /*
  * Attach task with pid 'pid' to cgroup 'cgrp'. Call with cgroup_mutex
_

Patches currently in -mm which might be from mst@redhat.com are

linux-next.patch
cgroups-fix-api-thinko.patch
cgroups-fix-api-thinko-fix.patch

