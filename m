From: akpm@linux-foundation.org
Subject: - security-filesystem-capabilities-refactor-kernel-code.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:24:53 -0700
Message-ID: <200807242324.m6ONOrAc010820@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33174 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756274AbYGXXaz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:30:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: morgan@kernel.org, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     security: filesystem capabilities refactor kernel code
has been removed from the -mm tree.  Its filename was
     security-filesystem-capabilities-refactor-kernel-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: security: filesystem capabilities refactor kernel code
From: Andrew G. Morgan <morgan@kernel.org>

To date, we've tried hard to confine filesystem support for capabilities
to the security modules.  This has left a lot of the code in
kernel/capability.c in a state where it looks like it supports something
that filesystem support for capabilities actually suppresses when the LSM
security/commmoncap.c code runs.  What is left is a lot of code that uses
sub-optimal locking in the main kernel

With this change we refactor the main kernel code and make it explicit
which locks are needed and that the only remaining kernel races in this
area are associated with non-filesystem capability code.

Signed-off-by: Andrew G. Morgan <morgan@kernel.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/capability.c |  338 +++++++++++++++++++++++++++---------------
 1 file changed, 221 insertions(+), 117 deletions(-)

diff -puN kernel/capability.c~security-filesystem-capabilities-refactor-kernel-code kernel/capability.c
--- a/kernel/capability.c~security-filesystem-capabilities-refactor-kernel-code
+++ a/kernel/capability.c
@@ -115,11 +115,208 @@ static int cap_validate_magic(cap_user_h
 	return 0;
 }
 
+#ifndef CONFIG_SECURITY_FILE_CAPABILITIES
+
+/*
+ * Without filesystem capability support, we nominally support one process
+ * setting the capabilities of another
+ */
+static inline int cap_get_target_pid(pid_t pid, kernel_cap_t *pEp,
+				     kernel_cap_t *pIp, kernel_cap_t *pPp)
+{
+	struct task_struct *target;
+	int ret;
+
+	spin_lock(&task_capability_lock);
+	read_lock(&tasklist_lock);
+
+	if (pid && pid != task_pid_vnr(current)) {
+		target = find_task_by_vpid(pid);
+		if (!target) {
+			ret = -ESRCH;
+			goto out;
+		}
+	} else
+		target = current;
+
+	ret = security_capget(target, pEp, pIp, pPp);
+
+out:
+	read_unlock(&tasklist_lock);
+	spin_unlock(&task_capability_lock);
+
+	return ret;
+}
+
+/*
+ * cap_set_pg - set capabilities for all processes in a given process
+ * group.  We call this holding task_capability_lock and tasklist_lock.
+ */
+static inline int cap_set_pg(int pgrp_nr, kernel_cap_t *effective,
+			     kernel_cap_t *inheritable,
+			     kernel_cap_t *permitted)
+{
+	struct task_struct *g, *target;
+	int ret = -EPERM;
+	int found = 0;
+	struct pid *pgrp;
+
+	spin_lock(&task_capability_lock);
+	read_lock(&tasklist_lock);
+
+	pgrp = find_vpid(pgrp_nr);
+	do_each_pid_task(pgrp, PIDTYPE_PGID, g) {
+		target = g;
+		while_each_thread(g, target) {
+			if (!security_capset_check(target, effective,
+						   inheritable, permitted)) {
+				security_capset_set(target, effective,
+						    inheritable, permitted);
+				ret = 0;
+			}
+			found = 1;
+		}
+	} while_each_pid_task(pgrp, PIDTYPE_PGID, g);
+
+	read_unlock(&tasklist_lock);
+	spin_unlock(&task_capability_lock);
+
+	if (!found)
+		ret = 0;
+	return ret;
+}
+
+/*
+ * cap_set_all - set capabilities for all processes other than init
+ * and self.  We call this holding task_capability_lock and tasklist_lock.
+ */
+static inline int cap_set_all(kernel_cap_t *effective,
+			      kernel_cap_t *inheritable,
+			      kernel_cap_t *permitted)
+{
+	struct task_struct *g, *target;
+	int ret = -EPERM;
+	int found = 0;
+
+	spin_lock(&task_capability_lock);
+	read_lock(&tasklist_lock);
+
+	do_each_thread(g, target) {
+		if (target == current
+		    || is_container_init(target->group_leader))
+			continue;
+		found = 1;
+		if (security_capset_check(target, effective, inheritable,
+					  permitted))
+			continue;
+		ret = 0;
+		security_capset_set(target, effective, inheritable, permitted);
+	} while_each_thread(g, target);
+
+	read_unlock(&tasklist_lock);
+	spin_unlock(&task_capability_lock);
+
+	if (!found)
+		ret = 0;
+
+	return ret;
+}
+
+/*
+ * Given the target pid does not refer to the current process we
+ * need more elaborate support... (This support is not present when
+ * filesystem capabilities are configured.)
+ */
+static inline int do_sys_capset_other_tasks(pid_t pid, kernel_cap_t *effective,
+					    kernel_cap_t *inheritable,
+					    kernel_cap_t *permitted)
+{
+	struct task_struct *target;
+	int ret;
+
+	if (!capable(CAP_SETPCAP))
+		return -EPERM;
+
+	if (pid == -1)	          /* all procs other than current and init */
+		return cap_set_all(effective, inheritable, permitted);
+
+	else if (pid < 0)                    /* all procs in process group */
+		return cap_set_pg(-pid, effective, inheritable, permitted);
+
+	/* target != current */
+	spin_lock(&task_capability_lock);
+	read_lock(&tasklist_lock);
+
+	target = find_task_by_vpid(pid);
+	if (!target)
+		ret = -ESRCH;
+	else {
+		ret = security_capset_check(target, effective, inheritable,
+					    permitted);
+
+		/* having verified that the proposed changes are legal,
+		   we now put them into effect. */
+		if (!ret)
+			security_capset_set(target, effective, inheritable,
+					    permitted);
+	}
+
+	read_unlock(&tasklist_lock);
+	spin_unlock(&task_capability_lock);
+
+	return ret;
+}
+
+#else /* ie., def CONFIG_SECURITY_FILE_CAPABILITIES */
+
+/*
+ * If we have configured with filesystem capability support, then the
+ * only thing that can change the capabilities of the current process
+ * is the current process. As such, we can't be in this code at the
+ * same time as we are in the process of setting capabilities in this
+ * process. The net result is that we can limit our use of locks to
+ * when we are reading the caps of another process.
+ */
+static inline int cap_get_target_pid(pid_t pid, kernel_cap_t *pEp,
+				     kernel_cap_t *pIp, kernel_cap_t *pPp)
+{
+	int ret;
+
+	if (pid && (pid != task_pid_vnr(current))) {
+		struct task_struct *target;
+
+		spin_lock(&task_capability_lock);
+		read_lock(&tasklist_lock);
+
+		target = find_task_by_vpid(pid);
+		if (!target)
+			ret = -ESRCH;
+		else
+			ret = security_capget(target, pEp, pIp, pPp);
+
+		read_unlock(&tasklist_lock);
+		spin_unlock(&task_capability_lock);
+	} else
+		ret = security_capget(current, pEp, pIp, pPp);
+
+	return ret;
+}
+
 /*
- * For sys_getproccap() and sys_setproccap(), any of the three
- * capability set pointers may be NULL -- indicating that that set is
- * uninteresting and/or not to be changed.
+ * With filesystem capability support configured, the kernel does not
+ * permit the changing of capabilities in one process by another
+ * process. (CAP_SETPCAP has much less broad semantics when configured
+ * this way.)
  */
