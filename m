From: akpm@linux-foundation.org
Subject: + x86-ldt-use-vfree_atomic-to-free-ldt-entries.patch added to -mm tree
Date: Mon, 21 Nov 2016 22:11:04 -0800
Message-ID: <5833e178.pkW6fQeoVxV9tmUx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57688 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751311AbcKVGLG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2016 01:11:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, chris@chris-wilson.co.uk, hch@lst.de, hpa@zytor.com, joaodias@google.com, joelaf@google.com, jszhang@marvell.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86/ldt: use vfree_atomic() to free ldt entries
has been added to the -mm tree.  Its filename is
     x86-ldt-use-vfree_atomic-to-free-ldt-entries.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-ldt-use-vfree_atomic-to-free-ldt-entries.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-ldt-use-vfree_atomic-to-free-ldt-entries.patch

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
Subject: x86/ldt: use vfree_atomic() to free ldt entries

vfree() is going to use sleeping lock.  free_ldt_struct() may be called
with disabled preemption, therefore we must use vfree_atomic() here.

E.g. call trace:
	vfree()
	free_ldt_struct()
	destroy_context_ldt()
	__mmdrop()
	finish_task_switch()
	schedule_tail()
	ret_from_fork()

Link: http://lkml.kernel.org/r/1479474236-4139-7-git-send-email-hch@lst.de
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

 arch/x86/kernel/ldt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/kernel/ldt.c~x86-ldt-use-vfree_atomic-to-free-ldt-entries arch/x86/kernel/ldt.c
--- a/arch/x86/kernel/ldt.c~x86-ldt-use-vfree_atomic-to-free-ldt-entries
+++ a/arch/x86/kernel/ldt.c
@@ -93,7 +93,7 @@ static void free_ldt_struct(struct ldt_s
 
 	paravirt_free_ldt(ldt->entries, ldt->size);
 	if (ldt->size * LDT_ENTRY_SIZE > PAGE_SIZE)
-		vfree(ldt->entries);
+		vfree_atomic(ldt->entries);
 	else
 		free_page((unsigned long)ldt->entries);
 	kfree(ldt);
_

Patches currently in -mm which might be from aryabinin@virtuozzo.com are

mm-add-vfree_atomic.patch
kernel-fork-use-vfree_atomic-to-free-thread-stack.patch
x86-ldt-use-vfree_atomic-to-free-ldt-entries.patch

