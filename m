From: akpm@linux-foundation.org
Subject: + ipmi-convert-tracking-of-the-acpi-device-pointer-to-a-pnp-device.patch added to -mm tree
Date: Fri, 19 Mar 2010 14:23:52 -0700
Message-ID: <201003192123.o2JLNriU013153@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59901 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751618Ab0CSVYA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 17:24:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: myron.stowe@hp.com, bjorn.helgaas@hp.com, lenb@kernel.org, minyard@acm.org, yakui.zhao@intel.com


The patch titled
     ipmi: convert tracking of the ACPI device pointer to a PNP device
has been added to the -mm tree.  Its filename is
     ipmi-convert-tracking-of-the-acpi-device-pointer-to-a-pnp-device.patch

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
Subject: ipmi: convert tracking of the ACPI device pointer to a PNP device
From: Myron Stowe <myron.stowe@hp.com>

Convert PNP patch (git 9e368fa011d4e0aa050db348d69514900520e40b) to
maintain a pointer to a PNP device, 'pnp_dev', instead of the ACPI device,
'acpi_dev', that is currently being tracked with PNP based IPMI device
discovery.

Signed-off-by: Myron Stowe <myron.stowe@hp.com>
Acked-by: Zhao Yakui <yakui.zhao@intel.com>
Cc: Corey Minyard <minyard@acm.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_si_intf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-convert-tracking-of-the-acpi-device-pointer-to-a-pnp-device drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-convert-tracking-of-the-acpi-device-pointer-to-a-pnp-device
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -2156,7 +2156,7 @@ static int __devinit ipmi_pnp_probe(stru
 		info->irq_setup = std_irq_setup;
 	}
 
-	info->dev = &acpi_dev->dev;
+	info->dev = &dev->dev;
 	pnp_set_drvdata(dev, info);
 
 	return try_smi_init(info);
_

Patches currently in -mm which might be from myron.stowe@hp.com are

ipmi-raise-precedence-of-pnp-based-discovery-mechanisms-acpi-pci.patch
ipmi-convert-tracking-of-the-acpi-device-pointer-to-a-pnp-device.patch
ipmi-update-driver-to-use-dev_printk-and-its-constructs.patch

