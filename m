From: akpm@linux-foundation.org
Subject: + microblaze-iowrite-upon-timeout.patch added to -mm tree
Date: Thu, 16 Apr 2009 14:12:40 -0700
Message-ID: <200904162112.n3GLCe9X020379@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40845 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752888AbZDPVOO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Apr 2009 17:14:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, monstr@monstr.eu


The patch titled
     microblaze: iowrite upon timeout
has been added to the -mm tree.  Its filename is
     microblaze-iowrite-upon-timeout.patch

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

linux-next.patch
drm-fix-lock_test_with_return-macro.patch
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
ufs-sector_t-cannot-be-negative.patch

