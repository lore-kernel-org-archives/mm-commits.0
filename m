From: akpm@linux-foundation.org
Subject: [merged] xtensa-fix-incorrect-memset.patch removed from -mm tree
Date: Thu, 12 Jul 2012 12:37:40 -0700
Message-ID: <20120712193740.AB13C100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:60493 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934236Ab2GLThl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 15:37:41 -0400
Received: by mail-vc0-f202.google.com with SMTP id p1so16661vcq.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 12:37:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@linux.intel.com, chris@zankel.net, dcb314@hotmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: xtensa: fix incorrect memset
has been removed from the -mm tree.  Its filename was
     xtensa-fix-incorrect-memset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alan Cox <alan@linux.intel.com>
Subject: xtensa: fix incorrect memset

Addresses: https://bugzilla.kernel.org/show_bug.cgi?id=43871
Reported-by: <dcb314@hotmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/kernel/process.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/xtensa/kernel/process.c~xtensa-fix-incorrect-memset arch/xtensa/kernel/process.c
--- a/arch/xtensa/kernel/process.c~xtensa-fix-incorrect-memset
+++ a/arch/xtensa/kernel/process.c
@@ -277,7 +277,7 @@ void xtensa_elf_core_copy_regs (xtensa_g
 
 	/* Don't leak any random bits. */
 
-	memset(elfregs, 0, sizeof (elfregs));
+	memset(elfregs, 0, sizeof(*elfregs));
 
 	/* Note:  PS.EXCM is not set while user task is running; its
 	 * being set in regs->ps is for exception handling convenience.
_

Patches currently in -mm which might be from alan@linux.intel.com are

origin.patch
linux-next.patch
fs-make-dumpable=2-require-fully-qualified-path.patch
coredump-warn-about-unsafe-suid_dumpable-core_pattern-combo.patch
kernel-sysc-avoid-argv_freenull.patch

