From: akpm@linux-foundation.org
Subject: + agp-ensure-gart-has-an-address-before-enabling-it.patch added to -mm tree
Date: Mon, 31 Jan 2011 14:25:43 -0800
Message-ID: <201101312225.p0VMPh9o005459__17484.956168528$1296512774$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40071 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753451Ab1AaW0E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Jan 2011 17:26:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steve@sk2.org, airlied@redhat.com, bjorn.helgaas@hp.com, florian@mickler.org, maciej.rutecki@gmail.com, rjw@sisk.pl, segooon@gmail.com, stable@kernel.org


The patch titled
     agp: ensure GART has an address before enabling it
has been added to the -mm tree.  Its filename is
     agp-ensure-gart-has-an-address-before-enabling-it.patch

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
Subject: agp: ensure GART has an address before enabling it
From: Stephen Kitt <steve@sk2.org>

Some BIOSs (eg.  the AMI BIOS on the Asus P4P800 motherboard) don't
initialise the GART address, and pcibios_assign_resources() can ignore it
because it can be marked as a host bridge (see
https://bugzilla.kernel.org/show_bug.cgi?id=24392#c5 for details).  This
was handled correctly up to 2.6.35, but the pci_enable_device() cleanup in
2.6.36 96576a9e1a0cdb8 ("agp: intel-agp: do not use PCI resources before
pci_enable_device()") means that the kernel tries to enable the GART
before assigning it an address; in such cases the GART overlaps with other
device assignments and ends up being disabled.

This patch fixes https://bugzilla.kernel.org/show_bug.cgi?id=24392

Note that I imagine efficeon-agp.c probably has the same problem, but
I can't test that and I'd like to make sure this patch is suitable for
-stable (since 2.6.36 and 2.6.37 are affected).

Signed-off-by: Stephen Kitt <steve@sk2.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kulikov Vasiliy <segooon@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Florian Mickler <florian@mickler.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/intel-agp.c |   27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff -puN drivers/char/agp/intel-agp.c~agp-ensure-gart-has-an-address-before-enabling-it drivers/char/agp/intel-agp.c
--- a/drivers/char/agp/intel-agp.c~agp-ensure-gart-has-an-address-before-enabling-it
+++ a/drivers/char/agp/intel-agp.c
@@ -774,20 +774,14 @@ static int __devinit agp_intel_probe(str
 	dev_info(&pdev->dev, "Intel %s Chipset\n", intel_agp_chipsets[i].name);
 
 	/*
-	* If the device has not been properly setup, the following will catch
-	* the problem and should stop the system from crashing.
-	* 20030610 - hamish@zot.org
-	*/
-	if (pci_enable_device(pdev)) {
-		dev_err(&pdev->dev, "can't enable PCI device\n");
-		agp_put_bridge(bridge);
-		return -ENODEV;
-	}
-
-	/*
 	* The following fixes the case where the BIOS has "forgotten" to
 	* provide an address range for the GART.
 	* 20030610 - hamish@zot.org
+	* This happens before pci_enable_device() intentionally;
+	* calling pci_enable_device() before assigning the resource
+	* will result in the GART being disabled on machines with such
+	* BIOSs (the GART ends up with a BAR starting at 0, which
+	* conflicts a lot of other devices).
 	*/
 	r = &pdev->resource[0];
 	if (!r->start && r->end) {
@@ -798,6 +792,17 @@ static int __devinit agp_intel_probe(str
 		}
 	}
 
+	/*
+	* If the device has not been properly setup, the following will catch
+	* the problem and should stop the system from crashing.
+	* 20030610 - hamish@zot.org
+	*/
+	if (pci_enable_device(pdev)) {
+		dev_err(&pdev->dev, "can't enable PCI device\n");
+		agp_put_bridge(bridge);
+		return -ENODEV;
+	}
+
 	/* Fill in the mode register */
 	if (cap_ptr) {
 		pci_read_config_dword(pdev,
_

Patches currently in -mm which might be from steve@sk2.org are

agp-ensure-gart-has-an-address-before-enabling-it.patch

