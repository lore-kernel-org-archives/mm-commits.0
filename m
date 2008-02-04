From: akpm@linux-foundation.org
Subject: - smack-using-capabilities-32-and-33.patch removed from -mm tree
Date: Sun, 03 Feb 2008 19:59:44 -0800
Message-ID: <200802040359.m143xPtu012799@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35084 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754323AbYBDEAP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 3 Feb 2008 23:00:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: casey@schaufler-ca.com, morgan@kernel.org, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Smack using capabilities 32 and 33
has been removed from the -mm tree.  Its filename was
     smack-using-capabilities-32-and-33.patch

This patch was dropped because it was folded into smack-version-11c-simplified-mandatory-access-control-kernel.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Smack using capabilities 32 and 33
From: Casey Schaufler <casey@schaufler-ca.com>

This patch takes advantage of the increase in capability bits to allocate
capabilities for Mandatory Access Control.  Whereas Smack was overloading a
previously allocated capability it is now using a pair, one for overriding
access control checks and the other for changes to the MAC configuration.

The two capabilities allocated should be obvious in their intent.  The
comments in capability.h are intended to make it clear that there is no
intention that implementations of MAC LSM modules be any more constrained
by the presence of these capabilities than an implementation of DAC LSM
modules are by the analogous DAC capabilities.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew G. Morgan <morgan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/capability.h |   24 ++++++++++++++++++++++--
 security/smack/smack.h     |    8 --------
 security/smack/smack_lsm.c |    8 ++++----
 security/smack/smackfs.c   |   12 ++++++------
 4 files changed, 32 insertions(+), 20 deletions(-)

diff -puN include/linux/capability.h~smack-using-capabilities-32-and-33 include/linux/capability.h
--- a/include/linux/capability.h~smack-using-capabilities-32-and-33
+++ a/include/linux/capability.h
@@ -319,6 +319,23 @@ typedef struct kernel_cap_struct {
 
 #define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
 
+/* Override MAC access.
+   The base kernel enforces no MAC policy.
+   An LSM may enforce a MAC policy, and if it does and it chooses
+   to implement capability based overrides of that policy, this is
+   the capability it should use to do so. */
+
+#define CAP_MAC_OVERRIDE     32
+
+/* Allow MAC configuration or state changes.
+   The base kernel requires no MAC configuration.
+   An LSM may enforce a MAC policy, and if it does and it chooses
+   to implement capability based checks on modifications to that
+   policy or the data required to maintain it, this is the
+   capability it should use to do so. */
+
+#define CAP_MAC_ADMIN        33
+
 /*
  * Bit location of each capability (used by user-space library and kernel)
  */
@@ -341,6 +358,8 @@ typedef struct kernel_cap_struct {
 			    | CAP_TO_MASK(CAP_FOWNER)		\
 			    | CAP_TO_MASK(CAP_FSETID))
 
+# define CAP_FS_MASK_B1     (CAP_TO_MASK(CAP_MAC_OVERRIDE))
+
 #if _LINUX_CAPABILITY_U32S != 2
 # error Fix up hand-coded capability macro initializers
 #else /* HAND-CODED capability initializers */
@@ -348,8 +367,9 @@ typedef struct kernel_cap_struct {
 # define CAP_EMPTY_SET    {{ 0, 0 }}
 # define CAP_FULL_SET     {{ ~0, ~0 }}
 # define CAP_INIT_EFF_SET {{ ~CAP_TO_MASK(CAP_SETPCAP), ~0 }}
-# define CAP_FS_SET       {{ CAP_FS_MASK_B0, 0 }}
-# define CAP_NFSD_SET     {{ CAP_FS_MASK_B0|CAP_TO_MASK(CAP_SYS_RESOURCE), 0 }}
+# define CAP_FS_SET       {{ CAP_FS_MASK_B0, CAP_FS_MASK_B1 } }
+# define CAP_NFSD_SET     {{ CAP_FS_MASK_B0|CAP_TO_MASK(CAP_SYS_RESOURCE), \
+			     CAP_FS_MASK_B1 } }
 
 #endif /* _LINUX_CAPABILITY_U32S != 2 */
 
