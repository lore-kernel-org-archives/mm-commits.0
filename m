From: akpm@linux-foundation.org
Subject: - uml-get-rid-of-asmlinkage.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:35:25 -0800
Message-ID: <200802052235.m15MZ6Wo012585@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46057 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760873AbYBEWl2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: get rid of asmlinkage
has been removed from the -mm tree.  Its filename was
     uml-get-rid-of-asmlinkage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: get rid of asmlinkage
From: Jeff Dike <jdike@addtoit.com>

Get rid of asmlinkage and remove some old cruft from asm/linkage.h.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/sys-i386/tls.c   |    9 +++++----
 include/asm-um/linkage.h |    6 ------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff -puN arch/um/sys-i386/tls.c~uml-get-rid-of-asmlinkage arch/um/sys-i386/tls.c
--- a/arch/um/sys-i386/tls.c~uml-get-rid-of-asmlinkage
+++ a/arch/um/sys-i386/tls.c
@@ -225,7 +225,8 @@ out:
 }
 
 /* XXX: use do_get_thread_area to read the host value? I'm not at all sure! */
-static int get_tls_entry(struct task_struct* task, struct user_desc *info, int idx)
+static int get_tls_entry(struct task_struct *task, struct user_desc *info,
+			 int idx)
 {
 	struct thread_struct *t = &task->thread;
 
@@ -263,7 +264,7 @@ clear:
 	goto out;
 }
 
-asmlinkage int sys_set_thread_area(struct user_desc __user *user_desc)
+int sys_set_thread_area(struct user_desc __user *user_desc)
 {
 	struct user_desc info;
 	int idx, ret;
@@ -298,7 +299,7 @@ asmlinkage int sys_set_thread_area(struc
  * i386. However the only possible error are caused by bugs.
  */
 int ptrace_set_thread_area(struct task_struct *child, int idx,
-		struct user_desc __user *user_desc)
+			   struct user_desc __user *user_desc)
 {
 	struct user_desc info;
 
@@ -311,7 +312,7 @@ int ptrace_set_thread_area(struct task_s
 	return set_tls_entry(child, &info, idx, 0);
 }
 
-asmlinkage int sys_get_thread_area(struct user_desc __user *user_desc)
+int sys_get_thread_area(struct user_desc __user *user_desc)
 {
 	struct user_desc info;
 	int idx, ret;
diff -puN include/asm-um/linkage.h~uml-get-rid-of-asmlinkage include/asm-um/linkage.h
--- a/include/asm-um/linkage.h~uml-get-rid-of-asmlinkage
+++ a/include/asm-um/linkage.h
@@ -3,10 +3,4 @@
 
 #include "asm/arch/linkage.h"
 
-
-/* <linux/linkage.h> will pick sane defaults */
-#ifdef CONFIG_GPROF
-#undef fastcall
-#endif
-
 #endif
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
random-add-async-notification-support-to-dev-random.patch
mount-options-fix-hostfs.patch
