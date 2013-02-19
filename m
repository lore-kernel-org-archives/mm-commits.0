From: akpm@linux-foundation.org
Subject: + drivers-scsi-aacraid-srcc-silence-two-gcc-warnings.patch added to -mm tree
Date: Tue, 19 Feb 2013 15:31:03 -0800
Message-ID: <20130219233103.9314331C03C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:65275 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933654Ab3BSXbF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Feb 2013 18:31:05 -0500
Received: by mail-qc0-f202.google.com with SMTP id k26so723091qcs.1
        for <mm-commits@vger.kernel.org>; Tue, 19 Feb 2013 15:31:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pebolle@tiscali.nl, James.Bottomley@HansenPartnership.com


The patch titled
     Subject: drivers/scsi/aacraid/src.c: silence two GCC warnings
has been added to the -mm tree.  Its filename is
     drivers-scsi-aacraid-srcc-silence-two-gcc-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
drivers-scsi-aacraid-srcc-silence-two-gcc-warnings.patch

