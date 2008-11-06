From: akpm@linux-foundation.org
Subject: + irq-maintain-user-set-affinity.patch added to -mm tree
Date: Thu, 06 Nov 2008 13:35:39 -0800
Message-ID: <200811062135.mA6LZdQu032615@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50675 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751154AbYKFViS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Nov 2008 16:38:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: galak@kernel.crashing.org, mingo@elte.hu, tglx@linutronix.de


The patch titled
     irq: maintain user set affinity
has been added to the -mm tree.  Its filename is
     irq-maintain-user-set-affinity.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: irq: maintain user set affinity
From: Kumar Gala <galak@kernel.crashing.org>

This addresses a regression in that if a user specified an affinity for an
interrupt that affinity information would get reset between a
request_irq(), free_irq() and request_irq() for the same irq.

One example of this is bringing up an ethernet interface, taking it down
and bringing it back up again.

Instead of always using the irq_default_affinity we use the previous
setting of the IRQs affinity with the assumption that at boot the IRQs
affinity will be set to irq_default_affinity.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/manage.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN kernel/irq/manage.c~irq-maintain-user-set-affinity kernel/irq/manage.c
--- a/kernel/irq/manage.c~irq-maintain-user-set-affinity
+++ a/kernel/irq/manage.c
@@ -115,9 +115,12 @@ int irq_select_affinity(unsigned int irq
 	if (!irq_can_set_affinity(irq))
 		return 0;
 
-	cpus_and(mask, cpu_online_map, irq_default_affinity);
