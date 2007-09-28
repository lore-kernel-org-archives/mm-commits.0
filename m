From: akpm@linux-foundation.org
Subject: + pci-use-pci=bfsort-for-hp-dl385-g2-dl585-g2.patch added to -mm tree
Date: Thu, 27 Sep 2007 23:29:29 -0700
Message-ID: <200709280629.l8S6TT8r014641@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47610 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755014AbXI1GaT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Sep 2007 02:30:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mschmidt@redhat.com, Matt_Domsch@dell.com, ak@suse.de, andy@greyhouse.net, greg@kroah.com, john.cagle@hp.com


The patch titled
     pci: use pci=bfsort for HP DL385 G2, DL585 G2
has been added to the -mm tree.  Its filename is
     pci-use-pci=bfsort-for-hp-dl385-g2-dl585-g2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pci: use pci=bfsort for HP DL385 G2, DL585 G2
From: Michal Schmidt <mschmidt@redhat.com>

HP ProLiant systems DL385 G2 and DL585 G2 need pci=bfsort to enumerate PCI
devices in the expected order.

Matt sayeth:

  biosdevname is a userspace app I wrote to help solve this so we don't need
  to patch the kernel for future systems.  It's not integrated into any
  distributions properly yet, but is included in openSUSE 10.3 and Fedora 8
  for people who want to download and install it there.  It acts as a udev
  helper.

  For the time being, patching the kernel is necessary.  I really hope
  biosdevname eliminates that need in future distributions.

  http://linux.dell.com/biosdevname/

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Cc: <john.cagle@hp.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
Cc: Greg KH <greg@kroah.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/pci/common.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN arch/i386/pci/common.c~pci-use-pci=bfsort-for-hp-dl385-g2-dl585-g2 arch/i386/pci/common.c
--- a/arch/i386/pci/common.c~pci-use-pci=bfsort-for-hp-dl385-g2-dl585-g2
+++ a/arch/i386/pci/common.c
@@ -297,6 +297,22 @@ static struct dmi_system_id __devinitdat
 		},
 	},
 #endif
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant DL385 G2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant DL385 G2"),
+		},
+	},
+	{
+		.callback = set_bf_sort,
+		.ident = "HP ProLiant DL585 G2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant DL585 G2"),
+		},
+	},
 	{}
 };
 
_

Patches currently in -mm which might be from mschmidt@redhat.com are

origin.patch
pci-use-pci=bfsort-for-hp-dl385-g2-dl585-g2.patch
