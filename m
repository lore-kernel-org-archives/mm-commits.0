From: akpm@linux-foundation.org
Subject: + userns-make-has_capability-into-real-functions.patch added to -mm tree
Date: Fri, 04 Mar 2011 15:50:55 -0800
Message-ID: <201103042350.p24Not5n011133@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54261 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760304Ab1CDXvf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Mar 2011 18:51:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serge.hallyn@canonical.com, daniel.lezcano@free.fr, dhowells@redhat.com, ebiederm@xmission.com, jmorris@namei.org


The patch titled
     userns: make has_capability* into real functions
has been added to the -mm tree.  Its filename is
     userns-make-has_capability-into-real-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

sys_unshare-remove-the-dead-clone_thread-sighand-vm-code.patch
cgroup-remove-the-ns_cgroup.patch
userns-add-a-user_namespace-as-creator-owner-of-uts_namespace.patch
userns-security-make-capabilities-relative-to-the-user-namespace.patch
userns-security-make-capabilities-relative-to-the-user-namespace-fix.patch
userns-security-make-capabilities-relative-to-the-user-namespace-fix-fix.patch
userns-security-make-capabilities-relative-to-the-user-namespace-remove-unneeded-extra-argument-in-selinuxs-task_has_capability.patch
userns-allow-sethostname-in-a-container.patch
userns-allow-killing-tasks-in-your-own-or-child-userns.patch
userns-allow-ptrace-from-non-init-user-namespaces.patch
userns-make-has_capability-into-real-functions.patch
userns-user-namespaces-convert-all-capable-checks-in-kernel-sysc.patch
userns-add-a-user-namespace-owner-of-ipc-ns.patch
userns-add-a-user-namespace-owner-of-ipc-ns-dont-define-init_user_ns-in-ipc_namespaceh.patch
userns-user-namespaces-convert-several-capable-calls.patch
userns-user-namespaces-convert-several-capable-calls-checkpatch-fixes.patch
userns-userns-check-user-namespace-for-task-file-uid-equivalence-checks.patch
userns-userns-check-user-namespace-for-task-file-uid-equivalence-checks-checkpatch-fixes.patch
userns-rename-is_owner_or_cap-to-inode_owner_or_capable.patch
userns-rename-is_owner_or_cap-to-inode_owner_or_capable-fix.patch
userns-rename-is_owner_or_cap-to-inode_owner_or_capable-fix-fix.patch

