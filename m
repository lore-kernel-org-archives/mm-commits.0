From: akpm@linux-foundation.org
Subject: + tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up.patch added to -mm tree
Date: Sun, 18 Mar 2007 22:33:15 -0800
Message-ID: <200703190633.l2J6XF72007897@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44388 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965691AbXCSGd2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Mar 2007 02:33:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, alan@lxorguk.ukuu.org.uk


The patch titled
     tty: in tiocsctty when we steal a tty hang it up.
has been added to the -mm tree.  Its filename is
     tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tty: in tiocsctty when we steal a tty hang it up.
From: Eric W. Biederman <ebiederm@xmission.com>

The linux implementation of TIOCSCTTY includes an extention that provides for
making a tty that is already the controlling tty of another session our
controlling tty.  To do this it must steal the tty away from the previous
group that used it as a controlling tty.

The way we are currently stealing the controlling tty away is weird.  In
general there is a well defined process for loosing the controlling tty.  TTY
hangup processing.  However the linux extension that steals the tty from
another process group does not invoke that.  And instead just forgets the
controlling tty of the processes that were part of the session.

I can not imagine how our current behaviour of stealling a tty is correct or
how a set of processes could deal with it reasonably.  So this patch modifies
the tty stealing to call tty_vhangup so we get full hanup processing when we
steal a tty.

I did a quick survey of user space the only application I found using this
extended behaviour is sysvinit.  I perform a limited amount of testing and
nothing appears to have broken with this change.  And I did see sysvinit pass
through this piece of code.

In terms of the tty leaks that started this patch series this fix should
remove the last path into proc_clear_tty that has a session or a process
group.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_io.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/char/tty_io.c~tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up
+++ a/drivers/char/tty_io.c
@@ -2980,9 +2980,7 @@ static int tiocsctty(struct tty_struct *
 			/*
 			 * Steal it away
 			 */
-			read_lock(&tasklist_lock);
-			session_clear_tty(tty->session);
-			read_unlock(&tasklist_lock);
+			tty_vhangup(tty);
 		} else {
 			ret = -EPERM;
 			goto unlock;
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
