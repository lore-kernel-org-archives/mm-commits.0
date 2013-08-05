From: akpm@linux-foundation.org
Subject: + exec-move-allow_write_access-fput-to-exec_binprm.patch added to -mm tree
Date: Mon, 05 Aug 2013 13:45:11 -0700
Message-ID: <52000ed7.ckTOGRDYgEGS+9/L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42531 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313Ab3HEUpM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Aug 2013 16:45:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zml@linux.vnet.ibm.com, zbr@ioremap.net, viro@ZenIV.linux.org.uk, keescook@chromium.org, oleg@redhat.com

Subject: + exec-move-allow_write_access-fput-to-exec_binprm.patch added to -mm tree
To: oleg@redhat.com,keescook@chromium.org,viro@ZenIV.linux.org.uk,zbr@ioremap.net,zml@linux.vnet.ibm.com
From: akpm@linux-foundation.org
Date: Mon, 05 Aug 2013 13:45:11 -0700


The patch titled
     Subject: exec: move allow_write_access/fput to exec_binprm()
has been added to the -mm tree.  Its filename is
     exec-move-allow_write_access-fput-to-exec_binprm.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/exec-move-allow_write_access-fput-to-exec_binprm.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/exec-move-allow_write_access-fput-to-exec_binprm.patch

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
Subject: exec: move allow_write_access/fput to exec_binprm()

When search_binary_handler() succeeds it does allow_write_access() and
fput(), then it clears bprm->file to ensure the caller will not do the
same.

We can simply move this code to exec_binprm() which is called only once. 
In fact we could move this to free_bprm() and remove the same code in
do_execve_common's error path.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Zach Levis <zml@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN fs/exec.c~exec-move-allow_write_access-fput-to-exec_binprm fs/exec.c
--- a/fs/exec.c~exec-move-allow_write_access-fput-to-exec_binprm
+++ a/fs/exec.c
@@ -1400,10 +1400,6 @@ int search_binary_handler(struct linux_b
 			bprm->recursion_depth--;
 			if (retval >= 0) {
 				put_binfmt(fmt);
-				allow_write_access(bprm->file);
-				if (bprm->file)
-					fput(bprm->file);
-				bprm->file = NULL;
 				return retval;
 			}
 			read_lock(&binfmt_lock);
@@ -1455,6 +1451,12 @@ static int exec_binprm(struct linux_binp
 		ptrace_event(PTRACE_EVENT_EXEC, old_vpid);
 		current->did_exec = 1;
 		proc_exec_connector(current);
+
+		if (bprm->file) {
+			allow_write_access(bprm->file);
+			fput(bprm->file);
+			bprm->file = NULL; /* to catch use-after-free */
+		}
 	}
 
 	return ret;
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

