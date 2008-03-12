From: akpm@linux-foundation.org
Subject: + pnp-revert-supermicro-h8dce-motherboard-quirk.patch added to -mm tree
Date: Tue, 11 Mar 2008 22:22:38 -0700
Message-ID: <200803120522.m2C5Mcbt011779@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54540 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750970AbYCLFXX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Mar 2008 01:23:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, ambx1@neo.rr.com, avuton@gmail.com, hancockr@shaw.ca, karl.bellve@umassmed.edu, lenb@kernel.org, mhall@mhcomputing.net, shaohua.li@intel.com, trenn@suse.de, wriede@riede.org


The patch titled
     PNP: revert Supermicro H8DCE motherboard quirk
has been added to the -mm tree.  Its filename is
     pnp-revert-supermicro-h8dce-motherboard-quirk.patch

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
Subject: PNP: revert Supermicro H8DCE motherboard quirk
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

There are other systems with similar problems
(http://lkml.org/lkml/2008/1/27/168), so we need a more
generic quirk.  Remove the Supermicro-specific one first.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Matthew Hall <mhall@mhcomputing.net>
Cc: Willem Riede <wriede@riede.org>
Cc: Robert Hancock <hancockr@shaw.ca>
Cc: Karl Bellve <karl.bellve@umassmed.edu>
Cc: Avuton Olrich <avuton@gmail.com>
Cc: Adam Belay <ambx1@neo.rr.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/quirks.c |   43 -----------------------------------------
 1 file changed, 43 deletions(-)

diff -puN drivers/pnp/quirks.c~pnp-revert-supermicro-h8dce-motherboard-quirk drivers/pnp/quirks.c
--- a/drivers/pnp/quirks.c~pnp-revert-supermicro-h8dce-motherboard-quirk
+++ a/drivers/pnp/quirks.c
@@ -17,7 +17,6 @@
 #include <linux/slab.h>
 #include <linux/pnp.h>
 #include <linux/io.h>
-#include <linux/dmi.h>
 #include <linux/kallsyms.h>
 #include "base.h"
 
@@ -109,46 +108,6 @@ static void quirk_sb16audio_resources(st
 		       "pnp: SB audio device quirk - increasing port range\n");
 }
 
-static void quirk_supermicro_h8dce_system(struct pnp_dev *dev)
-{
-	int i;
-	static struct dmi_system_id supermicro_h8dce[] = {
-		{
-			.ident = "Supermicro H8DCE",
-			.matches = {
-				DMI_MATCH(DMI_SYS_VENDOR, "Supermicro"),
-				DMI_MATCH(DMI_PRODUCT_NAME, "H8DCE"),
-			},
-		},
-		{ }
-	};
-
-	if (!dmi_check_system(supermicro_h8dce))
-		return;
-
-	/*
-	 * On the Supermicro H8DCE, there's a system device with resources
-	 * that overlap BAR 6 of the built-in SATA PCI adapter.  If the PNP
-	 * system device claims them, the sata_nv driver won't be able to.
-	 * More details at:
-	 *     https://bugzilla.redhat.com/show_bug.cgi?id=280641
-	 *     https://bugzilla.redhat.com/show_bug.cgi?id=313491
-	 *     http://lkml.org/lkml/2008/1/9/449
-	 *     http://thread.gmane.org/gmane.linux.acpi.devel/27312
-	 */
-	for (i = 0; i < PNP_MAX_MEM; i++) {
-		if (pnp_mem_valid(dev, i) && pnp_mem_len(dev, i) &&
-		    (pnp_mem_start(dev, i) & 0xdfef0000) == 0xdfef0000) {
-			dev_warn(&dev->dev, "disabling 0x%llx-0x%llx to prevent"
-				" conflict with sata_nv PCI device\n",
-				(unsigned long long) pnp_mem_start(dev, i),
-				(unsigned long long) (pnp_mem_start(dev, i) +
-					pnp_mem_len(dev, i) - 1));
-			pnp_mem_flags(dev, i) = 0;
-		}
-	}
-}
-
 /*
  *  PnP Quirks
  *  Cards or devices that need some tweaking due to incomplete resource info
@@ -169,8 +128,6 @@ static struct pnp_fixup pnp_fixups[] = {
 	{"CTL0043", quirk_sb16audio_resources},
 	{"CTL0044", quirk_sb16audio_resources},
 	{"CTL0045", quirk_sb16audio_resources},
-	{"PNP0c01", quirk_supermicro_h8dce_system},
-	{"PNP0c02", quirk_supermicro_h8dce_system},
 	{""}
 };
 
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

mm-only-enforce-acpi-resource-conflict-checks.patch
pci-simplify-quirk-debug-output.patch
pnp-revert-supermicro-h8dce-motherboard-quirk.patch
pnp-disable-pnp-motherboard-resources-that-overlap-pci-bars.patch
simplify-initcall_debug-output.patch
pnp-skip-dev-protocol-null-checks.patch
pnp-simplify-quirk-debug-output.patch
pnp-use-dev_printk-for-quirk-messages.patch

