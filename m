From: akpm@linux-foundation.org
Subject: + spi_mpc83xx-add-small-delay-after-asserting-chip-select-line.patch added to -mm tree
Date: Mon, 04 May 2009 13:56:13 -0700
Message-ID: <200905042056.n44KuDLt016771@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48885 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754656AbZEDVCD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2009 17:02:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, benh@kernel.crashing.org, david-b@pacbell.net, galak@gate.crashing.org


The patch titled
     spi_mpc83xx: add small delay after asserting chip-select line
has been added to the -mm tree.  Its filename is
     spi_mpc83xx-add-small-delay-after-asserting-chip-select-line.patch

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
Subject: spi_mpc83xx: add small delay after asserting chip-select line
From: Anton Vorontsov <avorontsov@ru.mvista.com>

This is needed for some underlaying GPIO controllers that may be a bit
slow, or if chip-select signal need some time to stabilize.

For what it's worth, we already have the similar delay for chip-select
de-assertion case.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: David Brownell <david-b@pacbell.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_mpc83xx.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/spi/spi_mpc83xx.c~spi_mpc83xx-add-small-delay-after-asserting-chip-select-line drivers/spi/spi_mpc83xx.c
--- a/drivers/spi/spi_mpc83xx.c~spi_mpc83xx-add-small-delay-after-asserting-chip-select-line
+++ a/drivers/spi/spi_mpc83xx.c
@@ -383,8 +383,10 @@ static void mpc83xx_spi_work(struct work
 					break;
 			}
 
-			if (cs_change)
+			if (cs_change) {
 				mpc83xx_spi_chipselect(spi, BITBANG_CS_ACTIVE);
+				ndelay(nsecs);
+			}
 			cs_change = t->cs_change;
 			if (t->len)
 				status = mpc83xx_spi_bufs(spi, t);
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

linux-next.patch
mpc52xx_psc_spi-convert-to-cs_control-callback.patch
spi_mpc83xx-handle-other-freescale-processors.patch
spi_mpc83xx-quieten-down-the-requested-speed-is-too-low-message.patch
spi_mpc83xx-add-small-delay-after-asserting-chip-select-line.patch
powerpc-86xx-add-mmc-spi-support-for-mpc8610hpcd-boards.patch
spi_mpc83xx-fix-checkpatch-issues.patch
spi_mpc83xx-split-mpc83xx_spi_work-into-two-routines.patch
spi_mpc83xx-remove-dead-code.patch
spi_mpc83xx-rename-spi_83xxc-to-spi_8xxxc.patch
spi_mpc8xxx-s-83xx-8xxx-g.patch

