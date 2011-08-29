From: akpm@linux-foundation.org
Subject: + um-winch_interrupt-can-happen-inside-of-free_winch.patch added to -mm tree
Date: Mon, 29 Aug 2011 14:35:41 -0700
Message-ID: <201108292135.p7TLZfXO030265@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35633 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754412Ab1H2Vov (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Aug 2011 17:44:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: viro@ftp.linux.org.uk, richard@nod.at, viro@zeniv.linux.org.uk


The patch titled
     um: winch_interrupt() can happen inside of free_winch()
has been added to the -mm tree.  Its filename is
     um-winch_interrupt-can-happen-inside-of-free_winch.patch

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
Subject: um: winch_interrupt() can happen inside of free_winch()
From: Al Viro <viro@ftp.linux.org.uk>

...  so set winch->fd to -1 before doing free_irq(), to avoid having
winch_interrupt() come from/during the latter and attempt to do
reactivate_fd() on something that's already gone.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/line.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN arch/um/drivers/line.c~um-winch_interrupt-can-happen-inside-of-free_winch arch/um/drivers/line.c
--- a/arch/um/drivers/line.c~um-winch_interrupt-can-happen-inside-of-free_winch
+++ a/arch/um/drivers/line.c
@@ -725,6 +725,8 @@ struct winch {
 
 static void free_winch(struct winch *winch, int free_irq_ok)
 {
+	int fd = winch->fd;
+	winch->fd = -1;
 	if (free_irq_ok)
 		free_irq(WINCH_IRQ, winch);
 
@@ -732,8 +734,8 @@ static void free_winch(struct winch *win
 
 	if (winch->pid != -1)
 		os_kill_process(winch->pid, 1);
-	if (winch->fd != -1)
-		os_close_file(winch->fd);
+	if (fd != -1)
+		os_close_file(fd);
 	if (winch->stack != 0)
 		free_stack(winch->stack, 0);
 	kfree(winch);
_

Patches currently in -mm which might be from viro@ftp.linux.org.uk are

um-fix-oopsable-race-in-line_close.patch
um-winch_interrupt-can-happen-inside-of-free_winch.patch
um-fix-free_winch-mess.patch
um-ptrace_etfpxregs-had-been-wired-on-the-wrong-subarch.patch
um-fix-strrchr-problems.patch
um-clean-arch_ptrace-up-a-bit.patch
slab-leaks3-default-y.patch

