From: akpm@linux-foundation.org
Subject: + ipmi-dont-init-irq-until-ready.patch added to -mm tree
Date: Mon, 15 Oct 2007 14:53:59 -0700
Message-ID: <200710152153.l9FLrx45026970@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37202 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759605AbXJOVyY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 17:54:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cminyard@mvista.com, Patrick.Schoeller@hp.com


The patch titled
     IPMI: don't init irq until ready
has been added to the -mm tree.  Its filename is
     ipmi-dont-init-irq-until-ready.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

ipmi-dont-init-irq-until-ready.patch
ipmi-remove-bogus-semaphore-from-watchdog.patch
ipmi-documentation-fixes.patch
ipmi-add-polled-interface.patch
ipmi-fix-hotmod-remove-lock.patch
ipmi-add-09-support.patch
