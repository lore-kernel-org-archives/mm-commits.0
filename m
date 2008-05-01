From: akpm@linux-foundation.org
Subject: + pnp-set-irq-index-in-sysfs-set-irq-interface.patch added to -mm tree
Date: Thu, 01 May 2008 15:16:18 -0700
Message-ID: <200805012216.m41MGIov028258@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49685 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760856AbYEAWQl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 18:16:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, lenb@kernel.org


The patch titled
     PNP: set IRQ index in sysfs "set irq" interface
has been added to the -mm tree.  Its filename is
     pnp-set-irq-index-in-sysfs-set-irq-interface.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: PNP: set IRQ index in sysfs "set irq" interface
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

We have to set the ISAPNP register index when setting an IRQ via the sysfs
interface.  We already do it for IO, MEM, and DMA resources; I just missed the
IRQ one.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/interface.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pnp/interface.c~pnp-set-irq-index-in-sysfs-set-irq-interface drivers/pnp/interface.c
--- a/drivers/pnp/interface.c~pnp-set-irq-index-in-sysfs-set-irq-interface
+++ a/drivers/pnp/interface.c
@@ -424,7 +424,7 @@ pnp_set_current_resources(struct device 
 				start = simple_strtoul(buf, &buf, 0);
 				pnp_res = pnp_add_irq_resource(dev, start, 0);
 				if (pnp_res)
-					nirq++;
+					pnp_res->index = nirq++;
 				continue;
 			}
 			if (!strnicmp(buf, "dma", 3)) {
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

origin.patch
pnp-fix-printk-format-warnings.patch
acpi_pm_device_sleep_state-cleanup.patch
acpi-fix-drivers-acpi-gluec-build-error.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
smsc-ircc2-wrap-pnp-probe-code-in-ifdef-config_pnp.patch
nsc-ircc-wrap-pnp-probe-code-in-ifdef-config_pnp.patch
pnp-set-irq-index-in-sysfs-set-irq-interface.patch

