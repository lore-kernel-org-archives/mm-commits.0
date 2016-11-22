From: akpm@linux-foundation.org
Subject: + kernel-fork-use-vfree_atomic-to-free-thread-stack.patch added
 to -mm tree
Date: Mon, 21 Nov 2016 22:10:50 -0800
Message-ID: <5833e16a./1K09SXw0UrLwtSD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57668 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751487AbcKVGKv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2016 01:10:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, chris@chris-wilson.co.uk, hch@lst.de, hpa@zytor.com, joaodias@google.com, joelaf@google.com, jszhang@marvell.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/fork: use vfree_atomic() to free thread stack
has been added to the -mm tree.  Its filename is
     kernel-fork-use-vfree_atomic-to-free-thread-stack.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-fork-use-vfree_atomic-to-free-thread-stack.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-fork-use-vfree_atomic-to-free-thread-stack.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: kernel/fork: use vfree_atomic() to free thread stack

vfree() is going to use sleeping lock. Thread stack freed in atomic
context, therefore we must use vfree_atomic() here.

Link: http://lkml.kernel.org/r/1479474236-4139-6-git-send-email-hch@lst.de
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Joel Fernandes <joelaf@google.com>
Cc: Jisheng Zhang <jszhang@marvell.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: John Dias <joaodias@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/fork.c~kernel-fork-use-vfree_atomic-to-free-thread-stack kernel/fork.c
--- a/kernel/fork.c~kernel-fork-use-vfree_atomic-to-free-thread-stack
+++ a/kernel/fork.c
@@ -229,7 +229,7 @@ static inline void free_thread_stack(str
 		}
 		local_irq_restore(flags);
 
-		vfree(tsk->stack);
+		vfree_atomic(tsk->stack);
 		return;
 	}
 #endif
_

Patches currently in -mm which might be from aryabinin@virtuozzo.com are

mm-add-vfree_atomic.patch
kernel-fork-use-vfree_atomic-to-free-thread-stack.patch
x86-ldt-use-vfree_atomic-to-free-ldt-entries.patch

