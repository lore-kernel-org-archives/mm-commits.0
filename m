From: akpm@linux-foundation.org
Subject: + pci-set-pci=bfsort-for-poweredge-r900.patch added to -mm tree
Date: Sun, 25 Mar 2007 01:12:13 -0800
Message-ID: <200703250912.l2P9CDtC024447@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37092 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933271AbXCYJMR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 05:12:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Matt_Domsch@dell.com, greg@kroah.com


The patch titled
     pci: set pci=bfsort for PowerEdge R900
has been added to the -mm tree.  Its filename is
     pci-set-pci=bfsort-for-poweredge-r900.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pci: set pci=bfsort for PowerEdge R900
From: Matt Domsch <Matt_Domsch@dell.com>

Automatically enable pci=bfsort for the Dell PowerEdge R900.  This is
necessary to ensure the onboard NICs enumerate in the proper order, similar
to the other systems already on the list.

Signed-off-by: Matt Domsch <Matt_Domsch@dell.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/pci/common.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN arch/i386/pci/common.c~pci-set-pci=bfsort-for-poweredge-r900 arch/i386/pci/common.c
--- a/arch/i386/pci/common.c~pci-set-pci=bfsort-for-poweredge-r900
+++ a/arch/i386/pci/common.c
@@ -197,6 +197,14 @@ static struct dmi_system_id __devinitdat
 	},
 	{
 		.callback = set_bf_sort,
+		.ident = "Dell PowerEdge R900",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge R900"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
 		.ident = "HP ProLiant BL20p G3",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
_

Patches currently in -mm which might be from Matt_Domsch@dell.com are

origin.patch
pci-set-pci=bfsort-for-poweredge-r900.patch
