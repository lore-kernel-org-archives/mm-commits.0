From: akpm@linux-foundation.org
Subject: - smack-mutex-capability-pointers-and-spelling-cleanup.patch removed from -mm tree
Date: Sun, 03 Feb 2008 19:59:53 -0800
Message-ID: <200802040359.m143xYCE012805@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55526 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754495AbYBDEAk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 3 Feb 2008 23:00:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: casey@schaufler-ca.com, chrisw@sous-sol.org, darwish.07@gmail.com, jmorris@namei.org, method@manicmethod.com, morgan@kernel.org, paul.moore@hp.com, sds@tycho.nsa.gov, mm-commits@vger.kernel.org


The patch titled
     Smack: mutex, capability, pointers, and spelling cleanup
has been removed from the -mm tree.  Its filename was
     smack-mutex-capability-pointers-and-spelling-cleanup.patch

This patch was dropped because it was folded into smack-version-11c-simplified-mandatory-access-control-kernel.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Smack: mutex, capability, pointers, and spelling cleanup
From: Casey Schaufler <casey@schaufler-ca.com>

Addresses comments from akpm.

Clean out unnecessary mutex initializations for Smack list locks.
Once this is done, there is no need for them to be shared among
multiple files, so pull them out of the header file and put them
in the files where they belong. Make them static, too.

Pull unnecessary locking from smack_inode_setsecurity, it used
to be required when the assignment was not guaranteed to be a
scalar value but isn't now.

Change uses of __capable(current,...) to capable(...).

Take out an inappropriate cast. Use container_of() instead
of doing the same calculation by hand.

Fix comment spelling errors.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Cc: Joshua Brindle <method@manicmethod.com>
Cc: Paul Moore <paul.moore@hp.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: James Morris <jmorris@namei.org>
Cc: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: Andrew G. Morgan <morgan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/smack/smack.h        |    3 --
 security/smack/smack_access.c |    3 ++
 security/smack/smack_lsm.c    |   34 +++++++++-----------------------
 security/smack/smackfs.c      |    6 +++++
 4 files changed, 19 insertions(+), 27 deletions(-)

diff -puN security/smack/smack_access.c~smack-mutex-capability-pointers-and-spelling-cleanup security/smack/smack_access.c
--- a/security/smack/smack_access.c~smack-mutex-capability-pointers-and-spelling-cleanup
+++ a/security/smack/smack_access.c
@@ -58,6 +58,7 @@ struct smack_known smack_known_invalid =
 };
 
 struct smack_known *smack_known = &smack_known_invalid;
