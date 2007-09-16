From: akpm@linux-foundation.org
Subject: + i386-compaq-evo-n800c-needs-pci-bus-renumbering.patch added to -mm tree
Date: Sat, 15 Sep 2007 22:32:59 -0700
Message-ID: <200709160532.l8G5WxDo001964@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54964 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750729AbXIPFdN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 01:33:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Juha.Laiho@iki.fi, ak@suse.de, greg@kroah.com


The patch titled
     i386: Compaq EVO N800c needs PCI bus renumbering
has been added to the -mm tree.  Its filename is
     i386-compaq-evo-n800c-needs-pci-bus-renumbering.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -287,6 +287,14 @@ static struct dmi_system_id __devinitdat
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

i386-compaq-evo-n800c-needs-pci-bus-renumbering.patch
