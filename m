From: akpm@linux-foundation.org
Subject: - security-filesystem-capabilities-fix-fragile-setuid-fixup-code.patch removed from -mm tree
Date: Sun, 06 Jul 2008 20:05:07 -0700
Message-ID: <200807070305.m673576v004794@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44386 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753529AbYGGDGO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 6 Jul 2008 23:06:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: morgan@kernel.org, dhowells@redhat.com, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     security: filesystem capabilities: fix fragile setuid fixup code
has been removed from the -mm tree.  Its filename was
     security-filesystem-capabilities-fix-fragile-setuid-fixup-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: security: filesystem capabilities: fix fragile setuid fixup code
From: Andrew G. Morgan <morgan@kernel.org>

This commit includes a bugfix for the fragile setuid fixup code in the
case that filesystem capabilities are supported (in access()).  The effect
of this fix is gated on filesystem capability support because changing
securebits is only supported when filesystem capabilities support is
configured.)

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Andrew G. Morgan <morgan@kernel.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/open.c                  |   37 ++++++++++++++++++++---------------
 include/linux/capability.h |    2 +
 include/linux/securebits.h |   15 +++++++-------
 kernel/capability.c        |   21 +++++++++++++++++++
 4 files changed, 53 insertions(+), 22 deletions(-)

diff -puN fs/open.c~security-filesystem-capabilities-fix-fragile-setuid-fixup-code fs/open.c
--- a/fs/open.c~security-filesystem-capabilities-fix-fragile-setuid-fixup-code
+++ a/fs/open.c
@@ -16,6 +16,7 @@
 #include <linux/namei.h>
 #include <linux/backing-dev.h>
 #include <linux/capability.h>
+#include <linux/securebits.h>
 #include <linux/security.h>
 #include <linux/mount.h>
 #include <linux/vfs.h>
