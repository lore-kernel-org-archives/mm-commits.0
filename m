From: akpm@linux-foundation.org
Subject: [merged]
 usb-musb-dsps-fix-build-on-i386-when-compile_test-is-set.patch removed from -mm tree
Date: Tue, 07 Apr 2015 15:50:52 -0700
Message-ID: <55245f4c.poHwayjTrPuR0zSo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39581 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220AbbDGWux (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2015 18:50:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tony@atomide.com, balbi@ti.com, gregkh@linuxfoundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: usb: musb: dsps: fix build on i386 when COMPILE_TEST is set
has been removed from the -mm tree.  Its filename was
     usb-musb-dsps-fix-build-on-i386-when-compile_test-is-set.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tony Lindgren <tony@atomide.com>
Subject: usb: musb: dsps: fix build on i386 when COMPILE_TEST is set

Commit 3e457371f436 ("usb: musb: Fix fifo reads for dm816x with musb_dsps")
fixed a USB error on dm816x, but introduced a new build error on i386
when COMPILE_TEST is set:

drivers/usb/musb/musb_dsps.c: In function `dsps_read_fifo32':
drivers/usb/musb/musb_dsps.c:624:3: error: implicit declaration of function
`readsl' [-Werror=implicit-function-declaration]
readsl(fifo, dst, len >> 2);

Let's fix this by using ioread32_rep() instead of readsl() as that's
more portable.

Signed-off-by: Tony Lindgren <tony@atomide.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/musb/musb_dsps.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/musb/musb_dsps.c~usb-musb-dsps-fix-build-on-i386-when-compile_test-is-set drivers/usb/musb/musb_dsps.c
--- a/drivers/usb/musb/musb_dsps.c~usb-musb-dsps-fix-build-on-i386-when-compile_test-is-set
+++ a/drivers/usb/musb/musb_dsps.c
@@ -621,7 +621,7 @@ static void dsps_read_fifo32(struct musb
 	void __iomem *fifo = hw_ep->fifo;
 
 	if (len >= 4) {
-		readsl(fifo, dst, len >> 2);
+		ioread32_rep(fifo, dst, len >> 2);
 		dst += len & ~0x03;
 		len &= 0x03;
 	}
_

Patches currently in -mm which might be from tony@atomide.com are

linux-next.patch

