From: akpm@linux-foundation.org
Subject: - arm-use-kbuildh-instead-of-macros-in-asm-offsetsc.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:50:01 -0700
Message-ID: <200804300550.m3U5o1Xe030050@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60866 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758955AbYD3Fua (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:50:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     arm: use kbuild.h instead of macros in asm-offsets.c
has been removed from the -mm tree.  Its filename was
     arm-use-kbuildh-instead-of-macros-in-asm-offsetsc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arm: use kbuild.h instead of macros in asm-offsets.c
From: Christoph Lameter <clameter@sgi.com>

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/asm-offsets.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN arch/arm/kernel/asm-offsets.c~arm-use-kbuildh-instead-of-macros-in-asm-offsetsc arch/arm/kernel/asm-offsets.c
--- a/arch/arm/kernel/asm-offsets.c~arm-use-kbuildh-instead-of-macros-in-asm-offsetsc
+++ a/arch/arm/kernel/asm-offsets.c
@@ -16,6 +16,7 @@
 #include <asm/thread_info.h>
 #include <asm/memory.h>
 #include <asm/procinfo.h>
+#include <linux/kbuild.h>
 
 /*
  * Make sure that the compiler and target are compatible.
@@ -35,13 +36,6 @@
 #error    Known good compilers: 3.3
 #endif
 
-/* Use marker if you need to separate the values later */
-
-#define DEFINE(sym, val) \
-        asm volatile("\n->" #sym " %0 " #val : : "i" (val))
-
-#define BLANK() asm volatile("\n->" : : )
