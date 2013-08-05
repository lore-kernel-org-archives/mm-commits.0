From: akpm@linux-foundation.org
Subject: +
 exec-kill-load_binary-=-null-check-in-search_binary_handler.patch added to
 -mm tree
Date: Mon, 05 Aug 2013 13:45:12 -0700
Message-ID: <52000ed8.U+rOtqLskt1Cl4oP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42538 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab3HEUpN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Aug 2013 16:45:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zml@linux.vnet.ibm.com, zbr@ioremap.net, viro@ZenIV.linux.org.uk, keescook@chromium.org, oleg@redhat.com

Subject: + exec-kill-load_binary-=-null-check-in-search_binary_handler.patch added to -mm tree
To: oleg@redhat.com,keescook@chromium.org,viro@ZenIV.linux.org.uk,zbr@ioremap.net,zml@linux.vnet.ibm.com
From: akpm@linux-foundation.org
Date: Mon, 05 Aug 2013 13:45:12 -0700


The patch titled
     Subject: exec: kill ->load_binary != NULL check in search_binary_handler()
has been added to the -mm tree.  Its filename is
     exec-kill-load_binary-=-null-check-in-search_binary_handler.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/exec-kill-load_binary-=-null-check-in-search_binary_handler.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/exec-kill-load_binary-=-null-check-in-search_binary_handler.patch

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
Subject: exec: kill ->load_binary != NULL check in search_binary_handler()

search_binary_handler() checks ->load_binary != NULL for no reason, this
method should be always defined.  Turn this check into WARN_ON() and move
it into __register_binfmt().

Also, kill the function pointer.  The current code looks confusing, as if
->load_binary can go away after read_unlock(&binfmt_lock).  But we rely on
module_get(fmt->module), this fmt can't be changed or unregistered,
otherwise this code is buggy anyway.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Zach Levis <zml@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN fs/exec.c~exec-kill-load_binary-=-null-check-in-search_binary_handler fs/exec.c
--- a/fs/exec.c~exec-kill-load_binary-=-null-check-in-search_binary_handler
+++ a/fs/exec.c
@@ -74,6 +74,8 @@ static DEFINE_RWLOCK(binfmt_lock);
 void __register_binfmt(struct linux_binfmt * fmt, int insert)
 {
 	BUG_ON(!fmt);
+	if (WARN_ON(!fmt->load_binary))
+		return;
 	write_lock(&binfmt_lock);
 	insert ? list_add(&fmt->lh, &formats) :
 		 list_add_tail(&fmt->lh, &formats);
@@ -1389,14 +1391,11 @@ int search_binary_handler(struct linux_b
 	for (try=0; try<2; try++) {
 		read_lock(&binfmt_lock);
 		list_for_each_entry(fmt, &formats, lh) {
-			int (*fn)(struct linux_binprm *) = fmt->load_binary;
-			if (!fn)
-				continue;
 			if (!try_module_get(fmt->module))
 				continue;
 			read_unlock(&binfmt_lock);
 			bprm->recursion_depth++;
-			retval = fn(bprm);
+			retval = fmt->load_binary(bprm);
 			bprm->recursion_depth--;
 			if (retval >= 0) {
 				put_binfmt(fmt);
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

