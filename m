From: akpm@linux-foundation.org
Subject: + mtd-fix-orion-nand-driver-compilation-with-arm-oabi.patch added to -mm tree
Date: Fri, 23 Apr 2010 11:01:17 -0700
Message-ID: <201004231801.o3NI1IUA003410@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38460 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758577Ab0DWSBy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 Apr 2010 14:01:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulius.zaleckas@gmail.com, dedekind1@gmail.com, dwmw2@infradead.org, jamie@shareable.org, nico@fluxnic.net


The patch titled
     mtd: fix Orion NAND driver compilation with ARM OABI
has been added to the -mm tree.  Its filename is
     mtd-fix-orion-nand-driver-compilation-with-arm-oabi.patch

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
Subject: mtd: fix Orion NAND driver compilation with ARM OABI
From: Paulius Zaleckas <paulius.zaleckas@gmail.com>

We must tell GCC to use even register for variable passed to ldrd
instruction.  Without this patch GCC 4.2.1 puts this variable to r2/r3 on
EABI and r3/r4 on OABI, so force it to r2/r3.  This does not change
anything when EABI and OABI compilation works OK.

Without this patch and with OABI I get:
  CC      drivers/mtd/nand/orion_nand.o
/tmp/ccMkwOCs.s: Assembler messages:
/tmp/ccMkwOCs.s:63: Error: first destination register must be even -- `ldrd r3,[ip]'
make[5]: *** [drivers/mtd/nand/orion_nand.o] Error 1

Signed-off-by: Paulius Zaleckas <paulius.zaleckas@gmail.com>
Acked-by: Nicolas Pitre <nico@fluxnic.net>
Acked-by: Artem Bityutskiy <dedekind1@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Jamie Lokier <jamie@shareable.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/orion_nand.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/mtd/nand/orion_nand.c~mtd-fix-orion-nand-driver-compilation-with-arm-oabi drivers/mtd/nand/orion_nand.c
--- a/drivers/mtd/nand/orion_nand.c~mtd-fix-orion-nand-driver-compilation-with-arm-oabi
+++ a/drivers/mtd/nand/orion_nand.c
@@ -60,7 +60,13 @@ static void orion_nand_read_buf(struct m
 	}
 	buf64 = (uint64_t *)buf;
 	while (i < len/8) {
-		uint64_t x;
+		/*
+		 * Since GCC has no proper constraint (PR 43518)
+		 * force x variable to r2/r3 registers as ldrd instruction
+		 * requires first register to be even.
+		 */
+		register uint64_t x asm ("r2");
+
 		asm volatile ("ldrd\t%0, [%1]" : "=&r" (x) : "r" (io_base));
 		buf64[i++] = x;
 	}
_

Patches currently in -mm which might be from paulius.zaleckas@gmail.com are

mtd-fix-orion-nand-driver-compilation-with-arm-oabi.patch
linux-next.patch

