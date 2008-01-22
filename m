From: akpm@linux-foundation.org
Subject: + smack-socket-label-setting-fix.patch added to -mm tree
Date: Mon, 21 Jan 2008 18:51:06 -0800
Message-ID: <200801220250.m0M2okbK000710@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43857 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751928AbYAVCv7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jan 2008 21:51:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: casey@schaufler-ca.com, chrisw@sous-sol.org, darwish.07@gmail.com, jmorris@namei.org, method@manicmethod.com, morgan@kernel.org, paul.moore@hp.com, sds@tycho.nsa.gov


The patch titled
     Smack socket label setting fix
has been added to the -mm tree.  Its filename is
     smack-socket-label-setting-fix.patch

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
Subject: Smack socket label setting fix
From: Casey Schaufler <casey@schaufler-ca.com>

Correct the checks in smack_inode_setxattr to include the socket labeling
attributes.  Simplify and correct smack_sock_graft, while the values it was
setting were safe they were not correct and the job was not being done
efficiently.  smack_inode_setsecurity wasn't invoking the required netlabel
function in the case where smk_ipout was set.  It does now, but that change
required the hook to be moved in the file.  This movement accounts for the
bulk of the patch.

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

 security/smack/smack.h     |    2 
 security/smack/smack_lsm.c |  138 ++++++++++++++++-------------------
 2 files changed, 68 insertions(+), 72 deletions(-)

