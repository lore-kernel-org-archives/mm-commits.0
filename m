From: akpm@linux-foundation.org
Subject: - irq-maintain-user-set-affinity.patch removed from -mm tree
Date: Wed, 12 Nov 2008 12:47:13 -0800
Message-ID: <200811122047.mACKlDqg006919@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59100 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754001AbYKLUre (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Nov 2008 15:47:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: galak@kernel.crashing.org, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     irq: maintain user set affinity
has been removed from the -mm tree.  Its filename was
     irq-maintain-user-set-affinity.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
