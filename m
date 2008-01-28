From: akpm@linux-foundation.org
Subject: + uml-debug_shirq-fixes.patch added to -mm tree
Date: Sun, 27 Jan 2008 21:23:18 -0800
Message-ID: <200801280524.m0S5ODJs013750@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36402 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750932AbYA1FY3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 00:24:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com, magotari@gmail.com


The patch titled
     uml: DEBUG_SHIRQ fixes
has been added to the -mm tree.  Its filename is
     uml-debug_shirq-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: DEBUG_SHIRQ fixes
From: Jeff Dike <jdike@addtoit.com>

A couple more DEBUG_SHIRQ fixes.

The previous mconsole blocking fix exposed the lack of O_NONBLOCK on the
mconsole socket.

Also, winch_interrupt started crashing because it is called at irq free time
and it tries to dereference tty->driver_data, which has already been set to
NULL.

I added some error cleanup in mconsole_init while I was there.

Cc: "Karol Swietlicki" <magotari@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/line.c          |    8 +++++---
 arch/um/drivers/mconsole_kern.c |    8 +++++++-
 2 files changed, 12 insertions(+), 4 deletions(-)

diff -puN arch/um/drivers/line.c~uml-debug_shirq-fixes arch/um/drivers/line.c
--- a/arch/um/drivers/line.c~uml-debug_shirq-fixes
+++ a/arch/um/drivers/line.c
@@ -774,9 +774,11 @@ static irqreturn_t winch_interrupt(int i
 	tty = winch->tty;
 	if (tty != NULL) {
 		line = tty->driver_data;
-		chan_window_size(&line->chan_list, &tty->winsize.ws_row,
-				 &tty->winsize.ws_col);
-		kill_pgrp(tty->pgrp, SIGWINCH, 1);
+		if (line != NULL) {
+			chan_window_size(&line->chan_list, &tty->winsize.ws_row,
+					 &tty->winsize.ws_col);
+			kill_pgrp(tty->pgrp, SIGWINCH, 1);
+		}
 	}
  out:
 	if (winch->fd != -1)
diff -puN arch/um/drivers/mconsole_kern.c~uml-debug_shirq-fixes arch/um/drivers/mconsole_kern.c
--- a/arch/um/drivers/mconsole_kern.c~uml-debug_shirq-fixes
+++ a/arch/um/drivers/mconsole_kern.c
@@ -792,6 +792,8 @@ static int __init mconsole_init(void)
 		printk(KERN_ERR "Failed to initialize management console\n");
 		return 1;
 	}
+	if (os_set_fd_block(sock, 0))
+		goto out;
 
 	register_reboot_notifier(&reboot_notifier);
 
@@ -800,7 +802,7 @@ static int __init mconsole_init(void)
 			     "mconsole", (void *)sock);
 	if (err) {
 		printk(KERN_ERR "Failed to get IRQ for management console\n");
-		return 1;
+		goto out;
 	}
 
 	if (notify_socket != NULL) {
@@ -816,6 +818,10 @@ static int __init mconsole_init(void)
 	printk(KERN_INFO "mconsole (version %d) initialized on %s\n",
 	       MCONSOLE_VERSION, mconsole_socket_name);
 	return 0;
+
+ out:
+	os_close_file(sock);
+	return 1;
 }
 
 __initcall(mconsole_init);
_

Patches currently in -mm which might be from jdike@addtoit.com are

git-kvm.patch
git-x86.patch
uml-arch-um-include-inith-needs-a-definition-of-__used.patch
uml-implement-get_wchan.patch
uml-implement-get_wchan-fix.patch
uml-get-rid-of-asmlinkage.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-document-new-ubd-flag.patch
uml-further-bugsc-tidying.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
uml-smp-needs-to-depend-on-broken-for-now.patch
uml-console-driver-cleanups.patch
uml-clonec-tidying.patch
uml-borrow-consth-techniques.patch
uml-delete-some-unused-headers.patch
uml-allow-lflags-on-command-line.patch
uml-tidy-kern_utilh.patch
uml-tidy-pgtableh.patch
uml-tidy-pgtableh-fix.patch
uml-reconst-a-parameter.patch
arch-um-remove-duplicate-includes.patch
uml-host-tls-diagnostics.patch
uml-move-um_virt_to_phys.patch
uml-header-untangling.patch
uml-header-untangling-fix.patch
uml-style-cleanup.patch
uml-currenth-cleanup.patch
uml-fix-page-table-data-sizes.patch
uml-add-virt_to_pte.patch
uml-simplify-sigsegv-handling.patch
uml-use-ptrace-directly-in-libc-code.patch
uml-kill-processes-instead-of-panicing-kernel.patch
uml-clean-up-task_size-usage.patch
uml-cover-stubs-with-a-vma.patch
uml-fix-command-line-cflags-and-ldflags-support.patch
uml-style-fixes-in-arch-um-os-linux.patch
uml-miscellaneous-code-cleanups.patch
uml-style-fixes-in-filec.patch
uml-64-bit-tlb-fixes.patch
uml-customize-tlbh.patch
uml-eliminate-setjmp_wrapper.patch
uml-install-panic-notifier-earlier.patch
uml-use-barrier-instead-of-mb.patch
uml-tidy-helper-code.patch
uml-dont-kill-pid-0.patch
uml-get-rid-of-syscall-counters.patch
uml-dont-allow-processes-to-call-into-stub.patch
uml-move-sig_handler_common_skas.patch
uml-clean-up-sig_handler_common_skas.patch
uml-style-fixes-in-arch-um-kernel.patch
uml-signal-handling-tidying.patch
uml-remove-init_irq_signals.patch
uml-smp-locking-commentary.patch
uml-implement-o_append.patch
uml-remove-fakehd.patch
uml-debug_shirq-fixes.patch
uml-add-back-config_hz.patch
uml-style-fixes-in-arch-um-sys-x86_64.patch
uml-add-newlines-to-printks.patch
uml-move-register-initialization.patch
uml-remove-unused-fields-from-mm_context.patch
uml-remove-map_cb.patch
uml-use-of-a-public-mac-is-a-warning-not-an-error.patch
uml-defconfig-tweaks.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
create-arch-kconfig.patch
add-have_oprofile.patch
add-have_kprobes.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
random-add-async-notification-support-to-dev-random.patch
