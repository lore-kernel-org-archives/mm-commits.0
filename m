From: akpm@linux-foundation.org
Subject: - genirq-null-struct-irq_descs-member-name-in-dynamic_irq_cleanup.patch removed from -mm tree
Date: Wed, 22 Oct 2008 13:09:12 -0700
Message-ID: <200810222009.m9MK9CXi014007@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754147AbYJVUJZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Oct 2008 16:09:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcn@sgi.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     genirq: NULL struct irq_desc's member 'name' in dynamic_irq_cleanup()
has been removed from the -mm tree.  Its filename was
     genirq-null-struct-irq_descs-member-name-in-dynamic_irq_cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: genirq: NULL struct irq_desc's member 'name' in dynamic_irq_cleanup()
From: Dean Nelson <dcn@sgi.com>

If the member 'name' of the irq_desc structure happens to point to a
character string that is resident within a kernel module, problems ensue
if that module is rmmod'd (at which time dynamic_irq_cleanup() is called)
and then later show_interrupts() is called by someone.

It is also not a good thing if the character string resided in kmalloc'd
space that has been kfree'd (after having called dynamic_irq_cleanup()). 
dynamic_irq_cleanup() fails to NULL the 'name' member and
show_interrupts() references it on a few architectures (like h8300, sh and
x86).

Signed-off-by: Dean Nelson <dcn@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/chip.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/irq/chip.c~genirq-null-struct-irq_descs-member-name-in-dynamic_irq_cleanup kernel/irq/chip.c
--- a/kernel/irq/chip.c~genirq-null-struct-irq_descs-member-name-in-dynamic_irq_cleanup
+++ a/kernel/irq/chip.c
@@ -78,6 +78,7 @@ void dynamic_irq_cleanup(unsigned int ir
 	desc->chip_data = NULL;
 	desc->handle_irq = handle_bad_irq;
 	desc->chip = &no_irq_chip;
+	desc->name = NULL;
 	spin_unlock_irqrestore(&desc->lock, flags);
 }
 
_

Patches currently in -mm which might be from dcn@sgi.com are

origin.patch
linux-next.patch

