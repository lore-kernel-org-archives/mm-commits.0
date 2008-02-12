From: akpm@linux-foundation.org
Subject: + keys-add-keyctl-function-to-get-a-security-label.patch added to -mm tree
Date: Tue, 12 Feb 2008 15:51:55 -0800
Message-ID: <200802122351.m1CNptSJ029552@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48239 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753120AbYBLXw6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Feb 2008 18:52:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, chrisw@sous-sol.org, jmorris@namei.org, kwc@citi.umich.edu, paul.moore@hp.com, sds@tycho.nsa.gov


The patch titled
     keys: add keyctl function to get a security label
has been added to the -mm tree.  Its filename is
     keys-add-keyctl-function-to-get-a-security-label.patch

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
Subject: keys: add keyctl function to get a security label
From: David Howells <dhowells@redhat.com>

Add a keyctl() function to get the security label of a key.

The following is added to Documentation/keys.txt:

 (*) Get the LSM security context attached to a key.

	long keyctl(KEYCTL_GET_SECURITY, key_serial_t key, char *buffer,
		    size_t buflen)

     This function returns a string that represents the LSM security context
     attached to a key in the buffer provided.

     Unless there's an error, it always returns the amount of data it could
     produce, even if that's too big for the buffer, but it won't copy more
     than requested to userspace. If the buffer pointer is NULL then no copy
     will take place.

     A NUL character is included at the end of the string if the buffer is
     sufficiently big.  This is included in the returned count.  If no LSM is
     in force then an empty string will be returned.

     A process must have view permission on the key for this function to be
     successful.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Paul Moore <paul.moore@hp.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: James Morris <jmorris@namei.org>
Cc: Kevin Coffman <kwc@citi.umich.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/keys.txt   |   21 +++++++++++
 include/linux/keyctl.h   |    1 
 include/linux/security.h |   20 ++++++++++-
 security/dummy.c         |    8 ++++
 security/keys/compat.c   |    3 +
 security/keys/keyctl.c   |   66 +++++++++++++++++++++++++++++++++++++
 security/security.c      |    5 ++
 security/selinux/hooks.c |   21 ++++++++++-
 8 files changed, 141 insertions(+), 4 deletions(-)

diff -puN Documentation/keys.txt~keys-add-keyctl-function-to-get-a-security-label Documentation/keys.txt
--- a/Documentation/keys.txt~keys-add-keyctl-function-to-get-a-security-label
+++ a/Documentation/keys.txt
@@ -711,6 +711,27 @@ The keyctl syscall functions are:
      The assumed authoritative key is inherited across fork and exec.
 
 
+ (*) Get the LSM security context attached to a key.
+
+	long keyctl(KEYCTL_GET_SECURITY, key_serial_t key, char *buffer,
+		    size_t buflen)
+
+     This function returns a string that represents the LSM security context
+     attached to a key in the buffer provided.
+
+     Unless there's an error, it always returns the amount of data it could
+     produce, even if that's too big for the buffer, but it won't copy more
+     than requested to userspace. If the buffer pointer is NULL then no copy
+     will take place.
+
+     A NUL character is included at the end of the string if the buffer is
+     sufficiently big.  This is included in the returned count.  If no LSM is
+     in force then an empty string will be returned.
+
+     A process must have view permission on the key for this function to be
+     successful.
+
+
 ===============
 KERNEL SERVICES
 ===============
diff -puN include/linux/keyctl.h~keys-add-keyctl-function-to-get-a-security-label include/linux/keyctl.h
--- a/include/linux/keyctl.h~keys-add-keyctl-function-to-get-a-security-label
+++ a/include/linux/keyctl.h
@@ -49,5 +49,6 @@
 #define KEYCTL_SET_REQKEY_KEYRING	14	/* set default request-key keyring */
 #define KEYCTL_SET_TIMEOUT		15	/* set key timeout */
 #define KEYCTL_ASSUME_AUTHORITY		16	/* assume request_key() authorisation */
+#define KEYCTL_GET_SECURITY		17	/* get key security label */
 
 #endif /*  _LINUX_KEYCTL_H */
diff -puN include/linux/security.h~keys-add-keyctl-function-to-get-a-security-label include/linux/security.h
--- a/include/linux/security.h~keys-add-keyctl-function-to-get-a-security-label
+++ a/include/linux/security.h
@@ -970,6 +970,17 @@ struct request_sock;
  *	@perm describes the combination of permissions required of this key.
  *	Return 1 if permission granted, 0 if permission denied and -ve it the
  *      normal permissions model should be effected.
