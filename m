From: akpm@linux-foundation.org
Subject: + swiotlb-print-physical-addresses-consistently-with-other-parts-of-kernel.patch added to -mm tree
Date: Mon, 30 Apr 2012 16:27:23 -0700
Message-ID: <20120430232724.21723A04B2@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:56156 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757370Ab2D3X10 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Apr 2012 19:27:26 -0400
Received: by bkwj5 with SMTP id j5so171316bkw.1
        for <mm-commits@vger.kernel.org>; Mon, 30 Apr 2012 16:27:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bhelgaas@google.com, hpa@zytor.com, konrad.wilk@oracle.com, mingo@elte.hu, tglx@linutronix.de, yinghai@kernel.org


The patch titled
     Subject: swiotlb: print physical addresses consistently with other parts of kernel
has been added to the -mm tree.  Its filename is
     swiotlb-print-physical-addresses-consistently-with-other-parts-of-kernel.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: swiotlb: print physical addresses consistently with other parts of kernel

Patches currently in -mm which might be from bhelgaas@google.com are

linux-next.patch
x86-print-e820-physical-addresses-consistently-with-other-parts-of-kernel.patch
x86-print-physical-addresses-consistently-with-other-parts-of-kernel.patch
swiotlb-print-physical-addresses-consistently-with-other-parts-of-kernel.patch
mm-print-physical-addresses-consistently-with-other-parts-of-kernel.patch

