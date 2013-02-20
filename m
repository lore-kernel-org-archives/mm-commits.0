From: akpm@linux-foundation.org
Subject: [to-be-updated] drivers-scsi-aacraid-srcc-silence-two-gcc-warnings.patch removed from -mm tree
Date: Wed, 20 Feb 2013 13:54:27 -0800
Message-ID: <20130220215427.E125031C194@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:56483 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab3BTVy3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Feb 2013 16:54:29 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so850401vcd.1
        for <mm-commits@vger.kernel.org>; Wed, 20 Feb 2013 13:54:28 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pebolle@tiscali.nl, James.Bottomley@HansenPartnership.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/scsi/aacraid/src.c: silence two GCC warnings
has been removed from the -mm tree.  Its filename was
     drivers-scsi-aacraid-srcc-silence-two-gcc-warnings.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Paul Bolle <pebolle@tiscali.nl>
Subject: drivers/scsi/aacraid/src.c: silence two GCC warnings

Compiling src.o for a 32 bit system triggers two GCC warnings:
    drivers/scsi/aacraid/src.c: In function `aac_src_deliver_message':
    drivers/scsi/aacraid/src.c:410:3: warning: right shift count >= width of type [enabled by default]
    drivers/scsi/aacraid/src.c:434:2: warning: right shift count >= width of type [enabled by default]

Silence these warnings by casting the 'address' variable (of type
dma_addr_t) to u64 on those two lines.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aacraid/src.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/aacraid/src.c~drivers-scsi-aacraid-srcc-silence-two-gcc-warnings drivers/scsi/aacraid/src.c
--- a/drivers/scsi/aacraid/src.c~drivers-scsi-aacraid-srcc-silence-two-gcc-warnings
+++ a/drivers/scsi/aacraid/src.c
@@ -407,7 +407,7 @@ static int aac_src_deliver_message(struc
 		fib->hw_fib_va->header.StructType = FIB_MAGIC2;
 		fib->hw_fib_va->header.SenderFibAddress = (u32)address;
 		fib->hw_fib_va->header.u.TimeStamp = 0;
-		BUG_ON((u32)(address >> 32) != 0L);
+		BUG_ON(((u64)address >> 32) != 0UL);
 		address |= fibsize;
 	} else {
 		/* Calculate the amount to the fibsize bits */
@@ -431,7 +431,7 @@ static int aac_src_deliver_message(struc
 		address |= fibsize;
 	}
 
-	src_writel(dev, MUnit.IQ_H, (address >> 32) & 0xffffffff);
+	src_writel(dev, MUnit.IQ_H, ((u64)address >> 32) & 0xffffffff);
 	src_writel(dev, MUnit.IQ_L, address & 0xffffffff);
 
 	return 0;
_

Patches currently in -mm which might be from pebolle@tiscali.nl are

linux-next.patch

