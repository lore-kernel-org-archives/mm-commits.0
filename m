From: akpm@linux-foundation.org
Subject: + h8300-signal-fix-typo-statis.patch added to -mm tree
Date: Tue, 26 Jun 2012 16:50:26 -0700
Message-ID: <20120626235026.AFB42A0341@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:50011 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241Ab2FZXu1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jun 2012 19:50:27 -0400
Received: by ggeh3 with SMTP id h3so54174gge.1
        for <mm-commits@vger.kernel.org>; Tue, 26 Jun 2012 16:50:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, tony@bakeyournoodle.com, viro@zeniv.linux.org.uk, ysato@users.sourceforge.jp


The patch titled
     Subject: h8300/signal: fix typo "statis"
has been added to the -mm tree.  Its filename is
     h8300-signal-fix-typo-statis.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -446,7 +446,7 @@ handle_signal(unsigned long sig, siginfo
  * want to handle. Thus you cannot kill init even with a SIGKILL even by
  * mistake.
  */
-statis void do_signal(struct pt_regs *regs)
+static void do_signal(struct pt_regs *regs)
 {
 	siginfo_t info;
 	int signr;
_
Subject: Subject: h8300/signal: fix typo "statis"

Patches currently in -mm which might be from geert@linux-m68k.org are

linux-next.patch
mn10300-move-setup_jiffies_interrupt-to-cevt-mn10300c.patch
mn10300-remove-duplicate-definition-of-ptrace_o_tracesysgood.patch
mn10300-kernel-internalh-needs-linux-irqreturnh.patch
mn10300-kernel-trapsc-needs-linux-exporth.patch
mn10300-mm-dma-allocc-needs-linux-exporth.patch
mn10300-use-elif-definedconfig_-instead-of-elif-config_.patch
h8300-pgtable-add-missing-include-asm-generic-pgtableh.patch
h8300-signal-fix-typo-statis.patch
h8300-time-add-missing-include-asm-irq_regsh.patch
h8300-uaccess-remove-assignment-to-__gu_val-in-unhandled-case-of-get_user.patch
h8300-uaccess-add-mising-__clear_user.patch

