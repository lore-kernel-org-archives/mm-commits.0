From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-tps65217_blc-add-default-brightness-value-option.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:53:11 -0700
Message-ID: <20130430185311.743035A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:58074 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933128Ab3D3SxM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:53:12 -0400
Received: by mail-vb0-f74.google.com with SMTP id w8so86455vbf.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:53:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ujhelyi.m@gmail.com, grant.likely@secretlab.ca, matus.ujhelyi@streamunlimited.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/tps65217_bl.c add default brightness value option
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-tps65217_blc-add-default-brightness-value-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matus Ujhelyi <ujhelyi.m@gmail.com>
Subject: drivers/video/backlight/tps65217_bl.c add default brightness value option

Signed-off-by: Matus Ujhelyi <matus.ujhelyi@streamunlimited.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/video/backlight/tps65217-backlight.txt |    2 +
 drivers/video/backlight/tps65217_bl.c                                    |   15 +++++++++-
 include/linux/mfd/tps65217.h                                             |    1 
 3 files changed, 17 insertions(+), 1 deletion(-)

diff -puN Documentation/devicetree/bindings/video/backlight/tps65217-backlight.txt~drivers-video-backlight-tps65217_blc-add-default-brightness-value-option Documentation/devicetree/bindings/video/backlight/tps65217-backlight.txt
--- a/Documentation/devicetree/bindings/video/backlight/tps65217-backlight.txt~drivers-video-backlight-tps65217_blc-add-default-brightness-value-option
+++ a/Documentation/devicetree/bindings/video/backlight/tps65217-backlight.txt
@@ -9,6 +9,7 @@ Required properties:
 - backlight: node for specifying WLED1 and WLED2 lines in TPS65217
 - isel: selection bit, valid values: 1 for ISEL1 (low-level) and 2 for ISEL2 (high-level)
 - fdim: PWM dimming frequency, valid values: 100, 200, 500, 1000
+- default-brightness: valid values: 0-100
 
 Each regulator is defined using the standard binding for regulators.
 
@@ -20,6 +21,7 @@ Example:
 		backlight {
 			isel = <1>;  /* 1 - ISET1, 2 ISET2 */
 			fdim = <100>; /* TPS65217_BL_FDIM_100HZ */
+			default-brightness = <50>;
 		};
 	};
 
diff -puN drivers/video/backlight/tps65217_bl.c~drivers-video-backlight-tps65217_blc-add-default-brightness-value-option drivers/video/backlight/tps65217_bl.c
--- a/drivers/video/backlight/tps65217_bl.c~drivers-video-backlight-tps65217_blc-add-default-brightness-value-option
+++ a/drivers/video/backlight/tps65217_bl.c
@@ -245,6 +245,18 @@ tps65217_bl_parse_dt(struct platform_dev
 		}
 	}
 
+	if (!of_property_read_u32(node, "default-brightness", &val)) {
+		if (val < 0 ||
+			val > 100) {
+			dev_err(&pdev->dev,
+				"invalid 'default-brightness' value in the device tree\n");
+			err = ERR_PTR(-EINVAL);
+			goto err;
+		}
+
+		pdata->dft_brightness = val;
+	}
+
 	of_node_put(node);
 
 	return pdata;
@@ -311,7 +323,8 @@ static int tps65217_bl_probe(struct plat
 		return PTR_ERR(tps65217_bl->bl);
 	}
 
-	tps65217_bl->bl->props.brightness = 0;
+	tps65217_bl->bl->props.brightness = pdata->dft_brightness;
+	backlight_update_status(tps65217_bl->bl);
 	platform_set_drvdata(pdev, tps65217_bl);
 
 	return 0;
diff -puN include/linux/mfd/tps65217.h~drivers-video-backlight-tps65217_blc-add-default-brightness-value-option include/linux/mfd/tps65217.h
--- a/include/linux/mfd/tps65217.h~drivers-video-backlight-tps65217_blc-add-default-brightness-value-option
+++ a/include/linux/mfd/tps65217.h
@@ -228,6 +228,7 @@ enum tps65217_bl_fdim {
 struct tps65217_bl_pdata {
 	enum tps65217_bl_isel isel;
 	enum tps65217_bl_fdim fdim;
+	int dft_brightness;
 };
 
 /**
_

Patches currently in -mm which might be from ujhelyi.m@gmail.com are

origin.patch