diff -puN security/smack/smack.h~smack-using-capabilities-32-and-33 security/smack/smack.h
--- a/security/smack/smack.h~smack-using-capabilities-32-and-33
+++ a/security/smack/smack.h
@@ -162,14 +162,6 @@ struct smack_known {
 #define MAY_NOT		0
 
 /*
- * There are not enough CAP bits available to make this
- * real, so Casey borrowed the capability that looks to
- * him like it has the best balance of similarity amd
- * low use.
- */
-#define CAP_MAC_OVERRIDE CAP_LINUX_IMMUTABLE
-
-/*
  * These functions are in smack_lsm.c
  */
 struct inode_smack *new_inode_smack(char *);
diff -puN security/smack/smack_lsm.c~smack-using-capabilities-32-and-33 security/smack/smack_lsm.c
--- a/security/smack/smack_lsm.c~smack-using-capabilities-32-and-33
+++ a/security/smack/smack_lsm.c
@@ -585,7 +585,7 @@ static int smack_inode_setxattr(struct d
 				void *value, size_t size, int flags)
 {
 	if (strcmp(name, XATTR_NAME_SMACK) == 0 &&
-		!__capable(current, CAP_MAC_OVERRIDE))
+		!__capable(current, CAP_MAC_ADMIN))
 		return -EPERM;
 
 	return smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
@@ -649,14 +649,14 @@ static int smack_inode_getxattr(struct d
  * @dentry: the object
  * @name: name of the attribute
  *
- * Removing the Smack attribute requires CAP_MAC_OVERRIDE
+ * Removing the Smack attribute requires CAP_MAC_ADMIN
  *
  * Returns 0 if access is permitted, an error code otherwise
  */
 static int smack_inode_removexattr(struct dentry *dentry, char *name)
 {
 	if (strcmp(name, XATTR_NAME_SMACK) == 0 &&
-		!__capable(current, CAP_MAC_OVERRIDE))
+		!__capable(current, CAP_MAC_ADMIN))
 		return -EPERM;
 
 	return smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
@@ -1956,7 +1956,7 @@ static int smack_setprocattr(struct task
 {
 	char *newsmack;
 
-	if (!__capable(p, CAP_MAC_OVERRIDE))
+	if (!__capable(p, CAP_MAC_ADMIN))
 		return -EPERM;
 
 	/*
diff -puN security/smack/smackfs.c~smack-using-capabilities-32-and-33 security/smack/smackfs.c
--- a/security/smack/smackfs.c~smack-using-capabilities-32-and-33
+++ a/security/smack/smackfs.c
@@ -241,7 +241,7 @@ static ssize_t smk_write_load(struct fil
 	 * No partial writes.
 	 * Enough data must be present.
 	 */
-	if (!capable(CAP_MAC_OVERRIDE))
+	if (!capable(CAP_MAC_ADMIN))
 		return -EPERM;
 	if (*ppos != 0)
 		return -EINVAL;
@@ -474,7 +474,7 @@ static ssize_t smk_write_cipso(struct fi
 	 * No partial writes.
 	 * Enough data must be present.
 	 */
-	if (!capable(CAP_MAC_OVERRIDE))
+	if (!capable(CAP_MAC_ADMIN))
 		return -EPERM;
 	if (*ppos != 0)
 		return -EINVAL;
@@ -601,7 +601,7 @@ static ssize_t smk_write_doi(struct file
 	char temp[80];
 	int i;
 
-	if (!capable(CAP_MAC_OVERRIDE))
+	if (!capable(CAP_MAC_ADMIN))
 		return -EPERM;
 
 	if (count >= sizeof(temp) || count == 0)
@@ -666,7 +666,7 @@ static ssize_t smk_write_direct(struct f
 	char temp[80];
 	int i;
 
-	if (!capable(CAP_MAC_OVERRIDE))
+	if (!capable(CAP_MAC_ADMIN))
 		return -EPERM;
 
 	if (count >= sizeof(temp) || count == 0)
@@ -747,7 +747,7 @@ static ssize_t smk_write_ambient(struct 
 	char in[SMK_LABELLEN];
 	char *smack;
 
-	if (!capable(CAP_MAC_OVERRIDE))
+	if (!capable(CAP_MAC_ADMIN))
 		return -EPERM;
 
 	if (count >= SMK_LABELLEN)
@@ -840,7 +840,7 @@ static ssize_t smk_write_nltype(struct f
 	char *cp;
 	int i;
 
-	if (!capable(CAP_MAC_OVERRIDE))
+	if (!capable(CAP_MAC_ADMIN))
 		return -EPERM;
 
 	if (count >= 40)
_

Patches currently in -mm which might be from casey@schaufler-ca.com are

vfs-security-rework-inode_getsecurity-and-callers-to.patch
vfs-reorder-vfs_getxattr-to-avoid-unnecessary-calls-to-the-lsm.patch
revert-capabilities-clean-up-file-capability-reading.patch
add-64-bit-capability-support-to-the-kernel.patch
capabilities-introduce-per-process-capability-bounding-set.patch
netlabel-introduce-a-new-kernel-configuration-api-for-netlabel.patch
smack-version-11c-simplified-mandatory-access-control-kernel.patch
smack-using-capabilities-32-and-33.patch
smack-using-capabilities-32-and-33-update-cap_last_cap-to-reflect-cap_mac_admin.patch
smack-mutex-capability-pointers-and-spelling-cleanup.patch
smack-getpeercred_stream-fix-for-so_peersec-and-tcp.patch
smack-socket-label-setting-fix.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-smack-fix.patch
