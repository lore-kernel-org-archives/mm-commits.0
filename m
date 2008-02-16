From: akpm@linux-foundation.org
Subject: + h8300-signalc-typo-fix.patch added to -mm tree
Date: Fri, 15 Feb 2008 22:44:10 -0800
Message-ID: <200802160644.m1G6iAk5012833@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35166 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752039AbYBPGo0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 16 Feb 2008 01:44:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ysato@users.sourceforge.jp


The patch titled
     h8300: signal.c typo fix
has been added to the -mm tree.  Its filename is
     h8300-signalc-typo-fix.patch

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
Subject: h8300: signal.c typo fix
From: Yoshinori Sato <ysato@users.sourceforge.jp>

typo fix.

Signed-off-by: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/kernel/signal.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/h8300/kernel/signal.c~h8300-signalc-typo-fix arch/h8300/kernel/signal.c
--- a/arch/h8300/kernel/signal.c~h8300-signalc-typo-fix
+++ a/arch/h8300/kernel/signal.c
@@ -352,7 +352,7 @@ static void setup_frame (int sig, struct
 		ret = (unsigned char *)(ka->sa.sa_restorer);
 	else {
 		/* sub.l er0,er0; mov.b #__NR_sigreturn,r0l; trapa #0 */
-		err != __put_user(0x1a80f800 + (__NR_sigreturn & 0xff),
+		err |= __put_user(0x1a80f800 + (__NR_sigreturn & 0xff),
 				  (unsigned long *)(frame->retcode + 0));
 		err |= __put_user(0x5700, (unsigned short *)(frame->retcode + 4));
 	}
@@ -428,7 +428,7 @@ static void setup_rt_frame (int sig, str
 		ret = (unsigned char *)(ka->sa.sa_restorer);
 	else {
 		/* sub.l er0,er0; mov.b #__NR_sigreturn,r0l; trapa #0 */
-		err != __put_user(0x1a80f800 + (__NR_sigreturn & 0xff),
+		err |= __put_user(0x1a80f800 + (__NR_sigreturn & 0xff),
 				  (unsigned long *)(frame->retcode + 0));
 		err |= __put_user(0x5700, (unsigned short *)(frame->retcode + 4));
 	}
_

Patches currently in -mm which might be from ysato@users.sourceforge.jp are

h8300-signalc-typo-fix.patch
h8300-uaccessh-update.patch
h8300-config_kallsyms-fix.patch
h8300-irq-handling-update.patch
h8300-defconfig-update.patch
inflate-refactor-inflate-malloc-code.patch
elf-use-elf_core_eflags-for-kcore-elf-header-flags.patch
