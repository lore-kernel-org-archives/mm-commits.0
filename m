From: akpm@linux-foundation.org
Subject: [merged]
 rapidio-tsi721-fix-incorrect-detection-of-address-translation-condition.patch removed from -mm tree
Date: Fri, 02 Sep 2016 12:01:21 -0700
Message-ID: <57c9cc81.DMd2klk0fFmooIxa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33028 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755130AbcIBTBW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Sep 2016 15:01:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, andre.van.herk@prodrive-technologies.com, barry.wood@idt.com, mporter@kernel.crashing.org, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/tsi721: fix incorrect detection of address translation condition
has been removed from the -mm tree.  Its filename was
     rapidio-tsi721-fix-incorrect-detection-of-address-translation-condition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from alexandre.bounine@idt.com are

rapidio-rio_cm-use-memdup_user-instead-of-duplicating-code.patch

