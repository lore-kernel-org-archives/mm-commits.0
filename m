From: akpm@linux-foundation.org
Subject: + whitespace-fixes-capability-syscalls.patch added to -mm tree
Date: Fri, 20 Jul 2007 17:18:54 -0700
Message-ID: <200707210018.l6L0IsGp023896@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51036 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759814AbXGUAU3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 20:20:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwalker@mvista.com, chrisw@sous-sol.org


The patch titled
     whitespace fixes: capability syscalls
has been added to the -mm tree.  Its filename is
     whitespace-fixes-capability-syscalls.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: whitespace fixes: capability syscalls
From: Daniel Walker <dwalker@mvista.com>

Large chunks of 5 spaces instead of tabs.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/capability.c |  198 +++++++++++++++++++++---------------------
 1 files changed, 99 insertions(+), 99 deletions(-)

diff -puN kernel/capability.c~whitespace-fixes-capability-syscalls kernel/capability.c
--- a/kernel/capability.c~whitespace-fixes-capability-syscalls
+++ a/kernel/capability.c
@@ -5,7 +5,7 @@
  *
  * Integrated into 2.1.97+,  Andrew G. Morgan <morgan@transmeta.com>
  * 30 May 2002:	Cleanup, Robert M. Love <rml@tech9.net>
- */ 
+ */
 
 #include <linux/capability.h>
 #include <linux/mm.h>
@@ -44,49 +44,49 @@ static DEFINE_SPINLOCK(task_capability_l
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
@@ -119,7 +119,7 @@ static inline int cap_set_pg(int pgrp_nr
 	} while_each_pid_task(pgrp, PIDTYPE_PGID, g);
 
 	if (!found)
-	     ret = 0;
+		ret = 0;
 	return ret;
 }
 
@@ -173,68 +173,68 @@ static inline int cap_set_all(kernel_cap
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

whitespace-fixes-time-syscalls.patch
whitespace-fixes-process-accounting.patch
whitespace-fixes-cpuset.patch
whitespace-fixes-relayfs.patch
whitespace-fixes-audit-filtering.patch
whitespace-fixes-dma-channel-allocator.patch
whitespace-fixes-fork.patch
whitespace-fixes-module-loading.patch
whitespace-fixes-panic-handling.patch
whitespace-fixes-capability-syscalls.patch
whitespace-fixes-syscall-auditing.patch
whitespace-fixes-compat-syscalls.patch
whitespace-fixes-system-auditing.patch
whitespace-fixes-execution-domains.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
whitespace-fixes-task-exit-handling.patch
profile-likely-unlikely-macros.patch
