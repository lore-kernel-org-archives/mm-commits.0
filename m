From: akpm@linux-foundation.org
Subject: + mmc_spih-should-include-linux-interruptsh.patch added to -mm tree
Date: Tue, 27 May 2008 12:45:02 -0700
Message-ID: <200805271945.m4RJj2FC009850@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44566 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755264AbYE0TuX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 15:50:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, dbrownell@users.sourceforge.net, drzeus-mmc@drzeus.cx


The patch titled
     spi: mmc_spi.h should include linux/interrupts.h
has been added to the -mm tree.  Its filename is
     mmc_spih-should-include-linux-interruptsh.patch

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
Subject: spi: mmc_spi.h should include linux/interrupts.h
From: Anton Vorontsov <avorontsov@ru.mvista.com>

Since mmc_spi.h uses irqreturn_t type, it should include appropriate
header, otherwise build will break if users didn't include it (some of
them do not use interrupts).

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/spi/mmc_spi.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/spi/mmc_spi.h~mmc_spih-should-include-linux-interruptsh include/linux/spi/mmc_spi.h
--- a/include/linux/spi/mmc_spi.h~mmc_spih-should-include-linux-interruptsh
+++ a/include/linux/spi/mmc_spi.h
@@ -1,6 +1,8 @@
 #ifndef __LINUX_SPI_MMC_SPI_H
 #define __LINUX_SPI_MMC_SPI_H
 
+#include <linux/interrupt.h>
+
 struct device;
 struct mmc_host;
 
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

mmc_spih-should-include-linux-interruptsh.patch
linux-next.patch

