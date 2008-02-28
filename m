From: akpm@linux-foundation.org
Subject: + pidns-make-pid-level-and-pid_ns-level-unsigned.patch added to -mm tree
Date: Wed, 27 Feb 2008 23:29:32 -0800
Message-ID: <200802280729.m1S7TWhS021642@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:40550 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751212AbYB1H3f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Feb 2008 02:29:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, ebiederm@xmission.com


The patch titled
     pidns: make pid->level and pid_ns->level unsigned
has been added to the -mm tree.  Its filename is
     pidns-make-pid-level-and-pid_ns-level-unsigned.patch

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
Subject: pidns: make pid->level and pid_ns->level unsigned
From: Pavel Emelyanov <xemul@openvz.org>

These values represent the nesting level of a namespace and pids living in it,
and it's always non-negative.

Turning this from int to unsigned int saves some space in pid.c (11 bytes on
x86 and 64 on ia64) by letting the compiler optimize the pid_nr_ns a bit. 
E.g.  on ia64 this removes the sign extension calls, which compiler adds to
optimize access to pid->nubers[ns->level].

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pid.h           |    2 +-
 include/linux/pid_namespace.h |    2 +-
 kernel/pid_namespace.c        |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/pid.h~pidns-make-pid-level-and-pid_ns-level-unsigned include/linux/pid.h
--- a/include/linux/pid.h~pidns-make-pid-level-and-pid_ns-level-unsigned
+++ a/include/linux/pid.h
@@ -60,7 +60,7 @@ struct pid
 	/* lists of tasks that use this pid */
 	struct hlist_head tasks[PIDTYPE_MAX];
 	struct rcu_head rcu;
-	int level;
+	unsigned int level;
 	struct upid numbers[1];
 };
 
diff -puN include/linux/pid_namespace.h~pidns-make-pid-level-and-pid_ns-level-unsigned include/linux/pid_namespace.h
--- a/include/linux/pid_namespace.h~pidns-make-pid-level-and-pid_ns-level-unsigned
+++ a/include/linux/pid_namespace.h
@@ -20,7 +20,7 @@ struct pid_namespace {
 	int last_pid;
 	struct task_struct *child_reaper;
 	struct kmem_cache *pid_cachep;
-	int level;
+	unsigned int level;
 	struct pid_namespace *parent;
 #ifdef CONFIG_PROC_FS
 	struct vfsmount *proc_mnt;
diff -puN kernel/pid_namespace.c~pidns-make-pid-level-and-pid_ns-level-unsigned kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~pidns-make-pid-level-and-pid_ns-level-unsigned
+++ a/kernel/pid_namespace.c
@@ -66,7 +66,7 @@ err_alloc:
 	return NULL;
 }
 
-static struct pid_namespace *create_pid_namespace(int level)
+static struct pid_namespace *create_pid_namespace(unsigned int level)
 {
 	struct pid_namespace *ns;
 	int i;
_

Patches currently in -mm which might be from xemul@openvz.org are

use-find_task_by_vpid-in-audit-code.patch
ia64-fix-ptrace-inside-a-namespace.patch
udf-fix-anchor-point-detection.patch
cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64.patch
cgroup-api-files-add-res_counter_read_u64.patch
cgroup-api-files-use-read_u64-in-memory-controller.patch
cgroup-api-files-strip-all-trailing-whitespace-in-cgroup_write_u64.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroup-api-files-add-cgroup-map-data-type.patch
cgroup-api-files-use-cgroup-map-for-memcontrol-stats-file.patch
cgroup-api-files-drop-mem_cgroup_force_empty.patch
cgroup-api-files-move-releasable-to-cgroup_debug-subsystem.patch
cgroup-api-files-make-cgroup_debug-default-to-off.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
signals-consolidate-checks-for-whether-or-not-to-ignore-a-signal.patch
signals-clean-dequeue_signal-from-excess-checks-and-assignments.patch
signals-consolidate-send_sigqueue-and-send_group_sigqueue.patch
signals-cleanup-security_task_kill-usage-implementation.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
use-find_task_by_vpid-in-taskstats.patch
deprecate-find_task_by_pid.patch
pidns-make-pid-level-and-pid_ns-level-unsigned.patch
reiser4.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch
