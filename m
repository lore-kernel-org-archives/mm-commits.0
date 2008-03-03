From: akpm@linux-foundation.org
Subject: + lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks.patch added to -mm tree
Date: Sun, 02 Mar 2008 23:41:39 -0800
Message-ID: <200803030741.m237fdpc005083@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59337 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750765AbYCCHnR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 02:43:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: darwish.07@gmail.com, casey@schaufler-ca.com, chrisw@sous-sol.org, dwmw2@infradead.org, eparis@parisplace.org, jmorris@namei.org, paul.moore@hp.com, sds@tycho.nsa.gov, viro@zeniv.linux.org.uk


The patch titled
     LSM: Introduce inode_getsecid and ipc_getsecid hooks
has been added to the -mm tree.  Its filename is
     lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks.patch

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
Subject: LSM: Introduce inode_getsecid and ipc_getsecid hooks
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

A series of 9 patches to let Audit be LSM netural.  This is done for proper
future audit<->SMACK integration which will also be useful for any future LSM.

Basically, patches add below new LSM hooks:

1- secid extraction:
inode_getsecid(inode, secid)
ipc_getsecid(ipcp, secid)

2- LSM-specific Audit rules manipulation:
audit_rule_init(field, op, rulestr, lsmrule)
audit_rule_known(krule)
audit_rule_match(secid, field, op, rule, actx)
audit_rule_free(rule)

and remove ,now redundant, equivalent SELinux exported interfaces.

Initial work and idea by: Casey Schaufler <casey@schaufler-ca.com> Thanks to
Paul Moore <paul.moore@hp.com> for his deep review of first version.


This patch:

Introduce inode_getsecid(inode, secid) and ipc_getsecid(ipcp, secid) LSM
hooks.  These hooks will be used instead of similar exported SELinux
interfaces.

Let {inode,ipc,task}_getsecid hooks set the secid to 0 by default if
CONFIG_SECURITY is not defined or if the hook is set to NULL (dummy).  This is
done to notify the caller that no valid secid exists.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: James Morris <jmorris@namei.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@parisplace.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Paul Moore <paul.moore@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/security.h |   30 +++++++++++++++++++++++++++++-
 security/dummy.c         |   16 +++++++++++++++-
 security/security.c      |   10 ++++++++++
 3 files changed, 54 insertions(+), 2 deletions(-)

diff -puN include/linux/security.h~lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks include/linux/security.h
--- a/include/linux/security.h~lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks
+++ a/include/linux/security.h
@@ -449,6 +449,11 @@ struct request_sock;
  *	@dentry is the dentry being changed.
  *	Return 0 on success.  If error is returned, then the operation
  *	causing setuid bit removal is failed.
+ * @inode_getsecid:
+ *	Get the secid associated with the node.
+ *	@inode contains a pointer to the inode.
+ *	@secid contains a pointer to the location where result will be saved.
+ *	In case of failure, @secid will be set to zero.
  *
  * Security hooks for file operations
  *
@@ -617,6 +622,8 @@ struct request_sock;
  * @task_getsecid:
  *	Retrieve the security identifier of the process @p.
  *	@p contains the task_struct for the process and place is into @secid.
+ *	In case of failure, @secid will be set to zero.
+ *
  * @task_setgroups:
  *	Check permission before setting the supplementary group set of the
  *	current process.
@@ -980,6 +987,11 @@ struct request_sock;
  *	@ipcp contains the kernel IPC permission structure
  *	@flag contains the desired (requested) permission set
  *	Return 0 if permission is granted.
+ * @ipc_getsecid:
+ *	Get the secid associated with the ipc object.
+ *	@ipcp contains the kernel IPC permission structure.
+ *	@secid contains a pointer to the location where result will be saved.
+ *	In case of failure, @secid will be set to zero.
  *
  * Security hooks for individual messages held in System V IPC message queues
  * @msg_msg_alloc_security:
