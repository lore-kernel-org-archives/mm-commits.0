From: akpm@linux-foundation.org
Subject: + voyager-use-struct-instead-of-param.patch added to -mm tree
Date: Mon, 29 Oct 2007 13:51:30 -0700
Message-ID: <200710292051.l9TKpUJn022654@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43957 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751730AbXJ2UwY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Oct 2007 16:52:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, James.Bottomley@steeleye.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     voyager: use struct instead of PARAM
has been added to the -mm tree.  Its filename is
     voyager-use-struct-instead-of-param.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: voyager: use struct instead of PARAM
From: Randy Dunlap <randy.dunlap@oracle.com>

Use struct boot_params instead of PARAM + 0xoffsets.
Fixes one of many Voyager build problems.

arch/x86/kernel/setup_32.c:543: error: 'PARAM' undeclared (first use in this function)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86/mach-voyager/setup_arch.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN include/asm-x86/mach-voyager/setup_arch.h~voyager-use-struct-instead-of-param include/asm-x86/mach-voyager/setup_arch.h
--- a/include/asm-x86/mach-voyager/setup_arch.h~voyager-use-struct-instead-of-param
+++ a/include/asm-x86/mach-voyager/setup_arch.h
@@ -1,5 +1,7 @@
 #include <asm/voyager.h>
-#define VOYAGER_BIOS_INFO ((struct voyager_bios_info *)(PARAM+0x40))
+#include <asm/setup_32.h>
+#define VOYAGER_BIOS_INFO ((struct voyager_bios_info *) \
+			(&boot_params.apm_bios_info))
 
 /* Hook to call BIOS initialisation function */
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
fb-menu-fix-fb_omap-dependencies-so-that-menu-is-displayed.patch
git-kbuild.patch
git-unionfs.patch
git-watchdog.patch
git-ipwireless_cs.patch
x86-bitops_32h-style-cleanups.patch
voyager-use-struct-instead-of-param.patch
move-kprobes-examples-to-samples-resend.patch
move-kprobes-examples-to-samples-resend-checkpatch-fixes.patch
fs-menu-small-reorg.patch
profile-likely-unlikely-macros.patch
