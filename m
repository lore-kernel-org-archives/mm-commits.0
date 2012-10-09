From: akpm@linux-foundation.org
Subject: + drivers-thermal-rcar_thermalc-fix-compilation-errors.patch added to -mm tree
Date: Tue, 09 Oct 2012 14:57:42 -0700
Message-ID: <20121009215743.18DCF5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:60986 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650Ab2JIV5q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 17:57:46 -0400
Received: by mail-lb0-f202.google.com with SMTP id l12so371303lbo.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 14:57:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kuninori.morimoto.gx@renesas.com, develkernel412222@gmail.com, rui.zhang@intel.com


The patch titled
     Subject: drivers/thermal/rcar_thermal.c: fix compilation errors
has been added to the -mm tree.  Its filename is
     drivers-thermal-rcar_thermalc-fix-compilation-errors.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: drivers/thermal/rcar_thermal.c: fix compilation errors

This patch fixup following error

${LINUX}/drivers/thermal/rcar_thermal.c: In function 'rcar_thermal_probe':
${LINUX}/drivers/thermal/rcar_thermal.c:214:9: warning: passing argument 3 \
	of 'thermal_zone_device_register' makes integer from pointer without\
	a cast [enabled by default]
${LINUX}/include/linux/thermal.h:215:29: note: expected 'int' but argument \
	is of type 'struct rcar_thermal_priv *'
${LINUX}/drivers/thermal/rcar_thermal.c:214:9:\
	error: too few arguments to function 'thermal_zone_device_register'

Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/thermal/rcar_thermal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/thermal/rcar_thermal.c~drivers-thermal-rcar_thermalc-fix-compilation-errors drivers/thermal/rcar_thermal.c
--- a/drivers/thermal/rcar_thermal.c~drivers-thermal-rcar_thermalc-fix-compilation-errors
+++ a/drivers/thermal/rcar_thermal.c
@@ -210,7 +210,7 @@ static int rcar_thermal_probe(struct pla
 		goto error_free_priv;
 	}
 
-	zone = thermal_zone_device_register("rcar_thermal", 0, priv,
+	zone = thermal_zone_device_register("rcar_thermal", 0, 0, priv,
 				    &rcar_thermal_zone_ops, NULL, 0, 0);
 	if (IS_ERR(zone)) {
 		dev_err(&pdev->dev, "thermal zone device is NULL\n");
_

Patches currently in -mm which might be from kuninori.morimoto.gx@renesas.com are

origin.patch
linux-next.patch
drivers-thermal-rcar_thermalc-fix-compilation-errors.patch

