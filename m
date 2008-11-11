From: akpm@linux-foundation.org
Subject: + clocksource-acpi_pmc-put-acpi_pm_read_slow-under-config_pci.patch added to -mm tree
Date: Tue, 11 Nov 2008 15:47:30 -0800
Message-ID: <200811112347.mABNlU0q024190@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49210 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751825AbYKKXsU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Nov 2008 18:48:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, lenb@kernel.org, linux@dominikbrodowski.net, tglx@linutronix.de


The patch titled
     clocksource, acpi_pm.c: put acpi_pm_read_slow() under CONFIG_PCI
has been added to the -mm tree.  Its filename is
     clocksource-acpi_pmc-put-acpi_pm_read_slow-under-config_pci.patch

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
Subject: clocksource, acpi_pm.c: put acpi_pm_read_slow() under CONFIG_PCI
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

acpi_pm_read_slow() is only used when CONFIG_PCI=y, so move the definition
inside the ifdef.

Otherwise this causes a "defined but not used" warning when building with
CONFIG_ACPI=y and CONFIG_PCI=n (that's not supported yet, but it could
be).

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/clocksource/acpi_pm.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/clocksource/acpi_pm.c~clocksource-acpi_pmc-put-acpi_pm_read_slow-under-config_pci drivers/clocksource/acpi_pm.c
--- a/drivers/clocksource/acpi_pm.c~clocksource-acpi_pmc-put-acpi_pm_read_slow-under-config_pci
+++ a/drivers/clocksource/acpi_pm.c
@@ -57,11 +57,6 @@ u32 acpi_pm_read_verified(void)
 	return v2;
 }
 
-static cycle_t acpi_pm_read_slow(void)
-{
-	return (cycle_t)acpi_pm_read_verified();
-}
