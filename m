From: akpm@linux-foundation.org
Subject: + add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message.patch added to -mm tree
Date: Mon, 26 Nov 2007 21:02:34 -0800
Message-ID: <200711270502.lAR52Yvc028030@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35808 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750799AbXK0FDp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 00:03:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: morgan@kernel.org, casey@schaufler-ca.com, chrisw@sous-sol.org, jmorris@namei.org, sds@tycho.nsa.gov, serue@us.ibm.com


The patch titled
     Modify 'old libcap' warning message
has been added to the -mm tree.  Its filename is
     add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Modify 'old libcap' warning message
From: Andrew Morgan <morgan@kernel.org>

When an application (usually via libcap) attempts to use 32-bit
capabilities when the kernel supports 64-bit capabilities, we log a kernel
warning.  We do this exactly once per kernel boot.  The warning is just
that - the kernel should be able to transparently handle 32-bit capability
use.  The application will remain limited in the capabilities that it can
manipulate until it is relinked with libcap2.

Signed-off-by: Andrew G. Morgan <morgan@kernel.org>
Cc: Andrew Morgan <morgan@kernel.org>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: James Morris <jmorris@namei.org>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/capability.c |   36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff -puN kernel/capability.c~add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message kernel/capability.c
--- a/kernel/capability.c~add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message
+++ a/kernel/capability.c
@@ -30,6 +30,26 @@ const kernel_cap_t __cap_full_set = CAP_
 const kernel_cap_t __cap_init_eff_set = CAP_INIT_EFF_SET;
 
 /*
+ * More recent versions of libcap are available from:
+ *
+ *   http://www.kernel.org/pub/linux/libs/security/linux-privs/
+ */
+
+static void warn_legacy_capability_use(void)
+{
+	static int warned = 0;
+	if (!warned) {
+		char name[sizeof(current->comm)];
+
+		printk(KERN_INFO "warning: `%s' uses 32-bit capabilities"
+		       " (legacy support in use)\n",
+		       get_task_comm(name, current));
+		warned = 1;
+	}
+	return;
+}
+
+/*
  * For sys_getproccap() and sys_setproccap(), any of the three
  * capability set pointers may be NULL -- indicating that that set is
  * uninteresting and/or not to be changed.
@@ -59,12 +79,7 @@ asmlinkage long sys_capget(cap_user_head
 
 	switch (version) {
 	case _LINUX_CAPABILITY_VERSION_1:
-		if (warned < 5) {
-			warned++;
-			printk(KERN_INFO
-			       "warning: process `%s' gets w/ old libcap\n",
-			       current->comm);
-		}
+		warn_legacy_capability_use();
 		tocopy = _LINUX_CAPABILITY_U32S_1;
 		break;
 	case _LINUX_CAPABILITY_VERSION_2:
@@ -210,7 +225,6 @@ static inline int cap_set_all(kernel_cap
  */
 asmlinkage long sys_capset(cap_user_header_t header, const cap_user_data_t data)
 {
-	static int warned;
 	struct __user_cap_data_struct kdata[_LINUX_CAPABILITY_U32S];
 	unsigned i, tocopy;
 	kernel_cap_t inheritable, permitted, effective;
@@ -224,13 +238,7 @@ asmlinkage long sys_capset(cap_user_head
 
 	switch (version) {
 	case _LINUX_CAPABILITY_VERSION_1:
-		if (warned < 5) {
-			char name[sizeof(current->comm)];
-			warned++;
-			printk(KERN_INFO
-			       "warning: process `%s' sets w/ old libcap\n",
-			       get_task_comm(name, current));
-		}
+		warn_legacy_capability_use();
 		tocopy = _LINUX_CAPABILITY_U32S_1;
 		break;
 	case _LINUX_CAPABILITY_VERSION_2:
_

Patches currently in -mm which might be from morgan@kernel.org are

file-capabilities-allow-sigcont-within-session-v2.patch
revert-capabilities-clean-up-file-capability-reading.patch
revert-capabilities-clean-up-file-capability-reading-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel.patch
add-64-bit-capability-support-to-the-kernel-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-fix.patch
add-64-bit-capability-support-to-the-kernel-fix-fix.patch
add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message.patch
64bit-capability-support-legacy-support-fix.patch
remove-unnecessary-include-from-include-linux-capabilityh.patch
smack-version-11c-simplified-mandatory-access-control-kernel.patch
