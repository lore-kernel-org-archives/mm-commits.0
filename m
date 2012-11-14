From: akpm@linux-foundation.org
Subject: + drivers-of-fdtc-re-use-kernels-kbasename-fix.patch added to -mm tree
Date: Wed, 14 Nov 2012 14:00:14 -0800
Message-ID: <20121114220015.44D38100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:42384 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423259Ab2KNWAQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Nov 2012 17:00:16 -0500
Received: by mail-ye0-f202.google.com with SMTP id r11so101601yen.1
        for <mm-commits@vger.kernel.org>; Wed, 14 Nov 2012 14:00:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: grant.likely@secretlab.ca, andriy.shevchenko@linux.intel.com, rob.herring@calxeda.com, sfr@canb.auug.org.au


The patch titled
     Subject: drivers-of-fdtc-re-use-kernels-kbasename-fix
has been added to the -mm tree.  Its filename is
     drivers-of-fdtc-re-use-kernels-kbasename-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Grant Likely <grant.likely@secretlab.ca>
Subject: drivers-of-fdtc-re-use-kernels-kbasename-fix

drivers/of/fdt.c: In function 'of_scan_flat_dt':
drivers/of/fdt.c:490:10: warning: assignment discards 'const' qualifier from pointer target type [enabled by default]

Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/of/fdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/of/fdt.c~drivers-of-fdtc-re-use-kernels-kbasename-fix drivers/of/fdt.c
--- a/drivers/of/fdt.c~drivers-of-fdtc-re-use-kernels-kbasename-fix
+++ a/drivers/of/fdt.c
@@ -460,7 +460,7 @@ int __init of_scan_flat_dt(int (*it)(uns
 
 	do {
 		u32 tag = be32_to_cpup((__be32 *)p);
-		char *pathp;
+		const char *pathp;
 
 		p += 4;
 		if (tag == OF_DT_END_NODE) {
_

Patches currently in -mm which might be from grant.likely@secretlab.ca are

linux-next.patch
drivers-of-fdtc-re-use-kernels-kbasename.patch
drivers-of-fdtc-re-use-kernels-kbasename-fix.patch
rtc-omap-kicker-mechanism-support.patch
arm-davinci-remove-rtc-kicker-release.patch
rtc-omap-dt-support.patch
rtc-omap-depend-on-am33xx.patch
rtc-omap-add-runtime-pm-support.patch
rtc-imxdi-support-for-imx53.patch
rtc-imxdi-add-devicetree-support.patch
arm-mach-imx-support-for-dryice-rtc-in-imx53.patch

