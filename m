From: akpm@linux-foundation.org
Subject: + spi-pxa2xx-limit-reaches-1.patch added to -mm tree
Date: Fri, 17 Apr 2009 11:40:10 -0700
Message-ID: <200904171840.n3HIeAlu031812@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35330 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754409AbZDQSnS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Apr 2009 14:43:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, david-b@pacbell.net, eric.miao@marvell.com, rmk@arm.linux.org.uk


The patch titled
     spi: pxa2xx: limit reaches -1
has been added to the -mm tree.  Its filename is
     spi-pxa2xx-limit-reaches-1.patch

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
Subject: spi: pxa2xx: limit reaches -1
From: Roel Kluin <roel.kluin@gmail.com>

On line 944 the return value of flush() is considered as a boolean,
but limit reaches -1 upon timeout which evaluates to true.

On 540, 594, 720 the same occurs for wait_ssp_rx_stall()
On 536 the same occurs for wait_dma_channel_stop()

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Eric Miao <eric.miao@marvell.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/pxa2xx_spi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/spi/pxa2xx_spi.c~spi-pxa2xx-limit-reaches-1 drivers/spi/pxa2xx_spi.c
--- a/drivers/spi/pxa2xx_spi.c~spi-pxa2xx-limit-reaches-1
+++ a/drivers/spi/pxa2xx_spi.c
@@ -213,7 +213,7 @@ static int flush(struct driver_data *drv
 		while (read_SSSR(reg) & SSSR_RNE) {
 			read_SSDR(reg);
 		}
-	} while ((read_SSSR(reg) & SSSR_BSY) && limit--);
+	} while ((read_SSSR(reg) & SSSR_BSY) && --limit);
 	write_SSSR(SSSR_ROR, reg);
 
 	return limit;
@@ -484,7 +484,7 @@ static int wait_ssp_rx_stall(void const 
 {
 	unsigned long limit = loops_per_jiffy << 1;
 
-	while ((read_SSSR(ioaddr) & SSSR_BSY) && limit--)
+	while ((read_SSSR(ioaddr) & SSSR_BSY) && --limit)
 		cpu_relax();
 
 	return limit;
@@ -494,7 +494,7 @@ static int wait_dma_channel_stop(int cha
 {
 	unsigned long limit = loops_per_jiffy << 1;
 
-	while (!(DCSR(channel) & DCSR_STOPSTATE) && limit--)
+	while (!(DCSR(channel) & DCSR_STOPSTATE) && --limit)
 		cpu_relax();
 
 	return limit;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
drm-fix-lock_test_with_return-macro.patch
drm-count-reaches-1.patch
pata-rb532-cf-platform_get_irq-failure-ignored.patch
microblaze-iowrite-upon-timeout.patch
uwb-event_size-should-be-signed.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
bfin_5xx-misplaced-parentheses.patch
serial-z85c30-bcm1480-loops-reach-1.patch
spi-pxa2xx-limit-reaches-1.patch
ufs-sector_t-cannot-be-negative.patch

