From: akpm@linux-foundation.org
Subject: [patch 4/9] kernel/exit.c: export abort() to modules
Date: Thu, 04 Jan 2018 16:17:56 -0800
Message-ID: <5a4ec434.ukRhyh/mqYst4zvD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35392 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751108AbeAEAR5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 4 Jan 2018 19:17:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, Alexey.Brodkin@synopsys.com, arnd@arndb.de, Jose.Abreu@synopsys.com, rmk+kernel@armlinux.org.uk, sudipm.mukherjee@gmail.com, Vineet.Gupta1@synopsys.com

From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel/exit.c: export abort() to modules

gcc -fisolate-erroneous-paths-dereference can generate calls to abort()
from modular code too.

[arnd@arndb.de: drop duplicate exports of abort()]
  Link: http://lkml.kernel.org/r/20180102103311.706364-1-arnd@arndb.de
Reported-by: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Cc: Russell King <rmk+kernel@armlinux.org.uk>
Cc: Jose Abreu <Jose.Abreu@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---

 arch/arm/kernel/traps.c       |    1 -
 arch/m32r/kernel/traps.c      |    1 -
 arch/unicore32/kernel/traps.c |    1 -
 kernel/exit.c                 |    1 +
 4 files changed, 1 insertion(+), 3 deletions(-)

diff -puN arch/arm/kernel/traps.c~kernel-exitc-export-abort-to-modules arch/arm/kernel/traps.c
--- a/arch/arm/kernel/traps.c~kernel-exitc-export-abort-to-modules
+++ a/arch/arm/kernel/traps.c
@@ -793,7 +793,6 @@ void abort(void)
 	/* if that doesn't kill us, halt */
 	panic("Oops failed to kill thread");
 }
-EXPORT_SYMBOL(abort);
 
 void __init trap_init(void)
 {
diff -puN arch/m32r/kernel/traps.c~kernel-exitc-export-abort-to-modules arch/m32r/kernel/traps.c
--- a/arch/m32r/kernel/traps.c~kernel-exitc-export-abort-to-modules
+++ a/arch/m32r/kernel/traps.c
@@ -122,7 +122,6 @@ void abort(void)
 	/* if that doesn't kill us, halt */
 	panic("Oops failed to kill thread");
 }
-EXPORT_SYMBOL(abort);
 
 void __init trap_init(void)
 {
diff -puN arch/unicore32/kernel/traps.c~kernel-exitc-export-abort-to-modules arch/unicore32/kernel/traps.c
--- a/arch/unicore32/kernel/traps.c~kernel-exitc-export-abort-to-modules
+++ a/arch/unicore32/kernel/traps.c
@@ -298,7 +298,6 @@ void abort(void)
 	/* if that doesn't kill us, halt */
 	panic("Oops failed to kill thread");
 }
-EXPORT_SYMBOL(abort);
 
 void __init trap_init(void)
 {
diff -puN kernel/exit.c~kernel-exitc-export-abort-to-modules kernel/exit.c
--- a/kernel/exit.c~kernel-exitc-export-abort-to-modules
+++ a/kernel/exit.c
@@ -1763,3 +1763,4 @@ __weak void abort(void)
 	/* if that doesn't kill us, halt */
 	panic("Oops failed to kill thread");
 }
+EXPORT_SYMBOL(abort);
_
