From: akpm@linux-foundation.org
Subject: + acpi-kill-overly-verbose-throttling-states-log-messages.patch added to -mm tree
Date: Wed, 30 Sep 2009 13:58:03 -0700
Message-ID: <200909302058.n8UKw3sC015668@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53638 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754169AbZI3U7H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Sep 2009 16:59:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rdreier@cisco.com, bjorn.helgaas@hp.com, lenb@kernel.org, rolandd@cisco.com


The patch titled
     acpi: kill overly verbose "throttling states" log messages
has been added to the -mm tree.  Its filename is
     acpi-kill-overly-verbose-throttling-states-log-messages.patch

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