+
 /*
  * The initial value needs to be bigger than any of the
  * known values above.
@@ -173,6 +174,8 @@ int smk_curacc(char *obj_label, u32 mode
 	return rc;
 }
 
+static DEFINE_MUTEX(smack_known_lock);
+
 /**
  * smk_import_entry - import a label, return the list entry
  * @string: a text string that might be a Smack label
diff -puN security/smack/smackfs.c~smack-mutex-capability-pointers-and-spelling-cleanup security/smack/smackfs.c
--- a/security/smack/smackfs.c~smack-mutex-capability-pointers-and-spelling-cleanup
+++ a/security/smack/smackfs.c
@@ -41,6 +41,12 @@ enum smk_inos {
 };
 
 /*
+ * List locks
+ */
+static DEFINE_MUTEX(smack_list_lock);
+static DEFINE_MUTEX(smack_cipso_lock);
+
+/*
  * This is the "ambient" label for network traffic.
  * If it isn't somehow marked, use this.
  * It can be reset via smackfs/ambient
diff -puN security/smack/smack.h~smack-mutex-capability-pointers-and-spelling-cleanup security/smack/smack.h
--- a/security/smack/smack.h~smack-mutex-capability-pointers-and-spelling-cleanup
+++ a/security/smack/smack.h
@@ -186,7 +186,6 @@ extern int smack_net_nltype;
 extern char *smack_net_ambient;
 
 extern struct smack_known *smack_known;
-extern struct mutex smack_known_lock;
 extern struct smack_known smack_known_floor;
 extern struct smack_known smack_known_hat;
 extern struct smack_known smack_known_huh;
@@ -195,8 +194,6 @@ extern struct smack_known smack_known_st
 extern struct smack_known smack_known_unset;
 
 extern struct smk_list_entry *smack_list;
-extern struct mutex smack_list_lock;
-extern struct mutex smack_cipso_lock;
 
 /*
  * Stricly for CIPSO level manipulation.
diff -puN security/smack/smack_lsm.c~smack-mutex-capability-pointers-and-spelling-cleanup security/smack/smack_lsm.c
--- a/security/smack/smack_lsm.c~smack-mutex-capability-pointers-and-spelling-cleanup
+++ a/security/smack/smack_lsm.c
@@ -126,7 +126,7 @@ static int smack_syslog(int type)
 	if (rc != 0)
 		return rc;
 
-	if (__capable(current, CAP_MAC_OVERRIDE))
+	if (capable(CAP_MAC_OVERRIDE))
 		return 0;
 
 	 if (sp != smack_known_floor.smk_known)
@@ -584,8 +584,7 @@ static int smack_inode_getattr(struct vf
 static int smack_inode_setxattr(struct dentry *dentry, char *name,
 				void *value, size_t size, int flags)
 {
-	if (strcmp(name, XATTR_NAME_SMACK) == 0 &&
-		!__capable(current, CAP_MAC_ADMIN))
+	if (strcmp(name, XATTR_NAME_SMACK) == 0 && !capable(CAP_MAC_ADMIN))
 		return -EPERM;
 
 	return smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
@@ -655,8 +654,7 @@ static int smack_inode_getxattr(struct d
  */
 static int smack_inode_removexattr(struct dentry *dentry, char *name)
 {
-	if (strcmp(name, XATTR_NAME_SMACK) == 0 &&
-		!__capable(current, CAP_MAC_ADMIN))
+	if (strcmp(name, XATTR_NAME_SMACK) == 0 && !capable(CAP_MAC_ADMIN))
 		return -EPERM;
 
 	return smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
@@ -736,7 +734,7 @@ static int smack_inode_setsecurity(struc
 				   const void *value, size_t size, int flags)
 {
 	char *sp;
-	struct inode_smack *nsp = (struct inode_smack *)inode->i_security;
+	struct inode_smack *nsp = inode->i_security;
 	struct socket_smack *ssp;
 	struct socket *sock;
 
@@ -748,9 +746,7 @@ static int smack_inode_setsecurity(struc
 		return -EINVAL;
 
 	if (strcmp(name, XATTR_SMACK_SUFFIX) == 0) {
-		mutex_lock(&nsp->smk_lock);
 		nsp->smk_inode = sp;
-		mutex_unlock(&nsp->smk_lock);
 		return 0;
 	}
 	/*
@@ -950,7 +946,7 @@ static int smack_file_send_sigiotask(str
 	/*
 	 * struct fown_struct is never outside the context of a struct file
 	 */
-	file = (struct file *)((long)fown - offsetof(struct file, f_owner));
+	file = container_of(fown, struct file, f_owner);
 	rc = smk_access(file->f_security, tsk->security, MAY_WRITE);
 	if (rc != 0 && __capable(tsk, CAP_MAC_OVERRIDE))
 		return 0;
@@ -987,7 +983,7 @@ static int smack_file_receive(struct fil
  * @tsk: the task in need of a blob
  *
  * Smack isn't using copies of blobs. Everyone
- * points to an immutible list. No alloc required.
+ * points to an immutable list. No alloc required.
  * No data copy required.
  *
  * Always returns 0
@@ -1004,7 +1000,7 @@ static int smack_task_alloc_security(str
  * @task: the task with the blob
  *
  * Smack isn't using copies of blobs. Everyone
- * points to an immutible list. The blobs never go away.
+ * points to an immutable list. The blobs never go away.
  * There is no leak here.
  */
 static void smack_task_free_security(struct task_struct *task)
@@ -1192,8 +1188,7 @@ static int smack_task_wait(struct task_s
 	 * state into account in the decision as well as
 	 * the smack value.
 	 */
-	if (__capable(current, CAP_MAC_OVERRIDE) ||
-		__capable(p, CAP_MAC_OVERRIDE))
+	if (capable(CAP_MAC_OVERRIDE) || __capable(p, CAP_MAC_OVERRIDE))
 		return 0;
 
 	return rc;
@@ -1226,12 +1221,12 @@ static void smack_task_to_inode(struct t
  *
  * Returns 0 on success, -ENOMEM is there's no memory
  */
-static int smack_sk_alloc_security(struct sock *sk, int family, gfp_t priority)
+static int smack_sk_alloc_security(struct sock *sk, int family, gfp_t gfp_flags)
 {
 	char *csp = current->security;
 	struct socket_smack *ssp;
 
-	ssp = kzalloc(sizeof(struct socket_smack), priority);
+	ssp = kzalloc(sizeof(struct socket_smack), gfp_flags);
 	if (ssp == NULL)
 		return -ENOMEM;
 
@@ -1252,7 +1247,6 @@ static int smack_sk_alloc_security(struc
 static void smack_sk_free_security(struct sock *sk)
 {
 	kfree(sk->sk_security);
-	sk->sk_security = NULL;
 }
 
 /**
@@ -2481,10 +2475,6 @@ static struct security_operations smack_
 	.release_secctx = 		smack_release_secctx,
 };
 
-DEFINE_MUTEX(smack_list_lock);
-DEFINE_MUTEX(smack_known_lock);
-DEFINE_MUTEX(smack_cipso_lock);
-
 /**
  * smack_init - initialize the smack system
  *
@@ -2509,10 +2499,6 @@ static __init int smack_init(void)
 	spin_lock_init(&smack_known_floor.smk_cipsolock);
 	spin_lock_init(&smack_known_invalid.smk_cipsolock);
 
-	mutex_init(&smack_known_lock);
-	mutex_init(&smack_list_lock);
-	mutex_init(&smack_cipso_lock);
-
 	/*
 	 * Register with LSM
 	 */
_

Patches currently in -mm which might be from casey@schaufler-ca.com are

vfs-security-rework-inode_getsecurity-and-callers-to.patch
vfs-reorder-vfs_getxattr-to-avoid-unnecessary-calls-to-the-lsm.patch
revert-capabilities-clean-up-file-capability-reading.patch
add-64-bit-capability-support-to-the-kernel.patch
capabilities-introduce-per-process-capability-bounding-set.patch
netlabel-introduce-a-new-kernel-configuration-api-for-netlabel.patch
smack-version-11c-simplified-mandatory-access-control-kernel.patch
smack-mutex-capability-pointers-and-spelling-cleanup.patch
smack-getpeercred_stream-fix-for-so_peersec-and-tcp.patch
smack-socket-label-setting-fix.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-smack-fix.patch
