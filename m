From: akpm@linux-foundation.org
Subject: + kernel-exitc-export-abort-to-modules-fix.patch added to -mm
 tree
Date: Tue, 02 Jan 2018 15:33:25 -0800
Message-ID: <5a4c16c5.p38TXUQrNJA3uaIA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59142 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750989AbeABXd1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jan 2018 18:33:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, Jose.Abreu@synopsys.com, rmk+kernel@armlinux.org.uk, vgupta@synopsys.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arch: drop duplicate exports of abort()
has been added to the -mm tree.  Its filename is
     kernel-exitc-export-abort-to-modules-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-exitc-export-abort-to-modules-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-exitc-export-abort-to-modules-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: arch: drop duplicate exports of abort()

We now have exports in both architecture code in in common code, which
causes a link failure when symbol versioning is eanbled, on four
architectures:

kernel/exit.o: In function `__crc_abort':
exit.c:(*ABS*+0xc0e2ec8b): multiple definition of `__crc_abort'

This removes the four architecture specific exports and only leaves the
export next to the __weak symbol.

Link: http://lkml.kernel.org/r/20180102103311.706364-1-arnd@arndb.de
Fixes: mmotm ("kernel/exit.c: export abort() to modules")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Russell King <rmk+kernel@armlinux.org.uk>	[arm]
Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Jose Abreu <Jose.Abreu@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/traps.c       |    1 -
 arch/m32r/kernel/traps.c      |    1 -
 arch/unicore32/kernel/traps.c |    1 -
 3 files changed, 3 deletions(-)

diff -puN arch/arm/kernel/traps.c~kernel-exitc-export-abort-to-modules-fix arch/arm/kernel/traps.c
--- a/arch/arm/kernel/traps.c~kernel-exitc-export-abort-to-modules-fix
+++ a/arch/arm/kernel/traps.c
@@ -793,7 +793,6 @@ void abort(void)
 	/* if that doesn't kill us, halt */
 	panic("Oops failed to kill thread");
 }
-EXPORT_SYMBOL(abort);
 
 void __init trap_init(void)
 {
diff -puN arch/m32r/kernel/traps.c~kernel-exitc-export-abort-to-modules-fix arch/m32r/kernel/traps.c
--- a/arch/m32r/kernel/traps.c~kernel-exitc-export-abort-to-modules-fix
+++ a/arch/m32r/kernel/traps.c
@@ -122,7 +122,6 @@ void abort(void)
 	/* if that doesn't kill us, halt */
 	panic("Oops failed to kill thread");
 }
-EXPORT_SYMBOL(abort);
 
 void __init trap_init(void)
 {
diff -puN arch/unicore32/kernel/traps.c~kernel-exitc-export-abort-to-modules-fix arch/unicore32/kernel/traps.c
--- a/arch/unicore32/kernel/traps.c~kernel-exitc-export-abort-to-modules-fix
+++ a/arch/unicore32/kernel/traps.c
@@ -298,7 +298,6 @@ void abort(void)
 	/* if that doesn't kill us, halt */
 	panic("Oops failed to kill thread");
 }
-EXPORT_SYMBOL(abort);
 
 void __init trap_init(void)
 {
_

Patches currently in -mm which might be from arnd@arndb.de are

kernel-exitc-export-abort-to-modules-fix.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix-2.patch
bugh-work-around-gcc-pr82365-in-bug.patch
kasan-rework-kconfig-settings.patch

