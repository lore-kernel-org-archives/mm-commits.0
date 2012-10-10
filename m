From: akpm@linux-foundation.org
Subject: [obsolete] drivers-thermal-rcar_thermalc-fix-compilation-errors.patch removed from -mm tree
Date: Wed, 10 Oct 2012 13:04:21 -0700
Message-ID: <20121010200422.1F44E1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:52351 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab2JJUEX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Oct 2012 16:04:23 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so111381ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 10 Oct 2012 13:04:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kuninori.morimoto.gx@renesas.com, develkernel412222@gmail.com, rui.zhang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/thermal/rcar_thermal.c: fix compilation errors
has been removed from the -mm tree.  Its filename was
     drivers-thermal-rcar_thermalc-fix-compilation-errors.patch

This patch was dropped because it is obsolete

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

