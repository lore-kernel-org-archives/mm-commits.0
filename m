From: akpm@linux-foundation.org
Subject: + sdhci-s3c-fix-null-ptr-access-in-sdhci_s3c_remove.patch added to -mm tree
Date: Thu, 23 Sep 2010 12:08:10 -0700
Message-ID: <201009231908.o8NJ8A4u013067@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34207 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754855Ab0IWTI5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Sep 2010 15:08:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.szyprowski@samsung.com, ben-linux@fluff.org, cjb@laptop.org, kyungmin.park@samsung.com


The patch titled
     sdhci-s3c: fix NULL ptr access in sdhci_s3c_remove
has been added to the -mm tree.  Its filename is
     sdhci-s3c-fix-null-ptr-access-in-sdhci_s3c_remove.patch

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
Subject: sdhci-s3c: fix NULL ptr access in sdhci_s3c_remove
From: Marek Szyprowski <m.szyprowski@samsung.com>

If not all clocks has been defined in platform data, driver will cause a
null pointer dereference when it is being removed.  This patch fixes this
issue.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Chris Ball <cjb@laptop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci-s3c.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/mmc/host/sdhci-s3c.c~sdhci-s3c-fix-null-ptr-access-in-sdhci_s3c_remove drivers/mmc/host/sdhci-s3c.c
--- a/drivers/mmc/host/sdhci-s3c.c~sdhci-s3c-fix-null-ptr-access-in-sdhci_s3c_remove
+++ a/drivers/mmc/host/sdhci-s3c.c
@@ -483,8 +483,10 @@ static int __devexit sdhci_s3c_remove(st
 	sdhci_remove_host(host, 1);
 
 	for (ptr = 0; ptr < 3; ptr++) {
-		clk_disable(sc->clk_bus[ptr]);
-		clk_put(sc->clk_bus[ptr]);
+		if (sc->clk_bus[ptr]) {
+			clk_disable(sc->clk_bus[ptr]);
+			clk_put(sc->clk_bus[ptr]);
+		}
 	}
 	clk_disable(sc->clk_io);
 	clk_put(sc->clk_io);
_

Patches currently in -mm which might be from m.szyprowski@samsung.com are

linux-next.patch
sdhci-s3c-fix-null-ptr-access-in-sdhci_s3c_remove.patch

