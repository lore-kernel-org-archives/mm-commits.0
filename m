From: akpm@osdl.org
Subject: - x86-64-calgary-tighten-up-printks.patch removed from -mm tree
Date: Wed, 10 Jan 2007 15:03:46 -0800
Message-ID: <200701102303.l0AN3kqM010853@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33463 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965271AbXAJXD5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jan 2007 18:03:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: muli@il.ibm.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     x86-64 Calgary: tighten up printks
has been removed from the -mm tree.  Its filename was
     x86-64-calgary-tighten-up-printks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86-64 Calgary: tighten up printks
From: Muli Ben-Yehuda <muli@il.ibm.com>

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/kernel/pci-calgary.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff -puN arch/x86_64/kernel/pci-calgary.c~x86-64-calgary-tighten-up-printks arch/x86_64/kernel/pci-calgary.c
--- a/arch/x86_64/kernel/pci-calgary.c~x86-64-calgary-tighten-up-printks
+++ a/arch/x86_64/kernel/pci-calgary.c
@@ -1068,6 +1068,8 @@ void __init detect_calgary(void)
 	if (!early_pci_allowed())
 		return;
 
+	printk(KERN_DEBUG "Calgary: detecting Calgary via BIOS EBDA area\n");
+
 	ptr = (unsigned long)phys_to_virt(get_bios_ebda());
 
 	rio_table_hdr = NULL;
@@ -1088,14 +1090,14 @@ void __init detect_calgary(void)
 		offset = *((unsigned short *)(ptr + offset));
 	}
 	if (!rio_table_hdr) {
-		printk(KERN_ERR "Calgary: Unable to locate "
-				"Rio Grande Table in EBDA - bailing!\n");
+		printk(KERN_DEBUG "Calgary: Unable to locate Rio Grande table "
+		       "in EBDA - bailing!\n");
 		return;
 	}
 
 	ret = build_detail_arrays();
 	if (ret) {
-		printk(KERN_ERR "Calgary: build_detail_arrays ret %d\n", ret);
+		printk(KERN_DEBUG "Calgary: build_detail_arrays ret %d\n", ret);
 		return;
 	}
 
@@ -1128,6 +1130,9 @@ void __init detect_calgary(void)
 		}
 	}
 
+	printk(KERN_DEBUG "Calgary: finished detection, Calgary %s\n",
+	       calgary_found ? "found" : "not found");
+
 	if (calgary_found) {
 		iommu_detected = 1;
 		calgary_detected = 1;
_

Patches currently in -mm which might be from muli@il.ibm.com are

ia64-make-swiotlb-use-bus_to_virt-virt_to_bus.patch
ehca-avoid-crash-on-kthread_create-failure.patch
git-pciseg.patch
