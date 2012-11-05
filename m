From: akpm@linux-foundation.org
Subject: + drivers-of-fdtc-re-use-kernels-kbasename.patch added to -mm tree
Date: Mon, 05 Nov 2012 12:20:16 -0800
Message-ID: <20121105202016.E470420004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:50608 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab2KEUUU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2012 15:20:20 -0500
Received: by mail-fa0-f74.google.com with SMTP id t1so401399fae.1
        for <mm-commits@vger.kernel.org>; Mon, 05 Nov 2012 12:20:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andriy.shevchenko@linux.intel.com, grant.likely@secretlab.ca, rob.herring@calxeda.com


The patch titled
     Subject: drivers/of/fdt.c: re-use kernel's kbasename()
has been added to the -mm tree.  Its filename is
     drivers-of-fdtc-re-use-kernels-kbasename.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: drivers/of/fdt.c: re-use kernel's kbasename()

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/of/fdt.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff -puN drivers/of/fdt.c~drivers-of-fdtc-re-use-kernels-kbasename drivers/of/fdt.c
--- a/drivers/of/fdt.c~drivers-of-fdtc-re-use-kernels-kbasename
+++ a/drivers/of/fdt.c
@@ -486,14 +486,8 @@ int __init of_scan_flat_dt(int (*it)(uns
 		depth++;
 		pathp = (char *)p;
 		p = ALIGN(p + strlen(pathp) + 1, 4);
-		if ((*pathp) == '/') {
-			char *lp, *np;
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

linux-next.patch
string-introduce-helper-to-get-base-file-name-from-given-path.patch
lib-dynamic_debug-use-kbasename.patch
mm-use-kbasename.patch
procfs-use-kbasename.patch
procfs-use-kbasename-fix.patch
trace-use-kbasename.patch
drivers-of-fdtc-re-use-kernels-kbasename.patch

