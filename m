From: akpm@linux-foundation.org
Subject: - dont-force-frame-pointers-for-lockdep-on-mips.patch removed from -mm tree
Date: Sat, 28 Apr 2007 03:52:19 -0700
Message-ID: <200704281052.l3SAqJLk020036@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38626 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031155AbXD1Kwe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 06:52:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fbuihuu@gmail.com, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     Don't force frame pointers for lockdep on MIPS
has been removed from the -mm tree.  Its filename was
     dont-force-frame-pointers-for-lockdep-on-mips.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Don't force frame pointers for lockdep on MIPS
From: Franck Bui-Huu <fbuihuu@gmail.com>

Stacktrace support on MIPS doesn't use frame pointers.  Since this option
considerably increases the size of the kernel code, force lockdep to not
use it.

Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/Kconfig.debug~dont-force-frame-pointers-for-lockdep-on-mips lib/Kconfig.debug
--- a/lib/Kconfig.debug~dont-force-frame-pointers-for-lockdep-on-mips
+++ a/lib/Kconfig.debug
@@ -261,7 +261,7 @@ config LOCKDEP
 	bool
 	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
 	select STACKTRACE
-	select FRAME_POINTER if !X86
+	select FRAME_POINTER if !X86 && !MIPS
 	select KALLSYMS
 	select KALLSYMS_ALL
 
_

Patches currently in -mm which might be from fbuihuu@gmail.com are

origin.patch
