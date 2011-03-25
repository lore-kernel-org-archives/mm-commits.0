From: akpm@linux-foundation.org
Subject: [merged] userns-make-has_capability-into-real-functions.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:26:54 -0700
Message-ID: <201103250726.p2P7QmfN026181@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38320 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933642Ab1CYH06 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:26:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serge.hallyn@canonical.com, daniel.lezcano@free.fr, dhowells@redhat.com, ebiederm@xmission.com, jmorris@namei.org, mm-commits@vger.kernel.org


The patch titled
     userns: make has_capability* into real functions
has been removed from the -mm tree.  Its filename was
     userns-make-has_capability-into-real-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: userns: make has_capability* into real functions
From: "Serge E. Hallyn" <serge.hallyn@canonical.com>

So we can let type safety keep things sane, and as a bonus we can remove
the declaration of init_user_ns in capability.h.

Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/capability.h |   34 ++--------------------
 kernel/capability.c        |   54 +++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+), 30 deletions(-)

diff -puN include/linux/capability.h~userns-make-has_capability-into-real-functions include/linux/capability.h
--- a/include/linux/capability.h~userns-make-has_capability-into-real-functions
+++ a/include/linux/capability.h
@@ -371,8 +371,6 @@ struct cpu_vfs_cap_data {
 struct dentry;
 struct user_namespace;
 
-extern struct user_namespace init_user_ns;
-
 struct user_namespace *current_user_ns(void);
 
 extern const kernel_cap_t __cap_empty_set;
@@ -541,34 +539,10 @@ static inline kernel_cap_t cap_raise_nfs
 			   cap_intersect(permitted, __cap_nfsd_set));
 }
 
-/**
- * has_capability - Determine if a task has a superior capability available
- * @t: The task in question
- * @cap: The capability to be tested for
- *
- * Return true if the specified task has the given superior capability
- * currently in effect, false if not.
- *
- * Note that this does not set PF_SUPERPRIV on the task.
- */
-#define has_capability(t, cap) (security_real_capable((t), &init_user_ns, (cap)) == 0)
-
-#define has_ns_capability(t, ns, cap) (security_real_capable((t), (ns), (cap)) == 0)
-
-/**
- * has_capability_noaudit - Determine if a task has a superior capability available (unaudited)
- * @t: The task in question
- * @cap: The capability to be tested for
- *
- * Return true if the specified task has the given superior capability
- * currently in effect, false if not, but don't write an audit message for the
- * check.
- *
- * Note that this does not set PF_SUPERPRIV on the task.
- */
-#define has_capability_noaudit(t, cap) \
-	(security_real_capable_noaudit((t), &init_user_ns, (cap)) == 0)
-
+extern bool has_capability(struct task_struct *t, int cap);
+extern bool has_ns_capability(struct task_struct *t,
+			      struct user_namespace *ns, int cap);
+extern bool has_capability_noaudit(struct task_struct *t, int cap);
 extern bool capable(int cap);
 extern bool ns_capable(struct user_namespace *ns, int cap);
 extern bool task_ns_capable(struct task_struct *t, int cap);
diff -puN kernel/capability.c~userns-make-has_capability-into-real-functions kernel/capability.c
--- a/kernel/capability.c~userns-make-has_capability-into-real-functions
+++ a/kernel/capability.c
@@ -291,6 +291,60 @@ error:
 }
 
 /**
+ * has_capability - Does a task have a capability in init_user_ns
+ * @t: The task in question
+ * @cap: The capability to be tested for
+ *
+ * Return true if the specified task has the given superior capability
+ * currently in effect to the initial user namespace, false if not.
+ *
+ * Note that this does not set PF_SUPERPRIV on the task.
+ */
+bool has_capability(struct task_struct *t, int cap)
+{
+	int ret = security_real_capable(t, &init_user_ns, cap);
+
+	return (ret == 0);
+}
+
+/**
+ * has_capability - Does a task have a capability in a specific user ns
+ * @t: The task in question
+ * @ns: target user namespace
+ * @cap: The capability to be tested for
+ *
+ * Return true if the specified task has the given superior capability
+ * currently in effect to the specified user namespace, false if not.
+ *
+ * Note that this does not set PF_SUPERPRIV on the task.
+ */
+bool has_ns_capability(struct task_struct *t,
+		       struct user_namespace *ns, int cap)
+{
+	int ret = security_real_capable(t, ns, cap);
+
+	return (ret == 0);
+}
+
+/**
+ * has_capability_noaudit - Does a task have a capability (unaudited)
+ * @t: The task in question
+ * @cap: The capability to be tested for
+ *
+ * Return true if the specified task has the given superior capability
+ * currently in effect to init_user_ns, false if not.  Don't write an
+ * audit message for the check.
+ *
+ * Note that this does not set PF_SUPERPRIV on the task.
+ */
+bool has_capability_noaudit(struct task_struct *t, int cap)
+{
+	int ret = security_real_capable_noaudit(t, &init_user_ns, cap);
+
+	return (ret == 0);
+}
+
+/**
  * capable - Determine if the current task has a superior capability in effect
  * @cap: The capability to be tested for
  *
_

Patches currently in -mm which might be from serge.hallyn@canonical.com are

origin.patch
ipcns-fix-use-after-free-in-free_ipc_ns.patch
cgroup-remove-the-ns_cgroup.patch

