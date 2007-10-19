From: akpm@linux-foundation.org
Subject: - whitespace-fixes-capability-syscalls.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:43:48 -0700
Message-ID: <200710190343.l9J3hmxm013095@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33923 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966529AbXJSD4N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:56:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, chrisw@sous-sol.org, mm-commits@vger.kernel.org


The patch titled
     whitespace fixes: capability syscalls
has been removed from the -mm tree.  Its filename was
     whitespace-fixes-capability-syscalls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: whitespace fixes: capability syscalls
From: Daniel Walker <dwalker@mvista.com>

Large chunks of 5 spaces instead of tabs.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/capability.c |  198 +++++++++++++++++++++---------------------
 1 file changed, 99 insertions(+), 99 deletions(-)

diff -puN kernel/capability.c~whitespace-fixes-capability-syscalls kernel/capability.c
--- a/kernel/capability.c~whitespace-fixes-capability-syscalls
+++ a/kernel/capability.c
@@ -5,7 +5,7 @@
  *
  * Integrated into 2.1.97+,  Andrew G. Morgan <morgan@kernel.org>
  * 30 May 2002:	Cleanup, Robert M. Love <rml@tech9.net>
- */ 
+ */
 
 #include <linux/capability.h>
 #include <linux/mm.h>
@@ -37,49 +37,49 @@ static DEFINE_SPINLOCK(task_capability_l
  */
 asmlinkage long sys_capget(cap_user_header_t header, cap_user_data_t dataptr)
 {
-     int ret = 0;
-     pid_t pid;
-     __u32 version;
-     struct task_struct *target;
-     struct __user_cap_data_struct data;
-
-     if (get_user(version, &header->version))
-	     return -EFAULT;
-
-     if (version != _LINUX_CAPABILITY_VERSION) {
-	     if (put_user(_LINUX_CAPABILITY_VERSION, &header->version))
-		     return -EFAULT; 
-             return -EINVAL;
-     }
-
-     if (get_user(pid, &header->pid))
-	     return -EFAULT;
-
-     if (pid < 0) 
-             return -EINVAL;
-
-     spin_lock(&task_capability_lock);
-     read_lock(&tasklist_lock); 
-
-     if (pid && pid != current->pid) {
-	     target = find_task_by_pid(pid);
-	     if (!target) {
-	          ret = -ESRCH;
-	          goto out;
-	     }
-     } else
-	     target = current;
+	int ret = 0;
+	pid_t pid;
+	__u32 version;
+	struct task_struct *target;
+	struct __user_cap_data_struct data;
+
+	if (get_user(version, &header->version))
+		return -EFAULT;
+
+	if (version != _LINUX_CAPABILITY_VERSION) {
+		if (put_user(_LINUX_CAPABILITY_VERSION, &header->version))
+			return -EFAULT;
+		return -EINVAL;
+	}
+
+	if (get_user(pid, &header->pid))
+		return -EFAULT;
+
+	if (pid < 0)
+		return -EINVAL;
+
+	spin_lock(&task_capability_lock);
+	read_lock(&tasklist_lock);
 
-     ret = security_capget(target, &data.effective, &data.inheritable, &data.permitted);
+	if (pid && pid != current->pid) {
+		target = find_task_by_pid(pid);
+		if (!target) {
+			ret = -ESRCH;
+			goto out;
+		}
+	} else
+		target = current;
+
+	ret = security_capget(target, &data.effective, &data.inheritable, &data.permitted);
 
 out:
-     read_unlock(&tasklist_lock); 
-     spin_unlock(&task_capability_lock);
+	read_unlock(&tasklist_lock);
+	spin_unlock(&task_capability_lock);
 
-     if (!ret && copy_to_user(dataptr, &data, sizeof data))
-          return -EFAULT; 
+	if (!ret && copy_to_user(dataptr, &data, sizeof data))
+		return -EFAULT;
 
-     return ret;
+	return ret;
 }
 
 /*
@@ -112,7 +112,7 @@ static inline int cap_set_pg(int pgrp_nr
 	} while_each_pid_task(pgrp, PIDTYPE_PGID, g);
 
 	if (!found)
-	     ret = 0;
+		ret = 0;
 	return ret;
 }
 
@@ -166,68 +166,68 @@ static inline int cap_set_all(kernel_cap
  */
 asmlinkage long sys_capset(cap_user_header_t header, const cap_user_data_t data)
 {
-     kernel_cap_t inheritable, permitted, effective;
-     __u32 version;
-     struct task_struct *target;
-     int ret;
-     pid_t pid;
-
-     if (get_user(version, &header->version))
-	     return -EFAULT; 
-
-     if (version != _LINUX_CAPABILITY_VERSION) {
-	     if (put_user(_LINUX_CAPABILITY_VERSION, &header->version))
-		     return -EFAULT; 
-             return -EINVAL;
-     }
-
-     if (get_user(pid, &header->pid))
-	     return -EFAULT; 
-
-     if (pid && pid != current->pid && !capable(CAP_SETPCAP))
-             return -EPERM;
-
-     if (copy_from_user(&effective, &data->effective, sizeof(effective)) ||
-	 copy_from_user(&inheritable, &data->inheritable, sizeof(inheritable)) ||
-	 copy_from_user(&permitted, &data->permitted, sizeof(permitted)))
-	     return -EFAULT; 
-
-     spin_lock(&task_capability_lock);
-     read_lock(&tasklist_lock);
-
-     if (pid > 0 && pid != current->pid) {
-          target = find_task_by_pid(pid);
-          if (!target) {
-               ret = -ESRCH;
-               goto out;
-          }
-     } else
-               target = current;
-
-     ret = 0;
-
-     /* having verified that the proposed changes are legal,
-           we now put them into effect. */
-     if (pid < 0) {
-             if (pid == -1)  /* all procs other than current and init */
-                     ret = cap_set_all(&effective, &inheritable, &permitted);
-
-             else            /* all procs in process group */
-                     ret = cap_set_pg(-pid, &effective, &inheritable,
-		     					&permitted);
-     } else {
-	     ret = security_capset_check(target, &effective, &inheritable,
-	     						&permitted);
-	     if (!ret)
-		     security_capset_set(target, &effective, &inheritable,
-		     					&permitted);
-     }
+	kernel_cap_t inheritable, permitted, effective;
+	__u32 version;
+	struct task_struct *target;
+	int ret;
+	pid_t pid;
+
+	if (get_user(version, &header->version))
+		return -EFAULT;
+
+	if (version != _LINUX_CAPABILITY_VERSION) {
+		if (put_user(_LINUX_CAPABILITY_VERSION, &header->version))
+			return -EFAULT;
+		return -EINVAL;
+	}
+
+	if (get_user(pid, &header->pid))
+		return -EFAULT;
+
+	if (pid && pid != current->pid && !capable(CAP_SETPCAP))
+		return -EPERM;
+
+	if (copy_from_user(&effective, &data->effective, sizeof(effective)) ||
+	    copy_from_user(&inheritable, &data->inheritable, sizeof(inheritable)) ||
+	    copy_from_user(&permitted, &data->permitted, sizeof(permitted)))
+		return -EFAULT;
+
+	spin_lock(&task_capability_lock);
+	read_lock(&tasklist_lock);
+
+	if (pid > 0 && pid != current->pid) {
+		target = find_task_by_pid(pid);
+		if (!target) {
+			ret = -ESRCH;
+			goto out;
+		}
+	} else
+		target = current;
+
+	ret = 0;
+
+	/* having verified that the proposed changes are legal,
+	   we now put them into effect. */
+	if (pid < 0) {
+		if (pid == -1)	/* all procs other than current and init */
+			ret = cap_set_all(&effective, &inheritable, &permitted);
+
+		else		/* all procs in process group */
+			ret = cap_set_pg(-pid, &effective, &inheritable,
+					 &permitted);
+	} else {
+		ret = security_capset_check(target, &effective, &inheritable,
+					    &permitted);
+		if (!ret)
+			security_capset_set(target, &effective, &inheritable,
+					    &permitted);
+	}
 
 out:
-     read_unlock(&tasklist_lock);
-     spin_unlock(&task_capability_lock);
+	read_unlock(&tasklist_lock);
+	spin_unlock(&task_capability_lock);
 
-     return ret;
+	return ret;
 }
 
 int __capable(struct task_struct *t, int cap)
_

Patches currently in -mm which might be from dwalker@mvista.com are

origin.patch
whitespace-fixes-task-exit-handling.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