diff -puN security/smack/smack.h~smack-socket-label-setting-fix security/smack/smack.h
--- a/security/smack/smack.h~smack-socket-label-setting-fix
+++ a/security/smack/smack.h
@@ -130,6 +130,8 @@ struct smack_known {
 #define XATTR_SMACK_IPIN	"SMACK64IPIN"
 #define XATTR_SMACK_IPOUT	"SMACK64IPOUT"
 #define XATTR_NAME_SMACK	XATTR_SECURITY_PREFIX XATTR_SMACK_SUFFIX
+#define XATTR_NAME_SMACKIPIN	XATTR_SECURITY_PREFIX XATTR_SMACK_IPIN
+#define XATTR_NAME_SMACKIPOUT	XATTR_SECURITY_PREFIX XATTR_SMACK_IPOUT
 
 /*
  * smackfs macic number
diff -puN security/smack/smack_lsm.c~smack-socket-label-setting-fix security/smack/smack_lsm.c
--- a/security/smack/smack_lsm.c~smack-socket-label-setting-fix
+++ a/security/smack/smack_lsm.c
@@ -584,8 +584,12 @@ static int smack_inode_getattr(struct vf
 static int smack_inode_setxattr(struct dentry *dentry, char *name,
 				void *value, size_t size, int flags)
 {
-	if (strcmp(name, XATTR_NAME_SMACK) == 0 && !capable(CAP_MAC_ADMIN))
-		return -EPERM;
+	if (!capable(CAP_MAC_ADMIN)) {
+		if (strcmp(name, XATTR_NAME_SMACK) == 0 ||
+		    strcmp(name, XATTR_NAME_SMACKIPIN) == 0 ||
+		    strcmp(name, XATTR_NAME_SMACKIPOUT) == 0)
+			return -EPERM;
+	}
 
 	return smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
 }
@@ -718,57 +722,6 @@ static int smack_inode_getsecurity(const
 	return rc;
 }
 
-/**
- * smack_inode_setsecurity - set smack xattrs
- * @inode: the object
- * @name: attribute name
- * @value: attribute value
- * @size: size of the attribute
- * @flags: unused
- *
- * Sets the named attribute in the appropriate blob
- *
- * Returns 0 on success, or an error code
- */
-static int smack_inode_setsecurity(struct inode *inode, const char *name,
-				   const void *value, size_t size, int flags)
-{
-	char *sp;
-	struct inode_smack *nsp = inode->i_security;
-	struct socket_smack *ssp;
-	struct socket *sock;
-
-	if (value == NULL || size > SMK_LABELLEN)
-		return -EACCES;
-
-	sp = smk_import(value, size);
-	if (sp == NULL)
-		return -EINVAL;
-
-	if (strcmp(name, XATTR_SMACK_SUFFIX) == 0) {
-		nsp->smk_inode = sp;
-		return 0;
-	}
-	/*
-	 * The rest of the Smack xattrs are only on sockets.
-	 */
-	if (inode->i_sb->s_magic != SOCKFS_MAGIC)
-		return -EOPNOTSUPP;
-
-	sock = SOCKET_I(inode);
-	if (sock == NULL)
-		return -EOPNOTSUPP;
-
-	ssp = sock->sk->sk_security;
-
-	if (strcmp(name, XATTR_SMACK_IPIN) == 0)
-		ssp->smk_in = sp;
-	else if (strcmp(name, XATTR_SMACK_IPOUT) == 0)
-		ssp->smk_out = sp;
-	else
-		return -EOPNOTSUPP;
-	return 0;
-}
 
 /**
  * smack_inode_listsecurity - list the Smack attributes
@@ -1341,6 +1294,60 @@ static int smack_netlabel(struct sock *s
 }
 
 /**
+ * smack_inode_setsecurity - set smack xattrs
+ * @inode: the object
+ * @name: attribute name
+ * @value: attribute value
+ * @size: size of the attribute
+ * @flags: unused
+ *
+ * Sets the named attribute in the appropriate blob
+ *
+ * Returns 0 on success, or an error code
+ */
+static int smack_inode_setsecurity(struct inode *inode, const char *name,
+				   const void *value, size_t size, int flags)
+{
+	char *sp;
+	struct inode_smack *nsp = inode->i_security;
+	struct socket_smack *ssp;
+	struct socket *sock;
+
+	if (value == NULL || size > SMK_LABELLEN)
+		return -EACCES;
+
+	sp = smk_import(value, size);
+	if (sp == NULL)
+		return -EINVAL;
+
+	if (strcmp(name, XATTR_SMACK_SUFFIX) == 0) {
+		nsp->smk_inode = sp;
+		return 0;
+	}
+	/*
+	 * The rest of the Smack xattrs are only on sockets.
+	 */
+	if (inode->i_sb->s_magic != SOCKFS_MAGIC)
+		return -EOPNOTSUPP;
+
+	sock = SOCKET_I(inode);
+	if (sock == NULL)
+		return -EOPNOTSUPP;
+
+	ssp = sock->sk->sk_security;
+
+	if (strcmp(name, XATTR_SMACK_IPIN) == 0)
+		ssp->smk_in = sp;
+	else if (strcmp(name, XATTR_SMACK_IPOUT) == 0) {
+		ssp->smk_out = sp;
+		return smack_netlabel(sock->sk);
+	} else
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
+/**
  * smack_socket_post_create - finish socket setup
  * @sock: the socket
  * @family: protocol family
@@ -2192,33 +2199,20 @@ static int smack_socket_getpeersec_dgram
 static void smack_sock_graft(struct sock *sk, struct socket *parent)
 {
 	struct socket_smack *ssp;
-	struct netlbl_lsm_secattr secattr;
-	char smack[SMK_LABELLEN];
 	int rc;
 
-	if (sk == NULL || parent == NULL || parent->sk == NULL)
+	if (sk == NULL)
 		return;
 
 	if (sk->sk_family != PF_INET && sk->sk_family != PF_INET6)
 		return;
 
-	ssp = parent->sk->sk_security;
-
-	memset(smack, '\0', SMK_LABELLEN);
-	netlbl_secattr_init(&secattr);
-	rc = netlbl_sock_getattr(sk, &secattr);
-	if (rc == 0)
-		smack_from_secattr(&secattr, smack);
-	else
-		strncpy(smack, smack_known_huh.smk_known, SMK_MAXLEN);
-	netlbl_secattr_destroy(&secattr);
-
-	netlbl_secattr_init(&secattr);
+	ssp = sk->sk_security;
+	ssp->smk_in = current->security;
+	ssp->smk_out = current->security;
+	ssp->smk_packet[0] = '\0';
 
-	smack_to_secattr(smack, &secattr);
-	if (secattr.flags != NETLBL_SECATTR_NONE)
-		rc = netlbl_sock_setattr(parent->sk, &secattr);
-	netlbl_secattr_destroy(&secattr);
+	rc = smack_netlabel(sk);
 }
 
 /**
_

Patches currently in -mm which might be from casey@schaufler-ca.com are

vfs-security-rework-inode_getsecurity-and-callers-to.patch
vfs-reorder-vfs_getxattr-to-avoid-unnecessary-calls-to-the-lsm.patch
revert-capabilities-clean-up-file-capability-reading.patch
revert-capabilities-clean-up-file-capability-reading-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel.patch
add-64-bit-capability-support-to-the-kernel-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-fix.patch
add-64-bit-capability-support-to-the-kernel-fix-fix.patch
add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message.patch
add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message-fix.patch
64bit-capability-support-legacy-support-fix.patch
capabilities-introduce-per-process-capability-bounding-set.patch
netlabel-introduce-a-new-kernel-configuration-api-for-netlabel.patch
smack-version-11c-simplified-mandatory-access-control-kernel.patch
smack-using-capabilities-32-and-33.patch
smack-using-capabilities-32-and-33-update-cap_last_cap-to-reflect-cap_mac_admin.patch
smack-mutex-capability-pointers-and-spelling-cleanup.patch
smack-getpeercred_stream-fix-for-so_peersec-and-tcp.patch
smack-socket-label-setting-fix.patch
