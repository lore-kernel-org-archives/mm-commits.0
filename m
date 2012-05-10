From: akpm@linux-foundation.org
Subject: [merged] video-exynos-mipi-dsi-enable-interrupt-again-after-sw-reset.patch removed from -mm tree
Date: Thu, 10 May 2012 13:47:36 -0700
Message-ID: <20120510204736.7BF11A03DB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:60961 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526Ab2EJUrh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 May 2012 16:47:37 -0400
Received: by yhgm50 with SMTP id m50so301021yhg.1
        for <mm-commits@vger.kernel.org>; Thu, 10 May 2012 13:47:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dh09.lee@samsung.com, FlorianSchandinat@gmx.de, inki.dae@samsung.com, kyungmin.park@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: video: exynos mipi dsi: enable interrupt again after sw reset
has been removed from the -mm tree.  Its filename was
     video-exynos-mipi-dsi-enable-interrupt-again-after-sw-reset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Donghwa Lee <dh09.lee@samsung.com>
Subject: video: exynos mipi dsi: enable interrupt again after sw reset

When exynos_mipi_update_cfg() is called, mipi dsi registers were become
sw reset. So, It needs to enable interrupt again.

Signed-off-by: Donghwa Lee <dh09.lee@samsung.com>
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/exynos/exynos_mipi_dsi.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/video/exynos/exynos_mipi_dsi.c~video-exynos-mipi-dsi-enable-interrupt-again-after-sw-reset drivers/video/exynos/exynos_mipi_dsi.c
--- a/drivers/video/exynos/exynos_mipi_dsi.c~video-exynos-mipi-dsi-enable-interrupt-again-after-sw-reset
+++ a/drivers/video/exynos/exynos_mipi_dsi.c
@@ -102,6 +102,8 @@ static void exynos_mipi_update_cfg(struc
 	/* set display timing. */
 	exynos_mipi_dsi_set_display_mode(dsim, dsim->dsim_config);
 
+	exynos_mipi_dsi_init_interrupt(dsim);
+
 	/*
 	 * data from Display controller(FIMD) is transferred in video mode
 	 * but in case of command mode, all settigs is updated to registers.
_

Patches currently in -mm which might be from dh09.lee@samsung.com are

linux-next.patch
video-exynos-mipi-dsi-do-not-use-deprecated-suspend-resume-callbacks.patch
video-exynos-mipi-dsi-avoid-races-in-probe.patch
video-exynos-mipi-dsi-properly-interpret-the-interrupt-source-flags.patch
video-exynos-mipi-dsi-support-reverse-panel-type.patch

