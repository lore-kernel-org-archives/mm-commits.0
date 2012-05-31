From: akpm@linux-foundation.org
Subject: [merged] swiotlb-print-physical-addresses-consistently-with-other-parts-of-kernel.patch removed from -mm tree
Date: Thu, 31 May 2012 12:14:48 -0700
Message-ID: <20120531191448.78D8FA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:41965 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932892Ab2EaTOt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:14:49 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so134384ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:14:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhelgaas@google.com, hpa@zytor.com, konrad.wilk@oracle.com, mingo@elte.hu, tglx@linutronix.de, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: swiotlb: print physical addresses consistently with other parts of kernel
has been removed from the -mm tree.  Its filename was
     swiotlb-print-physical-addresses-consistently-with-other-parts-of-kernel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Bjorn Helgaas <bhelgaas@google.com>
Subject: swiotlb: print physical addresses consistently with other parts of kernel

Print swiotlb info in a style consistent with the %pR style used elsewhere
in the kernel.  For example:

    -Placing 64MB software IO TLB between ffff88007a662000 - ffff88007e662000
    -software IO TLB at phys 0x7a662000 - 0x7e662000
    +software IO TLB [mem 0x7a662000-0x7e661fff] (64MB) mapped at [ffff88007a662000-ffff88007e661fff]

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/swiotlb.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN lib/swiotlb.c~swiotlb-print-physical-addresses-consistently-with-other-parts-of-kernel lib/swiotlb.c
--- a/lib/swiotlb.c~swiotlb-print-physical-addresses-consistently-with-other-parts-of-kernel
+++ a/lib/swiotlb.c
@@ -130,11 +130,9 @@ void swiotlb_print_info(void)
 	pstart = virt_to_phys(io_tlb_start);
 	pend = virt_to_phys(io_tlb_end);
 
-	printk(KERN_INFO "Placing %luMB software IO TLB between %p - %p\n",
-	       bytes >> 20, io_tlb_start, io_tlb_end);
-	printk(KERN_INFO "software IO TLB at phys %#llx - %#llx\n",
-	       (unsigned long long)pstart,
-	       (unsigned long long)pend);
+	printk(KERN_INFO "software IO TLB [mem %#010llx-%#010llx] (%luMB) mapped at [%p-%p]\n",
+	       (unsigned long long)pstart, (unsigned long long)pend - 1,
+	       bytes >> 20, io_tlb_start, io_tlb_end - 1);
 }
 
 void __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)
_

Patches currently in -mm which might be from bhelgaas@google.com are

origin.patch

