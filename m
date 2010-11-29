From: akpm@linux-foundation.org
Subject: [merged] media-fix-timblogiw-kconfig-build-error.patch removed from -mm tree
Date: Mon, 29 Nov 2010 11:51:39 -0800
Message-ID: <201011291952.oATJq8Gd007365@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38641 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752701Ab0K2T4e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Nov 2010 14:56:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     media: fix timblogiw kconfig & build error
has been removed from the -mm tree.  Its filename was
     media-fix-timblogiw-kconfig-build-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: media: fix timblogiw kconfig & build error
From: Randy Dunlap <randy.dunlap@oracle.com>

timblogiw uses dma() interfaces and it selects TIMB_DMA for that support. 
However, drivers/dma/ is not built unless CONFIG_DMA_ENGINE is enabled, so
select/enable that symbol also.

drivers/built-in.o: In function `timblogiw_close':
timblogiw.c:(.text+0x4419fe): undefined reference to `dma_release_channel'
drivers/built-in.o: In function `buffer_release':
timblogiw.c:(.text+0x441a8d): undefined reference to `dma_sync_wait'
drivers/built-in.o: In function `timblogiw_open':
timblogiw.c:(.text+0x44212b): undefined reference to `__dma_request_channel'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/media/video/Kconfig~media-fix-timblogiw-kconfig-build-error drivers/media/video/Kconfig
--- a/drivers/media/video/Kconfig~media-fix-timblogiw-kconfig-build-error
+++ a/drivers/media/video/Kconfig
@@ -669,6 +669,7 @@ config VIDEO_HEXIUM_GEMINI
 config VIDEO_TIMBERDALE
 	tristate "Support for timberdale Video In/LogiWIN"
 	depends on VIDEO_V4L2 && I2C
+	select DMA_ENGINE
 	select TIMB_DMA
 	select VIDEO_ADV7180
 	select VIDEOBUF_DMA_CONTIG
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
backlight-fix-88pm860x_bl-macro-collision.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
w1-ds2423-counter-driver-and-documentation-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

