From: akpm@linux-foundation.org
Subject: - make-snd_soc_pcm_sh7760-depend-on-sh_dmabrg-rather-than-selecting-it.patch removed from -mm tree
Date: Fri, 08 Jun 2007 10:35:48 -0700
Message-ID: <200706081735.l58HZmcX006394@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57615 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937265AbXFHRpn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 13:45:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mano@roarinelk.homelinux.net, lethal@linux-sh.org, perex@suse.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     Make SND_SOC_PCM_SH7760 depend on SH_DMABRG rather than selecting it
has been removed from the -mm tree.  Its filename was
     make-snd_soc_pcm_sh7760-depend-on-sh_dmabrg-rather-than-selecting-it.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Make SND_SOC_PCM_SH7760 depend on SH_DMABRG rather than selecting it
From: Manuel Lauss <mano@roarinelk.homelinux.net>

Fixes Kconfig warning about undefined SH_DMABRG symbol on non-sh builds.

Signed-off-by: Manuel Lauss <mano@roarinelk.homelinux.net>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/soc/sh/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN sound/soc/sh/Kconfig~make-snd_soc_pcm_sh7760-depend-on-sh_dmabrg-rather-than-selecting-it sound/soc/sh/Kconfig
--- a/sound/soc/sh/Kconfig~make-snd_soc_pcm_sh7760-depend-on-sh_dmabrg-rather-than-selecting-it
+++ a/sound/soc/sh/Kconfig
@@ -2,8 +2,7 @@ menu "SoC Audio support for SuperH"
 
 config SND_SOC_PCM_SH7760
 	tristate "SoC Audio support for Renesas SH7760"
-	depends on CPU_SUBTYPE_SH7760 && SND_SOC
-	select SH_DMABRG
+	depends on CPU_SUBTYPE_SH7760 && SND_SOC && SH_DMABRG
 	help
 	  Enable this option for SH7760 AC97/I2S audio support.
 
_

Patches currently in -mm which might be from mano@roarinelk.homelinux.net are

git-alsa.patch
