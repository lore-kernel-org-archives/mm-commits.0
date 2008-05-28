From: akpm@linux-foundation.org
Subject: + capabilities-remain-source-compatible-with-32-bit-raw-legacy-capability-support.patch added to -mm tree
Date: Tue, 27 May 2008 20:33:51 -0700
Message-ID: <200805280333.m4S3XpQL027026@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35534 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753977AbYE1DeW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 23:34:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: morgan@kernel.org, chrisw@sous-sol.org, serue@us.ibm.com


The patch titled
     capabilities: remain source compatible with 32-bit raw legacy capability support.
has been added to the -mm tree.  Its filename is
     capabilities-remain-source-compatible-with-32-bit-raw-legacy-capability-support.patch

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
Subject: capabilities: remain source compatible with 32-bit raw legacy capability support.
From: Andrew G. Morgan <morgan@kernel.org>

Source code out there hard-codes a notion of what the
_LINUX_CAPABILITY_VERSION #define means in terms of the semantics of the
raw capability system calls capget() and capset().  Its unfortunate, but
true.

Since the confusing header file has been in a released kernel, there is
software that is erroneously using 64-bit capabilities with the semantics
of 32-bit compatibilities.  These recently compiled programs may suffer
corruption of their memory when sys_getcap() overwrites more memory than
they are coded to expect, and the raising of added capabilities when using
sys_capset().

As such, this patch does a number of things to clean up the situation
for all. It

  1. forces the _LINUX_CAPABILITY_VERSION define to always retain its
     legacy value.

  2. adopts a new #define strategy for the kernel's internal
     implementation of the preferred magic.

  3. depreciates v2 capability magic in favor of a new (v3) magic
     number. The functionality of v3 is entirely equivalent to v2,
     the only difference being that the v2 magic causes the kernel
     to log a "depreciated" warning so the admin can find applications
     that may be using v2 inappropriately.

[User space code continues to be encouraged to use the libcap API which
protects the application from details like this.  libcap-2.10 is the first
to support v3 capabilities.]

Signed-off-by: Andrew G. Morgan <morgan@kernel.org>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c            |    2 
 include/linux/capability.h |   29 ++++++---
 kernel/capability.c        |  110 ++++++++++++++++++++++-------------
 3 files changed, 94 insertions(+), 47 deletions(-)

diff -puN fs/proc/array.c~capabilities-remain-source-compatible-with-32-bit-raw-legacy-capability-support fs/proc/array.c
--- a/fs/proc/array.c~capabilities-remain-source-compatible-with-32-bit-raw-legacy-capability-support
+++ a/fs/proc/array.c
@@ -288,7 +288,7 @@ static void render_cap_t(struct seq_file
 	seq_printf(m, "%s", header);
 	CAP_FOR_EACH_U32(__capi) {
 		seq_printf(m, "%08x",
-			   a->cap[(_LINUX_CAPABILITY_U32S-1) - __capi]);
+			   a->cap[(_KERNEL_CAPABILITY_U32S-1) - __capi]);
 	}
 	seq_printf(m, "\n");
 }
diff -puN include/linux/capability.h~capabilities-remain-source-compatible-with-32-bit-raw-legacy-capability-support include/linux/capability.h
--- a/include/linux/capability.h~capabilities-remain-source-compatible-with-32-bit-raw-legacy-capability-support
+++ a/include/linux/capability.h
@@ -31,11 +31,11 @@ struct task_struct;
 #define _LINUX_CAPABILITY_VERSION_1  0x19980330
 #define _LINUX_CAPABILITY_U32S_1     1
 
-#define _LINUX_CAPABILITY_VERSION_2  0x20071026
+#define _LINUX_CAPABILITY_VERSION_2  0x20071026  /* depreciated - use v3 */
 #define _LINUX_CAPABILITY_U32S_2     2
 
-#define _LINUX_CAPABILITY_VERSION    _LINUX_CAPABILITY_VERSION_2
-#define _LINUX_CAPABILITY_U32S       _LINUX_CAPABILITY_U32S_2
+#define _LINUX_CAPABILITY_VERSION_3  0x20080522
+#define _LINUX_CAPABILITY_U32S_3     2
 
 typedef struct __user_cap_header_struct {
 	__u32 version;
@@ -77,10 +77,23 @@ struct vfs_cap_data {
 	} data[VFS_CAP_U32];
 };
 
