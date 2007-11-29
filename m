From: akpm@linux-foundation.org
Subject: + uml-work-around-host-tcsetattr-bug.patch added to -mm tree
Date: Thu, 29 Nov 2007 14:51:18 -0800
Message-ID: <200711292251.lATMpIoa011326@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54161 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756974AbXK2WvW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 17:51:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: work around host tcsetattr bug
has been added to the -mm tree.  Its filename is
     uml-work-around-host-tcsetattr-bug.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: work around host tcsetattr bug
From: Jeff Dike <jdike@addtoit.com>

Under the conditions that UML uses it, tcgetattr is guaranteed to return
-EINTR when the console is attached to /dev/ptmx, making generic_console_write
hang because it loops, calling tcgetattr until it succeeds.  This is a host
bug - see http://marc.info/?l=linux-kernel&m=119618990807182&w=2 for the
details.

This patch works around it by blocking SIGIO while the terminal attributes are
being fiddled.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/chan_user.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN arch/um/drivers/chan_user.c~uml-work-around-host-tcsetattr-bug arch/um/drivers/chan_user.c
--- a/arch/um/drivers/chan_user.c~uml-work-around-host-tcsetattr-bug
+++ a/arch/um/drivers/chan_user.c
@@ -74,10 +74,16 @@ void generic_free(void *data)
 
 int generic_console_write(int fd, const char *buf, int n)
 {
+	sigset_t old, no_sigio;
 	struct termios save, new;
 	int err;
 
 	if (isatty(fd)) {
+		sigemptyset(&no_sigio);
+		sigaddset(&no_sigio, SIGIO);
+		if (sigprocmask(SIG_BLOCK, &no_sigio, &old))
+			goto error;
+
 		CATCH_EINTR(err = tcgetattr(fd, &save));
 		if (err)
 			goto error;
@@ -97,8 +103,11 @@ int generic_console_write(int fd, const 
 	 * Restore raw mode, in any case; we *must* ignore any error apart
 	 * EINTR, except for debug.
 	 */
-	if (isatty(fd))
+	if (isatty(fd)) {
 		CATCH_EINTR(tcsetattr(fd, TCSAFLUSH, &save));
+		sigprocmask(SIG_SETMASK, &old, NULL);
+	}
+
 	return err;
 error:
 	return -errno;
_

Patches currently in -mm which might be from jdike@addtoit.com are

uml-fix-no_hz-busy-loop.patch
leak-in-do_ubd_request.patch
uml-keep-uml-kconfig-in-sync-with-x86.patch
uml-after_sleep_interval-should-return-something.patch
uml-work-around-host-tcsetattr-bug.patch
git-kvm.patch
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
uml-style-cleanup.patch
uml-currenth-cleanup.patch
uml-fix-page-table-data-sizes.patch
uml-add-virt_to_pte.patch
uml-simplify-sigsegv-handling.patch
uml-use-ptrace-directly-in-libc-code.patch
uml-kill-processes-instead-of-panicing-kernel.patch
uml-clean-up-task_size-usage.patch
uml-cover-stubs-with-a-vma.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
