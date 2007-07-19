From: akpm@linux-foundation.org
Subject: + file-caps-clean-up-for-linux-capabilityh.patch added to -mm tree
Date: Thu, 19 Jul 2007 15:44:02 -0700
Message-ID: <200707192244.l6JMi2B4026789@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33027 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751386AbXGSWo2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 18:44:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: morgan@kernel.org, casey@schaufler-ca.com, chris@friedhoff.org, chrisw@sous-sol.org, jmorris@namei.org, kaigai@kaigai.gr.jp, sds@tycho.nsa.gov, serue@us.ibm.com


The patch titled
     file-caps clean up for linux/capability.h
has been added to the -mm tree.  Its filename is
     file-caps-clean-up-for-linux-capabilityh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: file-caps clean up for linux/capability.h
From: Andrew Morgan <morgan@kernel.org>

These changes are needed to make compiling libcap work again.

You can download the corresponding (file-capability supporting) libcap
sources from here:

  http://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2

Signed-off-by: Andrew Morgan <morgan@kernel.org>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: James Morris <jmorris@namei.org>
Cc: KaiGai Kohei <kaigai@kaigai.gr.jp>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: <chris@friedhoff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/capability.h |   36 +++++++++++++++++------------------
 1 files changed, 18 insertions(+), 18 deletions(-)

diff -puN include/linux/capability.h~file-caps-clean-up-for-linux-capabilityh include/linux/capability.h
--- a/include/linux/capability.h~file-caps-clean-up-for-linux-capabilityh
+++ a/include/linux/capability.h
@@ -1,14 +1,14 @@
 /*
  * This is <linux/capability.h>
  *
- * Andrew G. Morgan <morgan@transmeta.com>
+ * Andrew G. Morgan <morgan@kernel.org>
  * Alexander Kjeldaas <astor@guardian.no>
  * with help from Aleph1, Roland Buresund and Andrew Main.
  *
  * See here for the libcap library ("POSIX draft" compliance):
  *
- * ftp://linux.kernel.org/pub/linux/libs/security/linux-privs/kernel-2.2/
- */ 
+ * ftp://linux.kernel.org/pub/linux/libs/security/linux-privs/kernel-2.6/
+ */
 
 #ifndef _LINUX_CAPABILITY_H
 #define _LINUX_CAPABILITY_H
@@ -28,14 +28,14 @@ struct task_struct;
    following structure to such a composite is better handled in a user
    library since the draft standard requires the use of malloc/free
    etc.. */
- 
+
 #define _LINUX_CAPABILITY_VERSION  0x19980330
 
 typedef struct __user_cap_header_struct {
 	__u32 version;
 	int pid;
 } __user *cap_user_header_t;
- 
+
 typedef struct __user_cap_data_struct {
         __u32 effective;
         __u32 permitted;
@@ -47,15 +47,13 @@ typedef struct __user_cap_data_struct {
 
 #define XATTR_CAPS_SZ (3*sizeof(__le32))
 #define VFS_CAP_REVISION_MASK	0xFF000000
-#define VFS_CAP_REVISION	0x01000000
+#define VFS_CAP_REVISION_1	0x01000000
+
+#define VFS_CAP_REVISION	VFS_CAP_REVISION_1
 
 #define VFS_CAP_FLAGS_MASK	~VFS_CAP_REVISION_MASK
 #define VFS_CAP_FLAGS_EFFECTIVE	0x000001
 
-#ifdef __KERNEL__
-
-#include <asm/current.h>
-
 struct vfs_cap_data {
 	__u32 magic_etc;  /* Little endian */
 	struct {
@@ -64,6 +62,10 @@ struct vfs_cap_data {
 	} data[1];
 };
 
+#ifdef __KERNEL__
+
+#include <asm/current.h>
+
 /* #define STRICT_CAP_T_TYPECHECKS */
 
 #ifdef STRICT_CAP_T_TYPECHECKS
@@ -77,7 +79,7 @@ typedef struct kernel_cap_struct {
 typedef __u32 kernel_cap_t;
 
 #endif
-  
+
 #define _USER_CAP_HEADER_SIZE  (2*sizeof(__u32))
 #define _KERNEL_CAP_T_SIZE     (sizeof(kernel_cap_t))
 
@@ -85,7 +87,7 @@ typedef __u32 kernel_cap_t;
 
 
 /**
- ** POSIX-draft defined capabilities. 
+ ** POSIX-draft defined capabilities.
  **/
 
 /* In a system with the [_POSIX_CHOWN_RESTRICTED] option defined, this
@@ -105,7 +107,7 @@ typedef __u32 kernel_cap_t;
    defined. Excluding DAC access covered by CAP_LINUX_IMMUTABLE. */
 
 #define CAP_DAC_READ_SEARCH  2
-    
+
 /* Overrides all restrictions about allowed operations on files, where
    file owner ID must be equal to the user ID, except where CAP_FSETID
    is applicable. It doesn't override MAC and DAC restrictions. */
@@ -275,7 +277,7 @@ typedef __u32 kernel_cap_t;
 /* Override reserved space on ext2 filesystem */
 /* Modify data journaling mode on ext3 filesystem (uses journaling
    resources) */
-/* NOTE: ext2 honors fsuid when checking for resource overrides, so 
+/* NOTE: ext2 honors fsuid when checking for resource overrides, so
    you can override using fsuid too */
 /* Override size restrictions on IPC message queues */
 /* Allow more than 64hz interrupts from the real-time clock */
@@ -309,10 +311,8 @@ typedef __u32 kernel_cap_t;
 
 #define CAP_SETFCAP	     31
 
-#define CAP_NUMCAPS	     32
-
 #ifdef __KERNEL__
-/* 
+/*
  * Bounding set
  */
 extern kernel_cap_t cap_bset;
@@ -320,7 +320,7 @@ extern kernel_cap_t cap_bset;
 /*
  * Internal kernel functions only
  */
- 
+
 #ifdef STRICT_CAP_T_TYPECHECKS
 
 #define to_cap_t(x) { x }
_

Patches currently in -mm which might be from morgan@kernel.org are

implement-file-posix-capabilities.patch
implement-file-posix-capabilities-fix.patch
file-capabilities-introduce-cap_setfcap.patch
file-capabilities-get_file_caps-cleanups.patch
file-caps-update-selinux-xattr-hooks.patch
file-capabilities-clear-caps-cleanup.patch
file-capabilities-clear-caps-cleanup-fix.patch
file-capabilities-change-xattr-format-v2.patch
file-capabilities-change-fe-to-a-bool.patch
file-caps-clean-up-for-linux-capabilityh.patch
