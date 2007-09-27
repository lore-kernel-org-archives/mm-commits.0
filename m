From: akpm@linux-foundation.org
Subject: - i386-compaq-evo-n800c-needs-pci-bus-renumbering.patch removed from -mm tree
Date: Wed, 26 Sep 2007 18:43:41 -0700
Message-ID: <200709270143.l8R1hfE8013983@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54999 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752668AbXI0BvQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 21:51:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Juha.Laiho@iki.fi, ak@suse.de, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     i386: Compaq EVO N800c needs PCI bus renumbering
has been removed from the -mm tree.  Its filename was
     i386-compaq-evo-n800c-needs-pci-bus-renumbering.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: Compaq EVO N800c needs PCI bus renumbering
From: Juha Laiho <Juha.Laiho@iki.fi>

Force PCI bus renumbering for Compaq EVO N800c laptop, in order to get
the cardbus slot recognised.

Signed-off-by: Juha Laiho <Juha.Laiho@iki.fi>
Cc: Greg KH <greg@kroah.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/pci/common.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN arch/i386/pci/common.c~i386-compaq-evo-n800c-needs-pci-bus-renumbering arch/i386/pci/common.c
--- a/arch/i386/pci/common.c~i386-compaq-evo-n800c-needs-pci-bus-renumbering
+++ a/arch/i386/pci/common.c
@@ -289,6 +289,14 @@ static struct dmi_system_id __devinitdat
 			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL685c G1"),
 		},
 	},
+	{
+		.callback = assign_all_busses,
+		.ident = "Compaq EVO N800c",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Compaq"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "EVO N800c"),
+		},
+	},
 	{}
 };
 
_

Patches currently in -mm which might be from Juha.Laiho@iki.fi are
