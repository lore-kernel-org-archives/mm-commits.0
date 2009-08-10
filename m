From: akpm@linux-foundation.org
Subject: [merged] drivers-mmc-correct-error-handling-code.patch removed from -mm tree
Date: Mon, 10 Aug 2009 12:27:36 -0700
Message-ID: <200908101927.n7AJRali026196@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36513 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752553AbZHJT26 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Aug 2009 15:28:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, avorontsov@ru.mvista.com, ian@mnementh.co.uk, matt@console-pimps.org, philipl@overt.org, pierre@ossman.eu, roberto.foglietta@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers/mmc: correct error-handling code
has been removed from the -mm tree.  Its filename was
     drivers-mmc-correct-error-handling-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/mmc: correct error-handling code
From: Julia Lawall <julia@diku.dk>

sdhci_alloc_host returns an ERR_PTR value in an error case instead of NULL.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@match exists@
expression x, E;
statement S1, S2;
@@

x = sdhci_alloc_host(...)
... when != x = E
(
*  if (x == NULL || ...) S1 else S2
|
*  if (x == NULL && ...) S1 else S2
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Acked-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: "Roberto A. Foglietta" <roberto.foglietta@gmail.com>
Cc: Philip Langdale <philipl@overt.org>
Cc: Pierre Ossman <pierre@ossman.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci-of.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mmc/host/sdhci-of.c~drivers-mmc-correct-error-handling-code drivers/mmc/host/sdhci-of.c
--- a/drivers/mmc/host/sdhci-of.c~drivers-mmc-correct-error-handling-code
+++ a/drivers/mmc/host/sdhci-of.c
@@ -234,7 +234,7 @@ static int __devinit sdhci_of_probe(stru
 		return -ENODEV;
 
 	host = sdhci_alloc_host(&ofdev->dev, sizeof(*of_host));
-	if (!host)
+	if (IS_ERR(host))
 		return -ENOMEM;
 
 	of_host = sdhci_priv(host);
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
drivers-media-dvb-use-dst_type-field-instead-of-type_flags.patch
drivers-media-video-gspca-introduce-missing-kfree.patch
drivers-ata-use-resource_size.patch
drivers-ata-introduce-missing-kfree.patch
drivers-md-introduce-missing-kfree.patch
drivers-rtc-correct-error-handling-code.patch
drivers-rtc-introduce-missing-kfree.patch
drivers-video-imxfbc-fix-resource-size-off-by-1-error.patch
drivers-video-add-kmalloc-null-tests.patch
drivers-video-add-kmalloc-null-tests-fix.patch
edac-fix-resource-size-calculation.patch
fs-romfs-correct-error-handling-code.patch
drivers-vlynq-vlynqc-fix-resource-size-off-by-1-error.patch