@@ -425,7 +426,7 @@ asmlinkage long sys_faccessat(int dfd, c
 {
 	struct nameidata nd;
 	int old_fsuid, old_fsgid;
-	kernel_cap_t old_cap;
+	kernel_cap_t uninitialized_var(old_cap);  /* !SECURE_NO_SETUID_FIXUP */
 	int res;
 
 	if (mode & ~S_IRWXO)	/* where's F_OK, X_OK, W_OK, R_OK? */
@@ -433,23 +434,27 @@ asmlinkage long sys_faccessat(int dfd, c
 
 	old_fsuid = current->fsuid;
 	old_fsgid = current->fsgid;
-	old_cap = current->cap_effective;
 
 	current->fsuid = current->uid;
 	current->fsgid = current->gid;
 
-	/*
-	 * Clear the capabilities if we switch to a non-root user
-	 *
-	 * FIXME: There is a race here against sys_capset.  The
-	 * capabilities can change yet we will restore the old
-	 * value below.  We should hold task_capabilities_lock,
-	 * but we cannot because user_path_walk can sleep.
-	 */
-	if (current->uid)
-		cap_clear(current->cap_effective);
-	else
-		current->cap_effective = current->cap_permitted;
+	if (!issecure(SECURE_NO_SETUID_FIXUP)) {
+		/*
+		 * Clear the capabilities if we switch to a non-root user
+		 */
+#ifndef CONFIG_SECURITY_FILE_CAPABILITIES
+		/*
+		 * FIXME: There is a race here against sys_capset.  The
+		 * capabilities can change yet we will restore the old
+		 * value below.  We should hold task_capabilities_lock,
+		 * but we cannot because user_path_walk can sleep.
+		 */
+#endif /* ndef CONFIG_SECURITY_FILE_CAPABILITIES */
+		if (current->uid)
+			old_cap = cap_set_effective(__cap_empty_set);
+		else
+			old_cap = cap_set_effective(current->cap_permitted);
+	}
 
 	res = __user_walk_fd(dfd, filename, LOOKUP_FOLLOW|LOOKUP_ACCESS, &nd);
 	if (res)
@@ -478,7 +483,9 @@ out_path_release:
 out:
 	current->fsuid = old_fsuid;
 	current->fsgid = old_fsgid;
-	current->cap_effective = old_cap;
+
+	if (!issecure(SECURE_NO_SETUID_FIXUP))
+		cap_set_effective(old_cap);
 
 	return res;
 }
diff -puN include/linux/capability.h~security-filesystem-capabilities-fix-fragile-setuid-fixup-code include/linux/capability.h
--- a/include/linux/capability.h~security-filesystem-capabilities-fix-fragile-setuid-fixup-code
+++ a/include/linux/capability.h
@@ -501,6 +501,8 @@ extern const kernel_cap_t __cap_empty_se
 extern const kernel_cap_t __cap_full_set;
 extern const kernel_cap_t __cap_init_eff_set;
 
+kernel_cap_t cap_set_effective(const kernel_cap_t pE_new);
+
 int capable(int cap);
 int __capable(struct task_struct *t, int cap);
 
diff -puN include/linux/securebits.h~security-filesystem-capabilities-fix-fragile-setuid-fixup-code include/linux/securebits.h
--- a/include/linux/securebits.h~security-filesystem-capabilities-fix-fragile-setuid-fixup-code
+++ a/include/linux/securebits.h
@@ -7,14 +7,15 @@
    inheritance of root-permissions and suid-root executable under
    compatibility mode. We raise the effective and inheritable bitmasks
    *of the executable file* if the effective uid of the new process is
-   0. If the real uid is 0, we raise the inheritable bitmask of the
+   0. If the real uid is 0, we raise the effective (legacy) bit of the
    executable file. */
 #define SECURE_NOROOT			0
 #define SECURE_NOROOT_LOCKED		1  /* make bit-0 immutable */
 
-/* When set, setuid to/from uid 0 does not trigger capability-"fixes"
-   to be compatible with old programs relying on set*uid to loose
-   privileges. When unset, setuid doesn't change privileges. */
+/* When set, setuid to/from uid 0 does not trigger capability-"fixup".
+   When unset, to provide compatiblility with old programs relying on
+   set*uid to gain/lose privilege, transitions to/from uid 0 cause
+   capabilities to be gained/lost. */
 #define SECURE_NO_SETUID_FIXUP		2
 #define SECURE_NO_SETUID_FIXUP_LOCKED	3  /* make bit-2 immutable */
 
@@ -26,10 +27,10 @@
 #define SECURE_KEEP_CAPS		4
 #define SECURE_KEEP_CAPS_LOCKED		5  /* make bit-4 immutable */
 
-/* Each securesetting is implemented using two bits. One bit specify
+/* Each securesetting is implemented using two bits. One bit specifies
    whether the setting is on or off. The other bit specify whether the
-   setting is fixed or not. A setting which is fixed cannot be changed
-   from user-level. */
+   setting is locked or not. A setting which is locked cannot be
+   changed from user-level. */
 #define issecure_mask(X)	(1 << (X))
 #define issecure(X)		(issecure_mask(X) & current->securebits)
 
diff -puN kernel/capability.c~security-filesystem-capabilities-fix-fragile-setuid-fixup-code kernel/capability.c
--- a/kernel/capability.c~security-filesystem-capabilities-fix-fragile-setuid-fixup-code
+++ a/kernel/capability.c
@@ -121,6 +121,27 @@ static int cap_validate_magic(cap_user_h
  * uninteresting and/or not to be changed.
  */
 
+/*
+ * Atomically modify the effective capabilities returning the original
+ * value. No permission check is performed here - it is assumed that the
+ * caller is permitted to set the desired effective capabilities.
+ */
+kernel_cap_t cap_set_effective(const kernel_cap_t pE_new)
+{
+	kernel_cap_t pE_old;
+
+	spin_lock(&task_capability_lock);
+
+	pE_old = current->cap_effective;
+	current->cap_effective = pE_new;
+
+	spin_unlock(&task_capability_lock);
+
+	return pE_old;
+}
+
+EXPORT_SYMBOL(cap_set_effective);
+
 /**
  * sys_capget - get the capabilities of a given process.
  * @header: pointer to struct that contains capability version and
_

Patches currently in -mm which might be from morgan@kernel.org are

security-protect-legacy-applications-from-executing-with-insufficient-privilege.patch
security-protect-legacy-apps-from-insufficient-privilege-cleanup.patch
security-protect-legacy-applications-from-executing-with-insufficient-privilege-checkpatch-fixes.patch
security-filesystem-capabilities-refactor-kernel-code.patch
security-filesystem-capabilities-no-longer-experimental.patch
sysctl-allow-override-of-proc-sys-net-with-cap_net_admin.patch

