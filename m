From: akpm@linux-foundation.org
Subject: - sysctl-add-the-permissions-callback-on-the-ctl_table_root.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:47:49 -0700
Message-ID: <200804300547.m3U5lnkQ029736@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59053 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758657AbYD3Fs5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:48:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, adobriyan@sw.ru, davem@davemloft.net, den@openvz.org, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     sysctl: add the ->permissions callback on the ctl_table_root
has been removed from the -mm tree.  Its filename was
     sysctl-add-the-permissions-callback-on-the-ctl_table_root.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1434,7 +1434,8 @@ void register_sysctl_root(struct ctl_tab
 
 #ifdef CONFIG_SYSCTL_SYSCALL
 /* Perform the actual read/write of a sysctl table entry. */
-static int do_sysctl_strategy(struct ctl_table *table,
+static int do_sysctl_strategy(struct ctl_table_root *root,
+			struct ctl_table *table,
 			int __user *name, int nlen,
 			void __user *oldval, size_t __user *oldlenp,
 			void __user *newval, size_t newlen)
@@ -1445,7 +1446,7 @@ static int do_sysctl_strategy(struct ctl
 		op |= 004;
 	if (newval)
 		op |= 002;
-	if (sysctl_perm(table, op))
+	if (sysctl_perm(root, table, op))
 		return -EPERM;
 
 	if (table->strategy) {
@@ -1471,6 +1472,7 @@ static int do_sysctl_strategy(struct ctl
 static int parse_table(int __user *name, int nlen,
 		       void __user *oldval, size_t __user *oldlenp,
 		       void __user *newval, size_t newlen,
+		       struct ctl_table_root *root,
 		       struct ctl_table *table)
 {
 	int n;
@@ -1485,14 +1487,14 @@ repeat:
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
@@ -1518,7 +1520,8 @@ int do_sysctl(int __user *name, int nlen
 	for (head = sysctl_head_next(NULL); head;
 			head = sysctl_head_next(head)) {
 		error = parse_table(name, nlen, oldval, oldlenp, 
-					newval, newlen, head->ctl_table);
+					newval, newlen,
+					head->root, head->ctl_table);
 		if (error != -ENOTDIR) {
 			sysctl_head_finish(head);
 			break;
@@ -1564,13 +1567,21 @@ static int test_perm(int mode, int op)
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

origin.patch
disable-the-memory-controller-by-default-v3.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
signals-consolidate-checks-for-whether-or-not-to-ignore-a-signal.patch
signals-clean-dequeue_signal-from-excess-checks-and-assignments.patch
signals-consolidate-send_sigqueue-and-send_group_sigqueue.patch
signals-cleanup-security_task_kill-usage-implementation.patch
signals-use-__group_complete_signal-for-the-specific-signals-too.patch
signals-fold-complete_signal-into-send_signal-do_send_sigqueue.patch
signals-unify-send_sigqueue-send_group_sigqueue-completely.patch
ptrace-allow-to-ptrace-sbin-init.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
use-find_task_by_vpid-in-taskstats.patch
deprecate-find_task_by_pid.patch
deprecate-find_task_by_pid-warning-fix.patch
pids-de_thread-dont-clear-session-pgrp-pids-for-the-old-leader.patch
pids-introduce-change_pid-helper.patch
pids-sys_setpgid-use-change_pid-helper.patch
pids-__set_special_pids-use-change_pid-helper.patch
pidns-make-pid-level-and-pid_ns-level-unsigned.patch
reiser4.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

