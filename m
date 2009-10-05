From: akpm@linux-foundation.org
Subject: [merged] acpi-kill-overly-verbose-throttling-states-log-messages.patch removed from -mm tree
Date: Mon, 05 Oct 2009 11:39:55 -0700
Message-ID: <200910051839.n95IdtYk020126@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41962 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754656AbZJESmD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2009 14:42:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdreier@cisco.com, bjorn.helgaas@hp.com, lenb@kernel.org, rolandd@cisco.com, mm-commits@vger.kernel.org


The patch titled
     acpi: kill overly verbose "throttling states" log messages
has been removed from the -mm tree.  Its filename was
     acpi-kill-overly-verbose-throttling-states-log-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: kill overly verbose "throttling states" log messages
From: Roland Dreier <rdreier@cisco.com>

I was recently lucky enough to get a 64-CPU system.  The processors
actually have T-states, so my kernel log ends up with 64 lines like:

    ACPI: Processor [CPU0] (supports xx throttling states)

This is pretty useless clutter because

 - this info is already available after boot from
   /proc/acpi/processor/CPUnn/throttling

 - there's also an ACPI_DEBUG_PRINT() in processor_throttling.c that
   gives the same info on boot for anyone who *really* cares.

So just delete the code that prints the throttling states in
processor_core.c.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_core.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN drivers/acpi/processor_core.c~acpi-kill-overly-verbose-throttling-states-log-messages drivers/acpi/processor_core.c
--- a/drivers/acpi/processor_core.c~acpi-kill-overly-verbose-throttling-states-log-messages
+++ a/drivers/acpi/processor_core.c
@@ -863,13 +863,6 @@ static int acpi_processor_add(struct acp
 		goto err_remove_sysfs;
 	}
 
-	if (pr->flags.throttling) {
-		printk(KERN_INFO PREFIX "%s [%s] (supports",
-		       acpi_device_name(device), acpi_device_bid(device));
-		printk(" %d throttling states", pr->throttling.state_count);
-		printk(")\n");
-	}
