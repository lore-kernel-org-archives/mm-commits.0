From: akpm@linux-foundation.org
Subject: - ipmi-dont-init-irq-until-ready.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:46:12 -0700
Message-ID: <200710190346.l9J3kCqf013290@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37465 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934306AbXJSDzf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cminyard@mvista.com, Patrick.Schoeller@hp.com, mm-commits@vger.kernel.org


The patch titled
     IPMI: don't init irq until ready
has been removed from the -mm tree.  Its filename was
     ipmi-dont-init-irq-until-ready.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: IPMI: don't init irq until ready
From: Corey Minyard <cminyard@mvista.com>

Patrick found a race at startup.  Interrupts were being enabled for the IPMI
interface before the driver was really ready to handle them.  This could
result in an oops if something was pending on the interface at startup and
interrupt were already enabled (technically shouldn't happen, but need to
cover for this in real life).  So move the IRQ setup to the code that starts
the actual IPMI processing.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Cc: Patrick Schoeller <Patrick.Schoeller@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_si_intf.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-dont-init-irq-until-ready drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-dont-init-irq-until-ready
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -1006,6 +1006,10 @@ static int smi_start_processing(void    
 
 	new_smi->intf = intf;
 
+	/* Try to claim any interrupts. */
+	if (new_smi->irq_setup)
+		new_smi->irq_setup(new_smi);
+
 	/* Set up the timer that drives the interface. */
 	setup_timer(&new_smi->si_timer, smi_timeout, (long)new_smi);
 	new_smi->last_timeout_jiffies = jiffies;
@@ -2765,10 +2769,6 @@ static int try_smi_init(struct smi_info 
 	setup_oem_data_handler(new_smi);
 	setup_xaction_handlers(new_smi);
 
-	/* Try to claim any interrupts. */
-	if (new_smi->irq_setup)
-		new_smi->irq_setup(new_smi);
-
 	INIT_LIST_HEAD(&(new_smi->xmit_msgs));
 	INIT_LIST_HEAD(&(new_smi->hp_xmit_msgs));
 	new_smi->curr_msg = NULL;
_

Patches currently in -mm which might be from cminyard@mvista.com are

origin.patch
