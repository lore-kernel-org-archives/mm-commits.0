From: akpm@linux-foundation.org
Subject: + tty-remove-unnecessary-export-of-proc_clear_tty.patch added to -mm tree
Date: Sun, 18 Mar 2007 22:33:09 -0800
Message-ID: <200703190633.l2J6X9iT007882@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44384 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965694AbXCSGd0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Mar 2007 02:33:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, alan@lxorguk.ukuu.org.uk


The patch titled
     tty: remove unnecessary export of proc_clear_tty
has been added to the -mm tree.  Its filename is
     tty-remove-unnecessary-export-of-proc_clear_tty.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tty: remove unnecessary export of proc_clear_tty
From: Eric W. Biederman <ebiederm@xmission.com>

All of the users of proc_clear_tty are compiled into the kernel so exporting
this symbol appears gratuitous.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_io.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/char/tty_io.c~tty-remove-unnecessary-export-of-proc_clear_tty drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~tty-remove-unnecessary-export-of-proc_clear_tty
+++ a/drivers/char/tty_io.c
@@ -3835,7 +3835,6 @@ void proc_clear_tty(struct task_struct *
 	p->signal->tty = NULL;
 	spin_unlock_irq(&p->sighand->siglock);
 }
-EXPORT_SYMBOL(proc_clear_tty);
 
 static struct pid *__proc_set_tty(struct task_struct *tsk, struct tty_struct *tty)
 {
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
tty-fix-two-reported-pid-leaks.patch
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
