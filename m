From: akpm@linux-foundation.org
Subject: + um-ajdust-size-of-pid_buf.patch added to -mm tree
Date: Fri, 22 Jul 2011 15:55:23 -0700
Message-ID: <201107222255.p6MMtNYA020052@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39689 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752421Ab1GVWzf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Jul 2011 18:55:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@nod.at, geert@linux-m68k.org


The patch titled
     um: adjust size of pid_buf
has been added to the -mm tree.  Its filename is
     um-ajdust-size-of-pid_buf.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: um: adjust size of pid_buf
From: Richard Weinberger <richard@nod.at>

Linux can have pids up to 4*1024*1024.  To handle such huge numbers
pid_buf needs to be larger.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/harddog_user.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/um/drivers/harddog_user.c~um-ajdust-size-of-pid_buf arch/um/drivers/harddog_user.c
--- a/arch/um/drivers/harddog_user.c~um-ajdust-size-of-pid_buf
+++ a/arch/um/drivers/harddog_user.c
@@ -32,7 +32,7 @@ int start_watchdog(int *in_fd_ret, int *
 {
 	struct dog_data data;
 	int in_fds[2], out_fds[2], pid, n, err;
-	char pid_buf[sizeof("nnnnn\0")], c;
+	char pid_buf[sizeof("nnnnnnn\0")], c;
 	char *pid_args[] = { "/usr/bin/uml_watchdog", "-pid", pid_buf, NULL };
 	char *mconsole_args[] = { "/usr/bin/uml_watchdog", "-mconsole", NULL,
 				  NULL };
_

Patches currently in -mm which might be from richard@nod.at are

linux-next.patch
um-clean-up-vm-flagsh.patch
um-exec-remove-redundant-set_fsuser_ds.patch
um-clean-up-delay-functions-v2.patch
um-fix-_fortify_source=2-support-for-kernel-modules.patch
um-add-netpoll-support.patch
um-reinstate-kernel-version-in-generated-config.patch
uml-drivers-net_userc-memory-leak-fix.patch
uml-cow_userc-warning-corrections.patch
uml-helperc-warning-corrections.patch
uml-drivers-slip_userc-memory-leak-fix.patch
uml-free-resources.patch
um-disable-scan_elf_aux-on-x86_64.patch
um-set-__have_arch_gate_area-for-i386.patch
um-set-__have_arch_gate_area-for-x86_64.patch
um-implement-a-x86_64-vdso.patch
um-ajdust-size-of-pid_buf.patch
um-remove-dead-code.patch
fs-execc-use-build_bug_on-for-vm_stack_flags-vm_stack_incomplete_setup.patch
exec-do-not-call-request_module-twice-from-search_binary_handler.patch
exec-do-not-retry-load_binary-method-if-config_modules=n.patch
gcov-disable-constructors-for-uml.patch

