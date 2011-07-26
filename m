From: akpm@linux-foundation.org
Subject: [merged] um-ajdust-size-of-pid_buf.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:54:53 -0700
Message-ID: <201107260753.p6Q7ruZ5003290@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35638 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752491Ab1GZHyx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:54:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@nod.at, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     um: adjust size of pid_buf
has been removed from the -mm tree.  Its filename was
     um-ajdust-size-of-pid_buf.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
fs-execc-use-build_bug_on-for-vm_stack_flags-vm_stack_incomplete_setup.patch
exec-do-not-call-request_module-twice-from-search_binary_handler.patch
exec-do-not-retry-load_binary-method-if-config_modules=n.patch
gcov-disable-constructors-for-uml.patch

