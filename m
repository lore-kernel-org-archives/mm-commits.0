From: akpm@linux-foundation.org
Subject: + x86_64-family-10h-and-11h-to-k8topology.patch added to -mm tree
Date: Thu, 26 Jul 2007 23:37:38 -0700
Message-ID: <200707270637.l6R6bcFS009779@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47946 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760670AbXG0Gh6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Jul 2007 02:37:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joachim.deguara@amd.com, ak@suse.de, clameter@sgi.com, lenb@kernel.org, yinghai.lu@sun.com


The patch titled
     x86_64: family 10h and 11h to k8topology
has been added to the -mm tree.  Its filename is
     x86_64-family-10h-and-11h-to-k8topology.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: family 10h and 11h to k8topology
From: "Joachim Deguara" <joachim.deguara@amd.com>

This just adds the PCI IDs of AMD's family 10h and 11h CPU's northbridges to
k8topology discovery.

Signed-off-by: Joachim Deguara <joachim.deguara@amd.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Acked-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/mm/k8topology.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN arch/x86_64/mm/k8topology.c~x86_64-family-10h-and-11h-to-k8topology arch/x86_64/mm/k8topology.c
--- a/arch/x86_64/mm/k8topology.c~x86_64-family-10h-and-11h-to-k8topology
+++ a/arch/x86_64/mm/k8topology.c
@@ -28,11 +28,15 @@ static __init int find_northbridge(void)
 		u32 header;
 		
 		header = read_pci_config(0, num, 0, 0x00);  
-		if (header != (PCI_VENDOR_ID_AMD | (0x1100<<16)))
+		if ((header != (PCI_VENDOR_ID_AMD | (0x1100<<16))) &&
+		    (header != (PCI_VENDOR_ID_AMD | (0x1200<<16))) &&
+		    (header != (PCI_VENDOR_ID_AMD | (0x1300<<16))))
 			continue; 	
 
 		header = read_pci_config(0, num, 1, 0x00); 
-		if (header != (PCI_VENDOR_ID_AMD | (0x1101<<16)))
+		if ((header != (PCI_VENDOR_ID_AMD | (0x1101<<16))) &&
+		    (header != (PCI_VENDOR_ID_AMD | (0x1201<<16))) &&
+		    (header != (PCI_VENDOR_ID_AMD | (0x1301<<16))))
 			continue;	
 		return num; 
 	} 
_

Patches currently in -mm which might be from joachim.deguara@amd.com are

x86_64-family-10h-and-11h-to-k8topology.patch
documentation-update-sched-stattxt.patch
