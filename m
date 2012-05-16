From: akpm@linux-foundation.org
Subject: [merged] video-exynos-mipi-dsi-support-reverse-panel-type.patch removed from -mm tree
Date: Wed, 16 May 2012 11:47:13 -0700
Message-ID: <20120516184713.4E164A028F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:52447 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760378Ab2EPSrO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 May 2012 14:47:14 -0400
Received: by mail-yx0-f202.google.com with SMTP id l3so125569yen.1
        for <mm-commits@vger.kernel.org>; Wed, 16 May 2012 11:47:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dh09.lee@samsung.com, FlorianSchandinat@gmx.de, inki.dae@samsung.com, kyungmin.park@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: video: exynos mipi dsi: support reverse panel type
has been removed from the -mm tree.  Its filename was
     video-exynos-mipi-dsi-support-reverse-panel-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Donghwa Lee <dh09.lee@samsung.com>
Subject: video: exynos mipi dsi: support reverse panel type

Add panel_reverse variable to support reversed s6e8ax0 panel type.

Signed-off-by: Donghwa Lee <dh09.lee@samsung.com>
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/exynos/s6e8ax0.c   |   15 +++++++++++++--
 include/video/exynos_mipi_dsim.h |    1 +
 2 files changed, 14 insertions(+), 2 deletions(-)

diff -puN drivers/video/exynos/s6e8ax0.c~video-exynos-mipi-dsi-support-reverse-panel-type drivers/video/exynos/s6e8ax0.c
--- a/drivers/video/exynos/s6e8ax0.c~video-exynos-mipi-dsi-support-reverse-panel-type
+++ a/drivers/video/exynos/s6e8ax0.c
@@ -293,9 +293,20 @@ static void s6e8ax0_panel_cond(struct s6
 		0x6e, 0x00, 0x00, 0x00, 0x02, 0x08, 0x08, 0x23, 0x23, 0xc0,
 		0xc8, 0x08, 0x48, 0xc1, 0x00, 0xc1, 0xff, 0xff, 0xc8
 	};
+	static const unsigned char data_to_send_panel_reverse[] = {
+		0xf8, 0x19, 0x35, 0x00, 0x00, 0x00, 0x93, 0x00, 0x3c, 0x7d,
+		0x08, 0x27, 0x7d, 0x3f, 0x00, 0x00, 0x00, 0x20, 0x04, 0x08,
+		0x6e, 0x00, 0x00, 0x00, 0x02, 0x08, 0x08, 0x23, 0x23, 0xc0,
+		0xc1, 0x01, 0x41, 0xc1, 0x00, 0xc1, 0xf6, 0xf6, 0xc1
+	};
 
-	ops->cmd_write(lcd_to_master(lcd), MIPI_DSI_DCS_LONG_WRITE,
-		data_to_send, ARRAY_SIZE(data_to_send));
+	if (lcd->dsim_dev->panel_reverse)
+		ops->cmd_write(lcd_to_master(lcd), MIPI_DSI_DCS_LONG_WRITE,
+				data_to_send_panel_reverse,
+				ARRAY_SIZE(data_to_send_panel_reverse));
+	else
+		ops->cmd_write(lcd_to_master(lcd), MIPI_DSI_DCS_LONG_WRITE,
+				data_to_send, ARRAY_SIZE(data_to_send));
 }
 
 static void s6e8ax0_display_cond(struct s6e8ax0 *lcd)
diff -puN include/video/exynos_mipi_dsim.h~video-exynos-mipi-dsi-support-reverse-panel-type include/video/exynos_mipi_dsim.h
--- a/include/video/exynos_mipi_dsim.h~video-exynos-mipi-dsi-support-reverse-panel-type
+++ a/include/video/exynos_mipi_dsim.h
@@ -315,6 +315,7 @@ struct mipi_dsim_lcd_device {
 	int			id;
 	int			bus_id;
 	int			irq;
+	int			panel_reverse;
 
 	struct mipi_dsim_device *master;
 	void			*platform_data;
_

Patches currently in -mm which might be from dh09.lee@samsung.com are

linux-next.patch

