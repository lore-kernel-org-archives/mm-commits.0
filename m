From: akpm@linux-foundation.org
Subject: [merged] x86-ldt-use-vfree_atomic-to-free-ldt-entries.patch
 removed from -mm tree
Date: Wed, 14 Dec 2016 11:26:00 -0800
Message-ID: <58519cc8.Wny41q7nF85wTcPz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44934 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756627AbcLNT0J (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:26:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, chris@chris-wilson.co.uk, hch@lst.de, hpa@zytor.com, joaodias@google.com, joelaf@google.com, jszhang@marvell.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86/ldt: use vfree_atomic() to free ldt entries
has been removed from the -mm tree.  Its filename was
     x86-ldt-use-vfree_atomic-to-free-ldt-entries.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


