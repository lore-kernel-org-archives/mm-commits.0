From: akpm@linux-foundation.org
Subject: + arch-x86-include-asm-spinlockh-fix-comment.patch added to -mm tree
Date: Fri, 06 Apr 2012 14:59:02 -0700
Message-ID: <20120406215902.5DF85A0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:34696 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281Ab2DFV7F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Apr 2012 17:59:05 -0400
Received: by wibhj13 with SMTP id hj13so46086wib.1
        for <mm-commits@vger.kernel.org>; Fri, 06 Apr 2012 14:59:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@nod.at, mingo@elte.hu


The patch titled
     Subject: arch/x86/include/asm/spinlock.h: fix comment
has been added to the -mm tree.  Its filename is
     arch-x86-include-asm-spinlockh-fix-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: arch/x86/include/asm/spinlock.h: fix comment

Patches currently in -mm which might be from richard@nod.at are

linux-next.patch
arch-x86-include-asm-spinlockh-fix-comment.patch
um-kernel-trapc-port-oom-changes-to-handle_page_fault.patch

