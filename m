From: akpm@linux-foundation.org
Subject: - uml-remove-xmm-checking-on-x86.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:35:18 -0800
Message-ID: <200802052234.m15MYxoj012569@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41594 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762326AbYBEWlQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: magotari@gmail.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: remove xmm checking on x86
has been removed from the -mm tree.  Its filename was
     uml-remove-xmm-checking-on-x86.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: remove xmm checking on x86
From: Karol Swietlicki <magotari@gmail.com>

This patch removes some code which ran at every boot, but does not seem to do
anything anymore.  Please test.  It works for me but mistakes can happen.

Signed-off-by: Karol Swietlicki <magotari@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/sys-i386/bugs.c         |    3 ---
 include/asm-um/processor-i386.h |    1 -
 2 files changed, 4 deletions(-)

diff -puN arch/um/sys-i386/bugs.c~uml-remove-xmm-checking-on-x86 arch/um/sys-i386/bugs.c
--- a/arch/um/sys-i386/bugs.c~uml-remove-xmm-checking-on-x86
+++ a/arch/um/sys-i386/bugs.c
@@ -15,7 +15,6 @@
 
 /* Set during early boot */
 int host_has_cmov = 1;
-int host_has_xmm = 0;
 
 static char token(int fd, char *buf, int len, char stop)
 {
@@ -163,8 +162,6 @@ void arch_check_bugs(void)
 	}
 	if (check_cpu_flag("cmov", &have_it))
 		host_has_cmov = have_it;
-	if (check_cpu_flag("xmm", &have_it))
-		host_has_xmm = have_it;
 }
 
 int arch_handle_signal(int sig, struct uml_pt_regs *regs)
diff -puN include/asm-um/processor-i386.h~uml-remove-xmm-checking-on-x86 include/asm-um/processor-i386.h
--- a/include/asm-um/processor-i386.h~uml-remove-xmm-checking-on-x86
+++ a/include/asm-um/processor-i386.h
@@ -10,7 +10,6 @@
 #include "asm/host_ldt.h"
 #include "asm/segment.h"
 
-extern int host_has_xmm;
 extern int host_has_cmov;
 
 /* include faultinfo structure */
_

Patches currently in -mm which might be from magotari@gmail.com are

origin.patch
