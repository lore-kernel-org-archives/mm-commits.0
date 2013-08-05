From: akpm@linux-foundation.org
Subject: + exec-kill-int-depth-in-search_binary_handler.patch added to -mm tree
Date: Mon, 05 Aug 2013 13:45:09 -0700
Message-ID: <52000ed5.rHCuNhrv8tDnvgXi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42522 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905Ab3HEUpK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Aug 2013 16:45:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zml@linux.vnet.ibm.com, zbr@ioremap.net, viro@ZenIV.linux.org.uk, keescook@chromium.org, oleg@redhat.com

Subject: + exec-kill-int-depth-in-search_binary_handler.patch added to -mm tree
To: oleg@redhat.com,keescook@chromium.org,viro@ZenIV.linux.org.uk,zbr@ioremap.net,zml@linux.vnet.ibm.com
From: akpm@linux-foundation.org
Date: Mon, 05 Aug 2013 13:45:09 -0700


The patch titled
     Subject: exec: kill "int depth" in search_binary_handler()
has been added to the -mm tree.  Its filename is
     exec-kill-int-depth-in-search_binary_handler.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/exec-kill-int-depth-in-search_binary_handler.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/exec-kill-int-depth-in-search_binary_handler.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: exec: kill "int depth" in search_binary_handler()

Nobody except search_binary_handler() should touch ->recursion_depth, "int
depth" buys nothing but complicates the code, kill it.

Probably we should also kill "fn" and the !NULL check, ->load_binary
should be always defined.  And it can not go away after read_unlock() or
this code is buggy anyway.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Zach Levis <zml@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c               |    9 ++++-----
 include/linux/binfmts.h |    2 +-
 2 files changed, 5 insertions(+), 6 deletions(-)

diff -puN fs/exec.c~exec-kill-int-depth-in-search_binary_handler fs/exec.c
--- a/fs/exec.c~exec-kill-int-depth-in-search_binary_handler
+++ a/fs/exec.c
@@ -1370,12 +1370,11 @@ EXPORT_SYMBOL(remove_arg_zero);
  */
 int search_binary_handler(struct linux_binprm *bprm)
 {
-	unsigned int depth = bprm->recursion_depth;
-	int try,retval;
+	int try, retval;
 	struct linux_binfmt *fmt;
 
 	/* This allows 4 levels of binfmt rewrites before failing hard. */
-	if (depth > 5)
+	if (bprm->recursion_depth > 5)
 		return -ELOOP;
 
 	retval = security_bprm_check(bprm);
@@ -1396,9 +1395,9 @@ int search_binary_handler(struct linux_b
 			if (!try_module_get(fmt->module))
 				continue;
 			read_unlock(&binfmt_lock);
-			bprm->recursion_depth = depth + 1;
+			bprm->recursion_depth++;
 			retval = fn(bprm);
-			bprm->recursion_depth = depth;
+			bprm->recursion_depth--;
 			if (retval >= 0) {
 				put_binfmt(fmt);
 				allow_write_access(bprm->file);
diff -puN include/linux/binfmts.h~exec-kill-int-depth-in-search_binary_handler include/linux/binfmts.h
--- a/include/linux/binfmts.h~exec-kill-int-depth-in-search_binary_handler
+++ a/include/linux/binfmts.h
@@ -31,7 +31,7 @@ struct linux_binprm {
 #ifdef __alpha__
 	unsigned int taso:1;
 #endif
-	unsigned int recursion_depth;
+	unsigned int recursion_depth; /* only for search_binary_handler() */
 	struct file * file;
 	struct cred *cred;	/* new credentials */
 	int unsafe;		/* how unsafe this exec is (mask of LSM_UNSAFE_*) */
_

Patches currently in -mm which might be from oleg@redhat.com are

x86-get_unmapped_area-use-proper-mmap-base-for-bottom-up-direction.patch
include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch
mm-mempolicy-turn-vma_set_policy-into-vma_dup_policy.patch
mm-shift-vm_grows-check-from-mmap_region-to-do_mmap_pgoff-v2.patch
mm-do_mmap_pgoff-cleanup-the-usage-of-file_inode.patch
mm-mmap_region-kill-correct_wcount-inode-use-allow_write_access.patch
kernel-wide-fix-missing-validations-on-__get-__put-__copy_to-__copy_from_user.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch
signals-eventpoll-set-saved_sigmask-at-the-start.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
exec-introduce-exec_binprm-for-depth-==-0-code.patch
exec-kill-int-depth-in-search_binary_handler.patch
exec-proc_exec_connector-should-be-called-only-once.patch
exec-move-allow_write_access-fput-to-exec_binprm.patch
exec-kill-load_binary-=-null-check-in-search_binary_handler.patch
exec-cleanup-the-config_modules-logic.patch
exec-dont-retry-if-request_module-fails.patch
exec-cleanup-the-error-handling-in-search_binary_handler.patch
linux-next.patch

