From: akpm@linux-foundation.org
Subject: + usb-musb-dsps-fix-build-on-i386-when-compile_test-is-set.patch
 added to -mm tree
Date: Mon, 06 Apr 2015 15:35:56 -0700
Message-ID: <55230a4c.qgmdhytXXVNrnR01%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42196 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbbDFWf5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2015 18:35:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tony@atomide.com, balbi@ti.com, gregkh@linuxfoundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: usb: musb: dsps: fix build on i386 when COMPILE_TEST is set
has been added to the -mm tree.  Its filename is
     usb-musb-dsps-fix-build-on-i386-when-compile_test-is-set.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/usb-musb-dsps-fix-build-on-i386-when-compile_test-is-set.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/usb-musb-dsps-fix-build-on-i386-when-compile_test-is-set.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
usb-musb-dsps-fix-build-on-i386-when-compile_test-is-set.patch

