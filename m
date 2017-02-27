From: akpm@linux-foundation.org
Subject: [merged] procfs-use-an-enum-for-possible-hidepid-values.patch
 removed from -mm tree
Date: Mon, 27 Feb 2017 12:28:30 -0800
Message-ID: <58b48bee.BlGs7FVm2UcnwJuE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60730 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751637AbdB0U2b (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 15:28:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wluikil@gmail.com, keescook@chromium.org, tixxdz@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs: use an enum for possible hidepid values
has been removed from the -mm tree.  Its filename was
     procfs-use-an-enum-for-possible-hidepid-values.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lafcadio Wluiki <wluikil@gmail.com>
Subject: procfs: use an enum for possible hidepid values

Previously, the hidepid parameter was checked by comparing literal
integers 0, 1, 2.  Let's add a proper enum for this, to make the checking
more expressive:

        0 → HIDEPID_OFF
        1 → HIDEPID_NO_ACCESS
        2 → HIDEPID_INVISIBLE

This changes the internal labelling only, the userspace-facing interface
remains unmodified, and still works with literal integers 0, 1, 2.

No functional changes.

Link: http://lkml.kernel.org/r/1484572984-13388-2-git-send-email-djalal@gmail.com
Signed-off-by: Lafcadio Wluiki <wluikil@gmail.com>
Signed-off-by: Djalal Harouni <tixxdz@gmail.com>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c                |    8 ++++----
 fs/proc/inode.c               |    2 +-
 fs/proc/root.c                |    3 ++-
 include/linux/pid_namespace.h |    6 ++++++
 4 files changed, 13 insertions(+), 6 deletions(-)

diff -puN fs/proc/base.c~procfs-use-an-enum-for-possible-hidepid-values fs/proc/base.c
--- a/fs/proc/base.c~procfs-use-an-enum-for-possible-hidepid-values
+++ a/fs/proc/base.c
@@ -697,11 +697,11 @@ static int proc_pid_permission(struct in
 	task = get_proc_task(inode);
 	if (!task)
 		return -ESRCH;
-	has_perms = has_pid_permissions(pid, task, 1);
+	has_perms = has_pid_permissions(pid, task, HIDEPID_NO_ACCESS);
 	put_task_struct(task);
 
 	if (!has_perms) {
-		if (pid->hide_pid == 2) {
+		if (pid->hide_pid == HIDEPID_INVISIBLE) {
 			/*
 			 * Let's make getdents(), stat(), and open()
 			 * consistent with each other.  If a process
@@ -1737,7 +1737,7 @@ int pid_getattr(struct vfsmount *mnt, st
 	stat->gid = GLOBAL_ROOT_GID;
 	task = pid_task(proc_pid(inode), PIDTYPE_PID);
 	if (task) {
-		if (!has_pid_permissions(pid, task, 2)) {
+		if (!has_pid_permissions(pid, task, HIDEPID_INVISIBLE)) {
 			rcu_read_unlock();
 			/*
 			 * This doesn't prevent learning whether PID exists,
@@ -3168,7 +3168,7 @@ int proc_pid_readdir(struct file *file,
 		int len;
 
 		cond_resched();
-		if (!has_pid_permissions(ns, iter.task, 2))
+		if (!has_pid_permissions(ns, iter.task, HIDEPID_INVISIBLE))
 			continue;
 
 		len = snprintf(name, sizeof(name), "%d", iter.tgid);
diff -puN fs/proc/inode.c~procfs-use-an-enum-for-possible-hidepid-values fs/proc/inode.c
--- a/fs/proc/inode.c~procfs-use-an-enum-for-possible-hidepid-values
+++ a/fs/proc/inode.c
@@ -107,7 +107,7 @@ static int proc_show_options(struct seq_
 
 	if (!gid_eq(pid->pid_gid, GLOBAL_ROOT_GID))
 		seq_printf(seq, ",gid=%u", from_kgid_munged(&init_user_ns, pid->pid_gid));
-	if (pid->hide_pid != 0)
+	if (pid->hide_pid != HIDEPID_OFF)
 		seq_printf(seq, ",hidepid=%u", pid->hide_pid);
 
 	return 0;
diff -puN fs/proc/root.c~procfs-use-an-enum-for-possible-hidepid-values fs/proc/root.c
--- a/fs/proc/root.c~procfs-use-an-enum-for-possible-hidepid-values
+++ a/fs/proc/root.c
@@ -58,7 +58,8 @@ int proc_parse_options(char *options, st
 		case Opt_hidepid:
 			if (match_int(&args[0], &option))
 				return 0;
-			if (option < 0 || option > 2) {
+			if (option < HIDEPID_OFF ||
+			    option > HIDEPID_INVISIBLE) {
 				pr_err("proc: hidepid value must be between 0 and 2.\n");
 				return 0;
 			}
diff -puN include/linux/pid_namespace.h~procfs-use-an-enum-for-possible-hidepid-values include/linux/pid_namespace.h
--- a/include/linux/pid_namespace.h~procfs-use-an-enum-for-possible-hidepid-values
+++ a/include/linux/pid_namespace.h
@@ -21,6 +21,12 @@ struct pidmap {
 
 struct fs_pin;
 
+enum { /* definitions for pid_namespace's hide_pid field */
+	HIDEPID_OFF	  = 0,
+	HIDEPID_NO_ACCESS = 1,
+	HIDEPID_INVISIBLE = 2,
+};
+
 struct pid_namespace {
 	struct kref kref;
 	struct pidmap pidmap[PIDMAP_ENTRIES];
_

Patches currently in -mm which might be from wluikil@gmail.com are