+ * @key_getsecurity:
+ *	Get a textual representation of the security context attached to a key
+ *	for the purposes of honouring KEYCTL_GETSECURITY.  This function
+ *	allocates the storage for the NUL-terminated string and the caller
+ *	should free it.
+ *	@key points to the key to be queried.
+ *	@_buffer points to a pointer that should be set to point to the
+ *	 resulting string (if no label or an error occurs).
+ *	Return the length of the string (including terminating NUL) or -ve if
+ *      an error.
+ *	May also return 0 (and a NULL buffer pointer) if there is no label.
  *
  * Security hooks affecting all System V IPC operations.
  *
@@ -1459,7 +1470,7 @@ struct security_operations {
 	int (*key_permission)(key_ref_t key_ref,
 			      struct task_struct *context,
 			      key_perm_t perm);
-
+	int (*key_getsecurity)(struct key *key, char **_buffer);
 #endif	/* CONFIG_KEYS */
 
 };
@@ -2600,6 +2611,7 @@ int security_key_alloc(struct key *key, 
 void security_key_free(struct key *key);
 int security_key_permission(key_ref_t key_ref,
 			    struct task_struct *context, key_perm_t perm);
+int security_key_getsecurity(struct key *key, char **_buffer);
 
 #else
 
@@ -2621,6 +2633,12 @@ static inline int security_key_permissio
 	return 0;
 }
 
+static inline int security_key_getsecurity(struct key *key, char **_buffer)
+{
+	*_buffer = NULL;
+	return 0;
+}
+
 #endif
 #endif /* CONFIG_KEYS */
 
diff -puN security/dummy.c~keys-add-keyctl-function-to-get-a-security-label security/dummy.c
--- a/security/dummy.c~keys-add-keyctl-function-to-get-a-security-label
+++ a/security/dummy.c
@@ -977,6 +977,13 @@ static inline int dummy_key_permission(k
 {
 	return 0;
 }
+
+static int dummy_key_getsecurity(struct key *key, char **_buffer)
+{
+	*_buffer = NULL;
+	return 0;
+}
+
 #endif /* CONFIG_KEYS */
 
 struct security_operations dummy_security_ops;
@@ -1164,6 +1171,7 @@ void security_fixup_ops (struct security
 	set_to_dummy_if_null(ops, key_alloc);
 	set_to_dummy_if_null(ops, key_free);
 	set_to_dummy_if_null(ops, key_permission);
+	set_to_dummy_if_null(ops, key_getsecurity);
 #endif	/* CONFIG_KEYS */
 
 }
diff -puN security/keys/compat.c~keys-add-keyctl-function-to-get-a-security-label security/keys/compat.c
--- a/security/keys/compat.c~keys-add-keyctl-function-to-get-a-security-label
+++ a/security/keys/compat.c
@@ -79,6 +79,9 @@ asmlinkage long compat_sys_keyctl(u32 op
 	case KEYCTL_ASSUME_AUTHORITY:
 		return keyctl_assume_authority(arg2);
 
+	case KEYCTL_GET_SECURITY:
+		return keyctl_get_security(arg2, compat_ptr(arg3), arg4);
+
 	default:
 		return -EOPNOTSUPP;
 	}
diff -puN security/keys/keyctl.c~keys-add-keyctl-function-to-get-a-security-label security/keys/keyctl.c
--- a/security/keys/keyctl.c~keys-add-keyctl-function-to-get-a-security-label
+++ a/security/keys/keyctl.c
@@ -20,6 +20,7 @@
 #include <linux/string.h>
 #include <linux/err.h>
 #include <linux/vmalloc.h>
+#include <linux/security.h>
 #include <asm/uaccess.h>
 #include "internal.h"
 
@@ -1080,6 +1081,66 @@ error:
 
 } /* end keyctl_assume_authority() */
 
