From: akpm@linux-foundation.org
Subject: + adx_wdtc-use-resource_size.patch added to -mm tree
Date: Tue, 08 Dec 2009 14:13:33 -0800
Message-ID: <200912082213.nB8MDX77018714@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42510 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966698AbZLHWNn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2009 17:13:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hartleys@visionengravers.com, hsweeten@visionengravers.com, thierry.reding@avionic-design.de, wim@iguana.be


The patch titled
     adx_wdt.c: use resource_size()
has been added to the -mm tree.  Its filename is
     adx_wdtc-use-resource_size.patch

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
Subject: adx_wdt.c: use resource_size()
From: "H Hartley Sweeten" <hartleys@visionengravers.com>

Use resource_size().

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Acked-by: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/adx_wdt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/watchdog/adx_wdt.c~adx_wdtc-use-resource_size drivers/watchdog/adx_wdt.c
--- a/drivers/watchdog/adx_wdt.c~adx_wdtc-use-resource_size
+++ a/drivers/watchdog/adx_wdt.c
@@ -242,14 +242,14 @@ static int __devinit adx_wdt_probe(struc
 	}
 
 	res = devm_request_mem_region(&pdev->dev, res->start,
-			res->end - res->start + 1, res->name);
+			resource_size(res), res->name);
 	if (!res) {
 		dev_err(&pdev->dev, "cannot request I/O memory region\n");
 		return -ENXIO;
 	}
 
 	wdt->base = devm_ioremap_nocache(&pdev->dev, res->start,
-			res->end - res->start + 1);
+			resource_size(res));
 	if (!wdt->base) {
 		dev_err(&pdev->dev, "cannot remap I/O memory region\n");
 		return -ENXIO;
_

Patches currently in -mm which might be from hartleys@visionengravers.com are

origin.patch
linux-next.patch
drivers-block-mg_diskc-use-resource_size.patch
adx_wdtc-use-resource_size.patch
security-min_addrc-make-init_mmap_min_addr-static.patch
drivers-misc-add-driver-for-texas-instruments-dac7512.patch
drivers-misc-add-driver-for-texas-instruments-dac7512-update.patch
init-mainc-fix-symbol-shadows-noise.patch
kernel-sysc-fix-warning-do-while-statement-is-not-a-compound-statement-noise.patch

