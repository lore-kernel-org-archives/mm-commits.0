From: akpm@linux-foundation.org
Subject: [patch 073/123] kernel/fork: use vfree_atomic() to free thread
 stack
Date: Mon, 12 Dec 2016 16:44:14 -0800
Message-ID: <584f445e.23kh50MvQjwVKtMc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41442 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753214AbcLMAoP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:44:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, aryabinin@virtuozzo.com, chris@chris-wilson.co.uk, hch@lst.de, hpa@zytor.com, joaodias@google.com, joelaf@google.com, jszhang@marvell.com, mingo@elte.hu, tglx@linutronix.de

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