@@ -1301,6 +1313,7 @@ struct security_operations {
 	int (*inode_getsecurity)(const struct inode *inode, const char *name, void **buffer, bool alloc);
   	int (*inode_setsecurity)(struct inode *inode, const char *name, const void *value, size_t size, int flags);
   	int (*inode_listsecurity)(struct inode *inode, char *buffer, size_t buffer_size);
+	void (*inode_getsecid)(const struct inode *inode, u32 *secid);
 
 	int (*file_permission) (struct file * file, int mask);
 	int (*file_alloc_security) (struct file * file);
@@ -1353,6 +1366,7 @@ struct security_operations {
 	void (*task_to_inode)(struct task_struct *p, struct inode *inode);
 
 	int (*ipc_permission) (struct kern_ipc_perm * ipcp, short flag);
+	void (*ipc_getsecid) (struct kern_ipc_perm *ipcp, u32 *secid);
 
 	int (*msg_msg_alloc_security) (struct msg_msg * msg);
 	void (*msg_msg_free_security) (struct msg_msg * msg);
@@ -1562,6 +1576,7 @@ int security_inode_killpriv(struct dentr
 int security_inode_getsecurity(const struct inode *inode, const char *name, void **buffer, bool alloc);
 int security_inode_setsecurity(struct inode *inode, const char *name, const void *value, size_t size, int flags);
 int security_inode_listsecurity(struct inode *inode, char *buffer, size_t buffer_size);
+void security_inode_getsecid(const struct inode *inode, u32 *secid);
 int security_file_permission(struct file *file, int mask);
 int security_file_alloc(struct file *file);
 void security_file_free(struct file *file);
@@ -1606,6 +1621,7 @@ int security_task_prctl(int option, unsi
 void security_task_reparent_to_init(struct task_struct *p);
 void security_task_to_inode(struct task_struct *p, struct inode *inode);
 int security_ipc_permission(struct kern_ipc_perm *ipcp, short flag);
+void security_ipc_getsecid(struct kern_ipc_perm *ipcp, u32 *secid);
 int security_msg_msg_alloc(struct msg_msg *msg);
 void security_msg_msg_free(struct msg_msg *msg);
 int security_msg_queue_alloc(struct msg_queue *msq);
@@ -1976,6 +1992,11 @@ static inline int security_inode_listsec
 	return 0;
 }
 
+static inline void security_inode_getsecid(const struct inode *inode, u32 *secid)
+{
+	*secid = 0;
+}
+
 static inline int security_file_permission (struct file *file, int mask)
 {
 	return 0;
@@ -2091,7 +2112,9 @@ static inline int security_task_getsid (
 }
 
 static inline void security_task_getsecid (struct task_struct *p, u32 *secid)
-{ }
+{
+	*secid = 0;
+}
 
 static inline int security_task_setgroups (struct group_info *group_info)
 {
@@ -2170,6 +2193,11 @@ static inline int security_ipc_permissio
 	return 0;
 }
 
+static inline void security_ipc_getsecid(struct kern_ipc_perm *ipcp, u32 *secid)
+{
+	*secid = 0;
+}
+
 static inline int security_msg_msg_alloc (struct msg_msg * msg)
 {
 	return 0;
diff -puN security/dummy.c~lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks security/dummy.c
--- a/security/dummy.c~lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks
+++ a/security/dummy.c
@@ -422,6 +422,11 @@ static int dummy_inode_listsecurity(stru
 	return 0;
 }
 
+static void dummy_inode_getsecid(const struct inode *inode, u32 *secid)
+{
+	*secid = 0;
+}
+
 static int dummy_file_permission (struct file *file, int mask)
 {
 	return 0;
@@ -540,7 +545,9 @@ static int dummy_task_getsid (struct tas
 }
 
 static void dummy_task_getsecid (struct task_struct *p, u32 *secid)
-{ }
+{
+	*secid = 0;
+}
 
 static int dummy_task_setgroups (struct group_info *group_info)
 {
@@ -614,6 +621,11 @@ static int dummy_ipc_permission (struct 
 	return 0;
 }
 
+static void dummy_ipc_getsecid(struct kern_ipc_perm *ipcp, u32 *secid)
+{
+	*secid = 0;
+}
+
 static int dummy_msg_msg_alloc_security (struct msg_msg *msg)
 {
 	return 0;
@@ -1055,6 +1067,7 @@ void security_fixup_ops (struct security
 	set_to_dummy_if_null(ops, inode_getsecurity);
 	set_to_dummy_if_null(ops, inode_setsecurity);
 	set_to_dummy_if_null(ops, inode_listsecurity);
+	set_to_dummy_if_null(ops, inode_getsecid);
 	set_to_dummy_if_null(ops, file_permission);
 	set_to_dummy_if_null(ops, file_alloc_security);
 	set_to_dummy_if_null(ops, file_free_security);
@@ -1091,6 +1104,7 @@ void security_fixup_ops (struct security
 	set_to_dummy_if_null(ops, task_reparent_to_init);
  	set_to_dummy_if_null(ops, task_to_inode);
 	set_to_dummy_if_null(ops, ipc_permission);
+	set_to_dummy_if_null(ops, ipc_getsecid);
 	set_to_dummy_if_null(ops, msg_msg_alloc_security);
 	set_to_dummy_if_null(ops, msg_msg_free_security);
 	set_to_dummy_if_null(ops, msg_queue_alloc_security);
diff -puN security/security.c~lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks security/security.c
--- a/security/security.c~lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks
+++ a/security/security.c
@@ -516,6 +516,11 @@ int security_inode_listsecurity(struct i
 	return security_ops->inode_listsecurity(inode, buffer, buffer_size);
 }
 
+void security_inode_getsecid(const struct inode *inode, u32 *secid)
+{
+	security_ops->inode_getsecid(inode, secid);
+}
+
 int security_file_permission(struct file *file, int mask)
 {
 	return security_ops->file_permission(file, mask);
@@ -705,6 +710,11 @@ int security_ipc_permission(struct kern_
 	return security_ops->ipc_permission(ipcp, flag);
 }
 
+void security_ipc_getsecid(struct kern_ipc_perm *ipcp, u32 *secid)
+{
+	security_ops->ipc_getsecid(ipcp, secid);
+}
+
 int security_msg_msg_alloc(struct msg_msg *msg)
 {
 	return security_ops->msg_msg_alloc_security(msg);
_

Patches currently in -mm which might be from darwish.07@gmail.com are

origin.patch
git-kvm.patch
lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks.patch
selinux-setup-new-inode-ipc-getsecid-hooks.patch
audit-use-new-lsm-hooks-instead-of-selinux-exports.patch
netlink-use-generic-lsm-hook.patch
selinux-remove-redundant-exports.patch
lsm-audit-introduce-generic-audit-lsm-hooks.patch
audit-internally-use-the-new-lsm-audit-hooks.patch
selinux-use-new-audit-hooks-remove-redundant-exports.patch
audit-final-renamings-and-cleanup.patch

