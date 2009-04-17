From: akpm@linux-foundation.org
Subject: + spi_bfin5xx-limit-reaches-1.patch added to -mm tree
Date: Fri, 17 Apr 2009 11:40:52 -0700
Message-ID: <200904171840.n3HIeqmN032193@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47273 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758781AbZDQSyv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Apr 2009 14:54:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, cooloney@kernel.org, dbrownell@users.sourceforge.net


The patch titled
     spi_bfin5xx: limit reaches -1
has been added to the -mm tree.  Its filename is
     spi_bfin5xx-limit-reaches-1.patch

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
Subject: spi_bfin5xx: limit reaches -1
From: Roel Kluin <roel.kluin@gmail.com>

bfin_spi_flush() returns limit, which reaches -1 upon timeout.  but in
function bfin_spi_pump_transfers() it is compared with 0.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/spi/spi_bfin5xx.c~spi_bfin5xx-limit-reaches-1 drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~spi_bfin5xx-limit-reaches-1
+++ a/drivers/spi/spi_bfin5xx.c
@@ -169,7 +169,7 @@ static int bfin_spi_flush(struct driver_
 	unsigned long limit = loops_per_jiffy << 1;
 
 	/* wait for stop and clear stat */
-	while (!(read_STAT(drv_data) & BIT_STAT_SPIF) && limit--)
+	while (!(read_STAT(drv_data) & BIT_STAT_SPIF) && --limit)
 		cpu_relax();
 
 	write_STAT(drv_data, BIT_STAT_CLR);
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
spi_bfin5xx-limit-reaches-1.patch
ufs-sector_t-cannot-be-negative.patch

