From: akpm@linux-foundation.org
Subject: + mn10300-fix-pull-clearing-restore_sigmask-into-block_sigmask-fallout.patch added to -mm tree
Date: Fri, 13 Jul 2012 14:18:56 -0700
Message-ID: <20120713211857.233B620004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:36571 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754877Ab2GMVS7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jul 2012 17:18:59 -0400
Received: by eaao13 with SMTP id o13so204471eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jul 2012 14:18:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, dhowells@redhat.com, viro@zeniv.linux.org.uk, yasutake.koichi@jp.panasonic.com


The patch titled
     Subject: mn10300: Fix "pull clearing RESTORE_SIGMASK into block_sigmask()" fallout
has been added to the -mm tree.  Its filename is
     mn10300-fix-pull-clearing-restore_sigmask-into-block_sigmask-fallout.patch

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
Subject: mn10300: Fix "pull clearing RESTORE_SIGMASK into block_sigmask()" fallout

a610d6e672d6d3723e ("pull clearing RESTORE_SIGMASK into block_sigmask()")
caused:

arch/mn10300/kernel/signal.c: In function 'handle_signal':
arch/mn10300/kernel/signal.c:462:3: warning: 'return' with no value, in function returning non-void [-Wreturn-type]

Add the missing return values, and restore the indentation while we're at
it.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/kernel/signal.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN arch/mn10300/kernel/signal.c~mn10300-fix-pull-clearing-restore_sigmask-into-block_sigmask-fallout arch/mn10300/kernel/signal.c
--- a/arch/mn10300/kernel/signal.c~mn10300-fix-pull-clearing-restore_sigmask-into-block_sigmask-fallout
+++ a/arch/mn10300/kernel/signal.c
@@ -455,10 +455,11 @@ static int handle_signal(int sig,
 	else
 		ret = setup_frame(sig, ka, oldset, regs);
 	if (ret)
-		return;
+		return ret;
 
 	signal_delivered(sig, info, ka, regs,
-				 test_thread_flag(TIF_SINGLESTEP));
+			 test_thread_flag(TIF_SINGLESTEP));
+	return 0;
 }
 
 /*
_
Subject: Subject: mn10300: Fix "pull clearing RESTORE_SIGMASK into block_sigmask()" fallout

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
linux-next.patch
mn10300-fix-pull-clearing-restore_sigmask-into-block_sigmask-fallout.patch
mn10300-only-add-mmem-funcs-to-kbuild_cflags-if-gcc-supports-it.patch
frv-kill-used-but-uninitialized-variable.patch