+static inline int do_sys_capset_other_tasks(pid_t pid,
+					    kernel_cap_t *effective,
+					    kernel_cap_t *inheritable,
+					    kernel_cap_t *permitted)
+{
+	return -EPERM;
+}
+
+#endif /* ie., ndef CONFIG_SECURITY_FILE_CAPABILITIES */
 
 /*
  * Atomically modify the effective capabilities returning the original
@@ -155,7 +352,6 @@ asmlinkage long sys_capget(cap_user_head
 {
 	int ret = 0;
 	pid_t pid;
-	struct task_struct *target;
 	unsigned tocopy;
 	kernel_cap_t pE, pI, pP;
 
@@ -169,23 +365,7 @@ asmlinkage long sys_capget(cap_user_head
 	if (pid < 0)
 		return -EINVAL;
 
-	spin_lock(&task_capability_lock);
-	read_lock(&tasklist_lock);
-
-	if (pid && pid != task_pid_vnr(current)) {
-		target = find_task_by_vpid(pid);
-		if (!target) {
-			ret = -ESRCH;
-			goto out;
-		}
-	} else
-		target = current;
-
-	ret = security_capget(target, &pE, &pI, &pP);
-
-out:
-	read_unlock(&tasklist_lock);
-	spin_unlock(&task_capability_lock);
+	ret = cap_get_target_pid(pid, &pE, &pI, &pP);
 
 	if (!ret) {
 		struct __user_cap_data_struct kdata[_KERNEL_CAPABILITY_U32S];
@@ -216,7 +396,6 @@ out:
 		 * before modification is attempted and the application
 		 * fails.
 		 */
-
 		if (copy_to_user(dataptr, kdata, tocopy
 				 * sizeof(struct __user_cap_data_struct))) {
 			return -EFAULT;
@@ -226,70 +405,8 @@ out:
 	return ret;
 }
 
