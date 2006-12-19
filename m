From: akpm@osdl.org
Subject: + alsa-kill-pxa2xx-kconfig-warning.patch added to -mm tree
Date: Mon, 18 Dec 2006 16:46:24 -0800
Message-ID: <200612190046.kBJ0kOgJ018530@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:36416 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932539AbWLSAqg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Dec 2006 19:46:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: deweerdt@free.fr, frederik.deweerdt@gmail.com, perex@suse.cz, tiwai@suse.de


The patch titled
     alsa: kill pxa2xx Kconfig warning
has been added to the -mm tree.  Its filename is
     alsa-kill-pxa2xx-kconfig-warning.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: alsa: kill pxa2xx Kconfig warning
From: Frederik Deweerdt <deweerdt@free.fr>

The following patch silences the following Kconfig warning:
scripts/kconfig/conf -s arch/i386/Kconfig
sound/soc/pxa/Kconfig:18:warning: 'select' used by config symbol 'SND_PXA2XX_SOC_AC97' refer to undefined symbol 'SND_AC97_BUS'

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 sound/soc/pxa/Kconfig |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN sound/soc/pxa/Kconfig~alsa-kill-pxa2xx-kconfig-warning sound/soc/pxa/Kconfig
--- a/sound/soc/pxa/Kconfig~alsa-kill-pxa2xx-kconfig-warning
+++ a/sound/soc/pxa/Kconfig
@@ -15,7 +15,7 @@ config SND_PXA2XX_AC97
 
 config SND_PXA2XX_SOC_AC97
 	tristate
-	select SND_AC97_BUS
+	select AC97_BUS
 	select SND_SOC_AC97_BUS
 
 config SND_PXA2XX_SOC_I2S
_

Patches currently in -mm which might be from deweerdt@free.fr are

alsa-kill-pxa2xx-kconfig-warning.patch
disable-init-initramfsc-updated-fix.patch

