From: akpm@linux-foundation.org
Subject: + exec-cleanup-the-config_modules-logic.patch added to -mm tree
Date: Mon, 05 Aug 2013 13:45:13 -0700
Message-ID: <52000ed9.Bfs+AnVhDSIQlUf+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42540 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905Ab3HEUpO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Aug 2013 16:45:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zml@linux.vnet.ibm.com, zbr@ioremap.net, viro@ZenIV.linux.org.uk, keescook@chromium.org, oleg@redhat.com

Subject: + exec-cleanup-the-config_modules-logic.patch added to -mm tree
To: oleg@redhat.com,keescook@chromium.org,viro@ZenIV.linux.org.uk,zbr@ioremap.net,zml@linux.vnet.ibm.com
From: akpm@linux-foundation.org
Date: Mon, 05 Aug 2013 13:45:13 -0700


The patch titled
     Subject: exec: cleanup the CONFIG_MODULES logic
has been added to the -mm tree.  Its filename is
     exec-cleanup-the-config_modules-logic.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/exec-cleanup-the-config_modules-logic.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/exec-cleanup-the-config_modules-logic.patch

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
Subject: exec: cleanup the CONFIG_MODULES logic

search_binary_handler() uses "for (try=0; try<2; try++)" to avoid "goto"
but the code looks too complicated and horrible imho.  We still need to
check "try == 0" before request_module() and add the additional "break"
for !CONFIG_MODULES case.

Kill this loop and use a simple "bool need_retry" + "goto retry".  The
code looks much simpler and we do not even need ifdef's, gcc can optimize
out the "if (need_retry)" block if !IS_ENABLED().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Zach Levis <zml@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   68 +++++++++++++++++++++++-----------------------------
 1 file changed, 31 insertions(+), 37 deletions(-)

diff -puN fs/exec.c~exec-cleanup-the-config_modules-logic fs/exec.c
--- a/fs/exec.c~exec-cleanup-the-config_modules-logic
+++ a/fs/exec.c
@@ -1367,13 +1367,15 @@ out:
 }
 EXPORT_SYMBOL(remove_arg_zero);
 
+#define printable(c) (((c)=='\t') || ((c)=='\n') || (0x20<=(c) && (c)<=0x7e))
 /*
  * cycle the list of binary formats handler, until one recognizes the image
  */
 int search_binary_handler(struct linux_binprm *bprm)
 {
-	int try, retval;
+	bool need_retry = IS_ENABLED(CONFIG_MODULES);
 	struct linux_binfmt *fmt;
+	int retval;
 
 	/* This allows 4 levels of binfmt rewrites before failing hard. */
 	if (bprm->recursion_depth > 5)
@@ -1388,47 +1390,39 @@ int search_binary_handler(struct linux_b
 		return retval;
 
 	retval = -ENOENT;
-	for (try=0; try<2; try++) {
-		read_lock(&binfmt_lock);
-		list_for_each_entry(fmt, &formats, lh) {
-			if (!try_module_get(fmt->module))
-				continue;
-			read_unlock(&binfmt_lock);
-			bprm->recursion_depth++;
-			retval = fmt->load_binary(bprm);
-			bprm->recursion_depth--;
-			if (retval >= 0) {
-				put_binfmt(fmt);
-				return retval;
-			}
-			read_lock(&binfmt_lock);
+ retry:
+	read_lock(&binfmt_lock);
+	list_for_each_entry(fmt, &formats, lh) {
+		if (!try_module_get(fmt->module))
+			continue;
+		read_unlock(&binfmt_lock);
+		bprm->recursion_depth++;
+		retval = fmt->load_binary(bprm);
+		bprm->recursion_depth--;
+		if (retval >= 0) {
 			put_binfmt(fmt);
-			if (retval != -ENOEXEC || bprm->mm == NULL)
-				break;
-			if (!bprm->file) {
-				read_unlock(&binfmt_lock);
-				return retval;
-			}
+			return retval;
 		}
-		read_unlock(&binfmt_lock);
-#ifdef CONFIG_MODULES
-		if (retval != -ENOEXEC || bprm->mm == NULL) {
+		read_lock(&binfmt_lock);
+		put_binfmt(fmt);
+		if (retval != -ENOEXEC || bprm->mm == NULL)
 			break;
-		} else {
-#define printable(c) (((c)=='\t') || ((c)=='\n') || (0x20<=(c) && (c)<=0x7e))
-			if (printable(bprm->buf[0]) &&
-			    printable(bprm->buf[1]) &&
-			    printable(bprm->buf[2]) &&
-			    printable(bprm->buf[3]))
-				break; /* -ENOEXEC */
-			if (try)
-				break; /* -ENOEXEC */
-			request_module("binfmt-%04x", *(unsigned short *)(&bprm->buf[2]));
+		if (!bprm->file) {
+			read_unlock(&binfmt_lock);
+			return retval;
 		}
-#else
-		break;
-#endif
 	}
+	read_unlock(&binfmt_lock);
+
+	if (need_retry && retval == -ENOEXEC && bprm->mm) {
+		if (printable(bprm->buf[0]) && printable(bprm->buf[1]) &&
+		    printable(bprm->buf[2]) && printable(bprm->buf[3]))
+			return retval;
+		request_module("binfmt-%04x", *(ushort *)(bprm->buf + 2));
+		need_retry = false;
+		goto retry;
+	}
+
 	return retval;
 }
 EXPORT_SYMBOL(search_binary_handler);
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

