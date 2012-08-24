From: akpm@linux-foundation.org
Subject: [merged] arch-x86-include-asm-spinlockh-fix-comment.patch removed from -mm tree
Date: Fri, 24 Aug 2012 11:42:02 -0700
Message-ID: <20120824184203.01FB420004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:55093 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752370Ab2HXSmF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2012 14:42:05 -0400
Received: by lagw12 with SMTP id w12so106887lag.1
        for <mm-commits@vger.kernel.org>; Fri, 24 Aug 2012 11:42:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@nod.at, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/x86/include/asm/spinlock.h: fix comment
has been removed from the -mm tree.  Its filename was
     arch-x86-include-asm-spinlockh-fix-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Richard Weinberger <richard@nod.at>
Subject: arch/x86/include/asm/spinlock.h: fix comment

This comment is no longer true.  We support up to 2^16 CPUs because
__ticket_t is an u16 if NR_CPUS is larger than 256.

Signed-off-by: Richard Weinberger <richard@nod.at>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/spinlock.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/x86/include/asm/spinlock.h~arch-x86-include-asm-spinlockh-fix-comment arch/x86/include/asm/spinlock.h
--- a/arch/x86/include/asm/spinlock.h~arch-x86-include-asm-spinlockh-fix-comment
+++ a/arch/x86/include/asm/spinlock.h
@@ -12,8 +12,7 @@
  * Simple spin lock operations.  There are two variants, one clears IRQ's
  * on the local processor, one does not.
  *
- * These are fair FIFO ticket locks, which are currently limited to 256
- * CPUs.
+ * These are fair FIFO ticket locks, which support up to 2^16 CPUs.
  *
  * (the type definitions are in asm/spinlock_types.h)
  */
_

Patches currently in -mm which might be from richard@nod.at are

origin.patch
linux-next.patch

