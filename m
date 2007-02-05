From: akpm@linux-foundation.org
Subject: + pci-add-systems-for-automatic-breadth-first-device-sorting.patch added to -mm tree
Date: Mon, 05 Feb 2007 12:59:37 -0800
Message-ID: <200702052059.l15KxbnC031008@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33153 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933428AbXBEU7z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 15:59:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andy@greyhouse.net, Matt_Domsch@dell.com, greg@kroah.com


The patch titled
     PCI: add systems for automatic breadth-first device sorting
has been added to the -mm tree.  Its filename is
     pci-add-systems-for-automatic-breadth-first-device-sorting.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PCI: add systems for automatic breadth-first device sorting
From: Andy Gospodarek <andy@greyhouse.net>

This is an additional list of systems that exhibit the PCI device ordering
issue that prompted the following patch:

commit 6b4b78fed47e7380dfe9280b154e8b9bfcd4c86c
Author: Matt Domsch <Matt_Domsch@dell.com>
Date:   Fri Sep 29 15:23:23 2006 -0500

    PCI: optionally sort device lists breadth-first

Adding these systems to the list prevents the need for the additional
kernel command line argument.

Signed-off-by: Andy Gospodarek <andy@greyhouse.net>
Cc: Greg KH <greg@kroah.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/pci/common.c |   88 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 88 insertions(+)

diff -puN arch/i386/pci/common.c~pci-add-systems-for-automatic-breadth-first-device-sorting arch/i386/pci/common.c
--- a/arch/i386/pci/common.c~pci-add-systems-for-automatic-breadth-first-device-sorting
+++ a/arch/i386/pci/common.c
@@ -191,6 +191,94 @@ static struct dmi_system_id __devinitdat
 			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge 2950"),
 		},
 	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant BL20p G3",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL20p G3"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant BL20p G4",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL20p G4"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant BL30p G1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL30p G1"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant BL25p G1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL25p G1"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant BL35p G1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL35p G1"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant BL45p G1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL45p G1"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant BL45p G2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL45p G1"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant BL460c G1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL460c G1"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant BL465c G1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL465c G1"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant BL480c G1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL480c G1"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant BL685c G1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant BL685c G1"),
+		},
+	},
 	{}
 };
 
_

Patches currently in -mm which might be from andy@greyhouse.net are

pci-add-systems-for-automatic-breadth-first-device-sorting.patch
