From: akpm@linux-foundation.org
Subject: [patch 16/18] arm: jump label may reference text in __exit
Date: Wed, 03 Aug 2016 13:46:33 -0700
Message-ID: <57a25829.GxvMoF4G2ykAuz8r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39766 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758303AbcHCUqj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 16:46:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, jbaron@akamai.com, a.p.zijlstra@chello.nl, arnd@arndb.de, benh@kernel.crashing.org, cmetcalf@mellanox.com, davem@davemloft.net, heiko.carstens@de.ibm.com, joe@perches.com, mpe@ellerman.id.au, paulus@samba.org, schwidefsky@de.ibm.com

From: Jason Baron <jbaron@akamai.com>
Subject: arm: jump label may reference text in __exit

The jump table can reference text found in an __exit section.  Thus,
instead of discarding it at build time, include EXIT_TEXT as part of
__init and it will be released when the system boots.

Link: http://lkml.kernel.org/r/60284113bb759121e8ae3e99af1535647e52123f.1467837322.git.jbaron@akamai.com
Signed-off-by: Jason Baron <jbaron@akamai.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Chris Metcalf <cmetcalf@mellanox.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Joe Perches <joe@perches.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/vmlinux.lds.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/kernel/vmlinux.lds.S~arm-jump-label-may-reference-text-in-__exit arch/arm/kernel/vmlinux.lds.S
--- a/arch/arm/kernel/vmlinux.lds.S~arm-jump-label-may-reference-text-in-__exit
+++ a/arch/arm/kernel/vmlinux.lds.S
@@ -44,7 +44,7 @@
 #endif
 
 #if (defined(CONFIG_SMP_ON_UP) && !defined(CONFIG_DEBUG_SPINLOCK)) || \
-	defined(CONFIG_GENERIC_BUG)
+	defined(CONFIG_GENERIC_BUG) || defined(CONFIG_JUMP_LABEL)
 #define ARM_EXIT_KEEP(x)	x
 #define ARM_EXIT_DISCARD(x)
 #else
_
