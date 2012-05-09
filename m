From: akpm@linux-foundation.org
Subject: + video-exynos-mipi-dsi-enable-interrupt-again-after-sw-reset.patch added to -mm tree
Date: Wed, 09 May 2012 13:40:38 -0700
Message-ID: <20120509204039.3E6D2A01E3@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:34299 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932272Ab2EIUkr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2012 16:40:47 -0400
Received: by bkty5 with SMTP id y5so37945bkt.1
        for <mm-commits@vger.kernel.org>; Wed, 09 May 2012 13:40:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dh09.lee@samsung.com, FlorianSchandinat@gmx.de, inki.dae@samsung.com, kyungmin.park@samsung.com, rpurdie@rpsys.net


The patch titled
     Subject: video: exynos mipi dsi: enable interrupt again after sw reset
has been added to the -mm tree.  Its filename is
     video-exynos-mipi-dsi-enable-interrupt-again-after-sw-reset.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: video: exynos mipi dsi: enable interrupt again after sw reset

Patches currently in -mm which might be from dh09.lee@samsung.com are

linux-next.patch
video-exynos-mipi-dsi-enable-interrupt-again-after-sw-reset.patch
video-exynos-mipi-dsi-do-not-use-deprecated-suspend-resume-callbacks.patch
video-exynos-mipi-dsi-avoid-races-in-probe.patch
video-exynos-mipi-dsi-properly-interpret-the-interrupt-source-flags.patch
video-exynos-mipi-dsi-support-reverse-panel-type.patch

