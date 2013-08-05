From: akpm@linux-foundation.org
Subject: + exec-proc_exec_connector-should-be-called-only-once.patch added to -mm tree
Date: Mon, 05 Aug 2013 13:45:10 -0700
Message-ID: <52000ed6.aJCNIEkB4Zk0CCuE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42526 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab3HEUpL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Aug 2013 16:45:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zml@linux.vnet.ibm.com, zbr@ioremap.net, viro@ZenIV.linux.org.uk, keescook@chromium.org, oleg@redhat.com

Subject: + exec-proc_exec_connector-should-be-called-only-once.patch added to -mm tree
To: oleg@redhat.com,keescook@chromium.org,viro@ZenIV.linux.org.uk,zbr@ioremap.net,zml@linux.vnet.ibm.com
From: akpm@linux-foundation.org
Date: Mon, 05 Aug 2013 13:45:10 -0700


The patch titled
     Subject: exec: proc_exec_connector() should be called only once
has been added to the -mm tree.  Its filename is
     exec-proc_exec_connector-should-be-called-only-once.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/exec-proc_exec_connector-should-be-called-only-once.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/exec-proc_exec_connector-should-be-called-only-once.patch

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
Subject: exec: proc_exec_connector() should be called only once

A separate one-liner with the minor fix.

PROC_EVENT_EXEC reports the "exec" event, but this message is sent at
least twice if search_binary_handler() is called by ->load_binary()
recursively, say, load_script().

Move it to exec_binprm(), this is "depth == 0" code too.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Zach Levis <zml@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/exec.c~exec-proc_exec_connector-should-be-called-only-once fs/exec.c
--- a/fs/exec.c~exec-proc_exec_connector-should-be-called-only-once
+++ a/fs/exec.c
@@ -1404,7 +1404,6 @@ int search_binary_handler(struct linux_b
 				if (bprm->file)
 					fput(bprm->file);
 				bprm->file = NULL;
-				proc_exec_connector(current);
 				return retval;
 			}
 			read_lock(&binfmt_lock);
@@ -1455,6 +1454,7 @@ static int exec_binprm(struct linux_binp
 		trace_sched_process_exec(current, old_pid, bprm);
 		ptrace_event(PTRACE_EVENT_EXEC, old_vpid);
 		current->did_exec = 1;
+		proc_exec_connector(current);
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