+/*
+ * get the security label of a key
+ * - the key must grant us view permission
+ * - if there's a buffer, we place up to buflen bytes of data into it
+ * - unless there's an error, we return the amount of information available,
+ *   irrespective of how much we may have copied (including the terminal NUL)
+ * - implements keyctl(KEYCTL_GET_SECURITY)
+ */
+long keyctl_get_security(key_serial_t keyid,
+			 char __user *buffer,
+			 size_t buflen)
+{
+	struct key *key, *instkey;
+	key_ref_t key_ref;
+	char *context;
+	long ret;
+
+	key_ref = lookup_user_key(NULL, keyid, 0, 1, KEY_VIEW);
+	if (IS_ERR(key_ref)) {
+		if (PTR_ERR(key_ref) != -EACCES)
+			return PTR_ERR(key_ref);
+
+		/* viewing a key under construction is also permitted if we
+		 * have the authorisation token handy */
+		instkey = key_get_instantiation_authkey(keyid);
+		if (IS_ERR(instkey))
+			return PTR_ERR(key_ref);
+		key_put(instkey);
+
+		key_ref = lookup_user_key(NULL, keyid, 0, 1, 0);
+		if (IS_ERR(key_ref))
+			return PTR_ERR(key_ref);
+	}
+
+	key = key_ref_to_ptr(key_ref);
+	ret = security_key_getsecurity(key, &context);
+	if (ret == 0) {
+		/* if no information was returned, give userspace an empty
+		 * string */
+		ret = 1;
+		if (buffer && buflen > 0 &&
+		    copy_to_user(buffer, "", 1) != 0)
+			ret = -EFAULT;
+	} else if (ret > 0) {
+		/* return as much data as there's room for */
+		if (buffer && buflen > 0) {
+			if (buflen > ret)
+				buflen = ret;
+
+			if (copy_to_user(buffer, context, buflen) != 0)
+				ret = -EFAULT;
+		}
+
+		kfree(context);
+	}
+
+	key_ref_put(key_ref);
+	return ret;
+}
+
 /*****************************************************************************/
 /*
  * the key control system call
@@ -1160,6 +1221,11 @@ asmlinkage long sys_keyctl(int option, u
 	case KEYCTL_ASSUME_AUTHORITY:
 		return keyctl_assume_authority((key_serial_t) arg2);
 
+	case KEYCTL_GET_SECURITY:
+		return keyctl_get_security((key_serial_t) arg2,
+					   (char *) arg3,
+					   (size_t) arg4);
+
 	default:
 		return -EOPNOTSUPP;
 	}
diff -puN security/security.c~keys-add-keyctl-function-to-get-a-security-label security/security.c
--- a/security/security.c~keys-add-keyctl-function-to-get-a-security-label
+++ a/security/security.c
@@ -1102,4 +1102,9 @@ int security_key_permission(key_ref_t ke
 	return security_ops->key_permission(key_ref, context, perm);
 }
 
+int security_key_getsecurity(struct key *key, char **_buffer)
+{
+	return security_ops->key_getsecurity(key, _buffer);
+}
+
 #endif	/* CONFIG_KEYS */
diff -puN security/selinux/hooks.c~keys-add-keyctl-function-to-get-a-security-label security/selinux/hooks.c
--- a/security/selinux/hooks.c~keys-add-keyctl-function-to-get-a-security-label
+++ a/security/selinux/hooks.c
@@ -5199,6 +5199,20 @@ static int selinux_key_permission(key_re
 			    SECCLASS_KEY, perm, NULL);
 }
 
+static int selinux_key_getsecurity(struct key *key, char **_buffer)
+{
+	struct key_security_struct *ksec = key->security;
+	char *context = NULL;
+	unsigned len;
+	int rc;
+
+	rc = security_sid_to_context(ksec->sid, &context, &len);
+	if (!rc)
+		rc = len;
+	*_buffer = context;
+	return rc;
+}
+
 #endif
 
 static struct security_operations selinux_ops = {
@@ -5378,9 +5392,10 @@ static struct security_operations selinu
 #endif
 
 #ifdef CONFIG_KEYS
-	.key_alloc =                    selinux_key_alloc,
-	.key_free =                     selinux_key_free,
-	.key_permission =               selinux_key_permission,
+	.key_alloc =			selinux_key_alloc,
+	.key_free =			selinux_key_free,
+	.key_permission =		selinux_key_permission,
+	.key_getsecurity =		selinux_key_getsecurity,
 #endif
 };
 
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
fix-frv-cmpxchg_local.patch
final-removal-of-fastcall-fastcall.patch
iget-stop-unionfs-from-using-iget-and-read_inode.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
keys-increase-the-payload-size-when-instantiating-a-key.patch
keys-check-starting-keyring-as-part-of-search.patch
keys-allow-the-callout-data-to-be-passed-as-a-blob-rather-than-a-string.patch
keys-add-keyctl-function-to-get-a-security-label.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
mutex-subsystem-synchro-test-module.patch
