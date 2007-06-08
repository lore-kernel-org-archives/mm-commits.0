From: akpm@linux-foundation.org
Subject: + make-snd_soc_pcm_sh7760-depend-on-sh_dmabrg-rather-than-selecting-it.patch added to -mm tree
Date: Thu, 07 Jun 2007 22:17:05 -0700
Message-ID: <200706080517.l585H5lP019630@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50896 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754778AbXFHFSJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 01:18:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mano@roarinelk.homelinux.net, lethal@linux-sh.org, perex@suse.cz, tiwai@suse.de


The patch titled
     Make SND_SOC_PCM_SH7760 depend on SH_DMABRG rather than selecting it
has been added to the -mm tree.  Its filename is
     make-snd_soc_pcm_sh7760-depend-on-sh_dmabrg-rather-than-selecting-it.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
make-snd_soc_pcm_sh7760-depend-on-sh_dmabrg-rather-than-selecting-it.patch
