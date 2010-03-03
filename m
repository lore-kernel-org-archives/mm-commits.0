From: akpm@linux-foundation.org
Subject: [to-be-updated] olpc-alsa-fix-cs5535audios-mic-gpio-to-enable-input.patch removed from -mm tree
Date: Tue, 02 Mar 2010 16:00:23 -0800
Message-ID: <201003030000.o2300NCW005659@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48725 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755115Ab0CCAAo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Mar 2010 19:00:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@collabora.co.uk, gardner.ben@gmail.com, jayakumar.alsa@gmail.com, stable@kernel.org, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     OLPC: ALSA: fix cs5535audio's MIC GPIO to enable input
has been removed from the -mm tree.  Its filename was
     olpc-alsa-fix-cs5535audios-mic-gpio-to-enable-input.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: OLPC: ALSA: fix cs5535audio's MIC GPIO to enable input
From: Andres Salomon <dilinger@collabora.co.uk>

Previously the MIC GPIO was set to output mode, and when checking the
status after setting it we were checking OUTPUT_VAL.  This worked, though
I'm not quite sure why.  Instead, if we actually check the READ_BACK
value, it doesn't work unless the GPIO is in bidirectional mode.  Thus,
enable input mode as well.

Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
Cc: Ben Gardner <gardner.ben@gmail.com>
Cc: Jaya Kumar <jayakumar.alsa@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/cs5535audio/cs5535audio_olpc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN sound/pci/cs5535audio/cs5535audio_olpc.c~olpc-alsa-fix-cs5535audios-mic-gpio-to-enable-input sound/pci/cs5535audio/cs5535audio_olpc.c
--- a/sound/pci/cs5535audio/cs5535audio_olpc.c~olpc-alsa-fix-cs5535audios-mic-gpio-to-enable-input
+++ a/sound/pci/cs5535audio/cs5535audio_olpc.c
@@ -157,6 +157,7 @@ int __devinit olpc_quirks(struct snd_car
 		return -EIO;
 	}
 	gpio_direction_output(OLPC_GPIO_MIC_AC, 0);
+	gpio_direction_input(OLPC_GPIO_MIC_AC);
 
 	/* drop the original AD1888 HPF control */
 	memset(&elem, 0, sizeof(elem));
_

Patches currently in -mm which might be from dilinger@collabora.co.uk are

origin.patch
linux-next.patch
olpc-alsa-fix-cs5535audios-mic-gpio-to-enable-input.patch
cs5535-clockevt-free-timer-in-irq-setup-error-path.patch
mac80211-give-warning-if-building-w-out-rate-ctrl-algorithm.patch
mfgpt-move-clocksource-menu.patch
gpio-cs5535-gpio-fix-input-direction.patch
cs5535_gpio-gpio_chipget-should-return-the-input-value.patch