-#ifdef __KERNEL__
+#ifndef __KERNEL__
+
+/*
+ * Backwardly compatible definition for source code - trapped in a
+ * 32-bit world. If you find you need this, please consider using
+ * libcap to untrap yourself...
+ */
+#define _LINUX_CAPABILITY_VERSION  _LINUX_CAPABILITY_VERSION_1
+#define _LINUX_CAPABILITY_U32S     _LINUX_CAPABILITY_U32S_1
+
+#else
+
+#define _KERNEL_CAPABILITY_VERSION _LINUX_CAPABILITY_VERSION_3
+#define _KERNEL_CAPABILITY_U32S    _LINUX_CAPABILITY_U32S_3
 
 typedef struct kernel_cap_struct {
-	__u32 cap[_LINUX_CAPABILITY_U32S];
+	__u32 cap[_KERNEL_CAPABILITY_U32S];
 } kernel_cap_t;
 
 #define _USER_CAP_HEADER_SIZE  (sizeof(struct __user_cap_header_struct))
@@ -351,7 +364,7 @@ typedef struct kernel_cap_struct {
  */
 
 #define CAP_FOR_EACH_U32(__capi)  \
-	for (__capi = 0; __capi < _LINUX_CAPABILITY_U32S; ++__capi)
+	for (__capi = 0; __capi < _KERNEL_CAPABILITY_U32S; ++__capi)
 
 # define CAP_FS_MASK_B0     (CAP_TO_MASK(CAP_CHOWN)		\
 			    | CAP_TO_MASK(CAP_DAC_OVERRIDE)	\
@@ -361,7 +374,7 @@ typedef struct kernel_cap_struct {
 
 # define CAP_FS_MASK_B1     (CAP_TO_MASK(CAP_MAC_OVERRIDE))
 
-#if _LINUX_CAPABILITY_U32S != 2
+#if _KERNEL_CAPABILITY_U32S != 2
 # error Fix up hand-coded capability macro initializers
 #else /* HAND-CODED capability initializers */
 
@@ -372,7 +385,7 @@ typedef struct kernel_cap_struct {
 # define CAP_NFSD_SET     ((kernel_cap_t){{ CAP_FS_MASK_B0|CAP_TO_MASK(CAP_SYS_RESOURCE), \
 					CAP_FS_MASK_B1 } })
 
-#endif /* _LINUX_CAPABILITY_U32S != 2 */
+#endif /* _KERNEL_CAPABILITY_U32S != 2 */
 
 #define CAP_INIT_INH_SET    CAP_EMPTY_SET
 
