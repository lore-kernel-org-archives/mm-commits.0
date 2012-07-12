From: akpm@linux-foundation.org
Subject: [merged] h8300-signal-fix-typo-statis.patch removed from -mm tree
Date: Thu, 12 Jul 2012 12:36:53 -0700
Message-ID: <20120712193653.A5EF31E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:60493 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932899Ab2GLTgy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 15:36:54 -0400
Received: by mail-vc0-f202.google.com with SMTP id p1so16661vcq.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 12:36:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, tony@bakeyournoodle.com, viro@zeniv.linux.org.uk, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: h8300/signal: fix typo "statis"
has been removed from the -mm tree.  Its filename was
     h8300-signal-fix-typo-statis.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: h8300/signal: fix typo "statis"

The keyword is "static", not "statis":

arch/h8300/kernel/signal.c:455:8: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'void'
arch/h8300/kernel/signal.c: In function 'do_notify_resume':
arch/h8300/kernel/signal.c:511:3: error: implicit declaration of function 'do_signal' [-Werror=implicit-function-declaration]
arch/h8300/kernel/signal.c: At top level:
arch/h8300/kernel/signal.c:414:1: warning: 'handle_signal' defined but not used [-Wunused-function]

Introduced in commit 7ae4e32a65148353db3458e3eb87117f25620ac5 ("h8300: switch
to saved_sigmask-based sigsuspend/rt_sigsuspend")

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Tony Breeds <tony@bakeyournoodle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/kernel/signal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/h8300/kernel/signal.c~h8300-signal-fix-typo-statis arch/h8300/kernel/signal.c
--- a/arch/h8300/kernel/signal.c~h8300-signal-fix-typo-statis
+++ a/arch/h8300/kernel/signal.c
@@ -447,7 +447,7 @@ handle_signal(unsigned long sig, siginfo
  * want to handle. Thus you cannot kill init even with a SIGKILL even by
  * mistake.
  */
-statis void do_signal(struct pt_regs *regs)
+static void do_signal(struct pt_regs *regs)
 {
 	siginfo_t info;
 	int signr;
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
linux-next.patch
frv-kill-used-but-uninitialized-variable.patch

