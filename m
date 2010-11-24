From: akpm@linux-foundation.org
Subject: + media-fix-timblogiw-kconfig-build-error.patch added to -mm tree
Date: Wed, 24 Nov 2010 13:33:44 -0800
Message-ID: <201011242133.oAOLXijV005322@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35627 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753374Ab0KXVeX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Nov 2010 16:34:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, mchehab@infradead.org


The patch titled
     media: fix timblogiw kconfig & build error
has been added to the -mm tree.  Its filename is
     media-fix-timblogiw-kconfig-build-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
arch-x86-include-asm-fixmaph-mark-__set_fixmap_offset-as-__always_inline.patch
linux-next.patch
backlight-fix-88pm860x_bl-macro-collision.patch
ibm_rtl-fix-printk-format-warning.patch
media-fix-timblogiw-kconfig-build-error.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
w1-ds2423-counter-driver-and-documentation-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

