From: akpm@linux-foundation.org
Subject: - pid-namespaces-add-support-for-pid-namespaces-hierarchy.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:51:30 -0700
Message-ID: <200710192251.l9JMpUrL024188@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53170 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935235AbXJSXGg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:06:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, ebiederm@xmission.com, menage@google.com, oleg@tv-sign.ru, sukadev@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     pid namespaces: add support for pid namespaces hierarchy
has been removed from the -mm tree.  Its filename was
     pid-namespaces-add-support-for-pid-namespaces-hierarchy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pid namespaces: add support for pid namespaces hierarchy
From: Pavel Emelyanov <xemul@openvz.org>

Each namespace has a parent and is characterized by its "level".  Level is the
number of the namespace generation.  E.g.  init namespace has level 0, after
cloning new one it will have level 1, the next one - 2 and so on and so forth.
 This level is not explicitly limited.

True hierarchy must have some way to find each namespace's children, but it is
not used in the patches, so this ability is not added (yet).

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pid_namespace.h |    2 ++
 kernel/pid.c                  |    3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff -puN include/linux/pid_namespace.h~pid-namespaces-add-support-for-pid-namespaces-hierarchy include/linux/pid_namespace.h
--- a/include/linux/pid_namespace.h~pid-namespaces-add-support-for-pid-namespaces-hierarchy
+++ a/include/linux/pid_namespace.h
@@ -21,6 +21,8 @@ struct pid_namespace {
 	int last_pid;
 	struct task_struct *child_reaper;
 	struct kmem_cache *pid_cachep;
+	int level;
+	struct pid_namespace *parent;
 };
 
 extern struct pid_namespace init_pid_ns;
diff -puN kernel/pid.c~pid-namespaces-add-support-for-pid-namespaces-hierarchy kernel/pid.c
--- a/kernel/pid.c~pid-namespaces-add-support-for-pid-namespaces-hierarchy
+++ a/kernel/pid.c
@@ -67,7 +67,8 @@ struct pid_namespace init_pid_ns = {
 		[ 0 ... PIDMAP_ENTRIES-1] = { ATOMIC_INIT(BITS_PER_PAGE), NULL }
 	},
 	.last_pid = 0,
-	.child_reaper = &init_task
+	.level = 0,
+	.child_reaper = &init_task,
 };
 
 int is_global_init(struct task_struct *tsk)
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-resource-counters-v7-fix.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
reiser4-use-helpers-to-obtain-task-pid-in-printks.patch
