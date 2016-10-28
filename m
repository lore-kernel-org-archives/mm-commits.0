From: akpm@linux-foundation.org
Subject: [patch 19/20] cris/arch-v32: cryptocop: print a hex number after
 a 0x prefix
Date: Thu, 27 Oct 2016 17:47:10 -0700
Message-ID: <5812a00e.zZOroPJY0AIb7tM0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57992 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S943135AbcJ1ArL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2016 20:47:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, u.kleine-koenig@pengutronix.de, jesper.nilsson@axis.com, starvik@axis.com

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Subject: cris/arch-v32: cryptocop: print a hex number after a 0x prefix

It makes the result hard to interpret correctly if a base 10 number is
prefixed by 0x. So change to a hex number.

Link: http://lkml.kernel.org/r/20161026125658.25728-6-u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v32/drivers/cryptocop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/cris/arch-v32/drivers/cryptocop.c~cris-arch-v32-cryptocop-print-a-hex-number-after-a-0x-prefix arch/cris/arch-v32/drivers/cryptocop.c
--- a/arch/cris/arch-v32/drivers/cryptocop.c~cris-arch-v32-cryptocop-print-a-hex-number-after-a-0x-prefix
+++ a/arch/cris/arch-v32/drivers/cryptocop.c
@@ -3149,7 +3149,7 @@ static void print_dma_descriptors(struct
 	printk("print_dma_descriptors start\n");
 
 	printk("iop:\n");
-	printk("\tsid: 0x%lld\n", iop->sid);
+	printk("\tsid: 0x%llx\n", iop->sid);
 
 	printk("\tcdesc_out: 0x%p\n", iop->cdesc_out);
 	printk("\tcdesc_in: 0x%p\n", iop->cdesc_in);
_
