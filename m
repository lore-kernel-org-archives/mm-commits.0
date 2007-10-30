From: akpm@linux-foundation.org
Subject: + uml-get-rid-of-asmlinkage.patch added to -mm tree
Date: Tue, 30 Oct 2007 15:26:00 -0700
Message-ID: <200710302226.l9UMQ0Sl031090@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60117 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752511AbXJ3W0d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 18:26:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: get rid of asmlinkage
has been added to the -mm tree.  Its filename is
     uml-get-rid-of-asmlinkage.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: get rid of asmlinkage
From: Jeff Dike <jdike@addtoit.com>

Get rid of asmlinkage and remove some old cruft from asm/linkage.h.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/sys-i386/tls.c   |    9 +++++----
 include/asm-um/linkage.h |    7 -------
 2 files changed, 5 insertions(+), 11 deletions(-)

diff -puN arch/um/sys-i386/tls.c~uml-get-rid-of-asmlinkage arch/um/sys-i386/tls.c
--- a/arch/um/sys-i386/tls.c~uml-get-rid-of-asmlinkage
+++ a/arch/um/sys-i386/tls.c
@@ -225,7 +225,8 @@ out:
 }
 
 /* XXX: use do_get_thread_area to read the host value? I'm not at all sure! */
-static int get_tls_entry(struct task_struct* task, struct user_desc *info, int idx)
+static int get_tls_entry(struct task_struct* task, struct user_desc *info,
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
@@ -3,11 +3,4 @@
 
 #include "asm/arch/linkage.h"
 
-
-/* <linux/linkage.h> will pick sane defaults */
-#ifdef CONFIG_GPROF
-#undef FASTCALL
-#undef fastcall
-#endif
-
 #endif
_

Patches currently in -mm which might be from jdike@addtoit.com are

git-kvm.patch
arch-um-drivers-ubd_kernc-a-warning-fix.patch
uml-implement-get_wchan.patch
uml-get-rid-of-asmlinkage.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
