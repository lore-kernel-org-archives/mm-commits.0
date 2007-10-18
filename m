From: akpm@linux-foundation.org
Subject: - alpha-lock-bitops-fix.patch removed from -mm tree
Date: Thu, 18 Oct 2007 01:52:06 -0700
Message-ID: <200710180852.l9I8q60h002944@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37508 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755610AbXJRIwd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 04:52:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, ink@jurassic.park.msu.ru, npiggin@suse.de, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha bitops.h must #include <asm/barrier.h>
has been removed from the -mm tree.  Its filename was
     alpha-lock-bitops-fix.patch

This patch was dropped because it was folded into alpha-lock-bitops.patch

------------------------------------------------------
Subject: alpha bitops.h must #include <asm/barrier.h>
From: Adrian Bunk <bunk@kernel.org>

In file included from /home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/include/linux/bitops.h:17,
                 from /home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/include/linux/kernel.h:15,
                 from /home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/include/linux/sched.h:50,
                 from /home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/arch/alpha/kernel/asm-offsets.c:9:
include2/asm/bitops.h: In function 'clear_bit_unlock':
include2/asm/bitops.h:75: error: implicit declaration of function 'smp_mb'
make[2]: *** [arch/alpha/kernel/asm-offsets.s] Error 1

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-alpha/bitops.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/asm-alpha/bitops.h~alpha-lock-bitops-fix include/asm-alpha/bitops.h
--- a/include/asm-alpha/bitops.h~alpha-lock-bitops-fix
+++ a/include/asm-alpha/bitops.h
@@ -6,6 +6,7 @@
 #endif
 
 #include <asm/compiler.h>
+#include <asm/barrier.h>
 
 /*
  * Copyright 1994, Linus Torvalds.
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
make-kernel-power-maincsuspend_enter-static.patch
sysctl-parport-remove-binary-paths.patch
sysctl-error-on-bad-sysctl-tables.patch
alpha-lock-bitops.patch
alpha-lock-bitops-fix.patch
