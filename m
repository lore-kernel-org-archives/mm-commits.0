From: akpm@linux-foundation.org
Subject: + swiotlb-fix-wrong-panic.patch added to -mm tree
Date: Thu, 17 Feb 2011 13:09:18 -0800
Message-ID: <201102172109.p1HL9IE0011859__21543.9618252733$1297976996$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50445 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757349Ab1BQVJt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Feb 2011 16:09:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, arekm@maven.pl, cebbert@redhat.com, stable@kernel.org


The patch titled
     swiotlb: fix wrong panic
has been added to the -mm tree.  Its filename is
     swiotlb-fix-wrong-panic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: swiotlb: fix wrong panic
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

swiotlb's map_page wrongly calls panic() when it can't find a buffer fit
for device's dma mask.  It should return an error instead.

Devices with an odd dma mask (i.e.  under 4G) like b44 network card hit
this bug (the system crashes):

http://marc.info/?l=linux-kernel&m=129648943830106&w=2

If swiotlb returns an error, b44 driver can use the own bouncing
mechanism.

Reported-by: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Tested-by: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/swiotlb.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN lib/swiotlb.c~swiotlb-fix-wrong-panic lib/swiotlb.c
--- a/lib/swiotlb.c~swiotlb-fix-wrong-panic
+++ a/lib/swiotlb.c
@@ -686,8 +686,10 @@ dma_addr_t swiotlb_map_page(struct devic
 	/*
 	 * Ensure that the address returned is DMA'ble
 	 */
-	if (!dma_capable(dev, dev_addr, size))
-		panic("map_single: bounce buffer is not DMA'ble");
+	if (!dma_capable(dev, dev_addr, size)) {
+		swiotlb_tbl_unmap_single(dev, map, size, dir);
+		dev_addr = swiotlb_virt_to_bus(dev, io_tlb_overflow_buffer);
+	}
 
 	return dev_addr;
 }
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

linux-next.patch
swiotlb-fix-wrong-panic.patch
add-the-common-dma_addr_t-typedef-to-include-linux-typesh.patch
remove-dma64_addr_t.patch

