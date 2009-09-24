From: akpm@linux-foundation.org
Subject: [merged] exec-fix-set_binfmt-vs-sys_delete_module-race.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:35:42 -0700
Message-ID: <200909241935.n8OJZgC7000981@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43958 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753155AbZIXTgD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:36:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, h-shimamoto@ct.jp.nec.com, roland@redhat.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     exec: fix set_binfmt() vs sys_delete_module() race
has been removed from the -mm tree.  Its filename was
     exec-fix-set_binfmt-vs-sys_delete_module-race.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: exec: fix set_binfmt() vs sys_delete_module() race
From: Oleg Nesterov <oleg@redhat.com>

sys_delete_module() can set MODULE_STATE_GOING after
search_binary_handler() does try_module_get().  In this case
set_binfmt()->try_module_get() fails but since none of the callers
check the returned error, the task will run with the wrong old
->binfmt.

The proper fix should change all ->load_binary() methods, but we can
rely on fact that the caller must hold a reference to binfmt->module
and use __module_get() which never fails.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c               |   14 +++++---------
 include/linux/binfmts.h |    2 +-
 2 files changed, 6 insertions(+), 10 deletions(-)

diff -puN fs/exec.c~exec-fix-set_binfmt-vs-sys_delete_module-race fs/exec.c
--- a/fs/exec.c~exec-fix-set_binfmt-vs-sys_delete_module-race
+++ a/fs/exec.c
@@ -1395,18 +1395,14 @@ out_ret:
 	return retval;
 }
 
-int set_binfmt(struct linux_binfmt *new)
+void set_binfmt(struct linux_binfmt *new)
 {
-	struct linux_binfmt *old = current->binfmt;
+	if (current->binfmt)
+		module_put(current->binfmt->module);
 
-	if (new) {
-		if (!try_module_get(new->module))
-			return -1;
-	}
 	current->binfmt = new;
-	if (old)
-		module_put(old->module);
-	return 0;
+	if (new)
+		__module_get(new->module);
 }
 
 EXPORT_SYMBOL(set_binfmt);
diff -puN include/linux/binfmts.h~exec-fix-set_binfmt-vs-sys_delete_module-race include/linux/binfmts.h
--- a/include/linux/binfmts.h~exec-fix-set_binfmt-vs-sys_delete_module-race
+++ a/include/linux/binfmts.h
@@ -120,7 +120,7 @@ extern int copy_strings_kernel(int argc,
 extern int prepare_bprm_creds(struct linux_binprm *bprm);
 extern void install_exec_creds(struct linux_binprm *bprm);
 extern void do_coredump(long signr, int exit_code, struct pt_regs *regs);
-extern int set_binfmt(struct linux_binfmt *new);
+extern void set_binfmt(struct linux_binfmt *new);
 extern void free_bprm(struct linux_binprm *);
 
 #endif /* __KERNEL__ */
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch
utrace-core.patch

