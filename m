From: akpm@linux-foundation.org
Subject: + fix-very-high-interrupt-rate-for-irq8-rtc-unless-pnpacpi=off.patch added to -mm tree
Date: Wed, 26 Sep 2007 15:43:10 -0700
Message-ID: <200709262243.l8QMhAOR007724@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39435 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756531AbXIZWnw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 18:43:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olel@ans.pl, ak@suse.de, ambx1@neo.rr.com, bjorn.helgaas@hp.com, ole@ans.pl, shaohua.li@intel.com


The patch titled
     Fix very high interrupt rate for IRQ8 (rtc) unless pnpacpi=off
has been added to the -mm tree.  Its filename is
     fix-very-high-interrupt-rate-for-irq8-rtc-unless-pnpacpi=off.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix very high interrupt rate for IRQ8 (rtc) unless pnpacpi=off
From: Krzysztof Oledzki <olel@ans.pl>

Workaround for broken systems with BIOS that makes RTC interrupt level
triggered and/or active low.

See http://bugzilla.kernel.org/show_bug.cgi?id=5243

Based on the patch from Shaohua Li <shaohua.li@intel.com>

Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>
Cc: "Li, Shaohua" <shaohua.li@intel.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Adam Belay <ambx1@neo.rr.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/pnp/pnpacpi/rsparser.c~fix-very-high-interrupt-rate-for-irq8-rtc-unless-pnpacpi=off drivers/pnp/pnpacpi/rsparser.c
--- a/drivers/pnp/pnpacpi/rsparser.c~fix-very-high-interrupt-rate-for-irq8-rtc-unless-pnpacpi=off
+++ a/drivers/pnp/pnpacpi/rsparser.c
@@ -85,6 +85,16 @@ static void pnpacpi_parse_allocated_irqr
 	if (i >= PNP_MAX_IRQ)
 		return;
 
+#ifdef CONFIG_X86
+	if (gsi < 16 && (triggering != ACPI_EDGE_SENSITIVE ||
+				polarity != ACPI_ACTIVE_HIGH)) {
+		pnp_warn("BIOS BUG: legacy PNP IRQ %d should be edge trigger, "
+				"active high", gsi);
+		triggering = ACPI_EDGE_SENSITIVE;
+		polarity = ACPI_ACTIVE_HIGH;
+	}
+#endif
+
 	res->irq_resource[i].flags = IORESOURCE_IRQ;	// Also clears _UNSET flag
 	res->irq_resource[i].flags |= irq_flags(triggering, polarity);
 	irq = acpi_register_gsi(gsi, triggering, polarity);
_

Patches currently in -mm which might be from olel@ans.pl are

fix-very-high-interrupt-rate-for-irq8-rtc-unless-pnpacpi=off.patch
