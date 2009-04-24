From: akpm@linux-foundation.org
Subject: [merged] microblaze-iowrite-upon-timeout.patch removed from -mm tree
Date: Fri, 24 Apr 2009 12:27:54 -0700
Message-ID: <200904241927.n3OJRsnC015970@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51002 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752109AbZDXT3l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Apr 2009 15:29:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, monstr@monstr.eu, mm-commits@vger.kernel.org


The patch titled
     microblaze: iowrite upon timeout
has been removed from the -mm tree.  Its filename was
     microblaze-iowrite-upon-timeout.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: microblaze: iowrite upon timeout
From: Roel Kluin <roel.kluin@gmail.com>

retries reaches -1, so the iowrite occurrs upon timeout.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Michal Simek <monstr@monstr.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/kernel/early_printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/microblaze/kernel/early_printk.c~microblaze-iowrite-upon-timeout arch/microblaze/kernel/early_printk.c
--- a/arch/microblaze/kernel/early_printk.c~microblaze-iowrite-upon-timeout
+++ a/arch/microblaze/kernel/early_printk.c
@@ -36,7 +36,7 @@ static void early_printk_putc(char c)
 
 	unsigned retries = 10000;
 	/* read status bit - 0x8 offset */
-	while (retries-- && (in_be32(base_addr + 8) & (1 << 3)))
+	while (--retries && (in_be32(base_addr + 8) & (1 << 3)))
 		;
 
 	/* Only attempt the iowrite if we didn't timeout */
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
i2c-pxac-timeouts-off-by-1.patch
drm-fix-lock_test_with_return-macro.patch
pata-rb532-cf-platform_get_irq-failure-ignored.patch
uwb-event_size-should-be-signed.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
serial-z85c30-bcm1480-loops-reach-1.patch
spi_bfin5xx-limit-reaches-1.patch
ufs-sector_t-cannot-be-negative.patch

