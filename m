From: akpm@linux-foundation.org
Subject: - uninline-find_pid-etc-set-of-functions.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:52:08 -0700
Message-ID: <200710192252.l9JMq82v024245@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36100 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934494AbXJSXGV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:06:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, ebiederm@xmission.com, menage@google.com, oleg@tv-sign.ru, sukadev@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Uninline find_pid etc set of functions
has been removed from the -mm tree.  Its filename was
     uninline-find_pid-etc-set-of-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Uninline find_pid etc set of functions
From: Pavel Emelyanov <xemul@openvz.org>

The find_pid/_vpid/_pid_ns functions are used to find the struct pid by its
id, depending on whic id - global or virtual - is used.

The find_vpid() is a macro that pushes the current->nsproxy->pid_ns on the
stack to call another function - find_pid_ns().  It turned out, that this
dereference together with the push itself cause the kernel text size to
grow too much.

Move all these out-of-line.  Together with the previous patch this saves a
bit less that 400 bytes from .text section.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Paul Menage <menage@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pid.h |    5 ++---
 kernel/capability.c |    2 +-
 kernel/pid.c        |   12 ++++++++++++
 3 files changed, 15 insertions(+), 4 deletions(-)

diff -puN include/linux/pid.h~uninline-find_pid-etc-set-of-functions include/linux/pid.h
--- a/include/linux/pid.h~uninline-find_pid-etc-set-of-functions
+++ a/include/linux/pid.h
@@ -110,9 +110,8 @@ extern struct pid_namespace init_pid_ns;
  * see also find_task_by_pid() set in include/linux/sched.h
  */
 extern struct pid *FASTCALL(find_pid_ns(int nr, struct pid_namespace *ns));
-
-#define find_vpid(pid)	find_pid_ns(pid, current->nsproxy->pid_ns)
-#define find_pid(pid)	find_pid_ns(pid, &init_pid_ns)
+extern struct pid *find_vpid(int nr);
+extern struct pid *find_pid(int nr);
 
 /*
  * Lookup a PID in the hash table, and return with it's count elevated.
diff -puN kernel/capability.c~uninline-find_pid-etc-set-of-functions kernel/capability.c
--- a/kernel/capability.c~uninline-find_pid-etc-set-of-functions
+++ a/kernel/capability.c
@@ -96,7 +96,7 @@ static inline int cap_set_pg(int pgrp_nr
 	int found = 0;
 	struct pid *pgrp;
 
-	pgrp = find_pid_ns(pgrp_nr, current->nsproxy->pid_ns);
+	pgrp = find_vpid(pgrp_nr);
 	do_each_pid_task(pgrp, PIDTYPE_PGID, g) {
 		target = g;
 		while_each_thread(g, target) {
diff -puN kernel/pid.c~uninline-find_pid-etc-set-of-functions kernel/pid.c
--- a/kernel/pid.c~uninline-find_pid-etc-set-of-functions
+++ a/kernel/pid.c
@@ -302,6 +302,18 @@ struct pid * fastcall find_pid_ns(int nr
 }
 EXPORT_SYMBOL_GPL(find_pid_ns);
 
+struct pid *find_vpid(int nr)
+{
+	return find_pid_ns(nr, current->nsproxy->pid_ns);
+}
+EXPORT_SYMBOL_GPL(find_vpid);
+
+struct pid *find_pid(int nr)
+{
+	return find_pid_ns(nr, &init_pid_ns);
+}
+EXPORT_SYMBOL_GPL(find_pid);
+
 /*
  * attach_pid() must be called with the tasklist_lock write-held.
  */
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