diff -puN kernel/capability.c~capabilities-remain-source-compatible-with-32-bit-raw-legacy-capability-support kernel/capability.c
--- a/kernel/capability.c~capabilities-remain-source-compatible-with-32-bit-raw-legacy-capability-support
+++ a/kernel/capability.c
@@ -53,6 +53,68 @@ static void warn_legacy_capability_use(v
 }
 
 /*
+ * Version 2 capabilities worked fine, but the linux/capability.h file
+ * that accompanied their introduction encouraged their use without
+ * the necessary user-space source code changes. As such, we have
+ * created a version 3 with equivalent functionality to version 2, but
+ * with a header change to protect legacy source code from using
+ * version 2 when it wanted to use version 1. If your system has code
+ * that trips the following warning, it is using version 2 specific
+ * capabilities and may be doing so insecurely.
+ *
+ * The remedy is to either upgrade your version of libcap (to 2.10+,
+ * if the application is linked against it), or recompile your
+ * application with modern kernel headers and this warning will go
+ * away.
+ */
+
+static void warn_depreciated_v2(void)
+{
+	static int warned = 0;
+	if (!warned) {
+		char name[sizeof(current->comm)];
+
+		printk(KERN_INFO "warning: `%s' uses depreciated v2"
+		       " capabilities in a way that may be insecure.\n",
+		       get_task_comm(name, current));
+		warned = 1;
+	}
+}
+
+/*
+ * Version check. Return the number of u32s in each capability flag
+ * array, or a negative value on error.
+ */
+static int cap_validate_magic(cap_user_header_t header, unsigned *tocopy)
+{
+	__u32 version;
+
+	if (get_user(version, &header->version))
+		return -EFAULT;
+
+	switch (version) {
+	case _LINUX_CAPABILITY_VERSION_1:
+		warn_legacy_capability_use();
+		*tocopy = _LINUX_CAPABILITY_U32S_1;
+		break;
+	case _LINUX_CAPABILITY_VERSION_2:
+		warn_depreciated_v2();
+		/*
+		 * fall through - v3 is otherwise equivalent to v2.
+		 */
+	case _LINUX_CAPABILITY_VERSION_3:
+		*tocopy = _LINUX_CAPABILITY_U32S_3;
+		break;
+	default:
+		if (put_user(_KERNEL_CAPABILITY_VERSION, &header->version))
+			return -EFAULT;
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/*
  * For sys_getproccap() and sys_setproccap(), any of the three
  * capability set pointers may be NULL -- indicating that that set is
  * uninteresting and/or not to be changed.
@@ -71,27 +133,13 @@ asmlinkage long sys_capget(cap_user_head
 {
 	int ret = 0;
 	pid_t pid;
-	__u32 version;
 	struct task_struct *target;
 	unsigned tocopy;
 	kernel_cap_t pE, pI, pP;
 
-	if (get_user(version, &header->version))
-		return -EFAULT;
-
-	switch (version) {
-	case _LINUX_CAPABILITY_VERSION_1:
-		warn_legacy_capability_use();
-		tocopy = _LINUX_CAPABILITY_U32S_1;
-		break;
-	case _LINUX_CAPABILITY_VERSION_2:
-		tocopy = _LINUX_CAPABILITY_U32S_2;
-		break;
-	default:
-		if (put_user(_LINUX_CAPABILITY_VERSION, &header->version))
-			return -EFAULT;
-		return -EINVAL;
-	}
+	ret = cap_validate_magic(header, &tocopy);
+	if (ret != 0)
+		return ret;
 
 	if (get_user(pid, &header->pid))
 		return -EFAULT;
@@ -118,7 +166,7 @@ out:
 	spin_unlock(&task_capability_lock);
 
 	if (!ret) {
-		struct __user_cap_data_struct kdata[_LINUX_CAPABILITY_U32S];
+		struct __user_cap_data_struct kdata[_KERNEL_CAPABILITY_U32S];
 		unsigned i;
 
 		for (i = 0; i < tocopy; i++) {
@@ -128,7 +176,7 @@ out:
 		}
 
 		/*
-		 * Note, in the case, tocopy < _LINUX_CAPABILITY_U32S,
+		 * Note, in the case, tocopy < _KERNEL_CAPABILITY_U32S,
 		 * we silently drop the upper capabilities here. This
 		 * has the effect of making older libcap
 		 * implementations implicitly drop upper capability
@@ -240,30 +288,16 @@ static inline int cap_set_all(kernel_cap
  */
 asmlinkage long sys_capset(cap_user_header_t header, const cap_user_data_t data)
 {
-	struct __user_cap_data_struct kdata[_LINUX_CAPABILITY_U32S];
+	struct __user_cap_data_struct kdata[_KERNEL_CAPABILITY_U32S];
 	unsigned i, tocopy;
 	kernel_cap_t inheritable, permitted, effective;
-	__u32 version;
 	struct task_struct *target;
 	int ret;
 	pid_t pid;
 
-	if (get_user(version, &header->version))
-		return -EFAULT;
-
-	switch (version) {
-	case _LINUX_CAPABILITY_VERSION_1:
-		warn_legacy_capability_use();
-		tocopy = _LINUX_CAPABILITY_U32S_1;
-		break;
-	case _LINUX_CAPABILITY_VERSION_2:
-		tocopy = _LINUX_CAPABILITY_U32S_2;
-		break;
-	default:
-		if (put_user(_LINUX_CAPABILITY_VERSION, &header->version))
-			return -EFAULT;
-		return -EINVAL;
-	}
+	ret = cap_validate_magic(header, &tocopy);
+	if (ret != 0)
+		return ret;
 
 	if (get_user(pid, &header->pid))
 		return -EFAULT;
@@ -281,7 +315,7 @@ asmlinkage long sys_capset(cap_user_head
 		permitted.cap[i] = kdata[i].permitted;
 		inheritable.cap[i] = kdata[i].inheritable;
 	}
-	while (i < _LINUX_CAPABILITY_U32S) {
+	while (i < _KERNEL_CAPABILITY_U32S) {
 		effective.cap[i] = 0;
 		permitted.cap[i] = 0;
 		inheritable.cap[i] = 0;
_

Patches currently in -mm which might be from morgan@kernel.org are

capabilities-remain-source-compatible-with-32-bit-raw-legacy-capability-support.patch
capabilities-remain-source-compatible-with-32-bit-raw-legacy-capability-support-fix.patch
capabilities-remain-source-compatible-with-32-bit-raw-legacy-capability-support-fix-fix.patch
security-protect-legacy-apps-from-insufficient-privilege.patch
security-protect-legacy-apps-from-insufficient-privilege-cleanup.patch

