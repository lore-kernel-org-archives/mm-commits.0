From: akpm@linux-foundation.org
Subject: - pci-use-pci=bfsort-for-hp-dl385-g2-dl585-g2.patch removed from -mm tree
Date: Mon, 26 Nov 2007 13:50:02 -0800
Message-ID: <200711262150.lAQLo2nk024820@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38178 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755693AbXKZWAC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 17:00:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mschmidt@redhat.com, Matt_Domsch@dell.com, ak@suse.de, andy@greyhouse.net, greg@kroah.com, john.cagle@hp.com, mm-commits@vger.kernel.org


The patch titled
     pci: use pci=bfsort for HP DL385 G2, DL585 G2
has been removed from the -mm tree.  Its filename was
     pci-use-pci=bfsort-for-hp-dl385-g2-dl585-g2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Andy Gospodarek <andy@greyhouse.net>
Cc: Greg KH <greg@kroah.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/pci/common.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN arch/x86/pci/common.c~pci-use-pci=bfsort-for-hp-dl385-g2-dl585-g2 arch/x86/pci/common.c
--- a/arch/x86/pci/common.c~pci-use-pci=bfsort-for-hp-dl385-g2-dl585-g2
+++ a/arch/x86/pci/common.c
@@ -315,6 +315,22 @@ static struct dmi_system_id __devinitdat
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

git-x86.patch
proc-loadavg-reading-race.patch
