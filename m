From: akpm@linux-foundation.org
Subject: - sysctl-clean-from-unneeded-extern-and-forward-declarations.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:47:46 -0700
Message-ID: <200804300547.m3U5lkfR029733@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37517 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758682AbYD3Fs5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:48:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, adobriyan@sw.ru, davem@davemloft.net, den@openvz.org, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     sysctl: clean from unneeded extern and forward declarations
has been removed from the -mm tree.  Its filename was
     sysctl-clean-from-unneeded-extern-and-forward-declarations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl: clean from unneeded extern and forward declarations
From: Pavel Emelyanov <xemul@openvz.org>

The do_sysctl_strategy isn't used outside kernel/sysctl.c, so this can be
static and without a prototype in header.

Besides, move this one and parse_table() above their callers and drop the
forward declarations of the latter call.

One more "besides" - fix two checkpatch warnings: space before a ( and an
extra space at the end of a line.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Denis V. Lunev <den@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sysctl.h |    5 -
 kernel/sysctl.c        |  144 ++++++++++++++++++---------------------
 2 files changed, 68 insertions(+), 81 deletions(-)

diff -puN include/linux/sysctl.h~sysctl-clean-from-unneeded-extern-and-forward-declarations include/linux/sysctl.h
--- a/include/linux/sysctl.h~sysctl-clean-from-unneeded-extern-and-forward-declarations
+++ a/include/linux/sysctl.h
@@ -981,11 +981,6 @@ extern int do_sysctl (int __user *name, 
 		      void __user *oldval, size_t __user *oldlenp,
 		      void __user *newval, size_t newlen);
 
-extern int do_sysctl_strategy (struct ctl_table *table,
-			       int __user *name, int nlen,
-			       void __user *oldval, size_t __user *oldlenp,
-			       void __user *newval, size_t newlen);
-
 extern ctl_handler sysctl_data;
 extern ctl_handler sysctl_string;
 extern ctl_handler sysctl_intvec;
diff -puN kernel/sysctl.c~sysctl-clean-from-unneeded-extern-and-forward-declarations kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-clean-from-unneeded-extern-and-forward-declarations
+++ a/kernel/sysctl.c
@@ -145,12 +145,6 @@ extern int no_unaligned_warning;
 extern int max_lock_depth;
 #endif
 
-#ifdef CONFIG_SYSCTL_SYSCALL
-static int parse_table(int __user *, int, void __user *, size_t __user *,
-		void __user *, size_t, struct ctl_table *);
-#endif
-
-
 #ifdef CONFIG_PROC_SYSCTL
 static int proc_do_cad_pid(struct ctl_table *table, int write, struct file *filp,
 		  void __user *buffer, size_t *lenp, loff_t *ppos);
@@ -1439,6 +1433,74 @@ void register_sysctl_root(struct ctl_tab
 }
 
 #ifdef CONFIG_SYSCTL_SYSCALL
+/* Perform the actual read/write of a sysctl table entry. */
+static int do_sysctl_strategy(struct ctl_table *table,
+			int __user *name, int nlen,
+			void __user *oldval, size_t __user *oldlenp,
+			void __user *newval, size_t newlen)
+{
+	int op = 0, rc;
+
+	if (oldval)
+		op |= 004;
+	if (newval)
+		op |= 002;
+	if (sysctl_perm(table, op))
+		return -EPERM;
+
+	if (table->strategy) {
+		rc = table->strategy(table, name, nlen, oldval, oldlenp,
+				     newval, newlen);
+		if (rc < 0)
+			return rc;
+		if (rc > 0)
+			return 0;
+	}
+
+	/* If there is no strategy routine, or if the strategy returns
+	 * zero, proceed with automatic r/w */
+	if (table->data && table->maxlen) {
+		rc = sysctl_data(table, name, nlen, oldval, oldlenp,
+				 newval, newlen);
+		if (rc < 0)
+			return rc;
+	}
+	return 0;
+}
+
+static int parse_table(int __user *name, int nlen,
+		       void __user *oldval, size_t __user *oldlenp,
+		       void __user *newval, size_t newlen,
+		       struct ctl_table *table)
+{
+	int n;
+repeat:
+	if (!nlen)
+		return -ENOTDIR;
+	if (get_user(n, name))
+		return -EFAULT;
+	for ( ; table->ctl_name || table->procname; table++) {
+		if (!table->ctl_name)
+			continue;
+		if (n == table->ctl_name) {
+			int error;
+			if (table->child) {
+				if (sysctl_perm(table, 001))
+					return -EPERM;
+				name++;
+				nlen--;
+				table = table->child;
+				goto repeat;
+			}
+			error = do_sysctl_strategy(table, name, nlen,
+						   oldval, oldlenp,
+						   newval, newlen);
+			return error;
+		}
+	}
+	return -ENOTDIR;
+}
+
 int do_sysctl(int __user *name, int nlen, void __user *oldval, size_t __user *oldlenp,
 	       void __user *newval, size_t newlen)
 {
@@ -1511,76 +1573,6 @@ int sysctl_perm(struct ctl_table *table,
 	return test_perm(table->mode, op);
 }
 
-#ifdef CONFIG_SYSCTL_SYSCALL
-static int parse_table(int __user *name, int nlen,
-		       void __user *oldval, size_t __user *oldlenp,
-		       void __user *newval, size_t newlen,
-		       struct ctl_table *table)
-{
-	int n;
-repeat:
-	if (!nlen)
-		return -ENOTDIR;
-	if (get_user(n, name))
-		return -EFAULT;
-	for ( ; table->ctl_name || table->procname; table++) {
-		if (!table->ctl_name)
-			continue;
-		if (n == table->ctl_name) {
-			int error;
-			if (table->child) {
-				if (sysctl_perm(table, 001))
-					return -EPERM;
-				name++;
-				nlen--;
-				table = table->child;
-				goto repeat;
-			}
-			error = do_sysctl_strategy(table, name, nlen,
-						   oldval, oldlenp,
-						   newval, newlen);
-			return error;
-		}
-	}
-	return -ENOTDIR;
-}
-
-/* Perform the actual read/write of a sysctl table entry. */
-int do_sysctl_strategy (struct ctl_table *table,
-			int __user *name, int nlen,
-			void __user *oldval, size_t __user *oldlenp,
-			void __user *newval, size_t newlen)
-{
-	int op = 0, rc;
-
-	if (oldval)
-		op |= 004;
-	if (newval) 
-		op |= 002;
-	if (sysctl_perm(table, op))
-		return -EPERM;
-
-	if (table->strategy) {
-		rc = table->strategy(table, name, nlen, oldval, oldlenp,
-				     newval, newlen);
-		if (rc < 0)
-			return rc;
-		if (rc > 0)
-			return 0;
-	}
-
-	/* If there is no strategy routine, or if the strategy returns
-	 * zero, proceed with automatic r/w */
-	if (table->data && table->maxlen) {
-		rc = sysctl_data(table, name, nlen, oldval, oldlenp,
-				 newval, newlen);
-		if (rc < 0)
-			return rc;
-	}
-	return 0;
-}
-#endif /* CONFIG_SYSCTL_SYSCALL */
-
 static void sysctl_set_parent(struct ctl_table *parent, struct ctl_table *table)
 {
 	for (; table->ctl_name || table->procname; table++) {
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

