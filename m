From: akpm@linux-foundation.org
Subject: - pid-fix-mips-irix-emulation-pid-usage-fix.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:40:12 -0800
Message-ID: <200802080839.m188ds3U016008@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54853 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755470AbYBHIko (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:40:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, ebiederm@xmission.com, oleg@tv-sign.ru, ralf@linux-mips.org, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     mips: fix unbalanced parenthesis in irix_BSDsetpgrp()
has been removed from the -mm tree.  Its filename was
     pid-fix-mips-irix-emulation-pid-usage-fix.patch

This patch was dropped because it was folded into pid-fix-mips-irix-emulation-pid-usage.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mips: fix unbalanced parenthesis in irix_BSDsetpgrp()
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/sysirix.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/mips/kernel/sysirix.c~pid-fix-mips-irix-emulation-pid-usage-fix arch/mips/kernel/sysirix.c
--- a/arch/mips/kernel/sysirix.c~pid-fix-mips-irix-emulation-pid-usage-fix
+++ a/arch/mips/kernel/sysirix.c
@@ -1096,7 +1096,7 @@ asmlinkage int irix_BSDsetpgrp(int pid, 
 		pid = task_pid_vnr(current);
 
 	/* Wheee, weird sysv thing... */
-	if ((pgrp == 0) && (pid == task_pid_vnr(current))
+	if ((pgrp == 0) && (pid == task_pid_vnr(current)))
 		error = sys_setsid();
 	else
 		error = sys_setpgid(pid, pgrp);
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

origin.patch
pid-fix-mips-irix-emulation-pid-usage.patch
pid-fix-mips-irix-emulation-pid-usage-fix.patch
