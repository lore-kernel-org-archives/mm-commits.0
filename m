From: akpm@linux-foundation.org
Subject: + sysctl-add-the-permissions-callback-on-the-ctl_table_root.patch added to -mm tree
Date: Thu, 28 Feb 2008 12:36:09 -0800
Message-ID: <200802282036.m1SKaAcg019204@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:59433 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932575AbYB1UhA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Feb 2008 15:37:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, adobriyan@sw.ru, davem@davemloft.net, den@openvz.org, ebiederm@xmission.com


The patch titled
     sysctl: add the ->permissions callback on the ctl_table_root
has been added to the -mm tree.  Its filename is
     sysctl-add-the-permissions-callback-on-the-ctl_table_root.patch

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
Subject: sysctl: add the ->permissions callback on the ctl_table_root
From: Pavel Emelyanov <xemul@openvz.org>

When reading from/writing to some table, a root, which this table came from,
may affect this table's permissions, depending on who is working with the
table.

The core hunk is at the bottom of this patch.  All the rest is just pushing
the ctl_table_root argument up to the sysctl_perm() function.

This will be mostly (only?) used in the net sysctls.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Denis V. Lunev <den@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_sysctl.c  |    4 ++--
 include/linux/sysctl.h |    7 ++++++-
 kernel/sysctl.c        |   25 ++++++++++++++++++-------
 3 files changed, 26 insertions(+), 10 deletions(-)

diff -puN fs/proc/proc_sysctl.c~sysctl-add-the-permissions-callback-on-the-ctl_table_root fs/proc/proc_sysctl.c
--- a/fs/proc/proc_sysctl.c~sysctl-add-the-permissions-callback-on-the-ctl_table_root
+++ a/fs/proc/proc_sysctl.c
@@ -190,7 +190,7 @@ static ssize_t proc_sys_call_handler(str
 	 * and won't be until we finish.
 	 */
 	error = -EPERM;
-	if (sysctl_perm(table, write ? MAY_WRITE : MAY_READ))
+	if (sysctl_perm(head->root, table, write ? MAY_WRITE : MAY_READ))
 		goto out;
 
 	/* careful: calling conventions are nasty here */
@@ -388,7 +388,7 @@ static int proc_sys_permission(struct in
 		goto out;
 
 	/* Use the permissions on the sysctl table entry */
-	error = sysctl_perm(table, mask);
+	error = sysctl_perm(head->root, table, mask);
 out:
 	sysctl_head_finish(head);
 	return error;
diff -puN include/linux/sysctl.h~sysctl-add-the-permissions-callback-on-the-ctl_table_root include/linux/sysctl.h
--- a/include/linux/sysctl.h~sysctl-add-the-permissions-callback-on-the-ctl_table_root
+++ a/include/linux/sysctl.h
@@ -945,11 +945,14 @@ enum
 /* For the /proc/sys support */
 struct ctl_table;
 struct nsproxy;
+struct ctl_table_root;
+
 extern struct ctl_table_header *sysctl_head_next(struct ctl_table_header *prev);
 extern struct ctl_table_header *__sysctl_head_next(struct nsproxy *namespaces,
 						struct ctl_table_header *prev);
 extern void sysctl_head_finish(struct ctl_table_header *prev);
-extern int sysctl_perm(struct ctl_table *table, int op);
+extern int sysctl_perm(struct ctl_table_root *root,
+		struct ctl_table *table, int op);
 
 typedef struct ctl_table ctl_table;
 
@@ -1049,6 +1052,8 @@ struct ctl_table_root {
 	struct list_head header_list;
 	struct list_head *(*lookup)(struct ctl_table_root *root,
 					   struct nsproxy *namespaces);
+	int (*permissions)(struct ctl_table_root *root,
+			struct nsproxy *namespaces, struct ctl_table *table);
 };
 
 /* struct ctl_table_header is used to maintain dynamic lists of
diff -puN kernel/sysctl.c~sysctl-add-the-permissions-callback-on-the-ctl_table_root kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-add-the-permissions-callback-on-the-ctl_table_root
+++ a/kernel/sysctl.c
@@ -1454,7 +1454,8 @@ void register_sysctl_root(struct ctl_tab
 
 #ifdef CONFIG_SYSCTL_SYSCALL
 /* Perform the actual read/write of a sysctl table entry. */
-static int do_sysctl_strategy(struct ctl_table *table,
+static int do_sysctl_strategy(struct ctl_table_root *root,
+			struct ctl_table *table,
 			int __user *name, int nlen,
 			void __user *oldval, size_t __user *oldlenp,
 			void __user *newval, size_t newlen)
@@ -1465,7 +1466,7 @@ static int do_sysctl_strategy(struct ctl
 		op |= 004;
 	if (newval)
 		op |= 002;
-	if (sysctl_perm(table, op))
+	if (sysctl_perm(root, table, op))
 		return -EPERM;
 
 	if (table->strategy) {
@@ -1491,6 +1492,7 @@ static int do_sysctl_strategy(struct ctl
 static int parse_table(int __user *name, int nlen,
 		       void __user *oldval, size_t __user *oldlenp,
 		       void __user *newval, size_t newlen,
+		       struct ctl_table_root *root,
 		       struct ctl_table *table)
 {
 	int n;
@@ -1505,14 +1507,14 @@ repeat:
 		if (n == table->ctl_name) {
 			int error;
 			if (table->child) {
-				if (sysctl_perm(table, 001))
+				if (sysctl_perm(root, table, 001))
 					return -EPERM;
 				name++;
 				nlen--;
 				table = table->child;
 				goto repeat;
 			}
-			error = do_sysctl_strategy(table, name, nlen,
+			error = do_sysctl_strategy(root, table, name, nlen,
 						   oldval, oldlenp,
 						   newval, newlen);
 			return error;
@@ -1538,7 +1540,8 @@ int do_sysctl(int __user *name, int nlen
 	for (head = sysctl_head_next(NULL); head;
 			head = sysctl_head_next(head)) {
 		error = parse_table(name, nlen, oldval, oldlenp, 
-					newval, newlen, head->ctl_table);
+					newval, newlen,
+					head->root, head->ctl_table);
 		if (error != -ENOTDIR) {
 			sysctl_head_finish(head);
 			break;
@@ -1584,13 +1587,21 @@ static int test_perm(int mode, int op)
 	return -EACCES;
 }
 
-int sysctl_perm(struct ctl_table *table, int op)
+int sysctl_perm(struct ctl_table_root *root, struct ctl_table *table, int op)
 {
 	int error;
+	int mode;
+
 	error = security_sysctl(table, op);
 	if (error)
 		return error;
-	return test_perm(table->mode, op);
+
+	if (root->permissions)
+		mode = root->permissions(root, current->nsproxy, table);
+	else
+		mode = table->mode;
+
+	return test_perm(mode, op);
 }
 
 static void sysctl_set_parent(struct ctl_table *parent, struct ctl_table *table)
_

Patches currently in -mm which might be from xemul@openvz.org are

control-groups-add-paul-menage-a-maintainer.patch
add-balbir-as-the-maintainer-for-memory-resource-controller.patch
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
sysctl-merge-equal-proc_sys_read-and-proc_sys_write.patch
sysctl-clean-from-unneeded-extern-and-forward-declarations.patch
sysctl-add-the-permissions-callback-on-the-ctl_table_root.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
use-find_task_by_vpid-in-taskstats.patch
deprecate-find_task_by_pid.patch
pidns-make-pid-level-and-pid_ns-level-unsigned.patch
reiser4.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

