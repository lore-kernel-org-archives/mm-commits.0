From: akpm@linux-foundation.org
Subject: + sysctl-clean-from-unneeded-extern-and-forward-declarations.patch added to -mm tree
Date: Thu, 28 Feb 2008 12:36:06 -0800
Message-ID: <200802282036.m1SKa6w5019201@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:56904 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932585AbYB1UhB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Feb 2008 15:37:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, adobriyan@sw.ru, davem@davemloft.net, den@openvz.org, ebiederm@xmission.com


The patch titled
     sysctl: clean from unneeded extern and forward declarations
has been added to the -mm tree.  Its filename is
     sysctl-clean-from-unneeded-extern-and-forward-declarations.patch

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
@@ -1459,6 +1453,74 @@ void register_sysctl_root(struct ctl_tab
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
@@ -1531,76 +1593,6 @@ int sysctl_perm(struct ctl_table *table,
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

