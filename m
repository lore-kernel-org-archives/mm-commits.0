From: akpm@linux-foundation.org
Subject: + pid-fix-mips-irix-emulation-pid-usage-fix.patch added to -mm tree
Date: Thu, 13 Dec 2007 13:51:23 -0800
Message-ID: <200712132151.lBDLpN3B019874@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49369 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933679AbXLMVw1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Dec 2007 16:52:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.kozlowski@tuxland.pl, ebiederm@xmission.com, oleg@tv-sign.ru, ralf@linux-mips.org, xemul@openvz.org


The patch titled
     mips: fix unbalanced parenthesis in irix_BSDsetpgrp()
has been added to the -mm tree.  Its filename is
     pid-fix-mips-irix-emulation-pid-usage-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

timerfd-v3-new-timerfd-api-sparc64-fix.patch
md-balance-braces-in-raid5-debug-code.patch
git-mmc.patch
config_highpte-vs-sub-page-page-tables-fix-2.patch
pid-fix-mips-irix-emulation-pid-usage-fix.patch
reiser4.patch
