From: akpm@linux-foundation.org
Subject: - tty-fix-two-reported-pid-leaks.patch removed from -mm tree
Date: Mon, 19 Mar 2007 14:04:20 -0800
Message-ID: <200703192204.l2JM4KBL018944@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58773 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030716AbXCSWEW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Mar 2007 18:04:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, catalin.marians@gmail.com, mm-commits@vger.kernel.org


The patch titled
     tty: fix two reported pid leaks
has been removed from the -mm tree.  Its filename was
     tty-fix-two-reported-pid-leaks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: tty: fix two reported pid leaks
From: Eric W. Biederman <ebiederm@xmission.com>

These leaks were reported by: Catalin Marinas <catalin.marians@gmail.com>
and I have been able to very by inspection they are possible.

When converting tty_io.c to store pids as struct pid pointers instead of
pid_t values it appears I overlooked two places where we stop using the pid
value.  The very obvious one is in do_tty_hangup, and the one the less
obvious one in __proc_set_tty.

When looking into the code __proc_set_tty only has pids that need to be put
because of failures of other parts of the code to properly perform hangup
processing.  Fixing the leak here in __proc_set_tty is easy and obviously
correct so I am doing that first.

Fixing the places that should be performing hangup processing is much less
obviously correct.  So those I'm aiming those patches at -mm.  for now, so
the can age a while before they are merged.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_io.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/char/tty_io.c~tty-fix-two-reported-pid-leaks drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~tty-fix-two-reported-pid-leaks
+++ a/drivers/char/tty_io.c
@@ -1374,6 +1374,8 @@ static void do_tty_hangup(struct work_st
 	read_unlock(&tasklist_lock);
 
 	tty->flags = 0;
+	put_pid(tty->session);
+	put_pid(tty->pgrp);
 	tty->session = NULL;
 	tty->pgrp = NULL;
 	tty->ctrl_status = 0;
@@ -3839,6 +3841,9 @@ static struct pid *__proc_set_tty(struct
 {
 	struct pid *old_pgrp;
 	if (tty) {
+		/* We should not have a session or pgrp to here but.... */
+		put_pid(tty->session);
+		put_pid(tty->pgrp);
 		tty->session = get_pid(task_session(tsk));
 		tty->pgrp = get_pid(task_pgrp(tsk));
 	}
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
powerpc-rtas-msi-support.patch
fix-i-oat-for-kexec.patch
i386-irq-kill-irq-compression.patch
x86_64-irq-remove-extra-smp_processor_id-calling.patch
remove-hardcoding-of-hard_smp_processor_id-on-up.patch
use-the-apic-to-determine-the-hardware-processor-id-i386.patch
use-the-apic-to-determine-the-hardware-processor-id-x86_64.patch
always-ask-the-hardware-to-obtain-hardware-processor.patch
allow-i386-crash-kernels-to-handle-x86_64-dumps.patch
allow-i386-crash-kernels-to-handle-x86_64-dumps-fix.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
allow-access-to-proc-pid-fd-after-setuid.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
fix-race-between-proc_get_inode-and-remove_proc_entry.patch
fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-reorder-struct-pid_dentry-to-save-space-on-64bit-archs-and-constify-them.patch
tty-remove-unnecessary-export-of-proc_clear_tty.patch
tty-simplify-calling-of-put_pid.patch
tty-introduce-no_tty-and-use-it-in-selinux.patch
tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up.patch
edac-k8-driver-coding-tidy.patch
statically-initialize-struct-pid-for-swapper.patch
explicitly-set-pgid-and-sid-of-init-process.patch
use-struct-pid-parameter-in-copy_process.patch
remove-the-likelypid-check-in-copy_process.patch
use-task_pgrp-task_session-in-copy_process.patch
kill-unused-sesssion-and-group-values-in-rocket-driver.patch
fix-some-coding-style-errors-in-autofs.patch
replace-pid_t-in-autofs-with-struct-pid-reference.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