-/*
- * cap_set_pg - set capabilities for all processes in a given process
- * group.  We call this holding task_capability_lock and tasklist_lock.
- */
-static inline int cap_set_pg(int pgrp_nr, kernel_cap_t *effective,
-			      kernel_cap_t *inheritable,
-			      kernel_cap_t *permitted)
-{
-	struct task_struct *g, *target;
-	int ret = -EPERM;
-	int found = 0;
-	struct pid *pgrp;
-
-	pgrp = find_vpid(pgrp_nr);
-	do_each_pid_task(pgrp, PIDTYPE_PGID, g) {
-		target = g;
-		while_each_thread(g, target) {
-			if (!security_capset_check(target, effective,
-							inheritable,
-							permitted)) {
-				security_capset_set(target, effective,
-							inheritable,
-							permitted);
-				ret = 0;
-			}
-			found = 1;
-		}
-	} while_each_pid_task(pgrp, PIDTYPE_PGID, g);
-
-	if (!found)
-		ret = 0;
-	return ret;
-}
-
-/*
- * cap_set_all - set capabilities for all processes other than init
- * and self.  We call this holding task_capability_lock and tasklist_lock.
- */
-static inline int cap_set_all(kernel_cap_t *effective,
-			       kernel_cap_t *inheritable,
-			       kernel_cap_t *permitted)
-{
-     struct task_struct *g, *target;
-     int ret = -EPERM;
-     int found = 0;
-
-     do_each_thread(g, target) {
-             if (target == current || is_container_init(target->group_leader))
-                     continue;
-             found = 1;
-	     if (security_capset_check(target, effective, inheritable,
-						permitted))
-		     continue;
-	     ret = 0;
-	     security_capset_set(target, effective, inheritable, permitted);
-     } while_each_thread(g, target);
-
-     if (!found)
-	     ret = 0;
-     return ret;
-}
-
 /**
- * sys_capset - set capabilities for a process or a group of processes
+ * sys_capset - set capabilities for a process or (*) a group of processes
  * @header: pointer to struct that contains capability version and
  *	target pid data
  * @data: pointer to struct that contains the effective, permitted,
@@ -313,7 +430,6 @@ asmlinkage long sys_capset(cap_user_head
 	struct __user_cap_data_struct kdata[_KERNEL_CAPABILITY_U32S];
 	unsigned i, tocopy;
 	kernel_cap_t inheritable, permitted, effective;
-	struct task_struct *target;
 	int ret;
 	pid_t pid;
 
@@ -324,9 +440,6 @@ asmlinkage long sys_capset(cap_user_head
 	if (get_user(pid, &header->pid))
 		return -EFAULT;
 
-	if (pid && pid != task_pid_vnr(current) && !capable(CAP_SETPCAP))
-		return -EPERM;
-
 	if (copy_from_user(&kdata, data, tocopy
 			   * sizeof(struct __user_cap_data_struct))) {
 		return -EFAULT;
@@ -344,40 +457,31 @@ asmlinkage long sys_capset(cap_user_head
 		i++;
 	}
 
-	spin_lock(&task_capability_lock);
-	read_lock(&tasklist_lock);
-
-	if (pid > 0 && pid != task_pid_vnr(current)) {
-		target = find_task_by_vpid(pid);
-		if (!target) {
-			ret = -ESRCH;
-			goto out;
-		}
-	} else
-		target = current;
-
-	ret = 0;
+	if (pid && (pid != task_pid_vnr(current)))
+		ret = do_sys_capset_other_tasks(pid, &effective, &inheritable,
+						&permitted);
+	else {
+		/*
+		 * This lock is required even when filesystem
+		 * capability support is configured - it protects the
+		 * sys_capget() call from returning incorrect data in
+		 * the case that the targeted process is not the
+		 * current one.
+		 */
+		spin_lock(&task_capability_lock);
 
-	/* having verified that the proposed changes are legal,
-	   we now put them into effect. */
-	if (pid < 0) {
-		if (pid == -1)	/* all procs other than current and init */
-			ret = cap_set_all(&effective, &inheritable, &permitted);
-
-		else		/* all procs in process group */
-			ret = cap_set_pg(-pid, &effective, &inheritable,
-					 &permitted);
-	} else {
-		ret = security_capset_check(target, &effective, &inheritable,
+		ret = security_capset_check(current, &effective, &inheritable,
 					    &permitted);
+		/*
+		 * Having verified that the proposed changes are
+		 * legal, we now put them into effect.
+		 */
 		if (!ret)
-			security_capset_set(target, &effective, &inheritable,
+			security_capset_set(current, &effective, &inheritable,
 					    &permitted);
+		spin_unlock(&task_capability_lock);
 	}
 
-out:
-	read_unlock(&tasklist_lock);
-	spin_unlock(&task_capability_lock);
 
 	return ret;
 }
_

Patches currently in -mm which might be from morgan@kernel.org are

origin.patch
sysctl-allow-override-of-proc-sys-net-with-cap_net_admin.patch

