From: akpm@linux-foundation.org
Subject: [merged] drivers-of-fdtc-re-use-kernels-kbasename.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:06:14 -0800
Message-ID: <20121218200615.2FC5C200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:50490 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754994Ab2LRUGR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:06:17 -0500
Received: by mail-bk0-f74.google.com with SMTP id je9so63286bkc.3
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:06:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, fabio.estevam@freescale.com, grant.likely@secretlab.ca, rob.herring@calxeda.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/of/fdt.c: re-use kernel's kbasename()
has been removed from the -mm tree.  Its filename was
     drivers-of-fdtc-re-use-kernels-kbasename.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: drivers/of/fdt.c: re-use kernel's kbasename()

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/of/fdt.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff -puN drivers/of/fdt.c~drivers-of-fdtc-re-use-kernels-kbasename drivers/of/fdt.c
--- a/drivers/of/fdt.c~drivers-of-fdtc-re-use-kernels-kbasename
+++ a/drivers/of/fdt.c
@@ -488,14 +488,8 @@ int __init of_scan_flat_dt(int (*it)(uns
 		depth++;
 		pathp = (char *)p;
 		p = ALIGN(p + strlen(pathp) + 1, 4);
-		if ((*pathp) == '/') {
-			const char *lp, *np;
-			for (lp = NULL, np = pathp; *np; np++)
-				if ((*np) == '/')
-					lp = np+1;
-			if (lp != NULL)
-				pathp = lp;
-		}
+		if (*pathp == '/')
+			pathp = kbasename(pathp);
 		rc = it(p, pathp, depth, data);
 		if (rc != 0)
 			break;
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

origin.patch
linux-next.patch

