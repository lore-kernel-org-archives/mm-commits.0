From: akpm@linux-foundation.org
Subject: +
 drivers-firmware-broadcom-bcm47xx_nvramc-fix-incorrect-__ioread32_copy.patch added to -mm tree
Date: Thu, 17 Mar 2016 12:10:08 -0700
Message-ID: <56eb0110.2ycIF1iUktCPFiyb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40523 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030695AbcCQTKJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Mar 2016 15:10:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aaro.koskinen@iki.fi, hauke@hauke-m.de, sboyd@codeaurora.org, stable@vger.kernel.org, zajec5@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/firmware/broadcom/bcm47xx_nvram.c: fix incorrect __ioread32_copy
has been added to the -mm tree.  Its filename is
     drivers-firmware-broadcom-bcm47xx_nvramc-fix-incorrect-__ioread32_copy.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-firmware-broadcom-bcm47xx_nvramc-fix-incorrect-__ioread32_copy.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-firmware-broadcom-bcm47xx_nvramc-fix-incorrect-__ioread32_copy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: drivers/firmware/broadcom/bcm47xx_nvram.c: fix incorrect __ioread32_copy

Commit 1f330c327900 ("drivers/firmware/broadcom/bcm47xx_nvram.c: use
__ioread32_copy() instead of open-coding") switched to use a generic copy
function, but failed to notice that the header pointer is updated between
the two copies, resulting in bogus data being copied in the latter one. 
Fix by keeping the old header pointer.

The patch fixes totally broken networking on WRT54GL router (both LAN and
WLAN interfaces fail to probe).

Fixes: 1f330c327900 ("drivers/firmware/broadcom/bcm47xx_nvram.c: use __ioread32_copy() instead of open-coding")
Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Rafal Milecki <zajec5@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Cc: <stable@vger.kernel.org>	[4.4.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/broadcom/bcm47xx_nvram.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/firmware/broadcom/bcm47xx_nvram.c~drivers-firmware-broadcom-bcm47xx_nvramc-fix-incorrect-__ioread32_copy drivers/firmware/broadcom/bcm47xx_nvram.c
--- a/drivers/firmware/broadcom/bcm47xx_nvram.c~drivers-firmware-broadcom-bcm47xx_nvramc-fix-incorrect-__ioread32_copy
+++ a/drivers/firmware/broadcom/bcm47xx_nvram.c
@@ -94,15 +94,14 @@ static int nvram_find_and_copy(void __io
 
 found:
 	__ioread32_copy(nvram_buf, header, sizeof(*header) / 4);
-	header = (struct nvram_header *)nvram_buf;
-	nvram_len = header->len;
+	nvram_len = ((struct nvram_header *)(nvram_buf))->len;
 	if (nvram_len > size) {
 		pr_err("The nvram size according to the header seems to be bigger than the partition on flash\n");
 		nvram_len = size;
 	}
 	if (nvram_len >= NVRAM_SPACE) {
 		pr_err("nvram on flash (%i bytes) is bigger than the reserved space in memory, will just copy the first %i bytes\n",
-		       header->len, NVRAM_SPACE - 1);
+		       nvram_len, NVRAM_SPACE - 1);
 		nvram_len = NVRAM_SPACE - 1;
 	}
 	/* proceed reading data after header */
_

Patches currently in -mm which might be from aaro.koskinen@iki.fi are

drivers-firmware-broadcom-bcm47xx_nvramc-fix-incorrect-__ioread32_copy.patch

