From: akpm@linux-foundation.org
Subject: + mmc-atmel-host-kconfig-cleanup-for-everyone-else.patch added to -mm tree
Date: Tue, 12 Jan 2010 15:44:40 -0800
Message-ID: <201001122344.o0CNieGX002586__16481.4510768794$1263339917$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51053 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754054Ab0ALXpF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jan 2010 18:45:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nicolas.ferre@atmel.com, jic23@cam.ac.uk, linux-mmc@vger.kernel.org


The patch titled
     mmc: Atmel host kconfig cleanup for everyone else
has been added to the -mm tree.  Its filename is
     mmc-atmel-host-kconfig-cleanup-for-everyone-else.patch

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
Subject: mmc: Atmel host kconfig cleanup for everyone else
From: Nicolas Ferre <nicolas.ferre@atmel.com>

This prevents those without an Atmel chip having a line in kernel
configuration which says "Atmel SD/MMC Driver" without any option.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/mmc/host/Kconfig~mmc-atmel-host-kconfig-cleanup-for-everyone-else drivers/mmc/host/Kconfig
--- a/drivers/mmc/host/Kconfig~mmc-atmel-host-kconfig-cleanup-for-everyone-else
+++ a/drivers/mmc/host/Kconfig
@@ -189,6 +189,7 @@ config MMC_AU1X
 
 choice
 	prompt "Atmel SD/MMC Driver"
+	depends on AVR32 || ARCH_AT91
 	default MMC_ATMELMCI if AVR32
 	help
 	  Choose which driver to use for the Atmel MCI Silicon
_

Patches currently in -mm which might be from nicolas.ferre@atmel.com are

mmc-atmel-host-kconfig-cleanup-for-everyone-else.patch

