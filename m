From: akpm@linux-foundation.org
Subject: [merged] video-s3c-fb-use-arch_-dependancy.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:38:31 -0800
Message-ID: <20130222203831.A8E0331C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:52987 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757125Ab3BVUic (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:38:32 -0500
Received: by mail-gg0-f201.google.com with SMTP id l2so103693ggn.2
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:38:32 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, FlorianSchandinat@gmx.de, kyungmin.park@samsung.com, t.figa@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: video: s3c-fb: use ARCH_ dependancy
has been removed from the -mm tree.  Its filename was
     video-s3c-fb-use-arch_-dependancy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: video: s3c-fb: use ARCH_ dependancy

Use ARCH_ dependancy when using s3c-fb.  S3C_DEV_FB, S5P_DEV_FIMD0 cannot
be enabled on EXYNOS5.  So, ARCH_ should be used as dependancy for s3c-fb.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/video/Kconfig~video-s3c-fb-use-arch_-dependancy drivers/video/Kconfig
--- a/drivers/video/Kconfig~video-s3c-fb-use-arch_-dependancy
+++ a/drivers/video/Kconfig
@@ -2025,7 +2025,8 @@ config FB_TMIO_ACCELL
 
 config FB_S3C
 	tristate "Samsung S3C framebuffer support"
-	depends on FB && (S3C_DEV_FB || S5P_DEV_FIMD0)
+	depends on FB && (CPU_S3C2416 || ARCH_S3C64XX || ARCH_S5P64X0 || \
+		ARCH_S5PC100 || ARCH_S5PV210 || ARCH_EXYNOS)
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

