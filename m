From: akpm@linux-foundation.org
Subject: [merged] mn10300-fix-pull-clearing-restore_sigmask-into-block_sigmask-fallout.patch removed from -mm tree
Date: Mon, 23 Jul 2012 14:30:43 -0700
Message-ID: <20120723213044.185515C0063@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:45229 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864Ab2GWVa4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jul 2012 17:30:56 -0400
Received: by lbbgp10 with SMTP id gp10so354478lbb.1
        for <mm-commits@vger.kernel.org>; Mon, 23 Jul 2012 14:30:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, dhowells@redhat.com, viro@zeniv.linux.org.uk, yasutake.koichi@jp.panasonic.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mn10300: fix "pull clearing RESTORE_SIGMASK into block_sigmask()" fallout
has been removed from the -mm tree.  Its filename was
     mn10300-fix-pull-clearing-restore_sigmask-into-block_sigmask-fallout.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: mn10300: fix "pull clearing RESTORE_SIGMASK into block_sigmask()" fallout

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
@@ -459,10 +459,11 @@ static int handle_signal(int sig,
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

Patches currently in -mm which might be from geert@linux-m68k.org are

linux-next.patch
mn10300-only-add-mmem-funcs-to-kbuild_cflags-if-gcc-supports-it.patch
frv-kill-used-but-uninitialized-variable.patch

