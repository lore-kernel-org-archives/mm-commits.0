From: akpm@linux-foundation.org
Subject: [patch 14/14] rapidio/tsi721: fix incorrect detection of address
 translation condition
Date: Thu, 01 Sep 2016 16:15:18 -0700
Message-ID: <57c8b686.TLPBhp53zZmepZ6f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59899 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751211AbcIAXPU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Sep 2016 19:15:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, alexandre.bounine@idt.com, andre.van.herk@prodrive-technologies.com, barry.wood@idt.com, mporter@kernel.crashing.org, stable@vger.kernel.org

From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio/tsi721: fix incorrect detection of address translation condition

Fix incorrect condition to identify involvment of a address translation
mechanism.

This bug results in NULL pointer kernel crash dump in cases when mapping
of inbound RapidIO address range is requested within existing aprture.

Link: http://lkml.kernel.org/r/20160901173144.2983-1-alexandre.bounine@idt.com
Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Cc: Barry Wood <barry.wood@idt.com>
Cc: <stable@vger.kernel.org>	[4.6+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/tsi721.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rapidio/devices/tsi721.c~rapidio-tsi721-fix-incorrect-detection-of-address-translation-condition drivers/rapidio/devices/tsi721.c
--- a/drivers/rapidio/devices/tsi721.c~rapidio-tsi721-fix-incorrect-detection-of-address-translation-condition
+++ a/drivers/rapidio/devices/tsi721.c
@@ -1161,7 +1161,7 @@ static int tsi721_rio_map_inb_mem(struct
 		} else if (ibw_start < (ib_win->rstart + ib_win->size) &&
 			   (ibw_start + ibw_size) > ib_win->rstart) {
 			/* Return error if address translation involved */
-			if (direct && ib_win->xlat) {
+			if (!direct || ib_win->xlat) {
 				ret = -EFAULT;
 				break;
 			}
_
