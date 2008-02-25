From: akpm@linux-foundation.org
Subject: - h8300-signalc-typo-fix.patch removed from -mm tree
Date: Sun, 24 Feb 2008 16:45:27 -0800
Message-ID: <200802250045.m1P0jR02006261@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:42046 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753899AbYBYAsk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 24 Feb 2008 19:48:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     h8300: signal.c typo fix
has been removed from the -mm tree.  Its filename was
     h8300-signalc-typo-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

elf-use-elf_core_eflags-for-kcore-elf-header-flags.patch
