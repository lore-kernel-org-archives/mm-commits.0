From: akpm@linux-foundation.org
Subject: [merged] ibmphp-read-the-length-of-ebda-and-map-entire-ebda-region.patch removed from -mm tree
Date: Thu, 21 Jan 2010 13:28:30 -0800
Message-ID: <201001212128.o0LLSUXp030720@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41029 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755366Ab0AUV3X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Jan 2010 16:29:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chandru@in.ibm.com, chandru@linux.vnet.ibm.com, jbarnes@virtuousgeek.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     ibmphp: read the length of ebda and map entire ebda region
has been removed from the -mm tree.  Its filename was
     ibmphp-read-the-length-of-ebda-and-map-entire-ebda-region.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ibmphp: read the length of ebda and map entire ebda region
From: Chandru <chandru@in.ibm.com>

ibmphp driver currently maps only 1KB of ebda memory area into kernel
address space during driver initialization.  This causes kernel oops when
the driver is modprobe'd and it accesses memory area beyond 1KB within
ebda segment.  The first byte of ebda segment actually stores the length
of the ebda region in Kilobytes.  Hence make use of the length parameter
and map the entire ebda region.

Signed-off-by: Chandru Siddalingappa <chandru@linux.vnet.ibm.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/hotplug/ibmphp_ebda.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN drivers/pci/hotplug/ibmphp_ebda.c~ibmphp-read-the-length-of-ebda-and-map-entire-ebda-region drivers/pci/hotplug/ibmphp_ebda.c
--- a/drivers/pci/hotplug/ibmphp_ebda.c~ibmphp-read-the-length-of-ebda-and-map-entire-ebda-region
+++ a/drivers/pci/hotplug/ibmphp_ebda.c
@@ -245,7 +245,7 @@ static void __init print_ebda_hpc (void)
 
 int __init ibmphp_access_ebda (void)
 {
-	u8 format, num_ctlrs, rio_complete, hs_complete;
+	u8 format, num_ctlrs, rio_complete, hs_complete, ebda_sz;
 	u16 ebda_seg, num_entries, next_offset, offset, blk_id, sub_addr, re, rc_id, re_id, base;
 	int rc = 0;
 
@@ -260,7 +260,14 @@ int __init ibmphp_access_ebda (void)
 	iounmap (io_mem);
 	debug ("returned ebda segment: %x\n", ebda_seg);
 	
-	io_mem = ioremap(ebda_seg<<4, 1024);
+	io_mem = ioremap(ebda_seg<<4, 1);
+	ebda_sz = readb(io_mem);
+	iounmap(io_mem);
+	debug("ebda size: %d(KiB)\n", ebda_sz);
+	if (ebda_sz == 0)
+		return -ENOMEM;
+
+	io_mem = ioremap(ebda_seg<<4, (ebda_sz * 1024));
 	if (!io_mem )
 		return -ENOMEM;
 	next_offset = 0x180;
_

Patches currently in -mm which might be from chandru@in.ibm.com are

linux-next.patch

