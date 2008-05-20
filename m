From: akpm@linux-foundation.org
Subject: + mtd-m25p80-fix-bug-atmel-spi-flash-fails-to-be-copied-to-fix-up.patch added to -mm tree
Date: Tue, 20 May 2008 01:43:58 -0700
Message-ID: <200805200843.m4K8hwmi013806@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46222 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756799AbYETItQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 04:49:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael.hennerich@analog.com, cooloney@kernel.org, dwmw2@infradead.org


The patch titled
     mtd m25p80: fix bug - ATmel spi flash fails to be copied to - fix up
has been added to the -mm tree.  Its filename is
     mtd-m25p80-fix-bug-atmel-spi-flash-fails-to-be-copied-to-fix-up.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd m25p80: fix bug - ATmel spi flash fails to be copied to - fix up
From: Michael Hennerich <michael.hennerich@analog.com>

remove duplicate code.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/devices/m25p80.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/mtd/devices/m25p80.c~mtd-m25p80-fix-bug-atmel-spi-flash-fails-to-be-copied-to-fix-up drivers/mtd/devices/m25p80.c
--- a/drivers/mtd/devices/m25p80.c~mtd-m25p80-fix-bug-atmel-spi-flash-fails-to-be-copied-to-fix-up
+++ a/drivers/mtd/devices/m25p80.c
@@ -122,8 +122,6 @@ static int write_sr(struct m25p *flash, 
 	flash->command[0] = OPCODE_WRSR;
 	flash->command[1] = val;
 
-	spi_write(flash->spi, flash->command, 2);
