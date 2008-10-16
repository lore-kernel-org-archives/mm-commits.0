From: akpm@linux-foundation.org
Subject: + genirq-null-struct-irq_descs-member-name-in-dynamic_irq_cleanup.patch added to -mm tree
Date: Thu, 16 Oct 2008 16:12:00 -0700
Message-ID: <200810162312.m9GNC0qt003873@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56549 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758118AbYJPXMM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 19:12:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dcn@sgi.com, mingo@elte.hu


The patch titled
     genirq: NULL struct irq_desc's member 'name' in dynamic_irq_cleanup()
has been added to the -mm tree.  Its filename is
     genirq-null-struct-irq_descs-member-name-in-dynamic_irq_cleanup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

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

genirq-null-struct-irq_descs-member-name-in-dynamic_irq_cleanup.patch

